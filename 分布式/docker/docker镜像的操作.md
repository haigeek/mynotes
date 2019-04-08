# docker镜像
## 镜像的操作命令

### 获取镜像

从docker仓库获取镜像

```
docker pull [Docker Registry 地址[:端口号]/] [仓库名]：[标签]
```

Docker 镜像仓库地址：地址的格式一般是 <域名/IP>[:端口号]。默认地址是 Docker Hub。
仓库名：如之前所说，这里的仓库名是两段式名称，即 <用户名>/<软件名>。对于 Docker Hub，如果不给出用户名，则默认为 library，也就是官方镜像。

例如：

```
 docker pull ubuntu:16.04
```

### 列出镜像

```
docker image ls
```

列出部分镜像

```
docker image ls ubuntu（仓库名）
docker image ls ubuntu:16.04（仓库名:标签）
docker image ls -f since=mongo:3.2（过滤器 在 mongo:3.2 之后建立的镜像）
docker image ls -q（--filter 配合 -q 产生出指定范围的 ID 列表）
```

列出中间层镜像
为了加速镜像构建、重复利用资源，Docker 会利用 中间层镜像。所以在使用一段时间后，可能会看到一些依赖的中间层镜像

```
docker image ls -a
```

### 镜像的导入导出

#### 导入

```
docker save 容器名/id >容器名.tar

docker save 容器名/id >/usr/local/docker/容器名.tar
```

默认导出位置在当前执行命令的路径

#### 导出

```
docker load <容器名.tar

docker load </usr/local/docker/容器名.tar
```

默认在当前执行命令的路径寻找docker镜像

### 删除本地镜像

```
docker image rm [选项] <镜像1> [<镜像2> ...]
```

其中，<镜像> 可以是 镜像短 ID、镜像长 ID、镜像名 或者 镜像摘要。
删除行为分两类，一类是untagged,另一类是Deleted，当进行删除的时候，删除的某个标签的镜像，所以我们第一步将这个镜像标签取消，但是如果还有其他标签指向这个镜像，那么delete是不会发生的。当所以的标签都被删除了，那么就会触发删除行为。但是因为镜像是多层存储结构，从上层向基础层方向依次进行判断然后删除，可能某个其它镜像正依赖于当前镜像的某一层。这种情况，依旧不会触发删除该层的行为。直到没有任何层依赖当前层时，才会真实的删除当前层

docker image ls 命令来配合删除镜像

```
docker image rm $(docker image ls -q redis)
```