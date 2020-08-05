# docker容器的操作
## 启动

启动容器有两种方式，一个是基于镜像新建一个容器启动，另外一个是将终止状态的容器重新启动

### 新建并启动
使用 docker run 命令来启动容器
下面的代码是输出一个hello world然后终止容器

```shell
[root@VM_13_213_centos ~]# docker run ubuntu:16.04 /bin/echo 'hello word'
hello word
```
下面的命令则是则启动一个 bash 终端，允许用户进行交互，就像打开了Ubuntu系统
```shell
[root@VM_13_213_centos ~]# docker run -t -i ubuntu:16.04 /bin/bash
root@d2499c769aea:/# 
```
其中， -t 选项让Docker分配一个伪终端（pseudo-tty）并绑定到容器的标准输入上， -i则让容器的标准输入保持打开。

#### 命名

--name  名称

#### 端口映射

当docker启动的时候，可以是使用-P和-p进行端口的映射，将内部的端口映射出来

-P 随机映射

-p 指定端口映射 宿主机：容器端口

```
docker run -d -p 8080:8080 c8d8d44b57ad ##将内部的8080映射为宿主机的8080
```

#### 数据卷映射

容器运行时应该尽量保持容器存储层不发生写操作。但是，有时候我们需要存储持久化的数据，比如数据库，你的数据都在容器中，肯定是不行的，因为一退出就没有了。

这个时候需要用到数据卷。数据卷就是可以让你把主机上的数据以挂载的方式链接到容器中，这样不同的容器也能共享，而且数据也不会因为容器的退出而丢失。

使用-v进行文件卷的映射

```
docker run -d -v  ~/www:/www -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf -v $PWD/logs:/wwwlogs  -d nginx   #	将宿主机中当前目录下的www挂载到容器的/www、conf、wwwlogs类比
```

### 后台运行

-d 参数可以使得docker在后台运行
在不使用-d参数的时候，容器会将输出结果直接打印在宿主机上面
使用-d 参数运行容器将不会将输出进行打印，而是需要用户使用 docker container logs[container id or names]来查看输出

### 启动已终止的容器

当容器启动失败时候，会自动终止，但是这个容器依旧是成功创建的，这个时候我们只能使用start命令启动容器而不是run

```
docker start containerid
```

## 进入容器

在需要进入容器进行操作的时候，可以使用 docker attach命令或者docker exec命令

- attach
  Docker自带的命令，但是如果从这个 stdin 中 exit，会导致容器的停止。

  ```
  docker attach [容器id]
  ```

- exec
  使用 -t -i 命令可以是我们看到熟悉的linux终端，一个是 -i ：交互式操作，一个是 -t 终端如果从这个 stdin 中 exit，不会导致容器的停止。

  ```
  docker exec -it [容器id] bash
  ```

**注意只有在容器启动的时候才可以进入容器**

## 终止启动的容器
使用docker container stop来终止运行中的容器
只启动了一个终端的容器，用户通过 exit 命令或 Ctrl+d 来退出终端时，所创建的容器立刻终止。
处于终止状态的容器，可以通过 docker container start 命令来重新启动。
此外， docker container restart 命令会将一个运行态的容器终止，然后再重新启动它。

### 显示已经停止的容器

```
docker ps -a
```

## 查看容器的信息

查看容器的日志

```
docker logs [NAME]/[CONTAINER ID]
```

查看容器的进程

```
docker top [NAME]/[CONTAINER ID]
```

查看容器的信息

```
docker inspect [NAME]/[CONTAINER ID]
```

-f或--format格式化标志，可以查看指定部分的信息。

```
docker inspect --format='{{.State.Running}}' [NAME]/[CONTAINER ID] #查看容器的运行状态
docker inspect --format='{{.NetworkSettings.IPAddress}} [NAME]/[CONTAINER ID]' #查看容器的IP地址
docker inspect --format '{{.Name}} {{.State.Running}}' [NAME]/[CONTAINER ID] #同时查看多个信息查看容器名和运行状态
```


## 删除容器
删除一个处于终止状态的容器,如果要删除一个运行中的容器，可以添加 -f 参数。Docker 会发送 SIGKILL 信号给容器。

```
docker container rm [id] 
```


用 docker container ls -a 命令可以查看所有已经创建的包括终止状态的容器，如果数量太多要一个个删除可能会很麻烦，用下面的命令可以清理掉所有处于终止状态的容器。

```
docker contain prune
```

## 容器的导入和导出
如果要导出本地某个容器，可以使用 docker export 命令。

```
docker export [id] > ubuntu.tar
docker export [id] > /usr/local/docker/ubuntu.tar
```

可以使用 docker import 从容器快照文件中再导入为镜像,此外，也可以通过指定 URL 或者某个目录来导入

```
docker import -ubuntu.tar
docker import -/usr/local/docker/ubuntu.tar
```

**需要注意的是：导出的容器再次被导入时会变成镜像而不是容器**

导出镜像与导出容器的区别在于：

将一个镜像导出为文件，再使用docker load命令将文件导入为一个镜像，会保存该镜像的的所有历史记录。比docker export命令导出的文件大，很好理解，因为会保存镜像的所有历史记录。

将一个容器导出为文件，再使用docker import命令将容器导入成为一个新的镜像，但是相比docker save命令，容器文件会丢失所有元数据和历史记录，仅保存容器当时的状态，相当于虚拟机快照。

