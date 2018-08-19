# zookeeper注册中心的安装
## 什么是zookeeper
zookeeper是一个开源的分布式协调服务，zookeeper的设计目标是将那些复杂且容易出错的分布式一致性服务封装起来，以一系列的简单易用的接口提供给用户使用，分布式应用程序可以基于他实现诸如数据发布/订阅、负载均衡、命名服务、分布式协调/通知、集群管理、分布式锁和分布式队列等功能
## 安装和配置
1. 从官网下载压缩包后解压到本地
2. 在conf文件夹下存在一个名为zoo_simple.conf的配置文件，复制此配置文件并重新命名为zoo.conf即可，因为zookeeper在启动时需要在conf文件夹下寻找这个配置文件
![
](http://upload-images.jianshu.io/upload_images/1733731-13f4ad2597e575d3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3. 修改zoo.conf的配置文件
```
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial 
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just 
# example sakes.
dataDir=E:\\Program Files\\zookeeper-3.4.10\\data
dataLogDir=E:\\Program Files\\zookeeper-3.4.10\\log
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the 
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
```
- dataDir 对于产生的数据文件的位置 
- dataLogDir 对于产生日志文件的位置
其他按照默认配置即可运行，需要修改的部分按照注释进行配置
## 使用
进入bin文件夹，点击zkServer.cmd（win系统下），linux系统需要点击.sh结尾的文件即可运行程序，此时在dubbo的配置文件中可以选择注册中心为zookeeper