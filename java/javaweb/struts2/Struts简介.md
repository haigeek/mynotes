# Struts简介
## 什么是Struts
Struts直译过来就是支柱，枝干的意思，它实现了基于javaweb应用的Model-View——Controller设计模式的应用框架
## Struts的体系结构
一个请求在Struts2框架中的处理大概会经过以下结构步骤
1. 客户端发出一个指向Servlet容器（例如Tomcat）的请求
2. 这个请求会经过结构过滤器Filter(ActionContextCleanUP可选过滤器，其他web过滤器如SiteMesh等)，最后到达FilterDispatcher过滤器
3. 接着FilterDispatcher（过滤调度器）过滤器被调用，FilterDispatcher询问ActionMapper来决定这个请是否需要调用某个Action
4. 如果ActionMapper决定需要调用某个Action，FilterDispatcher把请求的处理交给Action对象的代理（ActionProxy）
5. ActionProxy通过配置管理器（Configuration Manager）读取框架的相关的配置文件（Struts.xml以及它包含的*.xml配置文件）找到需要调用的Action类
6. 找到需要调用的Action类之后，ActionProxy会创建一个ActionInvocation（动作调用)的实例
7. ActionInvocation在调用Action的过程之前，会先依次调用相关配置拦截器（Intercepter）执行结果返回结果字符串
8. ActionInvocation负责查找结果字符串对应的Result。然后再执行这个Result，再返回对应的结果视图（如JSP）来呈现界面
9. 再次调用所用的配置拦截器（调用顺序与第7步相反），然后响应（HttpServletResponse)被返回给浏览器
## Struts2的优点
- Struts2是非侵入式设计，即不依赖与Servlet API和StrutsAPI
- Strtus2提供了强大的拦截器，利用拦截器可进行AOP编程（面向切面的编程），实现权限的拦截等功能
- Strtus2提供了类型转换器，可以很方便地进行类型转换，例如将特殊的的请求参数转换成需要的类型
- Struts2支持多种表现层技术，如JSP、FreeMarker、Vectocity
- Struts2的输入验证可以对指定的方法进行验证