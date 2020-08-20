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

