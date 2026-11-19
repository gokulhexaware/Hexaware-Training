CREATE DATABASE BankTransferDB;
GO
USE BankTransferDB;
GO
CREATE TABLE Accounts(
AccountID INT PRIMARY KEY,
AccountHolder VARCHAR(100) NOT NULL,
Balance DECIMAL(18,2) NOT NULL CHECK(Balance>=0),
AccountStatus VARCHAR(20) NOT NULL CHECK(AccountStatus IN('Active','Inactive'))
);
GO
CREATE TABLE BankTransactions(
TransactionID INT IDENTITY(1,1) PRIMARY KEY,
AccountID INT NOT NULL,
TransactionType VARCHAR(30) NOT NULL,
Amount DECIMAL(18,2) NOT NULL CHECK(Amount>0),
TransactionDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
ReferenceNo VARCHAR(50) NOT NULL,
FOREIGN KEY(AccountID) REFERENCES Accounts(AccountID)
);
GO
-- Insert sample accounts using Tamil cinema and cricket names
INSERT INTO Accounts(AccountID,AccountHolder,Balance,AccountStatus)
VALUES
(1001,'Rajinikanth',50000.00,'Active'),
(1002,'Vijay',30000.00,'Active'),
(1003,'MS Dhoni',20000.00,'Inactive'),
(1004,'Virat Kohli',75000.00,'Active');
GO
-- Record opening balances in the transaction history
INSERT INTO BankTransactions(AccountID,TransactionType,Amount,TransactionDate,ReferenceNo)
VALUES
(1001,'Opening',50000.00,'2026-01-01','OPEN-1001'),
(1002,'Opening',30000.00,'2026-01-01','OPEN-1002'),
(1003,'Opening',20000.00,'2026-01-01','OPEN-1003'),
(1004,'Opening',75000.00,'2026-01-01','OPEN-1004');
GO
-- TASK 1: Successful funds transfer
DECLARE @RajiniFromAccountID INT=1001;
DECLARE @VijayToAccountID INT=1002;
DECLARE @DhoniTransferAmount DECIMAL(18,2)=5000.00;
DECLARE @KohliReferenceNo VARCHAR(50)='TRF-001';
DECLARE @RajiniBalance DECIMAL(18,2);
DECLARE @RajiniStatus VARCHAR(20);
DECLARE @VijayStatus VARCHAR(20);
BEGIN TRY
BEGIN TRANSACTION;
IF @DhoniTransferAmount<=0
THROW 51001,'Transfer amount must be greater than zero.',1;
IF @RajiniFromAccountID=@VijayToAccountID
THROW 51002,'Source and destination accounts must be different.',1;
-- Lock both accounts while checking and transferring money
SELECT @RajiniBalance=Balance,@RajiniStatus=AccountStatus
FROM Accounts WITH(UPDLOCK,HOLDLOCK)
WHERE AccountID=@RajiniFromAccountID;
SELECT @VijayStatus=AccountStatus
FROM Accounts WITH(UPDLOCK,HOLDLOCK)
WHERE AccountID=@VijayToAccountID;
IF @RajiniBalance IS NULL
THROW 51003,'Source account does not exist.',1;
IF @VijayStatus IS NULL
THROW 51004,'Destination account does not exist.',1;
IF @RajiniStatus<>'Active'
THROW 51005,'Source account is inactive.',1;
IF @VijayStatus<>'Active'
THROW 51006,'Destination account is inactive.',1;
IF @RajiniBalance<@DhoniTransferAmount
THROW 51007,'Insufficient account balance.',1;
UPDATE Accounts
SET Balance=Balance-@DhoniTransferAmount
WHERE AccountID=@RajiniFromAccountID;
IF @@ROWCOUNT<>1
THROW 51008,'Debit operation failed.',1;
UPDATE Accounts
SET Balance=Balance+@DhoniTransferAmount
WHERE AccountID=@VijayToAccountID;
IF @@ROWCOUNT<>1
THROW 51009,'Credit operation failed.',1;
INSERT INTO BankTransactions(AccountID,TransactionType,Amount,ReferenceNo)
VALUES
(@RajiniFromAccountID,'Debit',@DhoniTransferAmount,@KohliReferenceNo),
(@VijayToAccountID,'Credit',@DhoniTransferAmount,@KohliReferenceNo);
COMMIT TRANSACTION;
PRINT 'Funds transfer completed successfully.';
END TRY
BEGIN CATCH
IF XACT_STATE()<>0
ROLLBACK TRANSACTION;
PRINT CONCAT('Transfer failed: ',ERROR_MESSAGE());
THROW;
END CATCH;
GO
-- Verify successful transfer
SELECT * FROM Accounts ORDER BY AccountID;
SELECT * FROM BankTransactions ORDER BY TransactionID;
GO
-- TASK 2: Deliberate failure after debit to demonstrate rollback
DECLARE @SuriyaBalanceBefore DECIMAL(18,2);
DECLARE @AjithBalanceBefore DECIMAL(18,2);
DECLARE @SuriyaBalanceAfter DECIMAL(18,2);
DECLARE @AjithBalanceAfter DECIMAL(18,2);
SELECT @SuriyaBalanceBefore=Balance FROM Accounts WHERE AccountID=1001;
SELECT @AjithBalanceBefore=Balance FROM Accounts WHERE AccountID=1002;
PRINT 'Balances before deliberate failure:';
SELECT AccountID,AccountHolder,Balance
FROM Accounts
WHERE AccountID IN(1001,1002);
BEGIN TRY
BEGIN TRANSACTION;
-- Perform debit first
UPDATE Accounts
SET Balance=Balance-2000.00
WHERE AccountID=1001 AND AccountStatus='Active' AND Balance>=2000.00;
IF @@ROWCOUNT<>1
THROW 51010,'Debit failed.',1;
-- Generate an intentional error after the debit
THROW 51011,'Intentional failure to test rollback.',1;
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
IF XACT_STATE()<>0
ROLLBACK TRANSACTION;
PRINT CONCAT('Expected error: ',ERROR_MESSAGE());
PRINT 'Transaction rolled back successfully.';
END CATCH;
SELECT @SuriyaBalanceAfter=Balance FROM Accounts WHERE AccountID=1001;
SELECT @AjithBalanceAfter=Balance FROM Accounts WHERE AccountID=1002;
PRINT 'Balances after rollback:';
SELECT AccountID,AccountHolder,Balance
FROM Accounts
WHERE AccountID IN(1001,1002);
SELECT
@SuriyaBalanceBefore AS RajiniBalanceBefore,
@SuriyaBalanceAfter AS RajiniBalanceAfter,
@AjithBalanceBefore AS VijayBalanceBefore,
@AjithBalanceAfter AS VijayBalanceAfter,
CASE
WHEN @SuriyaBalanceBefore=@SuriyaBalanceAfter
AND @AjithBalanceBefore=@AjithBalanceAfter
THEN 'ROLLBACK VERIFIED - BALANCES UNCHANGED'
ELSE 'ROLLBACK VERIFICATION FAILED'
END AS RollbackResult;
GO
-- TASK 3: SAVEPOINT demonstration
DECLARE @RajiniSaveAmount DECIMAL(18,2)=1000.00;
DECLARE @DhoniFee DECIMAL(18,2)=100.00;
BEGIN TRY
BEGIN TRANSACTION;
-- Validate both accounts before transferring
IF NOT EXISTS(SELECT 1 FROM Accounts WHERE AccountID=1001 AND AccountStatus='Active' AND Balance>=@RajiniSaveAmount)
THROW 51012,'Source account is inactive or has insufficient balance.',1;
IF NOT EXISTS(SELECT 1 FROM Accounts WHERE AccountID=1002 AND AccountStatus='Active')
THROW 51013,'Destination account is inactive or missing.',1;
-- Complete the main transfer
UPDATE Accounts SET Balance=Balance-@RajiniSaveAmount WHERE AccountID=1001;
UPDATE Accounts SET Balance=Balance+@RajiniSaveAmount WHERE AccountID=1002;
INSERT INTO BankTransactions(AccountID,TransactionType,Amount,ReferenceNo)
VALUES
(1001,'Debit',@RajiniSaveAmount,'TRF-SAVE-001'),
(1002,'Credit',@RajiniSaveAmount,'TRF-SAVE-001');
-- Create savepoint after the successful transfer
SAVE TRANSACTION FeeSavepoint;
-- Attempt to post a separate transfer fee
UPDATE Accounts SET Balance=Balance-@DhoniFee WHERE AccountID=1001;
INSERT INTO BankTransactions(AccountID,TransactionType,Amount,ReferenceNo)
VALUES(1001,'Fee',@DhoniFee,'FEE-SAVE-001');
-- Roll back only the fee operation
ROLLBACK TRANSACTION FeeSavepoint;
-- Keep the main transfer and commit it
COMMIT TRANSACTION;
PRINT 'Main transfer committed successfully.';
PRINT 'Fee posting rolled back to savepoint.';
END TRY
BEGIN CATCH
IF XACT_STATE()<>0
ROLLBACK TRANSACTION;
PRINT CONCAT('Savepoint transaction failed: ',ERROR_MESSAGE());
THROW;
END CATCH;
GO
-- Verify that the transfer exists and the fee does not
SELECT * FROM Accounts ORDER BY AccountID;
SELECT * FROM BankTransactions
WHERE ReferenceNo IN('TRF-SAVE-001','FEE-SAVE-001')
ORDER BY TransactionID;
GO
