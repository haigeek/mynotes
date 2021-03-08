## Nginx实现Tomcat集群负载均衡
### 1、负载均衡配置

在nginx的配置文件加入负载均衡组:upstream，定义一个上游服务器集群，关于负载均衡的权重，有一系统的相关设置。

```plain
upstream backend {
# ip_hash;
server s1.barretlee.com;
server s2.barretlee.com;
}
server {
location / {
proxy_pass http://backend;
}
}
```
### 2、负载均衡的模式
内置负载均衡策略
#### - 轮询（默认）
相同的权重，当其中一个挂掉的时候，默认会请求其他的机器
#### - <span data-type="color" style="color:rgb(79, 79, 79)"><span data-type="background" style="background-color:rgb(255, 255, 255)">weight  </span></span>
<span data-type="color" style="color:rgb(79, 79, 79)"><span data-type="background" style="background-color:rgb(255, 255, 255)">默认为1，将请求平均分配给每台server</span></span>
```plain
upstream tomcats {
    server 192.168.0.100:8080 weight=2;  # 2/6次
    server 192.168.0.101:8080 weight=3;  # 3/6次
    server 192.168.0.102:8080 weight=1;  # 1/6次
```
#### down; (down 表示单前的server暂时不参与负载)，backup; (其它所有的非backup机器down或者忙的时候，请求backup机器)
```plain
upstream tomcats {
    server 192.168.0.100:8080 weight=2 max_fails=3 fail_timeout=15;

    server 192.168.0.101:8080 down;

    server 192.168.0.102:8080 backup;
}
```
#### max\_fails ：允许请求失败的次数默认为1.当超过最大次数时，返回。fail\_timeout:max\_fails次失败后，暂停的时间
```plain
upstream tomcats {
    server 192.168.0.100:8080 weight=2 max_fails=3 fail_timeout=15;
    server 192.168.0.101:8080 weight=3;
    server 192.168.0.102:8080 weight=1;
}
```
#### max\_conns 
限制分配给某台Server处理的最大连接数量，超过这个数量，将不会分配新的连接给它。默认为0，表示不限制。注意：1.5.9之后的版本才有这个配置

```plain
upstream tomcats {
    server 192.168.0.100:8080 max_conns=1000;
}
```

表示最多给100这台Server分配1000个请求，如果这台Server正在处理1000个请求，nginx将不会分配新的请求给到它。假如有一个请求处理完了，还剩下999个请求在处理，这时nginx也会将新的请求分配给它。
#### <span data-type="color" style="color:rgb(47, 47, 47)"><span data-type="background" style="background-color:rgb(255, 255, 255)">least_conn</span></span>
```plain

upstream tomcats {
server 192.168.0.100:8080;
server 192.168.0.101:8080;
least_conn;
}

```

#### - ip\_hash
上述方式存在一个问题就是说，在负载均衡系统中，假如用户在某台服务器上登录了，那么该用户第二次请求的时候，因为我们是负载均衡系统，每次请求都会重新定位到服务器集群中的某一个，那么__*已经登录某一个服务器的用户再重新定位到另一个服务器，其登录信息将会丢失，这样显然是不妥的*__。
我们可以采用__*ip\_hash*__指令解决这个问题，如果客户已经访问了某个服务器，当用户再次访问时，会将该请求通过__*哈希算法，自动定位到该服务器*__。
每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决__*session的问题*__。
需要注意的是：ip\_hash要求nginx一定是最前端的服务器，否则nginx得不到正确ip，就不能根据ip作hash。譬如使用的是squid为最前端，那么nginx取ip时只能得到squid的服务器ip地址，用这个地址来作分流是肯定错乱的。

```
upstream backserver {
    ip_hash;
    server 192.168.0.14:88;
    server 192.168.0.15:80;
}
```



![image.png | left | 747x252](https://cdn.nlark.com/yuque/0/2019/png/84598/1550124302648-12930b2f-2758-4635-adfd-d12a80fddb9a.png "")



第三方负载均衡策略
#### fair
根据服务器的响应时间来分配请求，响应时间短的优先分配，即负载压力小的优先会分配。
由于fair模块是第三方提供的，所以在编译nginx源码的时候，需要将fair添加到nginx模块中。
配置使用fair负载策略模块：
```plain

upstream tomcats {
    fair;
    server 192.168.0.100:8080;
    server 192.168.0.101:8080;
    server 192.168.0.102:8080;
}
```

由于采用fair负载策略，配置weigth参数改变负载权重将无效。
#### url\_hash
按请求url的hash结果来分配请求，使每个url定向到同一个后端服务器，服务器做缓存时比较有效。
```plain

upstream tomcats {
    server 192.168.0.100:8080;
    server 192.168.0.101:8080;
    server 192.168.0.102:8080;
    hash $request_uri;
}

```
### Nginx性能优化
```plain
# 这个控制Nginx运行的工作进程个数。大多数情况下，一个CPU核心跑一个工作进程能够工作得很好。可以将该指令设为auto来达到与CPU核心数匹配的工作进程数
worker_processes  auto;
events {
    #这个表示每个工作进程同时能够处理的最大连接数。默认值是512，但是大多数系统能处理更大的值。这个值该设为多少取决于服务器硬件配置以及流量的特性，可以通过测试来发现。
    worker_connections  51200;
}
http {
# Sendfile是一个操作系统特性，可以在Nginx上启用。它通过在内核中从一个文件描述符向另一个文件描述符复制数据，往往能达到零拷贝，因而可以提供更快的TCP数据传输。
sendfile        on;
持久连接可以减少打开和关闭连接所需要的CPU和网络开销，因而对性能有重大影响。表示空闲持久连接保持打开状态多长时间
keepalive_timeout  65;
# 开启压缩，压缩响应可以大大减小响应的大小，减少带宽占用
gzip  on;
}
```

### 性能测试

#### 测试方式

测试工具jmeter
测试结果说明

* Label：每个 JMeter 的 element （例如 HTTP Request ）都有一个 Name 属性，这里显示的就是 Name 属性的值
* Samples：表示你这次测试中一共发出了多少个请求，我的测试计划模拟 10 个用户，每个用户迭代 10 次，因此这里显示 100
* Average：平均响应时间 —— 默认情况下是单个 Request 的平均响应时间，当使用了 Transaction Controller 时，也可以以 Transaction 为单位显示平均响应时间
* Median：中位数，也就是 50 ％用户的响应时间
* 90% Line： 90 ％用户的响应时间
* Min： 最小响应时间
* Max： 最大响应时间
* Error%：本次测试中出现错误的请求的数量 / 请求的总数
* Throughput：吞吐量 —— 默认情况下表示每秒完成的请求数（ Request per Second ），当使用了 Transaction Controller 时，也可以表示类似 LoadRunner 的 Transaction per Second 数
* KB/Sec：每秒从服务器端接收到的数据量，相当于 LoadRunner 中的 Throughput/Sec
  采取两台服务器进行负载均衡，设置了三个线程组，每个线程组100次请求
  tomcat1（8.0）



![image.png | left | 827x221](https://cdn.nlark.com/yuque/0/2019/png/84598/1546783614412-b07aca4f-3639-46ba-8ba0-d14178c38574.png "")


tomcat2（8.5）


![image.png | left | 827x209](https://cdn.nlark.com/yuque/0/2019/png/84598/1546783640108-f13d747c-a3aa-4dd1-9473-0bf859ef9dca.png "")


nginx


![image.png | left | 827x205](https://cdn.nlark.com/yuque/0/2019/png/84598/1546783683698-316466c2-35d6-4423-9ed8-150dd0018a9f.png "")

#### 结果分析

三组测试结果 因为是同样的网络环境，接受数据基本一致；
tomcat8.5的最大响应时间低于8.0
nginx的负载均衡的最大响应时间低于单独的tomcat
但是三组测试的吞吐量基本一致