# 环境搭建与软件安装

## 安装zsh

export PATH="/Users/haigeek/anaconda/bin:/usr/local/bin:/usr/bin:/usr/sbin:/lsbin:/sbin:$PATH"

### 环境变量

创建软链接

ln -s 源命令位置 目标位置 

例如：

ln -s  /Users/haigeek/software/apache-maven-3.6.1/bin/mvn /usr/local/bin/mvn

使用

### mysql的安装

使用brew安装mysql

```shell
brew install mysql
```

在安装完成之后，会提示我们几条信息，首先提醒我们将mysql添加到环境变量，这是使用的zsh终端，bash终端类似，使用如下指令：

```shell
echo 'export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"' >> ~/.zshrc
```

在将mysql添加到环境变量之后，启动mysql

```shell
mysql.server start
```

启动之后进行mysql的配置

```shell
mysql_secure_installation
```

配置完成后进行连接

## zookeeper

### 启动，进入bin文件夹
./zkServer.sh start
./zkServer.sh start-foreground(在前台显示输出)

### 停止
./zkServer.sh stop
## jenv的使用
jenv是mac下的一款java版本管理软件
### 安装
```shell
brew install jenv
```
### 配置（默认的bash）
```language
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(jenv init -)"' >> ~/.bash_profile
```
### 使用
- 查看jdk版本
```language
jenv versions
```
- 添加jdk
```language
jenv add  /System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/
```
- 移除jdk
```language
jenv remove
```
- 查看当前jek路径
```language
jenv which java
```
- 设置默认的jdk
```language
jenv global 版本号
```
## youtube-dl的使用
### 安装
brew install youtube-dl
### 使用
- 查看分辨率
youtube-dl --proxy 'socks5://127.0.0.1:1086' --list-formats 'https://youtu.be/rkM-dTr89kQ'
- 指定编号进行下载
youtube-dl --proxy 'socks5://127.0.0.1:1086' -f 136 'https://youtu.be/rkM-dTr89kQ'
