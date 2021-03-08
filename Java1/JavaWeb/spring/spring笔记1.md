# spring笔记1
## spring概念
1. spring是开源的轻量级框架
2. spring核心主要两部分
    1. aop：面向切面编程
    2. ioc：控制反转
      比如有一个类，在类中有方法（不是静态的方法），调用类里面的方法，创建类的对象，使用对象调用方法，创建类对象的过程，需要new出来对象；把对象的创建不是通过new方式实现，而是交给spring配置创建类对象
3. spring是一站式框架

    spring在javaee三层结构中，每一层都提供不同的解决方法
    - web层：springMVC
    - service层：spring的ioc
    - dao层：spring的jdbcTemplate
4. spring版本
    1. spring4.x
## spring的ioc操作
1. 把对象的创建交给spring的进行管理
2. ioc操作的两部分
    - ioc的配置文件方式
    - ioc的注解方式
## ioc底层原理
1. ioc底层原理使用技术
    - xml配置文件
    - dom4j解决xml
    - 工厂设计模式
    - 反射
2. ioc的过程
    1. 创建xml配置文件，配置要创建对象类
    ```xml
    <bean id="userService" class="cn.haigeek.UserService:/>
    ```
    2. 创建工厂类，使用dom4j解析配置文件+反射
    ```java
    public class UserFactory{
        //返回UserService对象的方法
        public static UserService getService(){
            //使用dom4j解析xml文件
            //根据id值userService，得到id值对应的class属性值
            String classVaule="class属性值";
            //使用反射创建类对象
            Class clazz=Class.forName(classVaule);
            UserService service=clazz.newInstance();
            return service;
        }
    }
    ```
## spring入门案例
1. 导入jar包
2. 创建类，在类里创建方法
3. 创建spring配置文件，创建配置类
    - spring核心配置文件名称和位置不是确实的，建议放在src下，官方建议applicationContext.xml
    - 引入schema约束
    - 配置对象创建
4. 测试对象的创建
## spring 的bean管理（xml）
### bean实例化的方式
1. 在spring里面通过配置文件创建对象
    spring的IOC容器能够帮我们自动new对象，对象交给spring管之后我们不用自己手动去new对象了，也就是控制权的转让。

    spring使用BeanFactory来实例化、配置和管理对象，但是它只是一个接口，里面有一个getBean()方法。

    我们一般都不直接用BeanFactory，而是用它的实现类 **ApplicationContext** ，这个类会自动解析我们配置的**applicationContext.xml**
2. bean实例化的三种方式
    - 使用类的无参数构造，类里面没有无参数的构造，会出现异常
    - 使用静态工厂创建

        创建静态的方法，返回类对象
    - 使用实例工厂创建

        创建不是静态的方法，返回类对象
### bean标签的常用属性
1. id属性
    - 起名称，id属性值名称任意命名
    - 根据id值得到配置对象
2. class属性
    - 创建对象所在类的全路径
3. name属性
    - 功能和id属性一样，id属性不能包含特殊符号。但在name属性值可以包含特殊对象
4. scope属性
    - singleton：默认值 单例
    - prototype： 多例
## 属性注入
1. 创建对象时候。向类里面属性里面设置值
2. 属性注入的三种方式
    - 使用set方法注入
    ```java
    public class User{
        private String name;
        public void setName(String name){
            this.name=name;
        }
    }
    User user=new User();
    user.setName("a);
    ```
    - 有参数构造注入
    ```java
    public class User{
        private String name;
        public User(String name){
            this.name=name;
        }
    }
     User user=new User("a");
    ```
    - 使用接口注入
3. 在spring框架中，支持前两种方式

## 注入对象类型属性
1. 创建service类和dao类
    1. 在service得到dao对象
2. 具体实现过程
    1. 在service里面的dao作为类型属性
    2. 生成dao类型属相的set方法
## 注入复杂数据
包括数组，list，map，properties（键值对）
## IOC和DI的区别
1. ioc：控制反转。把对象的创建交给spring配置
2. DI：依赖注入，向类里面的属性中设置值
3. 关系：依赖注入不能单独存在，需要在ioc基础之上完成操作
## spring整合项目原理
1. 加载核心配置文件  
  new对象，功能可以实现，但是效率低
2. 实现思想  
  把加载配置文件和创建对象的过程，在服务器启动的过程时候完成
  3.实现思想
3. ServletContext对象
4. 监听器
5. 具体使用
    - 在服务器启动的时候，为每一个项目创建一个ServletContext对象
    - 在ServletContext对象创建的时候，使用监听器可以具体到ServletContext对象在什么时候创建
    - 使用监听器监听到ServletContext对象创建时候，加载spring配置文件，把配置文件配置对象创建
    - 把创建出来的对象放到ServletContext域对象里（setAttribute方法）
    - 获取对象的时候，到ServletContext域得到（getAttribute方法）
