## 使用Nginx作为静态服务器
### 文件服务器
在nginx的配置文件设置以下几个地方便可实现一个简单的文件服务器
```nginx
autoindex on; ##显示索引
autoindex_exact_size on; ##显示大小
autoindex_localtime on;   ##显示时间

server {
        listen       8181;
        server_name  localhost;
        charset utf-8;
        location / {
            #静态资源文件服务器,设置根目录
            root   /Users/haigeek/Downloads;
        }
```
### 前后端分离的静态应用
将前端应用部署在nginx的文件夹下，配置好api的地址，可以将nginx作为前端的服务器运行前端应用
```nginx
server {
        listen       8181;
        server_name  localhost;
        charset utf-8;
        location / {
            #设置根目录
            root /usr/local/var/www;
            #设置应用首页
            index  index.html index.htm;
        }
```
在浏览器输入对于的ip加端口加应用名即可访问