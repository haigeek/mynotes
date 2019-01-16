# nginx静态资源配置

## 使用nginx做简单的文件服务器

在nginx的配置文件设置以下几个地方

```
autoindex on; ##显示索引
autoindex_exact_size on; ##显示大小
autoindex_localtime on;   ##显示时间


server {
        listen       8181;
        server_name  localhost;

        charset utf-8;#避免乱码问题

        location / {
            root   /Users/haigeek/Downloads; #设置根目录
            index  index.html index.htm;
        }
```

即可完成简单的文件服务器