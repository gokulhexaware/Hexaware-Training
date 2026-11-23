USE RetailAuditDB;
GO
SET NOCOUNT ON;
GO
DISABLE TRIGGER trg_price_audit ON product_price;
DISABLE TRIGGER trg_check_price ON product_price;
UPDATE product_price SET selling_price=CASE product_id WHEN 1 THEN 2000 WHEN 2 THEN 1800 WHEN 3 THEN 1200 WHEN 4 THEN 1400 WHEN 5 THEN 1600 END;
ENABLE TRIGGER trg_price_audit ON product_price;
ENABLE TRIGGER trg_check_price ON product_price;
DELETE FROM price_audit;
DELETE FROM rejected_price_audit;
GO
PRINT 'TEST 1: SINGLE ROW VALID UPDATE';
UPDATE product_price
SET selling_price=2100
WHERE product_id=1;
SELECT * FROM product_price WHERE product_id=1;
SELECT * FROM price_audit;
GO
PRINT 'TEST 2: MULTI ROW VALID UPDATE';
UPDATE product_price
SET selling_price=selling_price+100
WHERE product_id IN(2,3);
SELECT * FROM product_price WHERE product_id IN(2,3);
SELECT * FROM price_audit;
GO
PRINT 'TEST 3: SINGLE ROW REJECTED UPDATE';
UPDATE product_price
SET selling_price=500
WHERE product_id=4;
SELECT * FROM product_price WHERE product_id=4;
SELECT * FROM rejected_price_audit;
GO
PRINT 'TEST 4: MULTI ROW UPDATE WITH ONE INVALID PRICE';
UPDATE product_price
SET selling_price=CASE
WHEN product_id=4 THEN 800
WHEN product_id=5 THEN 1700
END
WHERE product_id IN(4,5);
SELECT * FROM product_price WHERE product_id IN(4,5);
SELECT * FROM rejected_price_audit;
GO
PRINT 'FINAL SUCCESSFUL PRICE AUDIT';
SELECT * FROM price_audit ORDER BY audit_id;
GO
PRINT 'FINAL REJECTED PRICE AUDIT';
SELECT * FROM rejected_price_audit ORDER BY reject_id;
GO
