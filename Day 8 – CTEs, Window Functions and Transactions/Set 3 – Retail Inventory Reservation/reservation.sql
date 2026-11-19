CREATE DATABASE RetailInventoryDB;
USE RetailInventoryDB;
CREATE TABLE Categories(
CategoryID INT PRIMARY KEY,
CategoryName VARCHAR(100) NOT NULL
);
GO
CREATE TABLE Products(
ProductID INT PRIMARY KEY,
ProductName VARCHAR(100) NOT NULL,
CategoryID INT NOT NULL,
StockQuantity INT NOT NULL CHECK(StockQuantity>=0),
UnitPrice DECIMAL(10,2) NOT NULL CHECK(UnitPrice>0),
FOREIGN KEY(CategoryID) REFERENCES Categories(CategoryID)
);
GO
CREATE TABLE Orders(
OrderID INT IDENTITY(1,1) PRIMARY KEY,
CustomerName VARCHAR(100) NOT NULL,
OrderDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
OrderStatus VARCHAR(20) NOT NULL
);
GO
CREATE TABLE OrderLines(
OrderLineID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT NOT NULL,
ProductID INT NOT NULL,
Quantity INT NOT NULL CHECK(Quantity>0),
UnitPrice DECIMAL(10,2) NOT NULL,
FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY(ProductID) REFERENCES Products(ProductID)
);
GO
INSERT INTO Categories VALUES
(1,'Electronics'),
(2,'Sports'),
(3,'Movies');
INSERT INTO Products VALUES
(101,'Vijay Headphones',1,20,2500),
(102,'Rajini Smart TV',1,8,45000),
(103,'Dhoni Cricket Bat',2,15,3000),
(104,'Kohli Cricket Kit',2,5,8500),
(105,'Leo Movie Collection',3,30,500),
(106,'Jailer Movie Collection',3,10,700),
(107,'Suriya Speaker',1,12,4000),
(108,'Rohit Cricket Gloves',2,25,1200),
(109,'Vikram Movie Collection',3,4,900);
GO
-- TASK 1: Successful stock reservation
DECLARE @RajiniOrderID INT;
DECLARE @VijayProductID INT=101;
DECLARE @DhoniQuantity INT=2;
DECLARE @KohliPrice DECIMAL(10,2);
BEGIN TRY
BEGIN TRANSACTION;
-- Lock the product row and check available stock
SELECT @KohliPrice=UnitPrice
FROM Products WITH(UPDLOCK,HOLDLOCK)
WHERE ProductID=@VijayProductID
AND StockQuantity>=@DhoniQuantity;
IF @KohliPrice IS NULL
THROW 53001,'Product does not exist or stock is insufficient.',1;
INSERT INTO Orders(CustomerName,OrderStatus)
VALUES('Rajinikanth','Confirmed');
SET @RajiniOrderID=SCOPE_IDENTITY();
UPDATE Products
SET StockQuantity=StockQuantity-@DhoniQuantity
WHERE ProductID=@VijayProductID
AND StockQuantity>=@DhoniQuantity;
IF @@ROWCOUNT<>1
THROW 53002,'Stock reservation failed.',1;
INSERT INTO OrderLines(OrderID,ProductID,Quantity,UnitPrice)
VALUES(@RajiniOrderID,@VijayProductID,@DhoniQuantity,@KohliPrice);
COMMIT TRANSACTION;
PRINT 'Order placed and stock reserved successfully.';
END TRY
BEGIN CATCH
IF XACT_STATE()<>0
ROLLBACK TRANSACTION;
PRINT CONCAT('Order failed: ',ERROR_MESSAGE());
THROW;
END CATCH;
GO
-- Verify successful order and remaining stock
SELECT * FROM Products ORDER BY ProductID;
SELECT * FROM Orders;
SELECT * FROM OrderLines;
GO
-- TASK 1: Demonstrate rollback when stock is insufficient
DECLARE @DhoniStockBefore INT;
DECLARE @DhoniStockAfter INT;
DECLARE @VijayOrderCountBefore INT;
DECLARE @VijayOrderCountAfter INT;
SELECT @DhoniStockBefore=StockQuantity
FROM Products WHERE ProductID=102;
SELECT @VijayOrderCountBefore=COUNT(*)
FROM Orders WHERE CustomerName='Vijay';
BEGIN TRY
BEGIN TRANSACTION;
-- Request more stock than available
IF NOT EXISTS(
SELECT 1 FROM Products WITH(UPDLOCK,HOLDLOCK)
WHERE ProductID=102 AND StockQuantity>=100
)
THROW 53003,'Insufficient stock for requested order.',1;
INSERT INTO Orders(CustomerName,OrderStatus)
VALUES('Vijay','Confirmed');
DECLARE @VijayOrderID INT=SCOPE_IDENTITY();
UPDATE Products SET StockQuantity=StockQuantity-100
WHERE ProductID=102 AND StockQuantity>=100;
INSERT INTO OrderLines(OrderID,ProductID,Quantity,UnitPrice)
VALUES(@VijayOrderID,102,100,45000);
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
IF XACT_STATE()<>0
ROLLBACK TRANSACTION;
PRINT CONCAT('Expected rollback: ',ERROR_MESSAGE());
END CATCH;
SELECT @DhoniStockAfter=StockQuantity
FROM Products WHERE ProductID=102;
SELECT @VijayOrderCountAfter=COUNT(*)
FROM Orders WHERE CustomerName='Vijay';
SELECT
@DhoniStockBefore AS StockBefore,
@DhoniStockAfter AS StockAfter,
@VijayOrderCountBefore AS OrdersBefore,
@VijayOrderCountAfter AS OrdersAfter,
CASE
WHEN @DhoniStockBefore=@DhoniStockAfter
AND @VijayOrderCountBefore=@VijayOrderCountAfter
THEN 'ROLLBACK VERIFIED'
ELSE 'ROLLBACK VERIFICATION FAILED'
END AS RollbackResult;
GO
-- TASK 2: Correlated subquery to find below-average stock products
SELECT
P.ProductID,
P.ProductName,
C.CategoryName,
P.StockQuantity
FROM Products P
INNER JOIN Categories C ON P.CategoryID=C.CategoryID
WHERE P.StockQuantity<(
SELECT AVG(CAST(P2.StockQuantity AS DECIMAL(10,2)))
FROM Products P2
WHERE P2.CategoryID=P.CategoryID
)
ORDER BY C.CategoryName,P.StockQuantity;
GO
