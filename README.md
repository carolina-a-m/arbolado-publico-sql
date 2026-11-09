# Gestión de Arbolado Público: base de datos relacional en SQL Server

Diseño e implementación de una base de datos relacional para gestionar el arbolado público de la ciudad de Rosario: inventario de árboles, cuadrillas de mantenimiento, tareas planificadas y realizadas, y reclamos de vecinos con seguimiento de su estado y de los tiempos de respuesta.

> Trabajo Práctico Final de **Bases de Datos I** (Tecnicatura Universitaria en Inteligencia Artificial, FCEIA, UNR, 2025). Proyecto grupal.

---

## Qué problema resuelve

La base permite responder preguntas operativas como:

- ¿Qué cuadrilla realizó más tareas en un mes determinado?
- ¿Qué motivos de reclamo se acumulan sin ser atendidos?
- ¿Cuánto tarda en asignarse y en resolverse un reclamo?
- ¿Qué árboles nunca recibieron un reclamo?
- ¿Cuáles son los árboles más altos de cada especie?
- ¿Cuándo es la próxima tarea pendiente de un tipo dado sobre un árbol, y cuántas tareas pendientes hay?

## Tecnologías

- **SQL Server** (T-SQL)
- Vistas, procedimientos almacenados con parámetros de salida, CTEs y funciones de ventana
- Se recomienda **SQL Server Management Studio** o **Azure Data Studio** para ejecutar los scripts

---

## Modelo de datos

El diagrama entidad-relación está en el [informe técnico del proyecto](https://docs.google.com/document/d/1t99e265wDqVSlcxn1XCl3Lm0Twvq-j2UipD8omsPfys/edit?tab=t.0). Es el DER de diseño original, y la implementación final en SQL difiere de él en algunos puntos. **Ante cualquier diferencia, el esquema SQL es la versión vigente.**

Diferencias entre el DER y el esquema implementado:

- **`RECLAMO_TAREA` referencia a `TAREA_ARBOL`**, no a `TAREA`: usa la clave `ID_Tarea_Arbol` para vincular cada reclamo con la combinación exacta tarea–árbol (ver decisiones de diseño).
- **`RECLAMO_TAREA` incluye `Fecha_asignacion`**, necesaria para calcular los tiempos de respuesta.
- **`EMPLEADO` no tiene `ID_Cuadrilla`**: la pertenencia a cuadrillas es una relación muchos a muchos que vive solo en `CUADRILLA_EMPLEADO`.
- **`MOTIVO_RECLAMO.Descripcion` es `VARCHAR(80)`** en el esquema.
- Las restricciones `UNIQUE` (código de cuadrilla, CUIL, tipo de tarea, estado de salud, especie, una medición por árbol y fecha) están definidas en el script SQL y no todas figuran en el diagrama.

| Tabla | Rol |
|---|---|
| `CUADRILLA`, `EMPLEADO` | Equipos de trabajo y personal |
| `CUADRILLA_EMPLEADO` | Relación M:N: un empleado puede estar en varias cuadrillas |
| `TIPO_TAREA` | Catálogo de tareas (plantado, poda, remoción, inspección, tratamiento fitosanitario) |
| `ESPECIE`, `SALUD`, `UBICACION` | Tablas auxiliares que caracterizan a cada árbol |
| `ARBOL` | Inventario: código único, especie, salud, ubicación y fecha de plantado (opcional) |
| `MEDICION_ALTURA` | Historial de alturas de cada árbol, una medición por árbol y fecha |
| `TAREA` | Tarea planificada y realizada por una cuadrilla, con comentario final |
| `TAREA_ARBOL` | Relación M:N: una tarea puede abarcar varios árboles y un árbol recibir varias tareas |
| `MOTIVO_RECLAMO`, `RECLAMO` | Reclamos de vecinos sobre un árbol, con motivo normalizado |
| `RECLAMO_TAREA` | Vincula cada reclamo con la combinación exacta tarea–árbol que lo atiende |

> Nota: en `UBICACION`, `Altura` es la **numeración de la calle** (queda en `NULL` para parques y plazas). No debe confundirse con la altura del árbol, que se aloja en `MEDICION_ALTURA`.

---

## Decisiones de diseño

**1. Tercera forma normal y claves subrogadas.** Todas las tablas están en 3FN. Cada una tiene una clave primaria autoincremental y los identificadores de negocio (código de árbol, CUIL, código de cuadrilla) se mantienen como atributos con restricción `UNIQUE`. Así, si un identificador natural cambia, la clave de la tabla sigue siendo estable.

**2. Relaciones muchos a muchos con tablas intermedias.** Se modelaron explícitamente `CUADRILLA_EMPLEADO`, `TAREA_ARBOL` y `RECLAMO_TAREA`. Un mismo árbol puede intervenirse varias veces a lo largo del tiempo, una tarea puede abarcar varios árboles y varios reclamos pueden resolverse con una misma tarea.

**3. El estado de un reclamo se calcula, no se guarda.** En lugar de crear una tabla de estados o un historial, el estado (`No asignado`, `En proceso`, `Finalizado`) se deriva de la relación entre `RECLAMO`, `RECLAMO_TAREA` y `TAREA`. Almacenarlo duplicaría información y obligaría a mantenerla sincronizada con triggers o actualizaciones manuales. La vista `Vista_Reclamos_Info` expone ese cálculo:

- sin filas en `RECLAMO_TAREA` → **No asignado**
- con tareas asignadas y alguna sin realizar → **En proceso**
- todas las tareas asignadas realizadas → **Finalizado**

**4. Una corrección importante durante las pruebas.** En una primera versión, `RECLAMO_TAREA` apuntaba directamente a `TAREA`. Al probar las consultas aparecieron reclamos "finalizados" aunque quedaban tareas incompletas sobre el mismo árbol: como una tarea puede involucrar varios árboles, no se podía garantizar que el reclamo estuviera asociado al árbol que lo motivó. La solución fue hacer que `RECLAMO_TAREA` referencie a `TAREA_ARBOL` (clave `ID_Tarea_Arbol`), con una restricción `UNIQUE (ID_Reclamo, ID_Tarea_Arbol)`. Con eso, los días hasta asignación y resolución y el estado del reclamo reflejan la situación real de cada árbol.

**5. Integridad referencial.** Claves foráneas definidas en todas las relaciones, restricciones `UNIQUE` sobre los datos críticos y `ON DELETE CASCADE` en las relaciones donde borrar al padre debe arrastrar a los dependientes (árbol, tarea, reclamo, cuadrilla, empleado). Solo son opcionales (`NULL`) la fecha de plantado, la numeración de la calle, el teléfono, la fecha de realización de una tarea y el comentario final; el resto es `NOT NULL`.

---

## Vistas y procedimientos

| Objeto | Qué hace |
|---|---|
| `Vista_Reclamos_Info` | Por reclamo: código de árbol, fecha del reclamo, primera asignación, última resolución, días hasta asignación, días hasta resolución y estado. Si todavía no hubo asignación o resolución, los días se calculan contra la fecha actual. |
| `vista_resumen_tareas` | Por tipo de tarea: fecha de la primera y de la última realizada y cantidad de tareas realizadas. |
| `sp_BuscarTareasPendientes` | Recibe un árbol y un tipo de tarea. Devuelve por parámetro de salida la fecha de la próxima tarea pendiente y, como valor de retorno, la cantidad de tareas pendientes. |

Ejemplo de uso del procedimiento:

```sql
DECLARE @Fecha DATE;
DECLARE @Cantidad INT;

EXEC @Cantidad = sp_BuscarTareasPendientes
        @idArbol = 10,
        @idTipoTarea = 4,
        @ProximaFecha = @Fecha OUTPUT;

SELECT @Fecha AS ProximaFecha, @Cantidad AS CantidadPendientes;
```

---

## Consultas incluidas

| Consigna | Técnicas |
|---|---|
| Cuadrilla que más tareas realizó en octubre de 2025 | `JOIN`, `GROUP BY`, `TOP 1`, filtro por rango de fechas |
| Motivos con más de 3 reclamos sin asignar | `LEFT JOIN` + `IS NULL` (anti-join), `HAVING` |
| Árboles (código, especie, ubicación) sin ningún reclamo | `LEFT JOIN` + `IS NULL`, `CASE` para armar la dirección |
| Los 3 árboles más altos de cada especie | CTE, `ROW_NUMBER() OVER (PARTITION BY ...)` |
| Consultas sobre las vistas y el procedimiento | Filtros por estado, agregaciones y parámetros de salida |

Fragmento de la consulta de los tres árboles más altos por especie:

```sql
WITH MaxAlturaPorArbol AS (
    SELECT A.ID_Arbol, A.Codigo, A.ID_Especie, MAX(M.Altura) AS AlturaMax
    FROM ARBOL A
    INNER JOIN MEDICION_ALTURA M ON A.ID_Arbol = M.ID_Arbol
    GROUP BY A.ID_Arbol, A.Codigo, A.ID_Especie
)
SELECT aux.Codigo, E.Nombre_comun AS Especie, aux.AlturaMax AS Altura
FROM (
    SELECT MA.Codigo, MA.ID_Especie, MA.AlturaMax,
           ROW_NUMBER() OVER (PARTITION BY MA.ID_Especie ORDER BY MA.AlturaMax DESC) AS rn
    FROM MaxAlturaPorArbol MA
) AS aux
INNER JOIN ESPECIE E ON aux.ID_Especie = E.ID_Especie
WHERE aux.rn <= 3
ORDER BY Especie, Altura DESC;
```

---

## Cómo ejecutarlo

1. Abrí SQL Server Management Studio o Azure Data Studio y conectate a tu instancia.
2. Ejecutá los scripts **en este orden**:
   1. `01_esquema.sql`: crea la base `TP_BBDD1_2025_19`, las tablas, las vistas y el procedimiento
   2. `02_datos.sql`: carga los datos de prueba
   3. `03_consultas.sql`: consultas y ejemplos de ejecución de vistas y procedimiento

Los scripts usan `GO` como separador de lotes, así que conviene correrlos desde una herramienta que lo soporte. Las vistas y el procedimiento deben crearse **después** de las tablas, tal como está ordenado en el script.

## Datos de prueba

Datos ficticios para poder probar todas las consultas: 3 cuadrillas, 10 empleados, 5 especies, 10 ubicaciones, 50 árboles, 19 tareas, 24 reclamos y mediciones de altura para parte del inventario.

## Estructura del repositorio

```
.
├── README.md
├── 01_esquema.sql
├── 02_datos.sql
└── 03_consultas.sql
```
