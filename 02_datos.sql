USE TP_BBDD1_2025_19;
GO

INSERT INTO CUADRILLA (codigo_cuadrilla)
VALUES
('C001'),
('C002'),
('C003');

-- EMPLEADOS (10)
INSERT INTO EMPLEADO (nombre, cuil, telefono, fecha_ingreso)
VALUES
('Ana Valdez','20-11111111-1','341-5550001','2020-03-15'),
('Bruno Rojas','20-22222222-2','341-5550002','2019-11-05'),
('Camila Torres','20-33333333-3','341-5550003','2021-06-10'),
('Diego López','20-44444444-4','341-5550004','2018-01-20'),
('Elena García','20-55555555-5','341-5550005','2022-09-01'),
('Facundo Méndez','20-66666666-6','341-5550006','2017-12-12'),
('Graciela Díaz','20-77777777-7','341-5550007','2016-04-03'),
('Hugo Ferrer','20-88888888-8','341-5550008','2020-08-30'),
('Irene Navarro','20-99999999-9','341-5550009','2015-05-25'),
('Javier Silva','20-10101010-0','341-5550010','2023-02-14');

-- TIPOS DE TAREA (5)
INSERT INTO TIPO_TAREA (TIPO)
VALUES
('Plantado'),
('Poda'),
('Remoción'),
('Inspección'),
('Tratamiento fitosanitario');

-- ESPECIES (5)
INSERT INTO ESPECIE (Nombre_comun, Nombre_científico)
VALUES
('Plátano','Platanus × acerifolia'),
('Jacarandá','Jacaranda mimosifolia'),
('Tipa','Tipuana tipu'),
('Fresno','Fraxinus excelsior'),
('Pino','Pinus spp.');

-- SALUD (4)
INSERT INTO SALUD (estado_salud)
VALUES
('Sano'),
('Débil'),
('Seco'),
('Enfermo');

-- UBICACIONES (10)
INSERT INTO UBICACION (Ubicacion_nombre, Altura, lat, lon, Ubicacion_tipo)
VALUES
('Av. Pellegrini', 1200, -32.944167, -60.650833, 'vereda'),
('Parque Independencia', NULL, -33.000000, -60.650000, 'parque'),
('Plaza Sarmiento', NULL, -32.950000, -60.666667, 'plaza'),
('Córdoba', 800, -32.945000, -60.650500, 'vereda'),
('Bv. Oroño', 500, -32.948000, -60.660000, 'vereda'),
('Plaza 25 de Mayo', NULL, -32.952000, -60.655000, 'plaza'),
('Parque España', NULL, -32.946000, -60.639000, 'parque'),
('Av. Francia', 200, -32.949000, -60.633000, 'vereda'),
('Bv. Oroño (Sur)', 120, -32.956000, -60.661000, 'vereda'),
('Plaza Italia', NULL, -32.958000, -60.648000, 'plaza');

-- MOTIVOS DE RECLAMO (5)
INSERT INTO MOTIVO_RECLAMO (Descripcion)
VALUES
('Copa toca alumbrado público'),
('Raíces levantan la vereda'),
('Árbol caído'),
('Plaga/insectos'),
('Riesgo de caída/ramas partidas');

INSERT INTO ARBOL (Codigo, Fecha_plantado, ID_Especie, ID_Salud, ID_Ubicacion) VALUES
('ARB0001','2018-05-12',1,1,1),
('ARB0002','2019-09-20',1,1,1),
('ARB0003',NULL,1,2,2),
('ARB0004','2020-07-01',2,1,2),
('ARB0005','2015-03-22',2,3,3),
('ARB0006',NULL,2,1,3),
('ARB0007','2021-10-11',3,1,4),
('ARB0008','2017-08-09',3,4,4),
('ARB0009','2016-12-01',3,2,5),
('ARB0010',NULL,3,1,5),
('ARB0011','2014-04-15',4,3,6),
('ARB0012','2022-11-20',4,1,6),
('ARB0013',NULL,4,1,7),
('ARB0014','2010-06-07',5,3,7),
('ARB0015','2019-01-30',5,2,8),
('ARB0016',NULL,5,1,8),
('ARB0017','2020-03-03',1,1,9),
('ARB0018','2013-09-18',1,4,9),
('ARB0019','2011-02-02',2,3,10),
('ARB0020',NULL,2,1,10),
('ARB0021','2016-05-05',3,1,1),
('ARB0022','2018-07-07',3,2,2),
('ARB0023',NULL,4,1,3),
('ARB0024','2012-10-10',4,3,4),
('ARB0025','2019-12-12',5,1,5),
('ARB0026',NULL,5,2,6),
('ARB0027','2021-05-20',1,1,7),
('ARB0028','2009-03-15',1,3,8),
('ARB0029',NULL,2,1,9),
('ARB0030','2014-09-09',2,4,10),
('ARB0031','2017-02-02',3,1,1),
('ARB0032',NULL,3,2,2),
('ARB0033','2013-11-11',4,1,3),
('ARB0034','2008-01-01',4,3,4),
('ARB0035',NULL,5,1,5),
('ARB0036','2010-05-05',5,2,6),
('ARB0037','2019-08-08',1,1,7),
('ARB0038',NULL,1,4,8),
('ARB0039','2016-06-06',2,1,9),
('ARB0040','2015-10-10',2,2,10),
('ARB0041',NULL,3,1,1),
('ARB0042','2024-04-04',3,1,2),
('ARB0043','2005-05-05',4,3,3),
('ARB0044','2011-11-11',5,1,4),
('ARB0045',NULL,5,2,5),
('ARB0046','2018-12-12',1,1,6),
('ARB0047','2012-02-02',1,3,7),
('ARB0048',NULL,2,1,8),
('ARB0049','2010-09-09',2,4,9),
('ARB0050',NULL,3,1,10);

INSERT INTO TAREA (Fecha_planificado, Fecha_realizada, Comentario_final, ID_Cuadrilla, ID_Tipo_tarea)
VALUES
('2025-07-03', '2025-07-03', 'Plantado nuevos ejemplares en vereda', 1, 1),
('2025-07-15', '2025-07-15', 'Poda de seguridad', 2, 2),
('2025-07-20', NULL, NULL, 3, 4),
('2025-07-28', '2025-07-28', 'Retiro de rama grande', 2, 3),
('2025-08-05', '2025-08-05', 'Retiro de árbol caído', 1, 3),
('2025-08-11', '2025-08-11', 'Tratamiento por plaga', 2, 5),
('2025-08-18', NULL, NULL, 3, 2),
('2025-08-22', '2025-08-22', 'Inspección general', 1, 4),
('2025-08-30', '2025-08-30', 'Plantado vereda Córdoba', 3, 1),
('2025-10-02', '2025-10-02', 'Poda correctiva', 2, 2),
('2025-10-05', '2025-10-05', 'Plantado en plaza', 3, 1),
('2025-10-07', NULL, NULL, 1, 4),
('2025-10-12', '2025-10-13', 'Remoción de 2 ejemplares', 2, 3),
('2025-10-15', NULL, NULL, 3, 5),
('2025-10-20', '2025-10-20', 'Poda por riesgo', 1, 2),
('2025-10-25', NULL, NULL, 2, 4),
('2025-10-30', '2025-10-30', 'Inspección y control fitosanitario', 2, 4),
('2025-11-02', NULL, NULL, 3, 1),
('2025-11-10', NULL, NULL, 1, 5);

-- MEDICIONES DE ALTURA (no todos los árboles tienen medición)
INSERT INTO MEDICION_ALTURA (ID_Arbol, Altura, Fecha_Medicion) VALUES
-- Árbol 1
(1,11.50,'2023-06-10'),
(1,12.20,'2024-03-15'),
(1,12.50,'2025-06-10'),
-- Árbol 2
(2,13.10,'2023-05-12'),
(2,13.75,'2024-05-12'),

-- Árbol 3
(3,8.50,'2023-07-01'),
(3,9.20,'2024-07-01'),
(3,9.80,'2025-07-01'),

-- Árbol 4
(4,15.00,'2023-08-20'),
(4,15.50,'2024-08-20'),

-- Árbol 5
(5,7.50,'2023-09-15'),
(5,8.00,'2024-09-15'),
(5,8.30,'2025-09-15'),

-- Árboles adicionales con 1 medición cada uno
(6,9.10,'2018-08-08'),
(7,10.00,'2021-10-12'),
(8,11.70,'2020-02-02'),
(9,13.40,'2017-07-07'),
(10,7.00,'2016-12-12'),
(11,16.00,'2019-01-15'),
(12,4.20,'2022-12-01'),
(13,9.50,'2020-05-05'),
(14,20.30,'2015-06-06'),
(15,8.40,'2019-02-02'),
(16,6.60,'2021-01-01'),
(17,13.80,'2023-03-03'),
(18,18.00,'2014-09-20'),
(19,14.75,'2012-02-02'),
(20,7.50,'2018-11-11');

-- CUADRILLA_EMPLEADO (asignaciones, incluyendo un empleado en 2 cuadrillas)
INSERT INTO CUADRILLA_EMPLEADO (id_cuadrilla, id_empleado)
VALUES
-- Cuadrilla 1
(1,1),(1,2),(1,3),(1,4),
-- Cuadrilla 2
(2,5),(2,6),(2,7),
-- Cuadrilla 3
(3,8),(3,9),(3,10),
-- Empleado en 2 cuadrillas (por ejemplo: Ana Valdez también en Cuadrilla 2)
(2,1);

INSERT INTO TAREA_ARBOL (ID_Tarea, ID_Arbol)
VALUES
(1,1), (1,21),
(2,5),
(3,10), (3,35),
(4,3),
(5,8), (5,18),
(6,22),
(7,25), (7,30), (7,49),
(8,2),
(9,15), (9,26),
(10,41),
(11,9), (11,11),
(12,39),
(13,4),
(14,27), (14,31),
(15,36),
(16,46),
(17,7),
(18,13), (18,24),
(19,43),
(19,50);
INSERT INTO RECLAMO (ID_Arbol, ID_Motivo_reclamo, email_denunciante, Fecha_reclamo)
VALUES
(1, 2, 'vecino10@mail.com', '2025-07-01'),
(2, 1, 'vecino15@mail.com', '2025-07-02'),
(3, 1, 'vecino4@mail.com', '2025-07-04'), 
(5, 2, 'vecino3@mail.com',  '2025-07-05'), 
(7, 5, 'vecino18@mail.com',  '2025-07-05'), 
(8, 4, 'vecino6@mail.com', '2025-07-05'),
(9, 3, 'vecino1@mail.com', '2025-07-05'), 
(9, 3, 'vecino2@mail.com', '2025-07-12'), 
(11, 2, 'vecino16@mail.com',  '2025-07-15'),
(12, 3, 'vecino21@mail.com',  '2025-07-15'), 
(13, 3, 'vecino22@mail.com',  '2025-07-15'), 
(14, 3, 'vecino23@mail.com',  '2025-08-01'), 
(15, 1, 'vecino11@mail.com',  '2025-08-01'), 
(16, 3, 'vecino24@mail.com',  '2025-08-04'), 
(18, 4, 'vecino7@mail.com',  '2025-08-07'), 
(21, 2, 'vecino19@mail.com',  '2025-08-09'),
(21, 2, 'vecino20@mail.com',  '2025-08-10'), 
(24, 3, 'vecino8@mail.com', '2025-08-20'), 
(26, 5, 'vecino12@mail.com',  '2025-10-01'),
(27, 1, 'vecino17@mail.com',  '2025-10-03'),
(30, 5, 'vecino9@mail.com', '2025-10-04'),
(39, 3, 'vecino13@mail.com',  '2025-10-06'),
(43, 5, 'vecino5@mail.com', '2025-10-07'),
(49, 3, 'vecino14@mail.com',  '2025-10-09');



INSERT INTO RECLAMO_TAREA (ID_Reclamo, ID_Tarea_Arbol, Fecha_asignacion)
VALUES
(3, 4, '2025-07-05'),    
(4, 6, '2025-07-06'),    -- reclamo 4 -> tarea 4, árbol 3 -> ID_Tarea_arbol = 6
(5, 5, '2025-07-05'),    -- reclamo 5 -> tarea 3, árbol 35 -> ID_Tarea_arbol = 5
(7, 12, '2025-07-06'),   -- reclamo 7 -> tarea 7, árbol 25 -> ID_Tarea_arbol = 12
(8, 8, '2025-07-12'),    -- reclamo 8 -> tarea 8, árbol 2 -> ID_Tarea_arbol = 8
(11, 13, '2025-07-18'),  -- reclamo 11 -> tarea 11, árbol 9 -> ID_Tarea_arbol = 13
(13, 5, '2025-08-03'),   -- reclamo 13 -> tarea 3, árbol 35 -> ID_Tarea_arbol = 5
(14, 15, '2025-08-05'),  -- reclamo 14 -> tarea 14, árbol 27 -> ID_Tarea_arbol = 15
(15, 9, '2025-08-07'),   -- reclamo 15 -> tarea 5, árbol 18 -> ID_Tarea_arbol = 9
(17, 17, '2025-08-12'),  -- reclamo 17 -> tarea 17, árbol 7 -> ID_Tarea_arbol = 17
(18, 18, '2025-08-20');  -- reclamo 18 -> tarea 18, árbol 13 -> ID_Tarea_arbol = 18

GO








