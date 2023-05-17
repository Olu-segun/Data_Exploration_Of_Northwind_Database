
--- 1) How many shippers do we have ?
 
 SELECT *
FROM [dbo].Shippers 


--- 2) Category of product with their CategoryID and description

 SELECT CategoryID, CategoryName, Description
FROM [dbo]. Categories


--- 3)  Slaes representative employee

SELECT  FirstName, LastName, Hiredate
FROM [dbo].Employees
WHERE Title = 'Sales Representative';

--- 4) Sales representative in the United States.

SELECT  FirstName, LastName, Hiredate, Country
FROM [dbo].Employees
WHERE Title = 'Sales Representative' AND Country = 'USA';


--- 5) Display all the order placed by Steven Buchanan with the EmployeeID 5

SELECT  OrderID, CAST(OrderDate AS date) Order_Date, ShippedDate, ShipCountry
FROM [dbo]. Orders Details
WHERE EmployeeID = 5

--- 6)In the Suppliers table, show the SupplierID, ContactName, and ContactTitle for those Suppliers whose ContactTitle is not Marketing Manager.

SELECT SupplierID,ContactName, ContactTitle
FROM [dbo].Suppliers
WHERE ContactTitle != 'Marketing Manager'

--- 7)  In the products table, we’d like to see the ProductID and ProductName for those products where the ProductName includes the string “queso”.

SELECT  ProductID, ProductName
FROM [dbo].Products
WHERE ProductName LIKE 'queso%';

--- 8) Looking at the Orders table, there’s a field called ShipCountry. Write a query that shows the OrderID, CustomerID, and ShipCountry for the orders where the ShipCountry is either France or Belgium.

SELECT OrderID, OrderDate, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry = 'France' OR ShipCountry = 'Belgium';

--- 9) Orders shipping to any country in Latin America.

SELECT OrderID, OrderDate, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry IN ('Brazil', 'Mexico',  'Argentina', 'Venezuela');

--- 10) For all the employees in the Employees table, show the FirstName, LastName, Title, and BirthDate. Order the results by BirthDate, so we have the oldest employees first

SELECT FirstName, LastName, Title, BirthDate
FROM Employees
ORDER BY BirthDate ASC;

--- 11) In the output of the query above, showing the Employees in order of BirthDate, we see the time of the BirthDate field, which we don’t want. Show only the date portion of the BirthDate field

SELECT FirstName, LastName, Title, CAST (BirthDate AS date) AS Date_of_Birth
FROM Employees
ORDER BY BirthDate ASC;

--- 12) Show the FirstName and LastName columns from the Employees table, and then create a new column called FullName, showing FirstName and LastName joined together in one column, with a space inbetween.

SELECT FirstName, LastName, CONCAT( FirstName,' ',LastName) AS Full_Name
FROM Employees;

--- 13) In the OrderDetails table, we have the fields UnitPrice and Quantity. Create a new field, TotalPrice, that multiplies these two together. We’ll ignore the Discount field for now.
--- In addition, show the OrderID, ProductID, UnitPrice, and Quantity. Order by OrderID and ProductID.

SELECT OrderID, ProductID,UnitPrice, Quantity, UnitPrice*Quantity AS Total_Price
FROM [Order Details]
ORDER BY OrderID, ProductID DESC;

--- 14) How many customers do we have in the Customers table? Show one value only, and don’t rely on getting the recordcount at the end of a resultset.

SELECT COUNT( DISTINCT CustomerID) AS Count_Of_Customer
FROM [Customers];

--- 15) Show the date of the first order ever made in the Orders table.

SELECT  MIN(OrderDate) AS First_OrderDate
FROM Orders

--- 16) Show a list of countries where the Northwind company has customers.

SELECT Country
FROM Suppliers
GROUP BY Country;

--- 17) Show a list of all the different values in the Customers table for ContactTitles. Also include a count for each ContactTitle.

SELECT  ContactTitle, COUNT(ContactTitle) As Total_Contact_Title
FROM Customers
GROUP BY ContactTitle
ORDER BY Total_Contact_Title DESC;

--- 18) We’d like to show, for each product, the associated Supplier. Show the ProductID, ProductName, and the CompanyName of the Supplier. Sort by ProductID.

SELECT ProductID, ProductName, CompanyName
FROM Products
INNER JOIN Suppliers
ON Products.ProductID = Suppliers.SupplierID
ORDER BY ProductID ASC;

--- 19) We’d like to show a list of the Orders that were made, including the Shipper that was used. Show the OrderID, OrderDate (date only), and CompanyName
--- of the Shipper, and sort by OrderID.In order to not show all the orders (there’s more than 800), show only those rows with an OrderID of less than 10300

SELECT OrderID, CAST(OrderDate AS date) AS Order_Date, CompanyName
FROM Orders
INNER JOIN Shippers
ON Orders.ShipVia = Shippers.ShipperID
WHERE OrderID < 10300;

--- 20) We’d like to see the total number of products in each category. Sort the results by the total number of products, in descending order.

SELECT CategoryName, Count(ProductID) AS Total_Number_of_products
FROM Categories
INNER JOIN Products
ON Categories.CategoryID = Products.CategoryID
GROUP BY CategoryName
ORDER BY  Total_Number_of_products DESC;

--- 21) In the Customers table, show the total number of customers per Country and City

SELECT Country, City, COUNT(CustomerID) AS Total_Number_of_Customer
FROM Customers
GROUP BY City, Country 
ORDER BY Total_Number_of_Customer DESC;

--- 22) What products do we have in our inventory that should be reordered? For now, just use the fields UnitsInStock and ReorderLevel, where UnitsInStock
--- is less than the ReorderLevel, ignoring the fields UnitsOnOrder and Discontinued. Order the results by ProductID.

SELECT ProductID, UnitsInStock, ReorderLevel
FROM Products
WHERE UnitsInStock < ReorderLevel
ORDER BY ProductID ASC;

--- 23) Now we need to incorporate these fields— UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued—into our calculation. We’ll define
--- “products that need reordering” with the following: UnitsInStock plus UnitsOnOrder are less than or equal to ReorderLevel The Discontinued flag is false (0).

SELECT ProductID, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
FROM Products
WHERE UnitsInStock + UnitsOnOrder <= ReorderLevel AND Discontinued = 0;

--- 24) A salesperson for Northwind is going on a business trip to visit customers, and would like to see a list of all customers, sorted by region, alphabetically.
--- However, he wants the customers with no region (null in the Region field) to be at the end, instead of at the top, where you’d normally find the null values. Within the same region, companies should be sorted by CustomerID

SELECT CustomerID, CompanyName, ContactName, Phone, Address, City, Region, Country
FROM Customers
ORDER BY  
CASE WHEN Region IS null then 1
ELSE 0
END ASC, Region;

--- 25) Some of the countries we ship to have very high freight charges. We'd like to investigate some more shipping options for our customers, to be able to
--- offer them lower freight charges. Return the three ship countries with the highest average freight overall, in descending order by average freigh
SELECT TOP 3 ShipCountry,   AVG(Freight) AS Average_Freight
FROM Orders
GROUP BY ShipCountry
ORDER BY  Average_Freight DESC;

--- 26) We're doing inventory, and we need to show all the following information; EmployeeID, FirstName, LastName, OrderID, ProductName, Quantity , for all orders. Sort by OrderID and Product ID

SELECT Employees.EmployeeID, FirstName, LastName, Orders.OrderID, ProductName, Quantity
FROM Employees
INNER JOIN Orders
ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN [Order Details]
ON Orders.OrderID = [Order Details].OrderID
INNER JOIN Products
ON [Order Details].ProductID = Products.ProductID;

--- 27) There are some customers who have never actually placed an order. Show these customers.

SELECT Customers.CustomerID, Customers.CompanyName, OrderID 
FROM Customers
LEFT JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
WHERE OrderID IS NULL;


--- 28) We want to send all of our high-value customers a special VIP gift. We're defining high-value customers as those who've made at least 1 order with a total value (not including the discount) equal to
--- $10,000 or more. We only want to consider orders made in the year 1998

SELECT Customers.CustomerID, CompanyName,  Orders.OrderID, COUNT(Distinct [Order Details].OrderID) AS Count_Of_Order, CAST(OrderDate AS date) AS Order_Date, UnitPrice,
Total_Value = (Quantity*UnitPrice-Discount)
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID 
INNER JOIN [Order Details]
ON Orders.OrderID = [Order Details].OrderID
WHERE OrderDate  BETWEEN '1998-01-01' AND '1998-12-31' AND Quantity*UnitPrice-Discount  >  10000
GROUP BY Customers.CustomerID, Customers.CompanyName, Orders.OrderID, OrderDate, Quantity, UnitPrice,Discount
ORDER BY Total_Value DESC;




