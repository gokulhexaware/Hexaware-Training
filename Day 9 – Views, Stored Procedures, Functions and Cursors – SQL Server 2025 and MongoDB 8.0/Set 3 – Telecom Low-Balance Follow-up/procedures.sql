USE TelecomDB;
GO
-- Returns the remaining validity days for a subscriber
CREATE FUNCTION fn_ValidityDaysLeft
(@SubscriberID INT)
RETURNS INT
AS
BEGIN
DECLARE @DaysLeft INT;
SELECT @DaysLeft=DATEDIFF(DAY,CAST(GETDATE() AS DATE),ValidityEndDate)
FROM Subscribers
WHERE SubscriberID=@SubscriberID;
RETURN CASE WHEN @DaysLeft IS NULL OR @DaysLeft<0 THEN 0 ELSE @DaysLeft END;
END;
GO
-- Returns the last five recharges of a subscriber
CREATE FUNCTION fn_LastFiveRecharges
(@SubscriberID INT)
RETURNS TABLE
AS
RETURN
(
SELECT TOP (5) RechargeID,SubscriberID,PlanID,RechargeAmount,RechargeDate
FROM RechargeHistory
WHERE SubscriberID=@SubscriberID
ORDER BY RechargeDate DESC,RechargeID DESC
);
GO
-- Processes a recharge and updates subscriber balance
CREATE PROCEDURE usp_Recharge
@SubscriberID INT,
@PlanID INT,
@Amount DECIMAL(10,2),
@NewBalance DECIMAL(10,2) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET @NewBalance=NULL;
DECLARE @ValidityDays INT;
DECLARE @CurrentValidity DATE;
BEGIN TRY
BEGIN TRANSACTION;
IF @Amount IS NULL OR @Amount<=0
THROW 50001,'Recharge amount must be greater than zero.',1;
IF NOT EXISTS(
SELECT 1 FROM RechargePlans
WHERE PlanID=@PlanID AND IsActive=1
)
THROW 50002,'Invalid or inactive recharge plan.',1;
SELECT @CurrentValidity=ValidityEndDate
FROM Subscribers WITH(UPDLOCK,HOLDLOCK)
WHERE SubscriberID=@SubscriberID
AND SubscriberType='Prepaid'
AND Status='Active';
IF @@ROWCOUNT=0
THROW 50003,'Subscriber does not exist, is not prepaid or is inactive.',1;
SELECT @ValidityDays=ValidityDays
FROM RechargePlans
WHERE PlanID=@PlanID AND IsActive=1;
IF @ValidityDays IS NULL OR @ValidityDays<=0
THROW 50004,'Invalid plan validity.',1;
UPDATE Subscribers
SET Balance=Balance+@Amount,
ValidityEndDate=DATEADD(DAY,@ValidityDays,
CASE WHEN @CurrentValidity<CAST(GETDATE() AS DATE)
THEN CAST(GETDATE() AS DATE) ELSE @CurrentValidity END)
WHERE SubscriberID=@SubscriberID;
INSERT INTO RechargeHistory(SubscriberID,PlanID,RechargeAmount)
VALUES(@SubscriberID,@PlanID,@Amount);
SELECT @NewBalance=Balance
FROM Subscribers
WHERE SubscriberID=@SubscriberID;
COMMIT TRANSACTION;
SELECT @NewBalance AS NewBalance,'Recharge Successful' AS Result;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0
ROLLBACK TRANSACTION;
SET @NewBalance=NULL;
THROW;
END CATCH
END;
GO
-- Test the recharge procedure
DECLARE @Balance DECIMAL(10,2);
EXEC usp_Recharge
@SubscriberID=1,
@PlanID=101,
@Amount=100,
@NewBalance=@Balance OUTPUT;
SELECT @Balance AS NewBalance;
-- Test the validity function
SELECT dbo.fn_ValidityDaysLeft(1) AS ValidityDaysLeft;
-- Test the last five recharges function
SELECT * FROM dbo.fn_LastFiveRecharges(1);
GO
