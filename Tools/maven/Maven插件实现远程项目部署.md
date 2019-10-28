# Maven插件实现远程服务器部署

## 背景

通过 tomcat7-maven-plugin 插件将项目自动部署到本地服务器或远程服务器。tomcat7和8均可通过该插件远程部署项目。

## 准备

1. 在tomcat-users.xml 文件配置用户权限

2. webapps文件下存放manager文件（tomcat一般自带这个文件）

3. 如果是远程服务器，还需要设置下manager的content.xml文件，不然会出现IP被限制问题。

4. 启动 tomcat

5. 提供者自动销毁实例代码，因为Dubbo项目在重新部署的时候，会出现服务被占用的情况。解决办法在提供者util包下新增DubboServerListener类，并在web.xml配置文件中引用它。

   ```
   package com.dist.util;
   
   
   /**
    * @author 常志
    * @create 2019-03-5
    **/
   import com.alibaba.dubbo.registry.dubbo.DubboRegistryFactory;
   import com.alibaba.dubbo.rpc.protocol.dubbo.DubboProtocol;
   import org.slf4j.Logger;
   import org.slf4j.LoggerFactory;
   
   import javax.servlet.ServletContextEvent;
   import javax.servlet.ServletContextListener;
   
   public class DubboServerListener implements ServletContextListener{
       /** 日志记录 */
       private Logger logger = LoggerFactory.getLogger(DubboServerListener.class);
       @Override
       public void contextInitialized(ServletContextEvent sce) {
           System.out.println("初始化");
       }
   
       @Override
       public void contextDestroyed(ServletContextEvent sce) {
           logger.info("销毁dubbo实例中....");
           DubboRegistryFactory.destroyAll();
           DubboProtocol.getDubboProtocol().destroy();
           logger.info("销毁dubbo服务完成！");
       }
   }
   ```

   ```
   <listener>
      <listener-class>com.dist.util.DubboServerListener</listener-class>
   </listener>
   ```

   

### 具体使用

------

1. 在提供者和消费者pom文件处添加以下代码

   ```
   <plugin>
       <groupId>org.apache.tomcat.maven</groupId>
       <!-- 引入tomcat插件 -->
       <artifactId>tomcat7-maven-plugin</artifactId>
       <configuration>
           <url>http://127.0.0.1:8080/manager/text</url>
           <username>admin</username>
           <password>admin</password>
           <path>/dgp-server-service</path>
       </configuration>
       <version>2.2</version>
   </plugin>
   ```

2. url 本地或远程服务器tomcat地址

3. username 和 password 是tomcat配置的用户和密码

4. path 是打包后的名称，tomcat7-maven-plugin 会自动帮你打包

5. 运行命令 mvn tomcat7:deploy 部署项目

   

### 可能会遇到的问题

------

1. 用户权限问题，解决办法：

   ```
   <role rolename="admin-gui"/>
   	<role rolename="admin-script"/>
   	<role rolename="manager-gui"/>
   	<role rolename="manager-script"/>
   	<role rolename="manager-jmx"/>
   	<role rolename="manager-status"/>
   	<user username="admin" password="admin" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui,admin-script "/>
   ```

2. 远程tomcat IP限制问题，解决办法tomcat-manager-META-INF-context.xml 将 Context下面的内容注释掉
3. 多次重复部署，提供者报错问题，解决办法参考 **准备 **第四步。

4. 单独对提供者或消费者上传打包的时候，dgp-server-api 或 dgp-server-base 会提示找不到，解决办法 dgp-server-root 执行 install 命令，原因 将api和base包保存到本地，在进行上传的时候会从本地获取api和base包。

5. tomcat开启状态，url连接不上

   1. 先检查地址和端口号

   2. 检查tomcat是否启动

   3. 进入tomcat管理页面，并尝试登陆。如：http://localhost:8080/

      

### 总结

------

优点

1. 可以节省切换服务器和部署时间，并且操作简单。
2. 再次部署不需要重启tomcat，可以节省部分时间，并且不影响其他项目使用。

缺点

 	1. tomcat必须是启动状态。
 	2. 无法支持单文件更新，一般是提供者或者消费者单独重新部署。