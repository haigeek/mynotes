# hibernate笔记三
## 表与表之间的关系
1. 一对多
一对多键表，通过外键建立关系
2. 多对多
多对多建表，创建第三张表维护关系
3. 一对一
## hibernate一对多操作
### 一对多映射配置
以客户联系人为例：
1. 创建两个实体类，客户和联系人
2. 让两个实体类之间互相表示
    1. 在客户实体类里面表示多个联系人，使用set集合
    2. 在联系人实体类表示所属客户，使用客户对象来表示
3. 配置映射关系
    1. 一般一个实体类对应一个映射文件
    2. 完成映射的基本配置
    3. 在映射文件中，配置一对多关系
        - 在客户映射文件中，表示所有联系人
        - 在联系人映射文件中，表示所属客户
    4. 创建核心配置文件，把映射文件引入配置文件中
### 一对多级联操作
#### 级联保存  
添加一个客户，为这个客户添加多个联系人
- 复杂写法
```java
	//一对多级联保存
	@Test
	public void testAddDemo1(){
		SessionFactory sessionFactory=null;
		Session session=null;
		Transaction tx=null;
		try {
			sessionFactory=HibernateUtils.getSessionFactory();
			session=sessionFactory.openSession();
			//开启事务
			tx=session.beginTransaction();
			//相关操作
			//添加一个客户，为这个客户添加一个联系人 
			Customer customer=new Customer();
			customer.setCustName("姓名");
			customer.setCustLevel("vip");
			customer.setCustSource("网络");
			customer.setCustPhone("110");
			customer.setCustMobile("123");
			
			LinkMan linkMan=new LinkMan();
			linkMan.setLkm_name("lucy");
			linkMan.setLkm_gender("男");
			linkMan.setLkm_phone("122");
			//建立客户对象和联系人对象关系
			//1.把联系人对象放到客户实体类对象的set集合里
			customer.getSetLinkMan().add(linkMan);
			//2.把客户对象放到联系人对象里面
			linkMan.setCustomer(customer);
			
			//保存到数据库
			session.save(customer);
			session.save(linkMan);
			//提交事务
			tx.commit();
		}catch (Exception e) {
			tx.rollback();// TODO: handle exception
		}finally{
			session.close();
			//sessionFactory.close();
		}
	
	}
```
- 简化写法
1. 在客户映射文件中进行配置，在客户映射文件里面set标签进行配置
    ```xml
    <set name="setLinkMan" cascade="save-update">
    ```
2. 创建客户和联系人对象，只需要把联系人放到客户里面就可以了，最终只需要保存客户就可以

#### 级联删除  
删除某个客户，这个客户的所有联系人也删除
1. 在客户映射文件set标签，进行配置，使用属性cascade属性值delete
2. 删除客户，根据id查询，调用session里面的delete方法删除
3. 执行过程
    - 根据id查询客户
    - 根据外键的id值查询联系人
    - 把联系人的外键设置为null
    -  删除联系人和客户
### 一对多修改操作
1. 改变lucy所属客户不是a，而是百度
```java
		//根据id查询lucy的联系人 根据id查询百度的用户
		Customer baidu=session.get(Customer.class,1 );
		LinkMan lucy=session.get(LinkMan.class,2);
		//设置持久态对象
		//把联系人放到客户里
		baidu.getSetLinkMan().add(lucy);
		//把客户放到联系人中
		lucy.setCustomer(baidu);
```
2. inverse属性
	1. hibernate双向维护外键，在客户和联系人都需要维护外键，修改联系人的时候修改一次维护外键，修改联系人的时候也修改一次外键
	2. 解决方式，让一方不在维护外键
	3. 具体实现：在放弃关系维护的映射文件中，进行配置，在set标签使用inverse属性
## hibernate多对多操作
### 多对多映射配置
以用户和角色为例
1. 创建实体类，用户和角色
2. 让两个实体类相互表示
	1. 一个用户里面表示所有角色，使用set集合
	2. 一个角色有多个用户，使用set集合
3. 配置映射关系
4. 在核心配置文件中引入映射文件
### 多对多级联保存
### 多对多级联删除
### 维护第三张表的关系

