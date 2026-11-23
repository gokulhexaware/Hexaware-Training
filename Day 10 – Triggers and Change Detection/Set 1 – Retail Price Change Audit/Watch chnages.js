
use retailDB
db.products.insertOne({product_id:1,name:"Virat Bat",price:2000})
db.runCommand({collMod:"products",changeStreamPreAndPostImages:{enabled:true}})

const { MongoClient } = require("mongodb");
const uri = "mongodb://127.0.0.1:27017/?replicaSet=rs0";
const client = new MongoClient(uri);
async function main() {
try {
await client.connect();
const db = client.db("retailDB");
const products = db.collection("products");
const changeStream = products.watch([
{$match:{operationType:"update","updateDescription.updatedFields.price":{$exists:true}}}
],{fullDocument:"updateLookup",fullDocumentBeforeChange:"whenAvailable"});
console.log("Watching product price changes...");
for await (const change of changeStream) {
const oldPrice = change.fullDocumentBeforeChange?.price ?? "Not available";
const newPrice = change.updateDescription.updatedFields.price;
console.log("Product ID:",change.documentKey.product_id);
console.log("Old Price:",oldPrice);
console.log("New Price:",newPrice);
console.log("Changed At:",change.clusterTime);
console.log("----------------------------");
}
} catch(error) {
console.log("Error:",error.message);
} finally {
await client.close();
}
}
main();
