# mongodb基本操作
## 数据库与集合
### 数据库连接

在终端连接mongo

```
mongo 192.168.1.110:27017
```



### 创建数据库
- `use DATABASE_NAME` 创建数据库，如果数据已经存在，切换到对应的数据库
- `show dbs`显示所有的数据库
- `db.DATABASE_NAME.insert({"name":"名称"})` 插入数据，默认的数据库为test 
### 删除数据库
- db.dropDatebase() 在执行数据库删除的时候，需要先切换到对于的数据库
### 创建集合
- db.createCollection(name, options)  name表示要创建的集合的名称，options表示可选的参数
options参数主要有以下几个参数
- capped 布尔型 如果为true，则创建固定集合，并必须制定size参数的大小，当集合达到最大值的时候，会自动覆盖之前的文档
- autoIndexId 布尔型 可以自动在_id字段创建索引，默认为false
- size 数值型 为固定集合指定一个最大值（以字节计）。
- max 数值型 指定固定集合中包含文档的最大数量。

Eg：

```
db.createCollection("name", false)
```

### 删除集合
- `show collection` 查看集合
- `db.collection.drop()` 删除集合
## 文档操作
MongoDB里的文档数据结构和JSON基本一致，所有存储在集合中的数据称为BSON格式，BSON是一种类json的一种二进制形式的存储格式,简称Binary JSON。
### 插入文档
- `db.COLLECTION_NAME.insert(document)` 使用insert()或者save()方法进行插入,在进行插入的时候，假如集合不在数据库中，MongoDB 会自动创建该集合并插入文档。
- 可以将数据定义为一个变量，再执行插入操作，将该变量插入。

eg:

```
db.test.insert({
app : null,
version : "1.0.0",
script : null,
createTime : NumberLong(1614302605963),
remark : "初始化字典数据"
})
```



### 更新文档
update()来进行文档的更新，更新格式如下
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
- query：update的更新条件
- update：update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的
- upsert：可选。如果不存在update的记录，是否插入objNew,true为插入，默认是false，不插入。
- multi：可选。mongodb 默认是false,只更新找到的第一条记录，如果这个参数为true,就把按条件查出来多条记录全部更新。
- writeConcern：可选，抛出异常的级别。
```sql
>db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}})
```
还可以使用save()方法通过传过来的文档替换已有的文档
### 删除文档
使用remove方式删除文档，在进行删除之前，最好先进行以下find操作
```shell
> db.col.insert({title:'learn mongo',name:'haigeek'})
WriteResult({ "nInserted" : 1 })
> db.col.insert({title:'learn mongo',name:'haigeek'})
WriteResult({ "nInserted" : 1 })
> db.col.find()
{ "_id" : ObjectId("5b86103d89566d2f2644945e"), "title" : "learn mongo", "name" : "haigeek" }
{ "_id" : ObjectId("5b86104089566d2f2644945f"), "title" : "learn mongo", "name" : "haigeek" }
> db.col.remove({'title':"learn mongo"})
WriteResult({ "nRemoved" : 2 })
```
### 查询文档
#### 语法
- `db.COLLECTION_NAME.find()` 查看已经插入的文档
- `db.COLLECTION_NAME.findOne()` 查看已经插入的文档,只返回一个结果
- `db.COLLECTION_NAME.find().pretty()` 以格式化的方式来进行文档的阅读
#### and操作
mongo中可以传入多个key，以逗号隔开，效果和常规sql的and操作一致
```shell
db.col.find({key1:value1, key2:value2}).pretty()
```
#### where操作
12|set
-|-
|sc|sdc 
#### or操作
```shell
>db.col.find(
   {
      $or: [
         {key1: value1}, {key2:value2}
      ]
   }
).pretty()
```
## 数据的获取与处理
### 条件操作符
### $type 操作符
### limt与Skip方法
### 排序
### 索引
### 聚合
### 复制
### 分片
### 备份与恢复
### 监控
### MongoDB java

