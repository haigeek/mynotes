
# devops
## 系统开发阶段

### Junit单元测试

开发人员在开发时针对复杂接口或者容易出错的接口及时编写单元测试样例，可以提升代码稳定性，方便后续开发人员快速上手。

### 在线单元测试

yapi具有保存单元测试的功能，可以保存单元测试样例数据，优点在于具有可视化界面，多位开发人员可以维护一组测试数据，变更记录可查。

![image-20191223215103761](images/image-20191223215103761.png)

支持私有化部署。

## 系统部署阶段

### jenkins自动化部署

#### 部署方式

可以使用单jenkins支撑多系统部署，或者多节点的方式，实现一处平台搭建，服务多个项目的目的。

#### 部署通知机制

部署前后可以借助企业微信机器人进行通知，方便测试人员和开发人员知晓部署动作。

![IMG_0857](images/IMG_0857.PNG)

## 系统配置修改

在使用docker之后，配置文件的修改会变得比较麻烦

使用apollo全局配置中心可以解决几个问题：

1. 配置项有更清晰易懂的说明。
2. 在线对配置文件进行管理，部署包不再放配置文件，方便开发人员配置，实施人员查找，配置文件修改记录可查
3. 部分配置可以实时生效
4. 多环境配置时，配置的发布需要确认后才能发布，配置文件可回滚。实施人员可根据实际情况参与配置文件的修改，由开发人员进行确认即可。

## 系统运维监控三大件
系统运维监控三大件
- Log
- trace
- Metrics
基于目前现有的技术栈，可以从以下几个方面构建运维体系
### SpringBoot

#### SpringBoot Actuator

SpringBoo借助Spring Boot Actuatort可以实现对系统的运行监控有良好的支持，但是Spring Boot Actuator暴露出的rest接口不方便数据的可视化。

较为高级的运维管理平台（基于Prometheus和Grafana）对SpringBoot Actuator也有支持。

#### springBoot-admin

Spring Boot Admin 是一个管理和监控Spring Boot 应用程序的开源软件。每个应用都认为是一个客户端，通过HTTP或者使用 Eureka注册到admin server中进行展示，Spring Boot Admin UI部分使用AngularJs将数据展示在前端。

可以监控的数据有：

- 应用基础信息
- 应用jvm相关的详细信息
- 应用运行环境信息以及应用的配置文件信息
- 日志文件/日志输出级别配置
- jmx查看
- 应用实时线程信息
- 应用接口调用记录
- 对运行的系统进行headdump

1.x版本

![image-20191223215304125](images/image-20191223215304125.png)

2.x版本

![image-20191223215409529](images/image-20191223215409529.png)

### dubbo

dubbo-monitor

dubbo可以查看已经启动的消费者与提供者接口信息，主要统计以下信息

- 接口/方法调用次数
- 接口/方法调用成功/失败率
- 接口/方法调用耗时
- 消费者与提供者的依赖情况

![image-20191223215507467](images/image-20191223215507467.png)



![image-20191223215617287](images/image-20191223215617287.png)



![image-20191223215847557](images/image-20191223215847557.png)

### jvm

服务器的jvm监控有助于我们分析Java程序的运行健康度

springBoot-admin具有查看jvm使用的功能，但是不是完善，可以寻找更加完善的jvm监控系统，最好具备监控数据存储的功能。

### 日志

#### ELK日志系统（开发环境）

elk日志收集系统部署相对较为复杂。

开发环境假如不希望到服务器拷贝配置文件，可以直接将日志存储到公共的elk日志平台。

#### 正式环境日志收集

日志是线上系统暴露信息的核心途径，在现有日志的基础上，优化日志打印内容，可以排除一些不重要的日志数据。

后期假如使用docker部署，需要对日志文件的生成做特殊处理（文件映射），保证实施人员可以方便快捷取得。

### 其他监控

#### 分布式系统数据链路监控（大而全监控）

以美团的cat为例（https://github.com/dianping/cat），摘取仓库的介绍：

>  CAT 作为服务端项目基础组件，提供了 Java, C/C++, Node.js, Python, Go 等多语言客户端，已经在美团点评的基础架构中间件框架（MVC框架，RPC框架，数据库框架，缓存框架等，消息队列，配置系统等）深度集成，为美团点评各业务线提供系统丰富的性能指标、健康状况、实时告警等。

- **[Transaction报表](https://github.com/dianping/cat/wiki/transaction)** 一段代码运行时间、次数，比如URL、Cache、SQL执行次数和响应时间
- **[Event报表](https://github.com/dianping/cat/wiki/event)** 一行代码运行次数，比如出现一个异常
- **[Problem报表](https://github.com/dianping/cat/wiki/problem)** 根据Transaction/Event数据分析出来系统可能出现的异常，包括访问较慢的程序等
- **[Heartbeat报表](https://github.com/dianping/cat/wiki/heartbeat)** JVM内部一些状态信息，比如Memory，Thread等
- **[Business报表](https://github.com/dianping/cat/wiki/business)** 业务监控报表，比如订单指标，支付等业务指标

摘取官方文档针对cpu和jvm情况的统计图表：

![image-20191223214952340](images/image-20191223214952340.png)

### 阈值报警

基于各种监控平台的指标阈值设置，或者在代码中进行打点，将错误信息、预警信息实时通过企业微信机器人进行推送。

## 系统维护
#### 数据库自动备份

借助定时任务完成数据库的自动备份。

#### 系统热部署

在对系统可用性强的系统考虑不停机热部署，借助nginx实现负载均衡和dubbo集群可以较为简单的实现。



