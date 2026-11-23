
USE InsuranceDB;
GO
-- Calculates premium with a 10 percent discount when there are no claims
CREATE FUNCTION fn_PremiumWithNoClaimDiscount
(@PolicyID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
DECLARE @Premium DECIMAL(10,2);
SELECT @Premium=PremiumAmount
FROM Policies
WHERE PolicyID=@PolicyID;
IF @Premium IS NULL
RETURN NULL;
IF NOT EXISTS(SELECT 1 FROM Claims WHERE PolicyID=@PolicyID)
SET @Premium=@Premium*0.90;
RETURN @Premium;
END;
GO
-- Returns renewal quotes for all active policies handled by an agent
CREATE FUNCTION fn_AgentRenewalQuotes
(@AgentID INT)
RETURNS TABLE
AS
RETURN
(
SELECT p.PolicyID,p.CustomerID,c.CustomerName,p.PolicyType,
p.PremiumAmount AS CurrentPremium,
dbo.fn_PremiumWithNoClaimDiscount(p.PolicyID) AS RenewalPremium,
p.PolicyEndDate
FROM Policies p
JOIN Customers c ON p.CustomerID=c.CustomerID
WHERE p.AgentID=@AgentID
AND p.PolicyStatus='Active'
);
GO
-- Renews a policy after checking its status and pending claims
CREATE PROCEDURE usp_RenewPolicy
@PolicyID INT
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;
DECLARE @OldPremium DECIMAL(10,2);
DECLARE @NewPremium DECIMAL(10,2);
DECLARE @OldEndDate DATE;
BEGIN TRY
BEGIN TRANSACTION;
SELECT @OldPremium=PremiumAmount,@OldEndDate=PolicyEndDate
FROM Policies WITH(UPDLOCK,HOLDLOCK)
WHERE PolicyID=@PolicyID AND PolicyStatus='Active';
IF @OldPremium IS NULL
THROW 50001,'Policy does not exist or is not active.',1;
IF EXISTS(
SELECT 1 FROM Claims
WHERE PolicyID=@PolicyID AND ClaimStatus='Pending'
)
THROW 50002,'Policy cannot be renewed due to a pending claim.',1;
SET @NewPremium=dbo.fn_PremiumWithNoClaimDiscount(@PolicyID);
IF @NewPremium IS NULL
THROW 50003,'Premium calculation failed.',1;
INSERT INTO PremiumAudit(PolicyID,OldPremium,NewPremium,Remarks)
VALUES(@PolicyID,@OldPremium,@NewPremium,'Premium recalculated during policy renewal.');
INSERT INTO PolicyRenewals(PolicyID,RenewalDate,NewPremium)
VALUES(@PolicyID,DATEADD(DAY,1,@OldEndDate),@NewPremium);
UPDATE Policies
SET PremiumAmount=@NewPremium,
PolicyEndDate=DATEADD(YEAR,1,@OldEndDate),
PremiumDueDate=DATEADD(YEAR,1,@OldEndDate),
PaymentStatus='Unpaid'
WHERE PolicyID=@PolicyID;
COMMIT TRANSACTION;
SELECT @PolicyID AS PolicyID,@OldPremium AS OldPremium,
@NewPremium AS NewPremium,'Renewed Successfully' AS Result;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0
ROLLBACK TRANSACTION;
THROW;
END CATCH
END;
GO
-- Test the scalar function
SELECT dbo.fn_PremiumWithNoClaimDiscount(1001) AS DiscountedPremium;
-- Test the table-valued function
SELECT * FROM dbo.fn_AgentRenewalQuotes(101);
-- Test the renewal procedure
EXEC usp_RenewPolicy @PolicyID=1001;
-- Check the audit record
SELECT * FROM PremiumAudit;
-- Check the renewal record
SELECT * FROM PolicyRenewals;
GO
