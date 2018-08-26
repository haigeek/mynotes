# Redis的数据类型
Redis支持五种数据类型：string（字符串），hash（哈希），list（列表），set（集合）及zset(sorted set：有序集合)。
## String
String是Redis最基本的类型，一个key对应一个value，String可以包含任何数据，例如jpg图片或者序列化的对象，string 类型可以存储最大的数据值是512MB
```shell
127.0.0.1:6379> set name "hello"
OK
127.0.0.1:6379> get name
"hello"
```
## Hash
Redis hash 是一个键值(key=>value)对集合，是一个 string 类型的 field 和 value 的映射表，hash 特别适合用于存储对象。实例中我们使用了 Redis HMSET, HGET 命令，HMSET 设置了两个 field=>value 对, HGET 获取对应 field 对应的 value。
每个 hash 可以存储 2的32次方减1个键值对（40多亿）。
```shell
127.0.0.1:6379> hmset myhash field1 "hello" field2 "world"
OK
127.0.0.1:6379> hget myhash field1
"hello"
127.0.0.1:6379> hget myhash field2
"world"
```
## Set
Redis的Set是string类型的无序集合。集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是O(1)。
添加数据使用sadd 命令。添加一个 string 元素到 key 对应的 set 集合中，成功返回1，如果元素已经在集合中返回 0，如果 key 对应的 set 不存在则返回错误。
```shell
127.0.0.1:6379> sadd settest hello
(integer) 1
127.0.0.1:6379> sadd settest world
(integer) 1
127.0.0.1:6379> sadd settest !
(integer) 1
127.0.0.1:6379> sadd settest !
(integer) 0
127.0.0.1:6379> SMEMBERS settest
1) "!"
2) "world"
3) "hello"
```
## Zset
有序集合，Redis zset 和 set 一样也是string类型元素的集合,且不允许重复的成员。
不同的是每个元素都会关联一个double类型的分数。redis正是通过分数来为集合中的成员进行从小到大的排序。zset的成员是唯一的,但分数(score)却可以重复。
命令：
```shell
zadd key score member 
```
demo
```shell
127.0.0.1:6379> ZADD zsettest 0 hello
(integer) 1
127.0.0.1:6379> ZADD zsettest 0 world
(integer) 1
127.0.0.1:6379> ZADD zsettest 0 ！
(integer) 1
127.0.0.1:6379> ZADD zsettest 0 ！
(integer) 0
127.0.0.1:6379> ZRANGEBYSCORE zsettest 0 100
1) "hello"
2) "world"
3) "\xef\xbc\x81"
```