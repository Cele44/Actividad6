/*Obtener CategoryID y el ProductName de aquel producto cuyo promedio de 
la cantidad de unidades vendidas durante la gestión de 1998, sea mayor 
a su promedio obtenido en la gestión de 1996. Ordenar los valores del 
atributo CategoryID en forma ascendente.*/
SELECT*
FROM
( SELECT CategoryID,ProductName,AVG(CAST(QUANTITY AS FLOAT )) PROMEDIO
  FROM Products P
  INNER JOIN [Order Details] OD ON P.ProductID=OD.ProductID
  INNER JOIN Orders O ON O.OrderID=OD.OrderID AND DATEPART(YYYY,OrderDate)=1998
  GROUP BY CategoryID,ProductName
)TA
INNER JOIN 
( 
  SELECT CategoryID,ProductName,AVG(CAST(QUANTITY AS FLOAT )) PROMEDIO
  FROM Products P
  INNER JOIN [Order Details] OD ON P.ProductID=OD.ProductID
  INNER JOIN Orders O ON O.OrderID=OD.OrderID AND DATEPART(YYYY,OrderDate)=1996
  GROUP BY CategoryID,ProductName
)TB ON TA.ProductName=TB.ProductName AND TA.PROMEDIO>TB.PROMEDIO

/* LISTAR LOS SIGUIENTES DATOS: (LASTNAME, FIRSTNAME) EMPLEADO, NOMBRE DEL MES Y 
   EL MONTO TOTAL DE VENTA POR MES, QUE REALIZO CADA VENDEDOR DURANTE LA GESTION DE 1997*/
   SELECT LastName,FirstName,DATENAME(MM,OrderDate)MES,SUM(Quantity*OD.UnitPrice*(1-Discount)) MONTO
   FROM Employees E
   INNER JOIN Orders O ON E.EmployeeID=O.EmployeeID
   INNER JOIN [Order Details] OD ON O.OrderID=OD.OrderID AND DATEPART(YYYY,OrderDate)=1997
   GROUP BY LastName,FirstName,DATENAME(MM,OrderDate),MONTH(OrderDate)
   ORDER BY LastName,FirstName,MONTH(OrderDate)
   
   /*Obtener el CustomerID, CompanyName, Año y la Cantidad de pedidos realizados
   por año, mismos que deben encontrarse entre el rango de 5 a 10. Ordenar los
   valores de los atributos CustomerID y Año en forma ascendente.*/
   SELECT C.CustomerID,C.CompanyName,YEAR(OrderDate)Año ,COUNT(*)AS CANTIDAD_PEDIDOS
   FROM Customers C
   INNER JOIN Orders O ON C.CustomerID=O.CustomerID
   GROUP BY C.CustomerID,C.CompanyName,YEAR(OrderDate)
   HAVING COUNT(*)BETWEEN 5 AND 10
   ORDER BY C.CustomerID,C.CompanyName,Año 
   


