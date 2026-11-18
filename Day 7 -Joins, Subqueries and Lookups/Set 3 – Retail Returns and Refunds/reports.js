
use('retailreturnrefund');
db.retail_feedback.deleteMany({});
db.retail_refunds.deleteMany({});
db.retail_returns.deleteMany({});
db.retail_sales.deleteMany({});
db.retail_employees.deleteMany({});
db.retail_products.deleteMany({});
db.retail_customers.deleteMany({});
db.retail_stores.deleteMany({});
db.retail_stores.insertMany([
{store_id:1,store_name:"chennai central",region:"south",city:"chennai"},
{store_id:2,store_name:"coimbatore city",region:"south",city:"coimbatore"},
{store_id:3,store_name:"madurai mall",region:"south",city:"madurai"},
{store_id:4,store_name:"salem outlet",region:"west",city:"salem"}
]);
db.retail_customers.insertMany([
{customer_id:1,customer_name:"arun kumar",city:"chennai",phone:"9876500001"},
{customer_id:2,customer_name:"vijay kumar",city:"coimbatore",phone:"9876500002"},
{customer_id:3,customer_name:"surya prakash",city:"madurai",phone:"9876500003"},
{customer_id:4,customer_name:"karthik rajan",city:"salem",phone:"9876500004"},
{customer_id:5,customer_name:"ashwin kumar",city:"chennai",phone:"9876500005"}
]);
db.retail_products.insertMany([
{product_id:1,product_name:"smartphone",category:"electronics",unit_price:20000},
{product_id:2,product_name:"laptop",category:"electronics",unit_price:50000},
{product_id:3,product_name:"office chair",category:"furniture",unit_price:5000},
{product_id:4,product_name:"water bottle",category:"accessories",unit_price:500},
{product_id:5,product_name:"headphones",category:"electronics",unit_price:3000}
]);
db.retail_employees.insertMany([
{employee_id:1,employee_name:"rajesh",manager_id:null,store_id:1,job_title:"store manager"},
{employee_id:4,employee_name:"kumar",manager_id:null,store_id:2,job_title:"store manager"},
{employee_id:6,employee_name:"ashwin",manager_id:null,store_id:3,job_title:"store manager"},
{employee_id:8,employee_name:"karthik",manager_id:null,store_id:4,job_title:"store manager"},
{employee_id:2,employee_name:"vijay",manager_id:1,store_id:1,job_title:"sales executive"},
{employee_id:3,employee_name:"arun",manager_id:1,store_id:1,job_title:"sales executive"},
{employee_id:5,employee_name:"surya",manager_id:4,store_id:2,job_title:"sales executive"},
{employee_id:7,employee_name:"rahul",manager_id:6,store_id:3,job_title:"sales executive"}
]);
db.retail_sales.insertMany([
{sale_id:101,product_id:1,customer_id:1,store_id:1,quantity:50,sale_date:ISODate("2026-09-01")},
{sale_id:102,product_id:1,customer_id:2,store_id:2,quantity:50,sale_date:ISODate("2026-09-02")},
{sale_id:103,product_id:2,customer_id:1,store_id:1,quantity:50,sale_date:ISODate("2026-09-03")},
{sale_id:104,product_id:2,customer_id:3,store_id:2,quantity:50,sale_date:ISODate("2026-09-04")},
{sale_id:105,product_id:3,customer_id:2,store_id:1,quantity:25,sale_date:ISODate("2026-09-05")},
{sale_id:106,product_id:3,customer_id:3,store_id:2,quantity:25,sale_date:ISODate("2026-09-06")},
{sale_id:107,product_id:4,customer_id:4,store_id:3,quantity:100,sale_date:ISODate("2026-09-07")}
]);
db.retail_returns.insertMany([
{return_id:201,sale_id:101,return_quantity:10,return_date:ISODate("2026-10-01"),return_reason:"damaged product"},
{return_id:202,sale_id:102,return_quantity:5,return_date:ISODate("2026-10-02"),return_reason:"wrong item"},
{return_id:203,sale_id:103,return_quantity:2,return_date:ISODate("2026-10-03"),return_reason:"defective product"},
{return_id:204,sale_id:104,return_quantity:3,return_date:ISODate("2026-10-04"),return_reason:"damaged product"},
{return_id:205,sale_id:105,return_quantity:4,return_date:ISODate("2026-10-05"),return_reason:"quality issue"},
{return_id:206,sale_id:106,return_quantity:4,return_date:ISODate("2026-10-06"),return_reason:"wrong size"},
{return_id:207,sale_id:107,return_quantity:2,return_date:ISODate("2026-10-07"),return_reason:"product not required"}
]);
db.retail_refunds.insertMany([
{refund_id:301,return_id:201,refund_amount:1000,refund_date:ISODate("2026-10-02")},
{refund_id:302,return_id:202,refund_amount:500,refund_date:ISODate("2026-10-03")},
{refund_id:303,return_id:203,refund_amount:200,refund_date:ISODate("2026-10-04")},
{refund_id:304,return_id:204,refund_amount:300,refund_date:ISODate("2026-10-05")},
{refund_id:305,return_id:205,refund_amount:400,refund_date:ISODate("2026-10-06")},
{refund_id:306,return_id:206,refund_amount:400,refund_date:ISODate("2026-10-07")}
]);
db.retail_feedback.insertMany([
{feedback_id:401,return_id:201,rating:2,feedback_text:"product quality was poor",feedback_date:ISODate("2026-10-03")},
{feedback_id:402,return_id:202,rating:3,feedback_text:"received incorrect item",feedback_date:ISODate("2026-10-04")},
{feedback_id:403,return_id:203,rating:1,feedback_text:"product was defective",feedback_date:ISODate("2026-10-05")},
{feedback_id:404,return_id:205,rating:4,feedback_text:"return process was good",feedback_date:ISODate("2026-10-07")},
{feedback_id:405,return_id:207,rating:3,feedback_text:"return completed successfully",feedback_date:ISODate("2026-10-08")}
]);
db.retail_returns.aggregate([
{$lookup:{from:"retail_feedback",localField:"return_id",foreignField:"return_id",as:"feedback"}},
{$lookup:{from:"retail_refunds",localField:"return_id",foreignField:"return_id",as:"refunds"}},
{$lookup:{from:"retail_sales",localField:"sale_id",foreignField:"sale_id",as:"sale"}},
{$unwind:"$sale"},
{$project:{_id:0,return_id:1,sale_id:1,return_quantity:1,return_reason:1,feedback:1,refunds:1}},
{$sort:{return_id:1}}
]);
db.retail_customers.aggregate([
{$lookup:{from:"retail_sales",localField:"customer_id",foreignField:"customer_id",as:"sales"}},
{$lookup:{from:"retail_returns",localField:"customer_id",foreignField:"customer_id",as:"returns"}},
{$lookup:{from:"retail_feedback",let:{customer_returns:"$returns.return_id"},pipeline:[{$match:{$expr:{$in:["$return_id","$$customer_returns"]}}}],as:"feedback"}},
{$project:{_id:0,customer_id:1,customer_name:1,city:1,sales:1,returns:1,feedback:1}},
{$sort:{customer_id:1}}
]);
db.retail_stores.aggregate([
{$lookup:{from:"retail_sales",localField:"store_id",foreignField:"store_id",as:"sales"}},
{$lookup:{from:"retail_returns",let:{store_sales:"$sales.sale_id"},pipeline:[{$match:{$expr:{$in:["$sale_id","$$store_sales"]}}},{$lookup:{from:"retail_refunds",localField:"return_id",foreignField:"return_id",as:"refunds"}},{$lookup:{from:"retail_feedback",localField:"return_id",foreignField:"return_id",as:"feedback"}}],as:"returns"}},
{$addFields:{total_refund_value:{$sum:"$returns.refunds.refund_amount"},total_returns:{$size:"$returns"}}},
{$project:{_id:0,store_id:1,store_name:1,region:1,total_returns:1,total_refund_value:1,returns:1}},
{$sort:{total_refund_value:-1}}
]);
db.retail_stores.find();
db.retail_customers.find();
db.retail_products.find();
db.retail_employees.find();
db.retail_sales.find();
db.retail_returns.find();
db.retail_refunds.find();
db.retail_feedback.find();
