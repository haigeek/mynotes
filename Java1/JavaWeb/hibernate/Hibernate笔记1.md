# Hibernate笔记
## 搭建Hibernate环境
1. 导入jar包
2. 创建实体类
    - 使用Hibernate的时候，不需要手动创建表，Hibernate帮我们创建表
3. 配置实体类和数据库表的一一对应关系
    使用配置文件实现映射关系
    1. 创建xml格式的配置文件，映射配置文件名称和位置没有固定要求，建议在实体类所在的包创建，实体类名称.hbm.xml
    2. 配置是xml格式，在配置文件引进xml约束
    3. 配置映射关系
    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE hibernate-mapping PUBLIC 
		"-//Hibernate/Hibernate Mapping DTD 3.0//EN"
		"http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
	<hibernate-mapping>
		<!-- 配置类和表对应
		name属性：实体类的全路径 
		table属性：数据库的名称-->
		<class name="cn.haigeek.entity.User" table="t_user">
			<!-- 配置实体类id和表id
			hibernate要求实体类有一个属性唯一值
			hibernate要求表有字段作为唯一值 -->
			<!-- id标签 name属性：
			实体类里面id属性名称 
			column属性：生成表的字段名称  -->
			<id name="uid" column="uid">
				<!-- 数据库表id主键字段增长 -->
				<generator class="native"></generator>
			</id>
			<!-- 配置其他属性和表字段对应 -->
			<property name="username"  column="username"></property>
			<property name="password" column="password"></property>
			<property name="address" column="address"></property>
		</class>
	</hibernate-mapping>
	4. 创建hibernate的核心文件
	- 文件格式xml；位置src下，名称hibernate.cfg.xml
	- 引入约束
	- hibernate在操作过程中，只加载核心配置文件
	- 配置文件实例
	```xml
	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE hibernate-configuration PUBLIC
		"-//Hibernate/Hibernate Configuration DTD 3.0//EN"
		"http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">
		<hibernate-configuration>
		<session-factory>
			<!-- 配置数据库信息 （必须）-->
			<!-- jdbc 的连接 url 和数据库-->
			<property name="connection.url">jdbc:mysql://localhost:3306/hibernate</property>
			<!--表示使用的数据库驱动类 -->
			<property name="connection.driver_class">com.mysql.jdbc.Driver</property>
			<property name="connection.username">root</property>
			<property name="connection.password">*****</property>
			<!-- 配置hibernate信息 -->
			<!-- 数据库使用的方言 （可选） -->
			<property name="dialect">org.hibernate.dialect.MySQLDialect</property>
			<!-- 设置 打印输出 sql 语句 为真 -->
			<property name="show_sql">true</property>
			<!-- 设置格式为 sql -->
			<property name="format_sql">true</property>
			<!-- 第一次加载 hibernate 时根据实体类自动建立表结构，以后自动更新表结构 -->
			<property name="hbm2ddl.auto">update</property>
			<!-- 将映射文件放进核心文件（必须） -->
			<mapping resource="cn/haigeek/entity/User.hbm.xml"/>
			<!-- DB schema will be updated if needed -->
			<!-- <property name="hbm2ddl.auto">update</property> -->
		</session-factory>
	</hibernate-configuration>
	```
## 实现添加操作
- 加载hibernate核心配置文件
- 创建SessionFactory对象
- 使用SessionFactory对象创建Session对象
- 开启事务
- 写具体逻辑crud操作
- 提交事务
- 关闭资源
实例如下
```java
package cn.haigeek.hibernatetest;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import cn.haigeek.entity.User;

public class HibernateDemo {
	public static void main(String[] args){
		// 加载hibernate核心配置文件
		//到src下面找到名称是hibernate.cfg.xml
		//在hibernate里面封装对象
		Configuration cfg=new Configuration();
		cfg.configure();
		// 创建SessionFactory对象
		//读取hibernate核心配置文件的内容，创建SessionFactory
		//在过程中，根据映射关系，在配置数据库里把表创建
		SessionFactory sessionFactory=cfg.buildSessionFactory();
		//使用SessionFactory对象创建Session对象
		//类似于连接
		Session session=sessionFactory.openSession();
		//开启事务
		Transaction tx=session.beginTransaction();
		//写具体逻辑crud操作
		User user=new User();
		user.setUsername("haigeek");
		user.setPassword("23");
		user.setAddress("中国");
		session.save(user);
		//提交事务
		tx.commit();
		//关闭资源
		session.close();
		sessionFactory.close();
	}
}
```
## hibernate核心api
### Configuration
```java
Configuration cfg=new Configuration();
cfg.configure();
```
到src下面找到hibernate.cfg.xml配置文件，创建对象，把配置文件放在对象中
### SessionFactory
使用configuration创建SessionFactory对象
1. 创建SessionFactory过程中做事情：根据核心配置文件中，有数据库配置，有映射文件部分，到数据库里面根据映射关系把表创建
	<property name="hibernate.hbm2ddl.auto">update</property>
2. 创建SessionFactory过程中，耗资源
在hibernate操作中，一个项目一般创建一个SessionFactory对象
3. 具体实现
写工具类，写静态代码块实现，静态代码块在类加载时执行，执行一次
### session
1. session类似jdbc中 connection
2. 调用session里面不同的方法实现curd方法
	- 添加save方法
	- 修改update方法
	- 删除delete方法
	- 根据id查询get方法
3. session对象单线程对象
	- session对象不能共用，只能自己使用
### Transaction
1. 事务对象
 Transaction tx=session.bebeginTransaction();
2. 事务提交和回滚方法
tx.commit()

tx.rollback()
3. 事务概念
- 原子性：整个事务的所有操作要么全部提交成功，要不全部失败回滚。事务在执行过程中发生错误，会被回滚（Rollback）到事务开始前的状态，就像这个事务从来没有执行过一样。
- 一致性：在事务开始之前和事务结束以后，数据库的完整性没有被破坏。
- 隔离性：数据库允许多个并发事务同时对其数据进行读写和修改的能力，隔离性可以防止多个事务并发执行时由于交叉执行而导致数据的不一致。
- 持久性：事务处理结束后，对数据的修改就是永久的，即便系统故障也不会丢失。