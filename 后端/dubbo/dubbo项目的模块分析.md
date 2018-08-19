dubbo后台模块分析
## dgp-server-mobile-api
这一模块主要是进行各种定义,供dgp-server-mobile-service这一模块进行调用，包括了常量的定义，数据实体的定义(与数据库中的表对应)，数据传输对象(服务层需要接收的数据和返回的数据),VO（展示层需要显示的数据）。定义service接口，在其他模块实现这些接口。
- constants 定义常量 
- dto(Data Transfer Object) 数据传输对象
- vo(view object) 视图对象，用于展示层，它的作用是把某个指定页面（或组件）的所有数据封装起来。 
- entity 数据实体，与数据库中的表对应
- service 定义公共接口 但不在这一模块实现
- pom文件
集成父pom文件，打包为jar包，引入依赖并排除不需要的依赖
## dgp-server-mobile-service
这一模块在dubbo中担任提供者的角色，主要的业务处理逻辑在这一层得以实现，同时数据的存储也在这一模块实现。
### 包的定义及功能
- 主要代码部分
1. dao层主要处理与数据库相关的操作
2. domain层主要是业务逻辑的处理，通过dao层和数据库打交道
3. service层 业务接口的实现类，service层会调用domain层来进行数据的交互
4. manage层 存放管理类的代码
5. util存放工具类
- assembly：包含打包成tar.gz文件的配置文件，并且需要maven-assembly-plugin插件
- profiles：属性文件
- resources：资源配置文件，在此处定义dubbo远程服务接口
- pom文件
集成父pom文件；打包成jar包；添加相关的jar包：
引入dgp-server-mobile-api jar包
同时需要插件：
maven-assembly-plugin
maven-jar-plugin
## dgp-server-mobile-web
这一模块在dubbo中担任消费者的角色，这一模块将整个系统的接口暴露出来供前端调用，Controller层调用service层来进行业务逻辑的处理
### 包的定义及功能
- controller 提供服务到前端
- swagger swagger相关
- resources 配置文件，包括dubbo和spring的相关配置，在此处进行定义dubbo消费者的接口
- webapp web.xml配置过滤以及监听

分级的意义
## 系统层面
1. 前后端分离，通过restful来进行接口的设计，通过swagger来进行接口的管理，使得系统的接口简洁明了
2. 通过dubbo来进行分布式的架构设计,消费者和提供者的通过注册中心来进行联系，建立稳定的服务中心，同时支持分布式部署，提升系统的稳定性和健壮性
## 开发层面
1. 分层开发使得系统逻辑清晰，每一层都有不同的功能，将系统进行解耦，提升了系统的可拓展性，同时方便开发者快速定位问题。
2. 较之前的三层业务模式，最直观的是层次更加清晰，当我们的业务越来越复杂的时候，原有的结构已经不能满足我们的需求，显得比较混乱，那么采用dubbo，将每个模块抽分出来（服务化），通过注册中心来维持整个架构的运转
3. 新的架构降低了系统的耦合性，提升系统的拓展性，在增加一个功能时，只需要增加一个模块，调用其他模块的接口即可。