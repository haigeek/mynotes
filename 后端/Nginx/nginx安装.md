# nginx安装配置
## 相关库的安装
```
yum update -y  
yum install -y gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel  
```
- PCRE pcre-devel  
  PCRE(Perl Compatible Regular Expressions) 是一个Perl库，包括 perl 兼容的正则表达式库。nginx 的 http 模块使用 pcre 来解析正则表达式，所以需要在 linux 上安装 pcre 库，pcre-devel 是使用 pcre 开发的一个二次开发库。nginx也需要此库。
- zlib  
  zlib 库提供了很多种压缩和解压缩的方式， nginx 使用 zlib 对 http 包的内容进行 gzip ，所以需要在 Centos 上安装 zlib 库。
- OpenSSL  
  OpenSSL 是一个强大的安全套接字层密码库，囊括主要的密码算法、常用的密钥和证书封装管理功能及 SSL 协议，并提供丰富的应用程序供测试或其它目的使用。
  nginx 不仅支持 http 协议，还支持 https（即在ssl协议上传输http），所以需要在 Centos 安装 OpenSSL 库。
## 下载源码安装
```
wget http://nginx.org/download/nginx-1.8.1.tar.gz 
```
## 编译安装
```
tar -zxvf nginx-1.8.1.tar.gz  
cd nginx-1.8.1/   
./configure  
make   
make install  
```
## 配置反向代理
```
cd /usr/local/nginx/conf   
vi nginx.conf  
```
## nginx相关操作
```
cd /usr/local/nginx/sbin  
./nginx #启动  
./nginx -s stop #停止
./nginx -s reload #更新配置文件
```
