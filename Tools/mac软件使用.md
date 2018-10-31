## mac下zookeeper的使用
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
