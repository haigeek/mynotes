# Spring IOC

## 什么是Ioc与DI
IoC—Inversion of Control，即“控制反转”，是一种设计思想。在Java开发中，Ioc意味着将你设计好的对象交给容器控制，而不是传统的在你的对象内部直接控制；
DI-Dependency Injection，即依赖注入，是组件之间的依赖关系由容器在运行期间决定，即由容器动态的将某个依赖关系注入到组件之中，依赖注入的目的并非为软件系统带来更多功能，而是为了提升组件重用的频率，并为系统搭建一个灵活、可扩展的平台。通过依赖注入机制，我们只需要通过简单的配置，而无需任何代码就可指定目标需要的资源，完成自身的业务逻辑，而不需要关心具体的资源来自何处，由谁实现。

### 关于DI的理解：

* 谁依赖于谁：应用程序依赖于IoC容器
* 为什么需要依赖：应用程序需要IoC程序来提供对象需要的外部资源
* 谁注入了谁：IoC容器注入应用程序的某个对象，应用程序依赖的对象
* 注入了什么：注入了某个对象需要的外部资源。相对IoC而言，依赖注入明确描述了被注入对象依赖IoC容器所配置的依赖对象。
### IoC容器的概念

IoC就是具有依赖注入功能的容器，IoC容器负责实例化、定位、配置应用程序中的对象及建立这些对象间的依赖，应用程序无需直接在代码中new相关的对象，应用程序由IoC容器进行组装，在Spring中BeanFactory是Ioc容器的实际代表者，Spring IoC容器通过读取配置文件中的配置元数据，通过元数据对应用中的各个对象进行实例化及装配。

## bean的概念
由IoC容器管理的那些组成你应用程序的对象我们就叫它Bean， Bean就是由Spring容器初始化、装配及管理的对象
## Spring容器装配Bean
### xml方式
示例xml
```xml
<!--声明accountDao对象，交给spring创建-->
<bean name="accountDao" class="com.springIoc.dao.impl.AccountDaoImpl"/>
<!--声明accountService对象，交给spring创建-->
<bean name="accountService" class="com.springIoc.service.impl.AccountServiceImpl">
        <!--注入accountDao对象，需要set方法-->
    <property name="accountDao" ref="accountDao"/>
</bean>
```
xml配置文件的方式对bean进行声明和管理，每一个bean标签都代表着需要被创建的对象并通过property标签可以为该类注入其他依赖对象。通过ClassPathXmlApplicationContext去加载spring的配置文件，接着获取想要的实例bean并调用相应方法执行。对于ClassPathXmlApplicationContext默认加载classpath路径下的文件，只需指明对应文件的classpath路径即可。如果存在多个配置文件，则只需分别传递即可，ClassPathXmlApplicationContext是一个可以接收可变参数的构造函数。实际上ClassPathXmlApplicationContext还有一个孪生兄弟FileSystemXmlApplicationContext，它默认为项目工作路径 即项目的根目录。
#### setter注入方式
Setter注入被注入的属性要有Set方法，通过调用Bean类的setter方法进行注入依赖，<span data-type="color" style="color:#3F3F3F">Setter注入是在bean实例创建完成后执行的</span>
<span data-type="color" style="color:#3F3F3F">1. 通过set注入对象，对象注入使用ref</span>
```xml
<!--声明accountDao对象，交给spring创建-->
<bean name="accountDao" class="com.springIoc.dao.impl.AccountDaoImpl"/>
<!--声明accountService对象，交给spring创建-->
<bean name="accountService" class="com.springIoc.service.impl.AccountServiceImpl">
    <!--注入accountDao对象，需要set方法-->
    <property name="accountDao" ref="accountDao"/>
</bean>
```
<span data-type="color" style="color:#3F3F3F">2. 通过Set注入简单值和map、set、list、数组</span>
```xml
<bean id="account" scope="prototype" class="com.springIoc.pojo.Account">
    <property name="name" value="i am springIoc"/>
    <property name="pwd" value="123"/>
    <property name="books">
        <map>
            <entry key="10" value="java"/>
            <entry key="11" value="java1"/>
            <entry key="12" value="java2"/>
        </map>
    </property>
    <property name="friends">
        <set>
            <value>tom</value>
            <value>jerry</value>
            <value>jack</value>
        </set>
    </property>
    <property name="citys">
        <list>
            <value>shanghai</value>
            <value>zhengzhou</value>
            <value>kunming</value>
        </list>
    </property>
</bean>
```
#### 构造函数注入
<span data-type="color" style="color:#3F3F3F">构造注入也就是通过构造方法注入依赖，构造函数的参数一般情况下就是依赖项，spring容器会根据bean中指定的构造函数参数来决定调用那个构造函数</span>
```java
public class AccountServiceImpl implements AccountService {
    /**
     * 需要注入的对象
     */
    private AccountDao accountDao;

    public void setAccountDao(AccountDao accountDao) {
        this.accountDao = accountDao;
    }

    /**
     * 构造注入
     */
    public AccountServiceImpl(AccountDao accountDao){
        this.accountDao=accountDao;
    }
```
xml配置
```xml
<!--声明accountDao对象，交给spring创建-->
<bean name="accountDao" class="com.springIoc.dao.impl.AccountDaoImpl"/>
<bean name="accountService" class="com.springIoc.service.impl.AccountServiceImpl">
    <!--构造方法注入accountDao对象-->
    <constructor-arg ref="accountDao"></constructor-arg>
</bean>
```
<span data-type="color" style="color:#3F3F3F">和setter注入一样，构造注入也可传入简单值类型和集合类型，需要注意的是，当一个bean定义中有多个＜constructor-arg＞标签时，它们的放置顺序并不重要，因为Spring容器会通过传入的依赖参数与类中的构造函数的参数进行比较，尝试找到合适的构造函数</span>
<span data-type="color" style="color:#3F3F3F">在某些情况下可能会出现问题，如下的User类，带有两个构造函数，参数类型和个数都是一样的，只是顺序不同，这在class的定义中是允许的，但对于Spring容器来说却是有问题的。</span>

```java
public class User {
    private String name;
    private int age;

    //第一个构造函数
    public User(String name , int age){
        this.name=name;
        this.age=age;
    }
    //第二个构造函数
    public User(int age,String name){
        this.name=name;
        this.age=age;
    }
}
```
当程序运行时，Spring容器会尝试查找适合的User构造函数进而创建User对象，由于＜constructor-arg＞的注入顺序并不重要，从而导致不知该使用两种构造函数中的哪种，这时user实例将创建失败，Spring容器也将启动失败。想要解决这个问题，只要给Spring容器一点点提示，它便能成功找到适合的构造函数从而创建user实例，在＜constructor-arg＞标签中存在一个index的属性，通过index属性可以告诉spring容器传递的依赖参数的顺序，下面的配置将会令Spring容器成功找到第一个构造函数并调用创建user实例。
<span data-type="color" style="color:#3F3F3F">根据参数索引注入</span>

```xml
<bean id="user" class="com.springIoc.pojo.User" >
    <constructor-arg index="0" value="Jack"/>
    <constructor-arg index="1" value="26"/>
</bean>
```
<span data-type="color" style="color:#3F3F3F">除此之外，还有根据参数类型注入和参数名字注入</span>
#### 循环依赖注入的情况
<span data-type="color" style="color:#3F3F3F">这是由于A被创建时，希望B被注入到自身，然而，此时B还有没有被创建，而且B也依赖于A，这样将导致Spring容器左右为难，无法满足两方需求，最后脑袋奔溃，抛出异常。解决这种困境的方式是使用Setter依赖，但还是会造成一些不必要的困扰，因此，不建议在配置文件中使用循环依赖。</span>
### 自动装配
<span data-type="color" style="color:#3F3F3F">除了上述手动注入的情况，Spring还非常智能地为我们提供自动向Bean注入依赖的功能，这个过程一般被称为自动装配（autowiring）。当注入的bean特别多时，它将极大地节省编写注入程序的时间，因此在开发中，非常常见。Spring的自动装配有三种模式：byTpye(根据类型)，byName(根据名称)、constructor(根据构造函数)。</span>
#### 基于xml的自动装配
__<span data-type="color" style="color:#3F3F3F">byTpye(根据类型)</span>__
<span data-type="color" style="color:#3F3F3F">在byTpye模式中，Spring容器会基于反射查看bean定义的类，然后找到与依赖类型相同的bean注入到另外的bean中，这个过程需要借助setter注入来完成，因此必须存在set方法，否则注入失败</span>
```java
//dao层
public class UserDaoImpl implements UserDao {
    public void done() {
        System.out.println("UserDaoImpl.invoke......");
    }
}
//service层
public class UserServiceImpl implements UserService{
    //需要注入的依赖
    private UserDao userDao;
    //set方法
    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }

    public void done() {
        userDao.done();

    }
}
```
xml配置
```xml
<bean id="userDao" class="com.springIoc.dao.impl.UserDaoImpl"/>
<bean id="userService" autowire="byType" class="com.springIoc.service.impl.UserServiceImpl"/>
```
<span data-type="color" style="color:#3F3F3F">事实上byType模式可能存一种注入失败的情况，由于是基于类型的注入，因此当xml文件中存在多个相同类型名称不同的实例Bean时，Spring容器依赖注入仍然会失败，因为存在多种适合的选项，Spring容器无法知道该注入那种，此时我们需要为Spring容器提供帮助，指定注入那个Bean实例。可以通过＜bean＞标签的autowire-candidate设置为false来过滤那些不需要注入的实例Bean</span>
__<span data-type="color" style="color:#3F3F3F">Byname模式</span>__
byName模式的自动装配，此时Spring只会尝试将属性名与bean名称进行匹配，如果找到则注入依赖bean。
```xml
<bean id="userDao" class="com.springIoc.dao.impl.UserDaoImpl"/>
<bean id="userDao2" class="com.springIoc.dao.impl.UserDaoImpl"/>
<!--根据姓名装配，找到UserServiceImpl名为 userDao属性并注入-->
<bean id="userService" autowire="byName" class="com.springIoc.service.impl.UserServiceImpl"/>
```
<span data-type="color" style="color:#3F3F3F">需要了解的是如果Spring容器中没有找到可以注入的实例bean时，将不会向依赖属性值注入任何bean，这时依赖bean的属性可能为null，因此我们需要小心处理这种情况，避免不必要的奔溃。</span>
__<span data-type="color" style="color:#3F3F3F">constructor模式</span>__
<span data-type="color" style="color:#3F3F3F">在该模式下Spring容器同样会尝试找到那些类型与构造函数相同匹配的bean然后注入</span>
```java
public class UserServiceImpl implements UserService{
    //需要注入的依赖
    private UserDao userDao;
    //constructor模式
    public UserServiceImpl(UserDao userDao){
        this.userDao=userDao;
    }
    public void done() {
        userDao.done();

    }
}
```
xml
```plain
<bean id="userDao" class="com.springIoc.dao.impl.UserDaoImpl"/>
<!--根据构造器装配，找到UserServiceImpl名为 userDao属性并注入-->
<bean id="userService" autowire="constructor" class="com.springIoc.service.impl.UserServiceImpl"/>
```
__注意：__<span data-type="color" style="color:#3F3F3F">在constructor模式下，存在单个实例则优先按类型进行参数匹配（无论名称是否匹配），当存在多个类型相同实例时，按名称优先匹配，如果没有找到对应名称，则注入失败，此时可以使用autowire-candidate=”false” 过滤来解决。</span>
#### 基于注解的自动装配
__基于@Autowired的自动装配__
<span data-type="color" style="color:#3F3F3F">Spring 2.5 中引入了 @Autowired 注释，它可以对类成员变量、方法及构造函数进行标注，完成自动装配的工作。 通过@Autowired的使用标注到成员变量时不需要有set方法，@Autowired 默认按类型匹配的，使用注解前必须先注册注解驱动，这样注解才能被正确识别</span>
```java
public class UserServiceImpl implements UserService{
    //需要注入的依赖
    @Autowired
//    标识成员变量
    private UserDao userDao;
    //constructor模式
    @Autowired
    //标识构造方法
    public UserServiceImpl(UserDao userDao){
        this.userDao=userDao;
    }
    //set方法
    @Autowired
    //标识set方法
    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }
    public void done() {
        userDao.done();
    }
}
```
<span data-type="color" style="color:#3F3F3F">上述代码我们通过3种方式注入userDao实例，xml配置文件只需声明bean的实例即可，在实际开发中，我们只需选择其中一种进行注入操作即可，建议使用成员变量注入，这样可以省略set方法和构造方法，相当简洁。</span>
<span data-type="color" style="color:#3F3F3F">在@Autowired中还传递了一个required=false的属性，false指明当userDao实例存在就注入不存就忽略，如果为true，就必须注入，若userDao实例不存在，就抛出异常。由于默认情况下@Autowired是按类型匹配的(byType)，如果需要按名称(byName)匹配的话，可以使用@Qualifier注解与@Autowired结合</span>
```java
public class UserServiceImpl implements UserService{
    //需要注入的依赖
    @Autowired
    @Qualifier("userDao1") 
 }
```
<span data-type="color" style="color:#3F3F3F">与@Autowried具备相同功效的还有@Resource，默认按 byName模式 自动注入,由J2EE提供，需导入Package: javax.annotation.Resource，可以标注在成员变量和set方法上，但无法标注构造函数。@Resource有两个中重要的属性：name和type。Spring容器对于@Resource注解的name属性解析为bean的名字，type属性则解析为bean的类型。因此使用name属性，则按byName模式的自动注入策略，如果使用type属性则按 byType模式自动注入策略。倘若既不指定name也不指定type属性，Spring容器将通过反射技术默认按byName模式注入。</span>
```java
public class UserServiceImpl implements UserService{
    //需要注入的依赖
    @Autowired
    @Qualifier("userDao")
//    标识成员变量
    //上述代码等价与@Resource
    @Resource(name = "userDao")
    private UserDao userDao;
    //set方法
    @Autowired
    //标识set方法
    @Resource(name = "userDao")
    //也可以用于标识set方法
    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }
｝
```

__基于@Value注解的自动装配以及properties文件读取__
上述两种自动装配的依赖注入并不适合简单值类型，如int、boolean、long、String以及Enum等，对于这些类型，Spring容器也提供了@Value注入的方式，可以解决很多硬编码问题。@Value接收一个String的值，该值指定了将要被注入到内置的java类型属性值，大多数情况下Spring容器都会自动处理好类型转换。一般情况下@Value会与properties文件结合使用，也分两种情况一种是SpEL（有点类似于jsp的EL），另外一种是占位符方式，一个简单例子jdbc.properties文件如下：
```java
jdbc.driver=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://127.0.0.1:3306/test?characterEncoding=UTF-8&allowMultiQueries=true
jdbc.username=root
jdbc.password=root
```

```plain
public class UserServiceImpl implements UserService {
    //标注成员变量
    @Autowired
    @Qualifier("userDao")
    private UserDao userDao;
    //占位符方式
    @Value("${jdbc.url}")
    private String url;
    //SpEL表达方式，其中代表xml配置文件中的id值configProperties
    @Value("#{configProperties['jdbc.username']}")
    private String userName;
    @Override
    public void done(){
        System.out.println("url:"+url);
        System.out.println("username:"+userName);
        userDao.done();
    }
}

```
## bean的命名
1. 不指定id，只配置必须的全限定类名，由IoC容器为其生成一个标识，客户端必须通过接口“TgetBean(Class<T> requiredType)”获取Bean；
2. 指定id，必须在Ioc容器中唯一
3. 指定name，这样name就是“标识符”，必须在Ioc容器中唯一
4. 指定id和name，id就是标识符，而name就是别名，必须在Ioc容器中唯一；
5. 指定多个name，多个name用“，”、“；”、“ ”分割，第一个被用作标识符，其他的（alias1、alias2、
alias3）是别名，所有标识符也必须在Ioc容器中唯一
6. 使用<alias>标签指定别名，别名也必须在IoC容器中唯一
7. 显然如果我们想要配置的Bean对象已存在，并且希望向一些Bean赋予特别的名称，此时别名就相当有用了。上述的Bean对象声明使用都在xml内声明手动声明的方式，一旦Bean对象多起来，管理Bean可能会发生繁琐的情况，因此Spring提供了基于Java注解的配置方式：
#### 基于注解的bean的配置方式
```java
//@Component 相同效果
@Service
public class AccountServiceImpl implements AccountService {
  @Autowired
  private AccountDao accountDao;
}

//@Component 相同效果
@Repository
public class AccountDaoImpl implements AccountDao{
//......
}

```
以上的声明方式与之前在xml声明bean的效果相同。这里我们需要明白可以使用@Component注解达到与@Service和@Repository的效果，@Component与@Service的含义并无差异，只不过@Service更能让我们明白该类为业务类罢了。至于@Repository在表示数据访问层含义的同时还能够启用与Spring数据访问相关链的其他功能,同时还可给@Component、@Service和@Repository输入一个String值的名称，如果没有提供名称，那么默认情况下就是一个简单的类名(第一个字符小写)变成Bean名称。
```java
@Service("accountService")
public class AccountServiceImpl implements AccountService {
  @Autowired
  private AccountDao accountDao;
}

@Repository("accountDao")
public class AccountDaoImpl implements AccountDao{
//......
}
```
Spring的框架中提供了与@Component注解等效的三个注解，@Repository 用于对DAO实现类进行标注，@Service用于对Service实现类进行标注
### bean的实例化
默认情况下Spring容器在启动阶段就会创建bean，这个过程被称为预先bean初始化，这样是有好处的，可尽可能早发现配置错误，如配置文件的出现错别字或者某些bean还没有被定义却被注入等。当然如存在大量bean需要初始化，这可能引起spring容器启动缓慢，一些特定的bean可能只是某些场合需要而没必要在spring容器启动阶段就创建，这样的bean可能是Mybatis的SessionFactory或者Hibernate SessionFactory等，延迟加载它们会让Spring容器启动更轻松些，从而也减少没必要的内存消耗。
＜context:component-scan/＞与＜context:annotation-config/＞
在基于主机方式配置Spring时,Spring配置文件applicationContext.xml,可见<context:annotation-config/>这样一条配置，它的作用是隐式的向Spring容器注册
因此如果在Spring的配置文件中事先加上<context:annotation-config/>这样一条配置的话，那么所有注解的传统声明就可以被 忽略，即不用在写传统的声明，Spring会自动完成声明。
<context:component-scan/>的作用是让Bean定义注解工作起来,也就是上述传统声明方式。 它的base-package属性指定了需要扫描的类包，类包及其递归子包中所有的类都会被处理。
当spring的xml配置文件出了＜context:component-scan/＞后，＜context:annotation-config/＞就可以不使用了，因为＜context:component-scan/＞已包含了＜context:annotation-config/＞的功能了。在大部分情况下，都会直接使用＜context:component-scan/＞进行注解驱动注册和包扫描功能。

__Bean的作用域__
Bean的作用域是指spring容器创建Bean后的生存周期即由创建到销毁的整个过程。
1. Singleton域

之前我们所创建的所有Bean其作用域都是Singleton，这是Spring默认的，在这样的作用域下，每一个Bean的实例只会被创建一次，而且Spring容器在整个应用程序生存期中都可以使用该实例。因此之前的代码中spring容器创建Bean后，通过代码获取的bean，无论多少次，都是同一个Bean的实例。我们可使用＜bean＞标签的scope属性来指定一个Bean的作用域，如下：

<div class="bi-table">
  <table>
    <colgroup>
      <col width="auto" />
    </colgroup>
    <tbody>
      <tr>
        <td rowspan="1" colSpan="1">
          <div data-type="p"><span data-type="color" style="color:#880000">&lt;!-- 默认情况下无需声明Singleton --&gt;</span></div>
          <div data-type="p"><span data-type="color" style="color:#006666">&lt;</span><span data-type="color" style="color:#000088">bean</span><span data-type="color" style="color:#006666"> </span><span data-type="color" style="color:#660066">name</span><span data-type="color"
              style="color:#006666">=</span><span data-type="color" style="color:#008800">&quot;accountDao&quot;</span><span data-type="color" style="color:#006666"> </span><span data-type="color" style="color:#660066">scope</span><span data-type="color"
              style="color:#006666">=</span><span data-type="color" style="color:#008800">&quot;singleton&quot;</span></div>
          <div data-type="p"><span data-type="color" style="color:#660066">class</span><span data-type="color" style="color:#006666">=</span><span data-type="color" style="color:#008800">&quot;com.springIoc.dao.impl.AccountDaoImpl&quot;</span><span data-type="color" style="color:#006666">/&gt;</span></div>
        </td>
      </tr>
    </tbody>
  </table>
</div>

2. Prototype域

除了Singleton外还有另外一种比较常用的作用域，prototype，它代表每次获取Bean实例时都会新创建一个实例对象，类似new操作符。

<div class="bi-table">
  <table>
    <colgroup>
      <col width="auto" />
    </colgroup>
    <tbody>
      <tr>
        <td rowspan="1" colSpan="1">
          <div data-type="p"><span data-type="color" style="color:#880000">&lt;!-- 作用域：prototype --&gt;</span></div>
          <div data-type="p"><span data-type="color" style="color:#006666">&lt;</span><span data-type="color" style="color:#000088">bean</span><span data-type="color" style="color:#006666"> </span><span data-type="color" style="color:#660066">name</span><span data-type="color"
              style="color:#006666">=</span><span data-type="color" style="color:#008800">&quot;accountDao&quot;</span><span data-type="color" style="color:#006666"> </span><span data-type="color" style="color:#660066">scope</span><span data-type="color"
              style="color:#006666">=</span><span data-type="color" style="color:#008800">&quot;prototype&quot;</span></div>
          <div data-type="p"><span data-type="color" style="color:#660066">class</span><span data-type="color" style="color:#006666">=</span><span data-type="color" style="color:#008800">&quot;com.springIoc.dao.impl.AccountDaoImpl&quot;</span><span data-type="color" style="color:#006666">/&gt;</span></div>
        </td>
      </tr>
    </tbody>
  </table>
</div>

3. request域

request作用域：表示每个请求需要容器创建一个全新Bean。比如提交表单的数据必须是对每次请求新建一个Bean来保持这些表单数据，请求结束释放这些数据。

4. session域

session作用域：表示每个会话需要容器创建一个全新Bean。比如对于每个用户一般会有一个会话，该用户的用户信息需要存储到会话中，此时可以将该Bean配置为web作用域。

5. globalSession域

这种作用域类似于Session作用域，相当于全局变量，类似Servlet的Application，适用基于portlet的web应用程序，portlet在这指的是分布式开发，而不是portlet语言开发。
__Bean的延迟加载__

在某些情况下，我们可能希望把bean的创建延迟到使用阶段，以免消耗不必要的内存，Spring也支持了延迟bean的初始化。因此可以在配置文件中定义bean的延迟加载，这样Spring容器将会延迟bean的创建直到真正需要时才创建。通常情况下，从一个已创建的bean引用另外一个bean，或者显示查找一个bean时会触发bean的创建即使配置了延迟属性，因此如果Spring容器在启动时创建了那些设为延长加载的bean实例，不必惊讶，可能那些延迟初始化的bean可能被注入到一个非延迟创建且作用域为singleton的bean。在xml文件中使用bean的lazy-init属性可以配置改bean是否延迟加载，如果需要配置整个xml文件的bean都延迟加载则使用defualt-lazy-init属性，但是lazy-init属性会覆盖defualt-lazy-init属性。


