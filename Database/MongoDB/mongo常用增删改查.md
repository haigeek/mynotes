
## 常用操作对照
```sql
db.users.find() select * from users
db.users.find({"age" : 27}) select * from users where age = 27
db.users.find({"username" : "joe", "age" : 27}) select * from users where "username" = "joe" and age = 27
db.users.find({}, {"username" : 1, "email" : 1}) select username, email from users
db.users.find({}, {"username" : 1, "_id" : 0}) // no case  // 即时加上了列筛选，_id也会返回；必须显式的阻止_id返回
db.users.find({"age" : {"$gte" : 18, "$lte" : 30}}) select * from users where age >=18 and age <= 30 // $lt(<) $lte(<=) $gt(>) $gte(>=)
db.users.find({"username" : {"$ne" : "joe"}}) select * from users where username <> "joe"
db.users.find({"ticket_no" : {"$in" : [725, 542, 390]}}) select * from users where ticket_no in (725, 542, 390)
db.users.find({"ticket_no" : {"$nin" : [725, 542, 390]}}) select * from users where ticket_no not in (725, 542, 390)
db.users.find({"$or" : [{"ticket_no" : 725}, {"winner" : true}]}) select * form users where ticket_no = 725 or winner = true
db.users.find({"id_num" : {"$mod" : [5, 1]}}) select * from users where (id_num mod 5) = 1
db.users.find({"$not": {"age" : 27}}) select * from users where not (age = 27)
db.users.find({"username" : {"$in" : [null], "$exists" : true}}) select * from users where username is null // 如果直接通过find({"username" : null})进行查询，那么连带"没有username"的纪录一并筛选出来
db.users.find({"name" : /joey?/i}) // 正则查询，value是符合PCRE的表达式
db.food.find({fruit : {$all : ["apple", "banana"]}}) // 对数组的查询, 字段fruit中，既包含"apple",又包含"banana"的纪录
db.food.find({"fruit.2" : "peach"}) // 对数组的查询, 字段fruit中，第3个(从0开始)元素是peach的纪录
db.food.find({"fruit" : {"$size" : 3}}) // 对数组的查询, 查询数组元素个数是3的记录，$size前面无法和其他的操作符复合使用
db.users.findOne(criteria, {"comments" : {"$slice" : 10}}) // 对数组的查询，只返回数组comments中的前十条，还可以{"$slice" : -10}， {"$slice" : [23, 10]}; 分别返回最后10条，和中间10条
db.people.find({"name.first" : "Joe", "name.last" : "Schmoe"})  // 嵌套查询
db.blog.find({"comments" : {"$elemMatch" : {"author" : "joe", "score" : {"$gte" : 5}}}}) // 嵌套查询，仅当嵌套的元素是数组时使用,
db.foo.find({"$where" : "this.x + this.y == 10"}) // 复杂的查询，$where当然是非常方便的，但效率低下。对于复杂查询，考虑的顺序应当是 正则 -> MapReduce -> $where
db.foo.find({"$where" : "function() { return this.x + this.y == 10; }"}) // $where可以支持javascript函数作为查询条件
db.foo.find().sort({"x" : 1}).limit(1).skip(10); // 返回第(10, 11]条，按"x"进行排序; 三个limit的顺序是任意的，应该尽量避免skip中使用large-number
```

## 更新语句

```sql
db.col.update({'user':'c4088e80-e467-43ca-bafa-4e566bb6b892'},{$set:{'startTime':ISODate("2020-06-15T11:12:36.236Z")}})
```

更新多条

```sql
db.getCollection('dus_proxy').update({"sort":0},{$set:{"user":"5ef99a58c4d79c95c1039381"}},{multi:true})
```

### 插入属性

```sql
db.getCollection('dus_proxy').update({"sort":0},{$set:{"serviceCatalog":"-1"}},{multi:true})
```

当不存在某个属性时

语法说明：

```sql
db.collection.update(
   <query>,
   <update>,
   {
     upsert: <boolean>,
     multi: <boolean>,
     writeConcern: <document>
   }
)
```

参数说明：

- query: update的查询条件，类似sql update查询内where后面的。
- update: update的对象和一些更新的操作符，也可以理解为sql update查询内set后面的。
- upsert: 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew, true为插入，默认是false，不插入。
- multi: 可选，mongodb默认是false，只更新找到的第一条记录，如果这个参数为true，则更新所有按条件查出来的多条记录。
- writeConcern: 可选，抛出异常的级别。

样例：

```sql
db.getCollection('dus_proxy').update(
    {"serviceCatalog" : {$exists : false}},
    {"$set" : {"serviceCatalog" : -1}},
    false,
    true
)
```

### 排序

在 MongoDB 中使用 sort() 方法对数据进行排序，sort() 方法可以通过参数指定排序的字段，并使用 1 和 -1 来指定排序的方式，其中 1 为升序排列，而 -1 是用于降序排列。

```sql
db.getCollection('dus_log').find().sort({startTime:-1})
```

mongo修改字段类型

数据类型批量转换：

```sql
db.tb_name.find({"status":{$type:1}}).forEach(function(x){x.status=NumberInt(x.status);db.tb_name.save(x)})
```

字段类型编号:

1 Double 浮点型

2 String UTF-8字符串都可表示为字符串类型的数据

3 Object 对象，嵌套另外的文档

4 Array 值的集合或者列表可以表示成数组

5 Binary data 二进制

7 Object id 对象id是文档的12字节的唯一 ID 系统默认会自动生成

8 Boolean 布尔类型有两个值TRUE和FALSE

9 Date 日期类型存储的是从标准纪元开始的毫秒数。不存储时区

10 Null 用于表示空值或者不存在的字段

11 Regular expression 采用js 的正则表达式语法

13 JavaScript code 可以存放Javasript 代码

14 Symbol 符号

15 JavaScript code with scope

16 32-bit integer 32位整数类型

17 Timestamp 特殊语义的时间戳数据类型

18 64-bit integer 64位整数类型





mongo时间查询

```
(>) 大于 - $gt
(<) 小于 - $lt
(>=) 大于等于 - $gte
(<= ) 小于等于 - $lte
```



mongo查询数组是否为空

```
db.getCollection('dus_apply_view').find({"embedProxy":{$size:0}})
```



删除某个字段



```
db.getCollection('dus_proxy').update({},{$unset:{"orgname":""}},false,true)
```



删除索引



```
db.COLLECTION_NAME.dropIndex("INDEX-NAME")
```



不等于

```
db.getCollection('dus_proxy').find({"user":{"$ne":"5f2bfb6abffbc0171c24ee2e"}})
```



联表查询

```
db.getCollection('dus_apply_cart').aggregate([
   {
     $lookup:
       {
  from: 'dus_proxy',
  localField: 'serviceId',
  foreignField: '_id',
  as: 'proxy'
}
  },
  { $match : {"proxy" : [ ]} }
])
```

数组查询

```
db.getCollection('dus_apply_from').find({"service":{"$elemMatch" :{"_id":"378b33ca-172f-41f5-9352-93acc1396f57"}}})
```

