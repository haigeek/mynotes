### 通过frp进行端口转发

为了解决wsl2不支持固定ip的问题，通过frp完成与宿主机的端口转发，实现思路如下：

1、在wsl里运行客户端，配置文件如下：

```
[common]
server_addr = 192.168.1.184 #Windows机器的ip
server_port = 7000

[8080]
type = tcp
local_ip = 127.0.0.1
local_port = 8080 #wsl里运行的jenkins的端口
remote_port = 8889 # Windows主机的端口
```

2、在Windows上安装服务端，使用默认的配置文件

这里建议在Windows上将frps以服务模式启动，可以使用winsw 完成，参考此[文章](http://note.eta.pub/2020/07/21/frp-windows-service/)的做法

### WSL下以服务模式运行frp

wsl2不支持systemctl命令，输入systemctl提示

```
System has not been booted with systemd as init system (PID 1)
Failed to connect to bus: Host is down
```

因此自定义了service

1、新建脚本文件

```
vim /etc/init.d/frpc
```

2、写入服务脚本，注意修改程序执行路径、配置文件路径以及日志存储路径，[服务脚本在这里](https://gist.github.com/haigeek/0a62cbd2cd23cad81d8be07a5427c1f0)

3、设置脚本为可执行文件

```
chmod +x /etc/init.d/frpc
```

4、验证服务是否可用

```
service frpc start
```

在启动成功后会在安装目录下生成一个frpc.log文件来存储日志

## 开机自启

`WSL`的是一个基于`Windows`系统的`Hyper V`服务运行的`Linux`系统，但没有对应的开机自检程序，因此在`WSL`中设置服务开机启动是没有用的。因此通过在Windows执行命令完成wsl系统的服务启动

首先在wsl里写入启动脚本

```
vim /etc/init.wsl
# 写入内容如下

#!/bin/sh
service ssh start
service jenkins start
service frpc start
```

在Windows外部新建一个bat文件，写入

```
REM 通过调用wsl写好的启动脚本完成任务启动
wsl -d Ubuntu-20.04 -u root -e /etc/init.wsl
pause
```

建议先在cmd测试下命令执行是否正确，`Ubuntu-20.04`需要改为自己的wsl系统名称
