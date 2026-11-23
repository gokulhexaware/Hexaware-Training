
USE InsuranceDB;
GO
-- Cursor-based approach to update lapsed policies
CREATE PROCEDURE usp_LapsePolicies_Cursor
AS
BEGIN
SET NOCOUNT ON;
DECLARE @PolicyID INT;
DECLARE @OldStatus VARCHAR(20);
DECLARE policy_cursor CURSOR LOCAL FAST_FORWARD FOR
SELECT PolicyID,PolicyStatus
FROM Policies
WHERE PremiumDueDate<CAST(GETDATE() AS DATE)
AND PaymentStatus='Unpaid'
AND PolicyStatus='Active';
BEGIN TRY
OPEN policy_cursor;
FETCH NEXT FROM policy_cursor INTO @PolicyID,@OldStatus;
WHILE @@FETCH_STATUS=0
BEGIN
UPDATE Policies
SET PolicyStatus='Lapsed'
WHERE PolicyID=@PolicyID;
INSERT INTO PolicyStatusLog(PolicyID,OldStatus,NewStatus,Remarks)
VALUES(@PolicyID,@OldStatus,'Lapsed','Policy lapsed due to unpaid premium.');
FETCH NEXT FROM policy_cursor INTO @PolicyID,@OldStatus;
END
CLOSE policy_cursor;
DEALLOCATE policy_cursor;
END TRY
BEGIN CATCH
IF CURSOR_STATUS('local','policy_cursor')>=0
CLOSE policy_cursor;
IF CURSOR_STATUS('local','policy_cursor')>-3
DEALLOCATE policy_cursor;
THROW;
END CATCH
END;
GO
-- Set-based approach to update all lapsed policies together
CREATE PROCEDURE usp_LapsePolicies_SetBased
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
BEGIN TRANSACTION;
DECLARE @UpdatedPolicies TABLE(
PolicyID INT,
OldStatus VARCHAR(20)
);
UPDATE Policies
SET PolicyStatus='Lapsed'
OUTPUT inserted.PolicyID,deleted.PolicyStatus
INTO @UpdatedPolicies(PolicyID,OldStatus)
WHERE PremiumDueDate<CAST(GETDATE() AS DATE)
AND PaymentStatus='Unpaid'
AND PolicyStatus='Active';
INSERT INTO PolicyStatusLog(PolicyID,OldStatus,NewStatus,Remarks)
SELECT PolicyID,OldStatus,'Lapsed','Policy lapsed due to unpaid premium.'
FROM @UpdatedPolicies;
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0
ROLLBACK TRANSACTION;
THROW;
END CATCH
END;
GO
-- Test cursor implementation
EXEC usp_LapsePolicies_Cursor;
SELECT * FROM PolicyStatusLog;
GO
-- Reset test data before testing the set-based implementation
UPDATE Policies
SET PolicyStatus='Active'
WHERE PolicyStatus='Lapsed'
AND PaymentStatus='Unpaid'
AND PremiumDueDate<CAST(GETDATE() AS DATE);
DELETE FROM PolicyStatusLog;
GO
-- Test set-based implementation
EXEC usp_LapsePolicies_SetBased;
SELECT * FROM PolicyStatusLog;
SELECT * FROM Policies;
GO
