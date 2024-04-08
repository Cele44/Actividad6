
/*1.Calcular el promedio de ventas mensuales para cada categoría de productos. */
SELECT CategoryName,MONTH(OrderDate)NUM_MES,Round(AVG(OD.Quantity*OD.UnitPrice*(1-Discount)),2)PROMEDIO_VENTA_MENSUAL
FROM Categories C
INNER JOIN Products P ON C.CategoryID=P.CategoryID
INNER JOIN [Order Details]OD ON P.ProductID=OD.ProductID
INNER JOIN Orders O ON OD.OrderID=O.OrderID AND YEAR(OrderDate)=1996---PARA COLOCAR EL AÑO DEL CUAL DESEA
GROUP BY CategoryName,MONTH(OrderDate)
ORDER BY CategoryName,PROMEDIO_VENTA_MENSUAL DESC

/*2.Identificar los clientes que han realizado más de 5 pedidos en los últimos 3 meses*/
SELECT O.CustomerID,MONTH(O.OrderDate) MES,COUNT(O.OrderID)PEDIDOS
FROM Customers C
INNER JOIN Orders O ON C.CustomerID=O.CustomerID 
WHERE MONTH(OrderDate) IN (1,2,3)   --TODOS LOS MESES BETWEEN 1 AND 12
GROUP BY O.CustomerID,MONTH(O.OrderDate)
HAVING COUNT(O.OrderID)>5
ORDER BY PEDIDOS DESC

/*3.Crear una función que calcule el descuento total aplicado a un pedido, considerando
descuentos por producto y descuentos generales.*/
-- Crear la función
CREATE OR ALTER FUNCTION DBO.F_DESCUENTO(@OrderID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @DescuentoProducto FLOAT;
    SELECT @DescuentoProducto = ISNULL(round(SUM(UnitPrice * Quantity * (1 - Discount)),2), 0)
    FROM [Order Details]
    WHERE OrderID = @OrderID;
    RETURN @DescuentoProducto;
END;
SELECT DBO.F_DESCUENTO(10250) AS DESCUENTO;
select*from [Order Details]
select* from Orders

/*4.Encontrar los productos que han sido vendidos más de 50 veces en un mes específico*/
SELECT P.ProductID,ProductName,MONTH(OrderDate)MES,DATENAME(month,OrderDate) AS NOMBRE_MES,SUM(Quantity) VECES_VENDIDO
From Products P
INNER JOIN [Order Details]OD ON P.ProductID=OD.ProductID
INNER JOIN Orders O ON OD.OrderID=O.OrderID AND MONTH(OrderDate)=2  --mes de FEBRERO
GROUP BY  P.ProductID,ProductName,MONTH(OrderDate),DATENAME(month,OrderDate)
HAVING SUM(QUANTITY)>50
ORDER BY VECES_VENDIDO DESC

/*5.Crear un procedimiento almacenado que inserte un nuevo cliente y su dirección en la base
de datos, verificando previamente si el cliente ya existe.*/

CREATE OR ALTER PROCEDURE SP_INSERTAR_NUEVO_CLIENTE 
    @CustomerID NVARCHAR(5),@CompanyName NVARCHAR(40),@ContactName NVARCHAR(30),@ContactTitle NVARCHAR(30),
    @Address NVARCHAR(60),@City NVARCHAR(15),@Region NVARCHAR(15),@PostalCode NVARCHAR(10),@Country NVARCHAR(15),
	@Phone NVARCHAR(24),@Fax NVARCHAR(24)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID)
    BEGIN
        INSERT INTO Customers (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country,Phone, Fax)
        VALUES (@CustomerID, @CompanyName, @ContactName, @ContactTitle,@Address,@City,@Region,@PostalCode,@Country, @Phone, @Fax); 
    END
    ELSE
    BEGIN
        PRINT 'El cliente ya existe en la base de datos.'
    END
END;
EXEC SP_INSERTAR_NUEVO_CLIENTE
    @CustomerID = 'CAMC',
    @CompanyName = 'Camping Club',
    @ContactName = 'Mariana Rodriguez',
    @ContactTitle = 'Owner',
    @Address = 'Cuzama 604',
    @City = 'Mexico',
    @Region = NULL,
    @PostalCode = '05033',
    @Country = 'Mexico',
    @Phone = '(5) 555-3845',
    @Fax = '(5) 545-2983';
select* from Customers
order by CompanyName 

/*6.Calcular el total de ventas por año y mes, mostrando también el porcentaje de ventas de
cada categoría de productos sobre el total*/

SELECT YEAR(O.OrderDate) AÑO,MONTH(O.OrderDate) MES,C.CategoryName,
    ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)),2)VENTAS_MENSUALES_CATEGORIAS,
    SUM(ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)),2)) OVER (PARTITION BY YEAR(O.OrderDate), MONTH(O.OrderDate)) AS VENTAS_MENSUALES,
    SUM(ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)),2)) OVER () AS TOTAL_VENTAS,
    SUM(ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)),2)) OVER (PARTITION BY C.CategoryName) AS TOTAL_VENTAS_POR_CATEGORIA,
    CASE
        WHEN SUM(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount))) OVER (PARTITION BY YEAR(O.OrderDate), MONTH(O.OrderDate), C.CategoryName) > 0
        THEN
                (SUM(od.Quantity * od.UnitPrice*(1 - OD.Discount)) / SUM(SUM(od.Quantity * od.UnitPrice*(1 - OD.Discount))) OVER (PARTITION BY YEAR(o.OrderDate), MONTH(o.OrderDate))) * 100
        ELSE 0
    END AS PORCENTAJE_VENTAS
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN Products P ON OD.ProductID = P.ProductID
INNER JOIN Categories C ON P.CategoryID = C.CategoryID
GROUP BY YEAR(O.OrderDate),MONTH(O.OrderDate),C.CategoryName
ORDER BY AÑO,MES,CategoryName;



/*7.Crear un procedimiento almacenado que actualice de manera eficiente el inventario de
productos después de cada venta, teniendo en cuenta el stock disponible y los productos
reservados*/
CREATE OR ALTER PROCEDURE SP_ACTUALIZAR
    @OrderID INT
AS
BEGIN
    UPDATE Products
    SET UnitsInStock = CASE
                          WHEN UnitsInStock - ISNULL(OD.Quantity, 0) >= 0 THEN UnitsInStock - ISNULL(OD.Quantity, 0)
                          ELSE 0
                       END,
        UnitsOnOrder = UnitsOnOrder - ISNULL(OD.Quantity, 0)
    FROM [Order Details] OD
    INNER JOIN Products P ON OD.ProductID = P.ProductID
    WHERE OD.OrderID = @OrderID;

    -- Actualizar productos reservados en Orders
    UPDATE Products
    SET UnitsOnOrder = UnitsOnOrder + ISNULL(OD.Quantity, 0)
    FROM [Order Details] OD
    INNER JOIN Products P ON OD.ProductID = P.ProductID
    WHERE OD.OrderID = @OrderID;
END;
EXEC SP_ACTUALIZAR 10250
 select*from Products
 
/*8.Crear un procedimiento almacenado que genere informes de ventas personalizados para
cada cliente, basados en sus preferencias y comportamiento de compra*/
CREATE OR ALTER PROCEDURE SP_INFORME_VENTAS
    @CustomerID NVARCHAR(5)
AS
BEGIN
    SELECT O.OrderID,CONVERT(VARCHAR(10), O.OrderDate,23) AS FECHA,ProductName,OD.Quantity,OD.UnitPrice
    FROM Customers C
    INNER JOIN Orders O ON C.CustomerID = O.CustomerID
    INNER JOIN[Order Details] OD ON O.OrderID = OD.OrderID
    INNER JOIN Products P ON OD.ProductID = P.ProductID
    WHERE C.CustomerID = @CustomerID AND P.CategoryID = (SELECT TOP 1 P1.CategoryID
                                                         FROM Customers C1
                                                         INNER JOIN Orders O1 ON C1.CustomerID = O1.CustomerID
                                                         INNER JOIN [Order Details] OD1 ON O1.OrderID = OD1.OrderID
                                                         INNER JOIN Products P1 ON OD1.ProductID = P1.ProductID
                                                         WHERE C1.CustomerID = @CustomerID
                                                         GROUP BY P1.CategoryID
                                                         ORDER BY COUNT(*) DESC
			                                             )
END
EXECUTE SP_INFORME_VENTAS 'BERGS'
SELECT*FROM CUSTOMERS

/*9.Crear un procedimiento almacenado que permita obtener los datos (Trimestre, ProductID,
ProductName, Cantidad) de los dos productos menos adquiridos en cada trimestre de la
gestión 1997*/

CREATE OR ALTER PROCEDURE SP_PRODUCTOS_MAS_ADQUIRIDOS(@GESTION NVARCHAR(MAX))
 AS
 BEGIN
 SELECT *
 FROM(  SELECT DATEPART(QUARTER, O.OrderDate)TRIMESTRE,OD.ProductID,P.ProductName,SUM(Quantity) CANTIDAD_PRODUCTOS_VENDIDIOS,
        ROW_NUMBER() OVER(PARTITION BY DATEPART(QUARTER, O.OrderDate) ORDER BY SUM(Quantity))Item
        FROM Orders O
        INNER JOIN [Order Details]OD ON O.OrderID=OD.OrderID
        INNER JOIN Products P ON OD.ProductID=P.ProductID AND YEAR (OrderDate)=@GESTION---1997
        GROUP BY DATEPART(QUARTER, O.OrderDate),OD.ProductID,P.ProductName
 
 )T
 WHERE Item <= 2
 ORDER BY TRIMESTRE
 END;
 EXECUTE SP_PRODUCTOS_MAS_ADQUIRIDOS '1997' 
 /*10. Crear un procedimiento almacenado que permita obtener los datos (SupplierID,
CompanyName) del proveedor(es), donde uno de sus productos fue el menos adquirido
durante la gestión 1997*/

CREATE OR ALTER PROCEDURE SP_PROVEEDORES(@GESTION NVARCHAR(MAX))
 AS
 BEGIN
 SELECT *
 FROM(  SELECT S.SupplierID,CompanyName,P.ProductName,ROW_NUMBER() OVER(PARTITION BY S.SupplierID ORDER BY SUM(Quantity))Item
        FROM Suppliers S
		INNER JOIN Products P ON S.SupplierID=P.SupplierID
        INNER JOIN [Order Details]OD ON P.ProductID=OD.ProductID
		INNER JOIN Orders O ON OD.OrderID=O.OrderID
        AND YEAR (OrderDate)=@GESTION---1997
        GROUP BY S.SupplierID,CompanyName,P.ProductName
 )T
 WHERE Item<= 1
 ORDER BY SupplierID
 END;
 EXECUTE SP_PROVEEDORES '1997' 