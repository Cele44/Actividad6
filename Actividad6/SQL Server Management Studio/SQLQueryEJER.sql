USE Northwind;
----obtener el employeeid,lastname,firstname de la tabla empleados que han realizado ventas en todos los años
SELECT e.EmployeeID, e.LastName, e.FirstName
FROM Employees e
WHERE e.EmployeeID IN (
    SELECT o.EmployeeID
    FROM Orders o
    GROUP BY o.EmployeeID
    HAVING COUNT(DISTINCT YEAR(o.OrderDate)) = (
        SELECT COUNT(DISTINCT YEAR(OrderDate))
        FROM Orders
    )
)
----obtener los productos cuyos valores esten entre 6 y 50 dolares
SELECT ProductID,ProductName,UnitPrice
from Products
WHERE UnitPrice BETWEEN 6 AND 50

select * from Products p
where p.UnitPrice between 6 and 50

----selecionar los 7 productos con precio mas
--caro y que cuneten con stock en almacen
SELECT TOP 7 ProductName,UnitPrice,UnitsInStock
from Products
where UnitsInStock not like 0
order by UnitPrice desc

/*listar cuantas ordenes a realizado cada empleado (mostrar
nombre ,apellidos y numero de pedidos) q sean mayores a 100*/
select FirstName,LastName,COUNT(*)NRO_PEDIDOS
from Employees E
inner join Orders O ON E.EmployeeID=O.EmployeeID
GROUP BY FirstName,LastName
HAVING COUNT(*)>100


/*listar cuantos pedidos a realizado cada cliente (mostrar
nombre ,apellidos y numero de pedidos) q sean mayores  de cada pais*/
select CompanyName,Country,COUNT(*)nro_ordenes
from Customers C
inner join Orders O ON C.CustomerID=O.CustomerID
GROUP BY CompanyName,Country
HAVING COUNT(*) > 1
ORDER BY nro_ordenes DESC 

SELECT
    C.CustomerID,
    C.ContactName,
    C.ContactTitle,
    C.CompanyName,
    C.Country,
    COUNT(O.OrderID) AS nro_ordenes
FROM
    Customers C
INNER JOIN
    Orders O ON C.CustomerID = O.CustomerID
GROUP BY
    C.CustomerID, C.ContactName, C.ContactTitle, C.CompanyName, C.Country
HAVING
    COUNT(O.OrderID) = (
        SELECT TOP 1 COUNT(O2.OrderID)
        FROM Orders O2
        WHERE C.CustomerID = O2.CustomerID
        GROUP BY O2.CustomerID
        ORDER BY COUNT(O2.OrderID) DESC
    )
ORDER BY
    nro_ordenes DESC;
