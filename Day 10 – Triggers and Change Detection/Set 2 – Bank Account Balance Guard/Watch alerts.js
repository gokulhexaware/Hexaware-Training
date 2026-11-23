
use bankDB
db.fraud_alerts.insertOne({alert_id:1,account_id:101,message:"Multiple failed login attempts",severity:"High",alert_time:new Date()})

const { MongoClient } = require("mongodb");
const uri = "mongodb://127.0.0.1:27017/?replicaSet=rs0";
const client = new MongoClient(uri);
async function main() {
try {
await client.connect();
const db = client.db("bankDB");
const alerts = db.collection("fraud_alerts");
const changeStream = alerts.watch([
{$match:{operationType:"insert"}}
]);
console.log("Watching for new fraud alerts...");
for await (const change of changeStream) {
const alert = change.fullDocument;
console.log("New Fraud Alert Detected");
console.log("Alert ID:",alert.alert_id);
console.log("Account ID:",alert.account_id);
console.log("Message:",alert.message);
console.log("Severity:",alert.severity);
console.log("Alert Time:",alert.alert_time);
console.log("----------------------------");
}
} catch(error) {
console.log("Error:",error.message);
} finally {
await client.close();
}
}
main();
