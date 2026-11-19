USE BankTransferDB;
-- Select the current month's statement
DECLARE @RajiniMonthStart DATE=DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),1);
DECLARE @VijayNextMonth DATE=DATEADD(MONTH,1,@RajiniMonthStart);
-- Calculate the signed transaction amount
WITH TransactionDetails AS(
SELECT
T.TransactionID,
T.AccountID,
A.AccountHolder,
T.TransactionType,
T.Amount,
T.TransactionDate,
T.ReferenceNo,
CASE
WHEN T.TransactionType IN('Opening','Credit') THEN T.Amount
WHEN T.TransactionType IN('Debit','Fee') THEN -T.Amount
ELSE 0
END AS SignedAmount
FROM BankTransactions T
INNER JOIN Accounts A ON T.AccountID=A.AccountID
),
-- Calculate the running account balance
RunningBalances AS(
SELECT
TransactionID,
AccountID,
AccountHolder,
TransactionType,
Amount,
TransactionDate,
ReferenceNo,
SUM(SignedAmount) OVER(
PARTITION BY AccountID
ORDER BY TransactionDate,TransactionID
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS CurrentBalance
FROM TransactionDetails
),
-- Apply ROW_NUMBER and LAG to the statement
StatementDetails AS(
SELECT
TransactionID,
AccountID,
AccountHolder,
TransactionType,
Amount,
TransactionDate,
ReferenceNo,
ROW_NUMBER() OVER(
PARTITION BY AccountID
ORDER BY TransactionDate,TransactionID
) AS TransactionNumber,
LAG(CurrentBalance,1,0) OVER(
PARTITION BY AccountID
ORDER BY TransactionDate,TransactionID
) AS PreviousBalance,
CurrentBalance
FROM RunningBalances
)
-- Display only transactions belonging to the selected month
SELECT
AccountID,
AccountHolder,
TransactionNumber,
TransactionID,
TransactionType,
Amount,
PreviousBalance,
CurrentBalance,
TransactionDate,
ReferenceNo
FROM StatementDetails
WHERE TransactionDate>=@RajiniMonthStart
AND TransactionDate<@VijayNextMonth
ORDER BY AccountID,TransactionDate,TransactionID;
GO
