安装

```
$ yum install crontabs
$ systemctl enable crond
$ systemctl start crond
```

配置定时规则

```
vim /etc/crontab
```

保存定时规则

```
crontab /etc/crontab
```

查看任务

```
crontab -l
```

