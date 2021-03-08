# Nginx初识

## Nginx是什么
<span data-type="color" style="color:rgb(33, 37, 41)"><span data-type="background" style="background-color:rgb(255, 255, 255)">Nginx 是一个免费的，开源的，高性能的HTTP服务器和反向代理，以及IMAP / POP3代理服务器。 Nginx 以其高性能，稳定性，丰富的功能，简单的配置和低资源消耗而闻名。</span></span>
Nginx的整体架构如下：


![image.png | left | 827x514](https://cdn.nlark.com/yuque/0/2019/png/84598/1550064535770-194eeb7e-1a15-42dd-ba16-9f3e15ba8ee5.png "")


nginx在启动后，会以daemon的方式在后台运行，后台进程包含一个master进程和多个worker进程。工作进程以非特权用户运行。master进程主要用来管理worker进程，包含：接收来自外界的信号，向各worker进程发送信号，监控worker进程的运行状态，当worker进程退出后(异常情况下)，会自动重新启动新的worker进程。worker进程则是处理基本的网络事件。多个worker进程之间是对等的，他们同等竞争来自客户端的请求，各进程互相之间是独立的。一个请求，只可能在一个worker进程中处理，一个worker进程，不可能处理其它进程的请求。

<span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">nginx包含3类模块：核心模块，基础模块，第三方模块</span></span>
- <span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">ht_core核心模块</span></span>
- <span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">ht_upstream 基础模块</span></span>
- <span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">ht_proxy 基础模块</span></span>
- <span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">ht_fastcgi 基础模块</span></span>
  <span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">还可以添加一些第三方模块，例如memcache客户端和后端的memcached通信。</span></span>

<span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">nginx使用事件驱动模式来处理请求，异步I/O，非阻塞，事件模式是epoll/select等，非常高效，内存使用mmap、aio，高级io  sendfile。</span></span>

Nginx的高并发，官方测试支持5万并发连接。实际生产环境能到2-3万并发连接数。10000个非活跃的HTTP keep-alive 连接仅占用约2.5MB内存。三万并发连接下，10个Nginx进程，消耗内存150M。淘宝tengine团队说测试结果是“24G内存机器上，处理并发请求可达200万”。

## 安装
### windows安装
下载地址：[http://nginx.org/en/download.html](http://nginx.org/en/download.html) 
选择windows版本下载后解压
### Linux安装与相关操作
1. 相关库的安装

```
yum update -y  
yum install -y gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel  
```

* PCRE pcre-devel
    PCRE(Perl Compatible Regular Expressions) 是一个Perl库，包括 perl 兼容的正则表达式库。nginx 的 http 模块使用 pcre 来解析正则表达式，所以需要在 linux 上安装 pcre 库，pcre-devel 是使用 pcre 开发的一个二次开发库。nginx也需要此库。
* zlib
    zlib 库提供了很多种压缩和解压缩的方式， nginx 使用 zlib 对 http 包的内容进行 gzip ，所以需要在 Centos 上安装 zlib 库。
* OpenSSL
    OpenSSL 是一个强大的安全套接字层密码库，囊括主要的密码算法、常用的密钥和证书封装管理功能及 SSL 协议，并提供丰富的应用程序供测试或其它目的使用。
    nginx 不仅支持 http 协议，还支持 https（即在ssl协议上传输http），所以需要在 Centos 安装 OpenSSL 库。
2. 下载源码

```
wget http://nginx.org/download/nginx-1.8.1.tar.gz 
```
3. 编译安装

```
tar -zxvf nginx-1.8.1.tar.gz  
cd nginx-1.8.1/   
./configure  
make   
make install  
```
4. 配置反向代理

```
cd /usr/local/nginx/conf   
vi nginx.conf  
```
5. nginx相关操作

```
cd /usr/local/nginx/sbin  
./nginx #启动  
./nginx -s stop #停止
./nginx -s reload #更新配置文件
```

## 正向代理和反向代理
### 正向代理
1. <span data-type="color" style="color:rgb(26, 26, 26)"><span data-type="background" style="background-color:rgb(255, 255, 255)">用户希望代理服务器帮助自己，和要访问服务器通信，那么需要以下信息</span></span>
  <span data-type="color" style="color:rgb(26, 26, 26)"><span data-type="background" style="background-color:rgb(255, 255, 255)">a) 用户IP报文的目的IP = 代理服务器IP</span></span>
  <span data-type="color" style="color:rgb(26, 26, 26)"><span data-type="background" style="background-color:rgb(255, 255, 255)">b) 用户报文端口号 = 代理服务器监听端口号</span></span>
  <span data-type="color" style="color:rgb(26, 26, 26)"><span data-type="background" style="background-color:rgb(255, 255, 255)">c) HTTP 消息里的URL要提供服务器的链接</span></span>
2. 代理服务器根据c中提供的链接直接与服务器进行通信
3. 服务器返回网页
4. 代理服务器将返回的网页返回给用户
  <span data-type="color" style="color:rgb(35, 57, 77)"><span data-type="background" style="background-color:rgb(255, 255, 255)">正向代理类似一个跳板机，把浏览器访问过程委托给代理去做，代理访问外部资源。</span></span>


![image.png | left | 747x149](https://cdn.nlark.com/yuque/0/2019/png/84598/1549979030433-d90ea45b-596e-4684-be81-16aa618b081d.png "")

<span data-type="color" style="color:rgb(35, 57, 77)"><span data-type="background" style="background-color:rgb(255, 255, 255)">举个例子：</span></span>
<span data-type="color" style="color:rgb(35, 57, 77)"><span data-type="background" style="background-color:rgb(255, 255, 255)">我是一个用户，我访问不了某网站，但是我能访问一个代理服务器，这个代理服务器能访问那个我不能访问的网站，于是我先连上代理服务器,告诉他我需要那个无法访问网站的内容，代理服务器去取回来,然后返回给我。从目标网站的角度，只在代理服务器来取内容的时候有一次记录，有时候并不知道是用户的请求，也隐藏了用户的资料，这取决于代理告不告诉网站。</span></span>
<span data-type="color" style="color:rgb(35, 57, 77)"><span data-type="background" style="background-color:rgb(255, 255, 255)">类似场景比如我们在外网去访问公司内网服务器B，我们先设置VPN，通过VPN将我们的请求转发到内网的A服务器，然后A把请求发到B上，响应内容返回到A，再由A通过VPN返回到我们。</span></span>
<span data-type="color" style="color:rgb(35, 57, 77)"><span data-type="background" style="background-color:rgb(255, 255, 255)">工作流程可以描述为：</span></span>
<span data-type="color" style="color:rgb(35, 57, 77)"><span data-type="background" style="background-color:rgb(255, 255, 255)">用户设置代理服务器，用户访问url，代理服务器代替用户访问并将网页内容返回。</span></span>

### 反向代理
<span data-type="color" style="color:rgb(26, 26, 26)"><span data-type="background" style="background-color:rgb(255, 255, 255)">在计算机世界里，由于单个服务器的处理客户端（用户）请求能力有一个极限，当用户的接入请求蜂拥而入时，会造成服务器忙不过来的局面，可以使用多个服务器来共同分担成千上万的用户请求，这些服务器提供相同的服务。实现反向代理，需要满足以下条件：</span></span>
1. 需要有一个负载均衡设备来分发用户请求，将用户请求分发到空闲的服务器上
2. 服务器返回自己的服务到负载均衡设备
3. 负载均衡将服务器的服务返回用户
  <span data-type="color" style="color:rgb(26, 26, 26)"><span data-type="background" style="background-color:rgb(255, 255, 255)">用户和负载均衡设备直接通信，</span></span>__也意味着用户做服务器域名解析时，解析得到的IP其实是负载均衡的IP，而不是服务器的IP__<span data-type="color" style="color:rgb(26, 26, 26)"><span data-type="background" style="background-color:rgb(255, 255, 255)">，这样有一个好处是，当新加入/移走服务器时，仅仅需要修改负载均衡的服务器列表，而不会影响现有的服务。</span></span>

__反向代理（Reverse Proxy）__<span data-type="color" style="color:rgb(35, 57, 77)"><span data-type="background" style="background-color:rgb(255, 255, 255)">方式是指后台内部网络服务器委托代理服务器，以代理服务器来接受Internet上的连接请求，然后将请求转发给内部网络上的服务器；并将从服务器上得到的结果返回给Internet上请求连接的客户端，此时代理服务器对外就表现为一个服务器。</span></span>
<span data-type="color" style="color:rgb(35, 57, 77)"><span data-type="background" style="background-color:rgb(255, 255, 255)">用户访问的是代理服务器，前端是不知道后台真实地址，只知道代理地址。</span></span>


![image.png | left | 747x212](https://cdn.nlark.com/yuque/0/2019/png/84598/1549979095220-8d825b38-b379-4b0d-85f2-aea8d6cea8e1.png "")

<span data-type="color" style="color:rgb(35, 57, 77)"><span data-type="background" style="background-color:rgb(255, 255, 255)">再举个栗子：</span></span>
<span data-type="color" style="color:rgb(35, 57, 77)"><span data-type="background" style="background-color:rgb(255, 255, 255)">我是一个用户，我可以访问某一个网站，网站的数据是来源于我访问不到的内部网络上的内容服务器，内容服务器设置了可以访问自己的代理服务器。于是我向目标内容服务器发起请求，其实我访问的是内容服务器设置的代理服务器，这个代理服务器将我的请求转发到目标内容服务器上，获取到数据后再返回给网站上，我就可以看见了。</span></span>


![image.png | left | 650x436](https://cdn.nlark.com/yuque/0/2019/png/84598/1549979127366-63b27c10-3d04-4338-887c-1efcd2bb58ac.png "")

<span data-type="color" style="color:rgb(35, 57, 77)"><span data-type="background" style="background-color:rgb(255, 255, 255)">工作流程可以描述为：</span></span>
<span data-type="color" style="color:rgb(35, 57, 77)"><span data-type="background" style="background-color:rgb(255, 255, 255)">和正向代理相反，由目标内容服务器设置代理服务器，代理转发用户发起的请求，获取数据再返回给用户。</span></span>
简单来说：正向代理代理客户端，反向代理代理服务器。
## Nginx主要配置解析
Nginx使用Block(如 `server block`, `location block`)来组成配置文件的层级结构，并在接收到客户端请求之后根据请求的域名(domain name)，端口(port)，IP地址判断处理该请求的`server block`，然后根据请求的资源和URI决定处理该请求的`location block`
### 虚拟主机和请求的分发
#### 1、域名和端口的配置

```plain
# IP地址和端口
listen 127.0.0.1:8000;
listen localhost:8000;
# 仅端口 监听所有接口为这个port的请求
listen *:8000;
```
#### 2、 主机名配置

```plain
server_name www.barretlee.com barretlee.com
# 选择以*开头的进行匹配，并优先选择最长的。
server_name *.barretlee.com
# 选择以*结尾的进行匹配，并优先选择最长的。
server_name barretlee.com.*
# 以~开头的表示以正则表达式进行匹配， “^” 和 “$” 锚定符对主机名进行界定，域名的分隔符 “.” 在正则表达式中应该以 “\” 引用
server_name ~^\.barret\.com$
```
如果以上规则都无法匹配，则选择`default_server`定义的默认的`server_block`（每个`server_block`只能有一个`default_server`），默认的default\_server是localhost

#### 3、`location block`是`server block`的一部分，决定了如何处理请求的URI

`modifier`是一个可选的参数，决定了如何解析后面的`location match`，modifier可选的值有:

1. (none)
    前缀匹配， 如
    ```
    location /site {
        ...
    }
    ```
    将匹配以`/site`开头的URI
2. =(equal sign)
    完整匹配，如
    ```
    location = /page {
        ...
    }
    ```
    将匹配`/page`,而不会响应`/page/index.html`的请求
3. ~(tilde)
    大小写敏感的正则匹配, 如
    ```
    location ~ \.(jpe?g|png|gif|ico)$ {
    ...
    }
    ```
    将匹配以`.jpg/.jpeg/.png/.gif/.ico`结尾的URI, 但不会响应`.JPG`
4. ~\*(tilde + asterisk)
    大小写无关的正则匹配, 如
    ```
    location ~* \.(jpe?g|png|gif|ico)$ {
        ...
    }
    ```
    `.jpg`和`.JPG`都会匹配
5. ^~(carat + tilde)
    非正则匹配，如
    ```
    location ^~ /page {
        ...
    }
    ```
    能够匹配`/page/index.html`

**匹配顺序**
Nginx优先选择正则表达式进行匹配，但是使用`=`和`^~（非正则匹配）`这两个`modifier`可以覆盖这一特性。排序对匹配过程也有一定的影响，因为Nginx在匹配到最长最精确的location之后就会停止匹配。

1. 将所有非正则表达式的`location_match`与请求的URI进行对比。
2. 与`modifier`为`=`的进行完整匹配。
3. 选择最长`location_match`前缀进行匹配，如果`modifier`为`^~`则匹配成功。
4. 进行正则表达式匹配
5. 用其他前缀匹配

**注意：**
__proxy\_pass的url是否存在 / 的区别__

```
location  /proxy/ {
	proxy_pass http://127.0.0.1/;
}
```

访问：`127.0.0.1/proxy/a.jpg`：则会请求到：[http://127.0.0.1/a.jpg](https://link.juejin.im?target=http%3A%2F%2F127.0.0.1%2Fa.jpg)

```
location  /proxy/ {
	proxy_pass http://127.0.0.1;
}
```

访问：`127.0.0.1/proxy/a.jpg`：则会请求到：[http://127.0.0.1/proxy/a.jpg](https://link.juejin.im?target=http%3A%2F%2F127.0.0.1%2Fproxy%2Fa.jpg)

__“location /xxx/” 与“location ^~ /xxx/”区别__

```
location = / {   #表示匹配访问根目录
	root   html;   #当前安装目录下的html，/html则表示服务器根目录下的html
	index  index.html index.htm;
}
location /svn/ {   #表示匹配ip:port/svn/
	root /data/;
	autoindex on;
}
}
location ^~ /svn/ {   #表示只要含有svn/就会被匹配
	root /data/;
	autoindex on;
}
```

####  4、其他指令

1. index
    语法：`index file ...;` 默认为`index index.html;`
    `index`指令指定了被作为index的文件，比如上面的`index.html`
    但是在下面这种情况下，对`/index.html`的请求将会被第二个`location block`处理，因为第一个与`/index.html`并不是完全匹配。
    ```
    location = / {
        index index.html;
    }
    location / {
        ...
    }
    ```
2. 根目录设置

    ```
    location / {
        root /home/barret/test/;
    }
    ```
3. try\_files
    ```
    root /var/www/main;
    location / {    try_files $uri $uri.html $uri/ /fallback/index.html;
    }
    location /fallback {
        root /var/www/another;
    }
    ```
    对`/page`的请求将会首先进入第一个location, 然后尝试在`/var/www/main` 下依次查找`page`, `page.html`, `page/`，如果都没有找到的话将会被重定向到`/fallback/index.html`，并由第二个location提供`/var/www/another/fallback/index.html`
4. 重定向配置
    重定向页面设置
    ```plain
    error_page    404         /404.html;
    error_page    502  503    /50x.html;
    error_page    404  =200   /1x1.gif;
    location / {
    error_page  404 @fallback;
    }
    location @fallback {
    # 将请求反向代理到上游服务器处理
    proxy_pass http://localhost:9000;
    }
    ```
5. error\_page
    ```
    root /var/www/main;
    location / {    error_page 404 /another/whoops.html;
    }
     
    location /another {
        root /var/www;
    }
    ```
    除了`/another`之外的请求都会在`/var/www/main`查找请求的资源，如果没有找到相关资源将会重定向到`/another/whoops.html`，由第二个`location block`处理，查找`/var/www/another/whoops.html`

### 反向代理配置
proxy\_pass 将请求转发到有处理能力的端上，默认不会转发请求中的 Host 头部

```plain
location /blog {
prox_pass http://localhost:9000;
### 下面都是次要关注项
proxy_set_header Host $host;
proxy_method POST;
# 指定不转发的头部字段
proxy_hide_header Cache-Control;
proxy_hide_header Other-Header;
# 指定转发的头部字段
proxy_pass_header Server-IP;
proxy_pass_header Server-Name;
# 是否转发包体
proxy_pass_request_body on | off;
# 是否转发头部
proxy_pass_request_headers on | off;
# 显形/隐形 URI，上游发生重定向时，Nginx 是否同步更改 uri
proxy_redirect on | off;
}
```