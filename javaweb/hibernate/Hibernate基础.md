# Hibernate基础知识
## 什么是Hibernate
Hibernate是一种ORM框架（OBject/Relational Mapping）；ORM意为对象关系映射，因此Hibernate会在java对象和关系数据库之间建立某种映射，以达到存取java对象的目的，是实现持久化存储（将内存中的数据存储在关系型的数据库、磁盘文件、XML数据文件中等等）的一种解决方案。

Hibernate 不仅管理 Java 类到数据库表的映射（包括从 Java 数据类型到 SQL 数据类型的映射），还提供数据查询和获取数据的方法，可以大幅度减少开发时人工使用 SQL 和 JDBC 处理数据的时间。这正是它的设计目标，即将软件开发人员从大量相同的数据持久层相关编程工作中解放出来。
## 什么是orm思想
1. 让实体类和数据库表一一对应关系
    - 让实体类和数据库表进行一一对应关系
    - 让实体类属性和表里面的字段对应
2. 不需要操作数据库表，而操作表对应实体类对象
## Hibernate体系结构
![Hibernate整体体系](https://dn-anything-about-doc.qbox.me/userid46108labid970time1430706939889?watermark/1/image/aHR0cDovL3N5bC1zdGF0aWMucWluaXVkbi5jb20vaW1nL3dhdGVybWFyay5wbmc=/dissolve/60/gravity/SouthEast/dx/0/dy/10)

从上图可以看出，HIbernate使用使用数据库和配置信息（Hibernate.properties)来为应用程序提供持久化服务（以及持久对象的Persistent OBjects）
- 轻型的体系结构方案
要求应用程序提供自己的JDBC连接并管理自己的事务，这种方案使用了Hibernate API 的最小集：
![](https://dn-anything-about-doc.qbox.me/userid46108labid970time1430706952117?watermark/1/image/aHR0cDovL3N5bC1zdGF0aWMucWluaXVkbi5jb20vaW1nL3dhdGVybWFyay5wbmc=/dissolve/60/gravity/SouthEast/dx/0/dy/10)
- 全面解决的体系结构方案
将应用底层的JDBC/JTA API 中抽象出来，让Hibernate来处理这些细节
![](https://dn-anything-about-doc.qbox.me/userid46108labid970time1430706965657?watermark/1/image/aHR0cDovL3N5bC1zdGF0aWMucWluaXVkbi5jb20vaW1nL3dhdGVybWFyay5wbmc=/dissolve/60/gravity/SouthEast/dx/0/dy/10)
## 基本APIs
- SessionFactory
对于单个数据库映射关系经过编译后的内存缓存，他是线程安全且不可变的。是session生成的工厂实例，也是ConnectProvider的一个客户端（会用到ConnectionProvider）。他在进程或集群的级别上，为那些在事务之前可重复使用的数据提供了选择性的二级缓存
- Session
提供应用程序和持久化存储介质之间的一个单线程的会话对象，此对象生存期短，他隐藏了JDBC连接，也是Transaction的工厂实例，对于应用的持久化对象及其集合，他提供了一个一级缓存；当遍历导航对象图或者根据持久化标识查找对象时，会用到这个一级缓存
