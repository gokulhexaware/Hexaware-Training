CREATE DATABASE TelecomDB;
GO
USE TelecomDB;
GO
CREATE TABLE Subscribers(
SubscriberID INT PRIMARY KEY,
SubscriberName VARCHAR(100) NOT NULL,
PhoneNumber VARCHAR(15) NOT NULL,
SubscriberType VARCHAR(20) NOT NULL,
Balance DECIMAL(10,2) NOT NULL,
Status VARCHAR(20) NOT NULL,
ValidityEndDate DATE
);
CREATE TABLE RechargePlans(
PlanID INT PRIMARY KEY,
PlanName VARCHAR(100) NOT NULL,
ValidityDays INT NOT NULL,
IsActive BIT NOT NULL
);
CREATE TABLE RechargeHistory(
RechargeID INT IDENTITY(1,1) PRIMARY KEY,
SubscriberID INT NOT NULL,
PlanID INT NOT NULL,
RechargeAmount DECIMAL(10,2) NOT NULL,
RechargeDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
FOREIGN KEY(SubscriberID) REFERENCES Subscribers(SubscriberID),
FOREIGN KEY(PlanID) REFERENCES RechargePlans(PlanID)
);
CREATE TABLE NotificationLog(
NotificationID INT IDENTITY(1,1) PRIMARY KEY,
SubscriberID INT NOT NULL,
NotificationMessage VARCHAR(200) NOT NULL,
NotificationDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
IsRead BIT NOT NULL DEFAULT 0,
FOREIGN KEY(SubscriberID) REFERENCES Subscribers(SubscriberID)
);
INSERT INTO Subscribers VALUES
(1,'Arun','9876543210','Prepaid',25,'Active',DATEADD(DAY,10,CAST(GETDATE() AS DATE))),
(2,'Priya','9876543211','Prepaid',120,'Active',DATEADD(DAY,20,CAST(GETDATE() AS DATE))),
(3,'Kumar','9876543212','Prepaid',40,'Active',DATEADD(DAY,5,CAST(GETDATE() AS DATE))),
(4,'Divya','9876543213','Postpaid',500,'Active',DATEADD(DAY,30,CAST(GETDATE() AS DATE))),
(5,'Ravi','9876543214','Prepaid',15,'Active',DATEADD(DAY,2,CAST(GETDATE() AS DATE)));
INSERT INTO RechargePlans VALUES
(101,'Basic Plan',28,1),
(102,'Standard Plan',56,1),
(103,'Premium Plan',84,1);
INSERT INTO RechargeHistory(SubscriberID,PlanID,RechargeAmount,RechargeDate) VALUES
(1,101,100,DATEADD(DAY,-10,SYSDATETIME())),
(1,102,200,DATEADD(DAY,-5,SYSDATETIME())),
(2,101,100,DATEADD(DAY,-8,SYSDATETIME())),
(3,101,50,DATEADD(DAY,-3,SYSDATETIME())),
(5,103,300,DATEADD(DAY,-15,SYSDATETIME()));
GO
-- Displays prepaid subscribers and hides postpaid users
CREATE VIEW vw_prepaid_subscribers
AS
SELECT SubscriberID,SubscriberName,PhoneNumber,Balance,Status,ValidityEndDate
FROM Subscribers
WHERE SubscriberType='Prepaid';
GO
-- Displays recharge details for each subscriber
CREATE VIEW vw_recharge_summary
AS
SELECT s.SubscriberID,s.SubscriberName,
COUNT(r.RechargeID) AS TotalRecharges,
ISNULL(SUM(r.RechargeAmount),0) AS TotalRechargeAmount,
MAX(r.RechargeDate) AS LastRechargeDate
FROM Subscribers s
LEFT JOIN RechargeHistory r ON s.SubscriberID=r.SubscriberID
WHERE s.SubscriberType='Prepaid'
GROUP BY s.SubscriberID,s.SubscriberName;
GO
SELECT * FROM vw_prepaid_subscribers;
SELECT * FROM vw_recharge_summary;
GO
