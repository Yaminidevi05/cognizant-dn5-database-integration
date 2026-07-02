
// HANDS-ON 5
// MongoDB – Document Modelling, CRUD & Aggregation
// Database : college_nosql
// Collection : feedback

use("college_nosql");
db.feedback.drop();

// Create Collection
db.createCollection("feedback");

// Task 1 - Insert Documents


db.feedback.insertMany([

{
student_id:1,
course_code:"CS101",
semester:"2022-ODD",
rating:5,
comments:"Excellent teaching. Would recommend.",
tags:["challenging","well-structured","good-examples"],
submitted_at:new Date("2022-11-30T10:15:00Z"),
attachments:[
{filename:"notes.pdf",size_kb:240}
]
},

{
student_id:2,
course_code:"CS101",
semester:"2022-ODD",
rating:4,
comments:"Very informative.",
tags:["challenging","interactive"],
submitted_at:new Date("2022-11-28T09:30:00Z"),
attachments:[
{filename:"assignment.pdf",size_kb:180}
]
},

{
student_id:3,
course_code:"CS101",
semester:"2021-EVEN",
rating:2,
comments:"Too difficult.",
tags:["challenging"],
submitted_at:new Date("2021-12-01T08:00:00Z"),
attachments:[
{filename:"feedback.docx",size_kb:100}
]
},

{
student_id:4,
course_code:"CS102",
semester:"2022-ODD",
rating:5,
comments:"Excellent practical sessions.",
tags:["hands-on","good-examples"],
submitted_at:new Date("2022-11-25T12:00:00Z"),
attachments:[
{filename:"lab.pdf",size_kb:300}
]
},

{
student_id:5,
course_code:"CS102",
semester:"2022-ODD",
rating:3,
comments:"Average course.",
tags:["interactive"],
submitted_at:new Date("2022-11-26T10:00:00Z"),
attachments:[
{filename:"report.pdf",size_kb:150}
]
},

{
student_id:6,
course_code:"CS103",
semester:"2022-ODD",
rating:1,
comments:"Needs improvement.",
tags:["difficult"],
submitted_at:new Date("2022-11-27T11:00:00Z"),
attachments:[
{filename:"complaint.pdf",size_kb:200}
]
},

{
student_id:7,
course_code:"CS104",
semester:"2022-ODD",
rating:4,
comments:"Nice explanations.",
tags:["good-examples","interactive"],
submitted_at:new Date("2022-11-24T08:30:00Z"),
attachments:[
{filename:"notes.docx",size_kb:120}
]
},

{
student_id:8,
course_code:"CS105",
semester:"2021-EVEN",
rating:2,
comments:"Could be better.",
tags:["boring"],
submitted_at:new Date("2021-11-20T07:45:00Z"),
attachments:[
{filename:"review.pdf",size_kb:210}
]
},

{
student_id:9,
course_code:"CS106",
semester:"2022-ODD",
rating:5,
comments:"Fantastic course.",
tags:["well-structured","good-examples"],
submitted_at:new Date("2022-11-29T09:00:00Z"),
attachments:[
{filename:"certificate.pdf",size_kb:250}
]
},


{
student_id:10,
course_code:"CS107",
semester:"2022-ODD",
rating:3,
comments:"Good overall.",
tags:["interactive"],
submitted_at:new Date("2022-11-23T06:00:00Z")
}

]);


db.feedback.countDocuments();


// Task 2 - CRUD Operations

db.feedback.find({ rating:5 });

db.feedback.find({
course_code:"CS101",
tags:"challenging"
});


db.feedback.find(
{},
{
student_id:1,
course_code:1,
rating:1,
_id:0
}
);


db.feedback.updateMany(
{rating:{$lt:3}},
{$set:{needs_review:true}}
);

db.feedback.updateMany(
{needs_review:true},
{$push:{tags:"reviewed"}}
);

db.feedback.deleteMany({
semester:"2021-EVEN"
});

// Task 3 - Aggregation Pipeline

db.feedback.aggregate([
{$match:{semester:"2022-ODD"}},
{
$group:{
_id:"$course_code",
avg_rating:{$avg:"$rating"},
total_feedback:{$sum:1}
}
},
{$sort:{avg_rating:-1}}
]);

db.feedback.aggregate([
{$match:{semester:"2022-ODD"}},
{
$group:{
_id:"$course_code",
avg_rating:{$avg:"$rating"},
total_feedback:{$sum:1}
}
},
{
$project:{
_id:0,
course_code:"$_id",
average_rating:{
$round:["$avg_rating",1]
},
total_feedback:1
}
},
{$sort:{average_rating:-1}}
]);

db.feedback.aggregate([
{$unwind:"$tags"},
{
$group:{
_id:"$tags",
count:{$sum:1}
}
},
{$sort:{count:-1}}
]);


db.feedback.createIndex({
course_code:1
});


db.feedback.find({
course_code:"CS101"
}).explain("executionStats");