const bankDB = db.getSiblingDB("BankTransferDB");
// Create sample accounts if they do not already exist
bankDB.accounts.updateOne(
{accountId:1001},
{$setOnInsert:{accountId:1001,accountHolder:"Rajinikanth",balance:50000,status:"Active"}},
{upsert:true}
);
bankDB.accounts.updateOne(
{accountId:1002},
{$setOnInsert:{accountId:1002,accountHolder:"Vijay",balance:30000,status:"Active"}},
{upsert:true}
);
const session = db.getMongo().startSession();
const transactionDB = session.getDatabase("BankTransferDB");
const rajiniAccountID = 1001;
const vijayAccountID = 1002;
const dhoniTransferAmount = 5000;
const kohliTransferID = new ObjectId().toString();
try{
session.startTransaction({
readConcern:{level:"snapshot"},
writeConcern:{w:"majority"},
readPreference:"primary"
});
// Debit the source account
const debitResult = transactionDB.accounts.updateOne(
{accountId:rajiniAccountID,status:"Active",balance:{$gte:dhoniTransferAmount}},
{$inc:{balance:-dhoniTransferAmount}}
);
if(debitResult.matchedCount!==1){
throw new Error("Source account is inactive, missing or has insufficient balance.");
}
// Credit the destination account
const creditResult = transactionDB.accounts.updateOne(
{accountId:vijayAccountID,status:"Active"},
{$inc:{balance:dhoniTransferAmount}}
);
if(creditResult.matchedCount!==1){
throw new Error("Destination account is inactive or does not exist.");
}
// Record both sides of the transfer
transactionDB.transactions.insertMany([
{
transferId:kohliTransferID,
accountId:rajiniAccountID,
transactionType:"Debit",
amount:dhoniTransferAmount,
transactionDate:new Date()
},
{
transferId:kohliTransferID,
accountId:vijayAccountID,
transactionType:"Credit",
amount:dhoniTransferAmount,
transactionDate:new Date()
}
]);
session.commitTransaction();
print("Funds transfer completed successfully.");
}catch(error){
session.abortTransaction();
print("Transaction failed: "+error.message);
print("All transaction changes have been rolled back.");
}finally{
session.endSession();
}
// Verify the final account balances
print("Final account balances:");
printjson(bankDB.accounts.find(
{accountId:{$in:[rajiniAccountID,vijayAccountID]}},
{_id:0}
).toArray());
// Verify transaction records
print("Transaction history:");
printjson(bankDB.transactions.find(
{transferId:kohliTransferID},
{_id:0}
).toArray());
