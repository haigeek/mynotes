## 什么是gdal

GDAL(Geospatial Data Abstraction Library)是一个在[X/MIT许可协议](https://baike.baidu.com/item/X%2FMIT许可协议/10136122)下的开源栅格空间数据转换库。它利用抽象数据模型来表达所支持的各种文件格式。它还有一系列命令行工具来进行数据转换和处理。

## 安装

按照官网的[介绍](https://trac.osgeo.org/gdal/wiki/BuildingOnMac)，安装可以使用以下几种方式：

一、使用编译好的程序

1. At KyngChaos: [http://www.kyngchaos.com/software/frameworks#gdal_complete](http://www.kyngchaos.com/software/frameworks#gdal_complete) 即在KyngChaos下载已经编译好的程序
2. Using [Homebrew](https://brew.sh/) via `brew install gdal` 使用brew进行安装

二、自行编译

1、下载源码进行编译

因为我需要在java的开发环境下进行开发，需要用到jni来进行gdal程序的调用，需要使用源码进入到swig目录下，选择java，进行编译，编译完成后会生成调用gdal的动态链接库和`gdal.jar`

2、使用brew进行编译

按照官网的介绍可以使用命令

```
brew install gdal --HEAD
```

但是我在执行的时候会报错误

```
Error: A newer Command Line Tools release is available.
Update them from Software Update in System Preferences or run:
  softwareupdate --all --install --force
```

按照提示操作后依旧报错。

### 准备工作

准备编译程序所需要的依赖包，我这里使用brew先来安装编译好的gdal，再卸载，这样需要的依赖会完成安装

1、安装

```
brew install gdal
```

2、卸载

```
brew uninstall gdal
```

这里也尝试使用官网介绍的`brew install gdal —-only-dependencies` 来安装依赖但是执行失败。

### 编译

1、下载源码

```
wget https://github.com/OSGeo/gdal/releases/download/v3.2.1/gdal-3.2.1.tar.gz
```

2、编译主程序

```
./configure --with-jvm-lib=/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home --without-python --without-pg
```

需要将`--with-jvm-lib`替换为你的jdk地址

其中--without-pg是为了避免错误，如果不加入此项，在第一次编译时有如下报错

```
./postgisraster.h:41:10: fatal error: 'libpq-fe.h' file not found
```

参考的处理方式：https://github.com/OSGeo/gdal/issues/1714

3、编译java运行环境所需要的动态链接库和jar包

```
make CFLAGS="-I/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home/include -I/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home/include/darwin"
```

在编译完成后将生成的`libgdalalljni.dylib`和`libgdalalljni.28.dylib`拷贝到路径`/Library/Java/Extensions`

4、在本地安装jar包

```
mvn install:install-file -Dfile=/Users/haigeek/dev/project/github/gdal-3.2.1/swig/java/gdal.jar -DgroupId=org.gdal -DartifactId=gdal -Dversion=3.2.1 -Dpackaging=jar
```

## JAVA使用Gda示例

```java
public void testGdb() {
         // 注册所有的驱动
        gdal.AllRegister();
        // 为了支持中文路径，请添加下面这句代码
        gdal.SetConfigOption("GDAL_FILENAME_IS_UTF8", "YES");
        // 为了使属性表字段支持中文，请添加下面这句
        gdal.SetConfigOption("SHAPE_ENCODING", "");
        String strDriverName = "OpenFileGDB";
        org.gdal.ogr.Driver oDriver = ogr.GetDriverByName(strDriverName);
        if (oDriver == null) {
            System.out.println(strDriverName + " 驱动不可用！");
            return;
        }
        String gdbPath = "/Users/haigeek/Downloads/FW测试/FW.gdb";
        DataSource ds = oDriver.Open(gdbPath);
        String dsName = ds.getName();
        int count = ds.GetLayerCount();
        //遍历图层
        for (int i = 0; i < count; i++) {
            String layerName = ds.GetLayerByIndex(i).GetName();
            System.out.println("图层名:" + layerName);
            Layer layer = ds.GetLayerByIndex(i);
            for (long j = 0; j < layer.GetFeatureCount(); j++) {
                FeatureDefn featureDefn = layer.GetLayerDefn();
                System.out.println("要素名" + featureDefn.GetName());
                for (int k = 0; k < featureDefn.GetFieldCount(); k++) {
                    System.out.println("字段名" + featureDefn.GetFieldDefn(k).GetName());
                }
            }
        }
        ds.delete();
    }
```



## 参考链接

https://gdal.org/download.html

https://www.ljnewmap.com/news/124.html

https://cloud.tencent.com/developer/article/1612274