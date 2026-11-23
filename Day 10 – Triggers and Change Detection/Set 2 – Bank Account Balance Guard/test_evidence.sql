USE BankAuditDB;
GO
SET NOCOUNT ON;
GO
DELETE FROM transaction_audit;
GO
PRINT 'TEST 1: INSERT TRANSACTIONS';
INSERT INTO account_transaction(transaction_id,account_id,amount,transaction_type)
VALUES
(104,1,1500,'Deposit'),
(105,2,2500,'Withdrawal');
SELECT * FROM transaction_audit;
GO
PRINT 'TEST 2: UPDATE TRANSACTIONS';
UPDATE account_transaction
SET amount=CASE transaction_id
WHEN 101 THEN 2500
WHEN 102 THEN 3500
END
WHERE transaction_id IN(101,102);
SELECT * FROM transaction_audit;
GO
PRINT 'TEST 3: DELETE TRANSACTION';
DELETE FROM account_transaction
WHERE transaction_id=103;
SELECT * FROM transaction_audit;
GO
PRINT 'TEST 4: BATCH UPDATE OF FIVE ACCOUNTS';
BEGIN TRY
UPDATE vw_accounts
SET balance=CASE account_id
WHEN 1 THEN 11000
WHEN 2 THEN 16000
WHEN 3 THEN -500
WHEN 4 THEN 13000
WHEN 5 THEN 19000
END
WHERE account_id IN(1,2,3,4,5);
PRINT 'All account balances updated successfully.';
END TRY
BEGIN CATCH
PRINT 'UPDATE REJECTED';
PRINT ERROR_MESSAGE();
END CATCH;
GO
PRINT 'VERIFY ALL FIVE ACCOUNT BALANCES';
SELECT * FROM bank_account WHERE account_id IN(1,2,3,4,5);
GO
PRINT 'FINAL TRANSACTION AUDIT';
SELECT * FROM transaction_audit ORDER BY audit_id;
GO
PRINT 'TEST 5: NESTED TRIGGER DEMONSTRATION';
IF OBJECT_ID('trg_demo_child','TR') IS NOT NULL DROP TRIGGER trg_demo_child;
IF OBJECT_ID('trg_demo_parent','TR') IS NOT NULL DROP TRIGGER trg_demo_parent;
IF OBJECT_ID('trigger_demo_log','U') IS NOT NULL DROP TABLE trigger_demo_log;
IF OBJECT_ID('trigger_demo_child','U') IS NOT NULL DROP TABLE trigger_demo_child;
IF OBJECT_ID('trigger_demo_parent','U') IS NOT NULL DROP TABLE trigger_demo_parent;
GO
CREATE TABLE trigger_demo_parent(
id INT PRIMARY KEY,
player_name VARCHAR(50)
);
CREATE TABLE trigger_demo_child(
id INT PRIMARY KEY,
player_name VARCHAR(50)
);
CREATE TABLE trigger_demo_log(
log_id INT IDENTITY(1,1) PRIMARY KEY,
message VARCHAR(100)
);
GO
CREATE TRIGGER trg_demo_parent
ON trigger_demo_parent
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO trigger_demo_child(id,player_name)
SELECT id,player_name FROM inserted;
END;
GO
CREATE TRIGGER trg_demo_child
ON trigger_demo_child
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO trigger_demo_log(message)
SELECT 'Nested trigger executed for '+player_name FROM inserted;
END;
GO
INSERT INTO trigger_demo_parent VALUES(1,'Virat Kohli');
SELECT * FROM trigger_demo_log;
GO
PRINT 'TEST 6: RECURSIVE TRIGGER SETTINGS';
SELECT name,is_recursive_triggers_on
FROM sys.databases
WHERE name=DB_NAME();
EXEC sp_configure 'nested triggers';
GO
PRINT 'ALL TESTS COMPLETED';
GO
