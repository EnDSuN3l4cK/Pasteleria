DROP DATABASE IF EXISTS Pasteleria;
CREATE DATABASE Pasteleria;
USE Pasteleria;

-- Tabla de Empleados
CREATE TABLE Empleado(
    NumPersonal INT NOT NULL,
    Nombre VARCHAR(30) NOT NULL,
    ApePaterno VARCHAR(30) NOT NULL,
    ApeMaterno VARCHAR(30) NOT NULL,
    TelPersonal VARCHAR(15) NOT NULL,
    TelCasa VARCHAR(15) NOT NULL,
    PRIMARY KEY (NumPersonal)
);

-- Tabla de Contratos
CREATE TABLE Contrato (
    FechaContrato DATE NOT NULL,
    FrecuenciaDePago VARCHAR(30) NOT NULL,
    SueldoBase DECIMAL(10,2) NOT NULL,
    HoraEntrada TIME NOT NULL,
    HoraSalida TIME NOT NULL,
    Turno VARCHAR(30) NOT NULL,
    NumPersonal INT NOT NULL,
    PRIMARY KEY (NumPersonal, FechaContrato),
    FOREIGN KEY (NumPersonal) REFERENCES Empleado(NumPersonal)
);

-- Tabla de Clientes
CREATE TABLE Clientes (
    RFC VARCHAR(13) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellido_Paterno VARCHAR(50) NOT NULL,
    Apellido_Materno VARCHAR(50) NOT NULL,
    Calle VARCHAR(50) NOT NULL,
    Num_Calle INT NOT NULL,
    Colonia VARCHAR(50) NOT NULL,
    Codigo_Postal VARCHAR(10) NOT NULL,
    Alcaldia VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Telefono VARCHAR(15),
    PRIMARY KEY (RFC)
);

-- Tabla de Productos
CREATE TABLE Productos (
    ID_producto INT NOT NULL,
    Nombre_del_producto VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Categoria VARCHAR(30) NOT NULL,
    Cantidad_de_personas INT,
    Temporada VARCHAR(30),
    Precio_de_venta DECIMAL(10,2) NOT NULL,
    Existencias INT NOT NULL,
    PRIMARY KEY (ID_producto)
);

-- Tabla de Ventas
CREATE TABLE Ventas (
    NumVenta INT NOT NULL,
    NumPersonal INT NOT NULL,
    FechaHora DATETIME NOT NULL,
    SUBTOTAL DECIMAL(10,2) NOT NULL,
    IVA DECIMAL(10,2) NOT NULL,
    TOTAL DECIMAL(10,2) NOT NULL,
    RFC VARCHAR(13),
    MetodoPago VARCHAR(30) NOT NULL,
    PRIMARY KEY (NumVenta),
    FOREIGN KEY (NumPersonal) REFERENCES Empleado(NumPersonal),
    FOREIGN KEY (RFC) REFERENCES Clientes(RFC)
);

-- Tabla de Productos Vendidos
CREATE TABLE ProductosVendidos (
    NumVenta INT NOT NULL,
    ID_producto INT NOT NULL,
    Cantidadpz INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (NumVenta, ID_producto),
    FOREIGN KEY (NumVenta) REFERENCES Ventas(NumVenta),
    FOREIGN KEY (ID_producto) REFERENCES Productos(ID_producto)
);

-- Tabla de Pedidos
CREATE TABLE Pedido (
    NumPedido INT NOT NULL,
    Estatus VARCHAR(20) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    ApePaterno VARCHAR(50) NOT NULL,
    ApeMaterno VARCHAR(50) NOT NULL,
    TelPersonal VARCHAR(15) NOT NULL,
    TelCasa VARCHAR(15) NOT NULL,
    FechaPedido DATE NOT NULL,
    FechaEntrega DATE NOT NULL,
    Precio DECIMAL(10,2),
    RFC VARCHAR(13),
    PRIMARY KEY (NumPedido),
    FOREIGN KEY (RFC) REFERENCES Clientes(RFC)
);

-- Tabla de Pasteles Personalizados
CREATE TABLE PastelPedido (
    NumPastelPedido INT NOT NULL,
    NumPedido INT NOT NULL,
    CantidadPersonas INT NOT NULL,
    Categoria VARCHAR(50) NOT NULL,
    TipoPan VARCHAR(50) NOT NULL,
    TipoRelleno VARCHAR(50),
    TipoCobertura VARCHAR(50),
    Decoracion VARCHAR(50),
    Comentarios TEXT,
    PRIMARY KEY (NumPastelPedido),
    FOREIGN KEY (NumPedido) REFERENCES Pedido(NumPedido)
);

-- Tabla de Entregas
CREATE TABLE Entrega (
    NumPedido INT NOT NULL,
    Calle VARCHAR(50) NOT NULL,
    Numero INT NOT NULL,
    Colonia VARCHAR(50) NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    CP VARCHAR(10) NOT NULL,
    Instrucciones TEXT,
    PRIMARY KEY (NumPedido),
    FOREIGN KEY (NumPedido) REFERENCES Pedido(NumPedido)
);

-- Tabla de Usuarios del Sistema
CREATE TABLE Usuarios (
    ID_Usuario INT NOT NULL,
    Correo VARCHAR(100) NOT NULL,
    Contraseña VARCHAR(255) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Rol ENUM('cliente', 'empleado', 'admin') NOT NULL,
    FechaRegistro DATE NOT NULL,
    UltimoAcceso DATETIME,
    Activo BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (ID_Usuario),
    UNIQUE (Correo)
);

-- Tabla de relación Usuario-Cliente
CREATE TABLE UsuarioCliente (
    ID_Usuario INT NOT NULL,
    RFC VARCHAR(13) NOT NULL,
    PRIMARY KEY (ID_Usuario, RFC),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario),
    FOREIGN KEY (RFC) REFERENCES Clientes(RFC)
);

-- Tabla de relación Usuario-Empleado
CREATE TABLE UsuarioEmpleado (
    ID_Usuario INT NOT NULL,
    NumPersonal INT NOT NULL,
    PRIMARY KEY (ID_Usuario, NumPersonal),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario),
    FOREIGN KEY (NumPersonal) REFERENCES Empleado(NumPersonal)
);

-- Insertar datos de empleados
INSERT INTO Empleado (NumPersonal, Nombre, ApePaterno, ApeMaterno, TelPersonal, TelCasa) VALUES
(1, 'Fernando', 'Acevedo', 'Martinez', '5551234567', '5553219876'),
(2, 'Carolina', 'Juarez', 'Hernandez', '5559876543', '5557778888'),
(3, 'Brenda', 'Flores', 'Lopez', '5585554755', '5552345678'),
(4, 'Ivan', 'Torres', 'Montiel', '5558889999', '5558901234'),
(5, 'David', 'Silva', 'Hernandez', '5554567890', '5571650511');

-- Insertar contratos
INSERT INTO Contrato (FechaContrato, FrecuenciaDePago, SueldoBase, HoraEntrada, HoraSalida, Turno, NumPersonal) VALUES
('2024-02-06', 'Semanal', 14000.00, '08:30:00', '15:00:00', 'Matutino', 1),
('2024-02-08', 'Semanal', 14000.00, '15:00:00', '21:00:00', 'Vespertino', 2),
('2024-02-06', 'Quincenal', 8000.00, '08:30:00', '15:00:00', 'Matutino', 3),
('2024-02-07', 'Quincenal', 8000.00, '15:00:00', '21:00:00', 'Vespertino', 4),
('2024-03-09', 'Quincenal', 8000.00, '15:00:00', '21:00:00', 'Vespertino', 5);

-- Insertar clientes
INSERT INTO Clientes (RFC, Nombre, Apellido_Paterno, Apellido_Materno, Calle, Num_Calle, Colonia, Codigo_Postal, Alcaldia, Email, Telefono) VALUES
('MARA950101ABC', 'Alicia', 'Martinez', 'Ramos', 'Av. Insurgentes', 123, 'Roma Norte', '06700', 'Cuauhtemoc', 'alicia.martinez@email.com', '5551112233'),
('DOTX890101BEF', 'Oscar', 'Dorantes', 'Torres', 'Juarez', 456, 'Centro Historico', '06000', 'Cuauhtemoc', 'oscar.dorantes@email.com', '5552223344'),
('MEJE850101GHI', 'Jesus', 'Mendez', 'Esparza', 'Av. Revolucion', 789, 'San Angel', '01000', 'Alvaro Obregon', 'jesus.mendez@email.com', '5553334455'),
('OITA840101JKL', 'Saul', 'Olivares', 'Torres', 'Monterrey', 246, 'Roma Sur', '06760', 'Cuauhtemoc', 'saul.olivares@email.com', '5554445566'),
('GOZK930101NMO', 'Karen', 'Gomez', 'Lopez', 'Av. Universidad', 135, 'Narvarte', '03020', 'Benito Juarez', 'karen.gomez@email.com', '5555556677'),
('TOSM920103PQR', 'Maria', 'Tolentino', 'Suaso', 'Tamaulipas', 789, 'Condesa', '06140', 'Cuauhtemoc', 'maria.tolentino@email.com', '5556667788');

-- Insertar productos
INSERT INTO Productos (ID_producto, Nombre_del_producto, Descripcion, Categoria, Cantidad_de_personas, Temporada, Precio_de_venta, Existencias) VALUES 
(12, 'Tiramisú', 'Capas de bizcochos de soletilla empapados en café y crema de mascarpone espolvoreado con cacao en polvo.', 'Pastel', 15, 'Anual', 700.00, 8),
(13, 'Pastel de Chocolate', 'Esponjoso pastel de cacao cubierto con ganache de chocolate.', 'Pastel', 20, 'Anual', 350.00, 15),
(14, 'Pastel Tres Leches', 'Un pastel esponjoso empapado en una mezcla de tres tipos de leche (leche evaporada, leche condensada y crema de leche).', 'Pastel', 20, 'Anual', 300.00, 9),
(15, 'Chocoflan', 'La parte superior es un suave y cremoso flan de vainilla, mientras que la parte inferior es un bizcocho de chocolate.', 'Pastel', 15, 'Anual', 400.00, 10),
(16, 'Pastel de Oreo', 'Consiste en varias capas de bizcocho de vainilla, intercaladas con capas de crema de Oreo una mezcla de crema de queso.', 'Pastel', 15, 'Anual', 600.00, 2);

-- Insertar ventas
INSERT INTO Ventas (NumVenta, NumPersonal, FechaHora, SUBTOTAL, IVA, TOTAL, RFC, MetodoPago) VALUES
(1, 3, '2024-03-24 09:30:00', 1200.00, 192.00, 1392.00, NULL, 'Efectivo'),
(2, 3, '2024-03-24 10:30:00', 1440.00, 230.40, 1670.40, NULL, 'Tarjeta'),
(3, 3, '2024-03-24 09:40:00', 900.00, 144.00, 1044.00, 'MEJE850101GHI', 'Efectivo');

-- Insertar productos vendidos
INSERT INTO ProductosVendidos (NumVenta, ID_producto, Cantidadpz, PrecioUnitario, Subtotal) VALUES 
(1, 12, 1, 700.00, 700.00),
(1, 13, 1, 350.00, 350.00),
(2, 12, 2, 700.00, 1400.00),
(3, 14, 3, 300.00, 900.00);

-- Insertar pedidos
INSERT INTO Pedido (NumPedido, Estatus, Nombre, ApePaterno, ApeMaterno, TelPersonal, TelCasa, FechaPedido, FechaEntrega, Precio, RFC) VALUES
(1, 'En proceso', 'Andrea', 'Rojas', 'Calderon', '5546474950', '5512345678', '2024-03-24', '2024-04-01', 1200.00, NULL),
(2, 'Entregado', 'Felipe', 'Ramirez', 'Perez', '5597632144', '5523456789', '2024-03-24', '2024-04-02', 900.00, NULL),
(3, 'Cancelado', 'Alejandra', 'Florez', 'Tapia', '5574300145', '5545678901', '2024-03-24', '2024-04-03', 100.00, NULL);

-- Insertar pasteles personalizados
INSERT INTO PastelPedido (NumPastelPedido, NumPedido, CantidadPersonas, Categoria, TipoPan, TipoRelleno, TipoCobertura, Decoracion, Comentarios) VALUES
(1, 1, 100, 'Pastel', '3 leches', 'Frutas', 'Betun clasico', 'Plin Plin', 'Imagenes comestibles'),
(2, 2, 90, 'Pastel', 'Red velvet', 'Frutos rojos', 'Betun queso crema', 'Elegante', 'Pastel alto');

-- Insertar entregas
INSERT INTO Entrega (NumPedido, Calle, Numero, Colonia, Estado, CP, Instrucciones) VALUES
(1, 'Reforma', 123, 'Juarez', 'Ciudad de México', '06600', 'Dejar con el portero'),
(2, 'Av. Insurgentes', 456, 'Condesa', 'Ciudad de México', '06140', 'Llamar antes de llegar');

-- Insertar usuarios
INSERT INTO Usuarios (ID_Usuario, Correo, Contraseña, Nombre, Rol, FechaRegistro, UltimoAcceso, Activo) VALUES
(1, 'admin@pasteleria.com', '$2a$10$xJwL5v9zJvQ6zqU9XcXZ3uJ1WQ2rV9YbW3dK7vN8mR1tS2uV3w4y5', 'Administrador', 'admin', '2024-01-01', NOW(), TRUE),
(2, 'empleado1@pasteleria.com', '$2a$10$xJwL5v9zJvQ6zqU9XcXZ3uJ1WQ2rV9YbW3dK7vN8mR1tS2uV3w4y5', 'Fernando Acevedo', 'empleado', '2024-02-06', NOW(), TRUE);

-- Relacionar usuarios con empleados
INSERT INTO UsuarioEmpleado (ID_Usuario, NumPersonal) VALUES
(2, 1);

-- Crear vistas útiles
CREATE VIEW VistaVentasDetalladas AS
SELECT v.NumVenta, v.FechaHora, e.Nombre AS Empleado, 
       c.Nombre AS Cliente, v.TOTAL, v.MetodoPago
FROM Ventas v
JOIN Empleado e ON v.NumPersonal = e.NumPersonal
LEFT JOIN Clientes c ON v.RFC = c.RFC;

CREATE VIEW VistaInventarioBajo AS
SELECT ID_producto, Nombre_del_producto, Existencias
FROM Productos
WHERE Existencias < 5;

-- Crear procedimientos almacenados
DELIMITER //

CREATE PROCEDURE ActualizarPrecioProducto(IN producto_id INT, IN nuevo_precio DECIMAL(10,2))
BEGIN
    UPDATE Productos 
    SET Precio_de_venta = nuevo_precio 
    WHERE ID_producto = producto_id;
END //

CREATE PROCEDURE ObtenerVentasPorFecha(IN fecha_inicio DATE, IN fecha_fin DATE)
BEGIN
    SELECT * FROM Ventas 
    WHERE DATE(FechaHora) BETWEEN fecha_inicio AND fecha_fin;
END //

DELIMITER ;
INSERT INTO Usuarios (ID_Usuario, Correo, Contraseña, Nombre, Rol, FechaRegistro, UltimoAcceso, Activo) VALUES
(3, 'cliente1@pasteleria.com', '1234', 'Ana Ramírez', 'cliente', '2024-03-15', NOW(), TRUE),
(4, 'cliente2@pasteleria.com', '1235', 'Luis Hernández', 'cliente', '2024-03-20', NOW(), TRUE);
update usuarios
set Contraseña = '$2b$12$FJDo7NPsPBAHPg06LtJ0zeiVmU9FZf4sX5bVJkBJPL70vUlyI1G2e'
where ID_Usuario = 3;
update usuarios
set Contraseña = '$2b$12$EfL5sY88vdPKz1QoMPINjeBDADYrTyqUlnJThKaG4emPDNW5W0BoG'
where ID_Usuario = 4;
-- Contraseñas "1234" y "1235" en bcrypt:
-- Generadas con bcrypt.hashpw(b"1234", bcrypt.gensalt()).decode()

select * from usuarios;

-- 1. Primero eliminar las restricciones de clave foránea que dependen de ID_Usuario
ALTER TABLE UsuarioCliente DROP FOREIGN KEY usuariocliente_ibfk_1;
ALTER TABLE UsuarioEmpleado DROP FOREIGN KEY usuarioempleado_ibfk_1;

-- 2. Modificar la columna ID_Usuario para que sea AUTO_INCREMENT
ALTER TABLE Usuarios 
MODIFY COLUMN ID_Usuario INT NOT NULL AUTO_INCREMENT;

-- 3. Volver a crear las restricciones de clave foránea
ALTER TABLE UsuarioCliente 
ADD CONSTRAINT usuariocliente_ibfk_1 
FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario);

ALTER TABLE UsuarioEmpleado 
ADD CONSTRAINT usuarioempleado_ibfk_1 
FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario);


