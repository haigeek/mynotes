# Linux常用命令（网络、磁盘）

## 网络命令

### ifconfig

许多windows非常熟悉ipconfig命令行工具，它被用来获取网络接口配置信息并对此进行修改。Linux系统拥有一个类似的工具，也就是ifconfig(interfaces config)。通常需要以root身份登录或使用sudo以便在Linux机器上使用ifconfig工具。依赖于ifconfig命令中使用一些选项属性，ifconfig工具不仅可以被用来简单地获取网络接口配置信息，还可以修改这些配置。

1．**命令格式**：

ifconfig [网络设备] [参数]

2．**命令功能**：

ifconfig 命令用来查看和配置网络设备。当网络环境发生改变时可通过此命令对网络进行相应的配置。

3．**命令参数：**

up 启动指定网络设备/网卡。

down 关闭指定网络设备/网卡。该参数可以有效地阻止通过指定接口的IP信息流，如果想永久地关闭一个接口，我们还需要从核心路由表中将该接口的路由信息全部删除。

arp 设置指定网卡是否支持ARP协议。

-promisc 设置是否支持网卡的promiscuous模式，如果选择此参数，网卡将接收网络中发给它所有的数据包

-allmulti 设置是否支持多播模式，如果选择此参数，网卡将接收网络中所有的多播数据包

-a 显示全部接口信息

-s 显示摘要信息（类似于 netstat -i）

add 给指定网卡配置IPv6地址

del 删除指定网卡的IPv6地址

<硬件地址> 配置网卡最大的传输单元

mtu<字节数> 设置网卡的最大传输单元 (bytes)

netmask<子网掩码> 设置网卡的子网掩码。掩码可以是有前缀0x的32位十六进制数，也可以是用点分开的4个十进制数。如果不打算将网络分成子网，可以不管这一选项；如果要使用子网，那么请记住，网络中每一个系统必须有相同子网掩码。

tunel 建立隧道

dstaddr 设定一个远端地址，建立点对点通信

-broadcast<地址> 为指定网卡设置广播协议

-pointtopoint<地址> 为网卡设置点对点通讯协议

multicast 为网卡设置组播标志

address 为网卡设置IPv4地址

txqueuelen<长度> 为网卡设置传输列队的长度

4. 示例

```
ifconfig
```

显示网络设备信息

eth0 表示第一块网卡

lo 是表示主机的回坏地址，这个一般是用来测试一个网络程序，但又不想让局域网或外网的用户能够查看，只能在此台主机上运行和查看所用的网络接口。比如把 HTTPD服务器的指定到回坏地址，在浏览器输入 127.0.0.1 就能看到你所架WEB网站了。但只是您能看得到，局域网的其它主机或用户无从知道。

up代表网卡的开启状态，RUNNING（代表网卡的网线被接上）MULTICAST（支持组播）MTU:1500（最大传输单元）：1500字节

inet 代表网卡的ip地址

ether 代表网卡的mac地址

netmask 代表子网掩码

broadcast 代表网卡的广播地址

RX：接收数据包情况统计

TX：接收数据包情况统计

```
ifconfig eth0 up

ifconfig eth0 down
```

启动/关闭 指定的网卡

```
ifconfig eth0 ether 00:AA:BB:CC:DD:EE
```

修改网卡的mac地址

```
ifconfig eth0 192.168.120.56 
```

给eth0网卡配置IP地：192.168.120.56

```
ifconfig eth0 192.168.120.56 netmask 255.255.255.0 broadcast 192.168.120.255
```

给eth0网卡配置IP地址：192.168.120.56，加上子掩码：255.255.255.0，加上个广播地址： 192.168.120.255

```
ifconfig eth0 mtu 1500
```

设置最大传输单元

### ping

linux下的ping与windows下的ping最大的区别是linux下的不会自动停止，可以使用ctrl+c结束

-c 数目：在发送指定数目的包后停止。

### telnet

telnet命令通常用来远程登录。telnet程序是基于TELNET协议的远程登录客户端程序。Telnet协议是TCP/IP协议族中的一员，是Internet远程登陆服务的标准协议和主要方式。telnet命令还可做别的用途，比如确定远程服务的状态，比如确定远程服务器的某个端口是否能访问。

1．**命令格式**：

telnet [参数] [主机]

2．**命令功能**：

执行telnet指令开启终端机阶段作业，并登入远端主机。

3. **示例**

telnet 192.168.120.206

假如远程主机无法访问处理这种情况方法：

（1）确认ip地址是否正确？

（2）确认ip地址对应的主机是否已经开机？

（3）如果主机已经启动，确认路由设置是否设置正确？（使用route命令查看）

（4）如果主机已经启动，确认主机上是否开启了telnet服务？（使用netstat命令查看，TCP的23端口是否有LISTEN状态的行）

（5）如果主机已经启动telnet服务，确认防火墙是否放开了23端口的访问？（使用iptables-save查看）

### netstat

netstat命令用于显示与IP、TCP、UDP和ICMP协议相关的统计数据，一般用于检验本机各端口的网络连接情况。

1．**命令格式**：

ifconfig [网络设备] [参数]

2．**命令功能**：

ifconfig 命令用来查看和配置网络设备。当网络环境发生改变时可通过此命令对网络进行相应的配置。

3．**命令参数：**

4. 示例

netstat -a 

列出所有端口

netstat -i

显示网卡列表

netstat -l

显示监听的套接口

netstat -at

显示所有的tcp端口

netstat -an | grep ssh

找出程序运行的端口

netstat -anpt | grep ':16064'

找出使用端口的程序并显示pid

### route

Linux系统的route命令用于显示和操作IP路由表（show / manipulate the IP routing table）。要实现两个不同的子网之间的通信，需要一台连接两个网络的路由器，或者同时位于两个网络的网关来实现。在Linux系统中，设置路由通常是为了解决以下问题：该Linux系统在一个局域网中，局域网中有一个网关，能够让机器访问Internet，那么就需要将这台机器的IP地址设置为Linux机器的默认路由。要注意的是，直接在命令行下执行route命令来添加路由，不会永久保存，当网卡重启或者机器重启之后，该路由就失效了；可以在/etc/rc.local中添加route命令来保证该路由设置永久有效。

### traceroute

### ss

### rcp

### scp

## 防火墙设置

centos7默认的使用firewalld防火墙

### 基本使用

检查防火墙状态：systemctl status firewalld

启动：systemctl start firewalld

关闭：systemctl stop firewalld

禁用：systemctl disable firewalld

启用：systemctl enable firewalld

### firewalld-cmd

查看版本： firewall-cmd --version

查看帮助： firewall-cmd --help

显示状态： firewall-cmd --state

查看所有打开的端口： firewall-cmd --permanent --zone=public --list-ports

更新防火墙规则： firewall-cmd --reload

查看区域信息:  firewall-cmd --get-active-zones

查看指定接口所属区域： firewall-cmd --get-zone-of-interface=eth0

拒绝所有包：firewall-cmd --panic-on

取消拒绝状态： firewall-cmd --panic-off

查看是否拒绝： firewall-cmd --query-panic



增加端口：

```
firewall-cmd --zone=public --add-port=30300/tcp --permanent
```



## 磁盘存储相关

df

du

workspace代表路径

```
du -h --max-depth=1 workspace/
```

