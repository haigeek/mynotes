# Spring-Cloud-Alibaba框架升级

框架官方地址：https://github.com/alibaba/spring-cloud-alibaba

在官网上有比较详细的介绍

## 目前的情况：

- 修改了pom文件的springboot版本
- 小部分代码做了适配（主要是mongo版本需要升级）

- 指标系统未分离

## 升级步骤

### 1、确定从哪个模块开始升级，整体的升级策略

先升级springboot版本，然后从一个完整的项目入手开始进行框架升级。

### 2、制定整体框架图，包括使用的版本号和使用的组件模块

#### 确定版本

springboot、springcloud、 spring-Cloud-alibaba版本关系

http://blog.didispace.com/spring-cloud-alibaba-version/

官网提供的版本说明

![image-20200203233250590](/Users/haigeek/Library/Application Support/typora-user-images/image-20200203233250590.png)

#### 明确组件

官网提供的组件说明

![image-20200203233201491](/Users/haigeek/Library/Application Support/typora-user-images/image-20200203233201491.png)

把组件主要分为以下几类，同时考虑其他版本的spring-cloud使用的组件和springboot-Cloud-alibaba的区别 为何要选用alibaba版本

#### 服务注册与发现

是使用Spring Cloud Feign进行服务间的远程http调用还是继续使用dubbo进行服务间的rpc调用

dubbo集成spring-cloud可以参考官方示例（https://github.com/alibaba/spring-cloud-alibaba/blob/master/spring-cloud-alibaba-examples/spring-cloud-alibaba-dubbo-examples/README_CN.md）

根据服务的调用方式，可以进一步确定注册中心的选择：nacos还是eureka

#### 全局配置中心

Alibaba提供的是nacos作为全局配置中心

#### 服务熔断与限流

sentinel的融合（参考蒋延坤的demo是在消费者模块进行配置即可）

#### 服务网关

为所有的微服务设置路由、过滤器、断言等，需要考虑在引入网关的情况下，原有的web模块的改造

#### 其他微服务组件

根据官方提供按需引入即可

### 3、在确定了整体的架构之后，细化以下几点：

- 现有框架的改动工作量有哪些，假如继续使用dubbo框架，使用rpc进行服务调用，是否还使用一个消费者多个提供者的架构
-  是否需要确定自有base模块，是否需要规范base包的工具类
- 业务模块的分割粒度，例如文件存储与转换、用户认证、sso等 是否需要提取作为单独的服务
- 每一个业务模块的分包规范
- 每个微服务是否可以独立启动，且尽量减少依赖，同时可以满足分布式部署需求（考虑业务模块的启动方式）
- 确定代码规范