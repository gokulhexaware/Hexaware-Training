USE HospitalDB;
GO
SET NOCOUNT ON;
GO
DELETE FROM admission_audit;
GO
PRINT 'TEST 1: SINGLE ROW ADMISSION';
INSERT INTO admission(admission_id,patient_name,ward_id)
VALUES(104,'Jadeja',1);
SELECT * FROM admission WHERE admission_id=104;
GO
PRINT 'TEST 2: VERIFY INSERT AUDIT';
SELECT * FROM admission_audit ORDER BY audit_id;
GO
PRINT 'TEST 3: UPDATE ADMISSION';
UPDATE admission
SET ward_id=3
WHERE admission_id=104;
SELECT * FROM admission WHERE admission_id=104;
SELECT * FROM admission_audit ORDER BY audit_id;
GO
PRINT 'TEST 4: DELETE ADMISSION';
DELETE FROM admission
WHERE admission_id=104;
SELECT * FROM admission_audit ORDER BY audit_id;
GO
PRINT 'TEST 5: MULTI ROW INSERT WITH ONE WARD EXCEEDING CAPACITY';
BEGIN TRY
INSERT INTO admission(admission_id,patient_name,ward_id)
VALUES
(105,'Bumrah',1),
(106,'Rahul',2),
(107,'Hardik',2);
PRINT 'All admissions inserted successfully.';
END TRY
BEGIN CATCH
PRINT 'ADMISSION REJECTED';
PRINT ERROR_MESSAGE();
END CATCH;
GO
PRINT 'TEST 6: VERIFY WARD OCCUPANCY';
SELECT w.ward_id,w.ward_name,w.capacity,COUNT(a.admission_id) AS occupied_beds,
w.capacity-COUNT(a.admission_id) AS available_beds
FROM ward w
LEFT JOIN admission a ON w.ward_id=a.ward_id
GROUP BY w.ward_id,w.ward_name,w.capacity
ORDER BY w.ward_id;
GO
PRINT 'TEST 7: VERIFY MULTI ROW INSERT REJECTION';
SELECT * FROM admission
WHERE admission_id IN(105,106,107);
GO
PRINT 'FINAL ADMISSION AUDIT';
SELECT * FROM admission_audit ORDER BY audit_id;
GO
PRINT 'ALL TESTS COMPLETED';
GO
