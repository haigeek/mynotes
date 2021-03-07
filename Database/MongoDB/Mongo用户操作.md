# Mongo用户操作

新建管理员用户

	use admin
	
	db.createUser(
		  {
			user: "adminuser",
			pwd: "passw0rd",
			roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
		  }
		)
	
	db.auth('adminuser','passw0rd')
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



