USE RetailOrderDB;
GO
-- Stores multiple products for a single order
CREATE TYPE OrderItemType AS TABLE(
ProductID INT,
Quantity INT
);
GO
-- Places an order and updates stock in one transaction
CREATE PROCEDURE usp_PlaceOrder
@CustomerID INT,
@Items OrderItemType READONLY,
@TaxRate DECIMAL(5,2)=0.18,
@OrderNumber INT OUTPUT
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET @OrderNumber=NULL;
BEGIN TRY
IF NOT EXISTS(SELECT 1 FROM Customers WHERE CustomerID=@CustomerID)
THROW 50001,'Customer does not exist.',1;
IF NOT EXISTS(SELECT 1 FROM @Items)
THROW 50002,'Order must contain at least one item.',1;
IF EXISTS(SELECT 1 FROM @Items WHERE Quantity<=0)
THROW 50003,'Quantity must be greater than zero.',1;
IF @TaxRate<0 OR @TaxRate>1
THROW 50004,'Invalid tax rate.',1;
IF EXISTS(
SELECT 1
FROM (SELECT ProductID,SUM(Quantity) AS RequiredQty FROM @Items GROUP BY ProductID) i
LEFT JOIN Products p ON i.ProductID=p.ProductID
WHERE p.ProductID IS NULL OR p.StockQuantity<i.RequiredQty
)
THROW 50005,'Product not available or insufficient stock.',1;
BEGIN TRANSACTION;
INSERT INTO Orders(CustomerID,OrderDate,OrderStatus)
VALUES(@CustomerID,SYSDATETIME(),'Pending');
SET @OrderNumber=SCOPE_IDENTITY();
INSERT INTO OrderDetails(OrderID,ProductID,Quantity,UnitPrice)
SELECT @OrderNumber,p.ProductID,i.Quantity,p.UnitPrice
FROM @Items i
JOIN Products p ON i.ProductID=p.ProductID;
UPDATE p
SET p.StockQuantity=p.StockQuantity-i.RequiredQty
FROM Products p
JOIN (SELECT ProductID,SUM(Quantity) AS RequiredQty FROM @Items GROUP BY ProductID) i
ON p.ProductID=i.ProductID;
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0
ROLLBACK TRANSACTION;
SET @OrderNumber=NULL;
THROW;
END CATCH
END;
GO
-- Calculates the total order amount including tax
CREATE FUNCTION fn_OrderTotalWithTax
(@OrderID INT,@TaxRate DECIMAL(5,2))
RETURNS DECIMAL(18,2)
AS
BEGIN
DECLARE @Total DECIMAL(18,2);
SELECT @Total=ISNULL(SUM(Quantity*UnitPrice),0)*(1+@TaxRate)
FROM OrderDetails
WHERE OrderID=@OrderID;
RETURN @Total;
END;
GO
-- Returns all orders placed by a particular customer
CREATE FUNCTION fn_CustomerOrders
(@CustomerID INT)
RETURNS TABLE
AS
RETURN
(
SELECT o.OrderID,o.CustomerID,o.OrderDate,o.OrderStatus,
SUM(od.Quantity*od.UnitPrice) AS OrderTotal
FROM Orders o
JOIN OrderDetails od ON o.OrderID=od.OrderID
WHERE o.CustomerID=@CustomerID
GROUP BY o.OrderID,o.CustomerID,o.OrderDate,o.OrderStatus
);
GO
-- Test the stored procedure
DECLARE @Items OrderItemType;
DECLARE @NewOrderNumber INT;
INSERT INTO @Items VALUES(101,1),(102,2);
EXEC usp_PlaceOrder
@CustomerID=1,
@Items=@Items,
@TaxRate=0.18,
@OrderNumber=@NewOrderNumber OUTPUT;
SELECT @NewOrderNumber AS NewOrderNumber;
-- Test the scalar function
SELECT dbo.fn_OrderTotalWithTax(@NewOrderNumber,0.18) AS TotalWithTax;
-- Test the table-valued function
SELECT * FROM dbo.fn_CustomerOrders(1);
GO
