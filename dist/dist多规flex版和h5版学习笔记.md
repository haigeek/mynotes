## 学习DGServer
Error:(22, 1) java: 对于属性<clinit>, 注释org.springframework.web.bind.annotation.CrossOrigin缺少值
解决：jdk版本问题，更换为1.8解决
java.lang.IllegalArgumentException: Invalid 'log4jConfigLocation' parameter: class path resource [log4j.properties] cannot be resolved to URL because it does not exist
解决：将打包方式更换为war exploded方式解决
## 学习h5-dubbo后台
### dubbo版本启动过程
1. 启动zookeeper
2.  -XX:MaxPermSize=64M 找不到类
解决：应该在target目录下启动dgp-server-service
3. [RMI TCP Connection(127.0.0.1:2181)] WARN ClientCnxn - Session 0x0 for serve
解决：重启zookeeper
### h5 dubbo后台的结构分析
#### dgp-server-web
1. com.dist.controller包是接口的实现，提供服务供前端使用



