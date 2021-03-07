# zookeeper未授权访问漏洞修复方案

## zk的身份认证与权限

**身份认证方式有四种：**

world：默认方式，相当于全世界都能访问

auth：代表已经认证通过的用户(cli中可以通过addauth digest user:pwd 来添加当前上下文中的授权用户)

digest：即用户名:密码这种方式认证，这也是业务系统中最常用的

ip：使用Ip地址认证

**对节点的操作权限有：**

CREATE、READ、WRITE、DELETE、ADMIN 也就是 增、删、改、查、管理权限，这5种权限简写为crwda(即：每个单词的首字符缩写)

注：这5种权限中，delete是指对子节点的删除权限，其它4种权限指对自身节点的操作权限

## zk配置

使用auth方式进行zk的认证

1、首先使用zkcli登录zk

```
# linux
./zkCli.sh
# win
zkCli.cmd
```

2、查找所有节点

```
ls /
```

输出结果为：

```
[spring-cloud-service, dubbo, services, zookeeper]
```

3、新增登录zk需要的用户名密码

```
addauth digest dist:pass
```

4、对节点分别进行授权（根据2查出来的列表）

```
setAcl /dubbo auth:dist:pass:rwadc
setAcl /zookeeper auth:dist:pass:rwadc
setAcl /spring-cloud-service auth:dist:pass:rwadc
setAcl /services auth:dist:pass:rwadc
```

假如取消授权，使用下面命令 将节点（ 也需要是具体的节点）权限设置为world权限，并允许任何人进行acd操作

```
setAcl /dubbo  world:anyone:acd
```

## dubbo应用配置

dubbo支持使用认证方式登录zk

在系统的dubbo配置xml中增加username和password即可

```
<dubbo:registry address="${dubbo.registry.address}" file="${dubbo.registry.file}" username="dist" password="pass"/>
```

假如dubbo中不增加相关配置 会报如下错误：

```
Caused by: org.I0Itec.zkclient.exception.ZkException: org.apache.zookeeper.KeeperException$NoAuthException: KeeperErrorCode = NoAuth for /dubbo/com.dist.dis.api.service.xxx
```

