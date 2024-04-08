/*EJERCICIOS*/
/*1 Crear una función que devuelva el importe (Quantity*UnitPrice*(1-Discount)) 
acumulado en una determinada gestión (@Gestion) y producto (@ProdID).*/
CREATE OR ALTER FUNCTION F_IMPORTE(@GESTION NVARCHAR(MAX), @PROID INT)
RETURNS INT 
AS
BEGIN
DECLARE @TotalImporte INT;
    SELECT @TotalImporte = SUM(Quantity * UnitPrice * (1 - Discount))
    FROM [Order Details] OD
    INNER JOIN Orders O ON OD.OrderID = O.OrderID
    WHERE YEAR(O.OrderDate) = YEAR(@GESTION) AND MONTH(O.OrderDate) = MONTH(@GESTION) AND OD.ProductID = @PROID;
    RETURN ISNULL(@TotalImporte, 0);
END;
DECLARE @Gestion NVARCHAR(MAX) = '1998'
DECLARE @ProdID INT = 7
SELECT DBO.F_IMPORTE(@Gestion, @ProdID) AS ImporteAcumulado;

/*2.Crear una función que devuelva el número de identificación (CustomerID)
del cliente que más pedidos realizó en una determinada gestión (@Gestion) y trimestre (@NumTrim).*/

CREATE OR ALTER FUNCTION F_IDENTIFICACION(@GESTION NVARCHAR(MAX), @NUMTRIM INT)
RETURNS NVARCHAR(5)
AS
BEGIN
    DECLARE @CustomerID NVARCHAR(5);
    SELECT TOP 1 @CustomerID = CustomerID
    FROM (
        SELECT CustomerID,ROW_NUMBER() OVER (ORDER BY COUNT(OrderID) DESC) AS item
        FROM Orders O
        WHERE YEAR(O.OrderDate) = CAST(@GESTION AS INT) AND DATEPART(QUARTER, O.OrderDate) = @NUMTRIM
        GROUP BY CustomerID
    ) T
    WHERE item = 1
    RETURN @CustomerID
END;
DECLARE @GESTION NVARCHAR(MAX) = '1997';
DECLARE @NUMTRIM INT = 3;
SELECT DBO.F_IDENTIFICACION(@GESTION, @NUMTRIM) AS CustomerID

/* da los 5 con su respectiva cantidad de pedido*/
DECLARE @GESTION NVARCHAR(MAX) = '1997';
DECLARE @NUMTRIM INT = 3;

SELECT TOP 5 CustomerID, COUNT(OrderID) AS CantidadPedidos
FROM Orders
WHERE YEAR(OrderDate) = CAST(@GESTION AS INT) AND DATEPART(QUARTER, OrderDate) = @NUMTRIM
GROUP BY CustomerID
ORDER BY COUNT(OrderID) DESC;
/*3.Crear una vista que permita listar el CustomerID, EmployeeID, OrderID, ProductID,
OrderDate y el Importe (Quantity*UnitPrice*(1-Discount)) de todas las transacciones
registradas*/
CREATE OR ALTER VIEW  V_TRAN_REGISTRO
WITH ENCRYPTION
AS
SELECT C.CustomerID,C.CompanyName,E.EmployeeID, E.LastName + ', ' + E.FirstName AS EmployeeName,
O.OrderID,CONVERT(VARCHAR(10), O.OrderDate,23) AS ORDERDATE,OD.ProductID,OD.Quantity,OD.UnitPrice,OD.Discount,
(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) IMPORTE
FROM Customers C
INNER JOIN Orders O ON C.CustomerID=O.CustomerID
INNER JOIN Employees E ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] OD ON O.OrderID=OD.OrderID
SELECT *
FROM V_TRAN_REGISTRO
WHERE YEAR(OrderDate) = 1997;

/*IMPORTE ANUAL*/
SELECT
    YEAR(OrderDate) AS Año,
    ROUND(SUM(IMPORTE),2) AS ImporteTotalAnual
FROM V_TRAN_REGISTRO
GROUP BY YEAR(OrderDate);








/*4.Crear un procedimiento almacenado que permita obtener los datos (Trimestre, ProductID,
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
 /*5. Crear un procedimiento almacenado que permita obtener los datos (SupplierID,
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

