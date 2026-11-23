CREATE DATABASE RetailOrderDB;
GO
USE RetailOrderDB;
GO
CREATE TABLE Customers(
CustomerID INT PRIMARY KEY,
CustomerName VARCHAR(100) NOT NULL,
Email VARCHAR(100),
Phone VARCHAR(15)
);
CREATE TABLE Suppliers(
SupplierID INT PRIMARY KEY,
SupplierName VARCHAR(100) NOT NULL
);
CREATE TABLE Products(
ProductID INT PRIMARY KEY,
ProductName VARCHAR(100) NOT NULL,
UnitPrice DECIMAL(10,2) NOT NULL,
CostPrice DECIMAL(10,2) NOT NULL,
StockQuantity INT NOT NULL,
ReorderLevel INT NOT NULL,
SupplierID INT,
FOREIGN KEY(SupplierID) REFERENCES Suppliers(SupplierID)
);
CREATE TABLE Orders(
OrderID INT IDENTITY(1,1) PRIMARY KEY,
CustomerID INT NOT NULL,
OrderDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
OrderStatus VARCHAR(30) NOT NULL DEFAULT 'Pending',
FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderDetails(
OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT NOT NULL,
ProductID INT NOT NULL,
Quantity INT NOT NULL,
UnitPrice DECIMAL(10,2) NOT NULL,
FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY(ProductID) REFERENCES Products(ProductID)
);
CREATE TABLE OrderFollowUps(
FollowUpID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT NOT NULL,
FollowUpDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
Remarks VARCHAR(200),
FOREIGN KEY(OrderID) REFERENCES Orders(OrderID)
);
INSERT INTO Customers VALUES
(1,'Arun','arun@gmail.com','9876543210'),
(2,'Priya','priya@gmail.com','9876543211'),
(3,'Kumar','kumar@gmail.com','9876543212');
INSERT INTO Suppliers VALUES
(1,'ABC Suppliers'),
(2,'Global Traders');
INSERT INTO Products VALUES
(101,'Laptop',55000,42000,10,5,1),
(102,'Mouse',500,250,3,5,2),
(103,'Keyboard',1200,700,20,5,1),
(104,'Monitor',12000,9000,2,5,2);
INSERT INTO Orders(CustomerID,OrderDate,OrderStatus) VALUES
(1,DATEADD(DAY,-5,SYSDATETIME()),'Pending'),
(2,DATEADD(DAY,-1,SYSDATETIME()),'Completed'),
(3,DATEADD(DAY,-6,SYSDATETIME()),'Pending');
INSERT INTO OrderDetails(OrderID,ProductID,Quantity,UnitPrice) VALUES
(1,101,1,55000),
(2,102,2,500),
(3,103,1,1200);
GO
-- Displays order details without exposing cost price or supplier information
CREATE VIEW vw_order_summary
AS
SELECT o.OrderID,c.CustomerName,o.OrderDate,o.OrderStatus,
SUM(od.Quantity*od.UnitPrice) AS OrderTotal
FROM Orders o
JOIN Customers c ON o.CustomerID=c.CustomerID
JOIN OrderDetails od ON o.OrderID=od.OrderID
GROUP BY o.OrderID,c.CustomerName,o.OrderDate,o.OrderStatus;
GO
-- Displays products that need stock replenishment
CREATE VIEW vw_low_stock
AS
SELECT ProductID,ProductName,StockQuantity,ReorderLevel
FROM Products
WHERE StockQuantity<=ReorderLevel;
GO
-- An updatable view that allows changes only for products with available stock
CREATE VIEW vw_available_products
AS
SELECT ProductID,ProductName,UnitPrice,StockQuantity
FROM Products
WHERE StockQuantity>0
WITH CHECK OPTION;
GO
-- View the results
SELECT * FROM vw_order_summary;
SELECT * FROM vw_low_stock;
SELECT * FROM vw_available_products;
GO
