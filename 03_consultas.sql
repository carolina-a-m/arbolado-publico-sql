-- Establece la base de datos correcta

USE TP_BBDD1_2025_19;
GO

-- 4) a. Mostrar la cuadrilla que más tareas realizó en el mes de Octubre de 2025, y la cantidad de tareas realizadas. 

SELECT TOP 1
    C.ID_Cuadrilla,
    COUNT(T.ID_Tarea) AS Cantidad_Tareas
FROM TAREA T
JOIN CUADRILLA C ON T.ID_Cuadrilla = C.ID_Cuadrilla
WHERE T.Fecha_realizada BETWEEN '2025-10-01' AND '2025-10-31'
GROUP BY C.ID_Cuadrilla
ORDER BY COUNT(T.ID_Tarea) DESC;

-- 4) b. Mostrar los Motivos de Reclamos que tengan más de 3 reclamos en estado no asignado (sin tarea).

SELECT 
    MR.Descripcion AS Motivo,
    COUNT(R.ID_Reclamo) AS Cantidad_Reclamos_No_Asignados
FROM RECLAMO R
INNER JOIN MOTIVO_RECLAMO MR 
        ON R.ID_Motivo_reclamo = MR.ID_Motivo_reclamo
LEFT JOIN RECLAMO_TAREA RT
        ON R.ID_Reclamo = RT.ID_Reclamo   -- Si no tiene coincidencia → no asignado
WHERE RT.ID_Reclamo IS NULL              -- filtra solo los reclamos sin tarea asignada
GROUP BY MR.Descripcion
HAVING COUNT(R.ID_Reclamo) > 3;

--

-- 4) c. Mostrar los Árboles (código, especie y ubicación) que no tengan ningún reclamo. 

SELECT 
    A.Codigo,
    E.Nombre_comun AS Especie,
    CASE 
        WHEN U.Altura IS NOT NULL 
        THEN U.Ubicacion_nombre + ' ' + CAST(U.Altura AS VARCHAR)
        ELSE U.Ubicacion_nombre
    END AS Ubicacion
FROM ARBOL A
INNER JOIN ESPECIE E ON A.ID_Especie = E.ID_Especie
INNER JOIN UBICACION U ON A.ID_Ubicacion = U.ID_Ubicacion
LEFT JOIN RECLAMO R ON A.ID_Arbol = R.ID_Arbol
WHERE R.ID_Arbol IS NULL;

-- 4) d. Mostrar los tres árboles (código y altura) más altos de cada especie. Mostrar los resultados ordenados por especie y luego altura decreciente. 

WITH MaxAlturaPorArbol AS ( 
    SELECT  
        A.ID_Arbol, 
        A.Codigo, 
        A.ID_Especie, 
        MAX(M.Altura) AS AlturaMax 
    FROM ARBOL A 
    INNER JOIN MEDICION_ALTURA M ON A.ID_Arbol = M.ID_Arbol 
    GROUP BY A.ID_Arbol, A.Codigo, A.ID_Especie 
) 
SELECT  
    aux.Codigo, 
    E.Nombre_comun AS Especie, 
    aux.AlturaMax AS Altura 
FROM ( 
    SELECT  
        MA.Codigo, 
        MA.ID_Especie, 
        MA.AlturaMax, 
        ROW_NUMBER() OVER ( 
            PARTITION BY MA.ID_Especie  
            ORDER BY MA.AlturaMax DESC 
        ) AS rn 
    FROM MaxAlturaPorArbol MA 
) AS aux 
INNER JOIN ESPECIE E ON aux.ID_Especie = E.ID_Especie 
WHERE aux.rn <= 3 
ORDER BY Especie, Altura DESC;

--  5) a) Ejemplos de ejecución

--  5) a)  Todos los reclamos

SELECT * FROM Vista_Reclamos_Info;

--  5) a)  Reclamos finalizados

SELECT *
FROM Vista_Reclamos_Info
WHERE Estado_Reclamo = 'Finalizado';

--  5) b) Ejemplos de ejecución

--  5) b) Muestra todas las tareas realizadas por tipo

SELECT * FROM vista_resumen_tareas;

-- 5) b) Muestra sólo los tipos con más de dos tareas realizadas 

SELECT TIPO, fecha_primera, fecha_ultima, cantidad_realizadas
FROM vista_resumen_tareas
WHERE cantidad_realizadas > 2
ORDER BY cantidad_realizadas DESC;

--  6) Ejemplos de ejecución:

-- Caso: Si hay resultados

DECLARE @FechaCon DATE;
DECLARE @CantidadCon INT;

EXEC @CantidadCon = sp_BuscarTareasPendientes 
        @idArbol = 10,
        @idTipoTarea = 4,
        @ProximaFecha = @FechaCon OUTPUT; -- No es necesario poner los nombres de las variables
--pero queda mas claro así

SELECT @FechaCon AS FechaCon
SELECT @CantidadCon AS CantidadCon

-- Caso: no hay resultados

DECLARE @FechaSin DATE;
DECLARE @CantidadSin INT;

EXEC @CantidadSin = sp_BuscarTareasPendientes 
        @idArbol = 5,
        @idTipoTarea = 2,
        @ProximaFecha = @FechaSin OUTPUT;

SELECT @FechaSin AS FechaSin
SELECT @CantidadSin AS CantidadSin

GO



