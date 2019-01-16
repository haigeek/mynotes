# tomcat原理及启动原理

## tomcat的概念

servlet（server applet 服务端小程序）是一种国际组织的协议，约定，tomcat针对servlet协议的规范做了封装，类似的软件还有jetty

## tomcat的总体结构

server->service->connector&container(engine->host->context(wrapper(servlet)))



![图1 Tomcat总体架构](http://img.blog.csdn.net/20170228113436468?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvc3VueXVuamllMzYx/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

tomcat的核心组件是connector和container，connector组件是可以被替换，这样可以提供给服务设计者更多的选择，一个container可以对应多个connector，多个connector和一个container就形成一个service，service负责对外提供服务，server提供service的生存环境，整个tomcat的生命周期由server控制

### server

server的任务是提供一个接口让其他程序访问到service集合，同时要维护它包含的所有的service的生命周期，包括如何初始化，如何结束服务，如何找到别人要访问的service

###  service

connector主要负责对外交流，container主要处理connector接受的请求，主要是处理内部事务，service也就是在connector和container外面多包一层，将他们组装在一起，向外面提供服务，一个service可以设置多个connector，但是只能有一个container容器

### connector

connect将在某个指定的端口来监听客户的请求，把从socket传递过来的数据，封装成request，传递给engine来处理，并从engine出获得响应并返回用户

### container

container是一个接口，定义了下属的各种容器，尤其是wrapper,host,engine,context

### engine

负责处理来自相关联的service的所有请求，处理后，将结果返回service，而connector是作为service与engine的中间媒介出现的

一个engine下可以配置一个默认主机，每个虚拟主机都有一个域名，当engine获得一个请求时，它把该请求匹配到虚拟主机（host）上，然后把请求交给该主机来处理

engine有一个默认主机，当请求无法匹配到任何一个虚拟主机的时候，将交给默认host来处理，engine以线程的方式来处理host

### host

代表一个虚拟主机，每个虚拟主机和某个网络域名相匹配，每个虚拟主机下都可以部署一个或者多个web应用，每个web应用对应于一个context，有一个context path。

当host获得一个请求的时候，将把该请求匹配到某个context上，处理匹配的方法是最长匹配。path==" "的Context将成为该Host的默认Context,所有无法和其它Context的路径名匹配的请求都将最终和该默认Context匹配。

### context

一个Context对应于一个Web应用，一个Web应用由一个或者多个Servlet组成Context在创建的时候将根据配置文件载入Servlet类。当Context获得请求时，将在自己的映射表(mapping table)中寻找相匹配的Servlet类，如果找到，则执行该类，获得请求的回应，并返回。

### wrapper

wrapper代表一个servlet，它负责管理一个servlet，包括servlet的装载，初始化，执行以及资源回收，wrapper是最底层的容器，没有子容器了，warpper的实现类是StandardWarpper，StandardWarpper还实现了拥有了一个servlet初始化信息的servletConfig，由此看出StandardWarpper将直接和servlet的各种信息打交道

### lifecycle

很多对象都具有生命周期，从初始化、运行、回收等阶段，tomcat中容器相关的很多组件都实现了lifecycle接口，当tomcat启动时，依赖的下层组件会全部进行初始化，并且可以对每个组件生命周期中的事件添加监视器（LifecycleListener）。例如当服务器启动的时候，tomcat需要去调用servlet的init方法和初始化容器等一系列操作，而停止的时候，也需要调用servlet的destory方法。而这些都是通过org.apache.catalina.Lifecycle接口来实现的。由这个类来制定各个组件生命周期的规范。LifecycleEvent是当有监听事件发生的时候，LifecycleEvent会存储时间类型和数据。

## tomcat的启动过程

1. 运行startup.bat或者startup.sh文件启动文件，这两个文件最后都会调用，org.apache.catalina.startup包下面Bootstrap类的main方法。
2. main方法先实例化一个BootStarp实例，接着调用init方法，init方法是生命周期方法
3. init方法先初始化类加载器createClassLoader，createClassLoader需要传入一个父加载器，初始化完类加载器后，使用反射机制调用org.apache.catalina.startup.Catalina类下的setParentClassLoader方法
4. 调用完init方法执行load方法，load方法通过反射调用Catalina类的load方法
5. load方法中比较重要的方法就是createStartDigester()，createStartDigester方法主要的作用就是帮我们实例化了所有的服务组件包括server,service和connect。初始化操作完成后，接下来会执行catalina实例的start方法。
6. 从上面加载的组件中，Tomcat会默认加载org.apache.catalina.core.StandardServer作为Server的实例类。
7. 在Server的start的方法里面会执行service的start方法。在createStartDigester()方法里面，会默认加载org.apache.catalina.core.StandardService类。会接着调用Service的start方法。 
8. service中会调用connector的start方法。至此Tomcat启动完毕



## tomcat处理一个http请求的过程

假设来自客户的请求为：http://localhost:8080/test/index.jsp

1. 请求被发送到本机的端口8080，被在那里侦听的Coyote HTTP/1.1 Connector获得
2. Connector把该请求交给它所在service的Engine来处理，并等待来自Engine的回应
3. Engine获得请求localhost/test/index.jsp，匹配它所拥有的所有虚拟主机host
4. Engine匹配到名为localhost的Host
5. localhost Host获得请求/test/insex.jsp,匹配它所拥有的Context，Host匹配到路径为/test的Context（如果匹配不到就把该请求交给路径名为””的Context去处理）
6. path=”/test”的Context获得请求/wsota_index.jsp，在它的mapping table中寻找对应的servlet
7. Context匹配到URL PATTERN为*.jsp的servlet，对应于JspServlet类
8. 构造HttpServletRequest对象和HttpServletResponse对象，作为参数调用JspServlet的doGet和doPost方法
9. Context把执行完了之后的HttpServletResponse对象返回给Host
10. Host把HttpServletResponse对象返回给Engine
11. Engine把HttpServletResponse对象返回给Connector
12. Connector把HttpServletResponse对象返回给客户browser