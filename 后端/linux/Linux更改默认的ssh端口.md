# Linux更改默认的ssh端口

## 起因

vps在使用xshell连接的时候发现提示：
![多次失败的尝试登陆.png](http://upload-images.jianshu.io/upload_images/1733731-0d1ca1e9527ec408.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
有多次失败的尝试登陆

## 问题
在互联网上有人尝试使用默认的22端口来进行破解登陆
## 解决（centos7 环境下）
1. 使用命令vi /etc/ssh/sshd_config编辑配置文件，添加新的端口，使得可以使用新的端口访问
```
port 22
port xxxx
```
2. 重启ssh配置使其生效
在centos7中，使用命令
```
/etc/init.d/sshd restart
```
提示无效
于是使用命令
```
systemctl enable sshd.service
systemctl restart sshd.service
```
3. 使用新的端口xxx进行登陆，成功后`vi /etc/ssh/sshd_config`编辑配置删除原来的22端口