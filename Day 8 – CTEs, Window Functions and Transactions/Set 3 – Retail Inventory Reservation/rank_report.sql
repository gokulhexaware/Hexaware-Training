USE RetailInventoryDB;
-- Insert sample sales orders for reporting
INSERT INTO Orders(CustomerName,OrderDate,OrderStatus)
VALUES
('Vijay','2026-01-10','Confirmed'),
('Dhoni','2026-01-15','Confirmed'),
('Kohli','2026-01-20','Confirmed'),
('Rajinikanth','2026-02-10','Confirmed'),
('Suriya','2026-02-15','Confirmed'),
('Vijay','2026-02-20','Confirmed'),
('Dhoni','2026-03-10','Confirmed'),
('Kohli','2026-03-15','Confirmed'),
('Suriya','2026-03-20','Confirmed');
GO
INSERT INTO OrderLines(OrderID,ProductID,Quantity,UnitPrice)
VALUES
(2,101,5,2500),
(2,102,2,45000),
(3,101,3,2500),
(3,103,6,3000),
(4,102,4,45000),
(4,104,3,8500),
(5,103,8,3000),
(5,105,10,500),
(6,101,7,2500),
(6,106,5,700),
(7,102,3,45000),
(7,104,5,8500),
(8,103,4,3000),
(8,105,15,500),
(9,107,6,4000),
(9,108,8,1200),
(10,109,4,900),
(10,106,3,700);
GO
-- TASK 3: Rank products by sales within each category
WITH ProductSales AS(
SELECT
P.ProductID,
P.ProductName,
C.CategoryName,
SUM(OL.Quantity) AS TotalUnitsSold,
SUM(OL.Quantity*OL.UnitPrice) AS TotalSales
FROM Products P
INNER JOIN Categories C ON P.CategoryID=C.CategoryID
INNER JOIN OrderLines OL ON P.ProductID=OL.ProductID
INNER JOIN Orders O ON OL.OrderID=O.OrderID
WHERE O.OrderStatus='Confirmed'
GROUP BY P.ProductID,P.ProductName,C.CategoryName
),
RankedProducts AS(
SELECT
ProductID,
ProductName,
CategoryName,
TotalUnitsSold,
TotalSales,
ROW_NUMBER() OVER(
PARTITION BY CategoryName
ORDER BY TotalSales DESC,ProductID
) AS SalesRank
FROM ProductSales
)
SELECT
ProductID,
ProductName,
CategoryName,
TotalUnitsSold,
TotalSales,
SalesRank
FROM RankedProducts
WHERE SalesRank<=3
ORDER BY CategoryName,SalesRank;
GO
-- TASK 4: Calculate monthly sales and month-on-month changes
WITH MonthlySales AS(
SELECT
P.ProductID,
P.ProductName,
DATEFROMPARTS(YEAR(O.OrderDate),MONTH(O.OrderDate),1) AS SalesMonth,
SUM(OL.Quantity*OL.UnitPrice) AS MonthlyRevenue
FROM Products P
INNER JOIN OrderLines OL ON P.ProductID=OL.ProductID
INNER JOIN Orders O ON OL.OrderID=O.OrderID
WHERE O.OrderStatus='Confirmed'
GROUP BY
P.ProductID,
P.ProductName,
YEAR(O.OrderDate),
MONTH(O.OrderDate)
),
SalesComparison AS(
SELECT
ProductID,
ProductName,
SalesMonth,
MonthlyRevenue,
LAG(MonthlyRevenue) OVER(
PARTITION BY ProductID
ORDER BY SalesMonth
) AS PreviousMonthSales,
LEAD(MonthlyRevenue) OVER(
PARTITION BY ProductID
ORDER BY SalesMonth
) AS NextMonthSales
FROM MonthlySales
)
SELECT
ProductID,
ProductName,
SalesMonth,
MonthlyRevenue,
PreviousMonthSales,
MonthlyRevenue-PreviousMonthSales AS ChangeFromPreviousMonth,
NextMonthSales,
NextMonthSales-MonthlyRevenue AS ChangeToNextMonth
FROM SalesComparison
ORDER BY ProductID,SalesMonth;
GO
