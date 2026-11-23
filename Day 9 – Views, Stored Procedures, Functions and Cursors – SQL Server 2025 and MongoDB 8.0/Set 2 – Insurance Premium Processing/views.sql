CREATE DATABASE InsuranceDB;
GO
USE InsuranceDB;
GO
CREATE TABLE Customers(
CustomerID INT PRIMARY KEY,
CustomerName VARCHAR(100) NOT NULL,
Email VARCHAR(100),
Phone VARCHAR(15),
Address VARCHAR(200),
NationalID VARCHAR(30)
);
CREATE TABLE Agents(
AgentID INT PRIMARY KEY,
AgentName VARCHAR(100) NOT NULL
);
CREATE TABLE Policies(
PolicyID INT PRIMARY KEY,
CustomerID INT NOT NULL,
AgentID INT NOT NULL,
PolicyType VARCHAR(50) NOT NULL,
PremiumAmount DECIMAL(10,2) NOT NULL,
PolicyStatus VARCHAR(20) NOT NULL,
PolicyEndDate DATE NOT NULL,
PremiumDueDate DATE NOT NULL,
PaymentStatus VARCHAR(20) NOT NULL,
FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
FOREIGN KEY(AgentID) REFERENCES Agents(AgentID)
);
CREATE TABLE Claims(
ClaimID INT PRIMARY KEY,
PolicyID INT NOT NULL,
ClaimStatus VARCHAR(20) NOT NULL,
FOREIGN KEY(PolicyID) REFERENCES Policies(PolicyID)
);
CREATE TABLE PremiumAudit(
AuditID INT IDENTITY(1,1) PRIMARY KEY,
PolicyID INT NOT NULL,
OldPremium DECIMAL(10,2),
NewPremium DECIMAL(10,2),
AuditDate DATETIME2 DEFAULT SYSDATETIME(),
Remarks VARCHAR(200),
FOREIGN KEY(PolicyID) REFERENCES Policies(PolicyID)
);
CREATE TABLE PolicyRenewals(
RenewalID INT IDENTITY(1,1) PRIMARY KEY,
PolicyID INT NOT NULL,
RenewalDate DATE NOT NULL,
NewPremium DECIMAL(10,2) NOT NULL,
FOREIGN KEY(PolicyID) REFERENCES Policies(PolicyID)
);
CREATE TABLE PolicyStatusLog(
LogID INT IDENTITY(1,1) PRIMARY KEY,
PolicyID INT NOT NULL,
OldStatus VARCHAR(20),
NewStatus VARCHAR(20),
LogDate DATETIME2 DEFAULT SYSDATETIME(),
Remarks VARCHAR(200),
FOREIGN KEY(PolicyID) REFERENCES Policies(PolicyID)
);
INSERT INTO Customers VALUES
(1,'Arun','arun@gmail.com','9876543210','Coimbatore','ID1001'),
(2,'Priya','priya@gmail.com','9876543211','Chennai','ID1002'),
(3,'Kumar','kumar@gmail.com','9876543212','Madurai','ID1003');
INSERT INTO Agents VALUES
(101,'Ravi'),
(102,'Meena');
INSERT INTO Policies VALUES
(1001,1,101,'Health',12000,'Active',DATEADD(DAY,15,CAST(GETDATE() AS DATE)),DATEADD(DAY,15,CAST(GETDATE() AS DATE)),'Unpaid'),
(1002,2,102,'Life',18000,'Active',DATEADD(DAY,25,CAST(GETDATE() AS DATE)),DATEADD(DAY,25,CAST(GETDATE() AS DATE)),'Paid'),
(1003,3,101,'Vehicle',8000,'Active',DATEADD(DAY,60,CAST(GETDATE() AS DATE)),DATEADD(DAY,-5,CAST(GETDATE() AS DATE)),'Unpaid');
INSERT INTO Claims VALUES
(1,1001,'Approved'),
(2,1002,'Closed'),
(3,1003,'Pending');
GO
-- Displays policies due within the next 30 days without sensitive customer columns
CREATE VIEW vw_policy_due
AS
SELECT p.PolicyID,c.CustomerID,c.CustomerName,c.Email,c.Phone,
p.PolicyType,p.PremiumAmount,p.PolicyStatus,p.PolicyEndDate,p.PremiumDueDate
FROM Policies p
JOIN Customers c ON p.CustomerID=c.CustomerID
WHERE p.PolicyStatus='Active'
AND p.PolicyEndDate>=CAST(GETDATE() AS DATE)
AND p.PolicyEndDate<=DATEADD(DAY,30,CAST(GETDATE() AS DATE));
GO
SELECT * FROM vw_policy_due;
GO
