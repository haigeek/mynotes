# Mongo的安装与配置
## 安装
使用homebrew进行安装

## 配置

### 设置用户名与密码

切换到admin数据库并设置密码

```
use admin
db.createUser({user: 'root', pwd: '123456', roles: ['root']})
```

验证是否添加成功

`'db.auth(用户名，用户密码)'` 这里用`db.auth('root', '123456')` 如果返回 '1'表示验证成功， 如果是 '0' 表示验证失败

为普通数据库设置密码

`use distMongo`

接下来为这个库添加一个用户，并且赋予权限

`db.createUser({user:'dist',pwd:'pass',roles: [{role:'readWrite',db:'distMongo'}]})`

mongo默认是没有开启访问控制的，使用--auth参数重启mongo服务，`mongod --dbpath 存放数据库文件夹路径 --auth`一旦开启了，用户连接mongod必须指定用户名和密码。

