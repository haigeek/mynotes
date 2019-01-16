# Nginx代理配置
参考：[https://my.oschina.net/u/2288423/blog/703018](https://my.oschina.net/u/2288423/blog/703018)

[https://juejin.im/entry/58354604d20309005fe2c419](https://juejin.im/entry/58354604d20309005fe2c419)

[https://juejin.im/entry/59966124f265da249600b026](https://juejin.im/entry/59966124f265da249600b026)

## 概述
Nginx使用Block(如 `server block`, `location block`)来组成配置文件的层级结构，并在接收到客户端请求之后根据请求的域名(domain name)，端口(port)，IP地址判断处理该请求的`server block`，然后根据请求的资源和URI决定处理该请求的`location block`
## 使用Nginx进行web服务器的配置
### 虚拟主机和请求的分发
1、域名和端口的配置
```plain
# IP地址和端口
listen 127.0.0.1:8000;
listen localhost:8000;
# 仅端口 监听所有接口为这个port的请求
listen *:8000;
```
2、 主机名配置
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
3、`location block`是`server block`的一部分，决定了如何处理请求的URI
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
* 匹配顺序
Nginx优先选择正则表达式进行匹配，但是使用`=`和`^~（非正则匹配）`这两个`modifier`可以覆盖这一特性。排序对匹配过程也有一定的影响，因为Nginx在匹配到最长最精确的location之后就会停止匹配。

1. 将所有非正则表达式的`location_match`与请求的URI进行对比。
2. 与`modifier`为`=`的进行完整匹配。
3. 选择最长`location_match`前缀进行匹配，如果`modifier`为`^~`则匹配成功。
4. 进行正则表达式匹配
5. 用其他前缀匹配
4、其他指令
1. index
    语法：`index file ...;` 默认为`index index.html;`
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
    对`/page`的请求将会首先进入第一个location, 然后尝试在`/var/www/main` 下依次查找`page`, `page.html`, `page/`，如果都没有找到的话将会被重定向到`/fallback/index.html`，并由第二个location提供`/var/www/another/fallback/index.html`
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
## 使用Nginx进行反向代理服务器的配置
反向代理（reserve proxy）方式是指用代理服务器来接受 Internet 上的连接请求，然后将请求转发给内部网络中的上游服务器，并将上游服务器上得到的结果返回给 Internet 上请求连接的客户端，此时代理服务器对外的表现就是一个 Web 服务器。
Nginx 具备超强的高并发高负载能力，一般会作为前端的服务器直接向客户端提供静态文件服务；而业务一般还包含一些业务逻辑需要 Apache、Tomcat 等服务器来处理，故通常 Nginx 对外表现即为静态 Web 服务器也是反向代理服务器。
缺点是增加了一次请求的处理时间，优点是降低了上游服务器的负载，尽量将压力放在 Nginx 服务器上。
### 1、负载均衡配置
upstream，定义一个上游服务器集群，关于负载均衡的权重，有一系统的相关设置。

```plain
upstream backend {
# ip_hash;
server s1.barretlee.com;
server s2.barretlee.com;
}
server {
location / {
proxy_pass http://backend;
}
}
```

### 2、反向代理
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

## nginx代理实战
### 场景
在一个网络中，应用服务器所在的网络与用户所在的网络是隔绝的，唯一的联系是用户组可以访问服务器组的某一台服务器的80端口，需要我们只使用这个80端口来完成整个系统的访问。
### 分析
我们可以使用nginx的反向代理代理我们服务器的地址，通过设置location，进行url的匹配，这样就可以达到访问我们系统的目的。但是整个系统是复杂的，当我们的系统返回来一个ip地址（不同于可访问那台主机的ip和端口）的时候，浏览器是直接请求这个ip地址的，这时候是无法直接访问的，访问被拒绝。
整个请求的流程如下
<div id="lbdqct" data-type="puml" data-display="block" data-align="left" data-src="https://cdn.nlark.com/__puml/3c2538b0272e75087395166c6e11c55e.svg" data-width="628" data-height="601" data-text="%40startuml%0A%0A%7C%E6%B5%8F%E8%A7%88%E5%99%A8%7C%0Astart%0A%3A%E5%8F%91%E8%B5%B7%E8%AF%B7%E6%B1%82%3B%0A%7C%23AntiqueWhite%7Cnginx%EF%BC%88%E9%85%8D%E7%BD%AE%E5%9C%A8%E5%8F%AF%E8%AE%BF%E9%97%AE%E7%9A%84%E6%9C%8D%E5%8A%A1%E5%99%A8%EF%BC%89%7C%0A%7Cnginx%EF%BC%88%E9%85%8D%E7%BD%AE%E5%9C%A8%E5%8F%AF%E8%AE%BF%E9%97%AE%E7%9A%84%E6%9C%8D%E5%8A%A1%E5%99%A8%EF%BC%89%7C%0A%3A%E6%8E%A5%E6%94%B6%E8%AF%B7%E6%B1%82%3B%0A%3A%E8%AF%B7%E6%B1%82url%E7%AC%A6%E5%90%88%EF%BC%8C%E8%BF%9B%E8%A1%8C%E4%BB%A3%E7%90%86%3B%0A%7C%E5%BA%94%E7%94%A8%E6%9C%8D%E5%8A%A1%E5%99%A8%7C%0A%3A%E6%8E%A5%E6%94%B6nginx%E8%BD%AC%E5%8F%91%E8%BF%87%E6%9D%A5%E7%9A%84%E8%AF%B7%E6%B1%82%3B%0A%3A%E6%9C%8D%E5%8A%A1%E5%99%A8%E8%BF%9B%E8%A1%8C%E5%A4%84%E7%90%86%E5%B9%B6%E8%BF%94%E5%9B%9E%3B%0A%7Cnginx%EF%BC%88%E9%85%8D%E7%BD%AE%E5%9C%A8%E5%8F%AF%E8%AE%BF%E9%97%AE%E7%9A%84%E6%9C%8D%E5%8A%A1%E5%99%A8%EF%BC%89%7C%0A%3A%E6%8E%A5%E6%94%B6%E6%9D%A5%E8%87%AA%E5%BA%94%E7%94%A8%E6%9C%8D%E5%8A%A1%E5%99%A8%E7%9A%84%E5%93%8D%E5%BA%94%3B%0A%7C%E6%B5%8F%E8%A7%88%E5%99%A8%7C%0A%3A%E6%8E%A5%E6%94%B6nginx%E8%BF%94%E5%9B%9E%E7%9A%84%E5%93%8D%E5%BA%94%3B%0Astop%0A%0A%40enduml"><img src="https://cdn.nlark.com/__puml/3c2538b0272e75087395166c6e11c55e.svg" width="628"/></div>

那么问题就在于在最后一步nginx接收的响应中的信息包含没有被反向代理的ip地址。
### 处理方法
nginx的代理只能代理本台服务器的不同端口，以及不同的域名。但是并不能代理不同的服务器，当然这个逻辑本来就很荒谬。
那么怎么才可以解决这个问题呢，我们无法从nginx端下手，那就要考虑从应用端进行处理。
我们的应用端会返回不能访问的ip和地址，那么我么可以让服务器给我们返回可以访问的那个地址的ip和端口，也就是返回代理主机的ip，那么装有nginx的主机就可以接受请求，这时候，我们只需要在nginx的配置文件里面将这些请求代理到其正常应该访问的主机和端口即可以实现这个功能。



