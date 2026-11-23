USE RetailOrderDB;
GO
-- Cursor-based approach for pending orders
CREATE PROCEDURE usp_OrderFollowUp_Cursor
AS
BEGIN
SET NOCOUNT ON;
DECLARE @OrderID INT;
DECLARE order_cursor CURSOR LOCAL FAST_FORWARD FOR
SELECT OrderID
FROM Orders
WHERE OrderStatus='Pending'
AND OrderDate<DATEADD(DAY,-3,SYSDATETIME());
BEGIN TRY
OPEN order_cursor;
FETCH NEXT FROM order_cursor INTO @OrderID;
WHILE @@FETCH_STATUS=0
BEGIN
IF NOT EXISTS(SELECT 1 FROM OrderFollowUps WHERE OrderID=@OrderID)
BEGIN
INSERT INTO OrderFollowUps(OrderID,Remarks)
VALUES(@OrderID,'Follow-up required for pending order.');
END
FETCH NEXT FROM order_cursor INTO @OrderID;
END
CLOSE order_cursor;
DEALLOCATE order_cursor;
END TRY
BEGIN CATCH
IF CURSOR_STATUS('local','order_cursor')>=0
CLOSE order_cursor;
IF CURSOR_STATUS('local','order_cursor')>-3
DEALLOCATE order_cursor;
THROW;
END CATCH
END;
GO
-- Set-based approach for the same requirement
CREATE PROCEDURE usp_OrderFollowUp_SetBased
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO OrderFollowUps(OrderID,Remarks)
SELECT o.OrderID,'Follow-up required for pending order.'
FROM Orders o
WHERE o.OrderStatus='Pending'
AND o.OrderDate<DATEADD(DAY,-3,SYSDATETIME())
AND NOT EXISTS(
SELECT 1
FROM OrderFollowUps f
WHERE f.OrderID=o.OrderID
);
END;
GO
-- Test cursor implementation
EXEC usp_OrderFollowUp_Cursor;
SELECT * FROM OrderFollowUps;
GO
-- Remove test records to compare both methods using the same data
DELETE FROM OrderFollowUps;
GO
-- Test set-based implementation
EXEC usp_OrderFollowUp_SetBased;
SELECT * FROM OrderFollowUps;
GO
