# Spring Cloud构建微服务架构：服务注册与发现（Eureka、Consul）

## 什么是微服务架构

简单的说，微服务架构就是将一个完整的应用从数据存储开始垂直拆分成多个不同的服务，每个服务都能独立部署、独立维护、独立扩展，服务与服务间通过诸如RESTfulAPI的方式互相调用。

## 服务治理

由于SpringCloud为服务治理做了一层抽象接口，所以在Spring Cloud应用中可以支持多种不同的服务治理框架，比如：NetflixEureka、Consul、Zookeeper。在SpringCloud服务治理抽象层的作用下，我们可以无缝地切换服务治理实现，并且不影响任何其他的服务注册、服务发现、服务调用等逻辑

### Spring Cloud Eureka

Spring CloudEureka是Spring Cloud Netflix项目下的服务治理模块。而Spring Cloud Netflix项目是SpringCloud的子项目之一，它为Spring Boot应用提供了自配置的NetflixOSS整合。通过一些简单的注解，开发者就可以快速的在应用中配置一下常用模块并构建庞大的分布式系统。它主要提供的模块包括：服务发现（Eureka），断路器（Hystrix），智能路由（Zuul），客户端负载均衡（Ribbon）等。

#### 创建服务注册中心

1. 创建一个基础的Spring Boot工程，命名为eureka-server，并在pom.xml中引入需要的依赖内容：
2. 通过@EnableEurekaServer注解启动一个服务注册中心提供给其他应用进行对话。这一步非常的简单，只需要在一个普通的Spring     Boot应用中添加这个注解就能开启此功能
3. 在默认设置下，该服务注册中心也会将自己作为客户端来尝试注册它自己，所以我们需要禁用它的客户端注册行为，只需要在`application.properties`配置文件中增加如下信息：
4. ​

#### 创建服务提供方

1. 创建一个基本的Spring Boot应用。命名为`eureka-client`，在`pom.xml`中，加入如下配置：
2. 实现/dc请求处理接口，通过DiscoveryClient对象，在日志中打印出服务实例的相关内容。
3. 最后在应用主类中通过加上`@EnableDiscoveryClient`注解，该注解能激活Eureka中的DiscoveryClient实现，这样才能实现Controller中对服务信息的输出。
4. 我们在完成了服务内容的实现之后，再继续对`application.properties`做一些配置工作
5. 通过`spring.application.name`属性，我们可以指定微服务的名称后续在调用的时候只需要使用该名称就可以进行服务的访问。`eureka.client.serviceUrl.defaultZone`属性对应服务注册中心的配置内容，指定服务注册中心的位置。为了在本机上测试区分服务提供方和服务注册中心，使用`server.port`属性设置不同的端口。



