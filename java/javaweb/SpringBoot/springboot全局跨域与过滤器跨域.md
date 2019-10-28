# springboot全局跨域与过滤器跨域

## 跨域请求

浏览器具有同源限制，即完全一致的意思是，域名要相同（`www.example.com`和`example.com`不同），协议要相同（`http`和`https`不同），端口号要相同（默认是`:80`端口，它和`:8080`就不同）

## 使用CROS处理跨域

Origin表示本域，也就是浏览器当前页面的域。当JavaScript向外域（如sina.com）发起请求后，浏览器收到响应后，首先检查`Access-Control-Allow-Origin`是否包含本域，如果是，则此次跨域请求成功，如果不是，则请求失败，JavaScript将无法获取到响应的任何数据。

跨域能否成功，取决于对方服务器是否愿意给你设置一个正确的`Access-Control-Allow-Origin`，决定权始终在对方手中。

##### 简单跨域请求

上面这种跨域请求，称之为“简单请求”。简单请求包括GET、HEAD和POST（POST的Content-Type类型
仅限`application/x-www-form-urlencoded`、`multipart/form-data`和`text/plain`），并且不能出现任何自定义头（例如，`X-Custom: 12345`），通常能满足90%的需求。

##### 其他类型的请求

对于PUT、DELETE以及其他类型如`application/json`的POST请求，在发送AJAX请求之前，浏览器会先发送一个`OPTIONS`请求（称为preflighted请求）到这个URL上，询问目标服务器是否接受：

```
OPTIONS /path/to/resource HTTP/1.1
Host: bar.com
Origin: http://my.com
Access-Control-Request-Method: POST
```

服务器必须响应并明确指出允许的Method：

```
HTTP/1.1 200 OK
Access-Control-Allow-Origin: http://my.com
Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS
Access-Control-Max-Age: 86400
Access-Control-Allow-Credentials: true | false // 是否允许携带 Cookie
```

**带cookie的跨域请求**

`Access-Control-Allow-Credentials` 响应头会使浏览器允许在 Ajax 访问时携带 Cookie，但我们仍然需要对 XMLHttpRequest 设置其 `withCredentials` 参数，才能实现携带 Cookie 的目标。

为了安全，标准里不允许 `Access-Control-Allow-Origin: *`，必须指定明确的、与请求网页一致的域名。同时，Cookie 依然遵循“同源策略”，只有用目标服务器域名设置的 Cookie 才会上传，而且使用 `document.cookie` 也无法读取目标服务器域名下的 Cookie。

## Springboot设置跨域

可以在服务端设置允许跨域访问，设置如下：

```java
@Configuration
public class CorsConfig {
    @Bean
    public CorsFilter corsFilter() {
        //1.添加CORS配置信息
        CorsConfiguration config = new CorsConfiguration();
        //放行哪些原始域
        config.addAllowedOrigin("*");
        //是否发送Cookie信息
        config.setAllowCredentials(true);
        //放行哪些原始域(请求方式)
        config.addAllowedMethod("*");
        //放行哪些原始域(头部信息)
        config.addAllowedHeader("*");

        //2.添加映射路径
        UrlBasedCorsConfigurationSource configSource = new UrlBasedCorsConfigurationSource();
        configSource.registerCorsConfiguration("/**", config);

        //3.返回新的CorsFilter.
        return new CorsFilter(configSource);
    }
}
```

在实际的实践中发现，上述处理方式可以解决大多数情况下的跨域问题，但是当客户端的请求带有cookies时，我们就不能使用简单的通配符*来处理跨域问题，会发现上述的springboot跨域设置失效，针对这个问题，可以使用过滤器将请求的url进行拦截，重新设置响应头，就可以完成带cookie请求跨域的处理。

## 拦截器处理跨域问题

用filter拦截每次请求，如果携带身份信息(Credential)时，获取到具体的域响应给请求。

```java
public void doFilter(ServletRequest servletRequest,
                         ServletResponse servletResponse,
                         FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        //根据请求头设置响应头
        String allowOrigin = request.getHeader("Origin");
        String allowHeader = request.getHeader("Access-Control-Request-Headers");
        response.setHeader("Access-Control-Allow-Origin", allowOrigin);
        //设置允许带cookie的请求
        response.setHeader("Access-Control-Allow-Credentials", "true");
        response.setHeader("Access-Control-Allow-Methods", "OPTIONS, POST, PUT, GET, OPTIONS, DELETE");
        response.setHeader("Access-Control-Allow-Headers", allowHeader);
        filterChain.doFilter(servletRequest, servletResponse);
        }
    }

```

在实际的项目中，全局的跨域设置处理与拦截器可以同时设置，针对带有cookie的请求，我们可以设置拦截器来进行处理，就可以很好的处理跨域问题。



> 参考自：https://blog.csdn.net/u014029255/article/details/56842509