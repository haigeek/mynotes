# maven资源文件下文件的读取
新建一个maven工程后，main目录下会有java和resources两个文件夹，其中java文件夹下存放源代码，resources文件夹下存放一些配置文件等。
## classpath
classpath是编译后的 以 classes 文件夹为起点的路径，而在ItelliJ IDEA 中编译后的文件会存入out/production下，在maven中会保存到target/classes文件夹
## 如何读取文件
```Java
//获取文件的url地址
String url = This.class.getClassLoader().getResource("test.json").getFile();
```
getResource()方法会去classpath下找这个文件，获取到url resource, 得到这个资源后，调用url.getFile获取到 文件 的绝对路径
