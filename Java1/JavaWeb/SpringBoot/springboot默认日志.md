## 默认的日志系统

默认的日志系统为logback

### 输出格式

默认的日志输出格式如下：

`2017-12-13 10:02:59.897  INFO 17300 --- [           main] com.haigeek.JkfpApplication              : Starting JkfpApplication on haigeek with PID 17300 (started by haigeek in F:\coding\java\intellij idear workplace\jkfp)`

输出元素的具体内容如下

- 时间日期：精确到毫秒

- 日志级别：ERROR,INFO,WARN,DEBUG or TRACE

- 进程id

- 分隔符：--- 标志实际日志的开始

- 线程名： 方括号括起来

- logger名：通常使用源代码的类名

- 日志内容

### 控制台输出

在springboot默认配置了ERROR、WARN和INFO级别的日志输出到控制台。

可通过两种方式切换到DEBUG级别

- 在运行了命令后加入debug命令 如：$ java -jar my.jar -debug

- 在application.properties中配置debug=true * 该属性置为true的时候，核心Logger（包含嵌入式容器、hibernate、spring）会输出更多内容，但是你自己应用的日志并不会输出为DEBUG级别。

### 文件输出

Spring Boot默认配置只会输出到控制台，并不会记录到文件中。若要增加日志输出需要在application.properties中配置logging.file或logging.path属性。

- logging.file，设置文件，可以是绝对路径，也可以是相对路径。如：logging.file=my.log

- logging.path，设置目录，会在该目录下创建spring.log文件，并写入日志内容，如：logging.path=/var/log

日志文件会在10Mb大小的时候被截断，产生新的日志文件，默认级别为：ERROR、WARN、INFO

### 级别控制

在Spring Boot中只需要在application.properties中进行配置完成日志记录的级别控制。

配置格式：logging.level.*=LEVEL

- logging.level：日志级别控制前缀，*为包名或Logger名

- LEVEL：选项TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF

举例：

- logging.level.com.didispace=DEBUG：com.didispace包下所有class以DEBUG级别输出

- logging.level.root=WARN：root日志以WARN级别输出

