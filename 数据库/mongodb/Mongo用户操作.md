# Mongo用户操作

新建管理员用户

	db.createUser(
	  {
		user: "mySuperAdmin",
		pwd: "xxx",
		roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
	  }
	)
新建普通用户

```
db.createUser(
    {
    user: "xxx",
    pwd: "xxx",
    roles: [ { role: "dbOwner", db: "ims_jxsj" } ]
    }
)
```

查看所有用户

```
db.system.users.find().pretty()
```

删除用户

```
 db.dropUser('userims_jxsj')
```



