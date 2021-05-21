

下载地址：

支持systemctl程序

创建服务文件

```
vim /etc/systemd/system/frps.service
```

```
[Unit]
Description=frps service
After=network.target syslog.target
Wants=network.target

[Service]
Type=simple
#启动服务的命令（此处写你的frps的实际安装目录）
ExecStart=/usr/local/frp/frp_0.36.2_linux_amd64/frps -c /usr/local/frp/frp_0.36.2_linux_amd64/frps.ini

[Install]
WantedBy=multi-user.target
```

启动

```
systemctl start frps
```

自启动

```
systemctl enable frps
##关闭
systemctl  disable frps

```

