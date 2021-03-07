# Windows下安装openssh实现ssh连接

## 下载

使用微软开源的openssh

下载地址: https://github.com/PowerShell/openssh-portable

## 安装

按照官网的说明安装openssh即可,官网说明:https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH

1、cd到安装目录,执行下面的命令

**注意:openssh文件夹需要在C:\Program Files下**

```
powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1
```

安装成功界面

![image-20190704220157343](images/image-20190704220157343.png)

2、开放防火墙端口,可以在winsows控制面板开启,也可以使用命令开启,默认端口为22

winsowsServer2012指令:

```
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

Windows10或者WindowsServer2008

```
netsh advfirewall firewall add rule name=sshd dir=in action=allow protocol=TCP localport=22
```

3、启动服务

```
net start sshd
```

4、设置开机自启动

```
Set-Service sshd -StartupType Automatic
```

5、使用用户名密码进行连接

![image-20190704220318958](images/image-20190704220318958.png)

## 配置密钥免登录

1、进入c盘下的user目录,找到当前用户的目录,一般是administrator

```
mkdir .ssh
```

进入到ssh目录下

```
# 新建一个txt文件,将服务器公钥粘贴进去
notepad authorized_keys
# 重命名
mv authorized_keys.txt authorized_keys
```

2、修改ssh 服务的配置文件

打开C:\ProgramData\ssh\sshd_config

注释掉配置文件中的最后两行然后保存：

```
#Match Group administrators
#       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
```

3、打开服务

在服务管理器器中重启 OpenSSH SSH Server 服务，然后客户端就可以通过公钥认证的方式登录到远程服务器了。

4、免密登录



![image-20190704222509633](images/image-20190704222509633.png)