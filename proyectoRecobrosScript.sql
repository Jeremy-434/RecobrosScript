CREATE DATABASE [DBRecobros]
use [DBRecobros]

/* 
CREATE TABLE Usuarios (
    id INT PRIMARY KEY IDENTITY,
    nombre_usuario VARCHAR(50) NOT NULL,
	correo VARCHAR(50) NOT NULL,
    contraseña VARCHAR(60) NOT NULL
);
*/

CREATE TABLE Parametros (
id_parametro int primary key NOT NULL identity(1,1),
num_meses_eliminacion_historico int NOT NULL,
num_columnas_archivo int NOT NULL,
bytes_max_archivo int NOT NULL
)

CREATE TABLE Homologaciones (
id_homologacion int primary key NOT NULL identity(1,1),
entrada varchar(100) NOT NULL,
letras_iniciales_centro_costo varchar(100) NOT NULL,
salida varchar(100) NOT NULL
)

CREATE TABLE CierreMes (
id_cierre_mes int primary key NOT NULL identity(1,1),
mes int NOT NULL,
anio int NOT NULL,
estado varchar(50) check (estado IN ('Pendiente','Cerrado')),
usuario varchar(100) NOT NULL,
fecha_servidor datetime DEFAULT GETDATE(),
)

CREATE TABLE Aliados (
id_aliado int primary key NOT NULL identity(1,1),
nombre_aliado varchar(100) NOT NULL,
usuario varchar(30) NULL,
estado varchar(50) check (estado IN ('Activo','Inactivo') ),
correo_responsable varchar(200) NOT NULL,
fecha datetime DEFAULT GETDATE(),
fecha_modificacion datetime DEFAULT GETDATE(),
)

CREATE TABLE Servicios(
id_servicio int primary key identity(1,1) NOT NULL,
nombre_servicio varchar(80) NOT NULL,
descripcion varchar(200) NULL,
driver varchar(50) NULL, -- Sugerir No. de usuarios
responsable_reporte varchar(100) NOT NULL,
clase_actividad varchar(50) NOT NULL,
clase_costo varchar(50) NOT NULL,
porcentaje_comparacion float DEFAULT NULL,
)

CREATE TABLE Aplicaciones (
id_aplicacion int primary key NOT NULL identity(1,1),
nombre_aplicacion varchar(80) NOT NULL,
id_servicio int NOT NULL,
)

GO
alter table Aplicaciones add CONSTRAINT FK_IdServicio FOREIGN KEY (id_servicio) 
REFERENCES Servicios(id_servicio)

CREATE TABLE CentroCostos (
id_centro_costo int primary key NOT NULL identity(1,1),
login_user varchar(50) NOT NULL,
nombre_user varchar(100) NOT NULL,
ceco varchar(50) NOT NULL
)

CREATE TABLE ControlArchivo (
id_control_archivo int primary key NOT NULL identity(1,1),
usuario varchar(100) NULL,
estado varchar(50) check (estado IN ('Pendiente','Cerrado')),
nombre_archivo varchar(50) NULL,
fecha_servidor datetime DEFAULT GETDATE(),
Mes int NOT NULL,
anio int NOT NULL,
id_aliado int NOT NULL,
)
GO
alter table ControlArchivo add CONSTRAINT FK_IdAliado FOREIGN KEY (id_aliado)
REFERENCES Aliados(id_aliado)

CREATE TABLE Consolidado (
id_consolidado int primary key NOT NULL identity(1,1),
mes int NULL,
anio int NULL,
registro varchar(50) NOT NULL,
nombre varchar(50) NOT NULL,
nombre_servicio varchar(100) NOT NULL,
sub_servicio varchar(50) NOT NULL,
clase_actividad varchar(50) NOT NULL,
clase_costo varchar(50) NOT NULL,
driver varchar(50) DEFAULT 'No. de usuarios',
centro_costo_receptor varchar(100) NULL,
descripcion_ceco_emisor varchar(100) NULL,
cantidad int DEFAULT 1,
tarifa varchar(100) NULL,
costo varchar(100) NULL,
detalle varchar(100) NULL,
regional varchar(100) NULL,
localidad varchar(100) NULL,
serial varchar(100) NULL,
nombre_pc varchar(100) NULL,
nombre_aliado varchar(100) NULL,
producto_instalado varchar(50) NULL,
nombre_aplicacion varchar(100) NULL,
fecha datetime DEFAULT GETDATE(),
fecha_modificacion datetime NULL,
estado_registro varchar(50) check (estado_registro IN ('Procesado','Error')),
id_control_archivo int NOT NULL,
id_aplicacion int NOT NULL,
id_servicio int NOT NULL,
id_aliado int NOT NULL
)

GO
alter table Consolidado add CONSTRAINT FKC_IdControlArchivo FOREIGN KEY (id_control_archivo)
REFERENCES ControlArchivo(id_control_archivo)
alter table Consolidado add CONSTRAINT FKC_IdAplicacion FOREIGN KEY (id_aplicacion) 
REFERENCES Aplicaciones(id_aplicacion)
alter table Consolidado add CONSTRAINT FKC_IdServicio FOREIGN KEY (id_servicio) 
REFERENCES Servicios(id_servicio)
alter table Consolidado add CONSTRAINT FKC_IdAliado FOREIGN KEY (id_aliado) 
REFERENCES Aliados(id_aliado)

CREATE TABLE LogErrores (
id_log_error int primary key NOT NULL identity(1,1),
fecha_servidor datetime NULL,
descripcion_error varchar(30) DEFAULT NULL,
anio int DEFAULT NULL,
mes int DEFAULT NULL,
id_aliado int  NULL,
id_consolidado int  NULL,
)

GO
alter table LogErrores add CONSTRAINT FKLG_IdAliado FOREIGN KEY (id_aliado)
REFERENCES Aliados(id_aliado)
alter table LogErrores add CONSTRAINT FKLG_IdConsolidado FOREIGN KEY (id_consolidado)
REFERENCES Consolidado(id_consolidado)

CREATE TABLE HistorialConsolidado (
id_historial_consolidado int primary key NOT NULL identity(1,1),
mes int NULL,
anio int NULL,
registro varchar(50) NOT NULL,
nombre varchar(50) NOT NULL,
nombre_servicio varchar(100) NOT NULL,
sub_servicio varchar(100) NOT NULL,
clase_actividad varchar(50) NOT NULL,
clase_costo varchar(50) NOT NULL,
driver varchar(50) DEFAULT 'No. de usuarios',
centro_costo_receptor varchar(100) NULL,
descripcion_ceco_emisor varchar(100) NULL,
cantidad int DEFAULT 1,
tarifa varchar(100) NULL,
costo varchar(100) NULL,
detalle varchar(100) NULL,
regional varchar(100) NULL,
localidad varchar(100) NULL,
serial varchar(100) NULL,
nombre_pc varchar(100) NULL,
nombre_aliado varchar(100) NULL,
producto_instalado varchar(50) NULL,
nombre_aplicacion varchar(100) NULL,
fecha datetime DEFAULT GETDATE(),
fecha_modificacion datetime NULL,
estado_registro varchar(50) check (estado_registro IN ('Procesado','Error')),
id_consolidado int NOT NULL,
id_control_archivo int NOT NULL,
id_aplicacion int NOT NULL,
id_servicio int NOT NULL,
id_aliado int NOT NULL
)

GO
alter table HistorialConsolidado add CONSTRAINT FKHC_IdConsolidado FOREIGN KEY (id_consolidado)
REFERENCES Consolidado(id_consolidado)
alter table HistorialConsolidado add CONSTRAINT FKHC_IdControlArchivo FOREIGN KEY (id_control_archivo)
REFERENCES ControlArchivo(id_control_archivo)
alter table HistorialConsolidado add CONSTRAINT FKHC_IdAplicacion FOREIGN KEY (id_aplicacion)
REFERENCES Aplicaciones(id_aplicacion)
alter table HistorialConsolidado add CONSTRAINT FKHC_IdServicio FOREIGN KEY (id_servicio) 
REFERENCES Servicios(id_servicio)
alter table HistorialConsolidado add CONSTRAINT FKHC_IdAliado FOREIGN KEY (id_aliado) 
REFERENCES Aliados(id_aliado)


GO

INSERT INTO [dbo].[Parametros]
           ([num_meses_eliminacion_historico]
           ,[num_columnas_archivo]
           ,[bytes_max_archivo])
     VALUES
           (6,
           7,
           30000000)
GO


