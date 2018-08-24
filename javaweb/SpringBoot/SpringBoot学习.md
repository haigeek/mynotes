# Springboot学习笔记
## hello world
使用Spring Initializr快速构建SpringBoot程序
## 配置文件详解
在resources文件夹下添加不同的配置文件来供我们使用，可以分别添加
- application.properties(默认配置文件)
- application-dev.properties(开发)
- application-pron.properties(生产)
- application-test.properties(测试)
在application.properties选择要激活的配置文件
```xml
# 多环境配置文件激活属性
spring.profiles.active=dev
```
### 使用自定义属性
在配置文件中创建自定义属性，使用 @Value("${属性名}") 注解来加载对应的配置属性，例如
```
com.didispace.blog.name=程序猿DD
com.didispace.blog.title=Spring Boot教程
```
使用
```java
@Component
public class BlogProperties {

    @Value("${com.didispace.blog.name}")
    private String name;
    @Value("${com.didispace.blog.title}")
    private String title;

    // 省略getter和setter

}
```
同时在配置文件中参数也可以互相引用，例如 ${com.didispace.blog.name}
### 使用随机值
```
# 随机字符串
com.didispace.blog.value=${random.value}
# 随机int
com.didispace.blog.number=${random.int}
# 随机long
com.didispace.blog.bignumber=${random.long}
# 10以内的随机数
com.didispace.blog.test1=${random.int(10)}
# 10-20的随机数
com.didispace.blog.test2=${random.int[10,20]}
```
## 引入swagger2
### 引入配置
在pom文件中引入swagger，在Application.java同级创建Swagger2的配置类Swagger2,再通过createRestApi函数创建Docket的Bean之后，apiInfo()用来创建该Api的基本信息（这些基本信息会展现在文档页面中）。select()函数返回一个ApiSelectorBuilder实例用来控制哪些接口暴露给Swagger来展现，本例采用指定扫描的包路径来定义，Swagger会扫描该包下所有Controller定义的API，并产生文档内容（除了被@ApiIgnore指定的请求）。
### 在controller层进行配置
Application.java同级创建Swagger2的配置类Swagger2,通过@ApiOperation注解来给API增加说明、通过@ApiImplicitParams、@ApiImplicitParam注解来给参数增加说明。
## Springboot开发web应用
### 静态资源的访问
Spring Boot默认提供静态资源目录位置需置于classpath下，目录名需符合如下规则：
- /static
- /public
- resource
- /META-INF/resources
### 动态的web界面
Springboot提供模版引擎
- Thymeleaf
- FreeMarker
- Velocity(Springboot 1.5.X不再支持Velocity)
- Groovy
- Mustache
当你使用上述模板引擎中的任何一个，它们默认的模板配置路径为：src/main/resources/templates。当然也可以修改这个路径，具体如何修改，可在后续各模板引擎的配置属性中查询并修改。
## 全局异常的捕获
Spring Boot提供了一个默认的映射：/error，当请求发生错误的时候，会映射到默认的界面。
### 统一异常处理
#### 创建全局异常类
通过使用@ControllerAdvice定义统一的异常处理类，而不是在每个Controller中逐个定义。@ExceptionHandler用来定义函数针对的异常类型，最后将Exception对象和请求URL映射到error.html中
#### 实现error.html展示
实现error.html页面展示：在templates目录下创建error.html，将请求的URL和Exception对象的message输出。注意这里要清楚系统输出的异常数据有那些数据，才能在error.html中建立对于的模版值进行获取。
#### 以json的形式进行展示
本质上，只需在@ExceptionHandler之后加入@ResponseBody，就能让处理函数return的内容转换为JSON格式。
## 数据访问
### 使用JdbcTemplate操作数据库





