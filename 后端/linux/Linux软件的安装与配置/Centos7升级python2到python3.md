# Centos7升级python2到python3

服务器自带的python版本为2.7,需要升级到python3,遇到了一些坑,记录一下.

## 准备工作

安装和编译工作很顺利,但是发现pip版本不能被正确安装,出现下面的错误

```
Traceback (most recent call last):
   File "<stdin>", line 1, in <module>
   File "/usr/local/lib/python3.4/multiprocessing/context.py", line 132, in Value
      from .sharedctypes import Value
   File "/usr/local/lib/python3.4/multiprocessing/sharedctypes.py", line 10, in <
module>
   import ctypes
   File "/usr/local/lib/python3.4/ctypes/__init__.py", line 7, in <module>
      from _ctypes import Union, Structure, Array
ImportError: No module named '_ctypes'
```

[查阅资料发现](https://stackoverflow.com/questions/27022373/python3-importerror-no-module-named-ctypes-when-using-value-from-module-mul)需要提前安装好一个依赖,pip才可以被正确安装

```
yum install libffi-devel
```

## 安装

```
# 下载
wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
#解压源码包
tar -zxvf Python-3.7.0.tgz
#创建安装目录
mkdir /usr/local/python3
cd Python-3.7.0/
#安装到指定目录
./configure --prefix=/usr/local/python3
# 编译
make && make install
```

## 后续工作

### 设置软链接使得全局使用python3

```
cd /usr/local/python3
ln -s /usr/local/python3/bin/python3 /usr/local/bin/python3
ln -s /usr/local/bin/pip3 /usr/bin/pip
```

不知道pip安装位置的,可以使用命令来查看安装位置

```
which pip3
```

验证版本

```
pip3 -V
python3 -V
```

可以使用下述命令来查看软链接设置

```
ls -al /usr/bin | grep python
```

### 配置yum

升级 Python 之后，由于将默认的 python 指向了 python3，yum 不能正常使用，需要编辑 yum 的配置文件：

```text
vi /usr/bin/yum
```

同时修改：

```text
vi /usr/libexec/urlgrabber-ext-down
```

将 #!/usr/bin/python 改为 #!/usr/bin/python2.7，保存退出即可。



参考链接

> https://docs.python.org/zh-cn/3/installing/index.html

> https://www.jianshu.com/p/447750ec1186
>
> https://zhuanlan.zhihu.com/p/34024112