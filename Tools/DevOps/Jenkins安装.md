# Jenkins入门

## 安装

### windows

启动jenkins环境的准备 

˜启动方式war启动并需要支持端˜口修改

安装时推荐的插件不了解的可以全部安装，熟悉的可以根据需要安装

可能遇到的问题有

出现代理错误什么的 修改插件中心地址？一般百度都可以解决

### Linux

使用rpm进行安装(选择合适的版本进行安装)

```shell
wget https://pkg.jenkins.io/redhat/jenkins-2.156-1.1.noarch.rpm
rpm -ivh jenkins-2.156-1.1.noarch.rpm
```

修改目录权限

```shell
chown -R root:root /var/lib/jenkins
chown -R root:root /var/cache/jenkins
chown -R root:root /var/log/jenkins
```

启动

```
service start jenkins
```

在启动的时候可能会出现Java路径找不到的情况,设置一个软连接即可

```
ln -s /usr/java/jdk1.8.0_201/bin/java /usr/bin/java
```

### 设置编译环境

jdk、git、maven等

## 安装插件

一般安装时提供的插件相对已经比较完善，选几个比较常用的介绍下

常用的插件

git等

