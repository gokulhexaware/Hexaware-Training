const retailDB = db.getSiblingDB("RetailInventoryDB");
// Create a sample product if it does not exist
retailDB.products.updateOne(
{productId:101},
{$setOnInsert:{productId:101,productName:"Vijay Headphones",category:"Electronics",stockQuantity:20,unitPrice:2500}},
{upsert:true}
);
const rajiniProductID = 101;
const dhoniOrderQuantity = 2;
// Reserve stock using an atomic single-document update
const stockResult = retailDB.products.updateOne(
{productId:rajiniProductID,stockQuantity:{$gte:dhoniOrderQuantity}},
{$inc:{stockQuantity:-dhoniOrderQuantity}}
);
if(stockResult.modifiedCount===1){
print("Stock reserved successfully.");
}else{
print("Stock reservation failed. Product not found or insufficient stock.");
}
// Verify updated product stock
print("Updated product details:");
printjson(retailDB.products.findOne(
{productId:rajiniProductID},
{_id:0}
));
// Demonstrate insufficient stock handling
const kohliLargeQuantity = 100;
const failedResult = retailDB.products.updateOne(
{productId:rajiniProductID,stockQuantity:{$gte:kohliLargeQuantity}},
{$inc:{stockQuantity:-kohliLargeQuantity}}
);
if(failedResult.modifiedCount===1){
print("Stock updated successfully.");
}else{
print("Insufficient stock. No changes were made.");
}
