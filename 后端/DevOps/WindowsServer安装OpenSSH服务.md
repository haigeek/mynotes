# WindowsServer安装OpenSSH服务

## 下载

下载安装包

下载地址：https://github.com/PowerShell/Win32-OpenSSH/releases

解压到指定位置,推荐解压到C:\Program Files\OpenSSH64

## 安装

> 官方文档:https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH

使用cmd进行安装,cd到安装位置,输入命令

```
powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1
```

## 开启防火墙

打开22端口

## 启动服务

net stat sshd

直接使用命令即可登录,例如

ssh administrator@192.168.1.1

