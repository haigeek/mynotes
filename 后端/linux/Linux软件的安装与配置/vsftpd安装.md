# Linux下vsftpd的安装与配置

## 安装

使用yum进行安装

```
yum install vsftpd
```

## vsftpd的几个概念

### 用户设置

vsftpd支持以下三种模式的身份认证

1、匿名模式

2、本地用户身份认证模式

3、虚拟用户身份认证模式

在实际的使用中，使用本地身份认证模式是最为简单、相对安全的一种认证模式。

centos7默认已经存在ftp这个用户，假如没有特殊的用户名要求，可以直接使用ftp用户，该用户的主目录为/var/ftp

![image-20190402133018624](https://ws4.sinaimg.cn/large/006tKfTcly1g1o87db03qj30yi0f679h.jpg)

使用passwd修改ftp的密码即可使用ftp用户进行登录；

假如需要指定新的用户来使用ftp，那就新建本地用户即可。

### 连接模式

ftp的连接主要有两种模式，分别是主动模式和被动模式。

FTP只通过TCP连接,没有用于FTP的UDP组件.FTP不同于其他服务的是它使用了两个端口, 一个数据端口和一个命令端口(或称为控制端口)。通常21端口是命令端口，20端口是数据端口。当混入主动/被动模式的概念时，数据端口就有可能不是20了。

#### 主动模式

主动模式下，FTP客户端从任意的非特殊的端口（N > 1023）连入到FTP服务器的命令端口--21端口。然后客户端在N+1（N+1 >= 1024）端口监听，并且通过N+1（N+1 >= 1024）端口发送命令给FTP服务器。服务器会反过来连接用户本地指定的数据端口，比如20端口。

命令连接：客户端 >1023端口 -> 服务器 21端口

数据连接：客户端 >1023端口 <- 服务器 20端口 

#### 被动模式

为了解决服务器发起到客户的连接的问题，人们开发了一种不同的FTP连接方式。这就是所谓的被动方式，或者叫做PASV，当客户端通知服务器它处于被动模式时才启用。

在被动方式FTP中，命令连接和数据连接都由客户端，这样就可以解决从服务器到客户端的数据端口的入方向连接被防火墙过滤掉的问题。当开启一个FTP连接时，客户端打开两个任意的非特权本地端口（N >; 1024和N+1）。第一个端口连接服务器的21端口，但与主动方式的FTP不同，客户端不会提交PORT命令并允许服务器来回连它的数据端口，而是提交PASV命令。这样做的结果是服务器会开启一个任意的非特权端口（P >; 1024），并发送PORT P命令给客户端。然后客户端发起从本地端口N+1到服务器的端口P的连接用来传送数据。

命令连接：客户端 >1023端口 -> 服务器 21端口

数据连接：客户端 >1023端口 -> 服务器 >1023端口 

使用chrome和第三方的连接工具（filezilla等）时，默认是使用被动模式进行连接的

#### 针对两种不同的ftp配置要进行防火墙的设置

主动模式：打开20、21端口

被动模式：打开21和被动模式使用的数据传输端口范围

## 配置

### vsftpd的停止与启动

```
systemctl start vsftpd.service  #启动
systemctl restart vsftpd.service  #重启
systemctl stop vsftpd.service  #停止
```

### 设置ftp文件夹

指定一个文件夹放置ftp使用的文件，并对这个文件夹根据需要赋予权限

例如使用/var/ftp来作为ftp的主要目录

```
chmod -R 775 /var/ftp
```

### 配置文件的配置

要修改的配置文件主要有两个，一个是ftp的配置文件、一个是用户认证的配置文件

#### ftp的配置文件

ftp配置文件的主要修改如下

```
vi  /etc/vsftpd/vsftpd.conf
```

```
#禁止匿名访问(保持默认)
anonymous_enable=NO
#接受本地用户（保持默认）
local_enable=YES
#允许上传
write_enable=YES
#用户只能访问限制的目录
chroot_local_user=YES
#设置固定目录，在结尾添加。
#如果不添加这一行，各用户对应自己的目录，这个文件夹不是固定的，和上一步新建的主文件夹保持一致
local_root=/var/ftp
# 启动被动模式(支持被动模式访问的客户端)
pasv_enable=YES
# 被动模式的端口范围(根据实际情况设定，注意设置防火墙对应的端口为开放)
pasv_min_port=10000
pasv_max_port=11000
```

#### 用户认证的配置文件

修改这个配置文件的主要目的是为了避免  `530 Login incorrect`错误

在`auth required pam_shells.so`前加#，注释这个选项

```
vi /etc/pam.d/vsftpd
```

![image-20190402134556110](https://ws2.sinaimg.cn/large/006tKfTcly1g1o8nkq9z0j310m0jqtb5.jpg)

另外的一种处理方式

pam_shells.so是ftp用户认证的一项依据，含义为检查一下该用户的nologin shell是否在/etc/shells , PAM 不允许不在/etc/shells 里的用户shell 进行认证。

例如ftp用户的shell为：sbin/nologin

但是这个shell并不存在于 /etc/shells文件中，编辑/etc/shells 如下

![image-20190402141225107](https://ws4.sinaimg.cn/large/006tKfTcly1g1o9f4wq3fj30w20ik75f.jpg)

默认只有前四个shell，导致认证不通过，我们可以加上ftp用户使用的shell，上图为sbin/nologin

假如使用了这样的配置方式，不需要在`auth required pam_shells.so`前加#来注释

### 防火墙设置

基本的防火墙设置命令

```
systemctl start firewalld #开启防火墙

systemctl stop firewalld #关闭防火墙

systemctl restart firewalld #重启防火墙

systemctl disable firewalld #禁用

systemctl enable firewalld  #启用
```

开放防火墙端口

```
firewall-cmd --permanent --zone=public --add-port=21/tcp  #开放一个具体的端口

firewall-cmd --permanent --zone=public --add-port=10000-11000/tcp #开放一个端口范围
```

查看已经开放的防火墙的端口

```
firewall-cmd --permanent --zone=public --list-ports

```

**注意在配置了ftp的配置文件和防火墙配置后需要重启ftp的服务和防火墙来使配置生效**

> 参考：<https://www.cnblogs.com/xiaohh/p/4789813.html>
>
> <https://www.jianshu.com/p/b66066a70cd4>