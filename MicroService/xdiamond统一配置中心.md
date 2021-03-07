## xdiamond 统一配置中心
#### 1. 部署并启动 xdiamond 
##### (1) 下载 [xdiamond 源码](https://github.com/hengyunabc/xdiamond?tdsourcetag=s_pcqq_aiomsg) 或者 [xdiamond 包](http://elb-zentao-361931552.cn-northwest-1.elb.amazonaws.com.cn:5336/artifactory/webapp/#/search/quick/eyJzZWFyY2giOiJxdWljayIsInF1ZXJ5IjoieGRpYW1vbmQifQ==)(下载包可忽略下面操作，直接引用或启动)

##### (2) 修改 xdiamond 的 jdk 版本为 1.8，使用 tomcat8 服务器
> 此处升级 jdk 版本与 tomcat 版本主要是为了更好集成高配置环境项目用，无特殊要求可不进行升级  

- **升级 xdiamond-rootpom 的 pom.xml 配置文件中的 maven-compiler-plugin 插件的 jdk 配置为1.8**
```
    <plugin>
    	<groupId>org.apache.maven.plugins</groupId>
    	<artifactId>maven-compiler-plugin</artifactId>
    	<version>3.0</version>
    	<configuration>
    	    <source>1.8</source>
    		<target>1.8</target>
    		<encoding>${project.build.sourceEncoding}</encoding>
    	</configuration>
    </plugin>
```

- **升级 xdiamond-client-example 的 pom.xml 配置文件的 maven.compiler.target 和 maven.compiler.source 参数为 1.8**
```
    <maven.compiler.target>1.8</maven.compiler.target>
	<maven.compiler.source>1.8</maven.compiler.source>
```

##### (3) 修改项目配置
- **xdiamond-rootpom 的 pom.xml 配置文件中的 maven-javadoc-plugin 插件不接受 <additionalparam>-Xdoclint:none</additionalparam>，修改为 <doclint>none</doclint>**
```
    <plugin>
		<groupId>org.apache.maven.plugins</groupId>
		<artifactId>maven-javadoc-plugin</artifactId>
		<executions>
			<execution>
				<id>attach-javadocs</id>
				<goals>
					<goal>jar</goal>
				</goals>
				<configuration>
					<!-- add this to disable checking -->
	    			<!--<additionalparam>-Xdoclint:none</additionalparam>-->
                    <doclint>none</doclint>
				</configuration>
			</execution>
		</executions>
	</plugin>
```

- **因为 netty 的依赖版本较低，将 xdiamond-common 中 pom.xml 配置文件的 netty-transport、netty-codec 依赖，xdiamond-server 中 pom.xml 配置文件的 netty-codec、netty-handler 依赖，xdiamond-client 中 pom.xml 配置文件的 netty-handler 依赖的版本都升级到 4.1.16.Final**
```
    <dependency>
		<groupId>io.netty</groupId>
		<artifactId>netty-transport</artifactId>
		<version>4.1.16.Final</version>
	</dependency>
	<dependency>
	    <groupId>io.netty</groupId>
		<artifactId>netty-codec</artifactId>
		<version>4.1.16.Final</version>
	</dependency>
	<dependency>
		<groupId>io.netty</groupId>
		<artifactId>netty-handler</artifactId>
		<version>4.1.16.Final</version>
	</dependency>
```

##### (4) 通过 tomcat 启动 xdiamond-server 模块
##### (5) 通过 Main 启动 xdiamond-client-example

---

#### 2. xDiamond 配置中心简介
![image](https://note.youdao.com/yws/api/personal/file/B947851B19134C4DA0C3FF354D812176?method=download&shareKey=15af24db4b6cfdee2128c31cb8c6c714)  
&#160; &#160; (1) ==**Home**==：xDiamond配置中心的首页  
&#160; &#160; (2) ==**项目管理**==：可增删改查项目及依赖子项目的信息，增删改查项目下的配置文件以及配置文件下的配置信息，管理着 xdiamond 中客户端与服务器的连接以及配置的获取  
&#160; &#160; (3) ==**UserProfile**==：查看当前用户所在的组、拥有角色以及拥有的页面操作权限的基本信息  
&#160; &#160; (4) ==**用户管理**==：可增删改查用户的信息  
&#160; &#160; (5) ==**组管理**==：可增删改查组的信息，以及增删改查组下的用户的信息  
&#160; &#160; (6) ==**角色管理**==：可增删查角色信息，增加删除角色关联的权限、用户、组信息  
&#160; &#160; (7) ==**权限管理**==：可增删查权限信息，拥有的权限指定用户可以进行的页面操作；  
&#160; &#160; (8) ==**全部 Config**==：查看存放在数据库表 config 中的配置信息  
&#160; &#160; (9) ==**依赖图**==：以依赖图的形式描述项目之间的依赖关系  
&#160; &#160; (10) ==**Metrics**==：查看 JVM 的使用情况、HTTP 的请求情况、服务 service 和 缓存 Ehcache 的统计情况  
&#160; &#160; (11) ==**ThreadDump**==：查看并分析线程的情况  
&#160; &#160; (12) ==**SystemProperties**==：查看 xDiamond-server 项目所在系统的系统属性  
&#160; &#160; (13) ==**WebConsole**==：输入"help"命令查看可操作命令以及命令的作用  
&#160; &#160; (14) ==**DruidStat**==：使用 Druid Monitor 监控工具来监控数据源、慢查询、Web应用、URI监控、Session监控、Spring监控  
&#160; &#160; (15) ==**Health**==：查看 xDiamond-server 项目的应用环境总体健康情况  
&#160; &#160; (16) ==**Logger**==：查看 xDiamond-server 项目中所有的 Logger 以及对应的等级 Logger Level  
&#160; &#160; (17) ==**Apidoc**==：使用 swagger 展示并且操作 xDiamond-server 项目中的接口方法  
&#160; &#160; (18) ==**Connections**==：查看连接到 xDiamond-server 服务器项目中的客户端项目的基本信息  
&#160; &#160; (19) ==**LDAP**==：同步 LDAP 的组和用户的信息到数据库中

---

#### 3. xdiamond 中的项目管理操作(确保拥有足够的权限，否则某些操作可能无法实现)
##### (1) 在项目管理首页中列出了 xdiamond 服务器中所有的项目基本信息，在这里可以新建、修改、查找项目；  
![image](https://note.youdao.com/yws/api/personal/file/7D8D109361B44794B5E2B31862E5E91B?method=download&shareKey=bc106728b4c473715d670e56ba586d5d)
##### (2) 点击"查看profile"，进入项目 profile 环境界面，此处列出了项目中的所有环境，例如图中的 base、dev、test、product 四种环境，在这里可以添加、修改、删除 profile 环境；
![image](https://note.youdao.com/yws/api/personal/file/C269C2CCFABD4FA9AE283AF4CAA3C067?method=download&shareKey=9f826f4c88ecbc1dff57b6ee783b99a1)  
##### (3) 点击"查看Config"，进入项目环境中的 config 配置界面，此处列出了项目环境中的所有配置信息，xdiamond 客户端获取的配置值就是此处的 config 配置，在这里可以增加、修改、删除、查看 config 配置信息，其中继承过来的配置需要到配置的来源进行修改或删除操作；
![image](https://note.youdao.com/yws/api/personal/file/C5381395287242E2A08729A71A44431E?method=download&shareKey=ef74c90bf8a4b830c4dd5d46724fe739)

---

#### 4. 将连接的数据库从 Mysql 修改为 Oracle
##### (1) 仿照 ==schema-dev.sql== 和 ==data-dev.sql== 文件内容在 oracle 数据库中建表和添加数据

##### (2) 配置 xdiamond-server 的 jvm 的启动参数，指明 spring profile 为 product
&#160; &#160;&#160; &#160;xdiamond-server 默认的spring profile 是 dev，数据库内容是放在内存中，每次重启都会丢失，所以注意要将 spring profile 改为 product  
> ==**方法一：在 tomcat 中添加启动参数**==  
&#160; &#160;&#160; &#160;**JAVA_OPTS="$JAVA_OPTS  -Dspring.profiles.active=product"**&#160; &#160;(Linux)  
&#160; &#160;&#160; &#160;**set JAVA_OPTS=%JAVA_OPTS% -Dspring.profiles.active=product**&#160; &#160;(Windos)

> ==**方法二：修改 web.xml 配置文件中的 spring.profiles.default 参数值**==  
```
    <context-param>
		<param-name>spring.profiles.default</param-name>
		<param-value>product</param-value>
	</context-param>
```

##### (3) 修改数据库的连接配置
```
    jdbc.driver=oracle.jdbc.driver.OracleDriver
    jdbc.url=jdbc:oracle:thin:@127.0.0.1/ORCL
    jdbc.username=root
    jdbc.password=12345
    druid.initial-size=20
    druid.max-active=200
    druid.min-idle=10
    druid.max-wait=10000
```

##### (4) 修改 dataSource 配置
```
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
		<property name="driverClassName" value="${jdbc.driver}"/>
		<property name="url" value="${jdbc.url}"/>
		<property name="username" value="${jdbc.username}"/>
		<property name="password" value="${jdbc.password}"/>
		<property name="initialSize" value="${druid.initial-size}"/>
		<property name="maxActive" value="${druid.max-active}"/>
		<property name="minIdle" value="${druid.min-idle}"/>
		<property name="maxWait" value="${druid.max-wait}"/>
	</bean>
```

##### (5) 将 ==*Mapper.xml== 和 ==*Example.java== 两类文件中的 Mysql 语法与特殊符号修改为 oracle 的
例如：
> &#160; &#160; &#160; &#160;在 UserExample.java 类文件中为属性字段添加双引号  
![image](https://note.youdao.com/yws/api/personal/file/9491045F2A5C4511A981D7F44C2630F6?method=download&shareKey=0d79e4f55c21b2b695f70711043d763c)

> &#160; &#160; &#160; &#160;在 UserMapper.xml 配置文件中为属性字段添加双引号，创建相应的数据库表序列并且以序列的 nextval 值代替 LAST_INSERT_ID()，将 selectKey 中 order 的值改为 BEFORE  
![image](https://note.youdao.com/yws/api/personal/file/3C35EAA1D207488B83AF0C141B88E1DE?method=download&shareKey=a75477c35b414a8d6ef33dd3d896d81a)

##### (6) 在 mybatis 目录下新建 mybatis-config.xml 配置文件来输出 sql 日志
```
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE configuration
            PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
            "http://mybatis.org/dtd/mybatis-3-config.dtd">
    <configuration>
        <settings>
            <!-- 打印查询语句 -->
            <setting name="logImpl" value="STDOUT_LOGGING" />
        </settings>
    </configuration>
```

---

#### 5. 客户端获取 xDiamond 配置中心的配置信息
##### (1) 将 xdiamond-client 模块打成 jar 包并且在客户端中引入 xdiamond-client 的 jar 包
```
    <dependency>
		<groupId>io.github.hengyunabc.xdiamond</groupId>
		<artifactId>xdiamond-client</artifactId>
		<version>1.0.4</version>
	</dependency>
```

##### (2) 创建 spring 配置文来中添加 xdiamond 配置
```
    <!-- 通过 XDiamondConfigFactoryBean 初始化一个 XDiamondConfig，指定要连接的 xdiamond 项目及环境 -->
    <bean id="xDiamondConfig"
		class="io.github.xdiamond.client.spring.XDiamondConfigFactoryBean">
		<property name="serverHost" value="${xdiamond.server.host:localhost}" />
		<property name="serverPort" value="5678" />
		<property name="groupId" value="io.github.xdiamond" />
		<property name="artifactId" value="xdiamond-client-example" />
		<property name="version" value="0.0.1-SNAPSHOT" />
		<property name="profile" value="${xdiamond.project.profile:dev}" />
		<property name="secretKey" value="${xdiamond.project.secretkey:123456}"></property>
	</bean>
```

##### (3) 获取 xDiamond 配置中心中的配置值
> ==**方法一：将配置值注入到类 bean 的参数中**==  
&#160; &#160; &#160; &#160;在 xdiamond 配置文件中通过 PropertyPlaceholderConfigurer 使用 XDiamondConfig 获取配置，使用 ${} 表达式把配置值注入到类 bean 中，即可通过在类方法中注入该 bean 获取 bean 中的配置值  
```
    <!-- 获取 xdiamond 配置 -->
    <bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
        <property name="properties">
            <bean class="java.util.Properties"
                factory-bean="xDiamondConfig" factory-method="getProperties">
            </bean>
        </property>
    </bean>

    <!-- 把配置注入到 bean 的参数中 -->
    <bean id="clientExampleConfig" class="io.github.xdiamond.example.ClientExampleConfig">
		<property name="memcachedAddress" value="${memcached.serverlist}"></property>
		<property name="zookeeperAddress" value="${zookeeper.address}"></property>
	</bean>
	
	// 自定义类来保存配置值
	public class ClientExampleConfig {
      String memcachedAddress;
      String zookeeperAddress;
      public String getMemcachedAddress() {
        return memcachedAddress;
      }
      public void setMemcachedAddress(String memcachedAddress) {
        this.memcachedAddress = memcachedAddress;
      }
      public String getZookeeperAddress() {
        return zookeeperAddress;
      }
      public void setZookeeperAddress(String zookeeperAddress) {
        this.zookeeperAddress = zookeeperAddress;
      }
      @Override
      public String toString() {
        return "ClientExampleConfig{" +
                "memcachedAddress='" + memcachedAddress + '\'' +
                ", zookeeperAddress='" + zookeeperAddress + '\'' +
                '}';
      }
    }
    
    // 注入 bean 获取 bean 中保存的配置值
    @Autowired
    ClientExampleConfig clientExampleConfig;
```

> ==**方法二：基于前缀注入配置值**==  
&#160; &#160; &#160; &#160;如果项目整合了Spring Boot 框架，在 xdiamond 配置文件中通过 PropertySourcesAdderBean 使用 XDiamondConfig 获取配置，在类中通过 @ConfigurationProperties 注解基于前缀注入配置值  
```
    <!-- 获取 xdiamond 配置 -->
    <bean class="io.github.xdiamond.client.spring.PropertySourcesAdderBean">
		<property name="properties">
			<bean class="java.util.Properties" factory-bean="xDiamondConfig"
				factory-method="getProperties">
			</bean>
		</property>
	</bean>
	
	// 自定义类来保存以 memcached 为前缀的 xdiamond 配置信息
	@Configuration
    @ConfigurationProperties(prefix = "memcached")  // 获取前缀为 memcached 的 xdiamond 配置
    @EnableConfigurationProperties
    public class PrefixExampleConfig {
        private String serverlist;
    
        public String getServerlist() {
            return serverlist;
        }
    
        public void setServerlist(String serverlist) {
            this.serverlist = serverlist;
        }
    
        @Override
        public String toString() {
            return "PrefixExampleConfig{" +
                    "serverlist='" + serverlist + '\'' +
                    '}';
        }
    }
    
    // 同样注入 bean 获取 bean 中保存的配置值
    @Autowired
    PrefixExampleConfig prefixExampleConfig;
```

> ==**方法三：基于注解直接注入配置值**==   
&#160; &#160; &#160; &#160;在 xdiamond 配置文件中通过 PropertyPlaceholderConfigurer 使用 XDiamondConfig 获取配置，然后通过 @Value 注解将配置值直接注入类中     
```
    <!-- 获取 xdiamond 配置 -->
    <bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
        <property name="properties">
            <bean class="java.util.Properties"
                factory-bean="xDiamondConfig" factory-method="getProperties">
            </bean>
        </property>
    </bean>
    
    // 将获取到的 xdiamond 配置值直接注入到 AnnotationExampleConfig 类中
    @Configuration
    public class AnnotationExampleConfig {
        @Value("${memcached.serverlist}")
        String memcachedAddress;
    
        @Value("${zookeeper.address}")
        String zookeeperAddress;
    
        @Override
        public String toString() {
            return "AnnotationConfigExampleConfig{" +
                    "memcachedAddress='" + memcachedAddress + '\'' +
                    ", zookeeperAddress='" + zookeeperAddress + '\'' +
                    '}';
        }
    }
    
    // 同样注入 bean 获取 bean 中保存的配置值
    @Autowired
    AnnotationExampleConfig annotationExampleConfig;
```

---

#### 6. 客户端临时修改本地配置
> ==**方法一：使用 <util:properties> 标签**==    
&#160; &#160; &#160; &#160;在 xdiamond 配置文件的获取 xiamond 配置中，将 property 的 name 修改为 propertiesArray 并且 添加 <util:properties> 标签来临时修改配置信息  
```
    <!-- 获取 xdiamond 配置 -->
	<bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
	    <!-- 设置为 propertiesArray -->
		<property name="propertiesArray">
			<util:list>
				<bean id="xDiamondProperties" class="java.util.Properties"
					  factory-bean="xDiamondConfig" factory-method="getProperties">
				</bean>
				<!-- 通过 <util:properties> 临时修改本地配置 -->
				<util:properties>
					<!-- 将获取到 xdiamond 的 memcached.serverlist 配置值修改为 localhost:8888 -->
					<prop key="memcached.serverlist">localhost:8888</prop>
				</util:properties>
			</util:list>
		</property>
	</bean>
```

> ==**方法二：localtion 指向临时修改配置文件**==  
&#160; &#160; &#160; &#160;将需要临时修改的配置信息添加到配置文件中，在 xdiamond 配置文件的获取 xiamond 配置中，名称为 location 的 property 标签指向该配置文件，从而临时修改配置信息  
```
    <!-- 获取 xdiamond 配置 -->
	<bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
		<!-- 将需要临时修改的配置信息添加到一个配置文件中，location 指向该配置文件 -->
	 	<property name="location" value="classpath:local.properties" />
		<property name="properties">
			<bean id="xDiamondProperties" class="java.util.Properties"
				factory-bean="xDiamondConfig" factory-method="getProperties">
			</bean>
		</property>
	</bean>
	
	# 在 local.properties 配置文件中 指定 memcached.serverlist 的配置值为 localhost:8000
    memcached.serverlist=localhost:8000
```

---

#### 7. 将 xdiamond 配置值同步到客户端系统配置中 
> &#160; &#160; &#160; &#160;在 xdiamond 配置文件的 xDiamondConfig bean 中设置 bSyncToSystemProperties 参数为 true，可实现在 properties 配置文件中通过 ${} 表达式引用 xdiamond 的配置 
```
    # 在 system.properties 配置文件中引用 xdiamond 的 memcached.serverlist 的配置信息
    system.test=aaa${memcached.serverlist}bbb

    <bean id="xDiamondConfig"
		...
		<!-- 设置将配置同步到 System Properties 里，默认为 false -->
		<property name="bSyncToSystemProperties" value="true" />
	</bean>
    
    <!-- 获取 xdiamond 配置 -->
	<bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
		<property name="properties">
			<bean id="xDiamondProperties" class="java.util.Properties"
				factory-bean="xDiamondConfig" factory-method="getProperties">
			</bean>
		</property>
	</bean>
	
	@RunWith(SpringJUnit4ClassRunner.class)
    @ContextConfiguration("/spring-context-test.xml")
    @PropertySource("classpath:system.properties")  // 引入 system.properties 配置文件
    public class ClientExampleTest {
      // 使用 @Value 注解注入 system.test 配置信息
      @Value("${system.test}")
      String systemTest;

      @Test
      public void test() {
        System.err.println(systemTest);
      }
    }
```

---

#### 8. xdiamond客户端多环境配置参数选择
> &#160; &#160; &#160; &#160;在 xdiamond 配置文件中设置各种环境的 xdiamond 连接配置，就可以根据变化的项目环境配置来选择相对应的 xdiamond 连接配置  
```
    <!-- 多环境配置参数选择——product 环境 -->
	<beans profile="product">
		<bean id="projectProfile" class="java.lang.String">
			<constructor-arg value="product" />
		</bean>
		<bean id="projectSecretKey" class="java.lang.String">
			<constructor-arg value="b8ylj4r0OcBMgdNA" />
		</bean>
	</beans>

	<beans>
		<bean id="xDiamondConfig" class="io.github.xdiamond.client.spring.XDiamondConfigFactoryBean">
			...
			<!-- 关联到指定 bean -->
			<property name="profile" ref="projectProfile" />
			<property name="secretKey" ref="projectSecretKey" />
		</bean>

		<!-- 获取 xdiamond 配置 -->
		<bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
			<property name="properties">
				<bean id="xDiamondProperties" class="java.util.Properties"
					  factory-bean="xDiamondConfig" factory-method="getProperties">
				</bean>
			</property>
		</bean>

        <!-- 扫描项目包 -->
		<context:component-scan base-package="io.github.xdiamond.example.test">
		</context:component-scan>
	</beans>
```

---

#### 9. 客户端配置 Listener 监听配置修改
> ==**方法一：spring 配置文件注入 Listener**==   
&#160; &#160; &#160; &#160;在 spring 配置文件中注入 bean，在 bean 中通过 @OneKeyListener 和 @AllKeyListener 注解来获取到最新的 ConfigEvent 配置值。在 ConfigEvent 中，描述了修改配置值的 key(关键字)、oldValue(旧值)、value(新值)、eventType(修改类型：ADD/UPDATE/DELETE)；  
```
    <!-- 注入 Listener -->
    <bean class="io.github.xdiamond.example.listener.ListenerXmlBean"></bean>
    
    public class ListenerXmlBean {
        // 监听名为 testOneKeyListener 的 key 的修改
        @OneKeyListener(key = "testOneKeyListener")
        public void testOneKeyListener(ConfigEvent event) {
            System.err.println("ListenerXmlBean, testOneKeyListener, event :" + event);
        }
        // 监听所有 key 的修改
        @AllKeyListener
        public void testAllKeyListener(ConfigEvent event) {
            System.err.println("ListenerXmlBean, testAllKeyListener, event :" + event);
        }
    }
```

> ==**方法二：扫描 @Service 或 @Component 注解**==  
&#160; &#160; &#160; &#160;扫描以 @Service 或 @Component 注解的 bean，在 bean 中通过 @OneKeyListener 和 @AllKeyListener 注解来获取到最新的 ConfigEvent 配置值；  
```
    // 通过 @ComponentScan 注解扫描包
    @ComponentScan(basePackages = {"io.github.xdiamond.example"})
    
    // 以 @Service 或 @Component 注解 bean
    //@Component
    @Service
    public class ListenerExampleService {
        // 监听名为 testOneKeyListener 的 key 的修改
        @OneKeyListener(key = "testOneKeyListener")
        public void testOneKeyListener(ConfigEvent event) {
            System.err.println("ListenerExampleService, testOneKeyListener, event :" + event);
        }
        // 监听所有 key 的修改
        @AllKeyListener
        public void testAllKeyListener(ConfigEvent event) {
            System.err.println("ListenerExampleService, testAllKeyListener, event :" + event);
        }
    }
```

---

#### 10. 客户端本地缓存
> &#160; &#160; &#160; &#160;xdiamond client 客户端会把最后拉取的配置缓存到本地的 ${usr.home}/.xdiamond 目录下。如果应用在启动时，连接 xdiamond server 失败，那么也会先到这个目录下加载最后缓存的配置。  
![image](https://note.youdao.com/yws/api/personal/file/3C72E41709854840AA16D7760BA74334?method=download&shareKey=90c489947ac048bcacf2ca4b624e3e99)  
![image](https://note.youdao.com/yws/api/personal/file/DE16A61D30EE42C79CBF462582CB6B0C?method=download&shareKey=87088b8fc0dd0bc865fe9536e8bf08c2)

---

#### 11. LDAP 服务器的安装与连接
> (1) [Windows 下 OpenLDAP 的安装及使用](https://blog.csdn.net/chenxuejiakaren/article/details/7367572#)  

> (2) OpenLDAP 的 ldif 文件中条目设置举例（实际使用时"#"井号的注释语句要删除）：  
```
dn: dc=mycompany,dc=com
objectClass: top
objectClass: dcObject
objectClass: domain
dc: mycompany

dn: ou=roles,dc=mycompany,dc=com
objectClass: top
objectClass: organizationalUnit
ou: roles

dn: ou=people,dc=mycompany,dc=com
objectClass: top
objectClass: organizationalUnit
ou: people

dn: cn=Test Users,ou=roles,dc=mycompany,dc=com
# 当 xdiamond 获取 LDAP 数据时，默认获取 objectClass: groupOfUniqueNames 所在条目的数据
objectClass: groupOfUniqueNames
# cn: Test Users 表示组名为 Test Users
cn: Test Users
# uniqueMember 表示用户信息，cn=jbloggs 表示用户名为 jbloggs
uniqueMember: cn=jbloggs,ou=people,dc=mycompany,dc=com

dn: uid=jbloggs,ou=people,dc=mycompany,dc=com
objectClass: person
objectClass: inetOrgPerson
# 在 xdiamond 中登录时匹配用户名为 jbloggs
cn: jbloggs
sn: Bloggs
uid: jbloggs
# 在 xdiamond 中登录时匹配密码为 123456
userPassword: 123456
```

> (3) xdiamond-server 配置连接 LDAP 服务器
```
    # 连接 LDAP 服务器的 url 地址
    xdiamond.ldap.url=ldap://127.0.0.1:389
    # slapd.conf 配置文件中的 rootdn 配置值
    xdiamond.ldap.userDn=cn=Manager,dc=mycompany,dc=com
    # slapd.conf 配置文件中的 rootpw 配置值（不加密的密码）
    xdiamond.ldap.password=123456
    # slapd.conf 配置文件中的 suffix 配置值
    xdiamond.ldap.base=dc=mycompany,dc=com
```

---

#### 12. xdiamond 小心得 
> (1) xdiamond 使用 shiro 做权限控制，当用户登陆成功后，用户拥有的页面操作权限添加到 SimpleAuthorizationInfo 类的 stringPermissions 属性中；  
(2) 拥有不同的权限表示该用户可以进行不同的页面操作，当前用户的具体页面操作权限在 UserProfile 的 Permissions 中有详细描述；  
(3) 新建用户操作在底层的业务逻辑：新建以用户名为名称的组 -> 新建用户 -> 通过新建的组Id 和 用户Id 新建用户与组的联系；  
(4) base profile 里放公共的配置，比如某个服务的端口号，所有的非 base profile 都会继承 base profile 里的配置信息；  
(5) 在数据库中，用户-角色、用户-组、角色-组、角色-权限间存在联系，也是这些联系，使用户、角色、组、权限在业务逻辑上也相互关联；  
 
#### 13. xdiamond 集成到 BS 运维项目（以 dgp-dubbo-server-web 模块为例）
##### (1) 在 pom.xml 配置文件中加入 xdiamond-client 依赖
```
    <!-- 集成 xdiamond-client -->
    <dependency>
        <groupId>io.github.hengyunabc.xdiamond</groupId>
           <artifactId>xdiamond-client</artifactId>
        <version>1.0.4</version>
    </dependency>
```

##### (2) 创建 spring 配置文件，在该配置文件中加入 xdiamond 配置
```
    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:context="http://www.springframework.org/schema/context"
           xmlns:util="http://www.springframework.org/schema/util"
           xsi:schemaLocation="http://www.springframework.org/schema/beans
    		http://www.springframework.org/schema/beans/spring-beans.xsd
    		http://www.springframework.org/schema/context
            http://www.springframework.org/schema/context/spring-context.xsd http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util.xsd">
    
        <!-- 多环境配置参数选择——dev环境 -->
        <beans profile="dev">
            <bean id="xdiamondServerHost" class="java.lang.String">
                <constructor-arg value="localhost" />
            </bean>
            <bean id="xdiamondServerPort" class="java.lang.String">
                <constructor-arg value="5678" />
            </bean>
            <bean id="projectGroupId" class="java.lang.String">
                <constructor-arg value="io.github.xdiamond" />
            </bean>
            <bean id="projectArtifactId" class="java.lang.String">
                <constructor-arg value="xdiamond-jdbc-oracle" />
            </bean>
            <bean id="projectVersion" class="java.lang.String">
                <constructor-arg value="0.0.1" />
            </bean>
            <bean id="projectProfile" class="java.lang.String">
                <constructor-arg value="product" />
            </bean>
            <bean id="projectSecretKey" class="java.lang.String">
                <constructor-arg value="iVXiDPdxipmCfSQ0" />
            </bean>
            <bean id="xdiamondBSyncToSystemProperties" class="java.lang.String">
                <constructor-arg value="true" />
            </bean>
        </beans>
    
        <beans>
            <!-- 通过 XDiamondConfigFactoryBean 初始化一个 XDiamondConfig -->
            <bean id="xDiamondConfig"
                  class="io.github.xdiamond.client.spring.XDiamondConfigFactoryBean">
                <property name="serverHost" ref="xdiamondServerHost" />
                <property name="serverPort" ref="xdiamondServerPort" />
                <property name="groupId" ref="projectGroupId" />
                <property name="artifactId" ref="projectArtifactId" />
                <property name="version" ref="projectVersion" />
                <property name="profile" ref="projectProfile" />
                <property name="secretKey" ref="projectSecretKey" />
                <!-- 是否将 xdiamond 配置值同步到客户端系统配置中 -->
                <property name="bSyncToSystemProperties" ref="xdiamondBSyncToSystemProperties"/>
            </bean>
    
            <!-- 获取 xdiamond 配置 -->
            <bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
                <property name="properties">
                    <bean class="java.util.Properties"
                          factory-bean="xDiamondConfig" factory-method="getProperties">
                    </bean>
                </property>
            </bean>
        </beans>
    </beans>
```

##### (3) 将 xdiamond 配置值注入到 application.yml 配置中
```
    testXdiamond: aaa-${jdbc.driver}-bbb
```

##### (4) 基于注解直接注入 xdiamond 中要获取的配置值到类中
```
    @Configuration
    public class XdiamondConfig {
        @Value("${jdbc.driver}")
        String jdbcDriver;
    
        @Value("${jdbc.url}")
        String jdbcUrl;
    
        @Override
        public String toString() {
            return "XdiamondConfig{" +
                    "jdbcDriver='" + jdbcDriver + '\'' +
                    ", jdbcUrl='" + jdbcUrl + '\'' +
                    '}';
        }
    }
```

##### (5) 获取并使用 xdiamond 的配置值
```
    // 直接通过 @Value 获取 jdbc.driver 配置值
    @Value("${jdbc.driver}")
    private String jdbcDriver;
    
    // 获取 application.yml 配置文件中的 testXdiamond 配置值
    @Value("${testXdiamond}")
    private String testXdiamond;
    
    // 注入 XdiamondConfig 类
    @Autowired
    private XdiamondConfig xdiamondConfig;
```