# hibernate的一级缓存与二级缓存

# 什么是缓存

缓存是介于物理数据源与应用程序之间，是对数据库中的数据复制一份临时放在内存中的容器，其作用是为了减少应用程序对物理数据源访问的次数，从而提高了应用程序的运行性能。Hibernate 在进行读取数据的时候，根据缓存机制在相应的缓存中查询，如果在缓存中找到了需要的数据 (我们把这称做 “缓存命中 ")，则就直接把命中的数据作为结果加以利用，避免了大量发送 SQL 语句到数据库查询的性能损耗。 

缓存策略提供商： 提供了 HashTable 缓存，EHCache，OSCache，SwarmCache，jBoss Cathe2，这些缓存机制，其中 EHCache，OSCache 是不能用于集群环境（Cluster Safe）的，而 SwarmCache，jBoss Cathe2 是可以的。HashTable 缓存主要是用来测试的，只能把对象放在内存中，EHCache，OSCache 可以把对象放在内存（memory）中，也可以把对象放在硬盘（disk）上（为什么放到硬盘上？上面解释了）。 

# 一级缓存

## 定义

一级缓存是Session 缓存（又称作事务缓存）：Hibernate 内置的，不能卸除。 

缓存范围：缓存只能被当前 Session 对象访问。缓存的生命周期依赖于 Session 的生命周期，当 Session 被关闭后，缓存也就结束生命周期。 

## 实例

Hibernate 一些与一级缓存相关的操作（时间点）： 

数据放入缓存： 

1、save()。当 session 对象调用 save() 方法保存一个对象后，该对象会被放入到 session 的缓存中。 

2、get() 和 load()。当 session 对象调用 get() 或 load() 方法从数据库取出一个对象后，该对象也会被放入到 session 的缓存中。 

3、使用 HQL 和 QBC 等从数据库中查询数据。  

使用 get() 或 load() 证明缓存的存在： 

```java
public class Client {

    public static void main(String[] args) {

        Session session = HibernateUtil.getSessionFactory().openSession();

        Transaction tx = null;

        try {

            /* 开启一个事务 */

            tx = session.beginTransaction();

            /* 从数据库中获取 的 Customer 对象 */

            Customer customer1 = (Customer) session.get(Customer.class, "402881e534fa5a440134fa5a45340002");

            System.out.println("customer.getUsername is" + customer1.getUsername());

            /* 事务提交 */

            tx.commit();


            System.out.println("-------------------------------------");


            /* 开启一个新事务 */

            tx = session.beginTransaction();

            /* 从数据库中获取 的 Customer 对象 */

            Customer customer2 = (Customer) session.get(Customer.class, "402881e534fa5a440134fa5a45340002");

            System.out.println("customer2.getUsername is" + customer2.getUsername());

            /* 事务提交 */

            tx.commit();


            System.out.println("-------------------------------------");


            /* 比较两个 get() 方法获取的对象是否是同一个对象 */

            System.out.println("customer1 == customer2 result is" + (customer1 == customer2));

        } catch (Exception e) {

            if (tx != null) {

                tx.rollback();

            }

        } finally {

            session.close();

        }

    }

}
```

输出结果

```
Hibernate:

    select

        customer0_.id as id0_0_,

        customer0_.username as username0_0_,

        customer0_.balance as balance0_0_

    from

        customer customer0_

    where

        customer0_.id=?

customer.getUsername islisi

-------------------------------------

customer2.getUsername islisi

-------------------------------------

customer1 == customer2 result is true
```

> 数据从缓存中清除： 
>
> 1. evit() 将指定的持久化对象从缓存中清除，释放对象所占用的内存资源，指定对象从持久化状态变为脱管状态，从而成为游离对象。  
>
> 2. clear() 将缓存中的所有持久化对象清除，释放其占用的内存资源。 
>
> 其他缓存操作： 
>
> 1. contains() 判断指定的对象是否存在于缓存中。 
>
> 2. flush() 刷新缓存区的内容，使之与数据库数据保持同步。 

## 原理

在同一个 Session 里面，第一次调用 get() 方法， Hibernate 先检索缓存中是否有该查找对象，发现没有，Hibernate 发送 SELECT 语句到数据库中取出相应的对象，然后将该对象放入缓存中，以便下次使用，第二次调用 get() 方法，Hibernate 先检索缓存中是否有该查找对象，发现正好有该查找对象，就从缓存中取出来，不再去数据库中检索，没有再次发送 select 语句。

# 二级缓存

## 定义

SessionFactory 缓存（又称作应用缓存）：可以跨越 Session 存在，可以被多个 Session 所共享。使用第三方插件，可插拔。 

缓存范围：缓存被应用范围内的所有 session 共享, 不同的 Session 可以共享。这些 session 有可能是并发访问缓存，因此必须对缓存进行更新。缓存的生命周期依赖于应用的生命周期，应用结束时，缓存也就结束了生命周期，二级缓存存在于应用程序范围。 

## 为什么使用二级缓存

当我们重启一个 Session，第二次调用 load 或者 get 方法检索同一个对象的时候会重新查找数据库，会发 select 语句信息。 

原因：一个 session 不能取另一个 session 中的缓存。

性能上的问题：假如是多线程同时去取 Category 这个对象，load 一个对象，这个对像本来可以放到内存中的，可是由于是多线程，是分布在不同的 session 当中的，所以每次都要从数据库中取，这样会带来查询性能较低的问题。 

### 适合使用二级缓存的场景

（1）经常被访问 

（2）改动不大 

（3）数量有限 

（4）不是很重要的数据，允许出现偶尔并发的数据。  

例如：

用户的权限：用户的数量不大，权限不多，不会经常被改动，经常被访问。 

组织机构。 

## 原理

Hibernate 如何将数据库中的数据放入到二级缓存中？注意，你可以把缓存看做是一个 Map 对象，它的 Key 用于存储对象 OID，Value 用于存储 POJO。首先，当我们使用 Hibernate 从数据库中查询出数据，获取检索的数据后，Hibernate 将检索出来的对象的 OID 放入缓存中 key 中，然后将具体的 POJO 放入 value 中，等待下一次再次向数据查询数据时，Hibernate 根据你提供的 OID 先检索一级缓存，若有且配置了二级缓存，则检索二级缓存，如果还没有则才向数据库发送 SQL 语句，然后将查询出来的对象放入缓存中。

## 实例

为 Hibernate 配置二级缓存： 

1、在主配置文件中 hibernate.cfg.xml ： 

```xml
<property name="cache.use_second_level_cache">true</property>
 <!-- 设置缓存的类型，设置缓存的提供商 -->
<property
  name="cache.provider_class">org.hibernate.cache.EhCacheProvider
</property
```

2、配置 ehcache.xml

```xml
<ehcache>
    <!--缓存到硬盘的路径-->
    <diskStore path="d:/ehcache"/>
    <defaultCache
        maxElementsInMemory="200"<!-- 最多缓存多少个对象 -->
        eternal="false"<!-- 内存中的对象是否永远不变 -->
        timeToIdleSeconds="50"<!-- 发呆了多长时间，没有人访问它，这么长时间清除 -->
        timeToLiveSeconds="60"<!-- 活了多长时间，活了 1200 秒后就可以拿走，一般 Live 要比 Idle 设置的时间长 -->
        overflowToDisk="true"<!-- 内存中溢出就放到硬盘上 -->
        />

    <!--
        指定缓存的对象，缓存哪一个实体类
        下面出现的的属性覆盖上面出现的，没出现的继承上面的。
    -->
    <cache name="com.suxiaolei.hibernate.pojos.Order"
        maxElementsInMemory="200"
        eternal="true"
        timeToIdleSeconds="0"
        timeToLiveSeconds="0"
        overflowToDisk="false"
        />
</ehcache>
```


