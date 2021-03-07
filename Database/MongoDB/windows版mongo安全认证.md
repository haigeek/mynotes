# windows版mongo启动安全认证


测试版本：3.4.7  ，4.0.6

## 测试是否启动安全认证

- 打开mongo shell ：（可将mongo的bin目录配置到环境变量中的path中直接启动mongo）

  ```shell
  C:\Users\xiaohao>mongo
  MongoDB shell version v3.4.7
  connecting to: mongodb://127.0.0.1:27017
  MongoDB server version: 3.4.7
  Server has startup warnings:
  2019-08-29T10:56:07.116+0800 I CONTROL  [initandlisten]
  2019-08-29T10:56:07.116+0800 I CONTROL  [initandlisten] ** WARNING: Access control is not enabled for the database.
  2019-08-29T10:56:07.117+0800 I CONTROL  [initandlisten] **          Read and write access to data and configuration is unrestricted.
  2019-08-29T10:56:07.117+0800 I CONTROL  [initandlisten]
  >
  ```

  - 如果未启动安全认证会出现warnings（4.0.6版本未启动安全认证前shell会显示更多的warnings信息）
    - WARNING: Access control is not enabled for the database.
    - Read and write access to data and configuration is unrestricted.

## 开启安全认证（二选一）

> 推荐使用配置文件方式，易排查，有配置记录，利于后期维护

### 首先创建管理用户

- 首先打开mongo shell，进入admin数据库，创建一个管理员用户

```shell
use admin
switched to db admin
> db.createUser(
  {
  user: "myUserAdmin",
  pwd: "dist2019",
  roles: ["userAdminAnyDatabase"]
  }
)

Successfully added user: { "user" : "myUserAdmin", "roles" : [ "userAdminAnyDatabase" ] }
##登录测试
> db.auth("myUserAdmin","passwd")
1
##失败返回0
```

### 方式一：命令方式开启

- 以**管理员方式**启动cmd

- 删除以前的MongoDB服务

  ```shell
  sc delete MongoDB
  ```

- 打开计算机的服务管理界面，右键停止，刷新，就会发现该服务已经没了，关闭该界面。

- 创建带有安全认证的MongoDB服务

  ```shell
  sc create MongoDB binpath="E:\Mongo4.0\bin\mongod.exe --dbpath E:\Mongo4.0\data --logpath E:\Mongo4.0\log\mongodb.log  --logappend --service"
  ```

  - 注意修改路径，bin目录下的mongod.exe，数据库目录，日志目录

- 启动服务

  ```shell
  net start mongodb
  ```



### 方式二：配置文件方式开启

- 以**管理员方式**启动cmd

- 删除以前的MongoDB服务

  ```shell
  sc delete MongoDB
  ```

- 打开计算机的服务管理界面，右键停止，刷新，就会发现该服务已经没了，关闭该界面

- 在安装目录上添加配置文件

  ```shell
  systemLog:
      destination: file
      path: E:\Mongo4.0\log\mongodb.log
  storage:
      dbPath: E:\Mongo4.0\data
      engine: wiredTiger
      wiredTiger: 
          engineConfig: 
              cacheSizeGB: 5    
  net:
      bindIp: 127.0.0.1
      port: 27017
  security:
      authorization: enabled
  ```

  - 配置文件信息里子配置前面是四个空格，不能用tab键代替。不然报错

- 根据配置文件启动mongo

  ```shell
  E:\Mongo4.0\bin\mongod.exe --config "E:\Mongo4.0\mongod.cfg" --install  --serviceName "MongoDB"
  ```

  - 注意bin路径和配置文件的路径

- 启动mongoDB服务

  ```shell
  net start mongodb
  ```



## 安全认证测试

- 启动安全认证之后无登录进行连接：发现无权限查看数据库

  ```shell
  C:\Users\xiaohao>mongo
  MongoDB shell version v3.4.7
  connecting to: mongodb://127.0.0.1:27017
  MongoDB server version: 3.4.7
  ###无权限查看数据库
  > show dbs
  2019-08-29T12:21:17.295+0800 E QUERY    [thread1] Error: listDatabases failed:{
          "ok" : 0,
          "errmsg" : "not authorized on admin to execute command { listDatabases: 1.0 }",
          "code" : 13,
          "codeName" : "Unauthorized"
  } :
  _getErrorWithCode@src/mongo/shell/utils.js:25:13
  Mongo.prototype.getDBs@src/mongo/shell/mongo.js:62:1
  shellHelper.show@src/mongo/shell/utils.js:769:19
  shellHelper@src/mongo/shell/utils.js:659:15
  @(shellhelp2):1:1
  ```

  - 在4.0.6版本启动安全认证无登录查看数据库的时候不会报错，但不显示数据

- 退出shell进行用户登录：

  ```shell
  mongo -u myUserAdmin -p passwd localhost:27017/admin
  ```

- 登录成功返回信息，并能进行数据的操作

  ```shell
  C:\Users\xiaohao>>mongo -u myUserAdmin -p passwd localhost:27017/admin
  MongoDB shell version v3.4.7
  connecting to: mongodb://localhost:27017/admin
  MongoDB server version: 3.4.7
  ###测试是否有权限查看数据库
  > show dbs
  admin        0.000GB
  local        0.000GB
  test         0.000GB
  ```
  
- 开启安全认证之后，数据库连接工具要输入用户名和密码

## 相关bug

### net start MongoDB报错（服务无法启动）

```shell
C:\WINDOWS\system32>net start MongoDB
MongoDB 服务正在启动 .
MongoDB 服务无法启动。

发生服务特定错误:100
请键入 NET HELPMSG 3547 以获取更多的帮助
```

- 直接进入db文件夹，先删除 mongod.lock 文件，然后重新启动服务即可；
  要是还不行，就继续删 storage.bson文件，然后问题就解决了~

### net start mongodb报错（服务没有响应控制功能）

```shell
C:\WINDOWS\system32>net start mongodb
服务没有响应控制功能。

请键入 NET HELPMSG 2186 以获得更多的帮助。
```

- 出现这个问题一般是路径有问题。

  1）请注意你所有的路径没有错，包括mongod所在路径，日志所在路径等；

  2）不要加入多余的“\”，如“D:\MongoDB\Data”这个，千万不要写成“D:\MongoDB\Data\”。

  3)  卸载重新安装服务

### net start mongodb报错（发生系统错误 1058，无法启动服务）

```shell
C:\WINDOWS\system32>net start mongodb
发生系统错误 1058。

无法启动服务，原因可能是已被禁用或与其相关联的设备没有启动。
```

- 打开计算机的服务管理界面，找到mongodb服务，右键停止，刷新，就会发现该服务已经没了，关闭该界面，并重新创建服务。

### 在删除服务或者启动服务时，显示指定服务已删除

```shell
C:\WINDOWS\system32>sc delete MongoDB
[SC] DeleteService 失败 1072：
指定的服务已标记为删除


C:\WINDOWS\system32>sc create MongoDB binpath="E:\MongoDB\bin\mongod.exe --dbpath E:\MongoDB\data --logpath E:\MongoDB\logs\mongodb.log  --logappend --auth --service"
[SC] DeleteService 失败 1072：
指定的服务已标记为删除
```

- 关闭此电脑的服务管理界面，重新打开服务管理界面刷新服务。





