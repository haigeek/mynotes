在mongo中可以创建视图

视图是只读的

```

db.createView("dus_apply_view","dus_apply",
	[	
		{
		  $lookup:{from:"dus_proxy",localField:"serviceId",foreignField:"_id",as:"embedProxy"}
	  	},
		{
		  $project:{"embedProxy._id":0}  // 设置不需要哪些字段
		},
        { 
           $addFields: { "_id": { "$toString": "$_id" } }
        },
        {
          $lookup:{from:"dus_apply_log",localField:"_id",foreignField:"applyId",as:"embedApplyLog"}
        },
        {
		  $project:{"embedApplyLog._id":0}  // 设置不需要哪些字段
		}
	]
)
```

参数说明：

dus_apply_view：要创建的视图的名称

