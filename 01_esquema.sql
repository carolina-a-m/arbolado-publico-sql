CREATE DATABASE TP_BBDD1_2025_19;
GO
USE TP_BBDD1_2025_19;
GO

CREATE TABLE CUADRILLA (
    id_cuadrilla INT IDENTITY(1,1) NOT NULL,
    codigo_cuadrilla VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Cuadrilla PRIMARY KEY (id_cuadrilla),
    CONSTRAINT UK_Cuadrilla_Codigo UNIQUE (codigo_cuadrilla)
);

CREATE TABLE EMPLEADO (
    id_empleado INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    cuil VARCHAR(20) NOT NULL,
    telefono VARCHAR(30) NULL,
    fecha_ingreso DATE NOT NULL,
    CONSTRAINT PK_Empleado PRIMARY KEY (id_empleado),
    CONSTRAINT UK_Empleado_CUIL UNIQUE (cuil)
);

CREATE TABLE TIPO_TAREA (
    ID_Tipo_tarea INT IDENTITY(1,1) NOT NULL,
    TIPO varchar(100) NOT NULL,
    CONSTRAINT PK_TipoTarea PRIMARY KEY (ID_Tipo_tarea),
    CONSTRAINT UQ_TipoTarea_Tipo UNIQUE (TIPO)
);

CREATE TABLE ESPECIE (
    ID_Especie INT IDENTITY(1,1) NOT NULL,
    Nombre_comun VARCHAR(100) NOT NULL,
    Nombre_científico VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Especie PRIMARY KEY (ID_Especie),
    CONSTRAINT UQ_Especie_Nombre UNIQUE (Nombre_comun, Nombre_científico)
);

CREATE TABLE SALUD (
    id_salud INT IDENTITY(1,1) NOT NULL,
    estado_salud VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Salud PRIMARY KEY (id_salud),
    CONSTRAINT UK_Salud_Estado UNIQUE (estado_salud)
);

CREATE TABLE UBICACION (
    ID_Ubicacion INT IDENTITY(1,1) NOT NULL,
    Ubicacion_nombre varchar(100) NOT NULL, -- puede ser nombre de calle, plaza o parque
	Altura int null, -- si ubicación nombre es parque sarmiendo altura será null
    lat DECIMAL(10,7) NOT NULL, -- latitud
    lon DECIMAL(10,7) NOT NULL, -- longitud
	Ubicacion_tipo VARCHAR(20) NOT NULL, -- e.g. vereda, parque
    CONSTRAINT PK_Ubicacion PRIMARY KEY (ID_Ubicacion)
);

CREATE TABLE MOTIVO_RECLAMO (
    ID_Motivo_reclamo INT IDENTITY(1,1) NOT NULL,
	Descripcion VARCHAR(80) NOT NULL,
    CONSTRAINT PK_MotivoReclamo PRIMARY KEY (ID_Motivo_reclamo),
    CONSTRAINT UK_MotivoReclamo_Descripcion UNIQUE (Descripcion)
);
       
CREATE TABLE ARBOL (
    ID_Arbol INT IDENTITY(1,1) NOT NULL,
    Codigo VARCHAR(10) NOT NULL, -- único
    Fecha_plantado DATE NULL,
    ID_Especie INT NOT NULL,   -- FK hacia ESPECIE
    ID_Salud INT NOT NULL,     -- FK hacia SALUD
    ID_Ubicacion INT NOT NULL, -- FK hacia UBICACION
    CONSTRAINT UK_Codigo UNIQUE (Codigo),
    CONSTRAINT PK_Arbol PRIMARY KEY (ID_Arbol),
    CONSTRAINT FK_Arbol_Especie FOREIGN KEY (ID_Especie) REFERENCES ESPECIE(ID_Especie),
    CONSTRAINT FK_Arbol_Salud FOREIGN KEY (ID_Salud) REFERENCES SALUD(ID_Salud),
    CONSTRAINT FK_Arbol_Ubicacion FOREIGN KEY (ID_Ubicacion) REFERENCES UBICACION(ID_Ubicacion)
);

CREATE TABLE CUADRILLA_EMPLEADO ( 
    id_cuadrilla INT NOT NULL, -- pero como un mismo empleado puede estar en más de una cuadrilla se crea la entidad | M : N
    id_empleado INT NOT NULL,
    CONSTRAINT PK_CuadrillaEmpleado PRIMARY KEY (id_cuadrilla, id_empleado),
    CONSTRAINT FK_CuadrillaEmpleado_Cuadrilla FOREIGN KEY (id_cuadrilla) REFERENCES CUADRILLA(id_cuadrilla) ON DELETE CASCADE,
    CONSTRAINT FK_CuadrillaEmpleado_Empleado FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado) ON DELETE CASCADE
);

CREATE TABLE MEDICION_ALTURA (     
    ID_Medicion INT IDENTITY(1,1) NOT NULL,
    ID_Arbol INT NOT NULL,
    Altura DECIMAL(5,2) NOT NULL,      -- en metros
    Fecha_Medicion DATE NOT NULL,      -- fecha de esa altura
    CONSTRAINT PK_MedicionAltura PRIMARY KEY (ID_Medicion),
    CONSTRAINT FK_MedicionAltura_Arbol FOREIGN KEY (ID_Arbol) REFERENCES ARBOL(ID_Arbol) ON DELETE CASCADE,
    CONSTRAINT UQ_MedicionArbol_Fecha UNIQUE (ID_Arbol, Fecha_Medicion)
);

CREATE TABLE TAREA (
    ID_Tarea INT IDENTITY(1,1) NOT NULL,
    Fecha_planificado date NOT NULL,
    Fecha_realizada date NULL,
    Comentario_final varchar(200)  NULL,
    ID_Cuadrilla int  NOT NULL,  --FK
    ID_Tipo_tarea int  NOT NULL, --FK
    CONSTRAINT PK_Tarea PRIMARY KEY (ID_Tarea),
    CONSTRAINT FK_Tarea_Cuadrilla FOREIGN KEY (ID_Cuadrilla) REFERENCES CUADRILLA(ID_Cuadrilla),
    CONSTRAINT FK_Tarea_Tipo FOREIGN KEY (ID_Tipo_tarea) REFERENCES TIPO_TAREA(ID_Tipo_tarea)
);

CREATE TABLE TAREA_ARBOL (
    ID_Tarea_arbol INT IDENTITY(1,1) NOT NULL,
    ID_Tarea INT NOT NULL, -- FK hacia TAREA
    ID_Arbol INT NOT NULL, -- FK hacia ARBOL
    CONSTRAINT PK_TareaArbol PRIMARY KEY (ID_Tarea_arbol),
    CONSTRAINT FK_TareaArbol_Tarea FOREIGN KEY (ID_Tarea) REFERENCES TAREA(ID_Tarea) ON DELETE CASCADE,
    CONSTRAINT FK_TareaArbol_Arbol FOREIGN KEY (ID_Arbol) REFERENCES ARBOL(ID_Arbol) ON DELETE CASCADE,
    CONSTRAINT UQ_TareaArbol UNIQUE (ID_Tarea, ID_Arbol)
);

CREATE TABLE RECLAMO (
    ID_Reclamo INT IDENTITY(1,1) NOT NULL,
    ID_Arbol INT NOT NULL,
    ID_Motivo_reclamo INT NOT NULL,
    email_denunciante VARCHAR(100) NOT NULL,
    Fecha_reclamo DATE NOT NULL,
    CONSTRAINT PK_Reclamo PRIMARY KEY (ID_Reclamo),
    CONSTRAINT FK_Reclamo_Arbol FOREIGN KEY (ID_Arbol) REFERENCES ARBOL(ID_Arbol),
    CONSTRAINT FK_Reclamo_Motivo FOREIGN KEY (ID_Motivo_reclamo) REFERENCES MOTIVO_RECLAMO(ID_Motivo_reclamo),
);

CREATE TABLE RECLAMO_TAREA (
    ID_Reclamo_tarea INT IDENTITY(1,1) NOT NULL,
    ID_Reclamo INT NOT NULL,           -- FK hacia RECLAMO
    ID_Tarea_Arbol INT NOT NULL,       -- FK hacia TAREA_ARBOL
    Fecha_asignacion DATE,
    CONSTRAINT PK_ReclamoTarea PRIMARY KEY (ID_Reclamo_tarea),
    CONSTRAINT FK_ReclamoTarea_Reclamo 
        FOREIGN KEY (ID_Reclamo) 
        REFERENCES RECLAMO(ID_Reclamo) 
        ON DELETE CASCADE,
    -- FK hacia TAREA_ARBOL, garantiza coherencia con el árbol y tarea
    CONSTRAINT FK_ReclamoTarea_TareaArbol
        FOREIGN KEY (ID_Tarea_Arbol)
        REFERENCES TAREA_ARBOL(ID_Tarea_arbol)
        ON DELETE CASCADE,
    -- Un mismo reclamo no puede asignarse dos veces a la misma tarea–árbol
    CONSTRAINT UQ_ReclamoTarea UNIQUE (ID_Reclamo, ID_Tarea_Arbol)
);

GO
CREATE VIEW vista_resumen_tareas AS
SELECT 
    tt.TIPO,                                 -- Nombre del tipo de tarea
    MIN(t.Fecha_realizada) AS fecha_primera, -- Primera tarea realizada
    MAX(t.Fecha_realizada) AS fecha_ultima,  -- Última tarea realizada
    COUNT(*) AS cantidad_realizadas          -- Cantidad de tareas realizadas
FROM TAREA t
JOIN TIPO_TAREA tt ON t.ID_Tipo_tarea = tt.ID_Tipo_tarea
WHERE t.Fecha_realizada IS NOT NULL
GROUP BY tt.TIPO;
GO

GO
CREATE VIEW Vista_Reclamos_Info AS
SELECT
    r.ID_Reclamo,
    r.Fecha_reclamo,
    a.Codigo AS Codigo_Arbol,
    
    -- Fecha de primer asignación de tarea
    MIN(rt.Fecha_asignacion) AS Fecha_Primer_Asignacion,
    
    -- Fecha de última resolución de tarea
    MAX(t.Fecha_realizada) AS Fecha_Ultima_Resolucion,
    
    -- Días hasta asignación
    CASE
        WHEN MIN(rt.Fecha_asignacion) IS NULL
            THEN DATEDIFF(DAY, r.Fecha_reclamo, GETDATE())
        ELSE DATEDIFF(DAY, r.Fecha_reclamo, MIN(rt.Fecha_asignacion))
    END AS Dias_Hasta_Asignacion,
    
    -- Días hasta resolución
    CASE
        WHEN MAX(t.Fecha_realizada) IS NULL
            THEN DATEDIFF(DAY, r.Fecha_reclamo, GETDATE())
        ELSE DATEDIFF(DAY, r.Fecha_reclamo, MAX(t.Fecha_realizada))
    END AS Dias_Hasta_Resolucion,
    
    -- Estado del reclamo
    CASE
        WHEN COUNT(rt.ID_Reclamo_tarea) = 0 THEN 'No asignado'
        WHEN COUNT(CASE WHEN t.Fecha_realizada IS NOT NULL THEN 1 END) < COUNT(rt.ID_Reclamo_tarea) THEN 'En proceso'
        ELSE 'Finalizado'
    END AS Estado_Reclamo

FROM RECLAMO r
INNER JOIN ARBOL a ON r.ID_Arbol = a.ID_Arbol
LEFT JOIN RECLAMO_TAREA rt ON r.ID_Reclamo = rt.ID_Reclamo
LEFT JOIN TAREA_ARBOL ta ON rt.ID_Tarea_Arbol = ta.ID_Tarea_arbol
LEFT JOIN TAREA t ON ta.ID_Tarea = t.ID_Tarea

GROUP BY r.ID_Reclamo, r.Fecha_reclamo, a.Codigo;
GO

-- ACÁ SÍ O SÍ Y NO ANTES DEBEN IR LOS PROCEDIMIENTOS POR ORDEN DE CREACIÓN
-- ESTÁNDAR EN SQL, YA SE NORMALIZÓ EL PROBLEMA QUE EXISTÍA ANTES. 

-- 6) 

CREATE PROCEDURE sp_BuscarTareasPendientes
    @idArbol INT,
    @idTipoTarea INT,
    @ProximaFecha DATE OUTPUT     -- parámetro de salida
AS
BEGIN
    SET NOCOUNT ON; -- Evita mensajes como "(2 rows afected)" despues de cada operacion

-- Obtener próxima tarea pendiente

    SET @ProximaFecha = (
        SELECT TOP 1 T.Fecha_planificado
        FROM TAREA T
        JOIN TAREA_ARBOL TA ON T.ID_Tarea = TA.ID_Tarea
        WHERE 
            TA.ID_Arbol = @idArbol
            AND T.ID_Tipo_tarea = @idTipoTarea
            AND T.Fecha_realizada IS NULL
        ORDER BY T.Fecha_planificado ASC
        )

-- Contar tareas pendientes
  
    DECLARE @Cantidad INT;
    SET @Cantidad = (
        SELECT COUNT(*)
        FROM TAREA T
        JOIN TAREA_ARBOL TA ON T.ID_Tarea = TA.ID_Tarea
        WHERE 
            TA.ID_Arbol = @idArbol
            AND T.ID_Tipo_tarea = @idTipoTarea
            AND T.Fecha_realizada IS NULL
            )

    RETURN @Cantidad;
END;
GO
