
use TelecomDB
db.notification_log.insertMany([
{notificationId:1,subscriberId:1,message:"Your balance is below 50",isRead:false},
{notificationId:2,subscriberId:1,message:"Recharge successful",isRead:true},
{notificationId:3,subscriberId:3,message:"Your balance is below 50",isRead:false},
{notificationId:4,subscriberId:3,message:"Please recharge your account",isRead:false},
{notificationId:5,subscriberId:5,message:"Your balance is below 50",isRead:false},
{notificationId:6,subscriberId:2,message:"Recharge reminder",isRead:true}
])
db.createView(
"unread_notification_count",
"notification_log",
[
{
$match:{
isRead:false
}
},
{
$group:{
_id:"$subscriberId",
unreadCount:{$sum:1}
}
},
{
$project:{
_id:0,
subscriberId:"$_id",
unreadCount:1
}
},
{
$sort:{subscriberId:1}
}
]
)
db.unread_notification_count.find()
