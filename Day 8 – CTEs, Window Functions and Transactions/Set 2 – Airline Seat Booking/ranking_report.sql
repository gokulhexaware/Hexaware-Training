USE AirlineBookingDB;
GO
-- Add more bookings for ranking and revenue demonstration
INSERT INTO Bookings(FlightID,PassengerID,SeatID,Fare)
VALUES
(1,102,2,5000.00),
(1,103,3,4000.00),
(2,104,4,7000.00),
(2,101,5,7000.00);
UPDATE Seats SET SeatStatus='Booked'
WHERE SeatID IN(2,3,4,5);
GO
-- TASK 3: Rank passengers by fare for each flight
SELECT
F.FlightNumber,
P.PassengerName,
B.Fare,
RANK() OVER(
PARTITION BY B.FlightID
ORDER BY B.Fare DESC
) AS FareRank,
DENSE_RANK() OVER(
PARTITION BY B.FlightID
ORDER BY B.Fare DESC
) AS DenseFareRank
FROM Bookings B
INNER JOIN Flights F ON B.FlightID=F.FlightID
INNER JOIN Passengers P ON B.PassengerID=P.PassengerID
ORDER BY F.FlightNumber,B.Fare DESC;
GO
-- TASK 4: CTE with ranking and running revenue
WITH FlightRevenue AS(
SELECT
B.BookingID,
B.FlightID,
F.FlightNumber,
P.PassengerName,
B.Fare,
B.BookingDate
FROM Bookings B
INNER JOIN Flights F ON B.FlightID=F.FlightID
INNER JOIN Passengers P ON B.PassengerID=P.PassengerID
),
RankedRevenue AS(
SELECT
BookingID,
FlightID,
FlightNumber,
PassengerName,
Fare,
BookingDate,
RANK() OVER(
PARTITION BY FlightID
ORDER BY Fare DESC
) AS FareRank,
DENSE_RANK() OVER(
PARTITION BY FlightID
ORDER BY Fare DESC
) AS DenseFareRank,
SUM(Fare) OVER(
PARTITION BY FlightID
ORDER BY BookingDate,BookingID
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS RunningRevenue
FROM FlightRevenue
)
SELECT
FlightNumber,
PassengerName,
Fare,
FareRank,
DenseFareRank,
RunningRevenue
FROM RankedRevenue
ORDER BY FlightNumber,BookingDate,BookingID;
GO
-- Total revenue for each flight
SELECT
F.FlightNumber,
SUM(B.Fare) AS TotalRevenue
FROM Flights F
INNER JOIN Bookings B ON F.FlightID=B.FlightID
GROUP BY F.FlightNumber
ORDER BY F.FlightNumber;
GO
