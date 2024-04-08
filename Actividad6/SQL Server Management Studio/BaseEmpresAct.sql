CREATE DATABASE EMPRESABD;

CREATE TABLE CLIENTE (
IDCLIENTE INT IDENTITY (1,1) NOT NULL,
NOMBRE NVARCHAR (50) NOT NULL,
APELLIDO NVARCHAR (50) NOT NULL,
CORREO NVARCHAR (20) NULL,
TELEFONO NVARCHAR (50) NULL,
DIRECCION NVARCHAR (50) NOT NULL,
PRIMARY KEY (IDCLIENTE),
);

insert into CLIENTE values ('Carla' ,'García' ,'carla@gmail.com' ,'+59164738291', 'B. San Mateo');
insert into CLIENTE values ('Emma' ,'Álvarez' ,'emma@gmail.com' ,'+59161472583', 'B. Las Panosas');
insert into CLIENTE values ('Diego' ,'Sánchez' ,'diego@gmail.com' ,'+59171345678', 'B. Trigal');
insert into CLIENTE values ('Sonia' ,'Herrera' ,'sonia@gmail.com','+59168294731', 'B. La Loma');
insert into CLIENTE values ('Olivia' ,'Romero' ,'olivia@gmail.com','+59172938475', 'B. Senac');
insert into CLIENTE values ('Víctor' ,'Reyes' ,'victor@gmail.com','+59169123487', 'B. Juan XXIII');
insert into CLIENTE values ('Nicolás' ,'Flores' ,'nicolas@gmail.com','+59165432198', 'B. Avaroa');
insert into CLIENTE values ('Jorge' ,'Morales' ,'jorge@gmail.com','+59169485732', 'B. Los Chapacos');
insert into CLIENTE values ('Tomás' ,'Soto' ,'tomas@gmail.com','+59165837492', 'B. San Geronimo');
insert into CLIENTE values ('Karen' ,'Vargas' ,'karen@gmail.com','+59161293847', 'B. San Jorge II' );
insert into CLIENTE values ('Gloria' ,'Díaz' ,'gloria@gmail.com','+59176294837', 'B. Constructor');
insert into CLIENTE values ('Pablo' ,'Ortiz' ,'pablo@gmail.com','+59169384752', 'B. 3 de Mayo');

select* from CLIENTE

CREATE TABLE PEDIDO (
IDPEDIDO INT IDENTITY (1,1) NOT NULL,
IDCLIENTE INT NOT NULL,
FECHA DATETIME NOT NULL,
TOTAL MONEY NOT NULL,
ESTADO NVARCHAR(20)NOT NULL,
PRIMARY KEY (IDPEDIDO),
FOREIGN KEY (IDCLIENTE) REFERENCES CLIENTE(IDCLIENTE)
);

insert into PEDIDO values (1, CONVERT(datetime, '2022-02-01 14:00:00',120), 100, 'Exitoso');
insert into PEDIDO values (2, CONVERT(datetime, '2022-02-23 13:50:00',120), 67, 'Exitoso');
insert into PEDIDO values (3, CONVERT(datetime, '2022-03-15 09:20:00',120), 52, 'Exitoso');
insert into PEDIDO values (4, CONVERT(datetime, '2022-05-20 18:25:00',120), 10, 'Exitoso');
insert into PEDIDO values (5, CONVERT(datetime, '2022-06-06 12:32:00',120), 28, 'Exitoso');
insert into PEDIDO values (6, CONVERT(datetime, '2022-08-14 12:01:00',120), 90, 'Exitoso');
insert into PEDIDO values (7, CONVERT(datetime, '2022-09-30 11:28:00',120), 16, 'Exitoso');
insert into PEDIDO values (8, CONVERT(datetime, '2022-12-27 10:15:00',120), 45, 'Exitoso');
insert into PEDIDO values (9, CONVERT(datetime, '2023-02-22 08:41:00',120), 18, 'Exitoso');
insert into PEDIDO values (10, CONVERT(datetime, '2023-02-24 11:57:00',120), 34, 'Exitoso');
insert into PEDIDO values (11, CONVERT(datetime, '2023-05-24 17:00:00',120), 20, 'Exitoso');
insert into PEDIDO values (12, CONVERT(datetime, '2023-05-01 14:30:00',120), 10, 'Exitoso');
insert into PEDIDO values (2, CONVERT(datetime, '2023-02-12 10:50:00',120), 12, 'Exitoso');
insert into PEDIDO values (3, CONVERT(datetime, '2023-01-15 16:20:00',120), 22, 'Exitoso');
insert into PEDIDO values (4, CONVERT(datetime, '2022-08-20 08:25:00',120), 89, 'Exitoso');
insert into PEDIDO values (3, CONVERT(datetime, '2023-04-09 17:30:00',120), 22, 'Exitoso');
insert into PEDIDO values (4, CONVERT(datetime, '2023-09-12 19:48:00',120), 89, 'Exitoso');
select*from PEDIDO