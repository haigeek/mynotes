JAVA后台在调用gdal库的时候，需要运行环境具备gdal环境，但是采用直接安装的gdal包是不能满足需求的

因为直接编译gdal比较繁琐且容易出错，所以直接在gdal官方提供的镜像的基础上直接添加JAVA程序调用所需要的动态链接库文件，完成具备gdal环境的镜像的制作。

完成编译后，运行程序可能依然会报错

```
java.lang.UnsatisfiedLinkError: /usr/lib/jvm/jre1.8.0_291/lib/amd64/libgdalalljni.so: libgdal.so.28: cannot open shared object file: No such file or directory
```

这时只需要做一个软链接

将已经编译好的存在的libgdal.so文件链接到程序调用的/usr/lib/libgdal.so.28文件

```
ln -s /usr/lib/libgdal.so /usr/lib/libgdal.so.28
```

