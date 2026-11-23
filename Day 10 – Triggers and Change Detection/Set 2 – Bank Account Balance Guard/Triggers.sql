CREATE DATABASE BankAuditDB;
GO
USE BankAuditDB;
GO
CREATE TABLE bank_account(
account_id INT PRIMARY KEY,
account_holder VARCHAR(100),
account_type VARCHAR(20),
balance DECIMAL(12,2)
);
GO
CREATE TABLE account_transaction(
transaction_id INT PRIMARY KEY,
account_id INT,
amount DECIMAL(12,2),
transaction_type VARCHAR(20),
transaction_date DATETIME2 DEFAULT SYSDATETIME(),
FOREIGN KEY(account_id) REFERENCES bank_account(account_id)
);
GO
CREATE TABLE transaction_audit(
audit_id INT IDENTITY(1,1) PRIMARY KEY,
transaction_id INT,
account_id INT,
old_amount DECIMAL(12,2),
new_amount DECIMAL(12,2),
old_type VARCHAR(20),
new_type VARCHAR(20),
action_type VARCHAR(20),
changed_by VARCHAR(100),
changed_at DATETIME2
);
GO
INSERT INTO bank_account VALUES
(1,'Virat Kohli','Savings',10000),
(2,'Rohit Sharma','Savings',15000),
(3,'MS Dhoni','Savings',20000),
(4,'Jadeja','Savings',12000),
(5,'Bumrah','Savings',18000),
(6,'Rahul','Current',25000);
GO
INSERT INTO account_transaction(transaction_id,account_id,amount,transaction_type) VALUES
(101,1,2000,'Deposit'),
(102,2,3000,'Withdrawal'),
(103,3,5000,'Deposit');
GO
CREATE OR ALTER TRIGGER trg_transaction_audit
ON account_transaction
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO transaction_audit(transaction_id,account_id,old_amount,new_amount,old_type,new_type,action_type,changed_by,changed_at)
SELECT
i.transaction_id,
i.account_id,
d.amount,
i.amount,
d.transaction_type,
i.transaction_type,
CASE WHEN d.transaction_id IS NULL THEN 'INSERT' ELSE 'UPDATE' END,
SUSER_SNAME(),
SYSDATETIME()
FROM inserted i
LEFT JOIN deleted d ON i.transaction_id=d.transaction_id
UNION ALL
SELECT
d.transaction_id,
d.account_id,
d.amount,
NULL,
d.transaction_type,
NULL,
'DELETE',
SUSER_SNAME(),
SYSDATETIME()
FROM deleted d
LEFT JOIN inserted i ON d.transaction_id=i.transaction_id
WHERE i.transaction_id IS NULL;
END;
GO
CREATE OR ALTER VIEW vw_accounts
AS
SELECT account_id,account_holder,account_type,balance
FROM bank_account;
GO
CREATE OR ALTER TRIGGER trg_account_balance_guard
ON vw_accounts
INSTEAD OF UPDATE
AS
BEGIN
SET NOCOUNT ON;
IF EXISTS(
SELECT 1
FROM inserted
WHERE account_type='Savings' AND balance<0
)
BEGIN
THROW 50001,'Savings account balance cannot be negative.',1;
END;
UPDATE b
SET b.account_holder=i.account_holder,
b.account_type=i.account_type,
b.balance=i.balance
FROM bank_account b
INNER JOIN inserted i ON b.account_id=i.account_id;
END;
GO
