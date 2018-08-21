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

