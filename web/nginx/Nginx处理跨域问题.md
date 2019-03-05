## Nginx处理跨域问题

*Nginx* (engine x) 是一个高性能的[HTTP](https://baike.baidu.com/item/HTTP)和[反向代理](https://baike.baidu.com/item/%E5%8F%8D%E5%90%91%E4%BB%A3%E7%90%86/7793488)服务器，也是一个IMAP/POP3/SMTP服务。
### 跨域举例
假设有两个网站，A网站部署在：[http://localhost:81](http://localhost:81/)81 即本地ip端口81上；B网站部署在：[http://localhost:8](http://localhost:82/)080 即本地ip端口82上。现在A网站的页面想去访问B网站的信息，这时候浏览器是会报错的，因为形成了跨域。
现在我们的运维前端部署在nginx上，当我们访问[http://localhost:81](http://localhost:81/)81/dgpoms的时候，我们可以访问到运维系统的首页，但是当登录的时候，前端需要访问的[http://localhost:8](http://localhost:82/)080/weboms/rest/login这个接口，由于浏览器的同源策略，便出现了跨域的情况。


![](https://ws4.sinaimg.cn/large/006tKfTcly1g078tvruftj31j80u0k6f.jpg)

### 解决方式
#### 方案一、在服务端设置允许跨域
可以在服务端设置允许跨域访问，设置如下：

```java
@Configuration
@ConditionalOnExpression("${dist.cors.allow}")
public class CorsConfig {

    @Value("${dist.cors.mapping}")
    private String mapping;

    @Value("${dist.cors.origin}")
    private String origin;

    @Value("${dist.cors.method}")
    private String method;


    @Bean
    public CorsFilter corsFilter() {
        //1.添加CORS配置信息
        CorsConfiguration config = new CorsConfiguration();
        //放行哪些原始域
        config.addAllowedOrigin(this.origin);
        //是否发送Cookie信息
        config.setAllowCredentials(true);
        //放行哪些原始域(请求方式)
        config.addAllowedMethod(this.method);
        //放行哪些原始域(头部信息)
        config.addAllowedHeader(this.origin);
        //暴露哪些头部信息（因为跨域访问默认不能获取全部头部信息）
        //config.addExposedHeader(HttpHeaders.SERVER);

        //2.添加映射路径
        UrlBasedCorsConfigurationSource configSource = new UrlBasedCorsConfigurationSource();
        configSource.registerCorsConfiguration(this.mapping, config);

        //3.返回新的CorsFilter.
        return new CorsFilter(configSource);
    }
}
```

#### 方案二、使用nginx反向代理处理跨域
使用这种方式，针对现有的运维前端，将接口地址由 [http://localhost:8080/weboms修改为/weboms，](http://localhost:8080/weboms%E4%BF%AE%E6%94%B9%E4%B8%BA/weboms%EF%BC%8C)__修改的目的是为了让nginx去帮我们请求接口地址而不是在浏览器直接请求接口地址__。
nginx的配置文件如下：

```nginx
server {
        listen       8181;
        server_name  localhost;
        charset utf-8;
        
        location / {
            
            #负载均衡配置
            # proxy_pass http://tomcats;
            #静态资源文件服务器
            # root   /Users/haigeek/Downloads;
            root /usr/local/var/www;
            # proxy_pass http://127.0.0.1:8183;
            index  index.html index.htm;
            
        }

        location /weboms {
            proxy_pass http://127.0.0.1:8080;
            # 设置nginx往后台服务器传递客户端的请求头
            # 设置用户真实ip否则获取到的都是nginx服务器的ip
            proxy_set_header X-Real-IP $remote_addr;
            # 设置真实的host
            proxy_set_header Host $http_host;
            proxy_set_header REMOTE-HOST $remote_addr;
            # 设置携带cookie
            # proxy_set_header Cookie $http_cookie;
            # 设置cookie的domain
            # proxy_cookie_domain test.com localhost;
        }

        error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
```

### nginx代理处理跨域原理
我们前面提到跨域是浏览器的同源策略导致的，同源策略它是浏览器针对脚本攻击采取的一种安全策略，并不是 HTTP 协议的一部分。所以服务器端调用 HTTP 接口只是使用了 HTTP 协议，是不会执行 js 脚本的，不需要同源策略，也就不会形成跨域问题。
我们使用代理（同源）服务器发起请求，再由代理（同源）服务器请求内部服务器。

![](https://ws2.sinaimg.cn/large/006tKfTcly1g078tnewc5j30rs0g6mz8.jpg)



