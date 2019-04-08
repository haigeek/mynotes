# ELK搭建

## 环境搭建

### ES

#### 下载

wget https://artifacts.elastic.co/downloads/logstash/logstash-6.0.0.tar.gz

#### 安装

Elasticsearch 不能使用 root 用户启动，因此需要添加新的用户：

useradd -d /usr/elk -m -s /bin/bash elk

将下载后的文件进行解压，配置文件进行配置 

#### 可能出现的问题

1、es的虚拟内存问题

```
ERROR: [2] bootstrap checks failed
[1]: initial heap size [536870912] not equal to maximum heap size [1073741824]; this can cause resize pauses and prevents mlockall from locking the entire heap
[2]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

处理方式：

在/etc/sysctl.conf加上vm.max_map_count = 262144

```
vim /etc/sysctl.conf
vm.max_map_count = 262144
```

注意要=左右的空格，在修改完成之后执行：

```
sysctl -p
```

修改limits.conf:用来保护系统的资源访问，和sysctl.conf很像，但是limits.conf是针对于用户，而sysctl.conf是针对于操作系统.

```
[root@es-master local]# vim /etc/security/limits.conf
#在文件末尾添加如下内容：
elk soft nofile 65536
elk hard nofile 131072
elk soft nproc 4096
elk hard nproc 4096
```

2、ERROR: bootstrap checks failed
 system call filters failed to install; check the logs and fix your configuration or disable system call filters at your own risk

原因：这是在因为Centos6不支持SecComp，而ES5.2.0默认bootstrap.system_call_filter为true进行检测，所以导致检测失败，失败后直接导致ES不能启动。

解决：在elasticsearch.yml中配置bootstrap.system_call_filter为false，注意要在Memory下面:

```
 bootstrap.memory_lock: false
 bootstrap.system_call_filter: false
```

后台运行

```
./bin/elasticsearch -d
```

### Log stash

wget https://artifacts.elastic.co/downloads/logstash/logstash-6.0.0.tar.gz



./bin/logstash -f config/logstash-test.conf



nohup ./bin/logstash -f config/logstash-test.conf &

### kibana

wget https://artifacts.elastic.co/downloads/kibana/kibana-6.0.0-linux-x86_64.tar.gz



授权、更改用户



后台启动 dgp-server-web



## ELK集成说明

### 引入jar

```
<!-- logback -->
<dependency>
    <groupId>net.logstash.logback</groupId>
    <artifactId>logstash-logback-encoder</artifactId>
    <version>4.11</version>
</dependency>
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>1.2.3</version>
</dependency>
<dependency>
    <groupId>net.logstash.log4j</groupId>
    <artifactId>jsonevent-layout</artifactId>
    <version>1.7</version>
</dependency>

```

### 修改logback配置文件

![image-20190316110210979](https://ws1.sinaimg.cn/large/006tKfTcgy1g14ge2x26gj31co0n8gst.jpg)

需要指定好日志的应用名称

```
<!-- 发送日志到 logstash -->
<appender name="STASH" class="net.logstash.logback.appender.LogstashTcpSocketAppender">
   <destination>192.168.200.39:8050</destination>
   <!-- encoder is required -->
   <encoder charset="UTF-8" class="net.logstash.logback.encoder.LogstashEncoder"/>
</appender>

<root level="info">
		<appender-ref ref="STASH"/>
		<appender-ref ref="CONSOLE" />
</root>
```

访问地址

http://192.168.200.39:5601



