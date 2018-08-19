## 实体类编写规则
1. 实体类属性是私有的
2. 私有属性使用公开的set和get操作
3. 要求实体类有属性作为唯一值（一般使用id值）
4. 实体类属性不建议使用基本的数据类型，使用基本数据类型的包装类
    1. 八个基本数据类型的包装类
        - int-Integer
        - char-Character
        - 其他的都是首字母大写 
    2. 使用基本数据类型包装类的好处
        - 如 Integer score=0（分数为0）；Integer score=null（没有参加考试）；
## hibernate主键生成策略
1. hibernate要求在实体类有一个属性作为唯一值，对应表主键，主键可以有不同的生成策略，生成策略有很多值
2. 在class属性可以设置不同值
    1. native：根据数据库帮助选择哪个值
    2. hibernate帮助我们生成uuid值
        - 使用uuid生成策略，实体类id属性类型必须为字符串类型
        - 配置部分写出uuid值
## 实体类操作
### 对实体类crud操作
#### 添加操作
1. 调用session里面的save方法实现
#### 根据id查询
调用session里面的方法实现
```java
User user=session.get(User.class, 1);
```
#### 修改操作
1. 根据id查询
2. 向返回的对象设置修改的值
3. 调用session的方法修改update
#### 删除操作
1. 根据id查询
2. 调用session的方法delete
## hibernate的一级缓存
### 什么是缓存
数据存储在数据库中，数据库本身是文件系统，使用流文件操作文件效率不高；将数据存放在内存中，可以提高读取效率
### hibernate缓存
hibernate框架提供多种优化方式，缓存就是一种优化方式
#### hibernate缓存特点
1. hibernate的一级缓存
    - 一级缓存默认打开
    - 一级缓存有使用范围，是session的范围
    - 一级缓存中，存储数据必须持久化数据
2. hibernate二级缓存
    - 目前不使用，替代技术redis
    - 默认不打开，需要配置，使用范围是SessionFactory范围
3. 一级缓存特性
    - 持久态自动更新数据库
    根据id查询，设置返回对象值
## hibernate事务操作
### 事务代码规范写法
```java
	public void testTx(){
		SessionFactory sessionFactory=null;
		Session session=null;
		Transaction tx=null;
		try {
			sessionFactory=HibernateUtils.getSessionFactory();
			session=sessionFactory.openSession();
			//开启事务
			tx=session.beginTransaction();
			//相关操作
			//提交事务
			tx.commit();
		}catch (Exception e) {
			tx.rollback();// TODO: handle exception
		}finally{
			session.close();
			sessionFactory.close();
		}
	}
```
### hibernate绑定session
1. session类似jdbc的connection
2. hibernate帮助实现与本地线程绑定session
3. 获取本地线程session
    - 在hibernate核心配置文件中配置
    - 调用SessionFactory里面的方法得到
4. 获取与本地绑定session时候，关闭session报错，不需要手动关闭了
## hibernate的api的使用
### Query对象
1. 使用query对象，不需要写sql语句，但是写hql语句
    1. hql：hibernate query language 提供查询语言
    2. hql和sql的区别：
        - 使用sql操作表和表字段
        - 使用hql操作实体类和属性
2. 查询所有sql语句
    1. from 实体类名称
3. Query对象的使用
    1. 创建query对象
    2. 调用Query对象里面的方法得到结果
### Criteria对象
1. 使用该对象查询，不需要写语句，直接调用方法使用
2. 实现过程
    1. 创建对象
    2. 调用对象的方法得到结果
### SQL Query对象
1. 使用hibernate时候，调用底层sql语句实现
2. 实现过程
    1. 创建对象
    2. 调用对象的方法得到结果
