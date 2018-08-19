# docker镜像
## 镜像的操作命令
- 从docker仓库获取镜像
`docker pull [Docker Registry 地址[:端口号]/] [仓库名]：[标签]`
例如：
` docker pull ubuntu:16.04`
Docker 镜像仓库地址：地址的格式一般是 <域名/IP>[:端口号]。默认地址是 Docker Hub。
仓库名：如之前所说，这里的仓库名是两段式名称，即 <用户名>/<软件名>。对于 Docker Hub，如果不给出用户名，则默认为 library，也就是官方镜像。
- 列出镜像
`docker image ls`
- 列出部分镜像
`docker image ls ubuntu（仓库名）`
`docker image ls ubuntu:16.04（仓库名:标签）`
`docker image ls -f since=mongo:3.2（过滤器 在 mongo:3.2 之后建立的镜像）`
`docker image ls -q（--filter 配合 -q 产生出指定范围的 ID 列表）`
- 列出中间层镜像
为了加速镜像构建、重复利用资源，Docker 会利用 中间层镜像。所以在使用一段时间后，可能会看到一些依赖的中间层镜像
`docker image ls -a`
- 删除本地镜像
`$ docker image rm [选项] <镜像1> [<镜像2> ...]`
其中，<镜像> 可以是 镜像短 ID、镜像长 ID、镜像名 或者 镜像摘要。
删除行为分两类，一类是untagged,另一类是Deleted，当进行删除的时候，删除的某个标签的镜像，所以我们第一步将这个镜像标签取消，但是如果还有其他标签指向这个镜像，那么delete是不会发生的。当所以的标签都被删除了，那么就会触发删除行为。但是因为镜像是多层存储结构，从上层向基础层方向依次进行判断然后删除，可能某个其它镜像正依赖于当前镜像的某一层。这种情况，依旧不会触发删除该层的行为。直到没有任何层依赖当前层时，才会真实的删除当前层
- docker image ls 命令来配合删除镜像
` docker image rm $(docker image ls -q redis)`
## 定制镜像
镜像的定制实际上就是定制每一层所添加的配置、文件。如果我们可以把每一层修改、安装、构建、操作的命令都写入一个脚本，用这个脚本来构建、定制镜像，那么之前提及的无法重复的问题、镜像构建透明性的问题、体积的问题就都会解决。这个脚本就是 Dockerfile。Dockerfile 是一个文本文件，其内包含了一条条的指令(Instruction)，每一条指令构建一层，因此每一条指令的内容，就是描述该层应当如何构建。
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
