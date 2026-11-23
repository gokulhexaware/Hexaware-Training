
use InsuranceDB
db.customer_communications.insertMany([
{communicationId:1,customerId:1,type:"Complaint",message:"Premium amount is incorrect",status:"Unresolved"},
{communicationId:2,customerId:2,type:"Enquiry",message:"Policy renewal details",status:"Resolved"},
{communicationId:3,customerId:3,type:"Complaint",message:"Claim processing delay",status:"Unresolved"},
{communicationId:4,customerId:1,type:"Complaint",message:"Policy document not received",status:"Resolved"},
{communicationId:5,customerId:2,type:"Complaint",message:"Payment issue",status:"Unresolved"}
])
db.createView(
"unresolved_complaints",
"customer_communications",
[
{
$match:{
type:"Complaint",
status:"Unresolved"
}
},
{
$project:{
_id:0,
communicationId:1,
customerId:1,
type:1,
message:1,
status:1
}
},
{
$sort:{communicationId:1}
}
]
)
db.unresolved_complaints.find()
