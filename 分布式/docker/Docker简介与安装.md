# Docker简介与安装

Docker是一个开源的应用容器引擎；是一个轻量级容器技术；

![image.png](https://cdn.nlark.com/yuque/0/2019/png/84598/1554633390599-5f5ad709-18ba-4a43-a4d6-d55650938581.png#align=left&display=inline&height=142&name=image.png&originHeight=142&originWidth=215&size=17108&status=done&width=215)
<a name="84b6f2b0"></a>
## 1、简介
Docker支持将软件编译成一个镜像；然后在镜像中各种软件做好配置，将镜像发布出去，其他使用者可以直接使用这个镜像；运行中的这个镜像称为容器，容器启动是非常快速的。

![image.png](https://cdn.nlark.com/yuque/0/2019/png/84598/1554633372295-68342563-eeb6-47a8-a9cd-0e74716297ac.png#align=left&display=inline&height=362&name=image.png&originHeight=362&originWidth=539&size=118543&status=done&width=539)
<a name="caa034e6"></a>
## 2、docker的优点
**更轻量**镜像尺寸小 ，资源利用率高 。我们方便去牵引，牵引的话如果已经有一些镜像存在的话，镜像尺寸就比较小。同时因为它没有虚拟机那么重，所以它的健壮率会很高。**更快速**直接运行在宿主机上，没有IO转换负担。它就是宿主机上的一个进程，启一个进程是非常快的，没有像虚拟机还要进行CPU，内存的这些时间的消耗，并且docker它利用率高也体现。**更便捷**易安装，易使用，迁移方便，数据量小。安装docker就通过一个命令，一个脚本就把docker装起来，也很方便去使用，我们只有熟悉docker的命令，我们就可以把它运用起来。迁移的时候，我们不要去迁移docker，我们去迁移的是容器的镜像，数据量小也体现在镜像的分层技术，同一批镜像，如果有很多个，它是重复的，它只会占用一个磁盘空间。
<a name="fcd5525d"></a>
## 3、核心概念
docker主机(Host)：安装了Docker程序的机器（Docker直接安装在操作系统之上）；docker客户端(Client)：连接docker主机进行操作；docker仓库(Registry)：用来保存各种打包好的软件镜像；

![image.png](https://cdn.nlark.com/yuque/0/2019/png/84598/1554633789620-74500fe9-5ae8-4082-8a9a-5f787ccaadcb.png#align=left&display=inline&height=980&name=image.png&originHeight=980&originWidth=1190&size=501476&status=done&width=1190)

docker镜像(Images)：软件打包好的镜像；放在docker仓库中；镜像不包含任何动态数据，其内容在构建之后也不会被改变。其中使用分层技术，当我们下载镜像时候，会根据每一层的镜像标识判断是否已经下载过，下载过的layer不会重复下载，一个镜像不能超过
127 层。docker容器(Container)：镜像启动后的实例称为一个容器；容器是独立运行的一个或一组应用；镜像（Image）和容器（Container）的关系，就像是面向对象程序设计中的类和实例一样，镜像是静态的定义，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等。容器尽管可以运行多个服务，但推荐只运行一个服务。

![image.png](https://cdn.nlark.com/yuque/0/2019/png/84598/1554633757622-1a439fc6-c448-4960-b0db-5bc8836d8291.png#align=left&display=inline&height=125&name=image.png&originHeight=125&originWidth=368&size=22788&status=done&width=368)


![image.png](https://cdn.nlark.com/yuque/0/2019/png/84598/1554633763379-64e3620f-e8c1-470f-88ae-54b79c99b87e.png#align=left&display=inline&height=241&name=image.png&originHeight=241&originWidth=366&size=118172&status=done&width=366)

上面的两张图展示了容器与镜像、镜像与宿主机的关系。**容器是在镜像上加了一层可读写层来使得外界可以使用镜像。而这一切的基础都依赖于宿主机提供的系统和内核以及硬件支持。**

<a name="e71a87e7"></a>
## 4、Docker的安装与卸载
<a name="2205da00"></a>
### 安装步骤：
1、检查内核版本，必须是3.10及以上uname -r2、安装dockeryum install docker3、输入y确认安装4、启动docker[root@localhost ~]# systemctl start docker[root@localhost ~]# docker -vDocker version1.12.6, build 3e8e77d/1.12.65、开机启动docker[root@localhost ~]# systemctl enable dockerCreated symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.6、停止dockersystemctl stop docker
<a name="69aaefbf"></a>
### 卸载步骤：
1首先搜索已经安装的docker 安装包[root@localhost ~]# yum list installed|grep docker或者使用该命令[root@localhost ~]# rpm -qa|grep dockerdocker.x86_64 2:1.12.6-16.el7.centos @extrasdocker-client.x86_64 2:1.12.6-16.el7.centos @extrasdocker-common.x86_64 2:1.12.6-16.el7.centos @extra2 分别删除安装包[root@localhost ~]#yum –y remove docker.x86_64[root@localhost ~]#yum –y remove docker-client.x86_64[root@localhost ~]#yum –y remove docker-common.x86_643 删除docker 镜像[root@localhost ~]# rm -rf /var/lib/docker4 再次check docker是否已经卸载成功[root@localhost ~]# rm -rf /var/lib/docker[root@localhost ~]#如果没有搜索到，那么表示已经卸载成功。
