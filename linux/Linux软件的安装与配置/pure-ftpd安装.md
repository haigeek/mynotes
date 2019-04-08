# Pureftpd安装
## 安装
使用命令
yum  -y install epel-release && yum -y install pure-ftpd
## 生产配置文件
/usr/sbin/pure-config.pl /etc/pure-ftpd/pure-ftpd.conf
## 权限与用户
```
groupadd ftpgroup        //新建系统组
useradd -g ftpgroup -d /data/ftp  -s /sbin/nologin ftpuser //新建一个FTP用户，不创建用户目录，假定已经存在一个FTP root作为FTP的根目录。
chown ftpuser.ftpgroup /data/ftp/ -R
pure-pw useradd haigeek –u ftpuser –d /data/ftp –m //命令格式很好懂，pure-pw 命令使用useradd 需要添加的用户名， -u标明虚拟用户并且与系统用户权限关联，-d指定了系统用户Home目录中的子目录，且被限制在这个子目录里面（此处是否被限制与上文的conf文件设定相关）如果需要访问系统用户的HOME Directory，则直接使用参数 -D，-m则写入用户数据库，用户设置即时生效，无需重启进程。
pure-config.pl etc/pure-ftpd/pure-ftpd.conf &//后台启动进程。

```
groupadd -g 1000 ftpgroup
useradd -g 1000 -u 1000 -d /data/ftp/ -s /sbin/nologin ftpuser

chown ftpuser.ftpgroup /data/ftp/ -R
重启
/etc/init.d/pure-ftpd restart



/usr/local/pure-ftpd/sbin/pure-ftpd /usr/local/pure-ftpd/etc/pure-ftpd.conf