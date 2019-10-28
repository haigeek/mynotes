# Tomcat7 VS Tomcat8

## 协议的不同

​	在servlet3.1中实现了非阻塞式的I/O通信

Tomcat7：org.apache.coyote.http11.Http11Protocol

Tomcat8：org.apache.coyote.http11.Http11NioProtocol



Bio：一个线程处理一个请求。缺点：并发量高时，线程数较多，浪费资源。

Nio：利用Java的异步IO处理，可以通过少量的线程处理大量的请求。



## WebSocket

tomcat8正式支持WebSocket 1.0这个标准的API。

tomcat7中支持不够好。



## URIEncoding

Tomcat7：默认编码是ISO-8859-1 （URIEncoding）

Tomcat8：默认编码是UTF-8 （uriCharset）



### 部署方式

部署方式一致



## 推荐的Tomcat配置

1、Server 端口修改

```xml
<Server port="8005" shutdown="SHUTDOWN"></Server>
<!-- port改成 -1 -->
<Server port="-1" shutdown="SHUTDOWN"></Server>
```



2、打开连接池配置

```xml
<!-- 默认被注释
    <Executor name="tomcatThreadPool" namePrefix="catalina-exec-"
        maxThreads="150" minSpareThreads="4"/>
-->
 <Executor name="tomcatThreadPool" namePrefix="catalina-exec-"
           maxThreads="300" minSpareThreads="20" 
           prestartminSpareThreads="true" maxQueueSize="100"/> 
```

- name: 线程名称
- namePrefix: 线程前缀
- maxThreads : 最大并发连接数
- minSpareThreads：Tomcat启动初始化的线程数
- prestartminSpareThreads：在tomcat初始化的时候就初始化minSpareThreads的值
- maxQueueSize: 最大的等待队列数，超过则拒绝请求



3、Connector配置

```xml
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
<!-- 修改为 -->
<Connector port="8080" protocol="org.apache.coyote.http11.Http11Nio2Protocol"
        connectionTimeout="20000"
        redirectPort="8443" 
        executor="tomcatThreadPool"
        enableLookups="false" 
        compression="on" 
        compressionMinSize="2048" 
        noCompressionUserAgents="gozilla, traviata" 
        compressableMimeType="text/html,text/xml,text/plain,
                      text/css,text/javascript,application/javascript" 
/>
```

- connectionTimeout：连接超时时间
- enableLookups：表示支持域名解析,可以把IP地址解析为主机名。
- compression：on，表示开启 gzip压缩功能
- compressionMinSize：2048：大于2k的数据压缩
- noCompressionUserAgents：浏览器不启用 gzip 功能
- compressableMimeType：压缩文件类型



4、禁用AJP协议的Connector

```xml
<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />
<!-- 可注释掉 -->
```

