## Spring的jdbcTemplate操作
### 增加
1. 导入jar包
2. 创建对象，设置数据库信息
3. 创建jdbcTemplate对象，设置数据源
4. 调用jdbcTemplate对象里面的方法
### 修改
### 删除
### 查询
1. jdbcTemplate实现查询，有接口RowMapper，jdbcTemplate针对这个接口没有提供实现类，得到的类型需要自己进行数据封装
2. 查询的具体实现
    1. 查询返回某一个值
    2. 查询返回某一个对象
        ```
        jdbcTemplate.queryForObject(sql, rowMapper, args)
        ```
        - 第一个参数是sql语句
        - 第二个参数是接口
        - 第三个参数是可变参数
        - 接口的实现：1.从结果集里面把数据得到2.把得到数据封装到对象里面
    3. 查询返回一个list对象
## Spring配置连接池和使用jdbcTemplate
### 配置连接池
1. 导入jar包
2. 在配置文件中进行配置
    ```
    <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
    	<property name="driverClass" value="com.mysql.jdbc.Driver"></property>
    	<property name="jdbcUrl"
    		value="jdbc:mysql://localhost:3306/test?useUnicode=true&amp;characterEncoding=utf8">
    	</property>
    	<property name="user" value="root"></property>
    	<property name="password" value="xxxxx"></property>
    	<property name="maxPoolSize" value="3"></property>
    	<property name="maxIdleTime" value="10"></property>
    </bean>
    ```
### dao 使用jdbcTemplate
1. 创建service和dao，配置service和dao对象，在service注入dao
2. 创建jdbcTemplate对象，把模板注入到dao里面
3. 在jdbcTemplate对象里面注入dataSource
## spring的事务管理
### 事务概念

所谓事务管理，其实就是“按照给定的事务规则来执行提交或者回滚操作

- TransactionDefinition 给定的事务规则
- PlatformTransactionManager 按照……来执行提交或者回滚操作
- TransactionStatus  用于表示一个运行着的事务的状态。

### spring进行事务管理的api
1. spring事务管理的两种方式
    - 编程式事务管理  编程式事务需要你在代码中直接加入处理事务的逻辑,可能需要在代码中显式调用beginTransaction()、commit()、rollback()等事务管理相关的方法,如在执行a方法时候需要事务处理,你需要在a方法开始时候开启事务,处理完后。在方法结束时候,关闭事务.
    - 声明式事务管理 声明式的事务的做法是在a方法外围添加注解或者直接在配置文件中定义,a方法需要事务处理,在spring中会通过配置文件在a方法前后拦截,并添加事务.
### spring进行事务配置