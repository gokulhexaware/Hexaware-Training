use hospitalDB
db.ward_alerts.insertOne({alert_id:1,ward:"ICU Ward",severity:"critical",alert_time:new Date(),message:"Ward capacity reached"})
const { MongoClient } = require("mongodb");
const uri = "mongodb://127.0.0.1:27017/?replicaSet=rs0";
const client = new MongoClient(uri);
async function main() {
try {
await client.connect();
const db = client.db("hospitalDB");
const alerts = db.collection("ward_alerts");
const changeStream = alerts.watch([
{$match:{operationType:"insert","fullDocument.severity":"critical"}}
]);
console.log("Watching for critical ward alerts...");
for await (const change of changeStream) {
const alert = change.fullDocument;
console.log("Critical Ward Alert Detected");
console.log("Alert ID:",alert.alert_id);
console.log("Ward:",alert.ward);
console.log("Severity:",alert.severity);
console.log("Time:",alert.alert_time);
console.log("Message:",alert.message);
console.log("----------------------------");
}
} catch(error) {
console.log("Error:",error.message);
} finally {
await client.close();
}
}
main();
