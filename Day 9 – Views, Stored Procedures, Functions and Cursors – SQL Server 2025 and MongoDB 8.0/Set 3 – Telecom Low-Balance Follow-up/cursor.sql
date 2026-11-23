USE TelecomDB;
GO
-- Cursor-based approach to notify subscribers with low balance
CREATE PROCEDURE usp_LowBalanceNotification_Cursor
AS
BEGIN
SET NOCOUNT ON;
DECLARE @SubscriberID INT;
DECLARE @Balance DECIMAL(10,2);
DECLARE subscriber_cursor CURSOR LOCAL FAST_FORWARD FOR
SELECT SubscriberID,Balance
FROM Subscribers
WHERE SubscriberType='Prepaid'
AND Status='Active'
AND Balance<50;
BEGIN TRY
OPEN subscriber_cursor;
FETCH NEXT FROM subscriber_cursor INTO @SubscriberID,@Balance;
WHILE @@FETCH_STATUS=0
BEGIN
INSERT INTO NotificationLog(SubscriberID,NotificationMessage)
VALUES(@SubscriberID,'Your balance is below 50. Please recharge your account.');
FETCH NEXT FROM subscriber_cursor INTO @SubscriberID,@Balance;
END
CLOSE subscriber_cursor;
DEALLOCATE subscriber_cursor;
END TRY
BEGIN CATCH
IF CURSOR_STATUS('local','subscriber_cursor')>=0
CLOSE subscriber_cursor;
IF CURSOR_STATUS('local','subscriber_cursor')>-3
DEALLOCATE subscriber_cursor;
THROW;
END CATCH
END;
GO
-- Set-based approach to notify all low-balance subscribers
CREATE PROCEDURE usp_LowBalanceNotification_SetBased
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO NotificationLog(SubscriberID,NotificationMessage)
SELECT SubscriberID,'Your balance is below 50. Please recharge your account.'
FROM Subscribers
WHERE SubscriberType='Prepaid'
AND Status='Active'
AND Balance<50;
END;
GO
-- Measure cursor execution time
SET STATISTICS TIME ON;
DECLARE @CursorStart DATETIME2=SYSDATETIME();
EXEC usp_LowBalanceNotification_Cursor;
SELECT DATEDIFF(MICROSECOND,@CursorStart,SYSDATETIME()) AS CursorExecutionTimeMicroseconds;
SET STATISTICS TIME OFF;
-- Check cursor notifications
SELECT * FROM NotificationLog;
GO
-- Clear test notifications before testing the set-based approach
DELETE FROM NotificationLog;
GO
-- Measure set-based execution time
SET STATISTICS TIME ON;
DECLARE @SetStart DATETIME2=SYSDATETIME();
EXEC usp_LowBalanceNotification_SetBased;
SELECT DATEDIFF(MICROSECOND,@SetStart,SYSDATETIME()) AS SetBasedExecutionTimeMicroseconds;
SET STATISTICS TIME OFF;
-- Check set-based notifications
SELECT * FROM NotificationLog;
GO
