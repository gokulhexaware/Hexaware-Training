CREATE DATABASE AirlineBookingDB;
USE AirlineBookingDB;
CREATE TABLE Flights(
FlightID INT PRIMARY KEY,
FlightNumber VARCHAR(20) NOT NULL,
SourceCity VARCHAR(50) NOT NULL,
DestinationCity VARCHAR(50) NOT NULL
);
GO
CREATE TABLE Passengers(
PassengerID INT PRIMARY KEY,
PassengerName VARCHAR(100) NOT NULL
);
GO
CREATE TABLE Seats(
SeatID INT PRIMARY KEY,
FlightID INT NOT NULL,
SeatNumber VARCHAR(10) NOT NULL,
SeatStatus VARCHAR(20) NOT NULL CHECK(SeatStatus IN('Available','Booked')),
FOREIGN KEY(FlightID) REFERENCES Flights(FlightID),
UNIQUE(FlightID,SeatNumber)
);
GO
CREATE TABLE Bookings(
BookingID INT IDENTITY(1,1) PRIMARY KEY,
FlightID INT NOT NULL,
PassengerID INT NOT NULL,
SeatID INT NOT NULL,
Fare DECIMAL(10,2) NOT NULL CHECK(Fare>0),
BookingDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
FOREIGN KEY(FlightID) REFERENCES Flights(FlightID),
FOREIGN KEY(PassengerID) REFERENCES Passengers(PassengerID),
FOREIGN KEY(SeatID) REFERENCES Seats(SeatID),
CONSTRAINT UQ_Bookings_Seat UNIQUE(SeatID)
);
GO
INSERT INTO Flights VALUES
(1,'MA101','Chennai','Mumbai'),
(2,'MA202','Coimbatore','Bangalore');
INSERT INTO Passengers VALUES
(101,'Rajinikanth'),
(102,'Vijay'),
(103,'MS Dhoni'),
(104,'Virat Kohli');
INSERT INTO Seats VALUES
(1,1,'A1','Available'),
(2,1,'A2','Available'),
(3,1,'A3','Available'),
(4,2,'B1','Available'),
(5,2,'B2','Available');
GO
-- TASK 1: Book a seat inside one transaction
DECLARE @DhoniFlightID INT=1;
DECLARE @RajiniPassengerID INT=101;
DECLARE @VijaySeatID INT=1;
DECLARE @KohliFare DECIMAL(10,2)=5000.00;
BEGIN TRY
BEGIN TRANSACTION;
-- Lock the seat while checking its availability
IF NOT EXISTS(
SELECT 1 FROM Seats WITH(UPDLOCK,HOLDLOCK)
WHERE SeatID=@VijaySeatID
AND FlightID=@DhoniFlightID
AND SeatStatus='Available'
)
THROW 52001,'Seat is unavailable or does not belong to this flight.',1;
-- Insert booking record
INSERT INTO Bookings(FlightID,PassengerID,SeatID,Fare)
VALUES(@DhoniFlightID,@RajiniPassengerID,@VijaySeatID,@KohliFare);
-- Update seat status
UPDATE Seats
SET SeatStatus='Booked'
WHERE SeatID=@VijaySeatID
AND SeatStatus='Available';
IF @@ROWCOUNT<>1
THROW 52002,'Seat status update failed.',1;
COMMIT TRANSACTION;
PRINT 'Seat booking completed successfully.';
END TRY
BEGIN CATCH
IF XACT_STATE()<>0
ROLLBACK TRANSACTION;
PRINT CONCAT('Booking failed: ',ERROR_MESSAGE());
THROW;
END CATCH;
GO
-- Verify the booking
SELECT B.BookingID,F.FlightNumber,P.PassengerName,S.SeatNumber,B.Fare,S.SeatStatus
FROM Bookings B
INNER JOIN Flights F ON B.FlightID=F.FlightID
INNER JOIN Passengers P ON B.PassengerID=P.PassengerID
INNER JOIN Seats S ON B.SeatID=S.SeatID;
GO
-- TASK 2: Demonstrate duplicate booking prevention
-- Run this block after the successful booking above
DECLARE @DhoniFlightID2 INT=1;
DECLARE @VijayPassengerID INT=102;
DECLARE @AlreadyBookedSeatID INT=1;
BEGIN TRY
BEGIN TRANSACTION;
IF NOT EXISTS(
SELECT 1 FROM Seats WITH(UPDLOCK,HOLDLOCK)
WHERE SeatID=@AlreadyBookedSeatID
AND FlightID=@DhoniFlightID2
AND SeatStatus='Available'
)
THROW 52003,'This seat has already been booked.',1;
INSERT INTO Bookings(FlightID,PassengerID,SeatID,Fare)
VALUES(@DhoniFlightID2,@VijayPassengerID,@AlreadyBookedSeatID,4500.00);
UPDATE Seats SET SeatStatus='Booked'
WHERE SeatID=@AlreadyBookedSeatID;
COMMIT TRANSACTION;
PRINT 'Booking completed.';
END TRY
BEGIN CATCH
IF XACT_STATE()<>0
ROLLBACK TRANSACTION;
PRINT CONCAT('Expected booking rejection: ',ERROR_MESSAGE());
END CATCH;
GO
-- Verify that only one booking exists for seat A1
SELECT SeatID,COUNT(*) AS BookingCount
FROM Bookings
WHERE SeatID=1
GROUP BY SeatID;
GO
-- SERIALIZABLE concurrency demonstration
-- Run this in Session 1 and Session 2 as described in booking_notes.txt
