select * from ControlArchivo

ALTER TABLE controlArchivo ALTER COLUMN fecha_servidor datetime SET DEFAULT GETDATE();

-- Crear una nueva columna con el valor por defecto
ALTER TABLE controlArchivo ADD fecha_servidor_temp datetime NOT NULL DEFAULT GETDATE();
-- Actualizar la nueva columna con los valores de la antigua
UPDATE controlArchivo SET fecha_servidor_temp = fecha_servidor;
-- Eliminar la antigua columna
ALTER TABLE controlArchivo DROP COLUMN fecha_servidor;
-- Renombrar la nueva columna
EXEC sp_rename 'controlArchivo.fecha_servidor_temp', 'fecha_servidor', 'COLUMN';

-- Agregar una restricción de valor por defecto a un campo existente
ALTER TABLE controlArchivo ADD CONSTRAINT DF_fecha_servidor DEFAULT GETDATE() FOR fecha_servidor;

-- Borrar todas las filas de la tabla tbl_usuarios
TRUNCATE TABLE ControlArchivo;

-- Borrar las filas donde el nombre sea 'Abi'
DELETE FROM ControlArchivo WHERE usuario = 'Ama Gwatterson';
DELETE FROM CierreMes WHERE usuario = 'Ama Gwatterson';

select * from parametros


select * from Consolidado
select * from LogErrores

USE [recobrosDB]
GO

USE [recobrosDB]
GO

INSERT INTO [dbo].[CierreMes]
           ([mes]
           ,[anio]
           ,[estado]
           ,[usuario]
           ,[fecha_servidor])
     VALUES
           (3,
           2023,
           'Finalizado',
           'Ama Gwatterson',
		   '2023-03-29T09:17:22.807')
           
GO

USE [recobrosDB]
GO

DELETE FROM [dbo].[CierreMes]
      WHERE mes = 3
GO


select * from Aliados

USE [recobrosDB]
GO

INSERT INTO [dbo].[LogErrores]
           ([fecha_servidor]
           ,[descripcion_error]
           ,[anio]
           ,[mes]
           ,[id_aliado]
           ,[id_consolidado])
     VALUES
           ('2023-03-29T09:17:22.807',
           'Una descripcion de error',
           2024,
           4,
           14,
           1)
GO

select * from LogErrores


USE [recobrosDB]
GO

/****** Object:  Table [dbo].[Aliados]    Script Date: 4/13/2023 12:28:47 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Aliados]') AND type in (N'U'))
DROP TABLE [dbo].[Aliados]
GO

--Agregar una columna
ALTER TABLE Aliados
ADD fecha_modificacion datetime DEFAULT GETDATE();

select * from CierreMes

ALTER TABLE CierreMes
ALTER COLUMN estado varchar(50) WITH CHECK ADD CHECK (estado IN ('Pendiente','Cerrado')),

USE [recobrosDB]
GO

/****** Object:  Table [dbo].[CierreMes]    Script Date: 4/13/2023 1:30:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CierreMes](
	[id_cierre_mes] [int] IDENTITY(1,1) NOT NULL,
	[mes] [int] NOT NULL,
	[anio] [int] NOT NULL,
	[estado] [varchar](50) NULL,
	[usuario] [varchar](100) NOT NULL,
	[fecha_servidor] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cierre_mes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CierreMes] ADD  DEFAULT (getdate()) FOR [fecha_servidor]
GO

ALTER TABLE [dbo].[CierreMes]  WITH CHECK ADD CHECK  (([estado]='Finalizado' OR [estado]='Pendiente' OR [estado]='Procesando'))
GO

--Ver las restricciones
SELECT name FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('CierreMes');

SELECT name FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('LogErrores');

--Borrar restricciones
ALTER TABLE CierreMes
DROP CONSTRAINT CK__CierreMes__estad__11007AA7;
ALTER TABLE CierreMes
DROP CONSTRAINT CK__CierreMes__estad__14D10B8B;
ALTER TABLE CierreMes
DROP CONSTRAINT CK__CierreMes__estad__7093AB15;


ALTER TABLE CierreMes
ADD CONSTRAINT CK_CierreMes_estado CHECK (estado IN ('Pendiente', 'Cerrado'));

--Borrar todos los datos de una tabla
DELETE FROM LogErrores;

--Eliminar una columna
ALTER TABLE Aplicaciones
DROP COLUMN id_aliado;

ALTER TABLE Consolidado
DROP COLUMN id_aplicacion;



--Eliminar la restricción llave foranea
ALTER TABLE Aplicaciones
DROP CONSTRAINT FK_IdAliados;

ALTER TABLE Consolidado
DROP CONSTRAINT FKH_IdConsolidado;
DROP CONSTRAINT FKH_IdAliado;
DROP CONSTRAINT FKH_IdControlArchivo;

ALTER TABLE [dbo].[LogErrores] DROP CONSTRAINT [FKLG_IdServicio]
ALTER TABLE [dbo].[LogErrores] DROP CONSTRAINT [FKLG_IdAplicacion]


select * from LogErrores

--Agregar llave foranea a una tabla
ALTER TABLE Consolidado
ADD CONSTRAINT FKC_IdAplicacion
FOREIGN KEY (id_aplicacion)
REFERENCES Aplicaciones (id_aplicacion);

--Agregar una columna
ALTER TABLE Consolidado
ADD id_aplicacion int NOT NULL;

ALTER TABLE LogErrores
ADD id_servicio int NULL;

-----INNER JOIN-----

select *
from LogErrores l
inner join Consolidado c
on l.id_consolidado = c.id_consolidado

select * from Aplicaciones

SELECT * FROM LogErrores
WHERE id_consolidado NOT IN (SELECT id_consolidado FROM Consolidado)

---INDICES---
Create unique index UIDX_LE_IdConsolidado on LogErrores(id_consolidado)

Create unique index UIDX_HC_IdHistorialConsolidado on HistorialConsolidado(id_consolidado)

/****** Object:  Index [NUK_IdConsolidado]    Script Date: 4/14/2023 1:46:59 PM ******/
DROP INDEX [NUK_IdConsolidado] ON [dbo].[LogErrores]

INSERT INTO [dbo].[Consolidado]
           ([mes]
           ,[anio]
           ,[registro]
           ,[nombre]
           ,[nombre_servicio]
           ,[sub_servicio]
           ,[clase_actividad]
           ,[clase_costo]
           ,[driver]
           ,[centro_costo_receptor]
           ,[descripcion_ceco_emisor]
           ,[cantidad]
           ,[tarifa]
           ,[costo]
           ,[detalle]
           ,[regional]
           ,[localidad]
           ,[serial]
           ,[nombre_pc]
           ,[nombre_aliado]
           ,[producto_instalado]
           ,[nombre_aplicacion]
           --,[fecha]
           ,[fecha_modificacion]
           ,[id_control_archivo]
           ,[id_aplicacion]
           ,[id_servicio]
           ,[id_aliado])
     VALUES
           (6,
           2023,
           'E0014328',
           'Jefferson Said Mateus Tarazona',
           'FirstService 100',
           'FirstService 100',
           'Cl. 32NC',
           'Cl. 35kP',
           'No. de Usuarios',
           'PY0043',
           null,
           1,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           'FIRSTAPP 100',
           --null, --fecha
           null,
           1,
           1,
           1,
           1)
GO
select * from Consolidado

select * from Aliados
select * from ControlArchivo
delete from Consolidado
where mes = 3

USE [recobrosDB]
GO

INSERT INTO [dbo].[LogErrores]
           ([fecha_servidor]
           ,[descripcion_error]
           ,[anio]
           ,[mes]
           ,[id_aliado]
           ,[id_consolidado])
     VALUES
           ('2023-05-08T10:26:52.527',
           'Error en el servicio',
           2023,
           5,
           1,
           2)
GO
Select * from LogErrores
delete from LogErrores
where id_log_error = 10 or id_log_error = 11

CREATE TABLE Usuarios (
    id INT PRIMARY KEY IDENTITY,
    nombre_usuario VARCHAR(50) NOT NULL,
	correo VARCHAR(50) NOT NULL,
    contraseña VARCHAR(60) NOT NULL
);

Drop table usuarios

SELECT * FROM Usuarios
ALTER TABLE Usuarios ALTER COLUMN contraseña NVARCHAR(60)



--//////////////////////////////--
CREATE TABLE Aplicaciones (
id_aplicacion int primary key NOT NULL identity(1,1),
nombre_aplicacion varchar(80) NOT NULL,
estado varchar(50) check (estado IN ('Activo','Inactivo')),
nombre_segmento varchar(50) NULL,
id_servicio int NOT NULL,
)
--//////////////////////////////--

Select * from Aplicaciones
Select * from Servicios

Delete ControlArchivo 
where usuario = 'Ama Gwatterson'

ALTER TABLE Aplicaciones
DROP COLUMN estado

ALTER TABLE Aplicaciones
DROP CONSTRAINT CK__Aplicacio__estad__3D14070F;

DROP TABLE Parametros
SELECT * FROM Parametros