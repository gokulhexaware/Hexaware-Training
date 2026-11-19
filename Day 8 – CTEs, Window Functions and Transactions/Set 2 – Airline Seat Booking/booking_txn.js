const airlineDB = db.getSiblingDB("AirlineBookingDB");
// Prepare sample flight, passenger and seat documents
airlineDB.flights.updateOne(
{flightId:1},
{$setOnInsert:{flightId:1,flightNumber:"MA101"}},
{upsert:true}
);
airlineDB.passengers.updateOne(
{passengerId:101},
{$setOnInsert:{passengerId:101,passengerName:"Rajinikanth"}},
{upsert:true}
);
airlineDB.seats.updateOne(
{flightId:1,seatNumber:"A1"},
{$setOnInsert:{flightId:1,seatNumber:"A1",seatStatus:"Available"}},
{upsert:true}
);
// Create a unique seat constraint
airlineDB.bookings.createIndex(
{flightId:1,seatNumber:1},
{unique:true}
);
const session = db.getMongo().startSession();
const transactionDB = session.getDatabase("AirlineBookingDB");
const dhoniFlightID = 1;
const rajiniPassengerID = 101;
const vijaySeatNumber = "A1";
const kohliFare = 5000;
try{
session.startTransaction({
readConcern:{level:"snapshot"},
writeConcern:{w:"majority"},
readPreference:"primary"
});
// Reserve the available seat
const seatResult = transactionDB.seats.updateOne(
{flightId:dhoniFlightID,seatNumber:vijaySeatNumber,seatStatus:"Available"},
{$set:{seatStatus:"Booked"}}
);
if(seatResult.modifiedCount!==1){
throw new Error("Seat is not available.");
}
// Insert the booking document
transactionDB.bookings.insertOne({
flightId:dhoniFlightID,
passengerId:rajiniPassengerID,
seatNumber:vijaySeatNumber,
fare:kohliFare,
bookingDate:new Date()
});
session.commitTransaction();
print("Airline seat booking completed successfully.");
}catch(error){
session.abortTransaction();
print("Booking failed: "+error.message);
print("Seat update and booking insertion rolled back.");
}finally{
session.endSession();
}
// Verify the seat and booking
print("Seat details:");
printjson(airlineDB.seats.findOne(
{flightId:dhoniFlightID,seatNumber:vijaySeatNumber}
));
print("Booking details:");
printjson(airlineDB.bookings.find(
{flightId:dhoniFlightID,seatNumber:vijaySeatNumber}
).toArray());
