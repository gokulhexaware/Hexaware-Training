IF DB_ID('HospitalDB') IS NULL
CREATE DATABASE HospitalDB;
GO
USE HospitalDB;
GO
IF OBJECT_ID('trg_admission_capacity','TR') IS NOT NULL DROP TRIGGER trg_admission_capacity;
IF OBJECT_ID('trg_admission_audit','TR') IS NOT NULL DROP TRIGGER trg_admission_audit;
IF OBJECT_ID('admission_audit','U') IS NOT NULL DROP TABLE admission_audit;
IF OBJECT_ID('admission','U') IS NOT NULL DROP TABLE admission;
IF OBJECT_ID('ward','U') IS NOT NULL DROP TABLE ward;
GO
CREATE TABLE ward(
ward_id INT PRIMARY KEY,
ward_name VARCHAR(100),
capacity INT
);
GO
CREATE TABLE admission(
admission_id INT PRIMARY KEY,
patient_name VARCHAR(100),
ward_id INT,
admission_date DATETIME2 DEFAULT SYSDATETIME(),
FOREIGN KEY(ward_id) REFERENCES ward(ward_id)
);
GO
CREATE TABLE admission_audit(
audit_id INT IDENTITY(1,1) PRIMARY KEY,
admission_id INT,
patient_name VARCHAR(100),
old_ward_id INT,
new_ward_id INT,
action_type VARCHAR(20),
changed_by VARCHAR(100),
changed_at DATETIME2
);
GO
INSERT INTO ward VALUES
(1,'General Ward',2),
(2,'ICU Ward',2),
(3,'Emergency Ward',3);
GO
INSERT INTO admission(admission_id,patient_name,ward_id) VALUES
(101,'Virat Kohli',1),
(102,'Rohit Sharma',2),
(103,'MS Dhoni',3);
GO
CREATE OR ALTER TRIGGER trg_admission_capacity
ON admission
INSTEAD OF INSERT
AS
BEGIN
SET NOCOUNT ON;
IF EXISTS(
SELECT i.ward_id
FROM inserted i
GROUP BY i.ward_id
HAVING
(SELECT COUNT(*) FROM admission a WHERE a.ward_id=i.ward_id)
+ COUNT(*) > (SELECT w.capacity FROM ward w WHERE w.ward_id=i.ward_id)
)
BEGIN
THROW 50002,'Admission rejected: Ward bed capacity exceeded.',1;
END;
INSERT INTO admission(admission_id,patient_name,ward_id,admission_date)
SELECT admission_id,patient_name,ward_id,admission_date
FROM inserted;
END;
GO
CREATE OR ALTER TRIGGER trg_admission_audit
ON admission
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO admission_audit(admission_id,patient_name,old_ward_id,new_ward_id,action_type,changed_by,changed_at)
SELECT
COALESCE(i.admission_id,d.admission_id),
COALESCE(i.patient_name,d.patient_name),
d.ward_id,
i.ward_id,
CASE
WHEN d.admission_id IS NULL THEN 'INSERT'
WHEN i.admission_id IS NULL THEN 'DELETE'
ELSE 'UPDATE'
END,
SUSER_SNAME(),
SYSDATETIME()
FROM inserted i
FULL OUTER JOIN deleted d ON i.admission_id=d.admission_id;
END;
GO
