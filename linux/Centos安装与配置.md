# Centos安装与配置

## 安装准备

镜像下载：http://mirrors.aliyun.com/centos/7/isos/x86_64/   (阿里云镜像仓库）

虚拟机 ：vm

ssh工具： xshell

## 安装



## 配置

### 在虚拟机配置独立的ip地址

先看一下本机的网关和 ip，例如：

```
ip 是： 192.168.2.126
网关是： 192.168.2.1
```

编辑centos的网卡配置文件

```
vi /etc/sysconfig/network-scripts/ifcfg-eth0
```

在网卡配置文件配置如下内容设置静态ip

```
BOOTPROTO=static # 网卡获取IP的方式(默认为dchp,设置为静态获取。
IPADDR=192.168.2.20 # 除最后部分其他与宿主机的网关一致
GATEWAY=192.168.2.1 # 与宿主机保持一致
NETMASK=255.255.255.0
```

如果要访问外网还要配置 DNS

```
DNS1=192.168.2.1
DNS2=8.8.8.8
```

配置完之后保存重启网络

```
service network restart
```

之后就可以通过ssh连接

```
ssh root@192.168.2.20
```

### 通过yum安装一些基本的文件

net-tools 提供dig, nslookup, ipconfig等，用于配置网络：

```
yum install net-tools
```

### 禁止root用户使用ssh登录（生产环境）

进入配置文件：

```
/etc/ssh/sshd_config
```

找到如下语句进行修改

 ```
 PermitRootLogin yes
 ```

把它改成

 ```
 PermitRootLogin no
 ```

重启 sshd

```
systemctl restart sshd.service
```

