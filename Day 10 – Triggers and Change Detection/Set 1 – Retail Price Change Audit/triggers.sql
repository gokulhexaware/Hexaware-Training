CREATE DATABASE RetailAuditDB;
GO
USE RetailAuditDB;
GO
CREATE TABLE product_price(
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
cost_price DECIMAL(10,2),
selling_price DECIMAL(10,2)
);
GO
CREATE TABLE price_audit(
audit_id INT IDENTITY(1,1) PRIMARY KEY,
product_id INT,
old_price DECIMAL(10,2),
new_price DECIMAL(10,2),
changed_by VARCHAR(100),
changed_at DATETIME2
);
GO
CREATE TABLE rejected_price_audit(
reject_id INT IDENTITY(1,1) PRIMARY KEY,
product_id INT,
attempted_price DECIMAL(10,2),
cost_price DECIMAL(10,2),
rejected_by VARCHAR(100),
rejected_at DATETIME2
);
GO
INSERT INTO product_price VALUES
(1,'Virat Bat',1500,2000),
(2,'Rohit Bat',1200,1800),
(3,'Dhoni Gloves',800,1200),
(4,'Jadeja Pads',900,1400),
(5,'Bumrah Shoes',1000,1600);
GO
CREATE OR ALTER TRIGGER trg_price_audit
ON product_price
AFTER UPDATE
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO price_audit(product_id,old_price,new_price,changed_by,changed_at)
SELECT d.product_id,d.selling_price,i.selling_price,SUSER_SNAME(),SYSDATETIME()
FROM deleted d
INNER JOIN inserted i ON d.product_id=i.product_id;
END;
GO
CREATE OR ALTER TRIGGER trg_check_price
ON product_price
INSTEAD OF UPDATE
AS
BEGIN
SET NOCOUNT ON;
IF EXISTS(SELECT 1 FROM inserted WHERE selling_price<cost_price)
BEGIN
INSERT INTO rejected_price_audit(product_id,attempted_price,cost_price,rejected_by,rejected_at)
SELECT product_id,selling_price,cost_price,SUSER_SNAME(),SYSDATETIME()
FROM inserted
WHERE selling_price<cost_price;
PRINT 'Update rejected: Selling price cannot be below cost price.';
RETURN;
END;
UPDATE p
SET p.product_name=i.product_name,
p.cost_price=i.cost_price,
p.selling_price=i.selling_price
FROM product_price p
INNER JOIN inserted i ON p.product_id=i.product_id;
END;
GO
