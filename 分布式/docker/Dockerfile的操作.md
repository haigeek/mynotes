# Dockerfile的操作

## 定制镜像

镜像的定制实际上就是定制每一层所添加的配置、文件。如果我们可以把每一层修改、安装、构建、操作的命令都写入一个脚本，用这个脚本来构建、定制镜像，那么之前提及的无法重复的问题、镜像构建透明性的问题、体积的问题就都会解决。这个脚本就是 Dockerfile。Dockerfile 是一个文本文件，其内包含了一条条的指令(Instruction)，每一条指令构建一层，因此每一条指令的内容，就是描述该层应当如何构建。

## Docker 常用镜像的构建

### 使用jdk8和tomcat8.5构建基础镜像

```dockerfile
# make jdk-tomcat8 image
FROM openjdk:8-jdk-alpine
MAINTAINER haigeek
# now add java and tomcat support in the container 
ADD apache-tomcat-8.5.38.tar.gz /usr/local/ 
RUN cd /usr/local/  \
    && rm -f apache-tomcat-8.5.38.tar.gz

# configuration of java and tomcat ENV 
ENV CATALINA_HOME /usr/local/apache-tomcat-8.5.38
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/lib:$CATALINA_HOME/bin 

# container listener port 
EXPOSE 8080
# startup web application services by self 
CMD /usr/local/apache-tomcat-8.5.38/bin/catalina.sh run
```

### from 指定基础镜像

From指定一个基础镜像，在其上进行定制，基础镜像必须指定而且必须是第一条指令
在 Docker Store 上有非常多的高质量的官方镜像，有可以直接拿来使用的服务类的镜像，如 nginx、redis、mongo、mysql、httpd、php、tomcat 等；也有一些方便开发、构建、运行各种语言应用的镜像，如 node、openjdk、python、ruby、golang 等。可以在其中寻找一个最符合我们最终目标的镜像为基础镜像进行定制。
如果没有找到对应服务的镜像，官方镜像中还提供了一些更为基础的操作系统镜像，如 ubuntu、debian、centos、fedora、alpine 等，这些操作系统的软件库为我们提供了更广阔的扩展空间。
除了选择现有镜像为基础镜像外，Docker 还存在一个特殊的镜像，名为 scratch。这个镜像是虚拟的概念，并不实际存在，它表示一个空白的镜像。如果你以 scratch 为基础镜像的话，意味着你不以任何镜像为基础，接下来所写的指令将作为镜像第一层开始存在。

### run 执行命令

RUN 指令是用来执行命令行命令的，他有两种格式

- shell格式 在命令行中输入的命令一样
- exec格式 RUN ["可执行文件", "参数1", "参数2"]，这更像是函数调用中的格式。
  下面是一个run的例子

```shell
FROM debian:jessie

RUN buildDeps='gcc libc6-dev make' \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && wget -O redis.tar.gz "http://download.redis.io/releases/redis-3.2.5.tar.gz" \
    && mkdir -p /usr/src/redis \
    && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
    && make -C /usr/src/redis \
    && make -C /usr/src/redis install \
    && rm -rf /var/lib/apt/lists/* \
    && rm redis.tar.gz \
    && rm -r /usr/src/redis \
    && apt-get purge -y --auto-remove $buildDeps
```

在进行构建的时候，不需要使用RUN来一一对应不同的指令，只需要一个RUN指令，使用&&将各个所需要的命令串起来，同时要将Dockerfile进行格式化，Dockerfile 支持 Shell 类的行尾添加 \ 的命令换行方式，以及行首 # 进行注释的格式。良好的格式，比如换行、缩进、注释等，会让维护、排障更为容易。
此外，在一组命令的最后添加了清理工作的命令，删除了为了编译构建所需要的软件，清理了所有下载、展开的文件，并且还清理了 apt 缓存文件。

### 构建镜像

在Dockerfile文件所在的目录执行：