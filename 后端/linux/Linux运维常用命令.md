# Linux运维常用命令

## SCP

scp从远程拷贝数据到本地 

**-P 端口 P一定是大写**

```
~ scp -P 22 -r  root@192.168.1.1:/root/oracleData/dist/temp/ ~/Downloads

~ scp -P 22 -r  /Users/haigeek/Downloads/DGPOMS_20190814NEW.DMP root@192.168.1.1:/root/oracleData/dist/temp/ 
```



## SSH

增加密钥免密登录服务器

设置权限

```
sudo chmod 600 key.pem
```

安装密钥

```
ssh-add -K xxx.pem
```



## 端口

```
netstat -tupln |grep 1101
lsof -i|grep 13997
```

## 进程

```
ps -ef|grep tomcat
# 查看进程的详细信息
ll /proc/PID
```

## 查看配置

```
# 查看cpu信息
cat   /proc/cpuinfo
# 查看内存信息
free
```

