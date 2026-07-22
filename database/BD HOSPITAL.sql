
/*
SCRIPT DE BASE DE DATOS
	Script utilizado para el proyecto escolar "Hospital Angostura".
	Donde se pueden realizar acciones con las tablas relacionadas a consultorios médicos.

	Fecha: 2023
	Autor:
		Kalecxa Guadalupe Sandoval Encines
*/
CREATE DATABASE hos
GO
USE hos
GO
--TABLA ESPECIALIDAD: tabla para registrar las especialidades de los medicos--
CREATE TABLE Especialidades(
idEspecialidad int identity(1,1) primary key,
nombre nvarchar(80) not null,
descripcion nvarchar(100) not null
)
GO
--TABLA SUB Especialidad 
CREATE TABLE Subespecialides(
idSubespecialidad int identity(1,1) primary key,
nombre nvarchar(80) not null,
descripcion nvarchar(100) not null,
idEspecialidad int
)
GO

--TABLA DEPARTAMENTOS: tabla para registrar los departamentos del hospital--
CREATE TABLE Departamentos(
idDepartamento int identity(1,1) primary key,
nombre nvarchar(70),
numEmpleados int check (numEmpleados>0), --1er check 
telExt nvarchar(15) unique not null
)
GO

--TABLA MEDICOS: tabla para registrar a los medicos del hospital--
CREATE TABLE Medicos(
idMedico int identity(1,1) primary key,
nombre nvarchar(80) not null,
app nvarchar(50) not null,
apm nvarchar(50), 
idEspecialidad int,
idDepartamento int,
idSubespecialidad int,
correo nvarchar(50) unique not null,
cedulaProf nvarchar(50),
fecNac date,
telefono nvarchar(15) unique not null,
curp nvarchar(18) unique,
rfc nvarchar(13) unique,
numCasa nvarchar(10),
nomCalle nvarchar(50),
localidad nvarchar(100),
municipio nvarchar(100)
)
GO

--Subcatalogo de religion
CREATE TABLE Religiones(
idReligion int identity(1,1) primary key,
nombre NVARCHAR(80),
descripcion NVARCHAR(100)
)

--TABLA PACIENTES: tabla para registrar a los pacientes del hospital--
CREATE TABLE Pacientes(
idPaciente int identity(1,1) primary key,
nombre nvarchar(80) not null,
app nvarchar(50) not null,
apm nvarchar(50),
fecNac date,
edad int,
curp nvarchar(18) not null unique,
genero nvarchar(50),
alergias nvarchar(50),
tipoSangre nvarchar(15) not null,
municipio nvarchar(100),
localidad nvarchar(100),
numCasa nvarchar(10),
nomCalle nvarchar(50),
idReligion int,
telefono nvarchar(15) unique not null
)
--TABLA SERVICIOS: tabla para registrar los servicios ofrecidos por el hospital--
CREATE TABLE Servicios(
idServicio int identity(1,1) primary key,
nombre nvarchar(50) not null,
descripcion nvarchar(150)
)
GO

--TABLA CITAS: tabla para registra las citas medicas--
CREATE TABLE Citas(
idCita int identity(1,1) primary key,
idPaciente int,
idMedico int,
fecha datetime not null, --si no funciona libreria descomponer en fecha y hora
motivo nvarchar(250),
idServicio int,
consultorio nvarchar(50) not null,
comentarioA nvarchar(100), --Comentarios respecto a la cita
Estado nvarchar(50) default 'Pendiente' check (Estado in ('Pendiente', 'Asistida')) --2do check
)
GO
--Tabla de consultas 
CREATE TABLE Consultas(
idConsulta int identity(1,1) primary key,
idCita INT,
fecha datetime,
diagnostico nvarchar(300),
observaciones nvarchar(500),
presion nvarchar(30),
temp nvarchar(10),
altura nvarchar(10),
peso nvarchar(6)
)
GO

--subcatalogo tipos medicamentos
CREATE TABLE PresentacionMed(
idPresentacion int identity primary key,
nombre nvarchar(50),
descripcion nvarchar(70)
)
GO




--TABLA MEDICAMENTOS: tabla para registra losm medicamentos disponibles en el hospital---
CREATE TABLE Medicamentos(
idMedicamento int primary key,
nombre nvarchar(50) not null, 
codigoB nvarchar(50),
marca nvarchar(50), --nombre comercial
laboratorio nvarchar(50), --Empresa distribuye o crea
formula nvarchar(70), --Composion quimica de medicamento
fecVenc date,
mgUnidad int check (mgUnidad>0), --3do check
claveR nvarchar(15),--Clave de registro unidad sanitaria
idPresentacion int --subcatalogo
)
GO

--TABLA RECETAS: tabla para registra recetas--
CREATE TABLE Recetas(
idReceta int identity(1,1) primary key,
idConsulta int,
fecha datetime,
--dosis nvarchar(50) not null,
--duracion nvarchar(50),
diagnostico nvarchar(200),
instruccion nvarchar(200)
)
GO

--TABLA RECETAMEDICAMENTOS(MUCHOSAMUCHOS)--
CREATE TABLE RECETAMEDICAMENTOS(
idReceta int,
idMedicamento int,
cantidad int check (cantidad >0) not null,--4to check
primary key(idReceta, idMedicamento)
)
GO

CREATE TABLE Inventario(
idInventario int identity(1,1) primary key,
idMedicamento int,
CantidadDisp int,
FechaIngreso date,
Estado nvarchar (20) default 'disponible' check( Estado in('Disponible', 'Agotado')), --5to check
lote nvarchar(50)
)
GO

CREATE TABLE Usuarios(
id INT IDENTITY (1,1) PRIMARY KEY,
usuario VARCHAR(50),
contrasena VARCHAR(50),
rol VARCHAR(20) check( rol in('Administrador', 'Medico', 'Recepcionista', 'Farmac�utico')) --6to check
)
GO
insert into Usuarios values ('admin', 'admin123', 'Administrador')

-- ********** LLAVES FORANEAS **********

--LLave foranea de subespecialidad a especialidad 

ALTER TABLE Subespecialides
ADD CONSTRAINT FK_Subespecialidad_Especialidades
FOREIGN KEY (idEspecialidad) REFERENCES Especialidades (idEspecialidad);
GO

--Llave foraneas Medicos

ALTER TABLE Medicos
ADD CONSTRAINT FK_Medicos_Especialidades
FOREIGN KEY (idEspecialidad) REFERENCES Especialidades(idEspecialidad);
GO

ALTER TABLE Medicos
ADD CONSTRAINT FK_Medicos_Departamentos
FOREIGN KEY (idDepartamento) REFERENCES Departamentos(idDepartamento);
GO

ALTER TABLE Medicos
ADD CONSTRAINT FK_Medicos_Subespecialidad
FOREIGN KEY (idSubespecialidad) REFERENCES Subespecialides(idSubespecialidad);
GO

--llaves foraneas de Pacientes

ALTER TABLE Pacientes
ADD CONSTRAINT FK_Pacientes_Religion
FOREIGN KEY (idReligion) REFERENCES Religiones(idReligion);
GO

--Llaves foraneas de citas
ALTER TABLE Citas
ADD CONSTRAINT FK_Citas_Medicos
FOREIGN KEY (idMedico) REFERENCES Medicos(idMedico);
GO

ALTER TABLE Citas
ADD CONSTRAINT FK_Citas_Pacientes
FOREIGN KEY (idPaciente) REFERENCES Pacientes(idPaciente);
GO

ALTER TABLE Citas
ADD CONSTRAINT FK_Citas_Servicios
FOREIGN KEY (idServicio) REFERENCES Servicios(idServicio);
GO


--llaves medicamentos
ALTER TABLE Medicamentos
ADD CONSTRAINT FK_Medicamentos_Presentacion
FOREIGN KEY (idPresentacion) REFERENCES PresentacionMed(idPresentacion);
GO

--Llaves muchos a muchos
ALTER TABLE RECETAMEDICAMENTOS
ADD CONSTRAINT FK_RECETAMEDICAMENTOS_Recetas
FOREIGN KEY (idReceta) REFERENCES Recetas(idReceta);
GO

ALTER TABLE RECETAMEDICAMENTOS
ADD CONSTRAINT FK_RECETAMEDICAMENTOS_Medicamentos
FOREIGN KEY (idMedicamento) REFERENCES Medicamentos(idMedicamento);
GO

--Llaves foraneas consultas
ALTER TABLE Consultas
ADD CONSTRAINT FK_Consultas_Citas
FOREIGN KEY (idCita) REFERENCES Citas(idCita);
GO


--Llaves foraneas de Recetas 
ALTER TABLE Recetas
ADD CONSTRAINT FK_Recetas_Consultas
FOREIGN KEY (idConsulta) REFERENCES Consultas(idConsulta);
GO

--Llaves foraneas inventario
ALTER TABLE Inventario
ADD CONSTRAINT FK_Inventario_Medicamentos
FOREIGN KEY (idMedicamento) REFERENCES Medicamentos(idMedicamento);
GO

CREATE TABLE Sinaloa(
	d_codigo int NULL,
	d_asenta nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	d_tipo_asenta nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	D_mnpio nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	d_estado nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	d_ciudad nvarchar(100) COLLATE Modern_Spanish_CI_AS NULL,
	d_CP int NULL,
	c_estado int NULL,
	c_oficina int NULL,
	c_CP int NULL,
	c_tipo_asenta int NULL,
	c_mnpio int NULL,
	id_asenta_cpcons int NULL,
	d_zona nvarchar(50) COLLATE Modern_Spanish_CI_AS NULL,
	c_cve_ciudad int NULL
);
GO

INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80000,N'Centro',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,1,N'Urbano',2),
	 (80000,N'Centro Sinaloa',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,525,N'Urbano',2),
	 (80010,N'Arboledas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,9,N'Urbano',2),
	 (80010,N'Ignacio Allende',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,11,N'Urbano',2),
	 (80010,N'6 de Enero',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,12,N'Urbano',2),
	 (80010,N'Vicente Lombardo Toledano',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,13,N'Urbano',2),
	 (80010,N'Villa Universidad',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,14,N'Urbano',2),
	 (80010,N'Los Sabinos Tres R�os',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,496,N'Urbano',2),
	 (80010,N'Fresnos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2023,N'Urbano',2),
	 (80010,N'Espacios Marsella',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2808,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80013,N'Ciudad Universitaria',N'Equipamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,17,6,16,N'Urbano',2),
	 (80013,N'Obrero Campesino',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,17,N'Urbano',2),
	 (80013,N'Universitaria',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,18,N'Urbano',2),
	 (80014,N'Agrarista Mexicana',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,19,N'Urbano',2),
	 (80014,N'Buena Vista',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,20,N'Urbano',2),
	 (80014,N'Rosario Uzarraga',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,21,N'Urbano',2),
	 (80014,N'Zona Dorada II',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,45,N'Urbano',2),
	 (80014,N'Valle del Agua',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,280,N'Urbano',2),
	 (80014,N'Amorada',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,287,N'Urbano',2),
	 (80014,N'Sfera Residencial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,295,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80014,N'Portabelo',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,299,N'Urbano',2),
	 (80014,N'Albaterra',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,303,N'Urbano',2),
	 (80014,N'Benevento Residencial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,319,N'Urbano',2),
	 (80014,N'Lomas Verdes',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,499,N'Urbano',2),
	 (80014,N'Gran V�a',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,529,N'Urbano',2),
	 (80014,N'V�a San Jos�',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,531,N'Urbano',2),
	 (80014,N'Lomas de Tamazula',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,544,N'Urbano',2),
	 (80014,N'Acanto',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,548,N'Urbano',2),
	 (80014,N'Ampliaci�n los �ngeles',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,549,N'Urbano',2),
	 (80014,N'Portabelo III',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,551,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80014,N'Provenza',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,557,N'Urbano',2),
	 (80014,N'Palmanova',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,558,N'Urbano',2),
	 (80014,N'Jard�n Real',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,560,N'Urbano',2),
	 (80014,N'San Jos�',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,561,N'Urbano',2),
	 (80014,N'Las �guilas',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,563,N'Urbano',2),
	 (80014,N'Palos Altos',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,564,N'Urbano',2),
	 (80014,N'Los Angeles',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1345,N'Urbano',2),
	 (80014,N'Nueva Galaxia',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,1346,N'Urbano',2),
	 (80014,N'Floresta',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2155,N'Urbano',2),
	 (80014,N'Las Glorias',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2320,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80014,N'Maralago',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2809,N'Urbano',2),
	 (80014,N'Zona Dorada',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2994,N'Urbano',2),
	 (80015,N'Lomas de San Jer�nimo',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,3,N'Urbano',2),
	 (80015,N'Campestre',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,23,N'Urbano',2),
	 (80015,N'Ruben Jaramillo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,24,N'Urbano',2),
	 (80015,N'Solidaridad',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,25,N'Urbano',2),
	 (80015,N'Villa Del Sol',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,26,N'Urbano',2),
	 (80015,N'Lomas Del Magisterio',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,545,N'Urbano',2),
	 (80015,N'Grecia',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,1341,N'Urbano',2),
	 (80015,N'Residencial Hacienda',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2047,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80016,N'16 de Septiembre',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,28,N'Urbano',2),
	 (80016,N'Juan de Dios B�tiz',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,29,N'Urbano',2),
	 (80016,N'Lomas Del Pedregal',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,30,N'Urbano',2),
	 (80016,N'Lomas del Sol',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,31,N'Urbano',2),
	 (80016,N'Las Am�ricas',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,517,N'Urbano',2),
	 (80016,N'Lomas del Sol Duplex',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2156,N'Urbano',2),
	 (80016,N'Interlomas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2960,N'Urbano',2),
	 (80017,N'El Mirador',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,34,N'Urbano',2),
	 (80017,N'Jes�s Valdez Aldana',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,35,N'Urbano',2),
	 (80017,N'Montesierra',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,36,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80018,N'Las Cucas',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,37,N'Urbano',2),
	 (80018,N'Los Alamitos',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,38,N'Urbano',2),
	 (80018,N'Lirios del R�o',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2035,N'Urbano',2),
	 (80018,N'Bosques Del �lamo',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2150,N'Urbano',2),
	 (80019,N'Los Ciruelos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,4,N'Urbano',2),
	 (80019,N'Hacienda Alameda',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,5,N'Urbano',2),
	 (80019,N'Loma de Rodriguera',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,39,N'Urbano',2),
	 (80019,N'Los Mezcales',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,40,N'Urbano',2),
	 (80019,N'Hacienda los Huertos Secci�n Bosques de la Colina',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,268,N'Urbano',2),
	 (80019,N'Las Cerezas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,308,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80019,N'Mont Alto',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,323,N'Urbano',2),
	 (80019,N'Bicentenario',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,379,N'Urbano',2),
	 (80019,N'Las Amapas',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,387,N'Urbano',2),
	 (80019,N'Alameda',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,515,N'Urbano',2),
	 (80019,N'Los Mezcales Residencial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,535,N'Urbano',2),
	 (80019,N'Las Cerezas II',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,539,N'Urbano',2),
	 (80019,N'Los Huertos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,547,N'Urbano',2),
	 (80019,N'Cantaluna',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,565,N'Urbano',2),
	 (80019,N'Girasoles',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,1340,N'Urbano',2),
	 (80019,N'Jardines de La Sierra',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1343,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80019,N'Paseo Alameda',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1347,N'Urbano',2),
	 (80019,N'Hacienda Arboledas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2311,N'Urbano',2),
	 (80019,N'Rotarismo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,2811,N'Urbano',2),
	 (80019,N'Hacienda Los Huertos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2812,N'Urbano',2),
	 (80019,N'San Ferm�n',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,3039,N'Urbano',2),
	 (80020,N'FOVISSSTE Diamante',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,41,N'Urbano',2),
	 (80020,N'Humaya',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,42,N'Urbano',2),
	 (80020,N'INFONAVIT Humaya',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,43,N'Urbano',2),
	 (80020,N'STASE',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,44,N'Urbano',2),
	 (80020,N'Torres del R�o',N'Condominio',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,10,6,365,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80020,N'Tres R�os',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1351,N'Urbano',2),
	 (80020,N'STASE III',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2024,N'Urbano',2),
	 (80020,N'Privada La Rivera',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2151,N'Urbano',2),
	 (80020,N'Bonanza',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2152,N'Urbano',2),
	 (80020,N'Pueblo Bonito',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2153,N'Urbano',2),
	 (80025,N'Villa del Pedregal',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,15,N'Urbano',2),
	 (80025,N'Brisas de Humaya',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,47,N'Urbano',2),
	 (80025,N'Los Olivos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,48,N'Urbano',2),
	 (80025,N'Nueva Vizcaya',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,49,N'Urbano',2),
	 (80025,N'STASE II',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,50,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80025,N'Bosques del Humaya',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,106,N'Urbano',2),
	 (80025,N'Colinas de la Rivera Segunda Secci�n',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,267,N'Urbano',2),
	 (80025,N'Jardines del Rey',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,277,N'Urbano',2),
	 (80025,N'Riberas del Humaya',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1358,N'Urbano',2),
	 (80025,N'Jardines Del Pedregal',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2031,N'Urbano',2),
	 (80025,N'Colinas de La Rivera',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2097,N'Urbano',2),
	 (80025,N'Las Canarias',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2202,N'Urbano',2),
	 (80025,N'Villas del Humaya',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2522,N'Urbano',2),
	 (80025,N'Alegranza',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2820,N'Urbano',2),
	 (80025,N'La Ribera Residencial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2821,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80025,N'Humaya del Super',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2822,N'Urbano',2),
	 (80026,N'ISSSTESIN',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,51,N'Urbano',2),
	 (80027,N'Cuauht�moc',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,52,N'Urbano',2),
	 (80027,N'Campestre Los Laureles',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,53,N'Urbano',2),
	 (80027,N'Lago Tres R�os',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,54,N'Urbano',2),
	 (80027,N'Altamira',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,285,N'Urbano',2),
	 (80027,N'Altamira Secci�n Altana',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,310,N'Urbano',2),
	 (80027,N'Altamira Secci�n Barcel�',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,311,N'Urbano',2),
	 (80027,N'Los Almendros',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2105,N'Urbano',2),
	 (80028,N'Agustina Ramirez',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,55,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80028,N'Los Sauces',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,57,N'Urbano',2),
	 (80028,N'Santa Elena',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,58,N'Urbano',2),
	 (80028,N'Tulipanes',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,59,N'Urbano',2),
	 (80028,N'Villa Fontana',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,60,N'Urbano',2),
	 (80028,N'Portafe',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,282,N'Urbano',2),
	 (80028,N'Balcones Del Humaya',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,519,N'Urbano',2),
	 (80028,N'La Puerta',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,538,N'Urbano',2),
	 (80028,N'La Cascada',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1353,N'Urbano',2),
	 (80028,N'Lomas Verdes',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1355,N'Urbano',2),
	 (80028,N'Rinc�n Real',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1357,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80028,N'Privada La Rinconada',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2524,N'Urbano',2),
	 (80028,N'Villas de Culiac�n',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2823,N'Urbano',2),
	 (80028,N'Campestre Tres R�os',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2829,N'Urbano',2),
	 (80028,N'Portanova',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,3137,N'Urbano',2),
	 (80029,N'Fincas del Humaya',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2,N'Urbano',2),
	 (80029,N'Colinas del Humaya',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,61,N'Urbano',2),
	 (80029,N'10 de Abril',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,62,N'Urbano',2),
	 (80029,N'FOVISSSTE Humaya',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,63,N'Urbano',2),
	 (80029,N'Pedregal del Humaya',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,64,N'Urbano',2),
	 (80029,N'Real de Santa Fe',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,116,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80029,N'Cimas del Humaya',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,175,N'Urbano',2),
	 (80029,N'Joel Ram�rez',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,493,N'Urbano',2),
	 (80029,N'Cibeles',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,498,N'Urbano',2),
	 (80029,N'Heraclio Bernal',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,534,N'Urbano',2),
	 (80029,N'Montserrat',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,536,N'Urbano',2),
	 (80029,N'Fincas de las Colinas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,537,N'Urbano',2),
	 (80029,N'Santa Fe',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,567,N'Urbano',2),
	 (80029,N'Cumbres Tres R�os',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,581,N'Urbano',2),
	 (80029,N'Lomas Del Humaya',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,1354,N'Urbano',2),
	 (80029,N'Secci�n Cumbres',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2511,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80029,N'Jardines de Santa Fe',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2704,N'Urbano',2),
	 (80029,N'Santa Fe Real',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2705,N'Urbano',2),
	 (80029,N'Campestre San Jorge',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,2825,N'Urbano',2),
	 (80029,N'Cumbre Real',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2982,N'Urbano',2),
	 (80029,N'Los Cerritos',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,2996,N'Urbano',2),
	 (80029,N'Santa Rosa',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,2997,N'Urbano',2),
	 (80029,N'Bosque Encinos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,3198,N'Urbano',2),
	 (80030,N'Bur�crata',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,65,N'Urbano',2),
	 (80030,N'Gabriel Leyva',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,66,N'Urbano',2),
	 (80030,N'Tierra Blanca',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,67,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80030,N'Vistanova',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,527,N'Urbano',2),
	 (80030,N'Portales del R�o',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2284,N'Urbano',2),
	 (80030,N'La Jolla',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2285,N'Urbano',2),
	 (80030,N'Riverside',N'Condominio',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,10,6,2318,N'Urbano',2),
	 (80030,N'Parque Alameda',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2319,N'Urbano',2),
	 (80034,N'Comunicadores',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1337,N'Urbano',2),
	 (80034,N'Los Olivos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2715,N'Urbano',2),
	 (80034,N'Los Cisnes',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2728,N'Urbano',2),
	 (80034,N'Rinc�n Alameda',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2813,N'Urbano',2),
	 (80040,N'FOVISSSTE Abelardo de La Torre',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,68,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80040,N'Chapultepec',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,69,N'Urbano',2),
	 (80040,N'La Lima',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,70,N'Urbano',2),
	 (80040,N'Santa Margarita',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,71,N'Urbano',2),
	 (80040,N'Chapultepec Del Rio',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1338,N'Urbano',2),
	 (80040,N'Paseo Del Rio',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1348,N'Urbano',2),
	 (80040,N'Privada Del Real',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1349,N'Urbano',2),
	 (80040,N'Riberas de Tamazula',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1350,N'Urbano',2),
	 (80040,N'Santa Teresa',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2225,N'Urbano',2),
	 (80040,N'Real de Chapultepec',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,2810,N'Urbano',2),
	 (80050,N'Hermanos Flores Mag�n',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,72,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80050,N'Juntas de Humaya',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,73,N'Urbano',2),
	 (80050,N'Villas Del Rio',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,74,N'Urbano',2),
	 (80050,N'La Rioja',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,176,N'Urbano',2),
	 (80050,N'Culiac�n Tres R�os',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,283,N'Urbano',2),
	 (80050,N'Villas de Bacurim� Secci�n Acacia',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,313,N'Urbano',2),
	 (80050,N'Villas de Bacurim� Secci�n Britania',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,320,N'Urbano',2),
	 (80050,N'Country del R�o',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2048,N'Urbano',2),
	 (80050,N'Valle Del Rio',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,2103,N'Urbano',2),
	 (80050,N'Villas Del Rio Elite',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2268,N'Urbano',2),
	 (80050,N'Valle Alto',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2321,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80050,N'Stanza Toscana',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2815,N'Urbano',2),
	 (80050,N'Enrique F�lix Castro',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2817,N'Urbano',2),
	 (80050,N'La Primavera',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,3029,N'Rural',NULL),
	 (80050,N'Avellaneda',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,3038,N'Urbano',2),
	 (80050,N'Prados de Occidente',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,3191,N'Urbano',2),
	 (80054,N'4 de Marzo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,75,N'Urbano',2),
	 (80054,N'Horizontes',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,76,N'Urbano',2),
	 (80054,N'Parque Industrial CANACINTRA I',N'Zona industrial',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,37,6,1356,N'Urbano',2),
	 (80054,N'Montecarlo Residencial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2098,N'Urbano',2),
	 (80054,N'Misiones',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2510,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80054,N'Del Humaya',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2818,N'Urbano',2),
	 (80055,N'Universidad 94 II',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,1359,N'Urbano',2),
	 (80058,N'Pradera Dorada',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,78,N'Urbano',2),
	 (80058,N'Rinc�n Del Humaya',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,79,N'Urbano',2),
	 (80058,N'INFONAVIT Solidaridad',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,80,N'Urbano',2),
	 (80058,N'Universidad 94',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,81,N'Urbano',2),
	 (80058,N'Stanza Castilla',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,291,N'Urbano',2),
	 (80058,N'Conquista del Rey',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,307,N'Urbano',2),
	 (80058,N'Granada',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,317,N'Urbano',2),
	 (80058,N'Bosques del Rey',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,321,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80058,N'Montereal',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,352,N'Urbano',2),
	 (80058,N'Universidad de Occidente',N'Equipamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,17,6,497,N'Urbano',2),
	 (80058,N'San Florencio',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,562,N'Urbano',2),
	 (80058,N'Villas Santa Anita',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,1360,N'Urbano',2),
	 (80058,N'Villas San Antonio',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,1361,N'Urbano',2),
	 (80058,N'Villas Victoria',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,1362,N'Urbano',2),
	 (80058,N'La Conquista',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2030,N'Urbano',2),
	 (80058,N'INFONAVIT FTS',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2033,N'Urbano',2),
	 (80058,N'Praderas Del Rey',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2099,N'Urbano',2),
	 (80058,N'Rancho Contento',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2100,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80058,N'Santa Aynes',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2102,N'Urbano',2),
	 (80058,N'Valle Dorado',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2104,N'Urbano',2),
	 (80058,N'Acueducto',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2148,N'Urbano',2),
	 (80058,N'Pedregal de San Angel',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2323,N'Urbano',2),
	 (80058,N'Azaleas Residencial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2513,N'Urbano',2),
	 (80058,N'Rinc�n Colonial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2655,N'Urbano',2),
	 (80058,N'Prados de La Conquista',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2731,N'Urbano',2),
	 (80058,N'Valencia',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2748,N'Urbano',2),
	 (80058,N'Diamante',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2750,N'Urbano',2),
	 (80058,N'Pradera Dorada II',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2814,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80058,N'9 de Marzo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,2826,N'Urbano',2),
	 (80058,N'Altos Bacurimi',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2827,N'Urbano',2),
	 (80058,N'Villa del Cedro',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2828,N'Urbano',2),
	 (80058,N'Bonaterra',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,3037,N'Urbano',2),
	 (80058,N'Portalegre',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,3094,N'Urbano',2),
	 (80058,N'Urbivilla del Prado',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,3116,N'Urbano',2),
	 (80058,N'Acueducto III',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,3117,N'Urbano',2),
	 (80059,N'CANACO',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,82,N'Urbano',2),
	 (80059,N'Barcelona Secci�n Villa Barcelona',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,301,N'Urbano',2),
	 (80059,N'Barcelona Secci�n Villa Barcelona Etapa II',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,322,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80059,N'Barcelona Secci�n Villa Barcelona Etapa III',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,528,N'Urbano',2),
	 (80059,N'Alcal� del Rey',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,575,N'Urbano',2),
	 (80059,N'Espacios Barcelona',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2745,N'Urbano',2),
	 (80059,N'Praderas del Humaya',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,2824,N'Urbano',2),
	 (80060,N'La Campi�a',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,83,N'Urbano',2),
	 (80060,N'Las Quintas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,84,N'Urbano',2),
	 (80060,N'Aurora',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,86,N'Urbano',2),
	 (80060,N'Periodista',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,87,N'Urbano',2),
	 (80063,N'Los Sabinos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,541,N'Urbano',2),
	 (80063,N'Vi�edos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2021,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80063,N'Amapas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2670,N'Urbano',2),
	 (80063,N'Quinta Americana',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2696,N'Urbano',2),
	 (80063,N'Los Pinos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2697,N'Urbano',2),
	 (80064,N'La Limita de Itaje',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,9,6,85,N'Urbano',2),
	 (80064,N'Massara',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,312,N'Urbano',2),
	 (80064,N'M�naco',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,546,N'Urbano',2),
	 (80064,N'Colinas de la Campi�a',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,553,N'Urbano',2),
	 (80064,N'Colinas del Tamazula',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,556,N'Urbano',2),
	 (80064,N'Haciendas del R�o',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,1342,N'Urbano',2),
	 (80064,N'Verona',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80011,25,80011,NULL,21,6,3138,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80065,N'Pontevedra',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,318,N'Urbano',2),
	 (80065,N'Ban�s 360 Tenerife',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,540,N'Urbano',2),
	 (80065,N'M�sala Isla Bonita',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2503,N'Urbano',2),
	 (80065,N'Ban�s 360 Salduero',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2504,N'Urbano',2),
	 (80065,N'Ban�s 360 Coru�a',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2505,N'Urbano',2),
	 (80070,N'Vicente Guerrero',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,88,N'Urbano',2),
	 (80080,N'El Barrio',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,89,N'Urbano',2),
	 (80080,N'INFONAVIT El Barrio',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,90,N'Urbano',2),
	 (80080,N'Genaro Estrada',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,91,N'Urbano',2),
	 (80080,N'Punto Oriente',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,309,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80088,N'Villa Sat�lite',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,92,N'Urbano',2),
	 (80090,N'Las Vegas',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,93,N'Urbano',2),
	 (80090,N'Miguel Hidalgo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,94,N'Urbano',2),
	 (80093,N'Novena Zona Militar',N'Equipamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,17,6,2961,N'Urbano',2),
	 (80100,N'Los �lamos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,95,N'Urbano',2),
	 (80100,N'Portales Del Country',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,96,N'Urbano',2),
	 (80100,N'Jardines Tres R�os',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,304,N'Urbano',2),
	 (80100,N'Privanzas Natura',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,353,N'Urbano',2),
	 (80100,N'Country �lamos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1366,N'Urbano',2),
	 (80100,N'San �ngel',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2184,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80100,N'Puerta de Hierro',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2196,N'Urbano',2),
	 (80100,N'Los Patios 1',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2197,N'Urbano',2),
	 (80100,N'Las Moras',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2198,N'Urbano',2),
	 (80100,N'Las Dunas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2199,N'Urbano',2),
	 (80100,N'Condesa',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2200,N'Urbano',2),
	 (80100,N'Real del �lamo',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2733,N'Urbano',2),
	 (80100,N'Residencial San Jos�',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2737,N'Urbano',2),
	 (80100,N'Misi�n del �lamo',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2746,N'Urbano',2),
	 (80100,N'Privanzas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2837,N'Urbano',2),
	 (80100,N'La Paloma',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2838,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80100,N'Magnolias Residencial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2839,N'Urbano',2),
	 (80100,N'Santa In�s',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2840,N'Urbano',2),
	 (80100,N'Los Patios 2',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2950,N'Urbano',2),
	 (80103,N'Unidad de Servicios Educativos A Descentralizar',N'Equipamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,17,6,100,N'Urbano',2),
	 (80104,N'Las Flores',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,101,N'Urbano',2),
	 (80104,N'Real Del Country',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,102,N'Urbano',2),
	 (80104,N'Floresta Tres R�os',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,316,N'Urbano',2),
	 (80104,N'Tabachines',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2046,N'Urbano',2),
	 (80104,N'Palermo',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2716,N'Urbano',2),
	 (80104,N'Las Flores',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2717,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80105,N'Recursos Hidr�ulicos',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,97,N'Urbano',2),
	 (80105,N'Vallado Viejo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,2962,N'Urbano',2),
	 (80106,N'Bloom',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,526,N'Urbano',2),
	 (80106,N'Central Internacional Milenium',N'Zona comercial',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,33,6,2390,N'Urbano',2),
	 (80106,N'La Cantera',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2755,N'Urbano',2),
	 (80107,N'Country Courts',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2841,N'Urbano',2),
	 (80107,N'Country Tres R�os',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,3092,N'Urbano',2),
	 (80109,N'Unidad de Servicios Estatales',N'Equipamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,17,6,2389,N'Urbano',2),
	 (80110,N'El Vallado',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,103,N'Urbano',2),
	 (80110,N'Francisco Villa',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,104,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80110,N'Lomas del Boulevard',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,105,N'Urbano',2),
	 (80120,N'Industrial Bravo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,107,N'Urbano',2),
	 (80120,N'Popular',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,108,N'Urbano',2),
	 (80128,N'Los Pinos',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,109,N'Urbano',2),
	 (80130,N'Aeropuerto',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,111,N'Urbano',2),
	 (80130,N'Altos de Bachigualato',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1384,N'Urbano',2),
	 (80130,N'Bachigualato',N'Unidad habitacional',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,31,6,1386,N'Urbano',2),
	 (80130,N'Los Helechos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2507,N'Urbano',2),
	 (80130,N'Villa Andaluc�a',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2671,N'Urbano',2),
	 (80135,N'Nuevo Bachigualato',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1387,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80135,N'San Javier',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1390,N'Urbano',2),
	 (80135,N'Santa Rocio',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,1392,N'Urbano',2),
	 (80135,N'Joyas del Valle',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2288,N'Urbano',2),
	 (80139,N'Culiac�n (Culiac�n)',N'Aeropuerto',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,1,6,112,N'Urbano',2),
	 (80140,N'Bachigualato',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,113,N'Urbano',2),
	 (80140,N'Campo Bello',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,1385,N'Urbano',2),
	 (80140,N'Villas de Cort�s',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,1393,N'Urbano',2),
	 (80140,N'Para�so',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,1394,N'Urbano',2),
	 (80140,N'San Diego',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,1395,N'Urbano',2),
	 (80140,N'Las Ma�anitas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2165,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80140,N'San Luis Residencial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2166,N'Urbano',2),
	 (80140,N'Villas Del Manantial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2167,N'Urbano',2),
	 (80140,N'Danubio',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2170,N'Urbano',2),
	 (80140,N'Las Terrazas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2192,N'Urbano',2),
	 (80140,N'Valle Bonito',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2252,N'Urbano',2),
	 (80140,N'Campo El Cardenal I',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80307,25,80307,NULL,15,6,2600,N'Rural',NULL),
	 (80140,N'Las Alondras',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2722,N'Urbano',2),
	 (80140,N'Real San �ngel',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2846,N'Urbano',2),
	 (80140,N'Paseos del Valle',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,3063,N'Urbano',2),
	 (80140,N'San Luis Residencial II',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,3196,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80143,N'Terranova',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,114,N'Urbano',2),
	 (80143,N'Parque Industrial La Costa',N'Zona industrial',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,37,6,324,N'Urbano',2),
	 (80143,N'Privadas la Estancia',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,1388,N'Urbano',2),
	 (80143,N'Santa B�rbara',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,1391,N'Urbano',2),
	 (80143,N'Valles Del Sol',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2168,N'Urbano',2),
	 (80143,N'Real San Sebasti�n',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2847,N'Urbano',2),
	 (80144,N'Torres Aeropuerto',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,115,N'Urbano',2),
	 (80145,N'Parque Industrial Ori�n',N'Zona industrial',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,37,6,278,N'Urbano',2),
	 (80145,N'Stanza Solare',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,298,N'Urbano',2),
	 (80145,N'Roma Residencial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,314,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80145,N'Bugambilias',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2041,N'Urbano',2),
	 (80145,N'Hacienda de La Mora',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2164,N'Urbano',2),
	 (80145,N'Privada Real del Valle',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2500,N'Urbano',2),
	 (80145,N'Versalles',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2653,N'Urbano',2),
	 (80145,N'Valles Espa�oles',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2754,N'Urbano',2),
	 (80145,N'Torre Dorada',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,2845,N'Urbano',2),
	 (80145,N'Residencial Santa Sof�a',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,21,6,3036,N'Urbano',2),
	 (80150,N'San Rafael',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,118,N'Urbano',2),
	 (80150,N'Parque Industrial CANACINTRA II',N'Zona industrial',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,37,6,1374,N'Urbano',2),
	 (80150,N'Palmillas Residencial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2654,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80150,N'Rinc�n Las Palmas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2739,N'Urbano',2),
	 (80150,N'Palma Dorada',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2747,N'Urbano',2),
	 (80150,N'Rinc�n San Rafael',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2842,N'Urbano',2),
	 (80155,N'Rinc�n del Valle',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,119,N'Urbano',2),
	 (80155,N'Fuentes Del Valle',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1370,N'Urbano',2),
	 (80155,N'Hacienda Molino de Flores',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2161,N'Urbano',2),
	 (80159,N'INFONAVIT Las Flores',N'Unidad habitacional',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,31,6,120,N'Urbano',2),
	 (80159,N'Las Palmas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,121,N'Urbano',2),
	 (80159,N'Villa Contenta',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,122,N'Urbano',2),
	 (80159,N'Villa Serena',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2751,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80160,N'Industrial El Palmito',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,123,N'Urbano',2),
	 (80160,N'Salvador Alvarado',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,124,N'Urbano',2),
	 (80170,N'Morelos',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,125,N'Urbano',2),
	 (80170,N'Nuevo Culiac�n',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,126,N'Urbano',2),
	 (80170,N'Virreyes SC',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,127,N'Urbano',2),
	 (80170,N'ISSSTE Insurgentes',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,2032,N'Urbano',2),
	 (80176,N'Balcones de San Miguel',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,128,N'Urbano',2),
	 (80176,N'Colinas Del Parque',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,129,N'Urbano',2),
	 (80177,N'Loma Linda',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,130,N'Urbano',2),
	 (80177,N'Colina del Rey',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2034,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80177,N'Privada Del Rey',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2160,N'Urbano',2),
	 (80177,N'Misi�n San Fernando',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2307,N'Urbano',2),
	 (80177,N'La C�spide',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2835,N'Urbano',2),
	 (80177,N'Altezza',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2836,N'Urbano',2),
	 (80178,N'Ca�adas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,131,N'Urbano',2),
	 (80178,N'Las Palomas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,132,N'Urbano',2),
	 (80178,N'San Carlos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,133,N'Urbano',2),
	 (80178,N'Victoria',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2738,N'Urbano',2),
	 (80179,N'INFONAVIT Ca�adas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,134,N'Urbano',2),
	 (80179,N'Lomas del Bosque',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,135,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80179,N'La Ventana',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,136,N'Urbano',2),
	 (80180,N'Gustavo D�az Ordaz',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,138,N'Urbano',2),
	 (80180,N'Libertad',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,139,N'Urbano',2),
	 (80180,N'Loma Bonita',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,140,N'Urbano',2),
	 (80180,N'Paseo de los Arcos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,141,N'Urbano',2),
	 (80180,N'PEMEX',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,142,N'Urbano',2),
	 (80180,N'Paseos del Rey',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,288,N'Urbano',2),
	 (80180,N'Los Girasoles',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1372,N'Urbano',2),
	 (80180,N'Los Portales',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1373,N'Urbano',2),
	 (80180,N'Santa Clara',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1382,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80180,N'Parque Industrial Nueva Estaci�n',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2963,N'Urbano',2),
	 (80184,N'Balcones Del Valle',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,143,N'Urbano',2),
	 (80184,N'INFONAVIT Barrancos II',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,144,N'Urbano',2),
	 (80184,N'INFONAVIT Barrancos III',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,145,N'Urbano',2),
	 (80184,N'INFONAVIT Barrancos IV',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,146,N'Urbano',2),
	 (80184,N'Casas Lindas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,147,N'Urbano',2),
	 (80184,N'San Agustin',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,148,N'Urbano',2),
	 (80184,N'Villa Verde',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,149,N'Urbano',2),
	 (80184,N'Vinoramas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,150,N'Urbano',2),
	 (80184,N'Mont Blanc',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,290,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80184,N'Dos Puntas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,292,N'Urbano',2),
	 (80184,N'Belcantto',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,302,N'Urbano',2),
	 (80184,N'Centenario',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1365,N'Urbano',2),
	 (80184,N'Del Camino',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1368,N'Urbano',2),
	 (80184,N'San Cipriano',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1380,N'Urbano',2),
	 (80184,N'San Sebasti�n',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1381,N'Urbano',2),
	 (80184,N'Santa Susana',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2019,N'Urbano',2),
	 (80184,N'Villa Dorada',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,2022,N'Urbano',2),
	 (80184,N'Rinc�n Santa Rosa',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2159,N'Urbano',2),
	 (80184,N'Casa Blanca',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2523,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80184,N'Villa del Roble',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2707,N'Urbano',2),
	 (80189,N'INFONAVIT Barrancos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,152,N'Urbano',2),
	 (80189,N'Jardines Del Valle',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,153,N'Urbano',2),
	 (80189,N'Miravalle',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,154,N'Urbano',2),
	 (80189,N'Villa Colonial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,155,N'Urbano',2),
	 (80189,N'El Olivar',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2157,N'Urbano',2),
	 (80189,N'Azucena',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2158,N'Urbano',2),
	 (80190,N'Adolfo Lopez Mateos',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,156,N'Urbano',2),
	 (80190,N'Aquiles Serd�n',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,157,N'Urbano',2),
	 (80190,N'Independencia',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,158,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80190,N'Josefa Ortiz de Dominguez',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,159,N'Urbano',2),
	 (80190,N'Adolfo Ruiz Cortinez',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,160,N'Urbano',2),
	 (80194,N'Domingo Rub�',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,161,N'Urbano',2),
	 (80194,N'Ferrocarrilera',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,162,N'Urbano',2),
	 (80194,N'Antonio Nakayama',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,163,N'Urbano',2),
	 (80194,N'Plutarco Elias Calles',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,164,N'Urbano',2),
	 (80194,N'Chulavista',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1367,N'Urbano',2),
	 (80194,N'Finisterra',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1369,N'Urbano',2),
	 (80194,N'Real Del Parque',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1377,N'Urbano',2),
	 (80194,N'Urbi Villa del Sol',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2512,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80194,N'Capistrano Residencial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2514,N'Urbano',2),
	 (80194,N'Lomas Para�so',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2672,N'Urbano',2),
	 (80194,N'Colinas del Sol',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2732,N'Urbano',2),
	 (80194,N'Prados Residencial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2843,N'Urbano',2),
	 (80194,N'Valle de Amapa',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,3064,N'Urbano',2),
	 (80197,N'Esthela Ortiz de Toledo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,165,N'Urbano',2),
	 (80197,N'Felipe �ngeles',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,166,N'Urbano',2),
	 (80197,N'Valle de Encino',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,265,N'Urbano',2),
	 (80197,N'Parque Andares',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,294,N'Urbano',2),
	 (80197,N'Perisur II',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,533,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80197,N'Lomas de San Isidro',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1371,N'Urbano',2),
	 (80197,N'Prados Del Sol',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1375,N'Urbano',2),
	 (80197,N'Rinc�n Del Parque',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1379,N'Urbano',2),
	 (80197,N'Hacienda Del Valle',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2162,N'Urbano',2),
	 (80197,N'Progreso',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,2254,N'Urbano',2),
	 (80197,N'Valle Real',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2502,N'Urbano',2),
	 (80197,N'Lomas de San Isidro Secci�n Paseo Azteca',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2673,N'Urbano',2),
	 (80197,N'Esmeralda Life',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2674,N'Urbano',2),
	 (80197,N'Colinas del Bosque',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2979,N'Urbano',2),
	 (80197,N'Ib�rica',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2980,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80197,N'Perisur',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,3078,N'Urbano',2),
	 (80197,N'Lomas de San Isidro Secci�n Cumbres del Sur',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,3192,N'Urbano',2),
	 (80199,N'Amado Nervo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,167,N'Urbano',2),
	 (80199,N'Buenos Aires',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,168,N'Urbano',2),
	 (80199,N'Francisco I. Madero',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,170,N'Urbano',2),
	 (80199,N'Francisco Labastida Ochoa',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,171,N'Urbano',2),
	 (80199,N'22 de Diciembre',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,172,N'Urbano',2),
	 (80199,N'Barrio San Jos�',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,188,N'Urbano',2),
	 (80199,N'Barrio San Francisco',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,229,N'Urbano',2),
	 (80199,N'La Primavera Secci�n Parque Industrial',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,315,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80199,N'Barrio San Pablo',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,576,N'Urbano',2),
	 (80199,N'Barrio San Juan',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,578,N'Urbano',2),
	 (80199,N'Barrio San Eugenio',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,579,N'Urbano',2),
	 (80199,N'Barrio San Miguel',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,580,N'Urbano',2),
	 (80199,N'Diana Laura Riojas de Colosio',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,1333,N'Urbano',2),
	 (80199,N'Francisco Alarcon Fregoso',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,1334,N'Urbano',2),
	 (80199,N'Renato Vega Alvarado',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,9,6,1378,N'Urbano',2),
	 (80199,N'Villa Bonita',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,1383,N'Urbano',2),
	 (80199,N'La Primavera',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2028,N'Urbano',2),
	 (80199,N'Barrio San Agust�n',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2830,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80199,N'Campos El�seos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2831,N'Urbano',2),
	 (80199,N'Barrio de San Luis',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2832,N'Urbano',2),
	 (80199,N'Isla del Oeste',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2833,N'Urbano',2),
	 (80199,N'Barrio de San Anselmo',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,2834,N'Urbano',2),
	 (80199,N'Real de Minas',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80005,25,80005,NULL,21,6,3075,N'Urbano',2),
	 (80200,N'Jorge Almada',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,173,N'Urbano',2),
	 (80200,N'Miguel Alem�n',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,174,N'Urbano',2),
	 (80210,N'Benito Ju�rez',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,177,N'Urbano',2),
	 (80220,N'Guadalupe',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,178,N'Urbano',2),
	 (80225,N'Instituto Tecnol�gico Regional de Culiac�n',N'Equipamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,17,6,179,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80227,N'Montebello',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,181,N'Urbano',2),
	 (80227,N'Montebello Secci�n Dal�',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,306,N'Urbano',2),
	 (80228,N'Colinas de San Miguel',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,182,N'Urbano',2),
	 (80230,N'Antonio Rosales',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,183,N'Urbano',2),
	 (80230,N'5 de Mayo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,184,N'Urbano',2),
	 (80230,N'Melchor Ocampo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,185,N'Urbano',2),
	 (80240,N'Guadalupe Victoria',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,186,N'Urbano',2),
	 (80240,N'San Juan',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,187,N'Urbano',2),
	 (80246,N'Banjercito',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,189,N'Urbano',2),
	 (80246,N'Florida',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,190,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80246,N'Laureles Pinos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,191,N'Urbano',2),
	 (80246,N'San Benito',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,192,N'Urbano',2),
	 (80246,N'Vista Hermosa',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,193,N'Urbano',2),
	 (80246,N'Laureles',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,542,N'Urbano',2),
	 (80246,N'Las Coloradas',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,2988,N'Urbano',2),
	 (80247,N'5 de Febrero',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,194,N'Urbano',2),
	 (80247,N'7 Gotas',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,195,N'Urbano',2),
	 (80247,N'Portareal',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,284,N'Urbano',2),
	 (80247,N'Torralba',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,286,N'Urbano',2),
	 (80247,N'Villa Del Real',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,577,N'Urbano',2);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80247,N'San Valentino',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,1364,N'Urbano',2),
	 (80247,N'Camino Real',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2508,N'Urbano',2),
	 (80247,N'Florenza',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,3031,N'Urbano',2),
	 (80248,N'La Esperanza',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,197,N'Urbano',2),
	 (80248,N'Revoluci�n',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,198,N'Urbano',2),
	 (80248,N'Rinc�n Feliz',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,559,N'Urbano',2),
	 (80248,N'Servidor Publico Municipal',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,569,N'Urbano',2),
	 (80249,N'Campesina El Barrio',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,199,N'Urbano',2),
	 (80249,N'Constituci�n CROC',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,200,N'Urbano',2),
	 (80249,N'El Pipila',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,201,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80249,N'La Amistad',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,202,N'Urbano',2),
	 (80249,N'Ampliaci�n El Barrio',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,2807,N'Urbano',2),
	 (80250,N'Lomas de Guadalupe',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,203,N'Urbano',2),
	 (80260,N'Emiliano Zapata',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,204,N'Urbano',2),
	 (80260,N'Rafael Buelna',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,205,N'Urbano',2),
	 (80260,N'Sinaloa',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,206,N'Urbano',2),
	 (80270,N'10 de Mayo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,207,N'Urbano',2),
	 (80270,N'Margarita',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,208,N'Urbano',2),
	 (80279,N'Rep�blica Mexicana',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,209,N'Urbano',2),
	 (80280,N'Mezquitillo',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,210,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80280,N'21 de Marzo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,211,N'Urbano',2),
	 (80280,N'Renato Vega Amador',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,555,N'Urbano',2),
	 (80280,N'Estrella Nueva Galicia',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,1363,N'Urbano',2),
	 (80280,N'La Cascada',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,3032,N'Urbano',2),
	 (80290,N'Las Huertas',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,212,N'Urbano',2),
	 (80290,N'L�zaro C�rdenas',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,213,N'Urbano',2),
	 (80290,N'Simon Bol�var',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,215,N'Urbano',2),
	 (80290,N'Providencia',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,1336,N'Urbano',2),
	 (80294,N'Uni�n Antorchista',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,276,N'Urbano',2),
	 (80294,N'C�rcega',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,289,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80294,N'Vistas del Lago',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,510,N'Urbano',2),
	 (80294,N'Vistas del Lago la Primavera',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,543,N'Urbano',2),
	 (80294,N'Mi Ranchito',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,571,N'Urbano',2),
	 (80294,N'Barrio San Alberto',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,572,N'Urbano',2),
	 (80294,N'C�rcega Elite',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,573,N'Urbano',2),
	 (80294,N'El Ranchito',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,2069,N'Urbano',2),
	 (80294,N'Jes�s Manuel Camez Valdez',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,2509,N'Urbano',2),
	 (80294,N'Costa del Sol',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2949,N'Urbano',2),
	 (80295,N'Las Ilusiones',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,216,N'Rural',2),
	 (80295,N'Miguel de La Madrid',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,217,N'Rural',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80295,N'Nueva Galicia',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,552,N'Urbano',2),
	 (80295,N'Senderos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,566,N'Urbano',2),
	 (80295,N'Umbrales',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,568,N'Urbano',2),
	 (80295,N'Altaria',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,570,N'Urbano',2),
	 (80295,N'Alturas del Sur',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,2998,N'Urbano',2),
	 (80296,N'Antonio Toledo Corro',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,218,N'Urbano',2),
	 (80296,N'12 de Diciembre',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,220,N'Urbano',2),
	 (80296,N'La Costera',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,221,N'Urbano',2),
	 (80296,N'8 de Febrero',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,222,N'Urbano',2),
	 (80296,N'Prados Del Sur',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,21,6,1335,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80297,N'CNOP',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,223,N'Urbano',2),
	 (80297,N'Nuevo M�xico',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,224,N'Urbano',2),
	 (80298,N'Huizaches',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,9,6,225,N'Urbano',2),
	 (80299,N'Mercado de Abastos',N'Zona comercial',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80001,25,80001,NULL,33,6,226,N'Urbano',2),
	 (80300,N'Culiacancito',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,227,N'Rural',NULL),
	 (80300,N'Estaci�n Rosales',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,243,N'Rural',NULL),
	 (80300,N'El Venadillo',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,437,N'Rural',NULL),
	 (80300,N'El Alto de Culiacancito',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,471,N'Rural',NULL),
	 (80300,N'El Quince',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,483,N'Rural',NULL),
	 (80300,N'La Platanera (El Pizal)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,486,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80300,N'El Pinole',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,2594,N'Rural',NULL),
	 (80301,N'Bellavista',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,232,N'Rural',NULL),
	 (80301,N'Cantabria',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,21,6,296,N'Urbano',NULL),
	 (80301,N'La Higuerita (Las Higueras de Culiac�n)',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,300,N'Rural',NULL),
	 (80301,N'Las Brisas',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,465,N'Rural',NULL),
	 (80301,N'Hacienda Santa Clara',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,21,6,530,N'Urbano',NULL),
	 (80301,N'Latitud Norte',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,21,6,532,N'Rural',NULL),
	 (80301,N'La Presita',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,2422,N'Rural',NULL),
	 (80301,N'Bacurimi',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,2601,N'Rural',NULL),
	 (80301,N'Huertos del Pedregal',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,21,6,2725,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80301,N'Campo Morelia',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,2727,N'Rural',NULL),
	 (80302,N'La Campana',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,233,N'Rural',NULL),
	 (80302,N'La Higuera',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,234,N'Rural',NULL),
	 (80302,N'Las Higueras',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,441,N'Rural',NULL),
	 (80303,N'Adolfo Lopez Mateos',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,235,N'Rural',NULL),
	 (80303,N'Estaci�n Vitaruto',N'Rancho',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,48,6,274,N'Rural',NULL),
	 (80303,N'Campo San Emilio',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,2602,N'Rural',NULL),
	 (80304,N'Acapulco',N'Rancho',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,48,6,236,N'Rural',NULL),
	 (80304,N'La Higuerita',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,237,N'Rural',NULL),
	 (80304,N'Paredones',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,238,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80304,N'Dos Arroyos',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,472,N'Rural',NULL),
	 (80305,N'La Palmita y Anexos (La Presita)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,239,N'Rural',NULL),
	 (80305,N'El Lim�n de los Ramos',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,240,N'Rural',NULL),
	 (80305,N'Palos Blancos',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,241,N'Rural',NULL),
	 (80305,N'El Tecomate',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,351,N'Rural',NULL),
	 (80305,N'Mojolo',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,443,N'Rural',NULL),
	 (80305,N'La Boca',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,456,N'Rural',NULL),
	 (80305,N'La Gu�sima',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,459,N'Rural',NULL),
	 (80305,N'El Sif�n',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,2957,N'Rural',NULL),
	 (80308,N'Aguaruto Centro',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,245,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80308,N'Campo Morole�n',N'Zona industrial',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,37,6,444,N'Urbano',2),
	 (80308,N'Los �lamos',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,521,N'Urbano',2),
	 (80308,N'Villarreal (Las Coloradas)',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,524,N'Urbano',2),
	 (80308,N'20 de Noviembre',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1667,N'Urbano',2),
	 (80308,N'Demetrio Vallejo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1668,N'Urbano',2),
	 (80308,N'Agustina Ramirez',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1669,N'Urbano',2),
	 (80308,N'Villegas',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1670,N'Urbano',2),
	 (80308,N'Jardines de San Bartolome',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1671,N'Urbano',2),
	 (80308,N'Nueva',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1672,N'Urbano',2),
	 (80308,N'Miguel Hidalgo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1674,N'Urbano',2);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80308,N'Las Palmas',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1859,N'Urbano',2),
	 (80308,N'La Compuerta',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1860,N'Urbano',2),
	 (80308,N'Rosita',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1861,N'Urbano',2),
	 (80308,N'Aguaruto Viejo',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1862,N'Urbano',2),
	 (80308,N'La Ceiba',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,1863,N'Urbano',2),
	 (80308,N'Presidentes de M�xico',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,2018,N'Urbano',2),
	 (80308,N'Luis Donaldo Colosio',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,2169,N'Urbano',2),
	 (80308,N'Campo Bat�n',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,3018,N'Urbano',2),
	 (80308,N'Las Amapas',N'Colonia',N'Culiac�n',N'Sinaloa',N'Culiac�n Rosales',80307,25,80307,NULL,9,6,3061,N'Urbano',2),
	 (80309,N'Colinas de San Antonio',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'',80307,25,80307,NULL,21,6,246,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80309,N'El Alto del Coyote',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80307,25,80307,NULL,29,6,488,N'Rural',NULL),
	 (80309,N'Campo San Javier',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80307,25,80307,NULL,15,6,2625,N'Rural',NULL),
	 (80310,N'Jes�s Mar�a',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,251,N'Rural',NULL),
	 (80311,N'Bagrecitos',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,252,N'Rural',NULL),
	 (80311,N'El Guayabito',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,475,N'Rural',NULL),
	 (80313,N'La Anona',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,253,N'Rural',NULL),
	 (80313,N'Los Limones',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,477,N'Rural',NULL),
	 (80313,N'El Limoncito',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,491,N'Rural',NULL),
	 (80314,N'La Huerta',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,350,N'Rural',NULL),
	 (80314,N'Zalate de Los Ibarra',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,2603,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80315,N'La Pitahayita',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80011,25,80011,NULL,29,6,481,N'Rural',NULL),
	 (80315,N'El Paso del Norte (El Pasito)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80011,25,80011,NULL,29,6,3059,N'Rural',NULL),
	 (80316,N'San Rafael',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,254,N'Urbano',NULL),
	 (80316,N'Tecolotes',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,271,N'Urbano',NULL),
	 (80316,N'La Reforma',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,449,N'Urbano',NULL),
	 (80316,N'Las Gu�simas',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,453,N'Urbano',NULL),
	 (80317,N'Tachinolpa',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,255,N'Rural',NULL),
	 (80317,N'El Tepuchito',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,256,N'Rural',NULL),
	 (80318,N'Agua Blanca',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80011,25,80011,NULL,29,6,257,N'Rural',NULL),
	 (80318,N'El Tepuche',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80011,25,80011,NULL,28,6,258,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80318,N'La Pitahayita',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80011,25,80011,NULL,29,6,480,N'Rural',NULL),
	 (80319,N'Agua Caliente de los Monz�n',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80011,25,80011,NULL,29,6,259,N'Rural',NULL),
	 (80320,N'Vegas del R�o',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,46,N'Urbano',7),
	 (80320,N'Navolato Centro',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1578,N'Urbano',7),
	 (80322,N'Nayarit',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1585,N'Urbano',7),
	 (80322,N'Pueblo Nuevo No. 1',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1586,N'Urbano',7),
	 (80322,N'Los Alcanfores',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1587,N'Urbano',7),
	 (80322,N'Manuel �vila Camacho (Obrera)',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1588,N'Urbano',7),
	 (80322,N'Antonio Yamaguchi Gonz�lez',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1592,N'Urbano',7),
	 (80322,N'Jos� Mar�a Mart�nez CTM INFONAVIT',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1593,N'Urbano',7);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80322,N'Los Pinos',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1597,N'Urbano',7),
	 (80322,N'Secciones Hermanas CTM',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1602,N'Urbano',7),
	 (80322,N'Rinc�n de Navolato',N'Fraccionamiento',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,21,18,1603,N'Urbano',7),
	 (80322,N'Pradera Dorada',N'Fraccionamiento',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,21,18,2188,N'Urbano',7),
	 (80323,N'Ampliaci�n Chula Vista',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,48,N'Urbano',7),
	 (80323,N'La Arrocera',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1589,N'Urbano',7),
	 (80323,N'Chula Vista',N'Fraccionamiento',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,21,18,1615,N'Urbano',7),
	 (80324,N'Pueblo Nuevo No. 2 (Los Cochambres)',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1584,N'Urbano',7),
	 (80324,N'Jard�n',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1591,N'Urbano',7),
	 (80324,N'Primavera II',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1598,N'Urbano',7);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80324,N'5 de Febrero',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1599,N'Urbano',7),
	 (80324,N'Primavera I',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1600,N'Urbano',7),
	 (80324,N'La Villita',N'Fraccionamiento',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,21,18,1607,N'Urbano',7),
	 (80324,N'Renato Vega Alvarado',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1608,N'Urbano',7),
	 (80324,N'Amalia Plata',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1609,N'Urbano',7),
	 (80324,N'Solidaridad',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1610,N'Urbano',7),
	 (80324,N'Prodensa',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1611,N'Urbano',7),
	 (80324,N'Salvador Alvarado',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1612,N'Urbano',7),
	 (80324,N'Las Vegas',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1613,N'Urbano',7),
	 (80324,N'Bel�n Torres',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,2079,N'Urbano',7);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80327,N'Ejidal (Los Mangos)',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1579,N'Urbano',7),
	 (80327,N'Los �ngeles',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1580,N'Urbano',7),
	 (80327,N'ISSSTESIN Esperanza',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1581,N'Urbano',7),
	 (80327,N'Coca Cola INFONAVIT',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1582,N'Urbano',7),
	 (80327,N'Alfonso G. Calder�n',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1583,N'Urbano',7),
	 (80327,N'Heriberto Zazueta',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1590,N'Urbano',7),
	 (80327,N'Antonio Bonifant',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1594,N'Urbano',7),
	 (80327,N'Los Aguilares',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1595,N'Urbano',7),
	 (80327,N'Popular',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1596,N'Urbano',7),
	 (80327,N'Alba�iles',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1601,N'Urbano',7);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80327,N'Residencial Santa Mar�a',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1605,N'Urbano',7),
	 (80327,N'Valle Verde',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1606,N'Urbano',7),
	 (80327,N'Ampliaci�n Alfonso G. Calder�n',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,1614,N'Urbano',7),
	 (80327,N'Embotelladoras',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,2080,N'Urbano',7),
	 (80327,N'El Batey',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,2081,N'Urbano',7),
	 (80327,N'La Tener�a',N'Colonia',N'Navolato',N'Sinaloa',N'Navolato',80321,25,80321,NULL,9,18,2082,N'Urbano',7),
	 (80330,N'Campo Cinco Hermanos (Emiliano Zapata)',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,5,N'Rural',NULL),
	 (80330,N'Campo el Chamizal',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,19,N'Rural',NULL),
	 (80330,N'Casa Blanca (�ngeles Dos)',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,22,N'Rural',NULL),
	 (80330,N'La Colonia',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,33,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80330,N'Bachimeto',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,266,N'Rural',NULL),
	 (80330,N'Ciudad de los Ni�os',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,267,N'Rural',NULL),
	 (80330,N'El Bledal',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,268,N'Rural',NULL),
	 (80330,N'El Patag�n',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,269,N'Rural',NULL),
	 (80330,N'Monte Largo',N'Hacienda',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,24,18,270,N'Rural',NULL),
	 (80330,N'Bachoco',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,275,N'Rural',NULL),
	 (80330,N'Campo 5 Hermanos',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,1617,N'Rural',NULL),
	 (80330,N'Casa Blanca',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2346,N'Rural',NULL),
	 (80330,N'Ensenada',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,2367,N'Rural',NULL),
	 (80332,N'Ensenada (Tecomate)',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,7,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80332,N'Macario Gaxiola (El Poblado)',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,23,N'Rural',NULL),
	 (80332,N'Eduwiges',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,32,N'Rural',NULL),
	 (80332,N'Los Pochotes',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,274,N'Rural',NULL),
	 (80332,N'Juan Aldama (El Tigre)',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,276,N'Urbano',NULL),
	 (80332,N'5 de Mayo (Col. El Debate)',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2345,N'Rural',NULL),
	 (80333,N'Constituyentes de Sinaloa',N'Ejido',N'Navolato',N'Sinaloa',N'',81601,25,81601,NULL,15,18,2239,N'Rural',NULL),
	 (80334,N'Campo Paredes Gaxiola',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,41,N'Rural',NULL),
	 (80334,N'El Bols�n',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,277,N'Rural',NULL),
	 (80334,N'Lo de Reyes',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,278,N'Rural',NULL),
	 (80335,N'Limoncito',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,279,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80335,N'El Portugu�s (El Campito)',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2347,N'Rural',NULL),
	 (80336,N'Baricueto 2',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,271,N'Rural',NULL),
	 (80336,N'Las Trancas',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,273,N'Rural',NULL),
	 (80336,N'La Aviaci�n',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,280,N'Rural',NULL),
	 (80336,N'Otameto',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,281,N'Rural',NULL),
	 (80336,N'La Higuerita',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2339,N'Rural',NULL),
	 (80336,N'Monte Calvario',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2340,N'Rural',NULL),
	 (80336,N'Toboloto',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2356,N'Rural',NULL),
	 (80336,N'Campillo Veronica',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2357,N'Rural',NULL),
	 (80336,N'La Vuelta',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2364,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80337,N'Villamoros',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,282,N'Rural',NULL),
	 (80337,N'La Pipima',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2349,N'Rural',NULL),
	 (80338,N'Nuevo Cosal�',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,2,N'Rural',NULL),
	 (80338,N'Bariometo Segundo',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,10,N'Rural',NULL),
	 (80338,N'Ezequiel Leyva (Tacuache)',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,12,N'Rural',NULL),
	 (80338,N'Yameto',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,15,N'Rural',NULL),
	 (80338,N'Alto del Vergel',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,29,N'Rural',NULL),
	 (80338,N'Iraguato',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,283,N'Rural',NULL),
	 (80338,N'Dautillos',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,1618,N'Rural',NULL),
	 (80338,N'El Vergel',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,1619,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80338,N'Lic Alfredo Valdez Montoya',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2303,N'Rural',NULL),
	 (80338,N'La Bandera',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2313,N'Rural',NULL),
	 (80338,N'Primavera',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2341,N'Rural',NULL),
	 (80338,N'El Tetuan Nuevo',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2348,N'Rural',NULL),
	 (80339,N'El Potrero de Sataya',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,285,N'Rural',NULL),
	 (80339,N'Rosa Morada',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2361,N'Rural',NULL),
	 (80345,N'Los Angeles',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,287,N'Rural',NULL),
	 (80346,N'El Diecisiete',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,11,N'Rural',NULL),
	 (80346,N'Campo Lo de Beltr�n',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,31,N'Rural',NULL),
	 (80347,N'San Blas',N'Rancho',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,48,18,1,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80347,N'Santa Fe',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,288,N'Rural',NULL),
	 (80347,N'La Paloma',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,3012,N'Rural',NULL),
	 (80348,N'Caimancito',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,289,N'Rural',NULL),
	 (80348,N'Ca�ada de Guamuchilito',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,2215,N'Rural',NULL),
	 (80348,N'Campo Berl�n ( Berl�n)',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,3013,N'Rural',NULL),
	 (80349,N'Campo El 17',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,291,N'Rural',NULL),
	 (80349,N'Zona Centro Villa �ngel Flores (La Palma)',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,293,N'Urbano',NULL),
	 (80349,N'Nicol�s Bravo',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,1676,N'Urbano',NULL),
	 (80349,N'Benito Ju�rez',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,1677,N'Urbano',NULL),
	 (80349,N'Fidel Guti�rrez',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,1678,N'Urbano',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80349,N'Del Parque',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,1679,N'Urbano',NULL),
	 (80349,N'Vicente Guerrero',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,1680,N'Urbano',NULL),
	 (80349,N'Linda Vista',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,1681,N'Urbano',NULL),
	 (80349,N'Las Palmas',N'Fraccionamiento',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,21,18,2749,N'Urbano',NULL),
	 (80349,N'Luis Donaldo Colosio',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,3027,N'Urbano',NULL),
	 (80349,N'22 de Junio',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,3149,N'Urbano',NULL),
	 (80349,N'Fidel Vel�zquez',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,3150,N'Urbano',NULL),
	 (80349,N'Manuel de Jes�s Clouthier del Rinc�n',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,3151,N'Urbano',NULL),
	 (80349,N'Matzumoto',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,3152,N'Urbano',NULL),
	 (80349,N'Juan S. Mill�n',N'Colonia',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,9,18,3171,N'Urbano',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80360,N'El Castillo',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,294,N'Rural',NULL),
	 (80363,N'Santorini',N'Fraccionamiento',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,21,18,3,N'Rural',NULL),
	 (80363,N'Punta Esmeralda',N'Fraccionamiento',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,21,18,6,N'Rural',NULL),
	 (80363,N'Altata',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,295,N'Rural',NULL),
	 (80365,N'Aguapepito',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,296,N'Rural',NULL),
	 (80365,N'El Realito',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2344,N'Rural',NULL),
	 (80365,N'Las Aguamitas',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,2371,N'Rural',NULL),
	 (80365,N'El Pintor',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,3009,N'Rural',NULL),
	 (80365,N'Laco',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,3067,N'Rural',NULL),
	 (80366,N'Bainoritos',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,13,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80366,N'Los Molinos',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,297,N'Rural',NULL),
	 (80367,N'Batauto (Laguna de Batauto)',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,17,N'Rural',NULL),
	 (80367,N'Agr�cola AGA JBS',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,20,N'Rural',NULL),
	 (80367,N'Sacrificio (El Serrucho)',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,25,N'Rural',NULL),
	 (80367,N'Santa Teresa',N'Zona industrial',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,37,18,43,N'Rural',NULL),
	 (80367,N'P�njamo',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,298,N'Rural',NULL),
	 (80367,N'Santa Alicia (Florisa)',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,299,N'Rural',NULL),
	 (80367,N'Campo Clouthier',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2337,N'Rural',NULL),
	 (80367,N'Santa Elena',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2338,N'Rural',NULL),
	 (80367,N'Agr�cola Chaparral (El Gran Chaparral)',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2343,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80367,N'Campo Sof�a',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2351,N'Rural',NULL),
	 (80367,N'El Cafetal',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2358,N'Rural',NULL),
	 (80367,N'Campo San Jos�',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2359,N'Rural',NULL),
	 (80367,N'Campo Santa Cecilia',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2365,N'Rural',NULL),
	 (80367,N'Alonso',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2366,N'Rural',NULL),
	 (80367,N'Campo Victoria',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,2368,N'Rural',NULL),
	 (80367,N'Las Puentes (Guadalupe Victoria)',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,2369,N'Rural',NULL),
	 (80367,N'San Ra�l',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2958,N'Rural',NULL),
	 (80368,N'El Contrabando (Campo Pesquero)',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,3010,N'Rural',NULL),
	 (80370,N'Sataya',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,301,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80370,N'Plan de Ayala (el Zanjon)',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2342,N'Rural',NULL),
	 (80371,N'Campo Vital (Cofrad�a de la Estancia N�mero Dos)',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,21,N'Rural',NULL),
	 (80371,N'Grupo RR',N'Zona industrial',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,37,18,38,N'Rural',NULL),
	 (80371,N'Agr�cola Yipao',N'Zona industrial',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,37,18,40,N'Rural',NULL),
	 (80371,N'Campo Campa�a',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,303,N'Rural',NULL),
	 (80371,N'La Curva 1',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,304,N'Rural',NULL),
	 (80371,N'La Michoacana',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,305,N'Rural',NULL),
	 (80371,N'Lo de Jes�s',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,306,N'Rural',NULL),
	 (80371,N'Lo de Sauceda',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,307,N'Rural',NULL),
	 (80371,N'Luis G V�lez',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,308,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80371,N'Campo San Isidro',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2360,N'Rural',NULL),
	 (80371,N'Villa Morelos',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,3068,N'Rural',NULL),
	 (80372,N'Campo M�xico y Oriente',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,24,N'Rural',NULL),
	 (80372,N'Los Rieles',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,27,N'Rural',NULL),
	 (80372,N'La Campi�a de San Pedro (La Campi�a)',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,28,N'Rural',NULL),
	 (80372,N'Cofrad�a de Navolato (Cofrad�a de los Rocha)',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,309,N'Rural',NULL),
	 (80372,N'Convenci�n de Aguascalientes',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,310,N'Rural',NULL),
	 (80372,N'Melones Internacional',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,311,N'Rural',NULL),
	 (80372,N'La Sinaloa',N'Pueblo',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,28,18,312,N'Rural',NULL),
	 (80373,N'El Tanque',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,14,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80373,N'La Loma',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,30,N'Rural',NULL),
	 (80373,N'Cofradia de La Loma',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,313,N'Rural',NULL),
	 (80373,N'Los Arredondos',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,314,N'Rural',NULL),
	 (80373,N'Lo de Verdugo',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2350,N'Rural',NULL),
	 (80373,N'Rio Viejo',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,29,18,2352,N'Rural',NULL),
	 (80373,N'Campo Ochiqui',N'Ejido',N'Navolato',N'Sinaloa',N'',80321,25,80321,NULL,15,18,2893,N'Rural',NULL),
	 (80374,N'Los Alamitos',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,29,18,16,N'Rural',NULL),
	 (80374,N'San Luis',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,29,18,26,N'Rural',NULL),
	 (80374,N'San Manuel',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,29,18,34,N'Rural',NULL),
	 (80374,N'San Emili�n',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,29,18,35,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80374,N'Campo Nuevo',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,29,18,36,N'Rural',NULL),
	 (80374,N'Balbuena',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,29,18,302,N'Rural',NULL),
	 (80374,N'Bariometo',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,29,18,316,N'Rural',NULL),
	 (80374,N'Cofradia de San Pedro',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,29,18,317,N'Rural',NULL),
	 (80374,N'Las Bebelamas de San Pedro',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,29,18,318,N'Rural',NULL),
	 (80374,N'El Batall�n',N'Ejido',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,15,18,2314,N'Rural',NULL),
	 (80374,N'Laguna de San Pedro',N'Ejido',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,15,18,2354,N'Rural',NULL),
	 (80374,N'Yebavito',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,29,18,2370,N'Rural',NULL),
	 (80374,N'San Pedro',N'Pueblo',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,28,18,2589,N'Urbano',NULL),
	 (80376,N'La Bebelama de San Pedro',N'Pueblo',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,28,18,18,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80376,N'Campo San Severo',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,29,18,37,N'Rural',NULL),
	 (80376,N'San Pedro',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80307,25,80307,NULL,29,18,320,N'Rural',NULL),
	 (80377,N'Bachigualatillo',N'Rancher�a',N'Navolato',N'Sinaloa',N'',80001,25,80001,NULL,29,18,321,N'Rural',NULL),
	 (80378,N'Rosario Ort�z',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,8,N'Urbano',24),
	 (80378,N'Villa del Real',N'Fraccionamiento',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,21,18,9,N'Urbano',24),
	 (80378,N'Triqui Tres de Mayo',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,39,N'Urbano',24),
	 (80378,N'Quinta Bonita',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,42,N'Urbano',24),
	 (80378,N'Diana Laura',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,44,N'Urbano',24),
	 (80378,N'Santa Elvira',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,45,N'Urbano',24),
	 (80378,N'Santa Anita',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,47,N'Urbano',24);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80378,N'Las Vegas',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,49,N'Urbano',24),
	 (80378,N'Los Pinos',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,50,N'Urbano',24),
	 (80378,N'Manuel Amezquita',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,51,N'Urbano',24),
	 (80378,N'Los Girasoles',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,52,N'Urbano',24),
	 (80378,N'Juan S. Mill�n',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,53,N'Urbano',24),
	 (80378,N'El Tapacal',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,1683,N'Urbano',24),
	 (80378,N'Jos� L�pez Portillo',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,1684,N'Urbano',24),
	 (80378,N'4 de Marzo',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,1685,N'Urbano',24),
	 (80378,N'Margarita Maza de Ju�rez',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,1686,N'Urbano',24),
	 (80378,N'Las Cupias',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,1688,N'Urbano',24);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80378,N'La Primavera',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,2676,N'Urbano',24),
	 (80378,N'INFONAVIT ABC',N'Fraccionamiento',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,21,18,2677,N'Urbano',24),
	 (80378,N'Tierra y Libertad (Las Ca�itas)',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,2882,N'Urbano',24),
	 (80378,N'Liberaci�n 89',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,2886,N'Urbano',24),
	 (80378,N'Perfecto Arredondo',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,2999,N'Urbano',24),
	 (80378,N'Guadalupe',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,3000,N'Urbano',24),
	 (80378,N'Jos� Vasconcelos',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,3001,N'Urbano',24),
	 (80378,N'Manuel G�mez Morin',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,3002,N'Urbano',24),
	 (80378,N'Praderas del Sol',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,3003,N'Urbano',24),
	 (80378,N'Ampliaci�n Praderas del Sol',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,3004,N'Urbano',24);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80378,N'Las Granjas',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,3005,N'Urbano',24),
	 (80378,N'Las Amapas',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,3023,N'Urbano',24),
	 (80378,N'Popular',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,3024,N'Urbano',24),
	 (80378,N'Santa Natalia',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,3025,N'Urbano',24),
	 (80378,N'V�ctor Godoy',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,3026,N'Urbano',24),
	 (80378,N'Villa Bonita',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,3048,N'Urbano',24),
	 (80378,N'Luis Donaldo Colosio',N'Colonia',N'Navolato',N'Sinaloa',N'Licenciado Benito Ju�rez (Campo Gobierno)',80379,25,80379,NULL,9,18,3076,N'Urbano',24),
	 (80380,N'Sanalona',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,325,N'Rural',NULL),
	 (80380,N'Arroyo Grande',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,455,N'Rural',NULL),
	 (80383,N'Los Brasiles',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,266,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80383,N'Puerto Rico (El Reparito)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,281,N'Rural',NULL),
	 (80383,N'Tomo',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,326,N'Rural',NULL),
	 (80383,N'El Espinal',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,3197,N'Rural',NULL),
	 (80384,N'El Rinc�n',N'Rancho',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,48,6,262,N'Rural',NULL),
	 (80384,N'Portezuelo',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,279,N'Rural',NULL),
	 (80384,N'Mezquitita',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,297,N'Rural',NULL),
	 (80384,N'El Pozo',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,327,N'Rural',NULL),
	 (80384,N'Imala',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,328,N'Rural',NULL),
	 (80384,N'Las Aguamitas',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,403,N'Rural',NULL),
	 (80384,N'Ayun�',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,436,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80384,N'Plan de Oriente (El Doce)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,448,N'Rural',NULL),
	 (80384,N'La Cruz de Carrizalejo',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,454,N'Rural',NULL),
	 (80384,N'Los Naranjos',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,2604,N'Rural',NULL),
	 (80385,N'Carboneras',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,329,N'Rural',NULL),
	 (80385,N'El Lim�n de Tellaeche',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,330,N'Rural',NULL),
	 (80385,N'La Esmeralda',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,331,N'Rural',NULL),
	 (80385,N'La Noria',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,332,N'Rural',NULL),
	 (80385,N'El Carrizalejo',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,2883,N'Rural',NULL),
	 (80386,N'Las Milpas N�mero Dos (Las Milpas)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,333,N'Rural',NULL),
	 (80386,N'Los Mayos',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,334,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80386,N'Arroyo de la Higuera',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,435,N'Rural',NULL),
	 (80386,N'El Rinc�n',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,450,N'Rural',NULL),
	 (80386,N'El Ciruelar',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,2989,N'Rural',NULL),
	 (80387,N'Las Vinoramas',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,3122,N'Rural',NULL),
	 (80390,N'Baila',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,335,N'Rural',NULL),
	 (80390,N'El Tule',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,336,N'Rural',NULL),
	 (80390,N'Laguna Colorada',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,337,N'Rural',NULL),
	 (80391,N'Alcoyonqui',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,338,N'Rural',NULL),
	 (80391,N'Nuevo Mundo',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,445,N'Rural',NULL),
	 (80393,N'Insurgentes',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,9,6,273,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80393,N'Abuya y Ceuta Segunda (Echeverr�a)',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,339,N'Rural',NULL),
	 (80393,N'Bachigualatito',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,512,N'Rural',NULL),
	 (80393,N'El Diez',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,2421,N'Urbano',NULL),
	 (80393,N'Argentina Dos',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,2593,N'Rural',NULL),
	 (80393,N'Parque Industrial El Tr�bol',N'Zona industrial',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,37,6,3139,N'Rural',NULL),
	 (80394,N'El �lamo',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,340,N'Rural',NULL),
	 (80394,N'Salate de los Tapias',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,341,N'Rural',NULL),
	 (80394,N'La Guamuchilera',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,342,N'Rural',NULL),
	 (80394,N'La Mora',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,343,N'Rural',NULL),
	 (80395,N'Campo el Porvenir',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,501,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80395,N'Campo Chulavista [Campo la Veinte]',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,505,N'Rural',NULL),
	 (80395,N'Campo Cuba',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,507,N'Rural',NULL),
	 (80395,N'Campo Nora',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,508,N'Rural',NULL),
	 (80395,N'Agr�cola GEMA',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,513,N'Rural',NULL),
	 (80395,N'Paralelo Treinta y Ocho',N'Equipamiento',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,17,6,514,N'Rural',NULL),
	 (80395,N'La Cuchilla',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,522,N'Rural',NULL),
	 (80395,N'Chulavista Dos',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,523,N'Rural',NULL),
	 (80395,N'Campo La Flor',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,2302,N'Rural',NULL),
	 (80395,N'Campo Esperanza',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,2590,N'Rural',NULL),
	 (80395,N'Campo El Huarache',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,2595,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80395,N'Campo La Baqueta',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,2597,N'Rural',NULL),
	 (80395,N'Campo El Chorizo',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,2598,N'Rural',NULL),
	 (80396,N'San Rom�n',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,345,N'Rural',NULL),
	 (80397,N'Las Flechas',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,346,N'Rural',NULL),
	 (80398,N'El Quemadito',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,228,N'Rural',NULL),
	 (80398,N'La Pedrera',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,293,N'Rural',NULL),
	 (80398,N'Transportes y Agr�cola Areem El Gato',N'Equipamiento',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,17,6,347,N'Rural',NULL),
	 (80398,N'Las Bateas',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,348,N'Rural',NULL),
	 (80398,N'San Rafael',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,349,N'Rural',NULL),
	 (80398,N'El Quince (El Quincito)',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,457,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80398,N'El �lamo',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,470,N'Rural',NULL),
	 (80398,N'Los Huizaches',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,2297,N'Rural',NULL),
	 (80398,N'Campo El Sol (Campo Pegaso)',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,2605,N'Rural',NULL),
	 (80398,N'Can�n',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,2606,N'Rural',NULL),
	 (80398,N'Campo Nuevo M�xico',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,2607,N'Rural',NULL),
	 (80398,N'NCPE El 30',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,2608,N'Rural',NULL),
	 (80400,N'Ampliaci�n Uni�n (Nueva)',N'Colonia',N'Culiac�n',N'Sinaloa',N'Quil�',80401,25,80401,NULL,9,6,1696,N'Urbano',8),
	 (80400,N'Quil� Centro',N'Colonia',N'Culiac�n',N'Sinaloa',N'Quil�',80401,25,80401,NULL,9,6,1750,N'Urbano',8),
	 (80402,N'Santa Mar�a',N'Colonia',N'Culiac�n',N'Sinaloa',N'Quil�',80401,25,80401,NULL,9,6,1749,N'Urbano',8),
	 (80402,N'Alto de Quil� (San Francisco)',N'Colonia',N'Culiac�n',N'Sinaloa',N'Quil�',80401,25,80401,NULL,9,6,2743,N'Urbano',8);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80403,N'Uni�n',N'Colonia',N'Culiac�n',N'Sinaloa',N'Quil�',80401,25,80401,NULL,9,6,1747,N'Urbano',8),
	 (80405,N'Ejidal',N'Colonia',N'Culiac�n',N'Sinaloa',N'Quil�',80401,25,80401,NULL,9,6,2744,N'Urbano',8),
	 (80408,N'Cedros',N'Colonia',N'Culiac�n',N'Sinaloa',N'Quil�',80401,25,80401,NULL,9,6,264,N'Urbano',8),
	 (80408,N'Bellavista',N'Colonia',N'Culiac�n',N'Sinaloa',N'Quil�',80401,25,80401,NULL,9,6,2067,N'Urbano',8),
	 (80408,N'La Candelaria',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'Quil�',80401,25,80401,NULL,21,6,2924,N'Urbano',8),
	 (80409,N'Emiliano Zapata',N'Colonia',N'Culiac�n',N'Sinaloa',N'Quil�',80401,25,80401,NULL,9,6,263,N'Urbano',8),
	 (80409,N'Aviaci�n',N'Colonia',N'Culiac�n',N'Sinaloa',N'Quil�',80401,25,80401,NULL,9,6,1752,N'Urbano',8),
	 (80410,N'El Carrizal',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,357,N'Rural',NULL),
	 (80410,N'Las Tapias',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,358,N'Rural',NULL),
	 (80410,N'El Carrizal Dos',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,2609,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80411,N'El Porvenir',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,359,N'Rural',NULL),
	 (80411,N'Las Tranquitas',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,360,N'Rural',NULL),
	 (80411,N'Lo de Bartolo',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,361,N'Rural',NULL),
	 (80415,N'Campo Laguna',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,362,N'Rural',NULL),
	 (80415,N'Campo Laguna',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,15,6,363,N'Rural',NULL),
	 (80415,N'La Palma',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,364,N'Rural',NULL),
	 (80415,N'El Talayote',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,463,N'Rural',NULL),
	 (80416,N'La Pitahayita',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,366,N'Rural',NULL),
	 (80416,N'Santa Loreto',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,452,N'Rural',NULL),
	 (80417,N'Las Milpas 1',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,367,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80417,N'Lo de Clemente',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,442,N'Rural',NULL),
	 (80419,N'Tierra y Libertad',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80401,25,80401,NULL,28,6,368,N'Rural',NULL),
	 (80419,N'Tierra y Libertad 1',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80401,25,80401,NULL,28,6,369,N'Rural',NULL),
	 (80419,N'Valle Escondido',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80401,25,80401,NULL,29,6,370,N'Rural',NULL),
	 (80419,N'La Florida',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80401,25,80401,NULL,29,6,474,N'Rural',NULL),
	 (80419,N'Tierra y Libertad Dos',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80401,25,80401,NULL,15,6,2610,N'Rural',NULL),
	 (80419,N'La Reforma',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80401,25,80401,NULL,28,6,2611,N'Rural',NULL),
	 (80419,N'Comanito',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80401,25,80401,NULL,15,6,2612,N'Rural',NULL),
	 (80419,N'Libertad (Piramo)',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80401,25,80401,NULL,28,6,2613,N'Rural',NULL),
	 (80430,N'San Marcos',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,21,6,371,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80430,N'Campo el Seis',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,372,N'Rural',NULL),
	 (80430,N'Arkadia Uno (El Siete)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,373,N'Rural',NULL),
	 (80430,N'Centro',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,374,N'Urbano',NULL),
	 (80430,N'Los Becos (Duranguito)',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,375,N'Rural',NULL),
	 (80430,N'El Alhuate',N'Rancho',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,48,6,376,N'Rural',NULL),
	 (80430,N'Los Becos',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,377,N'Rural',NULL),
	 (80430,N'Benito Ju�rez Norte',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,1723,N'Urbano',NULL),
	 (80430,N'Benito Ju�rez Sur',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,1724,N'Urbano',NULL),
	 (80430,N'18 de Marzo',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,1725,N'Urbano',NULL),
	 (80430,N'Ca�itas',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,1727,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80430,N'Nuevas Ca�itas',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,1728,N'Rural',NULL),
	 (80430,N'Constituyentes',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,1729,N'Urbano',NULL),
	 (80430,N'Juan de Dios B�tiz',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,1730,N'Urbano',NULL),
	 (80430,N'Las Carpas',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,1731,N'Urbano',NULL),
	 (80430,N'Popular',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,1732,N'Urbano',NULL),
	 (80430,N'Campo Arbaco',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2626,N'Rural',NULL),
	 (80430,N'Campo San Marcos',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2627,N'Rural',NULL),
	 (80430,N'Campo Santa Luc�a',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2628,N'Rural',NULL),
	 (80430,N'Miguel Valdez Quintero (El Coraz�n)',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,28,6,2629,N'Rural',NULL),
	 (80430,N'Villa Rica',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3054,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80430,N'Solidaridad',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3070,N'Urbano',NULL),
	 (80430,N'San �ngel',N'Fraccionamiento',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,21,6,3071,N'Urbano',NULL),
	 (80430,N'Sinaloa',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3095,N'Urbano',NULL),
	 (80430,N'Las Piedritas',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3096,N'Urbano',NULL),
	 (80430,N'INFONAVIT Alondras',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3099,N'Urbano',NULL),
	 (80430,N'Solidaridad Campesina',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3100,N'Urbano',NULL),
	 (80430,N'INFONAVIT Prados del Sol',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3101,N'Urbano',NULL),
	 (80430,N'El Real',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3102,N'Urbano',NULL),
	 (80430,N'Magisterial',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3103,N'Urbano',NULL),
	 (80430,N'INFONAVIT 88',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3104,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80430,N'Francisco Villa',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3105,N'Urbano',NULL),
	 (80430,N'Loma Linda',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3106,N'Urbano',NULL),
	 (80430,N'General Zapata',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3107,N'Urbano',NULL),
	 (80430,N'S.T.A.S.A.C.',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3108,N'Urbano',NULL),
	 (80430,N'Ignacio Zaragoza',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3109,N'Urbano',NULL),
	 (80430,N'Veracruz',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3110,N'Urbano',NULL),
	 (80430,N'Ingenio',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3111,N'Urbano',NULL),
	 (80430,N'Barrio Estaci�n',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3112,N'Urbano',NULL),
	 (80430,N'Los Chinitos',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3113,N'Urbano',NULL),
	 (80430,N'Renato Vega Amador',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3114,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80430,N'Independencia',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3115,N'Urbano',NULL),
	 (80430,N'Revoluci�n',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,3195,N'Urbano',NULL),
	 (80433,N'Campo la Catorce',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,438,N'Rural',NULL),
	 (80433,N'Santa Luc�a',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,518,N'Rural',NULL),
	 (80433,N'Pueblo Nuevo',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,28,6,2630,N'Rural',NULL),
	 (80434,N'Campo 5 y Medio',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,380,N'Rural',NULL),
	 (80434,N'Campo �rika',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,467,N'Rural',NULL),
	 (80434,N'San Antonio Dos',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,492,N'Rural',NULL),
	 (80434,N'Ampliaci�n el Realito I (Curva el Treinta y Seis)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,494,N'Rural',NULL),
	 (80434,N'La Primavera',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,509,N'Rural',NULL);
INSERT INTO Sinaloa(d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80434,N'Golden Fields',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,511,N'Rural',NULL),
	 (80434,N'Empaque Cinco y Medio',N'Equipamiento',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,17,6,516,N'Rural',NULL),
	 (80434,N'Campo Patricia',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2591,N'Rural',NULL),
	 (80434,N'Campo Cuarenta y Cuatro',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2631,N'Rural',NULL),
	 (80434,N'Campo El Conejo (Campo Esperazna)',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2632,N'Rural',NULL),
	 (80434,N'Campo El Toro',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2633,N'Rural',NULL),
	 (80434,N'Campo Isabelitas',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2634,N'Rural',NULL),
	 (80434,N'Campo Nota',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2635,N'Rural',NULL),
	 (80434,N'Campo Paredes',N'Rancho',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,48,6,2636,N'Rural',NULL),
	 (80434,N'Empaque del Valle',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2637,N'Rural',NULL);
INSERT INTO Sinaloa(d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80434,N'Las Isabeles',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,28,6,2638,N'Rural',NULL),
	 (80434,N'Santa Lourdes',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2639,N'Rural',NULL),
	 (80435,N'Antonio Toledo Corro',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,489,N'Rural',NULL),
	 (80435,N'M�dulo del Sauz',N'Rancho',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,48,6,520,N'Rural',NULL),
	 (80435,N'Campo Gobierno II',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,3058,N'Rural',NULL),
	 (80436,N'El Para�so',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,447,N'Rural',NULL),
	 (80436,N'Doroteo Arango',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,460,N'Rural',NULL),
	 (80437,N'Campo Florencia (La P�ldora)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,490,N'Rural',NULL),
	 (80437,N'Villa Arredondo',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,495,N'Rural',NULL),
	 (80439,N'Campo Mezquitillo 2',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,381,N'Rural',NULL);
INSERT INTO Sinaloa(d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80439,N'Mezquitillo 2',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,28,6,382,N'Rural',NULL),
	 (80439,N'Mezquitillo (Chapeteado)',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,28,6,397,N'Rural',NULL),
	 (80439,N'Secci�n Alhuate',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,420,N'Rural',NULL),
	 (80439,N'Secci�n Alhuate',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,431,N'Rural',NULL),
	 (80439,N'Campo Santa Aurora',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,468,N'Rural',NULL),
	 (80439,N'Rebeca Uno (Primero de Mayo)',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,482,N'Rural',NULL),
	 (80439,N'Mezquitillo (La Curva)',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2640,N'Rural',NULL),
	 (80439,N'Campo Eureka',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2729,N'Rural',NULL),
	 (80440,N'El Salado',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,383,N'Rural',NULL),
	 (80441,N'Monte Verde de Villa',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,384,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80441,N'El Vizca�no',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,2293,N'Rural',NULL),
	 (80442,N'La Estancia de los Burgos',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,385,N'Rural',NULL),
	 (80442,N'El Ranchito de los Burgos',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,464,N'Rural',NULL),
	 (80443,N'Los Vasitos',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,386,N'Rural',NULL),
	 (80443,N'El Vichi de Abajo',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,2922,N'Rural',NULL),
	 (80444,N'Palo Blanco',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,446,N'Rural',NULL),
	 (80444,N'El Realito',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,2614,N'Rural',NULL),
	 (80447,N'San Lorenzo Nuevo',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,388,N'Rural',NULL),
	 (80447,N'Los Durmientes',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,458,N'Rural',NULL),
	 (80449,N'La Bebelama San Lorenzo',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,389,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80450,N'Eldorado Centro',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,1,N'Urbano',NULL),
	 (80450,N'Fidel Vel�zquez',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,2,N'Urbano',NULL),
	 (80450,N'Jardines del Sol',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,3,N'Urbano',NULL),
	 (80450,N'La Aviaci�n',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,4,N'Urbano',NULL),
	 (80450,N'Huerta de Redo 2',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,5,N'Urbano',NULL),
	 (80450,N'5� �lvarez',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,6,N'Urbano',NULL),
	 (80450,N'La Cuchilla',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,7,N'Urbano',NULL),
	 (80450,N'Adolfo Ruiz Cortines',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,8,N'Urbano',NULL),
	 (80450,N'Ampliaci�n Navito',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,9,N'Urbano',NULL),
	 (80450,N'Huerta de Redo 1',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,10,N'Urbano',NULL);
INSERT INTO Sinaloa(d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80450,N'Quinto Patio',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,11,N'Urbano',NULL),
	 (80450,N'Bicentenario',N'Fraccionamiento',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,21,19,12,N'Urbano',NULL),
	 (80450,N'El Chorrito',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,13,N'Urbano',NULL),
	 (80450,N'Benito Ju�rez',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,14,N'Urbano',NULL),
	 (80450,N'INFONAVIT San Diego',N'Fraccionamiento',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,21,19,16,N'Urbano',NULL),
	 (80450,N'INFONAVIT San Diego 2',N'Fraccionamiento',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,21,19,17,N'Urbano',NULL),
	 (80450,N'Navito',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,18,N'Urbano',NULL),
	 (80450,N'Mariano Escobedo',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,19,N'Urbano',NULL),
	 (80450,N'Alejandro Redo',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,20,N'Urbano',NULL),
	 (80450,N'La Arboleda',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,21,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80450,N'Los Cuartos',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,22,N'Urbano',NULL),
	 (80450,N'Bombas de Redo',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,23,N'Urbano',NULL),
	 (80450,N'Rastro Viejo',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,24,N'Urbano',NULL),
	 (80450,N'Los Payes',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,25,N'Urbano',NULL),
	 (80450,N'Lienzo Charro',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,26,N'Urbano',NULL),
	 (80450,N'Rub�n Jaramillo',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,27,N'Urbano',NULL),
	 (80450,N'Renato Vega Amador',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,28,N'Urbano',NULL),
	 (80450,N'Villa Eldorado',N'Fraccionamiento',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,21,19,29,N'Urbano',NULL),
	 (80450,N'La Huertita',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,30,N'Urbano',NULL),
	 (80450,N'Las Palmas',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,43,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80450,N'El Higueral',N'Pueblo',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,28,19,57,N'Rural',NULL),
	 (80450,N'Nuevo Higueral',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,58,N'Rural',NULL),
	 (80450,N'Eldorado Viejo',N'Colonia',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,9,19,62,N'Urbano',NULL),
	 (80452,N'San Manuel',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,31,N'Rural',NULL),
	 (80452,N'San Joaqu�n',N'Ejido',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,15,19,32,N'Rural',NULL),
	 (80452,N'San Diego',N'Pueblo',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,28,19,33,N'Rural',NULL),
	 (80452,N'La Cruz de Eldorado (Cruz de Navito)',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,34,N'Rural',NULL),
	 (80452,N'Campo San Mart�n',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,46,N'Rural',NULL),
	 (80452,N'El Saucito Nuevo',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,47,N'Rural',NULL),
	 (80452,N'Santo Ni�o',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,49,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80452,N'Navito',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,54,N'Rural',NULL),
	 (80452,N'Navolatillo',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,61,N'Rural',NULL),
	 (80453,N'Leopoldo S�nchez Celis',N'Pueblo',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,28,19,15,N'Rural',NULL),
	 (80453,N'La Arrocera',N'Ejido',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,15,19,35,N'Rural',NULL),
	 (80453,N'Campo Rebeca',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,38,N'Rural',NULL),
	 (80453,N'Rebeca Dos (Metesaca)',N'Ejido',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,15,19,40,N'Rural',NULL),
	 (80453,N'El Manguito',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,50,N'Rural',NULL),
	 (80453,N'Las Tres Gotas de Agua',N'Pueblo',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,28,19,51,N'Rural',NULL),
	 (80454,N'Las Piedritas',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,48,N'Rural',NULL),
	 (80454,N'Santa Rita (Tableta)',N'Rancho',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,48,19,52,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80454,N'La Flor (Metesaca)',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,53,N'Rural',NULL),
	 (80454,N'La Flor',N'Ejido',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,15,19,60,N'Rural',NULL),
	 (80455,N'Portaceli',N'Pueblo',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,28,19,36,N'Rural',NULL),
	 (80455,N'La Mojonera',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,42,N'Rural',NULL),
	 (80455,N'Guadalupe Victoria (El Ator�n)',N'Pueblo',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,28,19,59,N'Rural',NULL),
	 (80457,N'Las Arenitas',N'Pueblo',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,28,19,37,N'Rural',NULL),
	 (80457,N'El Robalar',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,39,N'Rural',NULL),
	 (80457,N'El Rosarito',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,55,N'Rural',NULL),
	 (80457,N'El Cuervo',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,56,N'Rural',NULL),
	 (80458,N'El Conchal',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,41,N'Rural',NULL);
INSERT INTO Sinaloa(d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80458,N'Soyatita',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,44,N'Rural',NULL),
	 (80458,N'Soyatita (Cruz Segunda)',N'Rancher�a',N'Eldorado',N'Sinaloa',N'',80456,25,80456,NULL,29,19,45,N'Rural',NULL),
	 (80460,N'El Camalote',N'Hacienda',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,24,6,404,N'Rural',NULL),
	 (80460,N'Jacola',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,405,N'Rural',NULL),
	 (80460,N'Laguna de Canachi',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,406,N'Rural',NULL),
	 (80460,N'La Compuerta',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,439,N'Rural',NULL),
	 (80460,N'La Romana',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,461,N'Rural',NULL),
	 (80460,N'El Huinacaxtle',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2649,N'Rural',NULL),
	 (80460,N'El Mel�n (San Alejandro)',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,28,6,2650,N'Rural',NULL),
	 (80460,N'Nicol�s Bravo',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2726,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80460,N'M�xico de Oriente (Las G�eras)',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,3057,N'Rural',NULL),
	 (80463,N'Heraclio Bernal',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,408,N'Rural',NULL),
	 (80463,N'La Esperanza (La Torta)',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,473,N'Rural',NULL),
	 (80463,N'El Tule',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,484,N'Rural',NULL),
	 (80463,N'Loma y Tecomate',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,3049,N'Rural',NULL),
	 (80464,N'La Constancia',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,270,N'Rural',NULL),
	 (80464,N'Cinco de Febrero (Las G�eras)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,476,N'Rural',NULL),
	 (80464,N'Marcelo Loya (Las G�eras)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,487,N'Rural',NULL),
	 (80468,N'Pen�nsula de Villamoros',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80379,25,80379,NULL,28,6,414,N'Rural',NULL),
	 (80470,N'Estancia de los Garcia',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,415,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80470,N'San Francisco de Tacuichamona',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,416,N'Rural',NULL),
	 (80470,N'Walamito',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,2292,N'Rural',NULL),
	 (80473,N'La Chilla',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,396,N'Rural',NULL),
	 (80475,N'San Lorenzo',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,355,N'Rural',NULL),
	 (80475,N'Tabala',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,28,6,417,N'Rural',NULL),
	 (80480,N'Estaci�n Quil�',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80401,25,80401,NULL,28,6,354,N'Rural',NULL),
	 (80480,N'Oso Nuevo (El Oso)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80401,25,80401,NULL,29,6,356,N'Rural',NULL),
	 (80480,N'La Loma (La Loma de Quila)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80401,25,80401,NULL,29,6,418,N'Rural',NULL),
	 (80481,N'Las Flores',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,419,N'Rural',NULL),
	 (80483,N'Oso Viejo',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80401,25,80401,NULL,28,6,421,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80484,N'Pueblos Unidos',N'Pueblo',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,28,6,422,N'Rural',NULL),
	 (80485,N'Estaci�n Obispo',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,423,N'Rural',NULL),
	 (80486,N'El Cachor�n (Nuevo Rosarito)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,466,N'Rural',NULL),
	 (80489,N'Higueras de Abuya',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,424,N'Rural',NULL),
	 (80490,N'Campo Agr�cola San Miguel',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,305,N'Rural',NULL),
	 (80490,N'El Sinaloense',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,425,N'Rural',NULL),
	 (80490,N'Emancipaci�n',N'Colonia',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,9,6,426,N'Rural',NULL),
	 (80490,N'Campo Jal-Aca',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,469,N'Rural',NULL),
	 (80490,N'Francisco Villa',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2615,N'Rural',NULL),
	 (80491,N'Obispo',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,427,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80491,N'San Isidro',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,428,N'Rural',NULL),
	 (80491,N'Jacola (El Guayabo)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,440,N'Rural',NULL),
	 (80491,N'R�o Florido',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,451,N'Rural',NULL),
	 (80491,N'La Esperanza',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,485,N'Rural',NULL),
	 (80491,N'El Retiro',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2617,N'Rural',NULL),
	 (80491,N'Santa Refugio',N'Ejido',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,15,6,2618,N'Rural',NULL),
	 (80491,N'Las Maravillas',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80456,25,80456,NULL,29,6,3051,N'Rural',NULL),
	 (80492,N'Adolfo L�pez Mateos (Casa Blanca)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80321,25,80321,NULL,29,6,429,N'Rural',NULL),
	 (80492,N'Panaltita',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80321,25,80321,NULL,29,6,479,N'Rural',NULL),
	 (80493,N'La Guasima',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80321,25,80321,NULL,29,6,430,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80496,N'Abuya',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,432,N'Rural',NULL),
	 (80496,N'Chiqueritos',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,433,N'Rural',NULL),
	 (80498,N'Cospita',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,434,N'Rural',NULL),
	 (80498,N'Estaci�n Abuya',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,500,N'Rural',NULL),
	 (80498,N'Higueras de Baila',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,502,N'Rural',NULL),
	 (80498,N'Pueblo Nuevo de Canachi (El Campito)',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,503,N'Rural',NULL),
	 (80498,N'Ricardo Flores Mag�n',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,504,N'Rural',NULL),
	 (80498,N'La Higuera',N'Rancher�a',N'Culiac�n',N'Sinaloa',N'',80001,25,80001,NULL,29,6,506,N'Rural',NULL),
	 (80500,N'Badiraguato',N'Pueblo',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,28,3,435,N'Urbano',NULL),
	 (80500,N'Colinas del Camich�n',N'Pueblo',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,28,3,2723,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80503,N'Chaparahueto',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,27,N'Rural',NULL),
	 (80504,N'La Acendrada (La Cendrada)',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,6,N'Rural',NULL),
	 (80504,N'El Guam�chil del Barranco',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,161,N'Rural',NULL),
	 (80505,N'La Amapa',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,13,N'Rural',NULL),
	 (80505,N'Viejo de los Serrano',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,163,N'Rural',NULL),
	 (80520,N'Babunica',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,16,N'Rural',NULL),
	 (80520,N'El Sauce',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,71,N'Rural',NULL),
	 (80520,N'La Noria',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,118,N'Rural',NULL),
	 (80524,N'Las Juntas',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,34,N'Rural',NULL),
	 (80524,N'El Real',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,129,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80524,N'El Potrero de los P�ez',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,177,N'Rural',NULL),
	 (80524,N'San Jos� del Taste',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,184,N'Rural',NULL),
	 (80526,N'Maturipa',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,38,N'Rural',NULL),
	 (80526,N'Santa Mar�a',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,117,N'Rural',NULL),
	 (80526,N'Caiquiva',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,200,N'Rural',NULL),
	 (80526,N'Las Limas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,210,N'Rural',NULL),
	 (80527,N'Bamopa',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,2243,N'Rural',NULL),
	 (80530,N'El �lamo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,9,N'Rural',NULL),
	 (80530,N'El Guasimal',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,32,N'Rural',NULL),
	 (80530,N'Santa Rosa',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,130,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80530,N'Potrerillo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,181,N'Rural',NULL),
	 (80530,N'La Dispencilla',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,194,N'Rural',NULL),
	 (80530,N'Sitio de Abajo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,437,N'Rural',NULL),
	 (80533,N'El Barril',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,3,N'Rural',NULL),
	 (80533,N'La Cieneguilla',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,25,N'Rural',NULL),
	 (80533,N'Ojo de Agua',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,46,N'Rural',NULL),
	 (80533,N'Las Palmas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,219,N'Rural',NULL),
	 (80534,N'El Aguaje',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,8,N'Rural',NULL),
	 (80534,N'El Huejote',N'Ejido',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,15,3,438,N'Rural',NULL),
	 (80534,N'San Nicol�s del Sitio (Sitio de Arriba)',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,439,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80535,N'Sitio de en Medio',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,440,N'Rural',NULL),
	 (80536,N'Los Alcajeces',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,10,N'Rural',NULL),
	 (80536,N'Baimusari',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,17,N'Rural',NULL),
	 (80536,N'Los Zapotes de Abajo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,133,N'Rural',NULL),
	 (80536,N'El Platanar',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,180,N'Rural',NULL),
	 (80536,N'La Tasajera',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,228,N'Rural',NULL),
	 (80536,N'Los Zapotes de Arriba',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,255,N'Rural',NULL),
	 (80536,N'La Juanilla',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,441,N'Rural',NULL),
	 (80536,N'Potrero de los Medina',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,442,N'Rural',NULL),
	 (80537,N'Boca de Arroyo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,18,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80537,N'El Aguaje',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,84,N'Rural',NULL),
	 (80537,N'Cinco de Mayo (Tepalcates)',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,100,N'Rural',NULL),
	 (80537,N'San Jos� de la Puerta',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,443,N'Rural',NULL),
	 (80537,N'San Antonio de la Palma',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,444,N'Rural',NULL),
	 (80540,N'El Tecu�n',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,229,N'Rural',NULL),
	 (80540,N'Las Higueras del Tecu�n',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,445,N'Rural',NULL),
	 (80543,N'Dos Arroyos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,29,N'Rural',NULL),
	 (80543,N'El Aguaje de los Monz�n',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,87,N'Rural',NULL),
	 (80543,N'Palo Verde',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,178,N'Rural',NULL),
	 (80544,N'Chinacates',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,202,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80544,N'El Zapotillo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,232,N'Rural',NULL),
	 (80544,N'Boca de Arroyo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,274,N'Rural',NULL),
	 (80544,N'Morirato',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,2241,N'Rural',NULL),
	 (80545,N'Potrero de los Vega',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,59,N'Rural',NULL),
	 (80545,N'El Tule',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,190,N'Rural',NULL),
	 (80545,N'El Zapote de los Monz�n',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,234,N'Rural',NULL),
	 (80545,N'Aguaje Grande',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,2273,N'Rural',NULL),
	 (80550,N'Higueras de �lvarez Borboa (Higuera de los Monz�n)',N'Pueblo',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,28,3,446,N'Rural',NULL),
	 (80553,N'Los Mapaches',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,37,N'Rural',NULL),
	 (80553,N'Las Aguamas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,88,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80553,N'La Majada de Arriba',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,175,N'Rural',NULL),
	 (80554,N'Los Chinos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,149,N'Rural',NULL),
	 (80554,N'La Higuerita',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,174,N'Rural',NULL),
	 (80554,N'Alcoyonqui',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,448,N'Rural',NULL),
	 (80554,N'Llano de los Roch�n',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,449,N'Rural',NULL),
	 (80555,N'El Divisadero',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,28,N'Rural',NULL),
	 (80555,N'Jurisdicci�n de Arriba',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,193,N'Rural',NULL),
	 (80556,N'Cerro de los Guerrero',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,160,N'Rural',NULL),
	 (80556,N'Batequitas',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,450,N'Rural',NULL),
	 (80556,N'Rinc�n de los Monz�n',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,451,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80557,N'La Apoma',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,447,N'Rural',NULL),
	 (80557,N'El Hormiguero',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,3040,N'Rural',NULL),
	 (80560,N'Nocoriba',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,43,N'Rural',NULL),
	 (80560,N'El Pueblito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,62,N'Rural',NULL),
	 (80560,N'Las Higueritas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,105,N'Rural',NULL),
	 (80560,N'La Vainilla',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,141,N'Rural',NULL),
	 (80560,N'El Zapote',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,192,N'Rural',NULL),
	 (80560,N'La Mezcla',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,253,N'Rural',NULL),
	 (80560,N'Otatillos',N'Pueblo',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,28,3,452,N'Rural',NULL),
	 (80563,N'Los Negritos',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,119,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80563,N'La Tarahumara',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,135,N'Rural',NULL),
	 (80563,N'Guat�nipa',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,146,N'Rural',NULL),
	 (80563,N'Rinc�n de los L�pez',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,164,N'Rural',NULL),
	 (80563,N'El Mezcalito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,176,N'Rural',NULL),
	 (80563,N'La Presita',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,220,N'Rural',NULL),
	 (80563,N'La Higuerita',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,453,N'Rural',NULL),
	 (80564,N'La Gu�sima de los Guerrero',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,31,N'Rural',NULL),
	 (80564,N'El Paso de San Nicol�s',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,127,N'Rural',NULL),
	 (80564,N'La Presa de Moributo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,162,N'Rural',NULL),
	 (80564,N'Cariatapa',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,166,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80565,N'El Portezuelo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,126,N'Rural',NULL),
	 (80565,N'Batopito',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,454,N'Rural',NULL),
	 (80565,N'Palmar de los R�os',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,455,N'Rural',NULL),
	 (80565,N'San Antonio de los Ortiz (El Riyito)',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,3128,N'Rural',NULL),
	 (80566,N'La Otra Banda de Badiraguato',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,218,N'Rural',NULL),
	 (80567,N'Ci�nega de los Lara',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,456,N'Rural',NULL),
	 (80570,N'La Amapa',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,89,N'Rural',NULL),
	 (80570,N'Zoquitita',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,251,N'Rural',NULL),
	 (80570,N'Cortijos de Guatenipa (Los Cortijos)',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,457,N'Rural',NULL),
	 (80573,N'El Naranjo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,41,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80573,N'Tareapa',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,75,N'Rural',NULL),
	 (80573,N'La Quebrada de Cu�n',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,252,N'Rural',NULL),
	 (80574,N'El Mautal',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,39,N'Rural',NULL),
	 (80574,N'El Cielo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,101,N'Rural',NULL),
	 (80574,N'El Sauce',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,154,N'Rural',NULL),
	 (80574,N'La Coronilla',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,272,N'Rural',NULL),
	 (80574,N'Los Brasiles',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,273,N'Rural',NULL),
	 (80575,N'El Zapote',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,81,N'Rural',NULL),
	 (80575,N'Lo de Tom�s',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,212,N'Rural',NULL),
	 (80576,N'Los Ayales',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,158,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80576,N'El Potrerillo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,182,N'Rural',NULL),
	 (80577,N'Potrerito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,248,N'Rural',NULL),
	 (80577,N'Atoribito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,249,N'Rural',NULL),
	 (80580,N'Rancho Viejo de los Vel�zquez',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,131,N'Rural',NULL),
	 (80580,N'El Mezquite',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,266,N'Rural',NULL),
	 (80583,N'Huicharabito',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,1,N'Rural',NULL),
	 (80583,N'Las Olorosas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,121,N'Rural',NULL),
	 (80583,N'Camotete [Campo Camotete]',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,458,N'Rural',NULL),
	 (80583,N'Saca de Agua',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,2240,N'Rural',NULL),
	 (80583,N'El Rinc�n de los Montes',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,2309,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80584,N'Agua Amarilla',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,157,N'Rural',NULL),
	 (80584,N'Las Canoas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,165,N'Rural',NULL),
	 (80585,N'Paso del Huejote',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,52,N'Rural',NULL),
	 (80585,N'Higueras de Bayaca (Bayaca)',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,90,N'Rural',NULL),
	 (80585,N'El Brasil',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,91,N'Rural',NULL),
	 (80585,N'El Huejotillo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,2242,N'Rural',NULL),
	 (80586,N'El Potrero del Varejonal',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80001,25,80001,NULL,29,3,221,N'Rural',NULL),
	 (80586,N'El Varejonal',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80001,25,80001,NULL,29,3,459,N'Rural',NULL),
	 (80600,N'Plan Grande',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,56,N'Rural',NULL),
	 (80600,N'El Ranchito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,153,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80600,N'Surutato',N'Ejido',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,15,3,461,N'Rural',NULL),
	 (80603,N'El Sauce',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,145,N'Rural',NULL),
	 (80603,N'La Colonia',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,265,N'Rural',NULL),
	 (80603,N'Copalitos',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,462,N'Rural',NULL),
	 (80604,N'Llano Grande',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,5,N'Rural',NULL),
	 (80604,N'La S�bila',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,67,N'Rural',NULL),
	 (80604,N'El Molino',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,148,N'Rural',NULL),
	 (80604,N'Los Sonocores',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,217,N'Rural',NULL),
	 (80604,N'La Ca�ita',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,238,N'Rural',NULL),
	 (80604,N'Los Inditos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,257,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80606,N'La Boca',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,19,N'Rural',NULL),
	 (80606,N'Las Calabazas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,20,N'Rural',NULL),
	 (80606,N'Lo de Gabriel',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,36,N'Rural',NULL),
	 (80606,N'Soyatita',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,74,N'Rural',NULL),
	 (80606,N'Los Mimbre',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,214,N'Rural',NULL),
	 (80606,N'San Jos� del Llano',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,460,N'Rural',NULL),
	 (80607,N'Los Pacheco',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,47,N'Rural',NULL),
	 (80607,N'El Naranjo de los Salom�n',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,271,N'Rural',NULL),
	 (80610,N'San Javier de Arriba',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,68,N'Rural',NULL),
	 (80610,N'Casas Viejas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,96,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80610,N'Las Higueras',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,104,N'Rural',NULL),
	 (80610,N'El Molino',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,112,N'Rural',NULL),
	 (80610,N'Los Mirasoles',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,113,N'Rural',NULL),
	 (80610,N'El Picacho',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,124,N'Rural',NULL),
	 (80610,N'Huanacaxtle',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,207,N'Rural',NULL),
	 (80610,N'Terreros de San Javier',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,239,N'Rural',NULL),
	 (80610,N'Palmarito de San Javier',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,261,N'Rural',NULL),
	 (80610,N'El Saucito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,264,N'Rural',NULL),
	 (80610,N'Potrerillos',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,463,N'Rural',NULL),
	 (80610,N'San Javier de Abajo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,464,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80613,N'El Frijolar',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,4,N'Rural',NULL),
	 (80613,N'Alisitos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,11,N'Rural',NULL),
	 (80613,N'Carricitos',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,99,N'Rural',NULL),
	 (80613,N'Milpitas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,241,N'Rural',NULL),
	 (80613,N'Los Laureles',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,258,N'Rural',NULL),
	 (80614,N'La Ca�a',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,22,N'Rural',NULL),
	 (80614,N'La Higuerita',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,33,N'Rural',NULL),
	 (80614,N'El Play�n',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,57,N'Rural',NULL),
	 (80614,N'La Cieneguita',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,98,N'Rural',NULL),
	 (80614,N'El Mezcal',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,114,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80614,N'Palos Dulces',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,147,N'Rural',NULL),
	 (80614,N'Los Gavilanes',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,169,N'Rural',NULL),
	 (80614,N'Los Zapotes',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,191,N'Rural',NULL),
	 (80614,N'El Tastecito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,242,N'Rural',NULL),
	 (80614,N'Los Coyotes',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,243,N'Rural',NULL),
	 (80614,N'El Pueblito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,244,N'Rural',NULL),
	 (80614,N'El Naranjo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,260,N'Rural',NULL),
	 (80614,N'Las Paredes',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,262,N'Rural',NULL),
	 (80615,N'Santo Tom�s de Arriba',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,70,N'Rural',NULL),
	 (80615,N'Tecuxiapa',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,76,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80615,N'Los Zapotillos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,233,N'Rural',NULL),
	 (80615,N'La Comisi�n',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,236,N'Rural',NULL),
	 (80615,N'Mesa de Bernal',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,237,N'Rural',NULL),
	 (80620,N'Potrero de la Vainilla',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,58,N'Rural',NULL),
	 (80623,N'Sabanillas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,66,N'Rural',NULL),
	 (80623,N'Alisitos',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,83,N'Rural',NULL),
	 (80623,N'Los Echaderos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,102,N'Rural',NULL),
	 (80625,N'El Carricito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,167,N'Rural',NULL),
	 (80625,N'La Soledad',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,267,N'Rural',NULL),
	 (80627,N'El Nogalito',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,45,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80627,N'La Palma',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,48,N'Rural',NULL),
	 (80627,N'San Jos� del Barranco',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,69,N'Rural',NULL),
	 (80627,N'Pie de la Cuesta',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,215,N'Rural',NULL),
	 (80627,N'San Miguel',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,278,N'Rural',NULL),
	 (80627,N'La Tuna',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,465,N'Rural',NULL),
	 (80630,N'El Pel�n',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,53,N'Rural',NULL),
	 (80630,N'Rancho Viejo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,64,N'Rural',NULL),
	 (80630,N'Los Cacahuates',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,95,N'Rural',NULL),
	 (80630,N'El Salto',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,225,N'Rural',NULL),
	 (80630,N'Santo Tom�s de Abajo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,227,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80633,N'Los Coquitos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,92,N'Rural',NULL),
	 (80633,N'El Laurel',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,107,N'Rural',NULL),
	 (80633,N'Los Pinos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,123,N'Rural',NULL),
	 (80633,N'El Tepehu�n',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,134,N'Rural',NULL),
	 (80633,N'El Trigo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,136,N'Rural',NULL),
	 (80633,N'Las Hiedritas (Terremoto)',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,173,N'Rural',NULL),
	 (80633,N'Ladrillera',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,179,N'Rural',NULL),
	 (80633,N'Las Vainillas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,246,N'Rural',NULL),
	 (80633,N'Rancho Blanco',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,277,N'Rural',NULL),
	 (80634,N'El Terrero',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,78,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80634,N'El Quemado',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,94,N'Rural',NULL),
	 (80634,N'V�lgame Dios',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,140,N'Rural',NULL),
	 (80634,N'El Cedro',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,168,N'Rural',NULL),
	 (80634,N'Los Bajillos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,198,N'Rural',NULL),
	 (80634,N'Las Burras',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,199,N'Rural',NULL),
	 (80634,N'Santa B�rbara de la Ca�a',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,226,N'Rural',NULL),
	 (80634,N'La Ca�a de Abajo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,235,N'Rural',NULL),
	 (80634,N'El Infiernito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,247,N'Rural',NULL),
	 (80634,N'Portezuelo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,263,N'Rural',NULL),
	 (80635,N'El Aguaje del Charo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,86,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80635,N'Carboneras',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,93,N'Rural',NULL),
	 (80635,N'Pericos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,122,N'Rural',NULL),
	 (80635,N'Saca de Agua',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,132,N'Rural',NULL),
	 (80635,N'Chivas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,142,N'Rural',NULL),
	 (80635,N'El Seno',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,201,N'Rural',NULL),
	 (80635,N'Salom�n',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,224,N'Rural',NULL),
	 (80635,N'Vinater�as',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,245,N'Rural',NULL),
	 (80635,N'La Mesa',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,259,N'Rural',NULL),
	 (80636,N'Los Amoles',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,14,N'Rural',NULL),
	 (80636,N'La Calera',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,21,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80636,N'La Ci�nega',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,24,N'Rural',NULL),
	 (80636,N'El Molino (Molino de los P�rez)',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,40,N'Rural',NULL),
	 (80636,N'El Jacal',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,106,N'Rural',NULL),
	 (80636,N'Palmarito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,143,N'Rural',NULL),
	 (80636,N'La Ensenada',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,144,N'Rural',NULL),
	 (80636,N'Jer�nimo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,211,N'Rural',NULL),
	 (80636,N'El Muertecito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,216,N'Rural',NULL),
	 (80636,N'Rancho de Luna',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,222,N'Rural',NULL),
	 (80636,N'Agujas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,269,N'Rural',NULL),
	 (80636,N'El Potrero de Bejarano',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,3090,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80639,N'Piedra Bola',N'Pueblo',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,28,3,2,N'Rural',NULL),
	 (80639,N'El Pinito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,55,N'Rural',NULL),
	 (80639,N'El Saucito (El Saucito de Lugo)',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,72,N'Rural',NULL),
	 (80639,N'Los Alisitos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,82,N'Rural',NULL),
	 (80639,N'El Gato',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,103,N'Rural',NULL),
	 (80639,N'El Guayabo de Abajo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,171,N'Rural',NULL),
	 (80639,N'El Guayabo de Arriba',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,172,N'Rural',NULL),
	 (80639,N'Terreros Bayos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,189,N'Rural',NULL),
	 (80639,N'Los Cocos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,270,N'Rural',NULL),
	 (80639,N'Mesa Colorada',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,276,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80639,N'Calabazas',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,466,N'Rural',NULL),
	 (80640,N'Las Cuevitas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,268,N'Rural',NULL),
	 (80640,N'El Triguito',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,467,N'Rural',NULL),
	 (80643,N'Alisos (Alisitos)',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,12,N'Rural',NULL),
	 (80644,N'Las Pozas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,61,N'Rural',NULL),
	 (80644,N'El Ranchito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,63,N'Rural',NULL),
	 (80644,N'El Ojito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,120,N'Rural',NULL),
	 (80644,N'Santa Rita de Abajo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,186,N'Rural',NULL),
	 (80644,N'El Garbancito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,204,N'Rural',NULL),
	 (80645,N'Los Lobitos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,35,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80645,N'La Palma',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,49,N'Rural',NULL),
	 (80645,N'El Pinal',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,54,N'Rural',NULL),
	 (80645,N'Santa Rita de Arriba',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,128,N'Rural',NULL),
	 (80646,N'El Palmar de Santa Rita',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,50,N'Rural',NULL),
	 (80646,N'La Hacienda',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,205,N'Rural',NULL),
	 (80646,N'La Mesa del Fierro',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,3131,N'Rural',NULL),
	 (80670,N'Arroyo de los Pay�n',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,15,N'Rural',NULL),
	 (80670,N'La Catalina',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,23,N'Rural',NULL),
	 (80670,N'La Cofrad�a',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,26,N'Rural',NULL),
	 (80670,N'El Epazote',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,30,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80670,N'El Reparo',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,65,N'Rural',NULL),
	 (80670,N'El Saucito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,73,N'Rural',NULL),
	 (80670,N'El Vallecito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,80,N'Rural',NULL),
	 (80670,N'La Pitahayita',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,109,N'Rural',NULL),
	 (80670,N'El Terrero',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,139,N'Rural',NULL),
	 (80670,N'Jajalpa',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,155,N'Rural',NULL),
	 (80670,N'El Mezquite',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,213,N'Rural',NULL),
	 (80670,N'El Zapotillo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,231,N'Rural',NULL),
	 (80670,N'Tameapa',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,468,N'Rural',NULL),
	 (80673,N'El Sapo',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,156,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80673,N'Batacomito',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,159,N'Rural',NULL),
	 (80673,N'El Potrero de los P�rez',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,183,N'Rural',NULL),
	 (80673,N'Alisitos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,197,N'Rural',NULL),
	 (80673,N'Tegoripa',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,469,N'Rural',NULL),
	 (80674,N'El Terrero',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,137,N'Rural',NULL),
	 (80675,N'Los Nogales',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,44,N'Rural',NULL),
	 (80675,N'Tepaca',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,77,N'Rural',NULL),
	 (80675,N'La Soledad',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,188,N'Rural',NULL),
	 (80675,N'El Aguaje',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,256,N'Rural',NULL),
	 (80677,N'La Vainilla',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,79,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80677,N'El Potrerito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,151,N'Rural',NULL),
	 (80677,N'Guanajuato',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,170,N'Rural',NULL),
	 (80677,N'Alisos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,196,N'Rural',NULL),
	 (80677,N'La Haciendita',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,206,N'Rural',NULL),
	 (80677,N'El Realito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,223,N'Rural',NULL),
	 (80677,N'El Arroyo de la Vainilla',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,254,N'Rural',NULL),
	 (80677,N'Santiago de los Caballeros (Santiago)',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,470,N'Rural',NULL),
	 (80678,N'La Ladrillera',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,110,N'Rural',NULL),
	 (80678,N'Santa Cruz',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,185,N'Rural',NULL),
	 (80678,N'Los Tepehuajes',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,2970,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80679,N'Los Naranjos',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,42,N'Rural',NULL),
	 (80679,N'El Pueblito',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,152,N'Rural',NULL),
	 (80679,N'Los Veneros',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,230,N'Rural',NULL),
	 (80679,N'Los Rebajes',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,250,N'Rural',NULL),
	 (80679,N'La Lapara',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,471,N'Rural',NULL),
	 (80680,N'Las Paredes',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,51,N'Rural',NULL),
	 (80680,N'Huixiopa',N'Pueblo',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,28,3,472,N'Rural',NULL),
	 (80680,N'Bacacoragua',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,2308,N'Rural',NULL),
	 (80683,N'El Aguaje',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,7,N'Rural',NULL),
	 (80683,N'Potrero de Victoria',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,60,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80683,N'El Mentidero',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,115,N'Rural',NULL),
	 (80683,N'La Huerta',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,209,N'Rural',NULL),
	 (80683,N'Yesqueros',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,275,N'Rural',NULL),
	 (80683,N'Revolcadero',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,3006,N'Rural',NULL),
	 (80684,N'Lim�n de los Aguirre',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,108,N'Rural',NULL),
	 (80684,N'La Lechuguilla',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,111,N'Rural',NULL),
	 (80685,N'Arroyo Seco',N'Rancher�a',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,29,3,85,N'Rural',NULL),
	 (80685,N'Los Cuates',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,97,N'Rural',NULL),
	 (80685,N'La Vainilla',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,150,N'Rural',NULL),
	 (80685,N'El Aguaje',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,195,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80685,N'El Chorro',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,203,N'Rural',NULL),
	 (80685,N'Las G�ejas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,208,N'Rural',NULL),
	 (80686,N'Los Terreros',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,138,N'Rural',NULL),
	 (80686,N'Los Sauces',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,187,N'Rural',NULL),
	 (80687,N'Milpas Viejas',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,116,N'Rural',NULL),
	 (80687,N'Persogaderos',N'Rancho',N'Badiraguato',N'Sinaloa',N'',80501,25,80501,NULL,48,3,125,N'Rural',NULL),
	 (80700,N'Lomas de San Juan',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,83,N'Urbano',21),
	 (80700,N'Cosala Centro',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,473,N'Urbano',21),
	 (80702,N'Las Quintas',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,1661,N'Urbano',21),
	 (80702,N'S�nchez Celis',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,1666,N'Urbano',21);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80702,N'Capellanes',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,2283,N'Urbano',21),
	 (80704,N'Los Arroyos',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,4,N'Urbano',21),
	 (80704,N'Las Lomitas',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,1665,N'Urbano',21),
	 (80705,N'Baj�o',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,1659,N'Urbano',21),
	 (80706,N'Canela',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,1660,N'Urbano',21),
	 (80706,N'Sierra Mojada',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,1662,N'Urbano',21),
	 (80706,N'El Rastro',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,2282,N'Urbano',21),
	 (80707,N'VIVAH',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,81,N'Urbano',21),
	 (80707,N'Luis Donaldo Colosio',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,1663,N'Urbano',21),
	 (80708,N'El Llano de La Carrera',N'Colonia',N'Cosal�',N'Sinaloa',N'Cosal�',80701,25,80701,NULL,9,5,1664,N'Urbano',21);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80720,N'Los Llanos de Refugio',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,63,N'Rural',NULL),
	 (80720,N'El Guam�chil',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,79,N'Rural',NULL),
	 (80720,N'La Ilama',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,475,N'Rural',NULL),
	 (80723,N'El Reparo',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,26,N'Rural',NULL),
	 (80723,N'La Vuelta del Cerro',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,32,N'Rural',NULL),
	 (80723,N'El Veinticuatro',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,39,N'Rural',NULL),
	 (80724,N'Las Amargosas',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,7,N'Rural',NULL),
	 (80724,N'Tachichilte',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,36,N'Rural',NULL),
	 (80724,N'El Sauce',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,37,N'Rural',NULL),
	 (80725,N'Bacata',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,476,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80726,N'Los Cedritos',N'Pueblo',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,28,5,3,N'Rural',NULL),
	 (80730,N'El Tecomate',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,30,N'Rural',NULL),
	 (80730,N'Las Milpas del Carrizo',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,71,N'Rural',NULL),
	 (80733,N'Los Mimbritos',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,19,N'Rural',NULL),
	 (80733,N'Los Mimbres',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,3142,N'Rural',NULL),
	 (80734,N'El Palmarito',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,22,N'Rural',NULL),
	 (80734,N'Santa Ana',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,28,N'Rural',NULL),
	 (80734,N'El Zapote',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,42,N'Rural',NULL),
	 (80735,N'Pueblo de Alay�',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,24,N'Rural',NULL),
	 (80736,N'El Ranchito',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,478,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80737,N'Los Algodones',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,6,N'Rural',NULL),
	 (80737,N'El Vertedor',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,38,N'Rural',NULL),
	 (80737,N'Higueras de Jacopa',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,2208,N'Rural',NULL),
	 (80738,N'Santa Anita',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,477,N'Rural',NULL),
	 (80740,N'La Culacha',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,10,N'Rural',NULL),
	 (80743,N'La Rastra',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,25,N'Rural',NULL),
	 (80743,N'El Caj�n de las Minas',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,33,N'Rural',NULL),
	 (80743,N'Mezcaltit�n',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,479,N'Rural',NULL),
	 (80744,N'Pueblo Nuevo',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,80,N'Rural',NULL),
	 (80750,N'Agua Caliente',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,5,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80750,N'El Rinc�n de la Lagunita',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,69,N'Rural',NULL),
	 (80750,N'Chiricahueto',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,2700,N'Rural',NULL),
	 (80753,N'Higueras de Campa�a',N'Pueblo',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,28,5,2955,N'Rural',NULL),
	 (80754,N'Palmar de los Ceballos',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,21,N'Rural',NULL),
	 (80754,N'Palmillas',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,68,N'Rural',NULL),
	 (80755,N'La Ciruelita',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,40,N'Rural',NULL),
	 (80756,N'El Bichi',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,58,N'Rural',NULL),
	 (80756,N'El Cerro de los Barraza',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,61,N'Rural',NULL),
	 (80757,N'Lo de Garza',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,18,N'Rural',NULL),
	 (80758,N'El Realito',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,1,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80758,N'Los Vasitos',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,31,N'Rural',NULL),
	 (80758,N'Los Carricitos',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,60,N'Rural',NULL),
	 (80760,N'El Carrizal',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,480,N'Rural',NULL),
	 (80763,N'Las Truchas',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,34,N'Rural',NULL),
	 (80764,N'Pozo Zarco',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,23,N'Rural',NULL),
	 (80764,N'La Ci�nega',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,62,N'Rural',NULL),
	 (80764,N'San Jos� de las Bocas',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,70,N'Rural',NULL),
	 (80764,N'Los Tigres',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,73,N'Rural',NULL),
	 (80770,N'Las Habas',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,12,N'Rural',NULL),
	 (80770,N'La Huerta',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,15,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80770,N'Ibon�a',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,41,N'Rural',NULL),
	 (80770,N'Santa Cruz de Alay�',N'Pueblo',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,28,5,482,N'Rural',NULL),
	 (80770,N'Chapala',N'Pueblo',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,28,5,2527,N'Rural',NULL),
	 (80773,N'Picacho',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,72,N'Rural',NULL),
	 (80773,N'El Vaso',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,74,N'Rural',NULL),
	 (80773,N'San Miguel de las Mesas',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,483,N'Rural',NULL),
	 (80774,N'Los Mimbres de Quiroz',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,20,N'Rural',NULL),
	 (80774,N'Palo Dulce',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,35,N'Rural',NULL),
	 (80775,N'El Sabino',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,27,N'Rural',NULL),
	 (80775,N'La Cuchilla (Cachahua)',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,43,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80775,N'Los Aguajitos',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,44,N'Rural',NULL),
	 (80775,N'Buenavista',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,45,N'Rural',NULL),
	 (80775,N'La Ca�ita',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,47,N'Rural',NULL),
	 (80775,N'Las Cup�as de Cachahua',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,49,N'Rural',NULL),
	 (80775,N'Los Salates',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,56,N'Rural',NULL),
	 (80775,N'El Caj�n de Cachahua',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,59,N'Rural',NULL),
	 (80776,N'Calafato',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,484,N'Rural',NULL),
	 (80776,N'El Potrero',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,485,N'Rural',NULL),
	 (80776,N'El Rodeo',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,486,N'Rural',NULL),
	 (80776,N'Vado Hondo',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,2895,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80777,N'El Huizachal',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,16,N'Rural',NULL),
	 (80777,N'La Chuchupira',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,50,N'Rural',NULL),
	 (80777,N'El Jag�ey',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,51,N'Rural',NULL),
	 (80777,N'La Palma',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,53,N'Rural',NULL),
	 (80777,N'Palo Verde',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,66,N'Rural',NULL),
	 (80778,N'Ipucha',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,17,N'Rural',NULL),
	 (80778,N'Las Mimbres (Las Mimbres del Padre)',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,64,N'Rural',NULL),
	 (80778,N'El Papachal',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,67,N'Rural',NULL),
	 (80778,N'Comoa',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,487,N'Rural',NULL),
	 (80780,N'Los Braceros',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,8,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80783,N'Las Higueras de Urrea',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,14,N'Rural',NULL),
	 (80783,N'Higueras de Padilla',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,481,N'Rural',NULL),
	 (80784,N'Los Molinos',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,65,N'Rural',NULL),
	 (80784,N'Cholula',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,489,N'Rural',NULL),
	 (80784,N'El Portezuelo',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,490,N'Rural',NULL),
	 (80785,N'Higuera Larga',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,13,N'Rural',NULL),
	 (80786,N'Los Bulitos',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,9,N'Rural',NULL),
	 (80786,N'Santa Cruz',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,29,N'Rural',NULL),
	 (80786,N'La Estancia',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,491,N'Rural',NULL),
	 (80790,N'Guadalupe de los Reyes',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,11,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80790,N'El Camich�n',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,46,N'Rural',NULL),
	 (80793,N'El Capule',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,48,N'Rural',NULL),
	 (80793,N'Potrerillo de los Torres',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,54,N'Rural',NULL),
	 (80793,N'Agua Caliente de los Urrea',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,75,N'Rural',NULL),
	 (80794,N'El Saucito',N'Rancher�a',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,29,5,57,N'Rural',NULL),
	 (80794,N'El Pino',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,77,N'Rural',NULL),
	 (80794,N'El Tule',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,78,N'Rural',NULL),
	 (80795,N'El Sauz',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,76,N'Rural',NULL),
	 (80797,N'La Tasajera',N'Pueblo',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,28,5,2,N'Rural',NULL),
	 (80797,N'Llano Grande',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,52,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80797,N'Las Habitas',N'Rancho',N'Cosal�',N'Sinaloa',N'',80701,25,80701,NULL,48,5,55,N'Rural',NULL),
	 (80800,N'Mocorito Centro',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,1396,N'Urbano',14),
	 (80803,N'Bugambilias',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,3172,N'Urbano',14),
	 (80803,N'Candilejas',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,3173,N'Urbano',14),
	 (80804,N'Las Delicias',N'Barrio',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,2,13,1806,N'Urbano',14),
	 (80804,N'Mercadito',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,3174,N'Urbano',14),
	 (80805,N'Las Casitas Nuevas',N'Fraccionamiento',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,21,13,80,N'Urbano',14),
	 (80805,N'Fovissste',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,1809,N'Urbano',14),
	 (80805,N'Las Playitas',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,3175,N'Urbano',14),
	 (80805,N'La Brecha',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,3176,N'Urbano',14);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80806,N'Los M�sicos',N'Fraccionamiento',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,21,13,83,N'Urbano',14),
	 (80806,N'Infonavit',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,1808,N'Rural',14),
	 (80806,N'Las Palmas',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,3177,N'Urbano',14),
	 (80807,N'La Primavera',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,84,N'Urbano',14),
	 (80807,N'Aviaci�n',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,1807,N'Urbano',14),
	 (80807,N'Tabachines',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,3178,N'Urbano',14),
	 (80807,N'La Loma',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,3179,N'Urbano',14),
	 (80808,N'Alameda',N'Colonia',N'Mocorito',N'Sinaloa',N'Mocorito',80801,25,80801,NULL,9,13,3180,N'Urbano',14),
	 (80810,N'Constancio Rodr�guez (La Otra Banda)',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,2373,N'Rural',NULL),
	 (80830,N'Alhueycito',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1397,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80830,N'Cerro Agudo',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1398,N'Rural',NULL),
	 (80830,N'Los P�rez',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,1399,N'Rural',NULL),
	 (80830,N'Rancho Viejo',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1400,N'Rural',NULL),
	 (80830,N'Las Milpas de los Gonz�lez',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1401,N'Rural',NULL),
	 (80830,N'Palmarito Mineral',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1402,N'Rural',NULL),
	 (80833,N'El Salto',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,4,N'Rural',NULL),
	 (80833,N'Lo de Gabriel',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,25,N'Rural',NULL),
	 (80833,N'Mautillos',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,26,N'Rural',NULL),
	 (80833,N'Las Tahonas',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1403,N'Rural',NULL),
	 (80833,N'El Valle de Leyva Solano (El Valle)',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1404,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80833,N'La Palma',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1405,N'Rural',NULL),
	 (80833,N'La Campanilla',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,3066,N'Rural',NULL),
	 (80833,N'El Reparo de los Galindo',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,3194,N'Rural',NULL),
	 (80834,N'La Ladrillera',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,24,N'Rural',NULL),
	 (80834,N'Ranchito de los Gaxiola',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,41,N'Rural',NULL),
	 (80834,N'La Primavera',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,59,N'Rural',NULL),
	 (80834,N'El Chinal',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1406,N'Rural',NULL),
	 (80834,N'Lomas Blancas',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1407,N'Rural',NULL),
	 (80834,N'Las Juntas',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,3077,N'Rural',NULL),
	 (80836,N'La Ca�ada',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,13,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80836,N'Los Pocitos',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1408,N'Rural',NULL),
	 (80840,N'El Becal',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1409,N'Rural',NULL),
	 (80840,N'Higuera de los Vega',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1410,N'Rural',NULL),
	 (80840,N'Palo de Asta',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1411,N'Rural',NULL),
	 (80840,N'Mazate de los L�pez',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1412,N'Rural',NULL),
	 (80840,N'Mazate de los S�nchez',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1413,N'Rural',NULL),
	 (80845,N'El Tule de Arriba',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1414,N'Rural',NULL),
	 (80845,N'El Gallo',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1415,N'Rural',NULL),
	 (80846,N'La Joya de los L�pez',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,2,N'Rural',NULL),
	 (80846,N'La Laguna',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,3,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80846,N'Corral Quemado',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,17,N'Rural',NULL),
	 (80846,N'Boca de Guam�chil',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,22,N'Rural',NULL),
	 (80846,N'Los Vasitos',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,51,N'Rural',NULL),
	 (80846,N'Los Charcos',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,64,N'Rural',NULL),
	 (80846,N'El Sauce de los G�mez',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1416,N'Rural',NULL),
	 (80846,N'Milpas Viejas',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1417,N'Rural',NULL),
	 (80846,N'Tabalopa',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1418,N'Rural',NULL),
	 (80850,N'Los Medina',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,58,N'Rural',NULL),
	 (80850,N'El Tule',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1419,N'Rural',NULL),
	 (80850,N'El Mezquite',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1420,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80850,N'El Magistral',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1421,N'Rural',NULL),
	 (80853,N'Lagunillas',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,5,N'Rural',NULL),
	 (80853,N'Bacamopa',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,8,N'Rural',NULL),
	 (80853,N'Cahuinahuato',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,10,N'Rural',NULL),
	 (80853,N'El Encinal',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,21,N'Rural',NULL),
	 (80853,N'El Nacimiento',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,31,N'Rural',NULL),
	 (80853,N'El Pueblito',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,39,N'Rural',NULL),
	 (80853,N'Cahuinahuatillo',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,55,N'Rural',NULL),
	 (80853,N'La Loma',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,57,N'Rural',NULL),
	 (80853,N'El Potrero Grande',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,61,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80853,N'Rinc�n de los Santos',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1422,N'Rural',NULL),
	 (80853,N'Los Llanos',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1423,N'Rural',NULL),
	 (80853,N'Canutillos',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1424,N'Rural',NULL),
	 (80853,N'La Virgen',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,2884,N'Rural',NULL),
	 (80853,N'El Potrero de las Perdices',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,2885,N'Rural',NULL),
	 (80853,N'El Manch�n',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,3124,N'Rural',NULL),
	 (80853,N'El Taray',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,3125,N'Rural',NULL),
	 (80853,N'San Miguel',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,3126,N'Rural',NULL),
	 (80853,N'La Higuerita',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,3130,N'Rural',NULL),
	 (80854,N'La Bebelama',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,62,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80854,N'Santa Rosal�a',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1425,N'Rural',NULL),
	 (80854,N'La Pionilla',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,3127,N'Rural',NULL),
	 (80855,N'Las Quebradas',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,40,N'Rural',NULL),
	 (80855,N'El Salto',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,46,N'Rural',NULL),
	 (80855,N'Terrero de los Pacheco',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1426,N'Rural',NULL),
	 (80855,N'Palos Colorados',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1427,N'Rural',NULL),
	 (80855,N'Palo Verde',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1428,N'Rural',NULL),
	 (80856,N'El Aguaje',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,6,N'Rural',NULL),
	 (80856,N'La Higuera Ca�da',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,23,N'Rural',NULL),
	 (80856,N'Rancho Viejo',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,42,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80856,N'El Recodo',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,43,N'Rural',NULL),
	 (80856,N'El Sabinito',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,45,N'Rural',NULL),
	 (80856,N'Palmarito de la Sierra (Casas de Abajo)',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,56,N'Rural',NULL),
	 (80856,N'La Cascada',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,63,N'Rural',NULL),
	 (80856,N'El Lanc�n N�mero Dos',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,65,N'Rural',NULL),
	 (80856,N'Loma Redonda',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,66,N'Rural',NULL),
	 (80856,N'La Tasajera',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,69,N'Rural',NULL),
	 (80856,N'Los Letreros',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1429,N'Rural',NULL),
	 (80856,N'La Laguna de los Boj�rquez',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1430,N'Rural',NULL),
	 (80856,N'Ojo de Agua',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1431,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80856,N'Potrero de los Gast�lum',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1432,N'Rural',NULL),
	 (80856,N'Las Milpas de los Valenzuela',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1433,N'Rural',NULL),
	 (80856,N'Guam�chiles Altos',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1434,N'Rural',NULL),
	 (80856,N'La Cueva',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1435,N'Rural',NULL),
	 (80856,N'Palmarito de la Sierra',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,2995,N'Rural',NULL),
	 (80857,N'San Benito',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1436,N'Rural',NULL),
	 (80870,N'El Guasimal',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1438,N'Rural',NULL),
	 (80870,N'Bequillos',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1439,N'Rural',NULL),
	 (80873,N'El Lim�n',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1440,N'Rural',NULL),
	 (80873,N'El Zapote de los Moya',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1441,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80875,N'Los Chinos',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,20,N'Rural',NULL),
	 (80875,N'Bebelama',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1442,N'Rural',NULL),
	 (80875,N'El Sabino Gordo',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1443,N'Rural',NULL),
	 (80875,N'Lo de F�lix',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1444,N'Rural',NULL),
	 (80875,N'La Huerta',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,2374,N'Rural',NULL),
	 (80876,N'Pochotillos',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,53,N'Rural',NULL),
	 (80876,N'La Higuerita',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,72,N'Rural',NULL),
	 (80876,N'Bequillitos',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1446,N'Rural',NULL),
	 (80876,N'La Palma Envuelta',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1447,N'Rural',NULL),
	 (80876,N'Palma de los Rocha',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,3193,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80877,N'Aguaje de Rosa Morada',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,7,N'Rural',NULL),
	 (80877,N'Portezuelo de Abajo',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,35,N'Rural',NULL),
	 (80877,N'Portezuelo de Arriba',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,36,N'Rural',NULL),
	 (80880,N'La Nanche',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,32,N'Rural',NULL),
	 (80880,N'Potrero de los Guerrero',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,38,N'Rural',NULL),
	 (80880,N'La Tasajera',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,70,N'Rural',NULL),
	 (80880,N'La Estancia',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,71,N'Rural',NULL),
	 (80880,N'Rosa Morada',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1448,N'Rural',NULL),
	 (80880,N'El Limoncito',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1449,N'Rural',NULL),
	 (80880,N'La Calera de los Moya',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1450,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80880,N'El Carrizal',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,3065,N'Rural',NULL),
	 (80883,N'Puerta de los Rocha',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1451,N'Rural',NULL),
	 (80883,N'El Guayabito',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,2724,N'Rural',NULL),
	 (80884,N'El N�mero Tres',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,33,N'Rural',NULL),
	 (80884,N'La Reforma',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,44,N'Rural',NULL),
	 (80884,N'El Sauce de Arriba',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,49,N'Rural',NULL),
	 (80884,N'La Ca�ada',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1452,N'Rural',NULL),
	 (80884,N'La Noria de Arriba',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1453,N'Rural',NULL),
	 (80884,N'La Noria de Abajo',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1454,N'Rural',NULL),
	 (80884,N'Batamotita',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1455,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80884,N'El Malinal',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1456,N'Rural',NULL),
	 (80885,N'Jurisdicci�n de Abajo',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1457,N'Rural',NULL),
	 (80885,N'Los Mezcales',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1458,N'Rural',NULL),
	 (80886,N'Bacamacari',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1459,N'Rural',NULL),
	 (80887,N'El Aguajito de Le�n',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1460,N'Rural',NULL),
	 (80887,N'Potrerillos Aguajito de Le�n',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1461,N'Rural',NULL),
	 (80888,N'Mezquite Gordo',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,28,N'Rural',NULL),
	 (80890,N'El Palmar de los Leal',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1462,N'Rural',NULL),
	 (80893,N'La Loma (El Alt�n)',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,76,N'Rural',NULL),
	 (80893,N'Boca de Arroyo',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1463,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80893,N'La Misi�n',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1464,N'Rural',NULL),
	 (80894,N'El Pochote',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1465,N'Rural',NULL),
	 (80895,N'Mecatita de Abajo',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,27,N'Rural',NULL),
	 (80895,N'San Juan',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,48,N'Rural',NULL),
	 (80895,N'Mecatita de Arriba',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1466,N'Rural',NULL),
	 (80895,N'Los �ngeles',N'Ejido',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,15,13,1467,N'Rural',NULL),
	 (80895,N'Tecomate',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,1468,N'Rural',NULL),
	 (80895,N'La Cofrad�a de Soto',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1469,N'Rural',NULL),
	 (80896,N'Monte Verde',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,29,N'Rural',NULL),
	 (80896,N'El Progreso (El Jal�n)',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1470,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80896,N'Tepantita',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,28,13,1471,N'Rural',NULL),
	 (80897,N'Potrerillos',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,29,13,37,N'Rural',NULL),
	 (80920,N'El Platanar',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,1473,N'Rural',NULL),
	 (80920,N'La Nanchita',N'Ejido',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,15,13,1474,N'Rural',NULL),
	 (80923,N'El Tancote',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,2983,N'Rural',NULL),
	 (80925,N'El Guadare',N'Ejido',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,15,13,1477,N'Rural',NULL),
	 (80926,N'El Chino',N'Ejido',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,15,13,1478,N'Rural',NULL),
	 (80926,N'El Guam�chil',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,1479,N'Rural',NULL),
	 (80926,N'El Zapote de los C�zares',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,1480,N'Rural',NULL),
	 (80927,N'Majada de Abajo',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,28,13,1481,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80927,N'Piedras Blancas',N'Ejido',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,15,13,1482,N'Rural',NULL),
	 (80928,N'Chicorato',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,19,N'Rural',NULL),
	 (80928,N'Sasalpa',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,2984,N'Rural',NULL),
	 (80930,N'Perico Petrolero',N'Rancho',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,48,13,68,N'Rural',NULL),
	 (80930,N'Bachoco Pollo',N'Granja',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,23,13,79,N'Rural',NULL),
	 (80930,N'Juan Escutia',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,28,13,1483,N'Rural',NULL),
	 (80930,N'Santiago de Comanito (Comanito)',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,28,13,1498,N'Rural',NULL),
	 (80935,N'El Barrial de Capirato',N'Rancho',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,48,13,9,N'Rural',NULL),
	 (80935,N'La Calera de Capirato',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,11,N'Rural',NULL),
	 (80935,N'La Cofrad�a de Capirato',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,16,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80935,N'El Salto (De Capirato)',N'Rancho',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,48,13,60,N'Rural',NULL),
	 (80935,N'Las Aguamitas',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,73,N'Rural',NULL),
	 (80936,N'El Carrizo',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,15,N'Rural',NULL),
	 (80936,N'La Morita',N'Rancho',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,48,13,30,N'Rural',NULL),
	 (80936,N'La Vainilla',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,28,13,1484,N'Rural',NULL),
	 (80936,N'Tepuche',N'Ejido',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,15,13,1485,N'Rural',NULL),
	 (80936,N'Aguapepe de los Gallardo',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,1486,N'Rural',NULL),
	 (80936,N'Capirato',N'Ejido',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,15,13,2376,N'Rural',NULL),
	 (80940,N'El Zapote de los Gast�lum',N'Rancho',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,48,13,1,N'Rural',NULL),
	 (80940,N'Juan Escutia',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,75,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80940,N'El Aguaje de Pericos',N'Ejido',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,15,13,2375,N'Rural',NULL),
	 (80940,N'Guamuchilera Segunda',N'Ejido',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,15,13,2377,N'Rural',NULL),
	 (80950,N'Pericos',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,28,13,1497,N'Rural',NULL),
	 (80950,N'Guadalupe',N'Colonia',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,9,13,2050,N'Rural',NULL),
	 (80950,N'Fonhapo',N'Colonia',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,9,13,2051,N'Rural',NULL),
	 (80950,N'Salinas de Gortari',N'Colonia',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,9,13,2052,N'Rural',NULL),
	 (80950,N'Del Parque',N'Colonia',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,9,13,2053,N'Rural',NULL),
	 (80950,N'La Loma',N'Colonia',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,9,13,2054,N'Rural',NULL),
	 (80953,N'Calomato (Calomatillo)',N'Ejido',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,15,13,12,N'Rural',NULL),
	 (80953,N'El Rosario (Chayo)',N'Colonia',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,9,13,18,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80953,N'La Pipima',N'Rancho',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,48,13,34,N'Rural',NULL),
	 (80953,N'San Francisco (El Crucero)',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,47,N'Rural',NULL),
	 (80953,N'El Nazario [SPR]',N'Rancho',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,48,13,78,N'Rural',NULL),
	 (80953,N'Albergue Calomato',N'Equipamiento',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,17,13,81,N'Rural',NULL),
	 (80954,N'Los Altos de Jalisco',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80321,25,80321,NULL,29,13,52,N'Rural',NULL),
	 (80954,N'Dique Mariquita',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80321,25,80321,NULL,29,13,67,N'Rural',NULL),
	 (80954,N'Calomato',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80321,25,80321,NULL,28,13,1487,N'Rural',NULL),
	 (80954,N'El Rodeo',N'Ejido',N'Mocorito',N'Sinaloa',N'',80321,25,80321,NULL,15,13,1488,N'Rural',NULL),
	 (80955,N'El Capule',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80321,25,80321,NULL,29,13,14,N'Rural',NULL),
	 (80955,N'Santa Mar�a',N'Rancho',N'Mocorito',N'Sinaloa',N'',80321,25,80321,NULL,48,13,82,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80955,N'Agua Salada',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80321,25,80321,NULL,28,13,1489,N'Rural',NULL),
	 (80956,N'El Bueycito',N'Ejido',N'Mocorito',N'Sinaloa',N'',80321,25,80321,NULL,15,13,1490,N'Rural',NULL),
	 (80957,N'La Loma',N'Rancho',N'Mocorito',N'Sinaloa',N'',80321,25,80321,NULL,48,13,77,N'Rural',NULL),
	 (80957,N'Caimanero',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80321,25,80321,NULL,28,13,1492,N'Rural',NULL),
	 (80957,N'Estaci�n Retes',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80321,25,80321,NULL,28,13,1493,N'Rural',NULL),
	 (80957,N'Recoveco',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80321,25,80321,NULL,28,13,1495,N'Rural',NULL),
	 (80960,N'Potrero de los S�nchez (Estaci�n Techa)',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',81601,25,81601,NULL,29,13,1496,N'Rural',NULL),
	 (80963,N'Rancho Viejo',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,29,13,1472,N'Rural',NULL),
	 (80964,N'Zapotillo',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',81601,25,81601,NULL,29,13,1494,N'Rural',NULL),
	 (80965,N'San Jorge',N'Rancher�a',N'Mocorito',N'Sinaloa',N'',81601,25,81601,NULL,29,13,54,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (80965,N'Melchor Ocampo',N'Pueblo',N'Mocorito',N'Sinaloa',N'',81601,25,81601,NULL,28,13,1476,N'Rural',NULL),
	 (80966,N'Tierritas Blancas',N'Pueblo',N'Mocorito',N'Sinaloa',N'',80001,25,80001,NULL,28,13,1475,N'Rural',NULL),
	 (80967,N'Tobora',N'Rancho',N'Mocorito',N'Sinaloa',N'',80801,25,80801,NULL,48,13,50,N'Rural',NULL),
	 (81000,N'Centro',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,579,N'Urbano',4),
	 (81010,N'Ocoro',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,581,N'Urbano',4),
	 (81014,N'2 de Octubre',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,582,N'Urbano',4),
	 (81014,N'Fresno',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,2703,N'Urbano',4),
	 (81015,N'La Florida',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,583,N'Urbano',4),
	 (81015,N'Once R�os',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,2174,N'Urbano',4),
	 (81016,N'Revoluci�n Mexicana',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,584,N'Urbano',4);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81017,N'La Piedrera',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,585,N'Urbano',4),
	 (81018,N'Independencia',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,586,N'Urbano',4),
	 (81020,N'Ejidal',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,588,N'Urbano',4),
	 (81028,N'San Jos�',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,3,N'Urbano',4),
	 (81028,N'Ayuntamiento 92',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,518,N'Urbano',4),
	 (81028,N'San Francisco',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,563,N'Urbano',4),
	 (81028,N'San Juan',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,565,N'Urbano',4),
	 (81028,N'Valle Bonito',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,589,N'Urbano',4),
	 (81028,N'Josefa Ortiz de Dom�nguez',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,1983,N'Urbano',4),
	 (81029,N'SAFINSA Guasave',N'Zona industrial',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,37,11,169,N'Urbano',4);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81029,N'Sector la Cruz',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,176,N'Urbano',4),
	 (81029,N'Eduardo Labastida',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,529,N'Urbano',4),
	 (81029,N'Los Sauces',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,549,N'Urbano',4),
	 (81029,N'STASE',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,571,N'Urbano',4),
	 (81029,N'Sinaloa',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,590,N'Urbano',4),
	 (81029,N'M�xico',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,1987,N'Urbano',4),
	 (81030,N'Sector La Ermita',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,2173,N'Urbano',4),
	 (81030,N'Sector DIF',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,2899,N'Urbano',4),
	 (81040,N'Del Bosque',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,528,N'Urbano',4),
	 (81040,N'�ngel Flores',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,593,N'Urbano',4);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81042,N'San Carlos',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,561,N'Urbano',4),
	 (81043,N'Electricistas',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,530,N'Urbano',4),
	 (81043,N'Valle del Sol',N'Fraccionamiento',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,21,11,575,N'Urbano',4),
	 (81043,N'San Fernando',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,1984,N'Urbano',4),
	 (81044,N'Fundadores Residencial',N'Fraccionamiento',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,21,11,9,N'Urbano',4),
	 (81044,N'Electricistas',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,175,N'Urbano',4),
	 (81045,N'Ampliaci�n Santa Mar�a',N'Fraccionamiento',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,21,11,10,N'Urbano',4),
	 (81045,N'L�zaro C�rdenas',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,170,N'Urbano',4),
	 (81045,N'Petatl�n',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,553,N'Urbano',4),
	 (81045,N'Margaritas',N'Fraccionamiento',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,21,11,1988,N'Urbano',4);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81045,N'Santa Mar�a',N'Fraccionamiento',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,21,11,2850,N'Urbano',4),
	 (81048,N'Residencial Campestre',N'Fraccionamiento',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,21,11,1,N'Urbano',4),
	 (81048,N'Las Palmas',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,540,N'Urbano',4),
	 (81048,N'Lomas del Mar',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,595,N'Urbano',4),
	 (81048,N'U.N.E.',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,1990,N'Urbano',4),
	 (81048,N'Delicias',N'Fraccionamiento',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,21,11,1991,N'Urbano',4),
	 (81048,N'Jardines del Sol',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,2178,N'Urbano',4),
	 (81048,N'Las Garzas',N'Fraccionamiento',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,21,11,2180,N'Urbano',4),
	 (81048,N'Santa Fe',N'Fraccionamiento',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,21,11,2267,N'Urbano',4),
	 (81048,N'Uni�n de Colonos',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,2849,N'Urbano',4);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81049,N'Santa Clara',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,2,N'Urbano',4),
	 (81049,N'Miguel Leyson P�rez',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,7,N'Urbano',4),
	 (81049,N'Bugambilias',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,522,N'Urbano',4),
	 (81049,N'Las Glorias',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,539,N'Urbano',4),
	 (81049,N'Constelaci�n',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,596,N'Urbano',4),
	 (81049,N'Doctores',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,2176,N'Urbano',4),
	 (81049,N'San Joachin',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,2177,N'Urbano',4),
	 (81050,N'Sector Rivera',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,597,N'Urbano',4),
	 (81060,N'Magisterial',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,600,N'Urbano',4),
	 (81065,N'Universitaria',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,6,N'Urbano',4);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81065,N'24 de Febrero',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,602,N'Urbano',4),
	 (81065,N'Tecomate',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,1992,N'Urbano',4),
	 (81066,N'18 de Marzo',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,603,N'Urbano',4),
	 (81075,N'Privada Popular',N'Fraccionamiento',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,21,11,4,N'Urbano',4),
	 (81075,N'Las Huertas',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,605,N'Urbano',4),
	 (81077,N'Makarenko',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,606,N'Urbano',4),
	 (81090,N'El Chaleco',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,612,N'Urbano',4),
	 (81090,N'Tierra y Libertad',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,613,N'Urbano',4),
	 (81095,N'Renato Vega Amador',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,557,N'Urbano',4),
	 (81095,N'17 de Mayo',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,614,N'Urbano',4);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81095,N'Jardines del Valle',N'Colonia',N'Guasave',N'Sinaloa',N'Guasave',81001,25,81001,NULL,9,11,2182,N'Urbano',4),
	 (81100,N'Cabreritas',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,11,N'Rural',NULL),
	 (81100,N'Las Choyitas',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,12,N'Rural',NULL),
	 (81100,N'L�zaro C�rdenas del R�o',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,13,N'Rural',NULL),
	 (81100,N'Las Playitas',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,14,N'Rural',NULL),
	 (81100,N'El Arroyo',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,15,N'Rural',NULL),
	 (81100,N'La Pelti',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,16,N'Rural',NULL),
	 (81100,N'El Varal (San Sebasti�n N�mero Uno)',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,615,N'Rural',NULL),
	 (81100,N'San Sebasti�n 2',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2427,N'Rural',NULL),
	 (81101,N'Las Compuertas',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,17,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81101,N'Campo B�rquez',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,18,N'Rural',NULL),
	 (81101,N'Agua Blanca',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,19,N'Rural',NULL),
	 (81101,N'Las Moritas',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,20,N'Rural',NULL),
	 (81101,N'Agua Blanca',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,21,N'Rural',NULL),
	 (81101,N'Agua Blancona',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,22,N'Rural',NULL),
	 (81101,N'San Fernandito',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,23,N'Rural',NULL),
	 (81101,N'La L�nea',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,24,N'Rural',NULL),
	 (81101,N'Las Gu�simas',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,25,N'Rural',NULL),
	 (81101,N'El Mezquital',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,26,N'Rural',NULL),
	 (81101,N'Canal 21',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,27,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81101,N'Canal Alto',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,29,N'Rural',NULL),
	 (81101,N'Los Guayacanes',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,30,N'Rural',NULL),
	 (81101,N'La Entrada',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,31,N'Rural',NULL),
	 (81101,N'Agua Escondida',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,33,N'Rural',NULL),
	 (81101,N'La Cruz',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,34,N'Rural',NULL),
	 (81101,N'La Providencia (Guayparime)',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,35,N'Rural',NULL),
	 (81101,N'El Campito',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,36,N'Rural',NULL),
	 (81101,N'Casa de la Comisi�n',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,39,N'Rural',NULL),
	 (81101,N'Caimanero',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,616,N'Rural',NULL),
	 (81101,N'Cofrad�a de Tamazula (La Cofrad�a)',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,617,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81101,N'El Dorado',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,619,N'Rural',NULL),
	 (81101,N'Guasavito',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,620,N'Rural',NULL),
	 (81101,N'La Entrada Vieja',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,621,N'Rural',NULL),
	 (81101,N'Los �ngeles',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,622,N'Urbano',NULL),
	 (81101,N'Ranchito de Castro',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,623,N'Rural',NULL),
	 (81101,N'San Joach�n',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,624,N'Rural',NULL),
	 (81101,N'Utatave (Mautillos)',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2428,N'Rural',NULL),
	 (81101,N'San Jos� de Guayparime',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2429,N'Rural',NULL),
	 (81101,N'Emilio Portes Gil (Agua Blanca)',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2494,N'Rural',NULL),
	 (81101,N'La Sabanilla [Campo Preciado]',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2582,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81101,N'5 de Mayo (Agua Blanca)',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2661,N'Rural',NULL),
	 (81101,N'La Uva',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2710,N'Rural',NULL),
	 (81102,N'Gambino',N'Ejido',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,15,11,625,N'Rural',NULL),
	 (81103,N'El Cerc�n',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,37,N'Rural',NULL),
	 (81103,N'La Cuchilla',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,38,N'Rural',NULL),
	 (81103,N'Ranchito de Caimanero (Infiernito)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,40,N'Rural',NULL),
	 (81103,N'Las Pitahayas',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,41,N'Rural',NULL),
	 (81103,N'Las Palmitas',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,42,N'Rural',NULL),
	 (81103,N'El Cuitab�n',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2430,N'Rural',NULL),
	 (81103,N'Plan del R�o',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2431,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81103,N'Las Juntitas de Valdez',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2432,N'Rural',NULL),
	 (81103,N'Ladrilleras de Ocoro',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2581,N'Rural',NULL),
	 (81104,N'Canal 21',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,28,N'Rural',NULL),
	 (81104,N'La Virgencita (Lindavista)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,43,N'Rural',NULL),
	 (81104,N'Choipa',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,45,N'Rural',NULL),
	 (81104,N'Camag�ey (Campo B�rquez)',N'Granja',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,23,11,46,N'Rural',NULL),
	 (81104,N'Santa Teresa de los Olivos (Los Pinitos)',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,47,N'Rural',NULL),
	 (81104,N'El Amolito',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,48,N'Rural',NULL),
	 (81104,N'Ranchito de Inzunza',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2433,N'Rural',NULL),
	 (81104,N'La Escalera',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2434,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81106,N'Callejones de Guasavito',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2435,N'Urbano',NULL),
	 (81106,N'San Pedro Paredes',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2436,N'Rural',NULL),
	 (81106,N'Las Crucecitas',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2437,N'Rural',NULL),
	 (81107,N'Campo Esperanza',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,32,N'Rural',NULL),
	 (81107,N'La Mojonera',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,49,N'Rural',NULL),
	 (81107,N'Campo Dimas',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,50,N'Rural',NULL),
	 (81107,N'Campo Inzunza',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,51,N'Rural',NULL),
	 (81107,N'Chino de los L�pez',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,52,N'Rural',NULL),
	 (81107,N'Campo Taj�n',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,53,N'Rural',NULL),
	 (81107,N'San Pedro Guasave (El Ranchito)',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2438,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81107,N'Chorohui',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2439,N'Rural',NULL),
	 (81107,N'San Gabriel',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2440,N'Rural',NULL),
	 (81107,N'La Cuestona (La Cuesta)',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2441,N'Rural',NULL),
	 (81107,N'Las Pitahayitas',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2442,N'Rural',NULL),
	 (81107,N'La Guamuchilera',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2443,N'Rural',NULL),
	 (81107,N'Jes�s Mar�a',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2444,N'Rural',NULL),
	 (81107,N'Cuesta de Arriba',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2495,N'Rural',NULL),
	 (81108,N'El Toro',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,54,N'Rural',NULL),
	 (81108,N'El Chinal',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,55,N'Rural',NULL),
	 (81108,N'El Colorado',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,56,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81108,N'Sabanillas del Burri�n',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,57,N'Rural',NULL),
	 (81108,N'Las Ladrilleras del Burri�n',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,58,N'Rural',NULL),
	 (81108,N'Las Joyitas',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,59,N'Rural',NULL),
	 (81110,N'Juan Jos� R�os',N'Colonia',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,9,20,1,N'Urbano',NULL),
	 (81110,N'El Estero',N'Colonia',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,9,20,2,N'Urbano',NULL),
	 (81113,N'Campo el Porvenir',N'Rancho',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,48,20,3,N'Rural',NULL),
	 (81113,N'H�roes Mexicanos',N'Rancher�a',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,29,20,4,N'Rural',NULL),
	 (81113,N'Treinta y Ochito',N'Ejido',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,15,20,5,N'Rural',NULL),
	 (81113,N'Babujaqui',N'Rancher�a',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,29,20,6,N'Rural',NULL),
	 (81113,N'Guayparime',N'Rancher�a',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,29,20,7,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81113,N'Campo Naranjos',N'Rancho',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,48,20,8,N'Rural',NULL),
	 (81113,N'Campo la Doscientos',N'Rancho',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,48,20,9,N'Rural',NULL),
	 (81113,N'Campo Treinta y Ocho',N'Rancher�a',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,29,20,10,N'Rural',NULL),
	 (81114,N'Cerro Batequis',N'Rancho',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,48,20,11,N'Rural',NULL),
	 (81114,N'La Diez',N'Rancho',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,48,20,12,N'Rural',NULL),
	 (81114,N'El Amapal',N'Rancher�a',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,29,20,13,N'Rural',NULL),
	 (81115,N'Tres Garant�as',N'Pueblo',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,28,20,14,N'Rural',NULL),
	 (81115,N'Agua de las Arenas',N'Rancher�a',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,29,20,15,N'Rural',NULL),
	 (81115,N'Santa Cecilia',N'Rancher�a',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,29,20,25,N'Rural',NULL),
	 (81116,N'Nuevo Luis Echeverr�a',N'Pueblo',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,28,20,16,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81118,N'Ampliaci�n el Cerro (La Chirimilla)',N'Rancho',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,48,20,17,N'Rural',NULL),
	 (81118,N'Carrizo Grande',N'Rancher�a',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,29,20,18,N'Rural',NULL),
	 (81118,N'Bachoco N�mero Dos (Macoch�n)',N'Ejido',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,15,20,19,N'Rural',NULL),
	 (81118,N'L�zaro C�rdenas (Muellecito)',N'Rancher�a',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,29,20,20,N'Rural',NULL),
	 (81118,N'Cerro Cabez�n (El Chorrito)',N'Ejido',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,15,20,21,N'Rural',NULL),
	 (81118,N'El Cerro Cabez�n',N'Colonia',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,9,20,22,N'Urbano',NULL),
	 (81119,N'San Carlos',N'Rancho',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,48,20,23,N'Rural',NULL),
	 (81119,N'Bachoco',N'Colonia',N'Juan Jos� R�os',N'Sinaloa',N'',81111,25,81111,NULL,9,20,24,N'Urbano',NULL),
	 (81120,N'24 de Febrero',N'Colonia',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,9,11,66,N'Rural',NULL),
	 (81120,N'Sacramento (Campo la Once)',N'Rancho',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,48,11,67,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81120,N'Juan Jos� R�os',N'Pueblo',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,28,11,627,N'Urbano',NULL),
	 (81120,N'La Once',N'Rancho',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,48,11,2583,N'Rural',NULL),
	 (81121,N'Campo el Tajito',N'Rancho',N'Guasave',N'Sinaloa',N'',81125,25,81125,NULL,48,11,68,N'Rural',NULL),
	 (81121,N'Adolfo Ruiz Cortinez',N'Pueblo',N'Guasave',N'Sinaloa',N'',81125,25,81125,NULL,28,11,634,N'Urbano',NULL),
	 (81121,N'Campestre Valle',N'Colonia',N'Guasave',N'Sinaloa',N'',81125,25,81125,NULL,9,11,1718,N'Urbano',NULL),
	 (81121,N'Rancho California',N'Colonia',N'Guasave',N'Sinaloa',N'',81125,25,81125,NULL,9,11,1719,N'Urbano',NULL),
	 (81121,N'El Campesino',N'Ejido',N'Guasave',N'Sinaloa',N'',81125,25,81125,NULL,15,11,2446,N'Rural',NULL),
	 (81121,N'Adolfo Ruiz Cortinez Dos',N'Colonia',N'Guasave',N'Sinaloa',N'',81125,25,81125,NULL,9,11,3186,N'Urbano',NULL),
	 (81122,N'Gabriel Leyva Solano (Benito Ju�rez)',N'Colonia',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,9,11,635,N'Urbano',NULL),
	 (81122,N'Figueroa',N'Ejido',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,15,11,2576,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81122,N'Ampliaci�n Gabriel Leyva Solano (Benito Ju�rez)',N'Colonia',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,9,11,3033,N'Urbano',NULL),
	 (81122,N'San Francisco',N'Colonia',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,9,11,3035,N'Urbano',NULL),
	 (81123,N'Jes�s Mar�a',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81125,25,81125,NULL,29,11,72,N'Rural',NULL),
	 (81123,N'Miguel Alem�n',N'Ejido',N'Guasave',N'Sinaloa',N'',81125,25,81125,NULL,15,11,629,N'Rural',NULL),
	 (81123,N'El Huitussi y Anexos (El Huitussito)',N'Ejido',N'Guasave',N'Sinaloa',N'',81125,25,81125,NULL,15,11,2447,N'Rural',NULL),
	 (81124,N'Corerepe',N'Pueblo',N'Guasave',N'Sinaloa',N'',81125,25,81125,NULL,28,11,637,N'Urbano',NULL),
	 (81124,N'Hidalgo',N'Colonia',N'Guasave',N'Sinaloa',N'',81125,25,81125,NULL,9,11,3188,N'Urbano',NULL),
	 (81124,N'El Gallo',N'Colonia',N'Guasave',N'Sinaloa',N'',81125,25,81125,NULL,9,11,3189,N'Urbano',NULL),
	 (81127,N'El Retiro',N'Colonia',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,9,11,171,N'Urbano',NULL),
	 (81127,N'Lic. Benito Ju�rez',N'Colonia',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,9,11,633,N'Urbano',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81127,N'El Tajito',N'Colonia',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,9,11,1733,N'Urbano',NULL),
	 (81127,N'Gallo de los Limones',N'Colonia',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,9,11,3034,N'Urbano',NULL),
	 (81128,N'California',N'Rancho',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,48,11,73,N'Rural',NULL),
	 (81128,N'Las Parritas',N'Ejido',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,15,11,2577,N'Rural',NULL),
	 (81128,N'Campo Figueroa',N'Rancho',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,48,11,2578,N'Rural',NULL),
	 (81130,N'Francisco Ley',N'Colonia',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,9,11,74,N'Urbano',NULL),
	 (81130,N'Le�n Fonseca',N'Pueblo',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,28,11,640,N'Urbano',NULL),
	 (81131,N'La Trinidad',N'Ejido',N'Guasave',N'Sinaloa',N'',81982,25,81982,NULL,15,11,642,N'Urbano',NULL),
	 (81132,N'Las Moritas',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,75,N'Rural',NULL),
	 (81132,N'La Aceituna',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,76,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81132,N'Portugu�s de G�lvez',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,643,N'Rural',NULL),
	 (81132,N'Las Juntas de Chamicari',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2584,N'Rural',NULL),
	 (81133,N'Palos Verdes',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,77,N'Rural',NULL),
	 (81133,N'Los Hornos N�mero Uno (Salsipuedes)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,78,N'Rural',NULL),
	 (81133,N'Las Moras',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,644,N'Rural',NULL),
	 (81133,N'Las Quemazones',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,645,N'Rural',NULL),
	 (81133,N'Los Hornos',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,646,N'Rural',NULL),
	 (81134,N'El Toruno',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81982,25,81982,NULL,29,11,79,N'Rural',NULL),
	 (81135,N'El Tanque',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,29,11,80,N'Rural',NULL),
	 (81135,N'La Palmita',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,29,11,81,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81135,N'El Zopilote',N'Ejido',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,15,11,2448,N'Rural',NULL),
	 (81136,N'Los Pinitos',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81982,25,81982,NULL,29,11,82,N'Rural',NULL),
	 (81136,N'La Familia',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81982,25,81982,NULL,29,11,83,N'Rural',NULL),
	 (81136,N'La Noria',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81982,25,81982,NULL,29,11,641,N'Rural',NULL),
	 (81136,N'Abelardo L. Rodr�guez',N'Ejido',N'Guasave',N'Sinaloa',N'',81982,25,81982,NULL,15,11,2669,N'Rural',NULL),
	 (81140,N'Bamoa',N'Pueblo',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,28,11,648,N'Urbano',NULL),
	 (81140,N'6 de Mayo',N'Colonia',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,9,11,1734,N'Urbano',NULL),
	 (81140,N'Ranchito de Zavala',N'Ejido',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,15,11,2585,N'Rural',NULL),
	 (81140,N'Horacio Grac�a Arrayales',N'Colonia',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,9,11,3187,N'Urbano',NULL),
	 (81141,N'Crucero de Bamoa',N'Rancho',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,48,11,84,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81141,N'Estaci�n Bamoa',N'Pueblo',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,28,11,649,N'Urbano',NULL),
	 (81142,N'El Sabino',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,29,11,650,N'Rural',NULL),
	 (81142,N'Carboneras',N'Ejido',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,15,11,2449,N'Rural',NULL),
	 (81143,N'La Cuerda',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,29,11,85,N'Rural',NULL),
	 (81143,N'Las Pilas',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,29,11,86,N'Rural',NULL),
	 (81143,N'Chino de los L�pez',N'Ejido',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,15,11,618,N'Rural',NULL),
	 (81143,N'Orba (Infiernito)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,29,11,651,N'Rural',NULL),
	 (81143,N'Cruz Blanca',N'Ejido',N'Guasave',N'Sinaloa',N'',81145,25,81145,NULL,15,11,2450,N'Rural',NULL),
	 (81144,N'N�o',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,652,N'Urbano',NULL),
	 (81144,N'Pueblo Viejo',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,654,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81147,N'Tahuilana (El Chorizo)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,29,11,87,N'Rural',NULL),
	 (81147,N'Norotillos',N'Ejido',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,15,11,653,N'Rural',NULL),
	 (81148,N'Campo California',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,88,N'Rural',NULL),
	 (81148,N'El Tecomate',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,89,N'Rural',NULL),
	 (81148,N'La Curva',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,90,N'Rural',NULL),
	 (81148,N'San Jos� de Palos Blancos (Palos Blancos)',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,91,N'Rural',NULL),
	 (81148,N'Campo Sinaloa',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,92,N'Rural',NULL),
	 (81148,N'N�o Dos',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,93,N'Rural',NULL),
	 (81148,N'Charco Largo',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,94,N'Rural',NULL),
	 (81148,N'Palos Blancos',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,657,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81148,N'Terahuito',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2451,N'Rural',NULL),
	 (81148,N'El Platanito',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2452,N'Rural',NULL),
	 (81149,N'El Burri�n',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,658,N'Urbano',NULL),
	 (81160,N'Bonanza',N'Colonia',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,9,11,95,N'Urbano',NULL),
	 (81160,N'San Rafael',N'Colonia',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,9,11,96,N'Urbano',NULL),
	 (81160,N'Cubilete 1',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,659,N'Urbano',NULL),
	 (81160,N'Sodi [Productora Agr�cola]',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2207,N'Rural',NULL),
	 (81160,N'Campo Crucero [Campo D�az]',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2216,N'Rural',NULL),
	 (81160,N'El Marcol',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,2453,N'Rural',NULL),
	 (81161,N'Miguel Hidalgo',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,97,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81161,N'Dorado N�mero Tres (Doradito)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,98,N'Rural',NULL),
	 (81161,N'Campo Treinta y Uno',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,99,N'Rural',NULL),
	 (81161,N'Buenavista',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,660,N'Rural',NULL),
	 (81162,N'Campo Yory',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,100,N'Rural',NULL),
	 (81162,N'Palos Dulces',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,101,N'Rural',NULL),
	 (81162,N'Tapachula (Los Chapos)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,102,N'Rural',NULL),
	 (81162,N'La Rosita',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,103,N'Rural',NULL),
	 (81162,N'Tapachula',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,105,N'Rural',NULL),
	 (81162,N'Torihuia',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,106,N'Rural',NULL),
	 (81162,N'Campo el Jito',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,107,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81162,N'Las Tortugas',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,108,N'Rural',NULL),
	 (81162,N'Los A�iles',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,109,N'Rural',NULL),
	 (81162,N'Penal Federal Guasave',N'Zona federal',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,34,11,174,N'Rural',NULL),
	 (81162,N'El Porvenir',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,661,N'Rural',NULL),
	 (81162,N'La Chuparrosa',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2454,N'Rural',NULL),
	 (81162,N'San Antonio',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2455,N'Rural',NULL),
	 (81162,N'Campo Filipinas',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,2586,N'Rural',NULL),
	 (81163,N'El Sacrificio',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2456,N'Rural',NULL),
	 (81163,N'El Tortugo',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2457,N'Rural',NULL),
	 (81163,N'Maximiliano R. L�pez (El Pochote)',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2458,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81163,N'Cubilete N�mero Dos',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2496,N'Rural',NULL),
	 (81164,N'Las Ca�adas N�mero Dos',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,110,N'Rural',NULL),
	 (81164,N'El Mezquit�n',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,111,N'Rural',NULL),
	 (81164,N'San Carlos',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,112,N'Rural',NULL),
	 (81164,N'San Fernando',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,113,N'Rural',NULL),
	 (81164,N'El Dorado N�mero Dos',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,114,N'Rural',NULL),
	 (81164,N'Chorohui',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,115,N'Rural',NULL),
	 (81164,N'Roberto Barrios',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2459,N'Rural',NULL),
	 (81165,N'Villa San Jos�',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,172,N'Rural',NULL),
	 (81165,N'Flor de Mayo',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2497,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81166,N'Mend�vil',N'Rancho',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,48,11,116,N'Rural',NULL),
	 (81166,N'General Emiliano Zapata',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,29,11,117,N'Rural',NULL),
	 (81166,N'Callej�n de Tamazula',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,29,11,118,N'Rural',NULL),
	 (81166,N'Los Hornos N�mero Dos',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,29,11,119,N'Rural',NULL),
	 (81166,N'El Coloradito',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,29,11,2668,N'Rural',NULL),
	 (81167,N'22-15 [Campo Pesquero]',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,29,11,120,N'Rural',NULL),
	 (81167,N'El Huitussi',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,29,11,636,N'Rural',NULL),
	 (81167,N'El Caracol',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81126,25,81126,NULL,29,11,2460,N'Rural',NULL),
	 (81170,N'El Amole',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,662,N'Rural',NULL),
	 (81170,N'La Bebelama',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,663,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81170,N'Callejones de Tamazula',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,664,N'Rural',NULL),
	 (81170,N'Tamazula',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,665,N'Rural',NULL),
	 (81170,N'Buen Retiro (El Retiro)',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2461,N'Rural',NULL),
	 (81170,N'Cubiri del Amole',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2498,N'Rural',NULL),
	 (81173,N'El Baj�o',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,121,N'Rural',NULL),
	 (81173,N'La Isleta',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,122,N'Rural',NULL),
	 (81173,N'Las Pilas',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,123,N'Rural',NULL),
	 (81174,N'Valle de Huyaqui (Los Solares)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,124,N'Rural',NULL),
	 (81174,N'Las Colonias (Colonia �ngel Flores)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,125,N'Rural',NULL),
	 (81175,N'Tierra y Libertad',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,126,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81175,N'Las Ca�adas Viejas',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,127,N'Rural',NULL),
	 (81175,N'El Guayabo',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,128,N'Rural',NULL),
	 (81175,N'Santa Elena',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,129,N'Rural',NULL),
	 (81175,N'El Crucero',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,130,N'Rural',NULL),
	 (81175,N'El Progreso',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,632,N'Rural',NULL),
	 (81175,N'Las Ca�adas N�mero Uno',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2462,N'Rural',NULL),
	 (81176,N'Las Flores',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,2206,N'Rural',NULL),
	 (81176,N'Las Culebras',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2246,N'Rural',NULL),
	 (81177,N'Alamito Caimanero',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,131,N'Rural',NULL),
	 (81177,N'La Pitahaya',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,132,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81177,N'Rosales',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,133,N'Rural',NULL),
	 (81177,N'Carricitos',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,134,N'Rural',NULL),
	 (81177,N'Las Higueras (Las Flores)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2463,N'Rural',NULL),
	 (81178,N'Campo Berrelleza',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,135,N'Rural',NULL),
	 (81178,N'El Alto',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,136,N'Rural',NULL),
	 (81178,N'R�o Viejo',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,137,N'Rural',NULL),
	 (81178,N'El Choyal',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,138,N'Rural',NULL),
	 (81178,N'El Realito (El Realito del Amole)',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,139,N'Rural',NULL),
	 (81178,N'El Papachal',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,140,N'Rural',NULL),
	 (81178,N'El Carrizal',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,141,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81178,N'Tres de Mayo (Nombre Feo)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,142,N'Rural',NULL),
	 (81178,N'El Bacatete (San Pascual)',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,143,N'Rural',NULL),
	 (81178,N'Las Playas (La Palma)',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,626,N'Rural',NULL),
	 (81178,N'Casa Blanca',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,666,N'Rural',NULL),
	 (81178,N'Palos Verdes',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,667,N'Rural',NULL),
	 (81178,N'San Pascual',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,2708,N'Rural',NULL),
	 (81180,N'Charco Largo',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,144,N'Rural',NULL),
	 (81180,N'Paul',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,145,N'Rural',NULL),
	 (81180,N'Los Tesitos',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,146,N'Rural',NULL),
	 (81180,N'Las Cuchillas',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,147,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81180,N'La Pichihuila',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,669,N'Rural',NULL),
	 (81180,N'San Rafael (General Miguel Valle D�valos)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,670,N'Rural',NULL),
	 (81180,N'El Serranito',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,2204,N'Rural',NULL),
	 (81180,N'Palmarito de los Angulo',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,2294,N'Rural',NULL),
	 (81180,N'El Pochote (Potrerillos)',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,2711,N'Rural',NULL),
	 (81181,N'Francisco R Serrano',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,671,N'Rural',NULL),
	 (81182,N'Norot�os Cuba',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,29,11,148,N'Rural',NULL),
	 (81182,N'Norot�o (El Gato)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,29,11,149,N'Rural',NULL),
	 (81182,N'San Mart�n',N'Rancho',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,48,11,150,N'Rural',NULL),
	 (81182,N'Las Am�ricas',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,29,11,672,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81183,N'San Francisco de Capomos (El Charro)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,29,11,151,N'Rural',NULL),
	 (81183,N'El Varali',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,29,11,152,N'Rural',NULL),
	 (81183,N'Choipa Dos',N'Pueblo',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,28,11,2205,N'Rural',NULL),
	 (81183,N'Herculano de la Rocha',N'Ejido',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,15,11,2464,N'Rural',NULL),
	 (81183,N'Choipa',N'Ejido',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,15,11,2465,N'Rural',NULL),
	 (81184,N'San Marcial',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,29,11,153,N'Rural',NULL),
	 (81184,N'El Reparo',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,29,11,154,N'Rural',NULL),
	 (81184,N'Estaci�n Capomas',N'Pueblo',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,28,11,155,N'Rural',NULL),
	 (81184,N'Ricardo Flores Mag�n (La Aceituna)',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,29,11,156,N'Rural',NULL),
	 (81184,N'San Francisco de Capomos Viejos',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,29,11,168,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81184,N'San Francisquito de Capomos',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81146,25,81146,NULL,29,11,668,N'Rural',NULL),
	 (81186,N'15 de Octubre',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,157,N'Rural',NULL),
	 (81186,N'La Curva',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,158,N'Rural',NULL),
	 (81186,N'Las Brisas (Emiliano Zapata)',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2466,N'Rural',NULL),
	 (81189,N'Campo Am�rica',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,159,N'Rural',NULL),
	 (81189,N'Campo Santa Isabel',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,160,N'Rural',NULL),
	 (81189,N'Las Cruces',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,161,N'Rural',NULL),
	 (81189,N'Cuatro Caminos',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,162,N'Rural',NULL),
	 (81189,N'El Sartenejal',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,163,N'Rural',NULL),
	 (81189,N'El Batall�n',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,164,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81189,N'Las Compuertas',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,165,N'Rural',NULL),
	 (81189,N'El Pochote',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,166,N'Rural',NULL),
	 (81189,N'La Esmeralda',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,173,N'Rural',NULL),
	 (81189,N'El Pitahayal',N'Rancher�a',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,29,11,673,N'Rural',NULL),
	 (81189,N'Vicente Guerrero',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2467,N'Rural',NULL),
	 (81189,N'Javier Rojo G�mez',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,2499,N'Rural',NULL),
	 (81190,N'La Brecha',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,674,N'Rural',NULL),
	 (81190,N'San Jos� de la Brecha',N'Ejido',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,15,11,675,N'Rural',NULL),
	 (81197,N'Las Glorias',N'Rancho',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,48,11,167,N'Rural',NULL),
	 (81197,N'Boca del R�o',N'Pueblo',N'Guasave',N'Sinaloa',N'',81001,25,81001,NULL,28,11,2203,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81200,N'Los Mochis Centro',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,676,N'Urbano',1),
	 (81210,N'Miguel Hidalgo',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,680,N'Urbano',1),
	 (81215,N'ISSSTESIN',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,681,N'Urbano',1),
	 (81215,N'Las Fuentes 2000',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2401,N'Urbano',1),
	 (81216,N'Benito Ju�rez',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,682,N'Urbano',1),
	 (81216,N'Reyes Guerrero',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1571,N'Urbano',1),
	 (81216,N'Bugambilias',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1998,N'Urbano',1),
	 (81216,N'Gaviotas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1999,N'Urbano',1),
	 (81217,N'Narciso Mendoza (Las Malvinas)',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,683,N'Urbano',1),
	 (81218,N'Conrado Espinoza',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,684,N'Urbano',1);
INSERT INTO Sinaloa(d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81220,N'Sector F�tima',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,685,N'Urbano',1),
	 (81220,N'Jiquilpan',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,686,N'Urbano',1),
	 (81220,N'Jordan',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1565,N'Urbano',1),
	 (81223,N'Villa Bonita',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,61,N'Urbano',1),
	 (81223,N'Las Fuentes',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,688,N'Urbano',1),
	 (81223,N'Deportivo y Rinc�n',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1570,N'Urbano',1),
	 (81224,N'Juan Cota',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,689,N'Urbano',1),
	 (81225,N'�vila Corona',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,690,N'Urbano',1),
	 (81225,N'Sanchez Ruiz',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1569,N'Urbano',1),
	 (81226,N'Jardines de F�tima',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,691,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81227,N'Fovissste',N'Unidad habitacional',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,31,1,692,N'Urbano',1),
	 (81228,N'Privada Palladio',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,3,N'Urbano',1),
	 (81228,N'Ampliaci�n Vi�edos',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,24,N'Urbano',1),
	 (81228,N'Macapule Infonavit',N'Unidad habitacional',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,31,1,694,N'Urbano',1),
	 (81228,N'Residencial Campestre',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2005,N'Urbano',1),
	 (81228,N'Bosques Del Country',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2145,N'Urbano',1),
	 (81228,N'Vi�edos Residencial',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2310,N'Urbano',1),
	 (81228,N'Privada Toscana',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2936,N'Urbano',1),
	 (81228,N'Daniel Biul Ruelas',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,2939,N'Urbano',1),
	 (81229,N'Palos Verdes Infonavit',N'Unidad habitacional',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,31,1,695,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81229,N'Jiquilpan',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1568,N'Urbano',1),
	 (81229,N'Tepeka',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1575,N'Urbano',1),
	 (81229,N'Residencial Diamante',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1996,N'Urbano',1),
	 (81229,N'Fuentes Del Bosque',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2004,N'Urbano',1),
	 (81230,N'Jard�n',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,696,N'Urbano',1),
	 (81230,N'Libertad',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,697,N'Urbano',1),
	 (81230,N'Ruben Jaramillo',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,698,N'Urbano',1),
	 (81233,N'M�xico',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,699,N'Urbano',1),
	 (81233,N'Flor de las Arboledas',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1499,N'Urbano',1),
	 (81233,N'Luis Donaldo Colosio',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1564,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81233,N'Providencia',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1926,N'Urbano',1),
	 (81233,N'Nuevo Horizonte',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2143,N'Urbano',1),
	 (81233,N'Valle Ca�averal',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2144,N'Urbano',1),
	 (81233,N'Los Sabinos',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2393,N'Urbano',1),
	 (81233,N'FOVISSSTE 3',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2399,N'Urbano',1),
	 (81233,N'Residencial Palmira',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2517,N'Urbano',1),
	 (81234,N'El Chamizal',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,700,N'Urbano',1),
	 (81234,N'Del Real',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,701,N'Urbano',1),
	 (81234,N'75 (Heriberto Valdez Romero)',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1500,N'Urbano',1),
	 (81234,N'Santa Fe',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1924,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81234,N'Valle Bonito',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1925,N'Urbano',1),
	 (81234,N'Carolina Residencial',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2864,N'Urbano',1),
	 (81234,N'Bosques del Pedregal',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2865,N'Urbano',1),
	 (81235,N'San Francisco',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,702,N'Urbano',1),
	 (81236,N'Alfonso G Calder�n',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,703,N'Urbano',1),
	 (81236,N'10 de Mayo',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1510,N'Urbano',1),
	 (81237,N'Estrella',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,705,N'Urbano',1),
	 (81238,N'Adolfo Lopez Mateos',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,706,N'Urbano',1),
	 (81238,N'28 de Junio',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,707,N'Urbano',1),
	 (81240,N'Scally',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,710,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81240,N'Jordan Jiquilpan',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1502,N'Urbano',1),
	 (81240,N'Valent�n Guti�rrez',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1514,N'Urbano',1),
	 (81240,N'Ibarra',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1517,N'Urbano',1),
	 (81240,N'Julia Viuda de R�os',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1518,N'Urbano',1),
	 (81240,N'Popular Blanca Gastelum',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1519,N'Urbano',1),
	 (81240,N'Zaky Muez',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1520,N'Urbano',1),
	 (81240,N'Mario Avilez',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1521,N'Urbano',1),
	 (81240,N'Alfredo Salazar',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1522,N'Urbano',1),
	 (81240,N'Alma Guadalupe Estrada',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1523,N'Urbano',1),
	 (81240,N'Dolores Castro',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1524,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81240,N'Mayra H Pamplona',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1525,N'Urbano',1),
	 (81240,N'Germ�n Arroyo',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1526,N'Urbano',1),
	 (81240,N'Las Torres',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2394,N'Urbano',1),
	 (81240,N'Ernesto Hays Borbo',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2403,N'Urbano',1),
	 (81240,N'Toledo Ceballos',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2866,N'Urbano',1),
	 (81245,N'Jardines Del Valle',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,712,N'Urbano',1),
	 (81245,N'Jardines Del Sol',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1504,N'Urbano',1),
	 (81245,N'Jordan Madero',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1515,N'Urbano',1),
	 (81245,N'Gastelum',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1516,N'Urbano',1),
	 (81245,N'Ofelia Duarte',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1527,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81245,N'Deportivo Country Club',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1535,N'Urbano',1),
	 (81245,N'Grijalva',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2397,N'Urbano',1),
	 (81247,N'Bachomo Infonavit',N'Unidad habitacional',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,31,1,714,N'Urbano',1),
	 (81247,N'Los Pinos',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,717,N'Urbano',1),
	 (81247,N'Islas Residenciales',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1528,N'Urbano',1),
	 (81247,N'Los Sauces',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1928,N'Urbano',1),
	 (81248,N'�lamo',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1,N'Urbano',1),
	 (81248,N'Jos� �ngel Ferrusquilla',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,25,N'Urbano',1),
	 (81248,N'Diana Laura Riojas',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,62,N'Urbano',1),
	 (81248,N'Cuauht�moc',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,718,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81248,N'Jardines del Country',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,719,N'Urbano',1),
	 (81248,N'�lamos',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,720,N'Urbano',1),
	 (81248,N'Jardines del Bosque',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1501,N'Urbano',1),
	 (81248,N'Los Olivos',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1529,N'Urbano',1),
	 (81248,N'Primavera',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1530,N'Urbano',1),
	 (81248,N'Monico Soto',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1531,N'Urbano',1),
	 (81248,N'Del Carmen',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2404,N'Urbano',1),
	 (81248,N'Monferrat',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2405,N'Urbano',1),
	 (81248,N'Residencial del Country',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2862,N'Urbano',1),
	 (81248,N'Real del Country',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2863,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81248,N'�lamos I',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,2925,N'Urbano',1),
	 (81248,N'�lamos II',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,2926,N'Urbano',1),
	 (81248,N'U.A.S. �lamos',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2928,N'Urbano',1),
	 (81249,N'Lastras Altamirano',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,721,N'Urbano',1),
	 (81249,N'Las Palmas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,722,N'Urbano',1),
	 (81249,N'Residencial Del Valle',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,723,N'Urbano',1),
	 (81249,N'Teresita',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,724,N'Urbano',1),
	 (81249,N'Progresivo San Rafael',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1509,N'Urbano',1),
	 (81249,N'Menonitas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1567,N'Urbano',1),
	 (81249,N'INFONAVIT Mochicahui II',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1923,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81249,N'Jardines de Zacatecas',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,2003,N'Urbano',1),
	 (81249,N'Villas del Sol',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,3008,N'Urbano',1),
	 (81250,N'La Cuchilla',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,725,N'Urbano',1),
	 (81254,N'Universidad de los Mochis',N'Equipamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,17,1,27,N'Urbano',1),
	 (81254,N'Centro Plaza Mochis',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1573,N'Urbano',1),
	 (81254,N'Loma Dorada',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1574,N'Urbano',1),
	 (81254,N'La Memoria',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2002,N'Urbano',1),
	 (81254,N'Mallorca',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2867,N'Urbano',1),
	 (81254,N'Versalles Residencial',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2877,N'Urbano',1),
	 (81254,N'Parque Industrial Ecol�gico',N'Zona industrial',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,37,1,2930,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81254,N'Monte Carlo',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,3089,N'Urbano',1),
	 (81255,N'Zona Industrial',N'Zona industrial',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,37,1,726,N'Urbano',1),
	 (81256,N'Ingeniero Heriberto Valdez Romero',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,727,N'Urbano',1),
	 (81256,N'L�zaro C�rdenas',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,728,N'Urbano',1),
	 (81256,N'Central de Abastos',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1511,N'Urbano',1),
	 (81256,N'Bellavista',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1920,N'Urbano',1),
	 (81256,N'Villa Huites',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1922,N'Urbano',1),
	 (81256,N'FOVISSSTE Tabachines IV',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2398,N'Urbano',1),
	 (81256,N'Jiquilpan 2',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,2400,N'Urbano',1),
	 (81256,N'INFONAVIT Mochicahui',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2933,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81257,N'Tabachines',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,729,N'Urbano',1),
	 (81257,N'Roberto Perez Jacobo',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1507,N'Urbano',1),
	 (81257,N'Villa Owen',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2195,N'Urbano',1),
	 (81259,N'Del Parque',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,730,N'Urbano',1),
	 (81260,N'Hacienda Santa Clara',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,11,N'Urbano',1),
	 (81260,N'Alejandro Pe�a',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,731,N'Urbano',1),
	 (81260,N'Rosendo G Castro',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,732,N'Urbano',1),
	 (81260,N'Realito',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1556,N'Urbano',1),
	 (81260,N'La Esperanza',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1557,N'Urbano',1),
	 (81260,N'Las Ma�anitas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2515,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81260,N'Valle Verde',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2945,N'Urbano',1),
	 (81263,N'Real Aurora',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,12,N'Urbano',1),
	 (81263,N'Las Glorias',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2396,N'Urbano',1),
	 (81263,N'Santa Lourdes',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2420,N'Urbano',1),
	 (81263,N'Prados del Valle',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2519,N'Urbano',1),
	 (81263,N'Santa Rosa',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2521,N'Urbano',1),
	 (81263,N'Residencial Aurora',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2931,N'Urbano',1),
	 (81265,N'Ferrocarril',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,733,N'Urbano',1),
	 (81265,N'Residencial Ahome 2000',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2407,N'Urbano',1),
	 (81270,N'Quinta de Cortes',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,14,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81270,N'Villa Antigua Residencial',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,56,N'Urbano',1),
	 (81270,N'Las Haciendas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,57,N'Urbano',1),
	 (81270,N'Gabriel Leyva',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,734,N'Urbano',1),
	 (81270,N'Margarita',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,735,N'Urbano',1),
	 (81270,N'Jardines de Guadalupe',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1505,N'Urbano',1),
	 (81270,N'Villa de Cortes',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1542,N'Urbano',1),
	 (81270,N'Terranova',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1544,N'Urbano',1),
	 (81270,N'San Fernando',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1545,N'Urbano',1),
	 (81270,N'Conquistadores',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1546,N'Urbano',1),
	 (81270,N'Villas Monterrey',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1921,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81270,N'Los Naranjos',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2000,N'Urbano',1),
	 (81270,N'Residencial Platino',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2001,N'Urbano',1),
	 (81270,N'Campanario',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2137,N'Urbano',1),
	 (81270,N'Paseo de las Aves',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2147,N'Urbano',1),
	 (81270,N'Las Huertas II',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2408,N'Urbano',1),
	 (81270,N'Salvador Esquer Apodaca',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2520,N'Urbano',1),
	 (81270,N'Las Quintas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2858,N'Urbano',1),
	 (81270,N'Las Huertas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2927,N'Urbano',1),
	 (81271,N'Real del Valle',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2,N'Urbano',1),
	 (81271,N'Tulipanes',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,10,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81271,N'Villa Fontana',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,16,N'Urbano',1),
	 (81271,N'Villas de Andaluc�a',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,64,N'Urbano',1),
	 (81271,N'Valle Alto Residencial',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,65,N'Urbano',1),
	 (81271,N'12 de Octubre',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,736,N'Urbano',1),
	 (81271,N'Sierra Bonita',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1548,N'Urbano',1),
	 (81271,N'Santa Cecilia',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1549,N'Urbano',1),
	 (81271,N'Santa Teresa',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1577,N'Urbano',1),
	 (81271,N'�lamos Country',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2006,N'Urbano',1),
	 (81271,N'Residencial Paseo Alameda',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2007,N'Urbano',1),
	 (81271,N'Zafiro',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2134,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81271,N'Santa B�rbara',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2136,N'Urbano',1),
	 (81271,N'Paseo Alameda',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2304,N'Urbano',1),
	 (81271,N'Portal de Hierro',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2675,N'Urbano',1),
	 (81271,N'Las Villas Residencial',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2857,N'Urbano',1),
	 (81271,N'Villa de Cortez',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2944,N'Urbano',1),
	 (81271,N'Quinta Real',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,3030,N'Urbano',1),
	 (81277,N'Haciendas Country',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,4,N'Urbano',1),
	 (81277,N'Las Delicias',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,737,N'Urbano',1),
	 (81277,N'Hacienda del Arroyo',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1927,N'Urbano',1),
	 (81277,N'Palmera Residencial',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2255,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81277,N'Las Haciendas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2409,N'Urbano',1),
	 (81277,N'Hacienda Arroyo Pioneros',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2861,N'Urbano',1),
	 (81278,N'Valle de la Rosa',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,5,N'Urbano',1),
	 (81278,N'Alc�zar del Country',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,9,N'Urbano',1),
	 (81278,N'Haciendas del Valle',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,28,N'Urbano',1),
	 (81278,N'Buenavista',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,29,N'Urbano',1),
	 (81278,N'Francisco Villa',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,738,N'Urbano',1),
	 (81278,N'San Jos�',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1559,N'Urbano',1),
	 (81278,N'Santa Mar�a',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1560,N'Urbano',1),
	 (81278,N'Santa Alicia',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1561,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81278,N'Cedros',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1562,N'Urbano',1),
	 (81278,N'Colon',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1563,N'Urbano',1),
	 (81278,N'El Dorado',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2135,N'Urbano',1),
	 (81278,N'Los Virreyes',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2248,N'Urbano',1),
	 (81278,N'La Esmeralda',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2410,N'Urbano',1),
	 (81278,N'Santa Catalina',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2851,N'Urbano',1),
	 (81278,N'San Isidro',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2860,N'Urbano',1),
	 (81278,N'Valle del Rey',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2937,N'Urbano',1),
	 (81278,N'Urbi Villa del Rey',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,3056,N'Urbano',1),
	 (81280,N'An�huac',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,739,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81280,N'Bienestar',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,740,N'Urbano',1),
	 (81280,N'Insurgentes Obrera',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,741,N'Urbano',1),
	 (81280,N'Obrera',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1503,N'Urbano',1),
	 (81280,N'Independencia',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1532,N'Urbano',1),
	 (81280,N'Vivienda Popular',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1533,N'Urbano',1),
	 (81280,N'Sinaloa',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1534,N'Urbano',1),
	 (81285,N'Antonio Toledo Corro',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,742,N'Urbano',1),
	 (81285,N'Raul Romanillo',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1508,N'Urbano',1),
	 (81285,N'STASE Los �lamos',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1512,N'Urbano',1),
	 (81285,N'Francisco Labastida Ochoa',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1541,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81285,N'La Joya',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2247,N'Urbano',1),
	 (81285,N'La Florida',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2322,N'Urbano',1),
	 (81285,N'Residencial Mar de Cort�s',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2392,N'Urbano',1),
	 (81285,N'Real Isabeles',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2395,N'Urbano',1),
	 (81285,N'Universitario',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2412,N'Urbano',1),
	 (81285,N'Prados del Sur',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2518,N'Urbano',1),
	 (81289,N'La Herradura',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,743,N'Urbano',1),
	 (81289,N'Parque Sinaloa',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1536,N'Urbano',1),
	 (81289,N'Americana',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,2419,N'Urbano',1),
	 (81290,N'Bur�crata',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,744,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81290,N'Morelos',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,745,N'Urbano',1),
	 (81290,N'Lopez Portillo',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1538,N'Urbano',1),
	 (81290,N'Ampliaci�n Bur�crata',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,2971,N'Urbano',1),
	 (81293,N'Real de Santiago',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,17,N'Urbano',1),
	 (81293,N'Pradera de Villa',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1543,N'Urbano',1),
	 (81293,N'Las Misiones',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2256,N'Urbano',1),
	 (81293,N'Mediterr�neo',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2269,N'Urbano',1),
	 (81293,N'Las Nubes',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2413,N'Urbano',1),
	 (81293,N'Real de Villa',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2414,N'Urbano',1),
	 (81293,N'Villa Centenario',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2855,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81293,N'Jardines de Villa',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2934,N'Urbano',1),
	 (81293,N'Villa de Santiago',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2935,N'Urbano',1),
	 (81293,N'Montebello',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2938,N'Urbano',1),
	 (81293,N'Privanzas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2978,N'Urbano',1),
	 (81294,N'Andaluc�a',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,55,N'Urbano',1),
	 (81294,N'Prado Bonito',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1513,N'Urbano',1),
	 (81294,N'Los Laureles',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1539,N'Urbano',1),
	 (81294,N'Siglo XXI',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1550,N'Urbano',1),
	 (81294,N'Jardines de Morelos',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1551,N'Urbano',1),
	 (81294,N'Nueva Revoluci�n',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,1552,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81294,N'Almendras',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1553,N'Urbano',1),
	 (81294,N'Las Azucenas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1576,N'Urbano',1),
	 (81294,N'L�zaro C�rdenas Del Rio',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2139,N'Urbano',1),
	 (81294,N'Catarinas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2140,N'Urbano',1),
	 (81294,N'Nuevo Siglo',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2141,N'Urbano',1),
	 (81294,N'Las Flores',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2270,N'Urbano',1),
	 (81294,N'Prados III',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2416,N'Urbano',1),
	 (81294,N'Camelias',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2417,N'Urbano',1),
	 (81294,N'La Primavera',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2852,N'Urbano',1),
	 (81294,N'Las Cerezas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2853,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81294,N'Jardines de Primavera',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2929,N'Urbano',1),
	 (81294,N'Ni�os H�roes',N'Colonia',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,9,1,3014,N'Urbano',1),
	 (81294,N'La Cantera',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,3017,N'Urbano',1),
	 (81295,N'Los Girasoles',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1554,N'Urbano',1),
	 (81295,N'Las Ca�as',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,1555,N'Urbano',1),
	 (81295,N'Las Praderas',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2138,N'Urbano',1),
	 (81295,N'Morelos CTM',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2391,N'Urbano',1),
	 (81295,N'Morelos CTM 2',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2418,N'Urbano',1),
	 (81295,N'Santa Luz',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2854,N'Urbano',1),
	 (81295,N'Los �ngeles',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2856,N'Urbano',1);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81295,N'San Francisco',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,2932,N'Urbano',1),
	 (81295,N'Los Portales',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,3015,N'Urbano',1),
	 (81296,N'Los �ngeles',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Los Mochis',81201,25,81201,NULL,21,1,63,N'Urbano',1),
	 (81300,N'Huatabampito',N'Pueblo',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,28,1,747,N'Rural',NULL),
	 (81300,N'Mayocoba',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,29,1,749,N'Rural',NULL),
	 (81300,N'Campo Gast�lum',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,2554,N'Rural',NULL),
	 (81300,N'Tosalibampo',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,2559,N'Rural',NULL),
	 (81300,N'Tabelojeca',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,2560,N'Rural',NULL),
	 (81303,N'Agua Nueva',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,2300,N'Rural',NULL),
	 (81304,N'El Embudo',N'Colonia',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,9,1,23,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81304,N'El A�il',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,29,1,30,N'Rural',NULL),
	 (81304,N'Las Varitas',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,29,1,35,N'Rural',NULL),
	 (81304,N'Goros Viejo',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,29,1,42,N'Rural',NULL),
	 (81304,N'Camayeca',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,29,1,45,N'Rural',NULL),
	 (81304,N'El Chalate',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,29,1,51,N'Rural',NULL),
	 (81304,N'Zapotillo Uno (Zapotillo Viejo)',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,29,1,753,N'Rural',NULL),
	 (81304,N'Goros',N'Pueblo',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,28,1,782,N'Rural',NULL),
	 (81304,N'San Miguel Zapotitl�n',N'Pueblo',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,28,1,783,N'Urbano',NULL),
	 (81304,N'Mezcalera',N'Colonia',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,9,1,2056,N'Rural',NULL),
	 (81304,N'Juricahui',N'Colonia',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,9,1,2057,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81304,N'Paroscahui',N'Colonia',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,9,1,2058,N'Rural',NULL),
	 (81304,N'Nuevo San Miguel',N'Ejido',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,15,1,2423,N'Rural',NULL),
	 (81304,N'Bacaporobampo',N'Ejido',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,15,1,2555,N'Rural',NULL),
	 (81304,N'Choacahui',N'Ejido',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,15,1,2556,N'Rural',NULL),
	 (81304,N'La Bajada de San Miguel',N'Ejido',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,15,1,2557,N'Rural',NULL),
	 (81304,N'Las Calaveras',N'Ejido',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,15,1,2558,N'Rural',NULL),
	 (81304,N'Porvenir Vallejo',N'Ejido',N'Ahome',N'Sinaloa',N'',81301,25,81301,NULL,15,1,2666,N'Rural',NULL),
	 (81305,N'Flor Azul',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,785,N'Rural',NULL),
	 (81305,N'Gabriel Leyva Solano (Zapotillo Dos)',N'Pueblo',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,28,1,786,N'Rural',NULL),
	 (81306,N'La Fortuna',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,29,1,34,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81306,N'San Antonio',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,29,1,43,N'Rural',NULL),
	 (81306,N'La Fortuna (La Primavera)',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,29,1,47,N'Rural',NULL),
	 (81306,N'Goros N�mero Dos',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,752,N'Rural',NULL),
	 (81306,N'El Porvenir',N'Pueblo',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,28,1,756,N'Rural',NULL),
	 (81306,N'Bombas �guila Bagojo del R�o',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,2561,N'Rural',NULL),
	 (81306,N'Cachoana',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,2574,N'Rural',NULL),
	 (81307,N'La Esmeralda',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,29,1,33,N'Rural',NULL),
	 (81307,N'Macapul [Almacenes]',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,29,1,60,N'Rural',NULL),
	 (81307,N'�guila Azteca',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,754,N'Rural',NULL),
	 (81307,N'Macapul',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,2562,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81308,N'Bolsa de Tosalibampo Uno',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,784,N'Rural',NULL),
	 (81310,N'Bagojo Colectivo',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,750,N'Urbano',NULL),
	 (81310,N'Emiliano Zapata',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,751,N'Urbano',NULL),
	 (81310,N'Cuchilla de Cachoana',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,2657,N'Urbano',NULL),
	 (81311,N'Los Su�rez',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,748,N'Rural',NULL),
	 (81311,N'El Guayabo',N'Pueblo',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,28,1,757,N'Rural',NULL),
	 (81312,N'Cohuibampo',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,29,1,759,N'Rural',NULL),
	 (81315,N'Puesta de Sol',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,21,1,13,N'Urbano',9),
	 (81315,N'Individual Ahome',N'Colonia',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,9,1,1757,N'Urbano',9),
	 (81315,N'Hidr�ulica',N'Colonia',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,9,1,1760,N'Urbano',9);
INSERT INTO Sinaloa(d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81315,N'Ahome Centro',N'Colonia',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,9,1,1763,N'Urbano',9),
	 (81316,N'La Florida',N'Colonia',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,9,1,20,N'Urbano',9),
	 (81316,N'Las Bombitas',N'Colonia',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,9,1,1755,N'Urbano',9),
	 (81316,N'Inzunza',N'Colonia',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,9,1,1756,N'Urbano',9),
	 (81316,N'Melchor Ocampo',N'Colonia',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,9,1,1758,N'Urbano',9),
	 (81316,N'Benito Ju�rez',N'Colonia',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,9,1,1762,N'Urbano',9),
	 (81316,N'Guadalupe',N'Colonia',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,9,1,2040,N'Urbano',9),
	 (81316,N'San Antonio',N'Colonia',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,9,1,2896,N'Urbano',9),
	 (81317,N'Morelos',N'Colonia',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,9,1,1759,N'Urbano',9),
	 (81318,N'Ahome Independencia',N'Colonia',N'Ahome',N'Sinaloa',N'Ahome',81313,25,81313,NULL,9,1,2039,N'Urbano',9);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81320,N'El Cardal',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,39,N'Rural',NULL),
	 (81323,N'El Peluch�n',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81331,25,81331,NULL,29,1,46,N'Rural',NULL),
	 (81324,N'La Despensa',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,773,N'Rural',NULL),
	 (81325,N'El Molino',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,52,N'Rural',NULL),
	 (81325,N'El Refugio',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,778,N'Rural',NULL),
	 (81326,N'Huacaporito',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,776,N'Rural',NULL),
	 (81326,N'San Pablo',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,777,N'Rural',NULL),
	 (81330,N'La Capilla',N'Barrio',N'Ahome',N'Sinaloa',N'Higuera de Zaragoza',81331,25,81331,NULL,2,1,18,N'Urbano',10),
	 (81330,N'Gloria Ochoa de Labastida',N'Colonia',N'Ahome',N'Sinaloa',N'Higuera de Zaragoza',81331,25,81331,NULL,9,1,19,N'Urbano',10),
	 (81330,N'Guasavito',N'Colonia',N'Ahome',N'Sinaloa',N'Higuera de Zaragoza',81331,25,81331,NULL,9,1,26,N'Urbano',10);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81330,N'Higueras de Zaragoza Centro',N'Colonia',N'Ahome',N'Sinaloa',N'Higuera de Zaragoza',81331,25,81331,NULL,9,1,1764,N'Urbano',10),
	 (81330,N'San Lorenzo Nuevo',N'Colonia',N'Ahome',N'Sinaloa',N'Higuera de Zaragoza',81331,25,81331,NULL,9,1,1765,N'Urbano',10),
	 (81330,N'Hidr�ulica',N'Colonia',N'Ahome',N'Sinaloa',N'Higuera de Zaragoza',81331,25,81331,NULL,9,1,1767,N'Urbano',10),
	 (81330,N'Ejidal',N'Colonia',N'Ahome',N'Sinaloa',N'Higuera de Zaragoza',81331,25,81331,NULL,9,1,1768,N'Urbano',10),
	 (81330,N'Buenavista',N'Colonia',N'Ahome',N'Sinaloa',N'Higuera de Zaragoza',81331,25,81331,NULL,9,1,1769,N'Urbano',10),
	 (81330,N'Francisco Ceballos',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Higuera de Zaragoza',81331,25,81331,NULL,21,1,1770,N'Urbano',10),
	 (81333,N'El Tule',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81331,25,81331,NULL,29,1,58,N'Rural',NULL),
	 (81333,N'San Isidro Viejo',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81331,25,81331,NULL,29,1,59,N'Rural',NULL),
	 (81333,N'San Isidro',N'Pueblo',N'Ahome',N'Sinaloa',N'',81331,25,81331,NULL,28,1,2244,N'Rural',NULL),
	 (81334,N'Matacahui (El Campito)',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81331,25,81331,NULL,29,1,36,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81334,N'Campo Nuevo',N'Colonia',N'Ahome',N'Sinaloa',N'',81331,25,81331,NULL,9,1,1771,N'Rural',NULL),
	 (81334,N'Las Lajitas',N'Ejido',N'Ahome',N'Sinaloa',N'',81331,25,81331,NULL,15,1,2233,N'Rural',NULL),
	 (81334,N'Jitz�muri',N'Pueblo',N'Ahome',N'Sinaloa',N'',81331,25,81331,NULL,28,1,2563,N'Rural',NULL),
	 (81334,N'Bolsa de Tosalibampo Dos',N'Ejido',N'Ahome',N'Sinaloa',N'',81331,25,81331,NULL,15,1,2564,N'Rural',NULL),
	 (81335,N'El Ranchito',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,31,N'Rural',NULL),
	 (81335,N'San Lorenzo Viejo',N'Pueblo',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,28,1,774,N'Rural',NULL),
	 (81335,N'Los Algodones',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,779,N'Rural',NULL),
	 (81336,N'San Jos� de Ahome',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,781,N'Rural',NULL),
	 (81337,N'Ohuime',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,49,N'Rural',NULL),
	 (81337,N'El Aguajito',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,780,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81340,N'Poblado 5',N'Pueblo',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,28,1,769,N'Rural',NULL),
	 (81340,N'Chihuahuita',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,770,N'Rural',NULL),
	 (81340,N'Poblado N�mero Seis (Los Natoches)',N'Pueblo',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,28,1,771,N'Rural',NULL),
	 (81341,N'M�rtires de Sinaloa Dos',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,764,N'Rural',NULL),
	 (81341,N'Gral. Guillermo Chavez Talamantes',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,765,N'Rural',NULL),
	 (81341,N'Ni�os H�roes de Chapultepec [Estaci�n Francisco]',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,766,N'Rural',NULL),
	 (81343,N'Gustavo D�az Ordaz (El Carrizo)',N'Pueblo',N'Ahome',N'Sinaloa',N'',81342,25,81342,NULL,28,1,761,N'Urbano',NULL),
	 (81343,N'Antonio Toledo Corro',N'Colonia',N'Ahome',N'Sinaloa',N'',81342,25,81342,NULL,9,1,1735,N'Urbano',NULL),
	 (81343,N'Revoluci�n Mexicana',N'Ejido',N'Ahome',N'Sinaloa',N'',81342,25,81342,NULL,15,1,2424,N'Rural',NULL),
	 (81343,N'Venustiano Carranza y Reforma',N'Ejido',N'Ahome',N'Sinaloa',N'',81342,25,81342,NULL,15,1,2565,N'Rural',NULL);
INSERT INTO Sinaloa(d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81344,N'El Hecho',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81342,25,81342,NULL,29,1,54,N'Rural',NULL),
	 (81345,N'El Desenga�o',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81342,25,81342,NULL,29,1,37,N'Rural',NULL),
	 (81345,N'Emigdio Ruiz',N'Ejido',N'Ahome',N'Sinaloa',N'',81342,25,81342,NULL,15,1,2667,N'Rural',NULL),
	 (81346,N'Alfonso G. Calder�n (Poblado Siete)',N'Pueblo',N'Ahome',N'Sinaloa',N'',81342,25,81342,NULL,28,1,8,N'Urbano',NULL),
	 (81349,N'Bacorehuis',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,762,N'Rural',NULL),
	 (81349,N'Dolores Hidalgo',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,763,N'Rural',NULL),
	 (81349,N'Sinaloa de Leyva (El Venadillo)',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,767,N'Rural',NULL),
	 (81350,N'Las Grullas Margen Derecha',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,29,1,788,N'Rural',NULL),
	 (81350,N'El Colorado',N'Pueblo',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,28,1,789,N'Rural',NULL),
	 (81350,N'Las Grullas Margen Izquierda',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,792,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81350,N'El Alhuate',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,2232,N'Rural',NULL),
	 (81351,N'Las Quintas',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,29,1,48,N'Rural',NULL),
	 (81351,N'La Florida Vieja',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,29,1,790,N'Rural',NULL),
	 (81351,N'El Bule',N'Ejido',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,15,1,791,N'Rural',NULL),
	 (81353,N'Cobayme',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81313,25,81313,NULL,29,1,32,N'Rural',NULL),
	 (81360,N'Dieciocho de Marzo',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,794,N'Rural',NULL),
	 (81360,N'Felipe �ngeles',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,795,N'Rural',NULL),
	 (81360,N'Cerrillos (campo 35)',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,2301,N'Rural',NULL),
	 (81360,N'CERESO Nuevo',N'Zona federal',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,34,1,2656,N'Rural',NULL),
	 (81361,N'El Uno',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,50,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81361,N'Compuertas',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,793,N'Rural',NULL),
	 (81361,N'Cinco de Mayo',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,803,N'Rural',NULL),
	 (81361,N'Campo la Arrocera',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,804,N'Rural',NULL),
	 (81363,N'Los Mochis',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,796,N'Rural',NULL),
	 (81363,N'20 de Noviembre Viejo',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,800,N'Rural',NULL),
	 (81363,N'20 de Noviembre Nuevo',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,2946,N'Rural',NULL),
	 (81364,N'Ricardo Flores Mag�n',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,799,N'Rural',NULL),
	 (81367,N'Louisiana',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,797,N'Rural',NULL),
	 (81367,N'Plan de San Luis',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,802,N'Rural',NULL),
	 (81367,N'Campo Louisiana',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,2658,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81367,N'Santa B�rbara (Cabaihunaca)',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,21,1,3055,N'Rural',NULL),
	 (81369,N'Los Mochis (Los Mochis)',N'Aeropuerto',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,1,1,805,N'Rural',NULL),
	 (81370,N'Atardeceres',N'Fraccionamiento',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,21,1,15,N'Urbano',23),
	 (81370,N'Topolobampo Centro',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,806,N'Urbano',23),
	 (81370,N'Topolobampo',N'Puerto',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,40,1,3182,N'Urbano',23),
	 (81372,N'Correos',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,21,N'Urbano',23),
	 (81372,N'Secundaria',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,22,N'Urbano',23),
	 (81372,N'Plaza',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1879,N'Urbano',23),
	 (81372,N'Estaci�n 1',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1884,N'Urbano',23),
	 (81372,N'Aduana',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1885,N'Urbano',23);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81372,N'Capilla San Jos�',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1886,N'Urbano',23),
	 (81372,N'San Jos� 1',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1887,N'Urbano',23),
	 (81372,N'San Jos� 2',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1888,N'Urbano',23),
	 (81372,N'El Pedregal',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1889,N'Urbano',23),
	 (81372,N'Kil�metro 23',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1890,N'Urbano',23),
	 (81372,N'Pestalozzi',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1891,N'Urbano',23),
	 (81372,N'Varadero 1',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1892,N'Urbano',23),
	 (81372,N'Varadero 2',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1893,N'Urbano',23),
	 (81372,N'Libertad',N'Barrio',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,2,1,1894,N'Urbano',23),
	 (81372,N'Sindicatura',N'Barrio',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,2,1,1895,N'Urbano',23);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81373,N'Banamex',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1880,N'Urbano',23),
	 (81373,N'Seguro Social',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1881,N'Urbano',23),
	 (81373,N'Los Conchos',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1897,N'Urbano',23),
	 (81373,N'P�rgola 1',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1899,N'Urbano',23),
	 (81373,N'P�rgola 2',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1900,N'Urbano',23),
	 (81373,N'Providencia',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1901,N'Urbano',23),
	 (81373,N'Mendez',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1902,N'Urbano',23),
	 (81373,N'Secretaria de Marina',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1903,N'Urbano',23),
	 (81373,N'Sindicato',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1904,N'Urbano',23),
	 (81373,N'Est�ndar',N'Barrio',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,2,1,1905,N'Urbano',23);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81373,N'Telmex',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1906,N'Urbano',23),
	 (81373,N'Pesquera',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1907,N'Urbano',23),
	 (81373,N'Secretaria de Marina Bajos',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1908,N'Urbano',23),
	 (81373,N'Iglesia de Guadalupe',N'Barrio',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,2,1,3016,N'Urbano',23),
	 (81374,N'CET Mar',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1883,N'Urbano',23),
	 (81374,N'La Guasima',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1896,N'Urbano',23),
	 (81375,N'Estaci�n 2',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1882,N'Urbano',23),
	 (81375,N'INFONAVIT La Curva',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1909,N'Urbano',23),
	 (81375,N'Cartolandia',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1910,N'Urbano',23),
	 (81375,N'24 de Febrero',N'Colonia',N'Ahome',N'Sinaloa',N'Topolobampo',81371,25,81371,NULL,9,1,1911,N'Urbano',23);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81376,N'Ohuira',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,808,N'Rural',NULL),
	 (81377,N'Campo Guadalupe Estrada',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81371,25,81371,NULL,29,1,41,N'Rural',NULL),
	 (81377,N'Topolobampo',N'Pueblo',N'Ahome',N'Sinaloa',N'',81371,25,81371,NULL,28,1,44,N'Rural',NULL),
	 (81377,N'Rosendo G. Castro',N'Pueblo',N'Ahome',N'Sinaloa',N'',81371,25,81371,NULL,28,1,801,N'Rural',NULL),
	 (81377,N'Paredones',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81371,25,81371,NULL,29,1,2566,N'Rural',NULL),
	 (81378,N'Bachomobampo N�mero Uno',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,809,N'Rural',NULL),
	 (81378,N'Bachomobampo N�mero Dos',N'Rancher�a',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,29,1,810,N'Rural',NULL),
	 (81379,N'9 de Diciembre',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,807,N'Rural',NULL),
	 (81379,N'Plan de Guadalupe',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,811,N'Rural',NULL),
	 (81379,N'Campo Cinco Plan de Ayala',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,2425,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81379,N'Benito Ju�rez',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,3011,N'Rural',NULL),
	 (81384,N'Primero de Mayo',N'Ejido',N'Ahome',N'Sinaloa',N'',81201,25,81201,NULL,15,1,813,N'Rural',NULL),
	 (81400,N'Zona Centro',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,814,N'Urbano',6),
	 (81400,N'Empleados de FFCC Nacionales de M�xico Secc 26',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,815,N'Urbano',6),
	 (81400,N'Empleados de FFCC Nacionales de M�xico Secc 27',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,851,N'Urbano',6),
	 (81410,N'Lomas del Valle',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,817,N'Urbano',6),
	 (81410,N'Ampliaci�n Lomas del Valle',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,818,N'Urbano',6),
	 (81410,N'Santa Rosa',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,819,N'Urbano',6),
	 (81413,N'CANACO',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,523,N'Urbano',6),
	 (81413,N'Los Mautos',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,548,N'Urbano',6);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81420,N'San Miguel',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,820,N'Urbano',6),
	 (81426,N'Los �ngeles',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,546,N'Urbano',6),
	 (81426,N'5 de Febrero',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,821,N'Urbano',6),
	 (81427,N'La Cuesta de Higuera',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,822,N'Urbano',6),
	 (81427,N'Los Laureles',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,2086,N'Urbano',6),
	 (81427,N'Buenos Aires',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,2087,N'Urbano',6),
	 (81427,N'Villahermosa',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2091,N'Urbano',6),
	 (81429,N'10 de Mayo',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,823,N'Urbano',6),
	 (81430,N'Agustina Ram�rez',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,824,N'Urbano',6),
	 (81430,N'Ni�os H�roes',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,825,N'Urbano',6);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81430,N'El Pedregal',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2154,N'Urbano',6),
	 (81430,N'Privada San Felipe',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2892,N'Urbano',6),
	 (81440,N'Militar',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,826,N'Urbano',6),
	 (81440,N'15 de Julio',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,827,N'Urbano',6),
	 (81440,N'Viva Bien',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,1972,N'Urbano',6),
	 (81440,N'12 de Enero',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,1974,N'Urbano',6),
	 (81448,N'Fernando Irizar L�pez',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,1,N'Urbano',6),
	 (81448,N'Lomas de las Torres',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,541,N'Urbano',6),
	 (81448,N'Emiliano Zapata',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,829,N'Urbano',6),
	 (81448,N'Emiliano Zapata',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,830,N'Urbano',6);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81448,N'Profesionistas',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,2872,N'Urbano',6),
	 (81448,N'Colinas de San Ambrosio',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,3050,N'Urbano',6),
	 (81450,N'Benito Ju�rez',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,831,N'Urbano',6),
	 (81460,N'Bebelamas INFONAVIT',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,520,N'Urbano',6),
	 (81460,N'Chutamonas',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,527,N'Urbano',6),
	 (81460,N'Del Evora',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,832,N'Urbano',6),
	 (81460,N'Morelos',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,833,N'Urbano',6),
	 (81460,N'Los Parques',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,834,N'Urbano',6),
	 (81470,N'Insurgentes',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,835,N'Urbano',6),
	 (81470,N'La Gloria',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,836,N'Urbano',6);
INSERT INTO Sinaloa(d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81470,N'Magisterio',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,837,N'Urbano',6),
	 (81470,N'FOVISSSTE',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,1973,N'Urbano',6),
	 (81474,N'Jobori',N'Unidad habitacional',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,31,15,838,N'Urbano',6),
	 (81474,N'Las Palmas',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,839,N'Urbano',6),
	 (81474,N'San Miguel',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,840,N'Urbano',6),
	 (81475,N'Campestre Rinc�n de Santa Luc�a',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,28,N'Urbano',6),
	 (81475,N'Huertos Universitarios',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,29,N'Urbano',6),
	 (81475,N'Ampliaci�n Solidaridad',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,30,N'Urbano',6),
	 (81475,N'Jorge Casal',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,31,N'Urbano',6),
	 (81475,N'Colinas del Sur',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,32,N'Urbano',6);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81475,N'Solidaridad',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,570,N'Urbano',6),
	 (81475,N'10 de Abril',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,841,N'Urbano',6),
	 (81475,N'Pedro Infante',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,2084,N'Urbano',6),
	 (81475,N'Maqu�o Clouthier',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,2085,N'Urbano',6),
	 (81475,N'Las Praderas',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2721,N'Urbano',6),
	 (81475,N'Valle Bonito',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2876,N'Urbano',6),
	 (81476,N'Renato Vega',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,556,N'Urbano',6),
	 (81476,N'1 de Mayo',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,842,N'Urbano',6),
	 (81476,N'Prado Bonito',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2088,N'Urbano',6),
	 (81477,N'Tultita',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,843,N'Urbano',6);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81478,N'Unidad Nacional',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,844,N'Urbano',6),
	 (81478,N'Las Fincas de Tultita',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2272,N'Urbano',6),
	 (81478,N'Linda Vista',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2874,N'Urbano',6),
	 (81479,N'Santa Sof�a Residencial',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2,N'Urbano',6),
	 (81479,N'Las Fuentes',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,532,N'Urbano',6),
	 (81479,N'Loma Linda',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,543,N'Urbano',6),
	 (81479,N'Residencial del Valle',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,558,N'Urbano',6),
	 (81479,N'Santa Mar�a',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,568,N'Urbano',6),
	 (81479,N'Victoria',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,845,N'Urbano',6),
	 (81479,N'San Crist�bal',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2089,N'Urbano',6);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81479,N'Nuestra Se�ora de Guadalupe',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,2870,N'Urbano',6),
	 (81479,N'Lomas del Sol',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2871,N'Urbano',6),
	 (81480,N'San Pedro',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,846,N'Urbano',6),
	 (81480,N'Los �lamos',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,1971,N'Urbano',6),
	 (81489,N'Zona Industrial',N'Zona industrial',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,37,15,578,N'Urbano',6),
	 (81490,N'Cuauht�moc',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,848,N'Urbano',6),
	 (81490,N'Las Garzas',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,849,N'Urbano',6),
	 (81490,N'Amapas',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,9,15,850,N'Urbano',6),
	 (81490,N'Loma Verde',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2257,N'Urbano',6),
	 (81490,N'Loma Dorada',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2258,N'Urbano',6);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81490,N'Haciendas',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2259,N'Urbano',6),
	 (81490,N'Bugambilias',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2868,N'Urbano',6),
	 (81490,N'INFONAVIT Las Higueras',N'Unidad habitacional',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,31,15,2875,N'Urbano',6),
	 (81493,N'Rafael Buelna',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,27,N'Urbano',6),
	 (81493,N'Lomas de los Achiris',N'Fraccionamiento',N'Salvador Alvarado',N'Sinaloa',N'Guam�chil',81402,25,81402,NULL,21,15,2873,N'Urbano',6),
	 (81500,N'La V�bora',N'Rancho',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,48,15,22,N'Rural',NULL),
	 (81500,N'Campo San Felipe',N'Rancho',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,48,15,24,N'Rural',NULL),
	 (81500,N'Campo Roch�n',N'Rancho',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,48,15,26,N'Rural',NULL),
	 (81500,N'El Salitre',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,853,N'Rural',NULL),
	 (81500,N'Gabriel Leyva Vel�zquez (La Escalera)',N'Ejido',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,15,15,2385,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81504,N'Campo P�njamo',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,10,N'Rural',NULL),
	 (81504,N'Lucio Blanco',N'Ejido',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,15,15,2378,N'Rural',NULL),
	 (81504,N'Emilio �lvarez Ibarra (Las Golondrinas)',N'Ejido',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,15,15,2379,N'Rural',NULL),
	 (81504,N'Cruz Blanca',N'Ejido',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,15,15,2383,N'Rural',NULL),
	 (81504,N'Rodolfo S�nchez Taboada (Las Lagunitas)',N'Ejido',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,15,15,2384,N'Rural',NULL),
	 (81510,N'Los Chinos',N'Ejido',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,15,15,7,N'Rural',NULL),
	 (81510,N'Veintisiete de Noviembre',N'Colonia',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,9,15,2382,N'Rural',NULL),
	 (81513,N'20 de Noviembre',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,13,N'Rural',NULL),
	 (81513,N'Tres Palmas',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,17,N'Rural',NULL),
	 (81513,N'Las Cabezas',N'Ejido',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,15,15,2381,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81520,N'Benito Ju�rez',N'Pueblo',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,28,15,857,N'Urbano',NULL),
	 (81523,N'Yacochito',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,14,N'Rural',NULL),
	 (81523,N'El Mauto',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,2718,N'Rural',NULL),
	 (81524,N'San Mart�n',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,25,N'Rural',NULL),
	 (81524,N'15 de Septiembre',N'Ejido',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,15,15,2305,N'Rural',NULL),
	 (81525,N'El Guayac�n',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,21,N'Rural',NULL),
	 (81525,N'Ci�nega de Casal',N'Pueblo',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,28,15,856,N'Rural',NULL),
	 (81530,N'El Alto del Taballal',N'Rancho',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,48,15,20,N'Rural',NULL),
	 (81530,N'El Taballal',N'Pueblo',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,28,15,854,N'Rural',NULL),
	 (81530,N'�lamo de los Montoya',N'Ejido',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,15,15,2380,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81533,N'El Descanso',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,16,N'Rural',NULL),
	 (81535,N'Buenavista',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,3,N'Rural',NULL),
	 (81535,N'Carricitos',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,5,N'Rural',NULL),
	 (81535,N'Gustavo D�az Ordaz',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,18,N'Rural',NULL),
	 (81535,N'Toro Manchado',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,19,N'Rural',NULL),
	 (81535,N'Caitime',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,852,N'Rural',NULL),
	 (81540,N'Cacalotita',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,4,N'Rural',NULL),
	 (81540,N'Cerro Bola',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,6,N'Rural',NULL),
	 (81540,N'El Batall�n de los Montoya',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,15,N'Rural',NULL),
	 (81543,N'El Gato de los Gallardo',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,8,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81543,N'La Tasajera',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,11,N'Rural',NULL),
	 (81544,N'Terrero de los Guerrero',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,12,N'Rural',NULL),
	 (81545,N'Laguna de Palos Blancos',N'Rancher�a',N'Salvador Alvarado',N'Sinaloa',N'',81402,25,81402,NULL,29,15,9,N'Rural',NULL),
	 (81600,N'Angostura Centro',N'Colonia',N'Angostura',N'Sinaloa',N'Angostura',81601,25,81601,NULL,9,2,858,N'Rural',15),
	 (81600,N'Labastida Ochoa',N'Colonia',N'Angostura',N'Sinaloa',N'Angostura',81601,25,81601,NULL,9,2,1804,N'Rural',15),
	 (81600,N'Fovissste',N'Colonia',N'Angostura',N'Sinaloa',N'Angostura',81601,25,81601,NULL,9,2,1805,N'Rural',15),
	 (81600,N'Los �lamos',N'Fraccionamiento',N'Angostura',N'Sinaloa',N'Angostura',81601,25,81601,NULL,21,2,3079,N'Urbano',15),
	 (81610,N'Alhuey',N'Pueblo',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,28,2,860,N'Rural',NULL),
	 (81610,N'Capomos',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,861,N'Rural',NULL),
	 (81610,N'Batamotos',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,2387,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81613,N'Capomones',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,2,N'Rural',NULL),
	 (81613,N'La Loma',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,3,N'Rural',NULL),
	 (81613,N'La Isleta',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,4,N'Rural',NULL),
	 (81613,N'Comercializadora de Granos Patr�n',N'Equipamiento',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,17,2,36,N'Rural',NULL),
	 (81620,N'Toberi',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,6,N'Rural',NULL),
	 (81620,N'Santa Rita',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,7,N'Rural',NULL),
	 (81620,N'El �bano',N'Pueblo',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,28,2,862,N'Rural',NULL),
	 (81620,N'San Antonio',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,863,N'Rural',NULL),
	 (81621,N'La Primavera',N'Pueblo',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,28,2,864,N'Rural',NULL),
	 (81622,N'La Colorada',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,8,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81622,N'El Fuerte',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,9,N'Rural',NULL),
	 (81622,N'Alhueycito',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,10,N'Rural',NULL),
	 (81622,N'La Palma',N'Pueblo',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,28,2,865,N'Rural',NULL),
	 (81623,N'Mojolo',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,11,N'Rural',NULL),
	 (81623,N'San Isidro',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,866,N'Rural',NULL),
	 (81624,N'La Cercada',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,12,N'Rural',NULL),
	 (81624,N'El Molino',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,13,N'Rural',NULL),
	 (81624,N'Las Infamias',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,14,N'Rural',NULL),
	 (81624,N'El Bonete',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,15,N'Rural',NULL),
	 (81624,N'Nacozari',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,16,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81624,N'El Llano',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,867,N'Rural',NULL),
	 (81624,N'San Luciano',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,868,N'Rural',NULL),
	 (81625,N'Las Tunas',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,1,N'Rural',NULL),
	 (81625,N'La Esperanza',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,869,N'Rural',NULL),
	 (81630,N'Acatita de los Castro',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,17,N'Rural',NULL),
	 (81630,N'Estaci�n Acatita',N'Pueblo',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,28,2,870,N'Rural',NULL),
	 (81632,N'Chumpilihuiztle',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,18,N'Rural',NULL),
	 (81632,N'El Cachor�n (La Esmeralda)',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,19,N'Rural',NULL),
	 (81632,N'La Uni�n',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,871,N'Rural',NULL),
	 (81632,N'El Ranchito',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,2719,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81635,N'El Ebanito',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,20,N'Rural',NULL),
	 (81635,N'La Ilama',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,2386,N'Rural',NULL),
	 (81635,N'18 de Diciembre',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,2388,N'Rural',NULL),
	 (81635,N'La Providencia',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,3123,N'Rural',NULL),
	 (81639,N'Juan de la Barrera N�mero Dos',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,21,N'Rural',NULL),
	 (81639,N'Bruno Beltr�n Garc�a',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,872,N'Rural',NULL),
	 (81640,N'Cerro Segundo',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,22,N'Rural',NULL),
	 (81640,N'Gustavo D�az Ordaz (Campo Plata)',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,873,N'Rural',NULL),
	 (81642,N'Palos Verdes',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,23,N'Rural',NULL),
	 (81642,N'Campo el General',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,874,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81644,N'Guayparime',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,24,N'Rural',NULL),
	 (81644,N'Las Tatemitas',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,25,N'Rural',NULL),
	 (81649,N'Cerro Angostura',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,26,N'Rural',NULL),
	 (81649,N'Cerro de los S�nchez',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,27,N'Rural',NULL),
	 (81649,N'Agustina Ram�rez',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,875,N'Rural',NULL),
	 (81650,N'Doce de Octubre (La Sonrisa)',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,28,N'Rural',NULL),
	 (81650,N'El Nuevo Ostional',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,29,N'Rural',NULL),
	 (81650,N'Valent�n G�mez Far�as (El Muerto)',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,876,N'Rural',NULL),
	 (81652,N'Chapo Arce',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,30,N'Rural',NULL),
	 (81652,N'Playa Colorada',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,877,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81653,N'Batury',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,878,N'Rural',NULL),
	 (81654,N'El Batall�n (El Batall�n de los Payanes)',N'Colonia',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,9,2,31,N'Rural',NULL),
	 (81654,N'El Saucito',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,32,N'Rural',NULL),
	 (81654,N'La Rosita',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,2981,N'Rural',NULL),
	 (81655,N'El Play�n',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,33,N'Rural',NULL),
	 (81655,N'Protom�rtir de Sinaloa',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,879,N'Rural',NULL),
	 (81660,N'Agr�cola M�xico (Palmitas)',N'Pueblo',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,28,2,880,N'Urbano',NULL),
	 (81661,N'D�maso C�rdenas',N'Rancher�a',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,29,2,882,N'Rural',NULL),
	 (81661,N'Rafael Buelna',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,883,N'Rural',NULL),
	 (81663,N'Contreras',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,34,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81664,N'Santa Mar�a del Play�n',N'Rancho',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,48,2,35,N'Rural',NULL),
	 (81664,N'Independencia',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,884,N'Rural',NULL),
	 (81666,N'Costa Azul',N'Colonia',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,9,2,885,N'Rural',NULL),
	 (81670,N'Leopoldo S�nchez Celis (El Gato de Lara)',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,886,N'Rural',NULL),
	 (81670,N'Ignacio Allende',N'Ejido',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,15,2,2306,N'Rural',NULL),
	 (81675,N'Agr�cola Sinaloa',N'Colonia',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,9,2,887,N'Rural',NULL),
	 (81680,N'La Reforma',N'Pueblo',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,28,2,888,N'Rural',NULL),
	 (81690,N'Independencia (Chinitos)',N'Colonia',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,9,2,890,N'Urbano',NULL),
	 (81690,N'Arboladas',N'Colonia',N'Angostura',N'Sinaloa',N'',81601,25,81601,NULL,9,2,3153,N'Urbano',NULL),
	 (81700,N'Choix Centro',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,1772,N'Urbano',11);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81703,N'Aguajito',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,1774,N'Urbano',11),
	 (81703,N'Huites',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,1776,N'Urbano',11),
	 (81703,N'Francisco R. Serrano',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,2037,N'Urbano',11),
	 (81703,N'Francisco I. Madero',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,2038,N'Urbano',11),
	 (81705,N'Higuerita',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,1780,N'Urbano',11),
	 (81706,N'Conchas',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,1775,N'Urbano',11),
	 (81707,N'Ayuntamiento 89',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,1779,N'Urbano',11),
	 (81707,N'Benito Ju�rez',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,2889,N'Urbano',11),
	 (81708,N'Ampliaci�n Reforma',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,1778,N'Urbano',11),
	 (81708,N'Poblado Nuevo Huites',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,1781,N'Urbano',11);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81709,N'Tepehuaje',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,182,N'Urbano',11),
	 (81709,N'Los Pescadores',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,183,N'Urbano',11),
	 (81709,N'Reforma',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,1773,N'Urbano',11),
	 (81709,N'Ejidal',N'Colonia',N'Choix',N'Sinaloa',N'Choix',81701,25,81701,NULL,9,7,1777,N'Urbano',11),
	 (81710,N'Ranchito de Islas',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,4,N'Rural',NULL),
	 (81710,N'El Vado (El Cerrito)',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,101,N'Rural',NULL),
	 (81712,N'Poblado Nuevo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,111,N'Rural',NULL),
	 (81712,N'La Calera',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,120,N'Rural',NULL),
	 (81712,N'La Igualamita',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,123,N'Rural',NULL),
	 (81712,N'Los Barbechitos',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,124,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81712,N'El Mezquite Ca�do',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,125,N'Rural',NULL),
	 (81712,N'La Salvia',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,127,N'Rural',NULL),
	 (81712,N'Las Taunitas',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,137,N'Rural',NULL),
	 (81712,N'Tasajeras',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,894,N'Rural',NULL),
	 (81712,N'El Nacimiento',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,2295,N'Rural',NULL),
	 (81713,N'Las Colmenas',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,107,N'Rural',NULL),
	 (81713,N'El Reparo',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,116,N'Rural',NULL),
	 (81713,N'El Cedrito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,122,N'Rural',NULL),
	 (81713,N'Nuevo Techobampo',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,128,N'Rural',NULL),
	 (81713,N'Los Chinos',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,138,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81715,N'Bajosori',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,891,N'Rural',NULL),
	 (81715,N'El Guayabito',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,909,N'Rural',NULL),
	 (81716,N'Las Urracas',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,3,N'Rural',NULL),
	 (81716,N'Estaci�n Loreto',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,92,N'Rural',NULL),
	 (81716,N'San Jos� de los Portillo',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,97,N'Rural',NULL),
	 (81716,N'Rancho Nuevo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,168,N'Rural',NULL),
	 (81716,N'Loreto',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,901,N'Rural',NULL),
	 (81716,N'Tabucahui',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,902,N'Rural',NULL),
	 (81717,N'El Altillo',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,1,N'Rural',NULL),
	 (81717,N'Las Rastras',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,2,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81717,N'El Rancho',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,20,N'Rural',NULL),
	 (81717,N'Toipaqui',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,105,N'Rural',NULL),
	 (81717,N'Loretillo',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,899,N'Rural',NULL),
	 (81718,N'Subilimayo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,11,N'Rural',NULL),
	 (81718,N'La Estancia',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,109,N'Rural',NULL),
	 (81718,N'Los Chinitos',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,110,N'Rural',NULL),
	 (81718,N'El Embarcadero',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,115,N'Rural',NULL),
	 (81718,N'Los Arenales',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,118,N'Rural',NULL),
	 (81718,N'El Garabato',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,121,N'Rural',NULL),
	 (81718,N'El Veranito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,126,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81718,N'El Zataque',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,129,N'Rural',NULL),
	 (81718,N'Baca',N'Pueblo',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,28,7,896,N'Rural',NULL),
	 (81718,N'Agua Caliente de Baca',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,897,N'Rural',NULL),
	 (81718,N'El Aguaje',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,3120,N'Rural',NULL),
	 (81718,N'Conicari',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,3121,N'Rural',NULL),
	 (81718,N'La Tuna',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,3129,N'Rural',NULL),
	 (81719,N'El Cajoncito (La Cieneguita)',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,130,N'Rural',NULL),
	 (81719,N'San Antonio',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,134,N'Rural',NULL),
	 (81719,N'Las Cruces',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,136,N'Rural',NULL),
	 (81719,N'El Descanso',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,903,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81719,N'Los Pozos',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,904,N'Rural',NULL),
	 (81720,N'Los Cedros',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,155,N'Rural',NULL),
	 (81724,N'Tezcalama (Tezcalama de Tarar�n)',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,14,N'Rural',NULL),
	 (81724,N'Las Presitas',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,15,N'Rural',NULL),
	 (81724,N'Las Higueras',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,98,N'Rural',NULL),
	 (81724,N'El Muerto',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,161,N'Rural',NULL),
	 (81724,N'�ltimo Vado',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,164,N'Rural',NULL),
	 (81724,N'La Nopalera',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,173,N'Rural',NULL),
	 (81725,N'El Carricito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,91,N'Rural',NULL),
	 (81725,N'Tararancito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,93,N'Rural',NULL);
INSERT INTO Sinaloa(d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81725,N'Los Alisos',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,94,N'Rural',NULL),
	 (81725,N'El Tule',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,95,N'Rural',NULL),
	 (81725,N'Los Cocos',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,169,N'Rural',NULL),
	 (81727,N'El Bainoral',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,87,N'Rural',NULL),
	 (81727,N'El Trigo',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,96,N'Rural',NULL),
	 (81727,N'Las Canoas (Huillachapa)',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,167,N'Rural',NULL),
	 (81727,N'Huillachapa (Buenavista)',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,900,N'Rural',NULL),
	 (81730,N'La Cieneguita de N��ez',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,8,N'Rural',NULL),
	 (81733,N'La Culebra',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,9,N'Rural',NULL),
	 (81733,N'El Oro',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,119,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81734,N'El Difunto',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,5,N'Rural',NULL),
	 (81734,N'El Real Blanco',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,6,N'Rural',NULL),
	 (81734,N'El Saucito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,7,N'Rural',NULL),
	 (81734,N'La Ladrillera de Madriles',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,16,N'Rural',NULL),
	 (81734,N'Mina Fr�a',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,106,N'Rural',NULL),
	 (81734,N'El Palmar',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,112,N'Rural',NULL),
	 (81734,N'Corral Quemado',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,113,N'Rural',NULL),
	 (81734,N'El Saucillo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,114,N'Rural',NULL),
	 (81734,N'Las Juntas',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,117,N'Rural',NULL),
	 (81734,N'Madriles',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,171,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81734,N'Puerto la Jud�a',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,3041,N'Rural',NULL),
	 (81735,N'El Sauz',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,103,N'Rural',NULL),
	 (81735,N'El Tacuache',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,170,N'Rural',NULL),
	 (81735,N'Cieneguita',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,2992,N'Rural',NULL),
	 (81736,N'El Orito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,100,N'Rural',NULL),
	 (81736,N'Jos� Lucas',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,102,N'Rural',NULL),
	 (81736,N'Zapote de Madriles',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,104,N'Rural',NULL),
	 (81736,N'Coscomate',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,2993,N'Rural',NULL),
	 (81737,N'El Guam�chil (Guam�chil de los Valdez)',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,108,N'Rural',NULL),
	 (81737,N'Potrero de Cancio',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,905,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81737,N'Caj�n de Cancio',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,906,N'Rural',NULL),
	 (81738,N'El Mochiqui',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,86,N'Rural',NULL),
	 (81738,N'El Mochiquito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,88,N'Rural',NULL),
	 (81738,N'El Saquillo',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,152,N'Rural',NULL),
	 (81738,N'Las Pilas',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,153,N'Rural',NULL),
	 (81738,N'Los Mimbres',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,156,N'Rural',NULL),
	 (81738,N'El Babu',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,160,N'Rural',NULL),
	 (81738,N'La Sauceda',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,162,N'Rural',NULL),
	 (81738,N'La Molienda',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,166,N'Rural',NULL),
	 (81740,N'Los Mautos',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,99,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81740,N'El Sauz de Baca',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,898,N'Rural',NULL),
	 (81740,N'Agua Zarca',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,2299,N'Rural',NULL),
	 (81740,N'Techobampo de los Cota',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,2887,N'Rural',NULL),
	 (81743,N'Agua Nueva',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,81,N'Rural',NULL),
	 (81743,N'La Piedra Bola',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,154,N'Rural',NULL),
	 (81743,N'San Isidro',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,158,N'Rural',NULL),
	 (81743,N'Los Cauques',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,163,N'Rural',NULL),
	 (81743,N'San Javier',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,907,N'Rural',NULL),
	 (81743,N'Techobampo de los Montes',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,3200,N'Rural',NULL),
	 (81745,N'La Ci�nega',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,911,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81746,N'El Ranchito de Buyubampo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,74,N'Rural',NULL),
	 (81746,N'La Viuda',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,157,N'Rural',NULL),
	 (81746,N'Buyubampo',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,910,N'Rural',NULL),
	 (81749,N'El Pajarito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,79,N'Rural',NULL),
	 (81749,N'Tres Hermanos',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,89,N'Rural',NULL),
	 (81749,N'Los Batequis',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,90,N'Rural',NULL),
	 (81749,N'El Tepeguaje (Caballihuaza)',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,172,N'Rural',NULL),
	 (81749,N'Los Picachos',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,908,N'Rural',NULL),
	 (81750,N'El Saucillo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,17,N'Rural',NULL),
	 (81750,N'Las Juntas',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,76,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81750,N'San Antonio',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,149,N'Rural',NULL),
	 (81750,N'La Guayepa',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,150,N'Rural',NULL),
	 (81750,N'El Guayabo de San Pantale�n',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,151,N'Rural',NULL),
	 (81750,N'San Pantale�n',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,2712,N'Rural',NULL),
	 (81753,N'Moliendita',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,77,N'Rural',NULL),
	 (81753,N'El Sabino Gordo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,78,N'Rural',NULL),
	 (81753,N'El Sauz de San Isidro',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,80,N'Rural',NULL),
	 (81753,N'Potrerillo',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,82,N'Rural',NULL),
	 (81753,N'El Chapote',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,83,N'Rural',NULL),
	 (81753,N'San Isidro',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,84,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81753,N'El Hornito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,159,N'Rural',NULL),
	 (81753,N'Los Mirasoles',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,165,N'Rural',NULL),
	 (81754,N'Los Llanitos',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,69,N'Rural',NULL),
	 (81754,N'El Palmarito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,71,N'Rural',NULL),
	 (81754,N'Santa Rosa',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,72,N'Rural',NULL),
	 (81754,N'Horconcitos',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,75,N'Rural',NULL),
	 (81755,N'San Pedro',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,66,N'Rural',NULL),
	 (81755,N'San Jos� de los Llanos (Los Llanos)',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,68,N'Rural',NULL),
	 (81755,N'El Potrerito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,70,N'Rural',NULL),
	 (81755,N'Santana',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,73,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81756,N'La Estancia de Baymena',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,19,N'Rural',NULL),
	 (81756,N'Rinc�n Grande de Baymena',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,60,N'Rural',NULL),
	 (81756,N'El Zapote de Baymena',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,62,N'Rural',NULL),
	 (81756,N'Sauz de Baymena (El Sauz)',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,67,N'Rural',NULL),
	 (81757,N'Mesa de los Torres',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,13,N'Rural',NULL),
	 (81757,N'Nacapule',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,135,N'Rural',NULL),
	 (81757,N'Guadalupe',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,912,N'Rural',NULL),
	 (81760,N'Baymena',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,55,N'Rural',NULL),
	 (81760,N'Agua Caliente Grande (De Gast�lum)',N'Pueblo',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,28,7,895,N'Rural',NULL),
	 (81760,N'Santa Ana',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,914,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81760,N'El Aguajito de Bajahui',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,916,N'Rural',NULL),
	 (81760,N'Venicia',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,2235,N'Rural',NULL),
	 (81763,N'Las Guayabas',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,52,N'Rural',NULL),
	 (81763,N'La Igualama',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,54,N'Rural',NULL),
	 (81763,N'Baymena',N'Pueblo',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,28,7,917,N'Rural',NULL),
	 (81764,N'Chicuras',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,18,N'Rural',NULL),
	 (81764,N'El Cojinillo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,21,N'Rural',NULL),
	 (81764,N'El Carrizo de los Torres',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,22,N'Rural',NULL),
	 (81764,N'Agua Calientilla',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,23,N'Rural',NULL),
	 (81764,N'Chavira',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,24,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81764,N'La Mesa del Oro',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,25,N'Rural',NULL),
	 (81764,N'El Chapote',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,33,N'Rural',NULL),
	 (81764,N'Vinater�as',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,41,N'Rural',NULL),
	 (81764,N'San Jos� de Choix (Las Lajitas)',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,142,N'Rural',NULL),
	 (81764,N'San Jos� de los Pericos',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,143,N'Rural',NULL),
	 (81764,N'Los Pericos',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,144,N'Rural',NULL),
	 (81764,N'Casa Vieja',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,145,N'Rural',NULL),
	 (81764,N'Los Chinos',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,180,N'Rural',NULL),
	 (81764,N'La Rondana',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,181,N'Rural',NULL),
	 (81764,N'Yecorato',N'Pueblo',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,28,7,918,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81764,N'El Frijol',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,2226,N'Rural',NULL),
	 (81765,N'Rinc�n de Agua Caliente Grande',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,53,N'Rural',NULL),
	 (81765,N'Antonio Rosales (El Disparate)',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,64,N'Rural',NULL),
	 (81765,N'El Colexio',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,915,N'Rural',NULL),
	 (81765,N'El Caj�n de los F�lix',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,2234,N'Rural',NULL),
	 (81765,N'Los Cedros',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,3019,N'Rural',NULL),
	 (81766,N'El Platanito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,139,N'Rural',NULL),
	 (81766,N'Los Chapotes',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,140,N'Rural',NULL),
	 (81766,N'Las Lajas',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,141,N'Rural',NULL),
	 (81766,N'El Terrero',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,174,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81766,N'Ca�ada el Rengo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,175,N'Rural',NULL),
	 (81766,N'El Realito de los Espinoza',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,176,N'Rural',NULL),
	 (81766,N'Potrero de los Fierro',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,177,N'Rural',NULL),
	 (81766,N'La Vinata',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,178,N'Rural',NULL),
	 (81766,N'Ranchito de Cabrera',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,3088,N'Rural',NULL),
	 (81770,N'El Llano',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,30,N'Rural',NULL),
	 (81770,N'Las Mercedes',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,34,N'Rural',NULL),
	 (81770,N'Bacayopa',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,36,N'Rural',NULL),
	 (81770,N'La Cuevita',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,37,N'Rural',NULL),
	 (81770,N'El Caj�n',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,39,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81770,N'Pie de la Cuesta (Los Laureles)',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,43,N'Rural',NULL),
	 (81770,N'Los Laureles',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,45,N'Rural',NULL),
	 (81770,N'El Pinito (La Ca�ada de Le�n)',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,48,N'Rural',NULL),
	 (81770,N'Casas Viejas',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,919,N'Rural',NULL),
	 (81773,N'El Sabino',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,59,N'Rural',NULL),
	 (81773,N'El Taparuyo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,61,N'Rural',NULL),
	 (81773,N'Las Ranas',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,63,N'Rural',NULL),
	 (81773,N'Sacochi (Haracoche)',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,65,N'Rural',NULL),
	 (81774,N'Norogachi',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,57,N'Rural',NULL),
	 (81774,N'Barranco de los Ruelas',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,58,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81774,N'Sonogoris',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,147,N'Rural',NULL),
	 (81774,N'La Sauceda',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,148,N'Rural',NULL),
	 (81774,N'El P�chol',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,913,N'Rural',NULL),
	 (81775,N'La Cumbre',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,31,N'Rural',NULL),
	 (81775,N'Puerto la Joya',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,32,N'Rural',NULL),
	 (81775,N'El Ranchito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,38,N'Rural',NULL),
	 (81775,N'La Chirimoya',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,40,N'Rural',NULL),
	 (81775,N'El Reparo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,42,N'Rural',NULL),
	 (81775,N'La Sidra',N'Ejido',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,15,7,3046,N'Rural',NULL),
	 (81776,N'El Lim�n',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,26,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81776,N'Potrero de los Cece�a',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,27,N'Rural',NULL),
	 (81776,N'San Sim�n',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,28,N'Rural',NULL),
	 (81776,N'Los Parajes',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,29,N'Rural',NULL),
	 (81776,N'Puerto del Reparo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,35,N'Rural',NULL),
	 (81776,N'El Carrizo de los Sarmiento',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,179,N'Rural',NULL),
	 (81777,N'Cadena',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,44,N'Rural',NULL),
	 (81777,N'Las Algarrobas',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,46,N'Rural',NULL),
	 (81777,N'El Terrero',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,47,N'Rural',NULL),
	 (81777,N'La Noria de Minitas',N'Rancher�a',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,29,7,49,N'Rural',NULL),
	 (81777,N'El Anc�n',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,50,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81777,N'Batayaqui',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,51,N'Rural',NULL),
	 (81777,N'Las Arenas',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,56,N'Rural',NULL),
	 (81777,N'El Realito',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,146,N'Rural',NULL),
	 (81780,N'Macoribo',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,133,N'Rural',NULL),
	 (81783,N'Los Molinos',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,10,N'Rural',NULL),
	 (81783,N'Huepaco',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,12,N'Rural',NULL),
	 (81784,N'Tacopaco',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,131,N'Rural',NULL),
	 (81784,N'Las Juntas de Osornio',N'Rancho',N'Choix',N'Sinaloa',N'',81701,25,81701,NULL,48,7,132,N'Rural',NULL),
	 (81800,N'San Blas Centro',N'Colonia',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,9,10,920,N'Urbano',16),
	 (81802,N'Kansas',N'Colonia',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,9,10,1845,N'Urbano',16);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81802,N'Libertad',N'Colonia',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,9,10,1846,N'Urbano',16),
	 (81802,N'Ejidal',N'Colonia',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,9,10,1847,N'Urbano',16),
	 (81802,N'San Blas Viejo',N'Colonia',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,9,10,3169,N'Urbano',16),
	 (81803,N'La Loma',N'Colonia',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,9,10,1848,N'Rural',16),
	 (81803,N'Cananea',N'Colonia',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,9,10,1849,N'Rural',16),
	 (81803,N'L�zaro C�rdenas',N'Colonia',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,9,10,1850,N'Rural',16),
	 (81803,N'Secci�n 23',N'Colonia',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,9,10,1851,N'Rural',16),
	 (81803,N'Secci�n 29',N'Colonia',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,9,10,1852,N'Rural',16),
	 (81803,N'Nuevo',N'Barrio',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,2,10,1853,N'Rural',16),
	 (81803,N'Las Flores',N'Barrio',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,2,10,1854,N'Rural',16);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81803,N'La Secci�n',N'Barrio',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,2,10,1855,N'Rural',16),
	 (81803,N'La Candelaria',N'Colonia',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,9,10,3170,N'Urbano',16),
	 (81804,N'8 de Octubre',N'Colonia',N'El Fuerte',N'Sinaloa',N'San Blas',81201,25,81201,NULL,9,10,1857,N'Rural',16),
	 (81805,N'Santa Luc�a',N'Rancho',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,48,10,8,N'Rural',NULL),
	 (81805,N'El Naranjo',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,9,N'Rural',NULL),
	 (81805,N'La Curva',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,46,N'Rural',NULL),
	 (81805,N'Las Estacas',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,926,N'Rural',NULL),
	 (81805,N'Tesila',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,927,N'Rural',NULL),
	 (81805,N'El Vateve',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,928,N'Rural',NULL),
	 (81805,N'La Carrera',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,929,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81805,N'Las Chunas',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,2245,N'Rural',NULL),
	 (81805,N'Ranchito de Bateve',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,2568,N'Rural',NULL),
	 (81805,N'Buenos Aires',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,3087,N'Rural',NULL),
	 (81806,N'Sibirijoa',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,29,N'Rural',NULL),
	 (81806,N'Tetamboca',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,30,N'Rural',NULL),
	 (81806,N'Buenavista',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,921,N'Rural',NULL),
	 (81806,N'Buenavista de Mochicahui',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,922,N'Rural',NULL),
	 (81806,N'Sibajahui',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,924,N'Rural',NULL),
	 (81806,N'Mulanjey [Estaci�n Vega]',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,925,N'Rural',NULL),
	 (81806,N'El Aliso',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,930,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81806,N'La Capilla',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,931,N'Rural',NULL),
	 (81807,N'Lomalinda',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,21,N'Rural',NULL),
	 (81807,N'Santa Mar�a',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,2231,N'Rural',NULL),
	 (81810,N'Crucero de Hornillos',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,6,N'Rural',NULL),
	 (81810,N'Bacausa de Abajo',N'Rancho',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,48,10,12,N'Rural',NULL),
	 (81810,N'El Mahone',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,23,N'Rural',NULL),
	 (81810,N'Los Capomitos',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,40,N'Rural',NULL),
	 (81810,N'Hornillos',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,932,N'Rural',NULL),
	 (81810,N'Los Capomos',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,933,N'Rural',NULL),
	 (81810,N'San Pedro',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,2296,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81811,N'Agua Caliente',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,934,N'Rural',NULL),
	 (81811,N'El Tepeguaje',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,935,N'Rural',NULL),
	 (81811,N'La Laguna',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,936,N'Rural',NULL),
	 (81812,N'Rinc�n de Alisos',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,937,N'Rural',NULL),
	 (81815,N'La Gavilana',N'Rancho',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,48,10,11,N'Rural',NULL),
	 (81820,N'Las Cabanillas',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,17,N'Rural',NULL),
	 (81820,N'Ocolome',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,24,N'Rural',NULL),
	 (81820,N'Los Ay�n',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,38,N'Rural',NULL),
	 (81820,N'Residencial del R�o',N'Fraccionamiento',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,21,10,51,N'Rural',NULL),
	 (81820,N'Baroten',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,938,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81820,N'El Fuerte Centro',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,940,N'Rural',NULL),
	 (81820,N'Tehueco',N'Pueblo',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,28,10,941,N'Rural',NULL),
	 (81820,N'Pablo Macias Valenzuela',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,1975,N'Rural',NULL),
	 (81820,N'Obrera',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,1977,N'Rural',NULL),
	 (81820,N'Los Ayalos',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,1980,N'Rural',NULL),
	 (81820,N'Leopoldo Sanchez Celis',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,1981,N'Rural',NULL),
	 (81820,N'Infonavit',N'Unidad habitacional',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,31,10,1982,N'Rural',NULL),
	 (81820,N'Solidaridad',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,2055,N'Rural',NULL),
	 (81820,N'Llano de los Soto',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,2229,N'Rural',NULL),
	 (81820,N'Villa de Montesclaros',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,3007,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81820,N'Palma Sola',N'Fraccionamiento',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,21,10,3069,N'Urbano',NULL),
	 (81820,N'Campamento CNA',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,3154,N'Urbano',NULL),
	 (81820,N'El Dique',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,3155,N'Urbano',NULL),
	 (81820,N'El Rastro',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,3156,N'Urbano',NULL),
	 (81820,N'H. Ayuntamiento',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,3157,N'Urbano',NULL),
	 (81820,N'Hospital',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,3158,N'Urbano',NULL),
	 (81820,N'La Bolsa',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,3159,N'Urbano',NULL),
	 (81820,N'La Bomba',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,3160,N'Urbano',NULL),
	 (81820,N'La Tener�a',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,3161,N'Urbano',NULL),
	 (81820,N'Quince',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,3162,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81825,N'Estaci�n Hoyancos [Estaci�n el Fuerte]',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,943,N'Rural',NULL),
	 (81827,N'Vivajaqui',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,944,N'Rural',NULL),
	 (81828,N'Bajada de Monte',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,945,N'Rural',NULL),
	 (81828,N'El Vado',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,946,N'Rural',NULL),
	 (81828,N'Los Terreros',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,2230,N'Rural',NULL),
	 (81830,N'Tetaroba',N'Pueblo',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,28,10,947,N'Rural',NULL),
	 (81833,N'Loma',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,1645,N'Rural',NULL),
	 (81834,N'Barrio Nuevo',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,1647,N'Rural',NULL),
	 (81834,N'L�zaro C�rdenas',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,9,10,1650,N'Rural',NULL),
	 (81840,N'Chinobampo',N'Pueblo',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,28,10,948,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81840,N'El Dique (Horacio Ur�as Nafarrete)',N'Rancho',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,48,10,1976,N'Rural',NULL),
	 (81843,N'El Realito 1',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,949,N'Rural',NULL),
	 (81844,N'Los Amoles',N'Rancho',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,48,10,4,N'Rural',NULL),
	 (81844,N'Chino de los V�zquez',N'Rancho',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,48,10,5,N'Rural',NULL),
	 (81844,N'Chino de los G�mez',N'Rancho',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,48,10,7,N'Rural',NULL),
	 (81845,N'San L�zaro',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,950,N'Rural',NULL),
	 (81846,N'La Junta',N'Rancho',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,48,10,3,N'Rural',NULL),
	 (81846,N'Potrero de los Soto',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,26,N'Rural',NULL),
	 (81847,N'Bacapaco',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,2228,N'Rural',NULL),
	 (81850,N'Borabampo',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,10,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81850,N'Boca de Arroyo',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,951,N'Rural',NULL),
	 (81850,N'La Misi�n Vieja',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,2315,N'Rural',NULL),
	 (81850,N'Cuesta Alta',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,2569,N'Rural',NULL),
	 (81850,N'La Misi�n Nueva',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,2570,N'Rural',NULL),
	 (81854,N'Arroyo de los Armenta',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,16,N'Rural',NULL),
	 (81854,N'Las Cabras',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,18,N'Rural',NULL),
	 (81854,N'La Galera',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,19,N'Rural',NULL),
	 (81854,N'Llano de los L�pez',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,22,N'Rural',NULL),
	 (81854,N'Zozorique',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,952,N'Rural',NULL),
	 (81855,N'Presa de los Valdez',N'Rancho',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,48,10,2,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81855,N'San Antonio',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,27,N'Rural',NULL),
	 (81856,N'Los Parajes',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81342,25,81342,NULL,29,10,25,N'Rural',NULL),
	 (81856,N'Tepic',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81342,25,81342,NULL,15,10,2426,N'Rural',NULL),
	 (81856,N'Palo Verde',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81342,25,81342,NULL,15,10,2571,N'Rural',NULL),
	 (81860,N'Canutillo',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,953,N'Rural',NULL),
	 (81864,N'Lo de Vega',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,29,10,954,N'Rural',NULL),
	 (81864,N'Los Ojitos',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,2227,N'Rural',NULL),
	 (81870,N'Jahuara Primero',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81342,25,81342,NULL,29,10,956,N'Rural',NULL),
	 (81871,N'Agua Nueva 2',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81342,25,81342,NULL,29,10,957,N'Rural',NULL),
	 (81872,N'San Jos� de Cahuinahua',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,35,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81872,N'La Bomba',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,43,N'Rural',NULL),
	 (81872,N'San Rafael',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,48,N'Rural',NULL),
	 (81872,N'Charay',N'Pueblo',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,28,10,955,N'Urbano',NULL),
	 (81872,N'Camajoa',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,958,N'Rural',NULL),
	 (81872,N'La Palma',N'Pueblo',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,28,10,959,N'Rural',NULL),
	 (81872,N'L�zaro C�rdenas',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,15,10,2888,N'Rural',NULL),
	 (81872,N'El Chorizo',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,9,10,3163,N'Urbano',NULL),
	 (81872,N'El Nopal',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,9,10,3164,N'Urbano',NULL),
	 (81872,N'El Poblado',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,9,10,3165,N'Urbano',NULL),
	 (81872,N'La Bacilia',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,9,10,3166,N'Urbano',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81872,N'La Calaca',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,9,10,3167,N'Urbano',NULL),
	 (81872,N'La Pitaya',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,9,10,3168,N'Urbano',NULL),
	 (81873,N'12 de Agosto',N'Colonia',N'El Fuerte',N'Sinaloa',N'',81342,25,81342,NULL,9,10,47,N'Urbano',NULL),
	 (81873,N'Adolfo L�pez Mateos (Jahuara Segundo)',N'Pueblo',N'El Fuerte',N'Sinaloa',N'',81342,25,81342,NULL,28,10,960,N'Urbano',NULL),
	 (81874,N'Estaci�n Charay (El Terco)',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,33,N'Rural',NULL),
	 (81874,N'Campo Seco (3 de Mayo)',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,15,10,2660,N'Rural',NULL),
	 (81876,N'Cerrillos N�mero Uno',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,36,N'Rural',NULL),
	 (81877,N'La Gu�sima',N'Rancho',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,48,10,13,N'Rural',NULL),
	 (81877,N'Basoteve',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,37,N'Rural',NULL),
	 (81877,N'Macoyahui',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,963,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81877,N'El Sufragio',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,15,10,2572,N'Rural',NULL),
	 (81878,N'16 de Septiembre',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81821,25,81821,NULL,15,10,1,N'Rural',NULL),
	 (81880,N'Huepaco',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,964,N'Rural',NULL),
	 (81887,N'La Genoveva',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,965,N'Rural',NULL),
	 (81888,N'Producto de la Revoluci�n',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,31,N'Rural',NULL),
	 (81888,N'Joaqu�n Amaro',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,32,N'Rural',NULL),
	 (81888,N'El Alhuate',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,41,N'Rural',NULL),
	 (81888,N'La Arrocera',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,49,N'Rural',NULL),
	 (81888,N'4 Milpas',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,966,N'Rural',NULL),
	 (81888,N'Kil�metro Diecinueve',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,15,10,2573,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81890,N'Campestre los Algodones',N'Fraccionamiento',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,21,10,15,N'Urbano',NULL),
	 (81890,N'La Ladrillera (La Cuera)',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,34,N'Urbano',NULL),
	 (81890,N'J�pare',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,44,N'Urbano',NULL),
	 (81890,N'T�roque Viejo',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,45,N'Urbano',NULL),
	 (81890,N'Dos de Abril',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,15,10,968,N'Rural',NULL),
	 (81890,N'Mochicahui',N'Pueblo',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,28,10,969,N'Rural',NULL),
	 (81891,N'Santa Blanca',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,28,N'Rural',NULL),
	 (81891,N'Campo Cuatro',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,39,N'Rural',NULL),
	 (81891,N'Antonio Rosales',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,15,10,970,N'Rural',NULL),
	 (81891,N'Los Tastes',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,971,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81892,N'Higueras de los Natoches',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,972,N'Rural',NULL),
	 (81892,N'Kil�metro 26',N'Pueblo',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,28,10,973,N'Rural',NULL),
	 (81893,N'Vialacahui',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,42,N'Rural',NULL),
	 (81893,N'Benito Ju�rez',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,974,N'Rural',NULL),
	 (81893,N'Constancia',N'Pueblo',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,28,10,975,N'Rural',NULL),
	 (81893,N'Pochotal',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,976,N'Rural',NULL),
	 (81893,N'El Carricito',N'Ejido',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,15,10,2298,N'Rural',NULL),
	 (81895,N'Las Higueras de los Natoches',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,14,N'Rural',NULL),
	 (81895,N'La L�nea',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,20,N'Rural',NULL),
	 (81895,N'El Carricito',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,50,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81895,N'El Ranchito 1',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,978,N'Rural',NULL),
	 (81895,N'El Ranchito 2',N'Rancher�a',N'El Fuerte',N'Sinaloa',N'',81201,25,81201,NULL,29,10,979,N'Rural',NULL),
	 (81900,N'Maripita',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,33,N'Rural',NULL),
	 (81900,N'La Cuevita',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,53,N'Rural',NULL),
	 (81900,N'Casas Nuevas',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,73,N'Rural',NULL),
	 (81900,N'El Gatal',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,77,N'Rural',NULL),
	 (81900,N'Cabrera de Bones y Olivos',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,79,N'Rural',NULL),
	 (81900,N'Baburia',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,981,N'Rural',NULL),
	 (81900,N'Cubiri de La Cuesta',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,982,N'Rural',NULL),
	 (81900,N'Cubiri de Portelas',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,983,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81900,N'Cubiri de la Capilla',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,15,17,2468,N'Rural',NULL),
	 (81900,N'Cubiri de la M�quina',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2469,N'Rural',NULL),
	 (81900,N'Cubiri de La Loma',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2662,N'Rural',NULL),
	 (81902,N'Cabrera de G�mez',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,25,N'Rural',NULL),
	 (81902,N'Cabrera de Inzunza',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,26,N'Rural',NULL),
	 (81902,N'El Caim�n (Margen Izquierdo)',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,59,N'Rural',NULL),
	 (81902,N'El Mezquitillo',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,63,N'Rural',NULL),
	 (81902,N'Licenciado Benito Ju�rez (Pared�n Blanco)',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,65,N'Rural',NULL),
	 (81902,N'Lombardo Toledano',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,71,N'Rural',NULL),
	 (81902,N'El Norte�o',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,72,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81902,N'El Caim�n (Margen Derecho)',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,986,N'Rural',NULL),
	 (81903,N'La Bocatoma',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,70,N'Rural',NULL),
	 (81903,N'Maquipo',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,15,17,987,N'Rural',NULL),
	 (81903,N'Opochi',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,988,N'Rural',NULL),
	 (81903,N'El Pueblito (El Realito)',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,15,17,2470,N'Rural',NULL),
	 (81903,N'Los Melones',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2471,N'Rural',NULL),
	 (81903,N'Las Playas',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2472,N'Rural',NULL),
	 (81904,N'Agua Fr�a',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,47,N'Rural',NULL),
	 (81904,N'Sanaria',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,51,N'Rural',NULL),
	 (81904,N'El Macapule',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,55,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81904,N'Cabrera de Limones',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2473,N'Rural',NULL),
	 (81904,N'La Loma de Lugo',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2587,N'Rural',NULL),
	 (81906,N'Matap�n del Llano',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,48,N'Rural',NULL),
	 (81906,N'Buenavista',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,989,N'Rural',NULL),
	 (81906,N'Maripa',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,990,N'Rural',NULL),
	 (81906,N'Agua Blanca',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2663,N'Rural',NULL),
	 (81907,N'G�era',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,31,N'Rural',NULL),
	 (81907,N'Las Lajas',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,32,N'Rural',NULL),
	 (81907,N'El Lim�n',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,49,N'Rural',NULL),
	 (81907,N'Porohui',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,991,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81910,N'Sinaloa de Leyva Centro',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,984,N'Urbano',13),
	 (81910,N'El Rastro',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,2265,N'Urbano',13),
	 (81912,N'Cruz de Piedra',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,82,N'Urbano',13),
	 (81912,N'El Kalzetin',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,1796,N'Urbano',13),
	 (81912,N'Tierra Blanca',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,1798,N'Urbano',13),
	 (81912,N'Choipa',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,1799,N'Urbano',13),
	 (81912,N'Lomas de San Felipe',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,1800,N'Urbano',13),
	 (81912,N'Guadalupana',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,2262,N'Urbano',13),
	 (81912,N'Los Doctores',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,2263,N'Urbano',13),
	 (81913,N'La Choya',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,1797,N'Urbano',13);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81915,N'La Torre',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,1795,N'Urbano',13),
	 (81916,N'Bellavista',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,1801,N'Urbano',13),
	 (81916,N'Ejidal',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,1802,N'Urbano',13),
	 (81916,N'San Jer�nimo',N'Colonia',N'Sinaloa',N'Sinaloa',N'Sinaloa de Leyva',81911,25,81911,NULL,9,17,2264,N'Urbano',13),
	 (81920,N'Agua Caliente de Cebada (La Churea)',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,44,N'Rural',NULL),
	 (81920,N'Agua Caliente de Cebada',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,993,N'Rural',NULL),
	 (81920,N'Santa Magdalena',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,2219,N'Rural',NULL),
	 (81924,N'Los Alisos de Olgu�n',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,22,N'Rural',NULL),
	 (81924,N'La Mesa del Frijol',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,78,N'Rural',NULL),
	 (81930,N'Sierrita de Los Germ�n',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,2223,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81933,N'Ocurague',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,2224,N'Rural',NULL),
	 (81935,N'San Jos� de Los Hornos',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2622,N'Rural',NULL),
	 (81940,N'El Platanito',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,994,N'Rural',NULL),
	 (81943,N'El Cochi',N'Rancho',N'Sinaloa',N'Sinaloa',N'',81982,25,81982,NULL,48,17,14,N'Rural',NULL),
	 (81943,N'Santa Luc�a',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81982,25,81982,NULL,28,17,15,N'Rural',NULL),
	 (81943,N'Las Bayas',N'Rancho',N'Sinaloa',N'Sinaloa',N'',81982,25,81982,NULL,48,17,18,N'Rural',NULL),
	 (81945,N'Mazocari',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,2221,N'Rural',NULL),
	 (81946,N'Portugu�s de Norzagaray',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2474,N'Rural',NULL),
	 (81946,N'Las Tatemas',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2475,N'Rural',NULL),
	 (81947,N'Ranchito de Llanes',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,36,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81947,N'La Ca�ada',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,60,N'Rural',NULL),
	 (81947,N'El Veranito',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,2220,N'Rural',NULL),
	 (81950,N'La Aceituna',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,20,N'Rural',NULL),
	 (81950,N'Pueblo Viejo',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,54,N'Rural',NULL),
	 (81950,N'El Zapote',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,15,17,995,N'Rural',NULL),
	 (81950,N'Buchinari',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,2238,N'Rural',NULL),
	 (81950,N'Sarabia',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2476,N'Rural',NULL),
	 (81950,N'Los Mezquites',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2477,N'Rural',NULL),
	 (81960,N'Genaro Estrada',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,2291,N'Rural',NULL),
	 (81960,N'Santiago de Ocoroni',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2478,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81960,N'La Playita de Casillas',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,15,17,2479,N'Rural',NULL),
	 (81963,N'La Cebolla',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,28,N'Rural',NULL),
	 (81963,N'El Gatal de Ocoroni',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,15,17,2480,N'Rural',NULL),
	 (81963,N'San Jos� de Alvarado (San Jos� Nuevo)',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,15,17,2481,N'Rural',NULL),
	 (81964,N'San Miguel de los Orrantia',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2482,N'Rural',NULL),
	 (81965,N'Gallo Nuevo',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,29,N'Rural',NULL),
	 (81965,N'Los Cerquitos (La Pila Dos)',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,75,N'Rural',NULL),
	 (81967,N'El Alamito',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,21,N'Rural',NULL),
	 (81967,N'El Altillo',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,23,N'Rural',NULL),
	 (81967,N'Casas Nuevas',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,27,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81967,N'El Garbanzo',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,30,N'Rural',NULL),
	 (81967,N'La Playa',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,34,N'Rural',NULL),
	 (81967,N'El Potrero de Soto',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,35,N'Rural',NULL),
	 (81967,N'Santa Ana',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,39,N'Rural',NULL),
	 (81967,N'Tepantita de Ocoroni',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,40,N'Rural',NULL),
	 (81967,N'La Mojonera',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,64,N'Rural',NULL),
	 (81967,N'Los Tastes',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,74,N'Rural',NULL),
	 (81970,N'Agua Blanca',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,76,N'Rural',NULL),
	 (81970,N'Palmar de Sep�lveda',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,997,N'Rural',NULL),
	 (81970,N'Las Huacapas',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,3082,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81970,N'El Ranchito de los L�pez',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,3083,N'Rural',NULL),
	 (81970,N'Mapiri',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,3084,N'Rural',NULL),
	 (81970,N'San Jos� del �lamo',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,3093,N'Rural',NULL),
	 (81971,N'El Aguajito',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,81,N'Rural',NULL),
	 (81971,N'Los Troncones',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,998,N'Rural',NULL),
	 (81972,N'La Huerta',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,61,N'Rural',NULL),
	 (81973,N'Baromena',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,24,N'Rural',NULL),
	 (81973,N'Potrero de los F�lix',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,52,N'Rural',NULL),
	 (81973,N'Bacubirito',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,999,N'Rural',NULL),
	 (81973,N'Chacoapana',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,2217,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81973,N'Bacurato',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,2709,N'Rural',NULL),
	 (81975,N'El Corral de Piedra',N'Rancho',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,48,17,11,N'Rural',NULL),
	 (81975,N'Los Quintero',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,15,17,2483,N'Rural',NULL),
	 (81976,N'San Jos� de Gracia',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,992,N'Rural',NULL),
	 (81976,N'Llanos de Peraza',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2623,N'Rural',NULL),
	 (81977,N'Hacienda de los Ceballos',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,6,N'Rural',NULL),
	 (81977,N'Ventura de los Boj�rquez',N'Rancho',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,48,17,7,N'Rural',NULL),
	 (81977,N'El Rinc�n',N'Rancho',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,48,17,8,N'Rural',NULL),
	 (81977,N'El Pe��n',N'Rancho',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,48,17,9,N'Rural',NULL),
	 (81977,N'Las Tinas',N'Rancho',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,48,17,12,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81977,N'La Mesa',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,62,N'Rural',NULL),
	 (81977,N'El Saucito',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,68,N'Rural',NULL),
	 (81977,N'San Jos� de las Delicias',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,2218,N'Rural',NULL),
	 (81977,N'Coronado',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2624,N'Rural',NULL),
	 (81977,N'El Terrero de Dur�n',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,3085,N'Rural',NULL),
	 (81977,N'Carrizalejo',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,3086,N'Rural',NULL),
	 (81980,N'Naranjo Centro',N'Colonia',N'Sinaloa',N'Sinaloa',N'Estaci�n Naranjo',81982,25,81982,NULL,9,17,1001,N'Rural',19),
	 (81980,N'Alfredo V Bonfil',N'Colonia',N'Sinaloa',N'Sinaloa',N'Estaci�n Naranjo',81982,25,81982,NULL,9,17,1736,N'Rural',19),
	 (81983,N'Nuevo San Ferm�n',N'Colonia',N'Sinaloa',N'Sinaloa',N'Estaci�n Naranjo',81982,25,81982,NULL,9,17,3,N'Urbano',19),
	 (81983,N'Las Viejas',N'Colonia',N'Sinaloa',N'Sinaloa',N'Estaci�n Naranjo',81982,25,81982,NULL,9,17,1844,N'Rural',19);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81985,N'Gabriel Leyva Vel�zquez',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,28,17,1,N'Urbano',NULL),
	 (81985,N'San Pablo Mochobampo (San Ignacio)',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,29,17,37,N'Rural',NULL),
	 (81985,N'Francisco Villa',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,29,17,45,N'Rural',NULL),
	 (81985,N'Jos� Mar�a Morelos y Pav�n',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,29,17,50,N'Rural',NULL),
	 (81985,N'Francisco J. M�gica',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,15,17,56,N'Rural',NULL),
	 (81985,N'Ruiz Cortines 3',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,15,17,1004,N'Rural',NULL),
	 (81985,N'Concentraci�n 5 de Febrero',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,15,17,2484,N'Rural',NULL),
	 (81985,N'Tobobampo',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,15,17,2485,N'Rural',NULL),
	 (81985,N'Santa Teresita',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,15,17,2486,N'Rural',NULL),
	 (81985,N'Ruiz Cortinez 1',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,15,17,2487,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81985,N'La Guamuchilera',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,15,17,2579,N'Rural',NULL),
	 (81985,N'Ceferino Paredes',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,15,17,2580,N'Rural',NULL),
	 (81985,N'Alfonso G Calder�n Velarde',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81125,25,81125,NULL,15,17,2664,N'Rural',NULL),
	 (81986,N'Campo Torre�n',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,41,N'Rural',NULL),
	 (81986,N'Tres Mar�as (Las Vinoramas)',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,42,N'Rural',NULL),
	 (81986,N'Tres Reyes',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,43,N'Rural',NULL),
	 (81986,N'El Toruno Dos',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,46,N'Rural',NULL),
	 (81986,N'Campo Seis',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,58,N'Rural',NULL),
	 (81986,N'La Pitahaya',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,66,N'Rural',NULL),
	 (81986,N'Melchor Ocampo',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,67,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81986,N'El Campito (campo Zamora)',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,2222,N'Rural',NULL),
	 (81986,N'Playa Segunda',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,15,17,2488,N'Rural',NULL),
	 (81986,N'El Palotal',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2489,N'Rural',NULL),
	 (81986,N'Naranjo Segundo',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,15,17,2490,N'Rural',NULL),
	 (81988,N'La Presita',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81126,25,81126,NULL,15,17,1005,N'Rural',NULL),
	 (81988,N'Batamote',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81126,25,81126,NULL,15,17,2491,N'Rural',NULL),
	 (81988,N'San Sebast�an L�zaro C�rdenas',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81126,25,81126,NULL,15,17,2492,N'Rural',NULL),
	 (81989,N'Capomas',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81145,25,81145,NULL,29,17,1006,N'Rural',NULL),
	 (81990,N'La Tranquilidad',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,16,N'Rural',NULL),
	 (81990,N'Tabalopa',N'Rancho',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,48,17,17,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81990,N'San Joaqu�n (San Joaqu�n Viejo)',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,57,N'Rural',NULL),
	 (81990,N'Tierra Blanca',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,69,N'Rural',NULL),
	 (81990,N'Agua Escondida',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,1007,N'Rural',NULL),
	 (81990,N'San Joaqu�n',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,1008,N'Rural',NULL),
	 (81990,N'El Mezquite',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,2493,N'Rural',NULL),
	 (81990,N'Seis de Enero',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,3047,N'Rural',NULL),
	 (81991,N'Llano Grande',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,1009,N'Rural',NULL),
	 (81991,N'Nacaveba',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,1010,N'Rural',NULL),
	 (81993,N'El Noroto',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,2,N'Rural',NULL),
	 (81993,N'El Camich�n',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,5,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (81993,N'Palo Hediondo',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,10,N'Rural',NULL),
	 (81995,N'Tezcalama (Tescalama de Arriba)',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,13,N'Rural',NULL),
	 (81996,N'San Pedro',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,4,N'Rural',NULL),
	 (81996,N'San Miguel de San Joaqu�n (San Miguel)',N'Rancher�a',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,29,17,38,N'Rural',NULL),
	 (81997,N'Alfredo V. Bonfil (Siete Ejidos)',N'Pueblo',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,28,17,19,N'Rural',NULL),
	 (81997,N'El Coyote',N'Ejido',N'Sinaloa',N'Sinaloa',N'',81911,25,81911,NULL,15,17,2665,N'Rural',NULL),
	 (82000,N'Balcones de Loma Linda',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1011,N'Urbano',5),
	 (82000,N'Los Pinos',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1012,N'Urbano',5),
	 (82000,N'Mazatl�n Centro',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1013,N'Urbano',5),
	 (82000,N'Loma Linda',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1016,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82010,N'Campo Bello',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1019,N'Urbano',5),
	 (82010,N'Estero',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1020,N'Urbano',5),
	 (82010,N'Independencia',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1021,N'Urbano',5),
	 (82010,N'Juan Carrasco',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1022,N'Urbano',5),
	 (82010,N'Libertad',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1023,N'Urbano',5),
	 (82010,N'Lomas del Mar',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1024,N'Urbano',5),
	 (82010,N'Palos Prietos',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1025,N'Urbano',5),
	 (82010,N'Palmeiras Club Residencial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2786,N'Urbano',5),
	 (82013,N'Ferrocarrilera',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1027,N'Urbano',5),
	 (82014,N'San Angel',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1028,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82015,N'Tr�pico de C�ncer',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1029,N'Urbano',5),
	 (82016,N'Brisas del Mar',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1030,N'Urbano',5),
	 (82017,N'Telleria',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1031,N'Urbano',5),
	 (82018,N'Insurgentes',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1032,N'Urbano',5),
	 (82019,N'Tierra y Libertad',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1033,N'Urbano',5),
	 (82020,N'12 de Mayo',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1034,N'Urbano',5),
	 (82020,N'Klein',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1119,N'Urbano',5),
	 (82020,N'Bah�as',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1289,N'Urbano',5),
	 (82020,N'Nueva Creaci�n',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2975,N'Urbano',5),
	 (82028,N'Casas Econ�micas',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1035,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82030,N'Montuosa',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1036,N'Urbano',5),
	 (82030,N'Reforma',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1037,N'Urbano',5),
	 (82035,N'Sanchez Taboada',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1038,N'Urbano',5),
	 (82037,N'Francisco Sol�s',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1040,N'Urbano',5),
	 (82038,N'Obrera',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1041,N'Urbano',5),
	 (82040,N'Gabriel Leyva',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1042,N'Urbano',5),
	 (82040,N'L�zaro C�rdenas',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1043,N'Urbano',5),
	 (82040,N'Playas del Sur',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1044,N'Urbano',5),
	 (82040,N'Cerro del Vig�a',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2902,N'Urbano',5),
	 (82043,N'Jos� de Nazaret',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,14,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82043,N'Isla de la Piedra',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1301,N'Urbano',5),
	 (82043,N'Vicente Guerrero',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2782,N'Urbano',5),
	 (82043,N'Ecol�gica',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2783,N'Urbano',5),
	 (82043,N'Anabella de Gavica',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2784,N'Urbano',5),
	 (82047,N'Octava Zona Naval (Puerto Mazatl�n)',N'Puerto',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,40,12,3181,N'Urbano',5),
	 (82050,N'Alfredo V. Bonfil',N'Zona industrial',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,37,12,1047,N'Urbano',5),
	 (82050,N'Las Malvinas',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2785,N'Urbano',5),
	 (82059,N'Casa Redonda',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1050,N'Urbano',5),
	 (82060,N'Francisco I Madero',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1051,N'Urbano',5),
	 (82060,N'Jos� Mar�a Pino Su�rez',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2011,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82070,N'Ejido Rinc�n de Ur�as',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1053,N'Urbano',5),
	 (82080,N'Gral. Rafael Buelna',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1055,N'Urbano',5),
	 (82080,N'5ta Chapalita',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1963,N'Urbano',5),
	 (82089,N'Central Termo�lectrica Jos� Aceves Pozos',N'Equipamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,17,12,129,N'Urbano',5),
	 (82089,N'La Sirena',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1057,N'Urbano',5),
	 (82089,N'Miramar',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2801,N'Urbano',5),
	 (82089,N'23 de Noviembre',N'Unidad habitacional',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,31,12,2805,N'Urbano',5),
	 (82090,N'Las Flores',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,115,N'Urbano',5),
	 (82090,N'CANACO',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,149,N'Urbano',5),
	 (82090,N'Diaz Ordaz',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1058,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82090,N'Ampliaci�n Felipe �ngeles',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1936,N'Urbano',5),
	 (82090,N'Felipe �ngeles',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1937,N'Urbano',5),
	 (82090,N'Hacienda de Urias',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2122,N'Urbano',5),
	 (82090,N'Santa Teresa',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2266,N'Urbano',5),
	 (82090,N'2a Ampliaci�n Felipe �ngeles',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2316,N'Urbano',5),
	 (82090,N'Mar�a del Mar',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2796,N'Urbano',5),
	 (82090,N'Urbivilla del Real',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2798,N'Urbano',5),
	 (82090,N'Valle de Urias',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2803,N'Urbano',5),
	 (82090,N'2da. Ampliaci�n Valle de Urias',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2917,N'Urbano',5),
	 (82099,N'Villa de Guadalupe',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,127,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82099,N'Ur�as',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1059,N'Urbano',5),
	 (82099,N'Ladrillera',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2799,N'Urbano',5),
	 (82099,N'Mar�a Elena',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2800,N'Urbano',5),
	 (82100,N'S�balo Country Club',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1060,N'Urbano',5),
	 (82100,N'Las Varas',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2919,N'Urbano',5),
	 (82102,N'Marina El Cid',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2012,N'Urbano',5),
	 (82103,N'El Secreto',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2681,N'Urbano',5),
	 (82103,N'Palmas del Sol',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2684,N'Urbano',5),
	 (82103,N'Punta Diamante',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2690,N'Urbano',5),
	 (82103,N'Marina Real',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2691,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82103,N'Marina Mazatl�n',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2760,N'Urbano',5),
	 (82103,N'Isla Mazatl�n',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2762,N'Urbano',5),
	 (82103,N'El Encanto',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2763,N'Urbano',5),
	 (82103,N'Puerta al Mar',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2903,N'Urbano',5),
	 (82103,N'Ra�ces',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,3052,N'Urbano',5),
	 (82110,N'El Cid',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1061,N'Urbano',5),
	 (82110,N'El Dorado',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1062,N'Urbano',5),
	 (82110,N'Las Gaviotas',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1063,N'Urbano',5),
	 (82110,N'Ex Laguna Las Gaviotas',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1064,N'Urbano',5),
	 (82110,N'Lomas de Mazatl�n',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1065,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82110,N'Rinc�n Colonial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1067,N'Urbano',5),
	 (82110,N'Zona Dorada',N'Zona comercial',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,33,12,1331,N'Urbano',5),
	 (82110,N'Puerta Dorada',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2904,N'Urbano',5),
	 (82110,N'Quinta Gaviotas',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2920,N'Urbano',5),
	 (82112,N'Azul Pacific',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,11,N'Urbano',5),
	 (82112,N'Almar',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,111,N'Urbano',5),
	 (82112,N'Marina del Rey',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,113,N'Urbano',5),
	 (82112,N'Azul Marino',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,117,N'Urbano',5),
	 (82112,N'Palmilla',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,120,N'Urbano',5),
	 (82112,N'Altabrisa Residencial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,122,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82112,N'Almarena Residencial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,125,N'Urbano',5),
	 (82112,N'Peninsula',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,133,N'Urbano',5),
	 (82112,N'Costa Bonita',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,134,N'Urbano',5),
	 (82112,N'El Cielo Parque Residencial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,138,N'Urbano',5),
	 (82112,N'Soles',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,140,N'Urbano',5),
	 (82112,N'Cerritos Resort',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1291,N'Urbano',5),
	 (82112,N'Quintas del Mar',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1317,N'Urbano',5),
	 (82112,N'Real del Mar',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1318,N'Urbano',5),
	 (82112,N'Royal Country',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1321,N'Urbano',5),
	 (82112,N'Villas de Rueda',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1328,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82112,N'Villa del Mar',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2015,N'Urbano',5),
	 (82112,N'Villa Tranquila',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2017,N'Urbano',5),
	 (82112,N'Playa Linda',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2059,N'Urbano',5),
	 (82112,N'Las Palmas',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2620,N'Urbano',5),
	 (82112,N'Villa Marina',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2621,N'Urbano',5),
	 (82112,N'Marina Garden',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2753,N'Urbano',5),
	 (82112,N'El Palmar',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2759,N'Urbano',5),
	 (82112,N'Marina Kelly',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2905,N'Urbano',5),
	 (82113,N'Club Real',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1967,N'Urbano',5),
	 (82113,N'Mediterr�neo Club Residencial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2761,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82120,N'El Toreo',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1069,N'Urbano',5),
	 (82120,N'Periodista',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1071,N'Urbano',5),
	 (82120,N'Pueblo Nuevo',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1072,N'Urbano',5),
	 (82120,N'Sanchez Celis',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1073,N'Urbano',5),
	 (82120,N'El Toro',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1297,N'Urbano',5),
	 (82120,N'Hacienda del Mar',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1299,N'Urbano',5),
	 (82120,N'Jardines del Toreo',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1304,N'Urbano',5),
	 (82120,N'Plaza Reforma',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1314,N'Urbano',5),
	 (82120,N'Zafiro',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1330,N'Urbano',5),
	 (82120,N'Residencial Rinconada',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2766,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82120,N'Azalea',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2972,N'Urbano',5),
	 (82123,N'Jardines de la Alameda',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,114,N'Urbano',5),
	 (82123,N'Olimpo INFONAVIT',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1070,N'Urbano',5),
	 (82123,N'Alameda',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1074,N'Urbano',5),
	 (82123,N'El Para�so',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1075,N'Urbano',5),
	 (82124,N'El Palmito',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,15,N'Urbano',5),
	 (82124,N'Bluu Habitat Lagoons',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,116,N'Urbano',5),
	 (82124,N'Marsella',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,118,N'Urbano',5),
	 (82124,N'Coto Platino',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,130,N'Urbano',5),
	 (82124,N'Colinas del Valle',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,131,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82124,N'Sonterra Residencial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,141,N'Urbano',5),
	 (82124,N'Sonterra Residencial II',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,142,N'Urbano',5),
	 (82124,N'Pac�fico Hills',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,143,N'Urbano',5),
	 (82124,N'Platino Norte',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,144,N'Urbano',5),
	 (82124,N'Atl�ntico Coto Residencial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,147,N'Urbano',5),
	 (82124,N'Portovera Residencial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,148,N'Urbano',5),
	 (82124,N'Puesta del Sol',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1316,N'Urbano',5),
	 (82124,N'Paseo de Las Torres',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2013,N'Urbano',5),
	 (82124,N'Prados del Sol',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2014,N'Urbano',5),
	 (82124,N'Rinc�n de las Palmas',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2110,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82124,N'Paseo Alameda',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2113,N'Urbano',5),
	 (82124,N'Terranova',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2114,N'Urbano',5),
	 (82124,N'Chulavista',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2171,N'Urbano',5),
	 (82124,N'La Joya',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2683,N'Urbano',5),
	 (82124,N'Paseo Los Olivos',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2685,N'Urbano',5),
	 (82124,N'Real del Valle',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2687,N'Urbano',5),
	 (82124,N'Real Pac�fico',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2765,N'Urbano',5),
	 (82124,N'Paseo Alameda Dos',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2767,N'Urbano',5),
	 (82124,N'San Joaqu�n de las Habas',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2965,N'Urbano',5),
	 (82124,N'Terranova Plus',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2966,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82125,N'Rinc�n de Las Plazas',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1320,N'Urbano',5),
	 (82125,N'Quinta Real',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2769,N'Urbano',5),
	 (82126,N'Hacienda Las Cruces',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1076,N'Urbano',5),
	 (82127,N'Francisco Villa',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1077,N'Urbano',5),
	 (82127,N'Dorados de Villa',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1296,N'Urbano',5),
	 (82127,N'Libertad de Expresi�n',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1307,N'Urbano',5),
	 (82127,N'Ejidal Francisco Villa',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2764,N'Urbano',5),
	 (82128,N'INFONAVIT Playas',N'Unidad habitacional',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,31,12,1078,N'Urbano',5),
	 (82128,N'San Carlos',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1323,N'Urbano',5),
	 (82128,N'Los Mangos I',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2108,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82128,N'Los Mangos II',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2736,N'Urbano',5),
	 (82128,N'Hacienda Los Mangos',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2752,N'Urbano',5),
	 (82128,N'Privanza',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2768,N'Urbano',5),
	 (82129,N'Hacienda del Seminario',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1,N'Urbano',5),
	 (82129,N'El Venadillo',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,28,12,1079,N'Urbano',5),
	 (82129,N'Monte Calvario',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2773,N'Urbano',5),
	 (82129,N'Huerta Grande',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2906,N'Urbano',5),
	 (82130,N'Mar de Cortes',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1951,N'Urbano',5),
	 (82132,N'Portomolino',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,8,N'Urbano',5),
	 (82132,N'Roca Condominios',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,13,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82132,N'Arboledas I',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1285,N'Urbano',5),
	 (82132,N'Arboledas II',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1286,N'Urbano',5),
	 (82132,N'Del Valle',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1295,N'Urbano',5),
	 (82132,N'Francisco Alarc�n Infonavit',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1298,N'Urbano',5),
	 (82132,N'Valle Dorado',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1327,N'Urbano',5),
	 (82132,N'Los Caracoles',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1929,N'Urbano',5),
	 (82132,N'Delfines',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1932,N'Urbano',5),
	 (82132,N'Torremolinos',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1933,N'Urbano',5),
	 (82132,N'Tortugas I',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1964,N'Urbano',5),
	 (82132,N'Jardines del Bosque',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2682,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82132,N'Valle Dorado II',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2908,N'Urbano',5),
	 (82132,N'Ampliaci�n Francisco Alarc�n (Venadillo II)',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2921,N'Urbano',5),
	 (82133,N'Las Misiones',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1930,N'Urbano',5),
	 (82133,N'Las Brisas',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1931,N'Urbano',5),
	 (82133,N'Brisas del Valle II',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2679,N'Urbano',5),
	 (82133,N'Misiones 2000',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2907,N'Urbano',5),
	 (82134,N'Monte Verde',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,9,N'Urbano',5),
	 (82134,N'Manuel de la Vega',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,128,N'Urbano',5),
	 (82134,N'Arieta',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,136,N'Urbano',5),
	 (82134,N'Puesta Norte',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,137,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82134,N'Bah�a',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,139,N'Urbano',5),
	 (82134,N'Arboledas III',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1287,N'Urbano',5),
	 (82134,N'Hogar Pescador',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1300,N'Urbano',5),
	 (82134,N'Jes�s Osuna',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1305,N'Urbano',5),
	 (82134,N'Colosio Si',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1309,N'Urbano',5),
	 (82134,N'Renato Vega',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1319,N'Urbano',5),
	 (82134,N'Salinas de Gortari',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1322,N'Urbano',5),
	 (82134,N'Valle del Ejido',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1326,N'Urbano',5),
	 (82134,N'Nuevo Milenio',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2106,N'Urbano',5),
	 (82134,N'Santa Rosa',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2109,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82134,N'San Francisco',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2116,N'Urbano',5),
	 (82134,N'Villa Carey',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2678,N'Urbano',5),
	 (82134,N'El Conchi II',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2680,N'Urbano',5),
	 (82134,N'Prado Bonito',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2686,N'Urbano',5),
	 (82134,N'Felicidad',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2774,N'Urbano',5),
	 (82134,N'San Marcos',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2775,N'Urbano',5),
	 (82134,N'Jardines Residencial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2776,N'Urbano',5),
	 (82134,N'San Antonio',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2777,N'Urbano',5),
	 (82134,N'Puerta del Sol',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2778,N'Urbano',5),
	 (82134,N'Sinaloa',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2779,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82134,N'Lucio Valverde',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2780,N'Urbano',5),
	 (82134,N'Jardines del Valle',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2909,N'Urbano',5),
	 (82134,N'Los Robles',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2910,N'Urbano',5),
	 (82134,N'Romanita de La Pe�a',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,2911,N'Urbano',5),
	 (82134,N'La Riviera',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,3072,N'Urbano',5),
	 (82134,N'Jardines de la Riviera',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,3073,N'Urbano',5),
	 (82134,N'Mundialista',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,3118,N'Urbano',5),
	 (82136,N'Montebello',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,112,N'Urbano',5),
	 (82136,N'Petr�leos',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1082,N'Urbano',5),
	 (82136,N'Jaripillo',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1948,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82136,N'Santa Laura',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1949,N'Urbano',5),
	 (82136,N'La Campi�a',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1952,N'Urbano',5),
	 (82136,N'Bosques del Arroyo',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1953,N'Urbano',5),
	 (82136,N'Colinas del Real',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2009,N'Urbano',5),
	 (82136,N'Mar�a Antonieta',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2126,N'Urbano',5),
	 (82136,N'Valle Bonito',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2132,N'Urbano',5),
	 (82136,N'Villa Tutuli',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2133,N'Urbano',5),
	 (82136,N'Buenos Aires',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2787,N'Urbano',5),
	 (82136,N'Torremolinos Costa Azul',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2788,N'Urbano',5),
	 (82136,N'Villa Tutuli II',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2968,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82137,N'Huertos Familiares',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1083,N'Urbano',5),
	 (82138,N'FOVISSSTE Playa Azul',N'Unidad habitacional',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,31,12,1313,N'Urbano',5),
	 (82139,N'La Cantera',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,123,N'Urbano',5),
	 (82139,N'El Conchi Infonavit',N'Unidad habitacional',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,31,12,1085,N'Urbano',5),
	 (82139,N'Vista del Mar',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1954,N'Urbano',5),
	 (82139,N'Villa de las Flores',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1957,N'Urbano',5),
	 (82139,N'Jes�s Kumate',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1958,N'Urbano',5),
	 (82139,N'Villa Florida',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1959,N'Urbano',5),
	 (82139,N'San Joaqu�n',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1960,N'Urbano',5),
	 (82139,N'Villa Verde',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1961,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82139,N'Lomas de San Jorge',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1962,N'Urbano',5),
	 (82139,N'Bugambilias',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2008,N'Urbano',5),
	 (82139,N'Arboledas INVIES',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2117,N'Urbano',5),
	 (82139,N'Costa Dorada',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2119,N'Urbano',5),
	 (82139,N'Francisco Labastida Ochoa',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2121,N'Urbano',5),
	 (82139,N'Los Laureles',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2124,N'Urbano',5),
	 (82139,N'Los Conchis Secci�n Arrecifes',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2125,N'Urbano',5),
	 (82139,N'El Conchi',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2127,N'Urbano',5),
	 (82139,N'Santa Sof�a',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2129,N'Urbano',5),
	 (82139,N'Las Ma�anitas',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2172,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82139,N'Ampliaci�n Villa Verde',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2261,N'Urbano',5),
	 (82139,N'Nuevo Cajeme',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2526,N'Urbano',5),
	 (82139,N'Pradera Dorada',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2619,N'Urbano',5),
	 (82139,N'Viva Progreso',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2789,N'Urbano',5),
	 (82139,N'San Antonio',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,3136,N'Rural',NULL),
	 (82140,N'Estadio',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1086,N'Urbano',5),
	 (82140,N'Lomas del Valle',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1087,N'Urbano',5),
	 (82140,N'L�pez Mateos',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1088,N'Urbano',5),
	 (82143,N'Casa Blanca',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1089,N'Urbano',5),
	 (82144,N'Girasoles',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1091,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82146,N'Sembradores de La Amistad',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1093,N'Urbano',5),
	 (82146,N'Antiguo Aeropuerto',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1965,N'Urbano',5),
	 (82147,N'Mar�a Fernanda',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1094,N'Urbano',5),
	 (82148,N'Playas del Sol',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1095,N'Urbano',5),
	 (82149,N'Flamingos',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1096,N'Urbano',5),
	 (82150,N'Ol�mpica',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1098,N'Urbano',5),
	 (82150,N'20 de Noviembre',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1099,N'Urbano',5),
	 (82150,N'Villa Galaxia',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1100,N'Urbano',5),
	 (82150,N'Villa Sat�lite',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1941,N'Urbano',5),
	 (82150,N'Villa de Jacaro',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2043,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82150,N'Los �ngeles (Santa Fe)',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2044,N'Urbano',5),
	 (82150,N'El Castillo',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2806,N'Urbano',5),
	 (82153,N'Antonio Toledo Corro',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1101,N'Urbano',5),
	 (82153,N'Jabalines Infonavit',N'Unidad habitacional',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,31,12,1102,N'Urbano',5),
	 (82154,N'Portal de los Olivos',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,124,N'Urbano',5),
	 (82154,N'FOVISSSTE Jabal�es',N'Unidad habitacional',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,31,12,1303,N'Urbano',5),
	 (82154,N'Los Venados',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1308,N'Urbano',5),
	 (82154,N'Los Portales',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1935,N'Urbano',5),
	 (82154,N'Los Olivos',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2107,N'Urbano',5),
	 (82154,N'Issstesin',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2115,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82154,N'Lomas del Bosque',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2758,N'Urbano',5),
	 (82154,N'Las Torres',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2770,N'Urbano',5),
	 (82154,N'Corredor de Abasto',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2771,N'Urbano',5),
	 (82154,N'Privada Santa Rita',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2772,N'Urbano',5),
	 (82154,N'San Nicol�s',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2914,N'Urbano',5),
	 (82155,N'Ruben Jaramillo',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1103,N'Urbano',5),
	 (82156,N'Villas del Estero',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1104,N'Urbano',5),
	 (82157,N'La Cima Residencial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,10,N'Urbano',5),
	 (82157,N'Jacarandas',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1105,N'Urbano',5),
	 (82157,N'Bah�a de Mazatl�n FOVISSSTE',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1288,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82157,N'Costa Brava',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1293,N'Urbano',5),
	 (82157,N'Isla Residencial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1302,N'Urbano',5),
	 (82157,N'Plazas San Ignacio',N'Zona comercial',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,33,12,1315,N'Urbano',5),
	 (82157,N'Santa Virginia',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1324,N'Urbano',5),
	 (82157,N'Gilberto Lopez',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1934,N'Urbano',5),
	 (82157,N'Villa Bonita',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2915,N'Urbano',5),
	 (82157,N'Residencial Flamingos',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,2967,N'Urbano',5),
	 (82158,N'Federico Velarde',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1106,N'Urbano',5),
	 (82159,N'Esperanza Fovissste',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1107,N'Urbano',5),
	 (82159,N'Universidad 94',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1955,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82159,N'Los Sauces',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2249,N'Urbano',5),
	 (82160,N'Luis Echeverr�a Alvarez',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1108,N'Urbano',5),
	 (82163,N'Bur�crata',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1109,N'Urbano',5),
	 (82163,N'Fuentes del Valle',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1969,N'Urbano',5),
	 (82163,N'Las Olas',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1970,N'Urbano',5),
	 (82164,N'Salvador Allende',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1110,N'Urbano',5),
	 (82164,N'Villa Residencial del Rey',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2042,N'Urbano',5),
	 (82164,N'Esmeralda',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2120,N'Urbano',5),
	 (82165,N'Jabal�es',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,21,12,1111,N'Urbano',5),
	 (82170,N'Constituci�n',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1113,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82170,N'Morelos',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1114,N'Urbano',5),
	 (82170,N'Ramon F Iturbide',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1115,N'Urbano',5),
	 (82180,N'Benito Ju�rez',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1116,N'Urbano',5),
	 (82180,N'Esperanza',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1117,N'Urbano',5),
	 (82180,N'Jes�s Garcia',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1118,N'Urbano',5),
	 (82180,N'Lomas de Ju�rez',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1120,N'Urbano',5),
	 (82180,N'Santa Elena',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1121,N'Urbano',5),
	 (82180,N'Venustiano Carranza',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1122,N'Urbano',5),
	 (82183,N'Obrera Industrial',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1124,N'Urbano',5),
	 (82185,N'Loma Atravesada',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82001,25,82001,NULL,9,12,1125,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82186,N'Azteca',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1126,N'Urbano',5),
	 (82186,N'Santa Cecilia',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1946,N'Urbano',5),
	 (82187,N'San Rafael',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1128,N'Urbano',5),
	 (82187,N'Del Bosque',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1947,N'Urbano',5),
	 (82188,N'An�huac',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1129,N'Urbano',5),
	 (82190,N'Lomas de las Torres',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,16,N'Urbano',5),
	 (82190,N'Emiliano Zapata',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1131,N'Urbano',5),
	 (82190,N'Flores Mag�n',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1132,N'Urbano',5),
	 (82190,N'Ni�os H�roes',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1133,N'Urbano',5),
	 (82190,N'Mirasol',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1134,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82190,N'Petrolero',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1135,N'Urbano',5),
	 (82190,N'Mazatlan I',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1939,N'Urbano',5),
	 (82190,N'Melina',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1945,N'Urbano',5),
	 (82190,N'El Campestre',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2794,N'Urbano',5),
	 (82190,N'Ampliaci�n Esperanza',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2901,N'Urbano',5),
	 (82195,N'Palmares',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,126,N'Urbano',5),
	 (82195,N'Club Campestre Mazatl�n',N'Equipamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,17,12,132,N'Urbano',5),
	 (82195,N'Mazatl�n III',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1938,N'Urbano',5),
	 (82195,N'Mazatlan II',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1940,N'Urbano',5),
	 (82195,N'Lomas Del Porvenir',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2123,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82195,N'Hacienda Victoria',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2189,N'Urbano',5),
	 (82195,N'Lomas de Cristo Rey',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2730,N'Urbano',5),
	 (82195,N'Universo',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2792,N'Urbano',5),
	 (82195,N'Rinc�n de Mazatl�n',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2793,N'Urbano',5),
	 (82195,N'El Pescador',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2969,N'Urbano',5),
	 (82195,N'La Alborada',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,3141,N'Urbano',5),
	 (82197,N'Primavera',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1136,N'Urbano',5),
	 (82198,N'Los Acantos',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,146,N'Urbano',5),
	 (82198,N'Miguel Hidalgo',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1017,N'Urbano',5),
	 (82198,N'Lomas del �bano',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1137,N'Urbano',5);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82198,N'Villas Del Sol',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1942,N'Urbano',5),
	 (82198,N'La Foresta',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,1943,N'Urbano',5),
	 (82198,N'Loma Bonita',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1944,N'Urbano',5),
	 (82198,N'Ex Hacienda del Conchi',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2010,N'Urbano',5),
	 (82198,N'Rinconada Del Valle',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2128,N'Urbano',5),
	 (82198,N'Simon Jimenez C�rdenas',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2131,N'Urbano',5),
	 (82198,N'San Fernando',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2251,N'Urbano',5),
	 (82198,N'Do�a Chonita',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2501,N'Urbano',5),
	 (82198,N'Valle del Sol',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2525,N'Urbano',5),
	 (82198,N'Ejidal',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2693,N'Urbano',5);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82198,N'Hacienda del Valle',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2720,N'Urbano',5),
	 (82198,N'Ampliaci�n Lomas del �bano',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,2791,N'Urbano',5),
	 (82199,N'Higueras Residencial',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,119,N'Urbano',5),
	 (82199,N'La Cantera II',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,145,N'Urbano',5),
	 (82199,N'Genaro Estrada Calder�n',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,9,12,1138,N'Urbano',5),
	 (82199,N'Los Magueyes',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2250,N'Urbano',5),
	 (82199,N'Los Tabachines',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Mazatl�n',82181,25,82181,NULL,21,12,2790,N'Urbano',5),
	 (82200,N'La Tuna',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,17,N'Rural',NULL),
	 (82200,N'Las Ma�anitas',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,18,N'Rural',NULL),
	 (82200,N'San Francisquito',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,28,12,1139,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82200,N'Lomas de Monterrey',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,28,12,2528,N'Rural',NULL),
	 (82203,N'El Vainillo',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2529,N'Rural',NULL),
	 (82204,N'Parque Industrial Mazatl�n',N'Zona industrial',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,37,12,4,N'Rural',NULL),
	 (82204,N'El Pozole',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,19,N'Rural',NULL),
	 (82204,N'Los Pozos',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,20,N'Rural',NULL),
	 (82204,N'La Urraca Nueva',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,2878,N'Rural',NULL),
	 (82205,N'La Amapa',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,21,N'Rural',NULL),
	 (82205,N'La Limonera',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,22,N'Rural',NULL),
	 (82205,N'Estaci�n Presidio',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,23,N'Rural',NULL),
	 (82205,N'El Aguaje de Costilla',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,24,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82205,N'La Amapa',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,2211,N'Rural',NULL),
	 (82206,N'El Walamo',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,28,12,1142,N'Rural',NULL),
	 (82206,N'Pedro Rodr�guez',N'Colonia',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,9,12,3045,N'Urbano',NULL),
	 (82207,N'Campo Rey',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,25,N'Rural',NULL),
	 (82207,N'El Garit�n',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,26,N'Rural',NULL),
	 (82207,N'El Habalito del Tubo',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,21,12,3044,N'Rural',NULL),
	 (82210,N'Villa Uni�n Centro',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1620,N'Urbano',12),
	 (82213,N'El Tronconal',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1782,N'Urbano',12),
	 (82214,N'Buenavista',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1627,N'Urbano',12),
	 (82214,N'Fidel Vel�zquez',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1783,N'Urbano',12);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82214,N'Alfonso G. Calder�n',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1784,N'Urbano',12),
	 (82214,N'Lomas de Villa Uni�n',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1785,N'Urbano',12),
	 (82214,N'Flor de Mayo',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1786,N'Urbano',12),
	 (82214,N'Agustina Ram�rez',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,2286,N'Urbano',12),
	 (82214,N'7 de Abril',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,2287,N'Urbano',12),
	 (82215,N'Antonio Toledo Corro',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1787,N'Urbano',12),
	 (82215,N'Jos� L�pez Portillo',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1788,N'Urbano',12),
	 (82215,N'Renato Vega',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1789,N'Urbano',12),
	 (82215,N'Lienzo Charro',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,21,12,1790,N'Urbano',12),
	 (82215,N'�ngela Peralta',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1791,N'Urbano',12);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82216,N'Ejidal',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1792,N'Urbano',12),
	 (82216,N'Once R�os',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1793,N'Urbano',12),
	 (82216,N'Los Sauces',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,21,12,3119,N'Urbano',12),
	 (82217,N'Margarita Maza de Ju�rez',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1621,N'Urbano',12),
	 (82217,N'Sixto Osuna',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1623,N'Urbano',12),
	 (82217,N'Raul Osuna Burgue�o',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,1794,N'Urbano',12),
	 (82217,N'Julio Arroyo',N'Colonia',N'Mazatl�n',N'Sinaloa',N'Villa Uni�n',82181,25,82181,NULL,9,12,2987,N'Urbano',12),
	 (82230,N'Telcoyonqui',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,27,N'Rural',NULL),
	 (82233,N'Veranos',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,28,N'Rural',NULL),
	 (82233,N'Pichilingue',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,29,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82233,N'Las Conchas',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,30,N'Rural',NULL),
	 (82233,N'Porras',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,31,N'Rural',NULL),
	 (82233,N'El Llano',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,32,N'Rural',NULL),
	 (82233,N'Tiro',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,33,N'Rural',NULL),
	 (82233,N'El Zacate',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,34,N'Rural',NULL),
	 (82233,N'Los Paisas',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,35,N'Rural',NULL),
	 (82233,N'El Recodo',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,28,12,1146,N'Rural',NULL),
	 (82233,N'Loma Alta de los Zatar�in',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,28,12,3021,N'Rural',NULL),
	 (82234,N'El Zapotal',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,36,N'Rural',NULL),
	 (82234,N'Los �banos',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,37,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82235,N'El Arenal',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,38,N'Rural',NULL),
	 (82236,N'Siqueros',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,28,12,1145,N'Rural',NULL),
	 (82238,N'El Guayabo',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,40,N'Rural',NULL),
	 (82238,N'Charcos Prietos',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,41,N'Rural',NULL),
	 (82238,N'El Salto',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,1144,N'Rural',NULL),
	 (82238,N'El Espinal',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2891,N'Rural',NULL),
	 (82240,N'Lomas del Guayabo',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,109,N'Rural',NULL),
	 (82240,N'Campo Pueblo Nuevo',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,110,N'Rural',NULL),
	 (82243,N'Los �banos',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,42,N'Rural',NULL),
	 (82245,N'El Roble',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,1149,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82246,N'El Guayabo',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,28,12,2530,N'Rural',NULL),
	 (82247,N'Escamillas',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,1151,N'Rural',NULL),
	 (82248,N'El Baj�o',N'Hacienda',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,24,12,1152,N'Rural',NULL),
	 (82248,N'El Tecomate de Siqueros',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,2880,N'Rural',NULL),
	 (82249,N'Cofrad�a (Cofrad�a de Leyva Solano)',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,1150,N'Rural',NULL),
	 (82264,N'De los Ni�os',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,43,N'Rural',NULL),
	 (82264,N'Stanza Magnolia',N'Fraccionamiento',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,21,12,121,N'Rural',NULL),
	 (82266,N'Barr�n',N'Ejido',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,15,12,1153,N'Rural',NULL),
	 (82267,N'Ampliaci�n el Castillo',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,44,N'Rural',NULL),
	 (82267,N'La Guanera',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,45,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82267,N'Los Gavilanes',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,46,N'Rural',NULL),
	 (82267,N'El Contento',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,48,12,47,N'Rural',NULL),
	 (82267,N'El Zapote',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,48,N'Rural',NULL),
	 (82267,N'Ampliaci�n el Zapote',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,29,12,49,N'Rural',NULL),
	 (82267,N'CERESO Mazatl�n',N'Equipamiento',N'Mazatl�n',N'Sinaloa',N'',82181,25,82181,NULL,17,12,1155,N'Rural',NULL),
	 (82269,N'Mazatl�n (Gral. Rafael Buelna)',N'Aeropuerto',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,1,12,2149,N'Urbano',NULL),
	 (82270,N'El Milagro',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,50,N'Rural',NULL),
	 (82270,N'El Mirabal',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,51,N'Rural',NULL),
	 (82270,N'El Ca��n de Batopilas',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,52,N'Rural',NULL),
	 (82270,N'El Habal',N'Hacienda',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,24,12,1147,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82273,N'Armadillo',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,53,N'Rural',NULL),
	 (82273,N'Los Cedros',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,54,N'Rural',NULL),
	 (82273,N'El Chilillo',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2531,N'Rural',NULL),
	 (82273,N'Puerta de Canoas',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,2879,N'Rural',NULL),
	 (82274,N'Escondida de Palmillas',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,55,N'Rural',NULL),
	 (82274,N'Palmillas',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,56,N'Rural',NULL),
	 (82274,N'La Presa',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,57,N'Rural',NULL),
	 (82274,N'Las Higueras del Conchi',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,58,N'Rural',NULL),
	 (82274,N'Miravalles',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,59,N'Rural',NULL),
	 (82275,N'San Juan',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,60,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82275,N'Ej�rcito de Salvaci�n',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,61,N'Rural',NULL),
	 (82275,N'El Pozole',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,1148,N'Rural',NULL),
	 (82277,N'Santa Teresa',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,62,N'Rural',NULL),
	 (82277,N'La Yerbabuena',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,63,N'Rural',NULL),
	 (82277,N'El Huizachal',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,64,N'Rural',NULL),
	 (82277,N'San Jos� (Chuchupiras)',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,65,N'Rural',NULL),
	 (82277,N'La Curva del Potrero',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,66,N'Rural',NULL),
	 (82277,N'San Jos�',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,67,N'Rural',NULL),
	 (82277,N'El Potrero de Carrasco',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,2688,N'Rural',NULL),
	 (82300,N'Piedra Blanca',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,68,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82300,N'Los Arrayanes (El Saucito)',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,69,N'Rural',NULL),
	 (82300,N'Las Salvias',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,70,N'Rural',NULL),
	 (82300,N'Los Copales',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2735,N'Rural',NULL),
	 (82303,N'Guaymas',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,71,N'Rural',NULL),
	 (82303,N'El Zapote',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,72,N'Rural',NULL),
	 (82303,N'La Embocada',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,73,N'Rural',NULL),
	 (82303,N'La Chapalota',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,74,N'Rural',NULL),
	 (82304,N'Guam�chil',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2532,N'Rural',NULL),
	 (82304,N'El Tecomate de la Noria',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2533,N'Rural',NULL),
	 (82305,N'La Osa',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,75,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82305,N'Las Gu�simas',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,76,N'Rural',NULL),
	 (82305,N'Los Cocos',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,77,N'Rural',NULL),
	 (82306,N'El Magistral',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,78,N'Rural',NULL),
	 (82306,N'Metates',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,79,N'Rural',NULL),
	 (82306,N'El Pinto (El Cerro)',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,80,N'Rural',NULL),
	 (82306,N'El Palmillar (El Palmillar de los Ag�eros)',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,81,N'Rural',NULL),
	 (82310,N'San Jos� del Ca��n',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,82,N'Rural',NULL),
	 (82310,N'Potrerillos',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,83,N'Rural',NULL),
	 (82313,N'El Olvido',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,84,N'Rural',NULL),
	 (82313,N'Las Tatemas de Arriba',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,85,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82313,N'El Bebedero',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,86,N'Rural',NULL),
	 (82313,N'San Marcos',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,135,N'Rural',NULL),
	 (82313,N'Juantillos',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,1158,N'Rural',NULL),
	 (82313,N'San Marcos',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,1161,N'Rural',NULL),
	 (82313,N'Puerta de San Marcos',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2734,N'Rural',NULL),
	 (82314,N'El Placer',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2986,N'Rural',NULL),
	 (82320,N'Chicura de la Noria',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,5,N'Rural',NULL),
	 (82320,N'Los Columpios',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,87,N'Rural',NULL),
	 (82320,N'Los Cuilones',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,88,N'Rural',NULL),
	 (82320,N'Las Tinajas',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,89,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82320,N'Los Cardones de Arriba',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,90,N'Rural',NULL),
	 (82329,N'La Noria de San Antonio (La Noria)',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,1157,N'Rural',NULL),
	 (82330,N'San Pedro',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,91,N'Rural',NULL),
	 (82330,N'Colima',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,92,N'Rural',NULL),
	 (82330,N'El Chilar',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,93,N'Rural',NULL),
	 (82330,N'Los A�iles',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,94,N'Rural',NULL),
	 (82330,N'Los Zapotes',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2534,N'Rural',NULL),
	 (82330,N'San Pablo',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2947,N'Rural',NULL),
	 (82334,N'La Palma Sola',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,3,N'Rural',NULL),
	 (82334,N'Las Moras de Alonso',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,95,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82334,N'Santa Fe',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,96,N'Rural',NULL),
	 (82334,N'El Pochote',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,97,N'Rural',NULL),
	 (82335,N'Los Limones',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,2,N'Rural',NULL),
	 (82335,N'La Semana',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,98,N'Rural',NULL),
	 (82350,N'El Quelite',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,1159,N'Rural',NULL),
	 (82350,N'El Puente del Quelite',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,2210,N'Rural',NULL),
	 (82353,N'El Amole del Quelite',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,99,N'Rural',NULL),
	 (82354,N'El Llor�n',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,100,N'Rural',NULL),
	 (82355,N'San Jos�',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,101,N'Rural',NULL),
	 (82360,N'El Quemado',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2535,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82363,N'El Moral',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,102,N'Rural',NULL),
	 (82365,N'El Vainillo',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,103,N'Rural',NULL),
	 (82365,N'Los Cedros',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,104,N'Rural',NULL),
	 (82365,N'La Mora Escarbada',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,105,N'Rural',NULL),
	 (82366,N'Jim�nez',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,106,N'Rural',NULL),
	 (82369,N'La S�bila',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,1160,N'Rural',NULL),
	 (82370,N'El Recreo',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2536,N'Rural',NULL),
	 (82370,N'Camacho',N'Pueblo',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,28,12,2954,N'Rural',NULL),
	 (82373,N'El Verde',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,107,N'Rural',NULL),
	 (82380,N'El Chamizal',N'Rancho',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,48,12,108,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82380,N'Los Llanitos',N'Rancher�a',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,29,12,2209,N'Rural',NULL),
	 (82384,N'M�rmol de Salcido (M�rmol)',N'Zona industrial',N'Mazatl�n',N'Sinaloa',N'',82001,25,82001,NULL,37,12,1143,N'Rural',NULL),
	 (82400,N'Paredones',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,17,N'Urbano',3),
	 (82400,N'Escuinapa Centro',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,1162,N'Urbano',3),
	 (82400,N'FOVISSSTE Buenos Aires',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2062,N'Urbano',3),
	 (82410,N'Cruces Cuatas',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,19,N'Urbano',3),
	 (82410,N'Pueblo Nuevo',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,1164,N'Urbano',3),
	 (82410,N'INFONAVIT El Arroyo',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2063,N'Urbano',3),
	 (82419,N'Loma Linda INFONAVIT Norte',N'Unidad habitacional',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,31,9,1165,N'Urbano',3),
	 (82420,N'Loma Bonita',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,18,N'Urbano',3);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82420,N'Francisco I. Madero',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,1166,N'Urbano',3),
	 (82420,N'INFONAVIT Arroyo Seco',N'Unidad habitacional',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,31,9,1995,N'Urbano',3),
	 (82420,N'Azteca',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2071,N'Urbano',3),
	 (82430,N'Insurgentes',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,1167,N'Urbano',3),
	 (82430,N'El Roblito',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2076,N'Urbano',3),
	 (82440,N'10 de Mayo',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,1168,N'Urbano',3),
	 (82457,N'INFONAVIT Las Flores',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,1,N'Urbano',3),
	 (82457,N'Emiliano Zapata',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,1170,N'Urbano',3),
	 (82457,N'El Para�so',N'Fraccionamiento',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,21,9,1994,N'Urbano',3),
	 (82457,N'13 de Septiembre',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2072,N'Urbano',3);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82457,N'Solidaridad',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2073,N'Urbano',3),
	 (82457,N'INFONAVIT Del Valle',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2074,N'Urbano',3),
	 (82457,N'D�maso Murua',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2191,N'Urbano',3),
	 (82458,N'Villa Galaxia II',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,20,N'Urbano',3),
	 (82458,N'Las Huertas INFONAVIT',N'Unidad habitacional',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,31,9,1171,N'Urbano',3),
	 (82458,N'Las Huertas II INFONAVIT',N'Unidad habitacional',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,31,9,2077,N'Urbano',3),
	 (82458,N'Villa Galaxia',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2186,N'Urbano',3),
	 (82459,N'Las Fuentes',N'Fraccionamiento',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,21,9,16,N'Urbano',3),
	 (82459,N'Antonio Toledo Corro',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,1172,N'Urbano',3),
	 (82459,N'L�zaro C�rdenas',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2070,N'Urbano',3);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82459,N'INFONAVIT del Mar',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2187,N'Urbano',3),
	 (82460,N'Ampliaci�n Gabriel Leyva',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,21,N'Urbano',3),
	 (82460,N'Gabriel Leyva',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,1173,N'Urbano',3),
	 (82460,N'INFONAVIT Los Mangos',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2075,N'Urbano',3),
	 (82460,N'Juvencio Arag�n',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2185,N'Urbano',3),
	 (82470,N'Benito Ju�rez',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,1174,N'Urbano',3),
	 (82478,N'Ampliaci�n Benito Ju�rez',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,1175,N'Urbano',3),
	 (82478,N'Santa Luc�a',N'Colonia',N'Escuinapa',N'Sinaloa',N'Escuinapa de Hidalgo',82401,25,82401,NULL,9,9,2064,N'Urbano',3),
	 (82500,N'Rinc�n del Verde',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,1177,N'Rural',NULL),
	 (82505,N'El Capomo',N'Rancho',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,48,9,10,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82513,N'El Camar�n',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,3143,N'Rural',NULL),
	 (82517,N'Pilas de Estancia',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,3098,N'Rural',NULL),
	 (82530,N'Jos� Mar�a Morelos y Pav�n',N'Colonia',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,9,9,1178,N'Urbano',NULL),
	 (82530,N'Isla del Bosque',N'Ejido',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,15,9,1180,N'Urbano',NULL),
	 (82532,N'Revoluci�n',N'Rancho',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,48,9,11,N'Rural',NULL),
	 (82532,N'La Estacada',N'Rancho',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,48,9,12,N'Rural',NULL),
	 (82532,N'Celaya',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,1179,N'Rural',NULL),
	 (82534,N'La Villita de la Estaci�n',N'Rancho',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,48,9,9,N'Rural',NULL),
	 (82540,N'Tecualilla',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,1181,N'Rural',NULL),
	 (82545,N'San Miguel de la Atarjea',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,14,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82550,N'El Tr�bol',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,8,N'Rural',NULL),
	 (82550,N'La Campana N�mero Dos (El Pochote)',N'Ejido',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,15,9,1182,N'Rural',NULL),
	 (82550,N'Ejido de la Campana N�mero Uno',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,1183,N'Rural',NULL),
	 (82553,N'El Tule (La Cobacha)',N'Rancho',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,48,9,15,N'Rural',NULL),
	 (82554,N'La Ci�nega',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,13,N'Rural',NULL),
	 (82560,N'Teacapan',N'Pueblo',N'Escuinapa',N'Sinaloa',N'',82561,25,82561,NULL,28,9,1186,N'Rural',NULL),
	 (82563,N'El Camich�n [Sitio de Pesca]',N'Rancho',N'Escuinapa',N'Sinaloa',N'',82561,25,82561,NULL,48,9,3,N'Rural',NULL),
	 (82563,N'Cristo Rey',N'Ejido',N'Escuinapa',N'Sinaloa',N'',82561,25,82561,NULL,15,9,1184,N'Rural',NULL),
	 (82564,N'Palmito del Verde',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82561,25,82561,NULL,29,9,1185,N'Rural',NULL),
	 (82580,N'Ojo de Agua de Palmillas',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,1188,N'Urbano',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82590,N'La Loma (Gabriel Leyva Solano)',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,2,N'Rural',NULL),
	 (82590,N'La Concha (La Concepci�n)',N'Pueblo',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,28,9,1190,N'Rural',NULL),
	 (82591,N'Copales',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,1191,N'Rural',NULL),
	 (82592,N'La Ceiba',N'Rancho',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,48,9,4,N'Rural',NULL),
	 (82592,N'Las Pilas',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,5,N'Rural',NULL),
	 (82592,N'Agua Caliente',N'Rancho',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,48,9,6,N'Rural',NULL),
	 (82592,N'El Tr�bol 2',N'Rancher�a',N'Escuinapa',N'Sinaloa',N'',82401,25,82401,NULL,29,9,7,N'Rural',NULL),
	 (82600,N'Los Arrayanes',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,65,N'Urbano',NULL),
	 (82600,N'Los Desplazados',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,66,N'Urbano',NULL),
	 (82600,N'Concordia Centro',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,1193,N'Urbano',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82600,N'Villa de Guadalupe',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,2274,N'Urbano',NULL),
	 (82600,N'San Sebasti�n',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,2275,N'Urbano',NULL),
	 (82600,N'La Maravilla',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,2276,N'Urbano',NULL),
	 (82600,N'Magisterial',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,2277,N'Urbano',NULL),
	 (82600,N'Los Ranchitos',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,2278,N'Urbano',NULL),
	 (82600,N'Emiliano Zapata',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,2279,N'Urbano',NULL),
	 (82600,N'20 de Enero',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,2280,N'Urbano',NULL),
	 (82600,N'Jardines de La Loma',N'Fraccionamiento',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,21,4,2281,N'Urbano',NULL),
	 (82600,N'Estadio',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,3145,N'Urbano',NULL),
	 (82600,N'INFONAVIT Loma Linda',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,3146,N'Urbano',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82600,N'Invies Colinas',N'Colonia',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,9,4,3147,N'Urbano',NULL),
	 (82600,N'La Ca�ada',N'Fraccionamiento',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,21,4,3148,N'Urbano',NULL),
	 (82603,N'Los Zacatitos',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,15,N'Rural',NULL),
	 (82604,N'Zavala',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,1194,N'Rural',NULL),
	 (82605,N'La Embocada',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,1197,N'Rural',NULL),
	 (82607,N'Las Porras',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,14,N'Rural',NULL),
	 (82608,N'El Card�n',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,28,N'Rural',NULL),
	 (82608,N'El Card�n',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,29,N'Rural',NULL),
	 (82608,N'San Gabriel',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,30,N'Rural',NULL),
	 (82610,N'El Tiro',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,2,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82610,N'El Naranjo',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,4,N'Rural',NULL),
	 (82610,N'Los Laureles',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,9,N'Rural',NULL),
	 (82610,N'La Cieneguilla',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,52,N'Rural',NULL),
	 (82613,N'Agua Caliente del Favor',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,8,N'Rural',NULL),
	 (82613,N'El Sesteadero',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,20,N'Rural',NULL),
	 (82613,N'El Pueblito',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,21,N'Rural',NULL),
	 (82613,N'San Jos� del Favor',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,22,N'Rural',NULL),
	 (82614,N'Cerro Pel�n',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,5,N'Rural',NULL),
	 (82614,N'Santa B�rbara',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,6,N'Rural',NULL),
	 (82614,N'El Palo Parado',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,7,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82616,N'Las Guacamayas',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,10,N'Rural',NULL),
	 (82616,N'El Llano',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,11,N'Rural',NULL),
	 (82616,N'Los Vasitos',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,12,N'Rural',NULL),
	 (82616,N'Zaragoza',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,53,N'Rural',NULL),
	 (82617,N'Agua Caliente del Zapote',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,13,N'Rural',NULL),
	 (82620,N'Agua Caliente de G�rate (Agua Caliente)',N'Pueblo',N'Concordia',N'Sinaloa',N'',82181,25,82181,NULL,28,4,1198,N'Rural',NULL),
	 (82625,N'El Huajote',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82181,25,82181,NULL,29,4,1196,N'Rural',NULL),
	 (82628,N'Ejido Caleritas',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82181,25,82181,NULL,29,4,27,N'Rural',NULL),
	 (82630,N'El Palmito',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,1200,N'Rural',NULL),
	 (82635,N'Loberas [Microondas]',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,46,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82635,N'Loberas',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,47,N'Rural',NULL),
	 (82635,N'La Laguna',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,49,N'Rural',NULL),
	 (82636,N'El Carrizo',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,50,N'Rural',NULL),
	 (82637,N'El Puente',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,3,N'Rural',NULL),
	 (82640,N'La Concepci�n (La Barrigona)',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,1201,N'Rural',NULL),
	 (82642,N'Agua Caliente de Jacobo',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,19,N'Rural',NULL),
	 (82642,N'San Juan de Jacobo',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,1202,N'Rural',NULL),
	 (82643,N'Palmillas',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,24,N'Rural',NULL),
	 (82643,N'Los Huanacaxtles',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,51,N'Rural',NULL),
	 (82643,N'Las Iguanas',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,1199,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82643,N'Casas Viejas',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,3020,N'Rural',NULL),
	 (82644,N'Tepuxta',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,1203,N'Rural',NULL),
	 (82644,N'Los Cerritos',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,2948,N'Rural',NULL),
	 (82646,N'Malpica',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,1205,N'Rural',NULL),
	 (82647,N'Los Corrales',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,16,N'Rural',NULL),
	 (82647,N'El Zapote',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,25,N'Rural',NULL),
	 (82648,N'El Verde',N'Fraccionamiento',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,21,4,1204,N'Rural',NULL),
	 (82650,N'El Naranjito',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,34,N'Rural',NULL),
	 (82650,N'Copalita',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,35,N'Rural',NULL),
	 (82650,N'Copala',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,1206,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82653,N'Charcas',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,59,N'Rural',NULL),
	 (82653,N'Joachinque',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,60,N'Rural',NULL),
	 (82653,N'El Saucillo',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,61,N'Rural',NULL),
	 (82653,N'La V�lvula',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,62,N'Rural',NULL),
	 (82653,N'Las Juntas',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,63,N'Rural',NULL),
	 (82653,N'Santa Rosa',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,64,N'Rural',NULL),
	 (82653,N'P�nuco',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,1207,N'Rural',NULL),
	 (82653,N'Palos Blancos',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,3134,N'Rural',NULL),
	 (82655,N'La Venada',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,48,N'Rural',NULL),
	 (82656,N'Los Naranjos',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,58,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82656,N'Platanar de los Ontiveros',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,1208,N'Rural',NULL),
	 (82656,N'Santa Catarina',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,1209,N'Rural',NULL),
	 (82658,N'Los Chinitos',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,17,N'Rural',NULL),
	 (82658,N'La Gu�sima',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,18,N'Rural',NULL),
	 (82658,N'Piedra Blanca',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,26,N'Rural',NULL),
	 (82658,N'Magistral',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,32,N'Rural',NULL),
	 (82658,N'La Pitarrilla',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,33,N'Rural',NULL),
	 (82658,N'Chupaderos',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,1210,N'Rural',NULL),
	 (82660,N'La Capilla del Taxte',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,56,N'Rural',NULL),
	 (82660,N'El Picacho',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,57,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82660,N'Santa Luc�a',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,1211,N'Rural',NULL),
	 (82663,N'La Ca�ita',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,41,N'Rural',NULL),
	 (82663,N'Corte Alto',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,42,N'Rural',NULL),
	 (82663,N'Santa Rita',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,43,N'Rural',NULL),
	 (82663,N'Tr�pico de C�ncer',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,44,N'Rural',NULL),
	 (82663,N'El Batel',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,45,N'Rural',NULL),
	 (82663,N'Chirimoyos',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,1212,N'Rural',NULL),
	 (82663,N'Potrerillos',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,1213,N'Rural',NULL),
	 (82666,N'La Mesa',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,23,N'Rural',NULL),
	 (82666,N'El Coco',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,36,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82666,N'La Mesa del Carrizal',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,37,N'Rural',NULL),
	 (82666,N'La Guayanera',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,39,N'Rural',NULL),
	 (82666,N'El Encinal',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,40,N'Rural',NULL),
	 (82667,N'La Petaca',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,1214,N'Rural',NULL),
	 (82670,N'Cuatantal',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,2537,N'Rural',NULL),
	 (82675,N'Habal de Copala',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,3135,N'Rural',NULL),
	 (82677,N'El Purgatorio',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,38,N'Rural',NULL),
	 (82680,N'Mesillas',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,1215,N'Rural',NULL),
	 (82684,N'Los Ciruelos',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,31,N'Rural',NULL),
	 (82685,N'San Lorenzo',N'Pueblo',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,28,4,1,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82686,N'La Ci�nega',N'Rancho',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,48,4,54,N'Rural',NULL),
	 (82686,N'La Pastor�a',N'Rancher�a',N'Concordia',N'Sinaloa',N'',82602,25,82602,NULL,29,4,55,N'Rural',NULL),
	 (82700,N'La Cruz Centro',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,1216,N'Urbano',17),
	 (82700,N'Pedregal',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,1810,N'Urbano',17),
	 (82700,N'Loma Linda',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,1811,N'Urbano',17),
	 (82702,N'Azteca',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,37,N'Urbano',17),
	 (82702,N'Arroyitos',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,1816,N'Urbano',17),
	 (82703,N'Sinaloa',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,42,N'Urbano',17),
	 (82703,N'Colinas del R�o',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,1815,N'Urbano',17),
	 (82703,N'Santa Cruz',N'Fraccionamiento',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,21,8,1820,N'Urbano',17);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82703,N'Las Brisas',N'Fraccionamiento',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,21,8,2943,N'Urbano',17),
	 (82703,N'Nuevo Amanecer',N'Fraccionamiento',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,21,8,3028,N'Urbano',17),
	 (82703,N'Los Claveles',N'Fraccionamiento',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,21,8,3053,N'Urbano',17),
	 (82703,N'Mac�as',N'Fraccionamiento',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,21,8,3081,N'Urbano',17),
	 (82703,N'Los �rboles',N'Fraccionamiento',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,21,8,3132,N'Urbano',17),
	 (82705,N'Ejidal',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,1818,N'Urbano',17),
	 (82706,N'Palos Blancos',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,1813,N'Urbano',17),
	 (82706,N'V�ctor Manuel Quintero',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,1817,N'Urbano',17),
	 (82706,N'Margarita',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,1819,N'Urbano',17),
	 (82707,N'Miramar',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,1812,N'Urbano',17);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82708,N'Guadalupe Victoria',N'Colonia',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,9,8,1814,N'Urbano',17),
	 (82708,N'Montebello',N'Fraccionamiento',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,21,8,2698,N'Urbano',17),
	 (82708,N'Vicente Escobar',N'Fraccionamiento',N'Elota',N'Sinaloa',N'La Cruz',82701,25,82701,NULL,21,8,2985,N'Urbano',17),
	 (82710,N'Rinc�n de Ibon�a',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1,N'Rural',NULL),
	 (82710,N'Ibon�a',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,2990,N'Rural',NULL),
	 (82713,N'El Sabinal',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,2991,N'Rural',NULL),
	 (82720,N'Casas Nuevas',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,2,N'Rural',NULL),
	 (82720,N'El Portezuelo de Arriba',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,3,N'Rural',NULL),
	 (82720,N'El Portezuelo de Abajo',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,4,N'Rural',NULL),
	 (82721,N'Conitaca',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,1219,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82721,N'Salto Chico',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1220,N'Rural',NULL),
	 (82723,N'La Resbalosa',N'Rancho',N'Elota',N'Sinaloa',N'',80701,25,80701,NULL,48,8,5,N'Rural',NULL),
	 (82723,N'El Chirimole',N'Pueblo',N'Elota',N'Sinaloa',N'',80701,25,80701,NULL,28,8,2977,N'Rural',NULL),
	 (82724,N'Japuino',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,2894,N'Rural',NULL),
	 (82725,N'Nuevo Salto Grande',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1221,N'Rural',NULL),
	 (82726,N'Pared�n Colorado',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,6,N'Rural',NULL),
	 (82727,N'El Solito',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,7,N'Rural',NULL),
	 (82730,N'El Espinal',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,1223,N'Rural',NULL),
	 (82730,N'San Jos� de Conitaca (Nuevo Conitaca)',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,2538,N'Rural',NULL),
	 (82733,N'Las Tinas',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,1231,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82734,N'Potrerillo de los Landeros',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,8,N'Rural',NULL),
	 (82734,N'Los Mecates',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,9,N'Rural',NULL),
	 (82739,N'El Aguaje',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1224,N'Rural',NULL),
	 (82740,N'Las Granjas del Norote',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,10,N'Rural',NULL),
	 (82740,N'Potrerillo del Norote',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,1225,N'Rural',NULL),
	 (82741,N'Alta Rosa (P�pila II)',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,1226,N'Rural',NULL),
	 (82743,N'Gabriel Leyva Solano',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,11,N'Rural',NULL),
	 (82743,N'26 de Enero',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,12,N'Rural',NULL),
	 (82743,N'Vida Campesina',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,1227,N'Rural',NULL),
	 (82744,N'Francisco Ferros',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,38,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82745,N'Higuera de los L�pez',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,13,N'Rural',NULL),
	 (82745,N'Higueras de Culiacancito',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1228,N'Rural',NULL),
	 (82747,N'Los Leones',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,14,N'Rural',NULL),
	 (82747,N'Santa Rita',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,15,N'Rural',NULL),
	 (82747,N'La Ventana (El Carrizo)',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1229,N'Rural',NULL),
	 (82747,N'Emiliano Zapata',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,1230,N'Rural',NULL),
	 (82750,N'El Tabach�n',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,16,N'Rural',NULL),
	 (82755,N'El Mautillo',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,17,N'Rural',NULL),
	 (82755,N'Aguapepe',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,18,N'Rural',NULL),
	 (82758,N'La Bebelama',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,19,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82758,N'Crucero de la Cruz',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,20,N'Rural',NULL),
	 (82758,N'Casas Viejas',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1232,N'Rural',NULL),
	 (82758,N'El Bolillo',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,2539,N'Rural',NULL),
	 (82760,N'Agua Nueva',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1233,N'Rural',NULL),
	 (82763,N'Ensenada',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1234,N'Rural',NULL),
	 (82764,N'La Papalota',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,21,N'Rural',NULL),
	 (82764,N'Casas Grandes',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1235,N'Rural',NULL),
	 (82765,N'Elota',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,1222,N'Rural',NULL),
	 (82770,N'Buenos Aires',N'Colonia',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,9,8,22,N'Rural',NULL),
	 (82770,N'Tanques',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1237,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82773,N'Campo Agrovo',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,23,N'Rural',NULL),
	 (82773,N'Campo la Paloma (Agr�cola el Chaparral)',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,24,N'Rural',NULL),
	 (82773,N'Sol y Arena Anthony',N'Equipamiento',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,17,8,40,N'Rural',NULL),
	 (82773,N'Boscoso',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,1238,N'Rural',NULL),
	 (82773,N'Culiac�n (Culiacancito)',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,2540,N'Rural',NULL),
	 (82773,N'Campo Cachanilla',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,2541,N'Rural',NULL),
	 (82774,N'Campo Nueva Florida',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,25,N'Rural',NULL),
	 (82774,N'Abocho (Estaci�n Abocho)',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,26,N'Rural',NULL),
	 (82774,N'Pueblo Nuevo',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,1236,N'Rural',NULL),
	 (82775,N'Campo y Valle',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,41,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82775,N'Campo San Juan',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,2542,N'Rural',NULL),
	 (82775,N'Campo Santa Luc�a II',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,2543,N'Rural',NULL),
	 (82776,N'Campo Cinco (La Retama)',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,2544,N'Rural',NULL),
	 (82777,N'Los Difuntos',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,27,N'Rural',NULL),
	 (82777,N'Los Caimanes',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1239,N'Rural',NULL),
	 (82777,N'Caimanes II',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,2545,N'Rural',NULL),
	 (82777,N'Campo Nuevo Caimanes',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,2546,N'Rural',NULL),
	 (82780,N'Celestino Gazca Villase�or',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,1240,N'Rural',NULL),
	 (82783,N'Campo Santa Fe',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,28,N'Rural',NULL),
	 (82786,N'Bellavista',N'Colonia',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,9,8,29,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82786,N'Campo Bellavista',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,2547,N'Rural',NULL),
	 (82786,N'Campo Capule',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,2548,N'Rural',NULL),
	 (82787,N'Los Majaguales',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,30,N'Rural',NULL),
	 (82787,N'Playa Ceuta',N'Equipamiento',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,17,8,39,N'Rural',NULL),
	 (82787,N'Ceuta',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1241,N'Rural',NULL),
	 (82787,N'Empaque Tarriba',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,2549,N'Rural',NULL),
	 (82788,N'Santa Fe',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,31,N'Rural',NULL),
	 (82788,N'Benito Ju�rez',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,32,N'Rural',NULL),
	 (82788,N'El Limoncito',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,33,N'Rural',NULL),
	 (82788,N'El Roble',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1242,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82790,N'El Saladito',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1243,N'Rural',NULL),
	 (82790,N'Campo Tayoltita',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,2550,N'Rural',NULL),
	 (82790,N'Tayoltita',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,2551,N'Rural',NULL),
	 (82790,N'Campo Tayoltita II',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,2552,N'Rural',NULL),
	 (82790,N'P�der (Los Arroyitos)',N'Pueblo',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,28,8,2553,N'Rural',NULL),
	 (82793,N'El Salado',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1246,N'Rural',NULL),
	 (82794,N'Nuevo Tecuyo (Tepalcates)',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,34,N'Rural',NULL),
	 (82794,N'Tecuyo',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1245,N'Rural',NULL),
	 (82795,N'Buenavista',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,35,N'Rural',NULL),
	 (82795,N'Loma de Tecuyo',N'Rancher�a',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,29,8,1244,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82796,N'Fructuoso N��ez Campa�a (El Perical)',N'Rancho',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,48,8,36,N'Rural',NULL),
	 (82797,N'Rosendo Nieblas',N'Ejido',N'Elota',N'Sinaloa',N'',82701,25,82701,NULL,15,8,2701,N'Rural',NULL),
	 (82800,N'El Rosario Centro',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1247,N'Urbano',18),
	 (82800,N'Anonal',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,3185,N'Urbano',18),
	 (82802,N'Rosendo G. Castro INFONAVIT',N'Fraccionamiento',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,21,14,1830,N'Urbano',18),
	 (82802,N'Pante�n',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1831,N'Urbano',18),
	 (82802,N'L�pez Portillo',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1842,N'Urbano',18),
	 (82803,N'INFONAVIT Lola Beltr�n',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1832,N'Urbano',18),
	 (82803,N'Genaro Estrada',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1833,N'Urbano',18),
	 (82803,N'Luis Donaldo Colosio',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1834,N'Urbano',18);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82804,N'Mecha Ardiendo',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,4,N'Urbano',18),
	 (82804,N'Rub�n Jaramillo',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1835,N'Urbano',18),
	 (82804,N'La Cruz',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1836,N'Urbano',18),
	 (82805,N'La Joya',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1822,N'Urbano',18),
	 (82805,N'Pablo de Villavicencio',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1839,N'Urbano',18),
	 (82805,N'El Tierral',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,2092,N'Urbano',18),
	 (82806,N'Vicente Guerrero',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1823,N'Urbano',18),
	 (82806,N'Potreritos',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1825,N'Urbano',18),
	 (82806,N'Pedro Ibarra',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1826,N'Urbano',18),
	 (82807,N'Bonifacio Rojas',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1824,N'Urbano',18);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82807,N'Alfonso G. Calder�n',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1838,N'Urbano',18),
	 (82807,N'INFONAVIT Real de Minas',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1840,N'Urbano',18),
	 (82807,N'Juan S. Mill�n',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,2094,N'Urbano',18),
	 (82807,N'Mar�a Luisa Lizarraga Saucedo',N'Fraccionamiento',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,21,14,2271,N'Urbano',18),
	 (82807,N'Ampliaci�n Juan S. Mill�n',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,3183,N'Urbano',18),
	 (82808,N'Marcelo Loya',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1827,N'Urbano',18),
	 (82808,N'Valle Nuevo',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1828,N'Urbano',18),
	 (82808,N'Presidentes',N'Colonia',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,9,14,1829,N'Urbano',18),
	 (82808,N'Minas del Tajo',N'Fraccionamiento',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,21,14,1841,N'Urbano',18),
	 (82809,N'Villas del Mineral',N'Fraccionamiento',N'Rosario',N'Sinaloa',N'El Rosario',82801,25,82801,NULL,21,14,1837,N'Urbano',18);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82810,N'Las Pi�as',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,5,N'Rural',NULL),
	 (82810,N'La Escondida',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,6,N'Rural',NULL),
	 (82810,N'Palos Blancos',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,7,N'Rural',NULL),
	 (82810,N'Chele',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,1253,N'Rural',NULL),
	 (82813,N'Los Tambos',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,8,N'Rural',NULL),
	 (82813,N'La Mimbre',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,9,N'Rural',NULL),
	 (82814,N'Los Sitios del Picacho',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,10,N'Rural',NULL),
	 (82814,N'Quebrada Verde',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,11,N'Rural',NULL),
	 (82817,N'El Guajolote',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,12,N'Rural',NULL),
	 (82817,N'Los Arrayanes',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,3190,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82820,N'Francisco Villa (Las Garzas)',N'Ejido',N'Rosario',N'Sinaloa',N'',82181,25,82181,NULL,15,14,13,N'Rural',NULL),
	 (82820,N'Teodoro Beltr�n (La Hacienda)',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82181,25,82181,NULL,29,14,1254,N'Rural',NULL),
	 (82820,N'Los Pozos',N'Pueblo',N'Rosario',N'Sinaloa',N'',82181,25,82181,NULL,28,14,2335,N'Rural',NULL),
	 (82823,N'Gregorio V�zquez Moreno (San Joach�n)',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82181,25,82181,NULL,29,14,2334,N'Rural',NULL),
	 (82824,N'La Gu�sima',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82181,25,82181,NULL,29,14,2332,N'Rural',NULL),
	 (82825,N'Pozos Labrados',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,14,N'Rural',NULL),
	 (82826,N'El Matadero',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,1256,N'Rural',NULL),
	 (82827,N'El Zopilote',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,2325,N'Rural',NULL),
	 (82830,N'El Infiernillo',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,15,N'Rural',NULL),
	 (82830,N'El Recodo',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,16,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82830,N'Cacalot�n',N'Pueblo',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,28,14,1257,N'Rural',NULL),
	 (82830,N'Copales',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,1258,N'Rural',NULL),
	 (82830,N'El Tamarindo',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,2330,N'Rural',NULL),
	 (82830,N'Francisco Quintero',N'Colonia',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,9,14,2740,N'Rural',NULL),
	 (82830,N'Hacienda el Tamarindo',N'Pueblo',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,28,14,2757,N'Rural',NULL),
	 (82830,N'El Nuevo Tonal�',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,3091,N'Rural',NULL),
	 (82832,N'Cruz Pedregoza',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,1250,N'Rural',NULL),
	 (82832,N'Laguna de Beltranes',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,1252,N'Rural',NULL),
	 (82832,N'Nieblas',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,2329,N'Rural',NULL),
	 (82833,N'El Tabl�n N�mero Dos',N'Ejido',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,15,14,1,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82833,N'Rinc�n de Higueras',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,2,N'Rural',NULL),
	 (82833,N'Tabl�n Viejo',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,2214,N'Rural',NULL),
	 (82833,N'Las Higueras',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,2331,N'Rural',NULL),
	 (82833,N'Tabl�n N�mero Uno (Las Cruces Cuatas)',N'Ejido',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,15,14,2333,N'Rural',NULL),
	 (82833,N'El Portezuelo',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,3199,N'Rural',NULL),
	 (82834,N'Santa Mar�a (Santa Mar�a de Gracia)',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,17,N'Rural',NULL),
	 (82834,N'La Canoa',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,18,N'Rural',NULL),
	 (82834,N'Ojo de Agua',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,2324,N'Rural',NULL),
	 (82835,N'Los Guajolotes',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,19,N'Rural',NULL),
	 (82835,N'Estaci�n Rosario',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,20,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82835,N'La Angarilla',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,21,N'Rural',NULL),
	 (82835,N'Ojitos',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,2328,N'Rural',NULL),
	 (82839,N'Loma de Potrerillos',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,22,N'Rural',NULL),
	 (82839,N'Otates',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,23,N'Rural',NULL),
	 (82839,N'Potrerillos',N'Pueblo',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,28,14,1259,N'Rural',NULL),
	 (82839,N'Ojo de Agua de Osuna',N'Ejido',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,15,14,2317,N'Rural',NULL),
	 (82850,N'San Miguel',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,25,N'Rural',NULL),
	 (82850,N'Tebaira',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,2213,N'Rural',NULL),
	 (82853,N'Agua Zarca',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,26,N'Rural',NULL),
	 (82860,N'El Plan',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,27,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82860,N'Agua Fr�a',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,28,N'Rural',NULL),
	 (82860,N'El Colomo',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,29,N'Rural',NULL),
	 (82860,N'El Azafr�n',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,30,N'Rural',NULL),
	 (82860,N'La Rastra',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,1260,N'Rural',NULL),
	 (82860,N'Plomosas',N'Pueblo',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,28,14,2289,N'Rural',NULL),
	 (82863,N'San Marcial',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,31,N'Rural',NULL),
	 (82863,N'Los Cajones',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,32,N'Rural',NULL),
	 (82863,N'Mesa de Santa Rita',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,33,N'Rural',NULL),
	 (82864,N'Palmarito',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,34,N'Rural',NULL),
	 (82864,N'La Palma Barrenada',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,35,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82865,N'El Llano de la Palma',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,36,N'Rural',NULL),
	 (82865,N'Las Cebollitas',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,37,N'Rural',NULL),
	 (82865,N'Charco Hondo',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,38,N'Rural',NULL),
	 (82865,N'El Carrizo',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,39,N'Rural',NULL),
	 (82866,N'Picachitos',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,40,N'Rural',NULL),
	 (82870,N'Chametla',N'Pueblo',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,28,14,1261,N'Rural',NULL),
	 (82871,N'La Loma',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,41,N'Rural',NULL),
	 (82871,N'El Potrero de Astengo',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,42,N'Rural',NULL),
	 (82871,N'Montealto',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,43,N'Rural',NULL),
	 (82871,N'Duranguito',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,44,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82871,N'La Reforma',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,45,N'Rural',NULL),
	 (82871,N'El Pozole',N'Pueblo',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,28,14,1251,N'Rural',NULL),
	 (82871,N'Apoderado',N'Pueblo',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,28,14,1262,N'Rural',NULL),
	 (82871,N'El Chupadero',N'Pueblo',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,28,14,2941,N'Rural',NULL),
	 (82872,N'Agua Verde',N'Pueblo',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,28,14,1263,N'Rural',NULL),
	 (82874,N'El Valamo',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,46,N'Rural',NULL),
	 (82874,N'Ponce',N'Ejido',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,15,14,1248,N'Rural',NULL),
	 (82875,N'Loma Blanca',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,47,N'Rural',NULL),
	 (82875,N'Guatimozitl',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,48,N'Rural',NULL),
	 (82875,N'Los Alacranes',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,49,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82875,N'La Urraca',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,50,N'Rural',NULL),
	 (82875,N'Chilillos',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,2326,N'Rural',NULL),
	 (82876,N'Emiliano Zapata',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,51,N'Rural',NULL),
	 (82876,N'Tazajal',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,52,N'Rural',NULL),
	 (82876,N'El Limoncito (El Riyito)',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,53,N'Rural',NULL),
	 (82876,N'Loma del Zorrillo',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,54,N'Rural',NULL),
	 (82876,N'Loma Verde',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,55,N'Rural',NULL),
	 (82876,N'Caj�n Verde',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,2327,N'Rural',NULL),
	 (82877,N'El Puyeque',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,1264,N'Rural',NULL),
	 (82877,N'Caj�n Ojo de Agua N�mero Dos',N'Pueblo',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,28,14,2336,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82880,N'Las Habitas',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,3,N'Rural',NULL),
	 (82880,N'Maloyita',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,56,N'Rural',NULL),
	 (82880,N'El Ciruelo',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,57,N'Rural',NULL),
	 (82880,N'Las Juntas',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,58,N'Rural',NULL),
	 (82880,N'Matat�n',N'Pueblo',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,28,14,1266,N'Rural',NULL),
	 (82883,N'Potrero de los Laureles',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,59,N'Rural',NULL),
	 (82883,N'Guamuchiltita',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,60,N'Rural',NULL),
	 (82883,N'Tepehuaje',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,61,N'Rural',NULL),
	 (82884,N'San Marco Otatit�n',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,62,N'Rural',NULL),
	 (82885,N'Tecomatillo',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,63,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82885,N'Buenavista',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,64,N'Rural',NULL),
	 (82885,N'Maloya',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,65,N'Rural',NULL),
	 (82885,N'Corral de Piedras',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,2212,N'Rural',NULL),
	 (82886,N'El Aguacate',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,66,N'Rural',NULL),
	 (82886,N'Jalpa N�mero Dos',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,67,N'Rural',NULL),
	 (82887,N'La Tuna',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,68,N'Rural',NULL),
	 (82887,N'La Arrastrada',N'Rancho',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,48,14,69,N'Rural',NULL),
	 (82887,N'Agua Caliente de los Panales',N'Rancher�a',N'Rosario',N'Sinaloa',N'',82801,25,82801,NULL,29,14,3097,N'Rural',NULL),
	 (82900,N'Chacualtita (Colompo)',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,5,N'Rural',NULL),
	 (82900,N'El Platanar',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,6,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82902,N'El Carrizal',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,7,N'Rural',NULL),
	 (82902,N'Ajoya',N'Pueblo',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,28,16,1269,N'Rural',NULL),
	 (82904,N'Los Humayes',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,8,N'Rural',NULL),
	 (82904,N'Las Lajas',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,2881,N'Rural',NULL),
	 (82905,N'El Chaco',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,9,N'Rural',NULL),
	 (82905,N'Tolosa (Guallanila)',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,10,N'Rural',NULL),
	 (82905,N'El Cant�n',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,11,N'Rural',NULL),
	 (82906,N'Tacuitapa',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,12,N'Rural',NULL),
	 (82906,N'El Capule',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,13,N'Rural',NULL),
	 (82907,N'Los Frailes',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,14,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82909,N'El Limoncito (El Palmar)',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,15,N'Rural',NULL),
	 (82909,N'Vado Hondo',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,16,N'Rural',NULL),
	 (82909,N'San Juan',N'Pueblo',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,28,16,1270,N'Rural',NULL),
	 (82910,N'San Ignacio Centro',N'Colonia',N'San Ignacio',N'Sinaloa',N'San Ignacio',82911,25,82911,NULL,9,16,1637,N'Urbano',22),
	 (82912,N'Pueblito',N'Colonia',N'San Ignacio',N'Sinaloa',N'San Ignacio',82911,25,82911,NULL,9,16,85,N'Urbano',22),
	 (82912,N'Heraclio Bernal',N'Colonia',N'San Ignacio',N'Sinaloa',N'San Ignacio',82911,25,82911,NULL,9,16,1638,N'Urbano',22),
	 (82912,N'Feliciano Roque',N'Colonia',N'San Ignacio',N'Sinaloa',N'San Ignacio',82911,25,82911,NULL,9,16,2201,N'Urbano',22),
	 (82913,N'Azucena del R�o',N'Colonia',N'San Ignacio',N'Sinaloa',N'San Ignacio',82911,25,82911,NULL,9,16,1639,N'Urbano',22),
	 (82913,N'El Pueblito',N'Colonia',N'San Ignacio',N'Sinaloa',N'San Ignacio',82911,25,82911,NULL,9,16,3144,N'Urbano',22),
	 (82916,N'La Chora (Renato Vega)',N'Colonia',N'San Ignacio',N'Sinaloa',N'San Ignacio',82911,25,82911,NULL,9,16,1640,N'Urbano',22);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82917,N'La Vega',N'Colonia',N'San Ignacio',N'Sinaloa',N'San Ignacio',82911,25,82911,NULL,9,16,1641,N'Urbano',22),
	 (82918,N'Los Tecomates',N'Fraccionamiento',N'San Ignacio',N'Sinaloa',N'San Ignacio',82911,25,82911,NULL,21,16,84,N'Urbano',22),
	 (82918,N'Labastida Ochoa',N'Colonia',N'San Ignacio',N'Sinaloa',N'San Ignacio',82911,25,82911,NULL,9,16,1642,N'Urbano',22),
	 (82920,N'Agua Caliente de los Yuriar',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,17,N'Rural',NULL),
	 (82920,N'Acatit�n',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,18,N'Rural',NULL),
	 (82923,N'La Ci�nega',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,19,N'Rural',NULL),
	 (82923,N'Rinc�n del Chilar',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,20,N'Rural',NULL),
	 (82923,N'El Chilar',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,1271,N'Rural',NULL),
	 (82925,N'Piedras Negras (Piedras Prietas Guasimillas)',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,21,N'Rural',NULL),
	 (82925,N'G�illapa',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,22,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82925,N'El Sauz',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,23,N'Rural',NULL),
	 (82925,N'Campanillas',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,24,N'Rural',NULL),
	 (82930,N'La Ca�a',N'Ejido',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,15,16,2312,N'Rural',NULL),
	 (82933,N'El Esp�ritu',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,25,N'Rural',NULL),
	 (82934,N'El Guayabo',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,26,N'Rural',NULL),
	 (82934,N'Los Tarayes',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,27,N'Rural',NULL),
	 (82935,N'El Rinc�n de Tenchoquelite',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,28,N'Rural',NULL),
	 (82935,N'Tepehuajes',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,29,N'Rural',NULL),
	 (82935,N'Tenchoquelite',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,30,N'Rural',NULL),
	 (82935,N'Los Brasiles',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,31,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82937,N'Cofrad�a',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,33,N'Rural',NULL),
	 (82940,N'Ixpalino',N'Pueblo',N'San Ignacio',N'Sinaloa',N'',82001,25,82001,NULL,28,16,1272,N'Rural',NULL),
	 (82943,N'San Agust�n',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,35,N'Rural',NULL),
	 (82945,N'El Guam�chil',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,34,N'Rural',NULL),
	 (82945,N'El Tecolote',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,36,N'Rural',NULL),
	 (82945,N'La Quebrada de los Sandoval',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,1273,N'Rural',NULL),
	 (82950,N'Contraestaca',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',34691,25,34691,NULL,29,16,1274,N'Rural',NULL),
	 (82953,N'Casa de Texas',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,37,N'Rural',NULL),
	 (82953,N'Rinc�n de Guayabito',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,38,N'Rural',NULL),
	 (82953,N'Pueblo Viejo',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,39,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82953,N'El Arroyo',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,40,N'Rural',NULL),
	 (82954,N'El Lim�n de los Casta�eda',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,41,N'Rural',NULL),
	 (82954,N'La Vainilla',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,42,N'Rural',NULL),
	 (82954,N'Las Milpillas',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,43,N'Rural',NULL),
	 (82955,N'La Ca�a',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,44,N'Rural',NULL),
	 (82955,N'Las Azoteas',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,45,N'Rural',NULL),
	 (82956,N'California',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,46,N'Rural',NULL),
	 (82960,N'El Caj�n de Piaxtla',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,1,N'Rural',NULL),
	 (82960,N'Crucero de Piaxtla (La Cacharola)',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,2,N'Rural',NULL),
	 (82960,N'Las Lomas del Pedregal',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,47,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82960,N'El Pujido',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,48,N'Rural',NULL),
	 (82960,N'Piaxtla de Abajo',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,1275,N'Rural',NULL),
	 (82960,N'Piaxtla de Arriba',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,2695,N'Rural',NULL),
	 (82963,N'El Array�n',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,49,N'Rural',NULL),
	 (82963,N'El Mariachi Piaxtla',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,50,N'Rural',NULL),
	 (82963,N'Camino Real de Piaxtla',N'Pueblo',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,28,16,1276,N'Rural',NULL),
	 (82965,N'El Patole',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,51,N'Rural',NULL),
	 (82966,N'Duranguito de Dimas',N'Pueblo',N'San Ignacio',N'Sinaloa',N'',82001,25,82001,NULL,28,16,1278,N'Rural',NULL),
	 (82967,N'Guillermo Prieto',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,82,N'Rural',NULL),
	 (82967,N'La Chicayota (Chilacayotas)',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,83,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82968,N'Barras de Piaxtla',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82001,25,82001,NULL,29,16,1279,N'Rural',NULL),
	 (82969,N'Dimas',N'Barrio',N'San Ignacio',N'Sinaloa',N'',82701,25,82701,NULL,2,16,1280,N'Urbano',NULL),
	 (82970,N'Los Mecates',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,52,N'Rural',NULL),
	 (82970,N'La Labor',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,1281,N'Rural',NULL),
	 (82973,N'Los Pl�tanos',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,53,N'Rural',NULL),
	 (82973,N'El Veladero',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,54,N'Rural',NULL),
	 (82973,N'El Quelele',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,55,N'Rural',NULL),
	 (82973,N'El Manch�n',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,56,N'Rural',NULL),
	 (82973,N'El Tule',N'Pueblo',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,28,16,3140,N'Rural',NULL),
	 (82974,N'Los Platanitos',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,57,N'Rural',NULL);
INSERT INTO  Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82974,N'Las Pilas',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,58,N'Rural',NULL),
	 (82974,N'El Carmen',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,59,N'Rural',NULL),
	 (82975,N'El Lodazal',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,61,N'Rural',NULL),
	 (82975,N'Cabaz�n',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,1283,N'Rural',NULL),
	 (82976,N'Coacoyol',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,62,N'Rural',NULL),
	 (82976,N'Camacho de Arriba',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,63,N'Rural',NULL),
	 (82976,N'San Javier',N'Pueblo',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,28,16,1282,N'Rural',NULL),
	 (82980,N'La Tasajera',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,64,N'Rural',NULL),
	 (82983,N'El Aguaje de lo Devota',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,65,N'Rural',NULL),
	 (82984,N'El Arrayanal',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,66,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82984,N'Los Colomos',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,67,N'Rural',NULL),
	 (82984,N'La Palma',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,68,N'Rural',NULL),
	 (82985,N'El Limoncito',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,69,N'Rural',NULL),
	 (82985,N'Jinetes',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,70,N'Rural',NULL),
	 (82985,N'El Cedro',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,71,N'Rural',NULL),
	 (82985,N'Los Tarayes',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,72,N'Rural',NULL),
	 (82985,N'El Moral (Las Tinas)',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,73,N'Rural',NULL),
	 (82990,N'Higueras de Ponce',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,74,N'Rural',NULL),
	 (82990,N'Entronque de Coyotit�n',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,75,N'Rural',NULL),
	 (82990,N'La Calavera',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,76,N'Rural',NULL);
INSERT INTO Sinaloa (d_codigo,d_asenta,d_tipo_asenta,D_mnpio,d_estado,d_ciudad,d_CP,c_estado,c_oficina,c_CP,c_tipo_asenta,c_mnpio,id_asenta_cpcons,d_zona,c_cve_ciudad) VALUES
	 (82990,N'Los Gordos',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,77,N'Rural',NULL),
	 (82990,N'El Verano',N'Rancho',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,48,16,78,N'Rural',NULL),
	 (82990,N'Coyotit�n',N'Pueblo',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,28,16,1284,N'Rural',NULL),
	 (82990,N'Lo de Ponce',N'Pueblo',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,28,16,2290,N'Rural',NULL),
	 (82993,N'Palmarito de los Ram�rez',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,3,N'Rural',NULL),
	 (82994,N'El Lim�n de los Peraza',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,79,N'Rural',NULL),
	 (82995,N'Ejido Toyhua',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,80,N'Rural',NULL),
	 (82995,N'El Pozole',N'Rancher�a',N'San Ignacio',N'Sinaloa',N'',82911,25,82911,NULL,29,16,81,N'Rural',NULL),
	 (82996,N'Lomas del Mar de Piaxtla',N'Pueblo',N'San Ignacio',N'Sinaloa',N'',82001,25,82001,NULL,28,16,2976,N'Rural',NULL);

GO

----------------------------------------------------------------------------------------------------------------------------------------------
--TRIGGERS
--Actualizar estado de cita a Asistida
CREATE TRIGGER TRG_ActualizarEstadoCita
ON Consultas
AFTER INSERT
AS
BEGIN
    UPDATE Citas
    SET Estado = 'Asistida'
    FROM Citas c
    INNER JOIN inserted i ON c.idCita = i.idCita;
END;

GO

CREATE TRIGGER TRG_ActualizarEstadoInv
ON Inventario
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Inventario
    SET Estado = 'Agotado'
    FROM Inventario c
    INNER JOIN inserted i ON c.idInventario = i.idInventario
	WHERE c.CantidadDisp=0
	
END;

GO

--PROC PARA RECETA MEDICAMENTO
CREATE PROCEDURE sp_RegistrarRecetaMedicamento
    @idReceta INT,
    @idMedicamento INT,
    @cantidad INT
AS
BEGIN
    DECLARE @stockActual INT;

    -- Obtener stock disponible
    SELECT @stockActual = CantidadDisp
    FROM Inventario
    WHERE idMedicamento = @idMedicamento;

    IF @stockActual IS NULL
    BEGIN
        RAISERROR('No hay inventario para este medicamento.', 16, 1);
        RETURN;
    END

    IF @stockActual < @cantidad
    BEGIN
        RAISERROR('No hay suficiente stock para este medicamento.', 16, 1);
        RETURN;
    END

    -- Insertar en RECETAMEDICAMENTOS
    INSERT INTO RECETAMEDICAMENTOS (idReceta, idMedicamento, cantidad)
    VALUES (@idReceta, @idMedicamento, @cantidad);

    -- Actualizar inventario
    UPDATE Inventario
    SET CantidadDisp = CantidadDisp - @cantidad
    WHERE idMedicamento = @idMedicamento;

    -- Opcional: Cambiar estado si se agot�
    UPDATE Inventario
    SET Estado = 'Agotado'
    WHERE idMedicamento = @idMedicamento AND CantidadDisp <= 0;
END;
go

create PROC Respaldo @Ruta nvarchar(150), @NuevoNom nvarchar(80)
as
begin

    DECLARE @sentencia nvarchar(max)
	declare @Nombre nvarchar(80)

	select @Nombre='hos'

    -- Agregar comillas y extensi�n .bak correctamente
    SET @sentencia = 'BACKUP DATABASE [' + @Nombre + '] TO DISK = '''  + @Ruta + '\' + @NuevoNom + '.bak''  WITH NOFORMAT, NOINIT, NAME = ''' 
	+ @NuevoNom + ''',  SKIP, NOREWIND, NOUNLOAD, STATS = 10'

    EXEC(@sentencia)
END

GO

-------------------------------------------------------------------------------------------------------------------------------
----------------------------------------AUDITORIAS-----------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

-- Crea una tabla para registrar los movimientos realizados en las tablas auditadas
--Tabla
create table bitacora_movimientos(
fecha datetime primary key,             -- Fecha y hora del movimiento
tabla varchar(100),                     -- Nombre de la tabla afectada
tipo_movimiento varchar(30),            -- Tipo de operaci n: INSERT, UPDATE o DELETE
usuario varchar(50),                    -- Usuario del sistema que realiz  el cambio
app varchar (200),                      -- Aplicaci n que ejecut  el cambio
host varchar(50),                       -- Nombre del equipo desde donde se ejecut 
registro_anterior varchar(max),         -- Datos antes del cambio (en caso de UPDATE o DELETE)
registro_nuevo varchar(max))            -- Datos despu s del cambio (en caso de INSERT o UPDATE)
GO 


----------------------PACIENTES------------------------------------------------------------
-- Trigger para auditar cambios en la tabla Pacientes
CREATE TRIGGER TR_AUDI_PACIENTES
ON Pacientes
FOR insert, update, delete
AS
BEGIN

    -- Evita mostrar mensajes de conteo de filas
    SET NOCOUNT OFF;

	    -- Variables para almacenar los datos antiguos y nuevos
	DECLARE @REG NVARCHAR(MAX);
	DECLARE @REGANT NVARCHAR(MAX)

	    -- Captura los datos eliminados o anteriores (para UPDATE o DELETE)
	SELECT @REGANT=(SELECT * FROM deleted FOR JSON AUTO)
	    -- Captura los datos nuevos (para INSERT o UPDATE)
	SELECT @REG = (SELECT * FROM inserted FOR JSON AUTO)

	    -- Si hay datos nuevos y no hay datos anteriores, es un INSERT
	IF(@REG is not null AND @REGANT is null)
		BEGIN
			INSERT INTO bitacora_movimientos
			VALUES (GETDATE(),'Pacientes','INSERT',SYSTEM_USER,APP_NAME(),HOST_NAME(),NULL,@REG);
		END
		    -- Si hay datos anteriores y nuevos, es un UPDATE
	ELSE IF(@REG is not null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Pacientes','UPDATE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,@REG);
		END
		    -- Si solo hay datos anteriores, es un DELETE
	ELSE IF(@REG is null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Pacientes','DELETE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,NULL);
		END
END
GO


---------------------MEDICAMENTOS------------------------------------------------------------
-- Trigger para auditar cambios en la tabla Medicamentos
create TRIGGER TR_AUDI_MEDICAMENTOS
ON Medicamentos
FOR insert, update, delete
AS
BEGIN

    -- Evita que se muestre el n mero de filas afectadas
    SET NOCOUNT OFF;

	    -- Variables para guardar datos nuevos y anteriores en formato 
	DECLARE @REG NVARCHAR(MAX);
	DECLARE @REGANT NVARCHAR(MAX)

	    -- Obtiene los datos eliminados o anteriores (para DELETE y UPDATE)
	SELECT @REGANT=(SELECT * FROM deleted FOR JSON AUTO)
	-- Obtiene los datos insertados o nuevos (para INSERT y UPDATE)
	SELECT @REG = (SELECT * FROM inserted FOR JSON AUTO)

	    -- Si solo hay datos nuevos, es un INSERT
	IF(@REG is not null AND @REGANT is null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Medicamentos','INSERT',SYSTEM_USER,APP_NAME(),HOST_NAME(),NULL,@REG);
		END
		    -- Si hay datos nuevos y anteriores, es un UPDATE
	ELSE IF(@REG is not null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Medicamentos','UPDATE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,@REG);
		END
		    -- Si solo hay datos anteriores, es un DELETE
	ELSE IF(@REG is null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos
			VALUES (GETDATE(),'Medicamentos','DELETE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,NULL);
		END
END
GO


---------------------MEDICOS------------------------------------------------------------
-- Trigger para auditar cambios en la tabla Medicos
CREATE TRIGGER TR_AUDI_MEDICOS
ON Medicos
FOR insert, update, delete
AS
BEGIN

    -- Evita mostrar mensajes de conteo de filas
    SET NOCOUNT OFF;

	    -- Variables para almacenar los datos antiguos y nuevos
	DECLARE @REG NVARCHAR(MAX);
	DECLARE @REGANT NVARCHAR(MAX)

	    -- Captura los datos eliminados o anteriores (para UPDATE o DELETE)
	SELECT @REGANT=(SELECT * FROM deleted FOR JSON AUTO)
	    -- Captura los datos nuevos (para INSERT o UPDATE)
	SELECT @REG = (SELECT * FROM inserted FOR JSON AUTO)

	    -- Si hay datos nuevos y no hay datos anteriores, es un INSERT
	IF(@REG is not null AND @REGANT is null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Medicos','INSERT',SYSTEM_USER,APP_NAME(),HOST_NAME(),NULL,@REG);
		END
		    -- Si hay datos anteriores y nuevos, es un UPDATE
	ELSE IF(@REG is not null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Medicos','UPDATE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,@REG);
		END
		    -- Si solo hay datos anteriores, es un DELETE
	ELSE IF(@REG is null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Medicos','DELETE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,NULL);
		END
END
GO


---------------------INVENTARIO------------------------------------------------------------
-- Trigger para auditar cambios en la tabla Inventario
CREATE TRIGGER TR_AUDI_INVENTARIO
ON Inventario
FOR insert, update, delete
AS
BEGIN

    -- Desactiva el conteo autom tico de filas
    SET NOCOUNT OFF;

	    -- Variables para guardar los registros nuevos y anteriores en formato JSON
	DECLARE @REG NVARCHAR(MAX);
	DECLARE @REGANT NVARCHAR(MAX)

	    -- Captura los datos eliminados o anteriores (DELETE o UPDATE)
	SELECT @REGANT=(SELECT * FROM deleted FOR JSON AUTO)
	    -- Captura los datos insertados o nuevos (INSERT o UPDATE)
	SELECT @REG = (SELECT * FROM inserted FOR JSON AUTO)

	    -- Si hay datos nuevos pero no anteriores, es un INSERT
	IF(@REG is not null AND @REGANT is null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Inventario','INSERT',SYSTEM_USER,APP_NAME(),HOST_NAME(),NULL,@REG);
		END
		    -- Si hay datos nuevos y anteriores, es un UPDATE
	ELSE IF(@REG is not null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Inventario','UPDATE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,@REG);
		END
		    -- Si solo hay datos anteriores, es un DELETE
	ELSE IF(@REG is null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Inventario','DELETE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,NULL);
		END
END
GO


---------------------CITAS------------------------------------------------------------
-- Trigger para auditar cambios en la tabla Citas


CREATE TRIGGER TR_UP_AUDI_CITAS
ON Citas 
FOR UPDATE, INSERT, DELETE
AS
BEGIN

    -- Desactiva el conteo autom tico de filas
    SET NOCOUNT OFF;

	    -- Variables para guardar los registros nuevos y anteriores en formato JSON
	DECLARE @REG NVARCHAR(MAX);
	DECLARE @REGANT NVARCHAR(MAX)

	    -- Captura los datos eliminados o anteriores (DELETE o UPDATE)
	SELECT @REGANT=(SELECT * FROM deleted FOR JSON AUTO)
	    -- Captura los datos insertados o nuevos (INSERT o UPDATE)
	SELECT @REG = (SELECT * FROM inserted FOR JSON AUTO)

	    -- Si hay datos nuevos pero no anteriores, es un INSERT
	IF(@REG is not null AND @REGANT is null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Citas','INSERT',SYSTEM_USER,APP_NAME(),HOST_NAME(),NULL,@REG);
		END
		    -- Si hay datos nuevos y anteriores, es un UPDATE
	ELSE IF(@REG is not null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Citas','UPDATE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,@REG);
		END
		    -- Si solo hay datos anteriores, es un DELETE
	ELSE IF(@REG is null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Citas','DELETE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,NULL);
		END
END
GO

---------------------CONSULTAS------------------------------------------------------------
-- Trigger para auditar cambios en la tabla Consultas

CREATE TRIGGER TR_UP_AUDI_CONSULTAS
ON Consultas 
FOR UPDATE, INSERT, DELETE
AS
BEGIN

    -- Desactiva el conteo autom tico de filas
    SET NOCOUNT OFF;

	    -- Variables para guardar los registros nuevos y anteriores en formato JSON
	DECLARE @REG NVARCHAR(MAX);
	DECLARE @REGANT NVARCHAR(MAX)

	    -- Captura los datos eliminados o anteriores (DELETE o UPDATE)
	SELECT @REGANT=(SELECT * FROM deleted FOR JSON AUTO)
	    -- Captura los datos insertados o nuevos (INSERT o UPDATE)
	SELECT @REG = (SELECT * FROM inserted FOR JSON AUTO)

	    -- Si hay datos nuevos pero no anteriores, es un INSERT
	IF(@REG is not null AND @REGANT is null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Consultas','INSERT',SYSTEM_USER,APP_NAME(),HOST_NAME(),NULL,@REG);
		END
		    -- Si hay datos nuevos y anteriores, es un UPDATE
	ELSE IF(@REG is not null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Consultas','UPDATE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,@REG);
		END
		    -- Si solo hay datos anteriores, es un DELETE
	ELSE IF(@REG is null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Consultas','DELETE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,NULL);
		END
END
GO

---------------------RECETAS------------------------------------------------------------
-- Trigger para auditar cambios en la tabla Recetas

CREATE TRIGGER TR_UP_AUDI_RECETAS
ON Recetas
FOR UPDATE, INSERT, DELETE
AS
BEGIN

    -- Desactiva el conteo autom tico de filas
    SET NOCOUNT OFF;

	    -- Variables para guardar los registros nuevos y anteriores en formato JSON
	DECLARE @REG NVARCHAR(MAX);
	DECLARE @REGANT NVARCHAR(MAX)

	    -- Captura los datos eliminados o anteriores (DELETE o UPDATE)
	SELECT @REGANT=(SELECT * FROM deleted FOR JSON AUTO)
	    -- Captura los datos insertados o nuevos (INSERT o UPDATE)
	SELECT @REG = (SELECT * FROM inserted FOR JSON AUTO)

	    -- Si hay datos nuevos pero no anteriores, es un INSERT
	IF(@REG is not null AND @REGANT is null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Recetas','INSERT',SYSTEM_USER,APP_NAME(),HOST_NAME(),NULL,@REG);
		END
		    -- Si hay datos nuevos y anteriores, es un UPDATE
	ELSE IF(@REG is not null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Recetas','UPDATE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,@REG);
		END
		    -- Si solo hay datos anteriores, es un DELETE
	ELSE IF(@REG is null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'Recetas','DELETE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,NULL);
		END
END
GO

---------------------RECETAMEDICAMENTOS------------------------------------------------------------
-- Trigger para auditar cambios en la tabla RecetaMedicamentos

CREATE TRIGGER TR_UP_AUDI_RECETASMEDICAMENTOS
ON RecetaMedicamentos
FOR UPDATE, INSERT, DELETE
AS
BEGIN

    -- Desactiva el conteo autom tico de filas
    SET NOCOUNT OFF;

	    -- Variables para guardar los registros nuevos y anteriores en formato JSON
	DECLARE @REG NVARCHAR(MAX);
	DECLARE @REGANT NVARCHAR(MAX)

	    -- Captura los datos eliminados o anteriores (DELETE o UPDATE)
	SELECT @REGANT=(SELECT * FROM deleted FOR JSON AUTO)
	    -- Captura los datos insertados o nuevos (INSERT o UPDATE)
	SELECT @REG = (SELECT * FROM inserted FOR JSON AUTO)

	    -- Si hay datos nuevos pero no anteriores, es un INSERT
	IF(@REG is not null AND @REGANT is null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'RecetaMedicamentos','INSERT',SYSTEM_USER,APP_NAME(),HOST_NAME(),NULL,@REG);
		END
		    -- Si hay datos nuevos y anteriores, es un UPDATE
	ELSE IF(@REG is not null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'RecetaMedicamentos','UPDATE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,@REG);
		END
		    -- Si solo hay datos anteriores, es un DELETE
	ELSE IF(@REG is null AND @REGANT is not null)
		BEGIN
			INSERT INTO bitacora_movimientos 
			VALUES (GETDATE(),'RecetaMedicamentos','DELETE',SYSTEM_USER,APP_NAME(),HOST_NAME(),@REGANT,NULL);
		END
END
GO
------------------------------------------------------------------------------------------------------------------------------

USE [master]
GO
CREATE LOGIN [uh] WITH PASSWORD=N'admin123', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE hos
GO

CREATE USER uh FOR LOGIN uh;
GO

GRANT EXECUTE ON SCHEMA::dbo TO uh;

EXEC sp_addrolemember 'db_datawriter', uh; -- Rol a usuario uh para esritura
EXEC sp_addrolemember 'db_datareader', uh; -- Rol a usuario uh para lectura
EXEC sp_addrolemember 'db_backupoperator', uh; -- Rol a usuario uh para respaldos


