CREATE DATABASE COMPUTADORABS
CREATE TABLE COMPUTADORA (
    IDCOMPUTADORA INT IDENTITY (1,1) NOT NULL,
    NOMBRE NVARCHAR(50),
    DESCRIPCION NVARCHAR(100),
    PRECIO MONEY NOT NULL,
    FECHAFABRICACION DATETIME NOT NULL,
	PRIMARY KEY (IDCOMPUTADORA)
);

insert into COMPUTADORA values ('MacBook Pro', 'Laptop de gama alta de Apple', 2399, '2022-01-09 12:47:29');
insert into COMPUTADORA values ('Dell XPS 15', 'Portátil premium para usuarios exigentes', 1999,'2022-07-22 09:47:29');
insert into COMPUTADORA values ('Microsoft Surface Laptop', 'Portátil elegante con pantalla táctil', 1300, '2022-03-08 12:47:29');
insert into COMPUTADORA values ('HP ZBook Studio', 'Estación de trabajo móvil potente', 3000, '2022-01-10 16:47:29');
insert into COMPUTADORA values ('ASUS ROG Strix Scar', 'Laptop para juegos con potencia y estilo', 2200, '2022-01-09 13:47:29');
insert into COMPUTADORA values ('Lenovo ThinkPad X1 Carbon', 'Portátil empresarial ultraligero y duradero', 1900, '2023-05-11 07:47:29');
insert into COMPUTADORA values ('HP Pavilion All-in-One', 'PC todo en uno para entretenimiento multimedia', 1100, '2023-09-12 12:47:29');
insert into COMPUTADORA values ('Dell Precision 7550', 'Estación de trabajo móvil para profesionales creativos', 3200, '2023-11-06 19:47:29');


CREATE TABLE USUARIOCOM (
IDUSUARIO INT IDENTITY (1,1) NOT NULL,
IDCOMPUTADORA INT NOT NULL,
NOMBREUSER NVARCHAR (50) NOT NULL,
CONTRASEÑA NVARCHAR (50) NOT NULL,
FECHAREG DATETIME NOT NULL,
PRIMARY KEY (IDUSUARIO),
FOREIGN KEY (IDCOMPUTADORA) REFERENCES COMPUTADORA (IDCOMPUTADORA)
);
insert into USUARIOCOM values (1, 'pedro', '6841', '2022-01-12 14:47:29');
insert into USUARIOCOM values (3, 'alejandro', '9189', '2022-03-10 17:40:29');
insert into USUARIOCOM values (5, 'bruno', '2664', '2022-02-11 08:30:29');
insert into USUARIOCOM  values (6, 'carla', '7655', '2023-06-08 19:48:00');
insert into USUARIOCOM values (8, 'sebastian', '9048', '2023-12-07 10:15:20');
insert into USUARIOCOM values (4, 'ana', '5539', '2022-03-12 13:47:12');
insert into USUARIOCOM values (10, 'roberto', '7655', '2024-03-10 17:40:29');
insert into USUARIOCOM values (7, 'esther', '7233', '2022-04-10 21:47:08');
select* from COMPUTADORA
 select* from USUARIOCOM
 delete from USUARIOCOM where IDUSUARIO=24
 SELECT * FROM sys.dm_exec_sessions WHERE session_id = @@SPID;
