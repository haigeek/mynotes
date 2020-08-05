# JavaEE框架面试题

## JavaEE

1. servlet生命周期及各个方法

2. servlet如何自定义filter

3. jsp原理

4. jsp和Servlet的区别
   - jsp经过编译之后就变成了“类servlet”
   - jsp由html代码和jsp标签构成，更擅长页面显示；servlet更擅长流程控制
   - jsp中嵌入java代码，而servlet中嵌入HTML代码

5. Jsp的动态include和静态include
   - 动态include用jsp：include动作实现，如<jsp:include page="abc.jsp" flush="true" />，它总是会检查所含文件的变化，适合包含动态页面，解析后和主页面一并显示，即先编译后包含
   - 静态include用include伪码实现，不会检查所含文件的变化，适用于包含静态界面，如<%@ include file="qq.htm" %>，不会提前解析所要包含的界面，先把要显示的界面包含进来，然后统一编译，即先包含再编译
6. session和cookie的区别

## JavaEE框架

1. Struts中的请求处理

2. MVC概念

3. Spring  mvc与Struts区别

4. HIbernate/Ibatis两者的区别

5. HIbernate一级和二级缓存

6. HIbernate实现集群部署

7. HIbernate如何实现声明式事务

8. 简述HIbernate常见的优化策略

9. Spring bean的加载过程

10. Spring如何实现AOP和IOC

11. Spring bean注入方式

12. Spring的事务管理

13. Spring事务的传播特性

14. springmvc原理

15. springmvc用过哪些注解

16. Restful有几种请求，有什么好处

18. Tomcat、Apache、JBoss的区别

    - Apache：HTTP服务器（web服务器），类似iis，可以用于建立虚拟站点，编译处理静态页面，可以支持ssl技术，支持多个虚拟主机等功能
    - Tomcat：Servlet容器，用于解析jsp，servlet的servlet容器，是高效、轻量级的容器，缺点是不支持EJB，只能用于Java应用
    - Jboss：应用服务器，运行EJB的就、J2EE的应用服务器，遵循J2EE规范，能够提供更多平台的支持和更多集成功能，如数据库连接，JCA等，其对Servlet的支持是通过其他Servlet容器实现的，如tomcat和jetty

19. memcached和redis的区别

20. 有没有聚遇到中文乱码问题，如何解决

21. 如何理解分布式锁

22. 你知道的开源协议

23. json和xml的区别
    xml：

    - 应用广泛，可拓展性强，被广泛应用于各种场合
    - 读取、解析没有json快
    - 可读性强，可描述复杂结构

    json：

    - 结构简单，都是键值对
    - 读取，解析快，很多语言支持
    - 传输数据量少。传递效率大大提高
    - 描述复杂结构较弱