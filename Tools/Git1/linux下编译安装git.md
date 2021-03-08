# linux下编译安装git

移除旧的git

```
yum remove git
```

安装依赖

```
yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker
```

cd到git的目录进行编译

```
make prefix=/usr/local/git all
```

安装git至`/usr/local/git`路径

```
make prefix=/usr/local/git install
```

设置环境变量

```
vim /etc/profile
```

```
PATH=$PATH:/usr/local/git/bin
export PATH
```

刷新

```
source /etc/profile
```

