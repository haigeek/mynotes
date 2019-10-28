# mongo开启安全验证

开启mongodb安全验证（参考https://docs.mongodb.com/guides/server/auth/）

xxx代表要设置的密码

## windows

1. cmd中启动mongodb

   ```
   "C:\Program Files\MongoDB\Server\3.4\bin\mongod.exe" --dbpath="C:\MongoDB\data" --logpath="C:\MongoDB\logs\mongodb.log"
   ```

2. 登录客户端mongo.exe,设置用户密码

   1. Switch to the admin Database

      ```
      use admin
      ```

   2. Create the user administrator

      ```
      	db.createUser(
      	  {
      		user: "mySuperAdmin",
      		pwd: "xxx",
      		roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
      	  }
      	)
      ```

   3. Create a user for reading and writing to your test database

      ```
      db.createUser(
      	  {
      		user: "userReadWrite",
      		pwd: "xxx",
      		roles: [ { role: "readWriteAnyDatabase", db: "admin" } ]
      	  }
      	)
      	db.createUser(
      	  {
      		user: "userfzbz",
      		pwd: "xxx",
      		roles: [ { role: "dbOwner", db: "fzbz_pdf" } ]
      	  }
      	)
      ```

3. cmd中重启mongodb

   ```
   "C:\Program Files\MongoDB\Server\3.4\bin\mongod.exe" --dbpath="C:\MongoDB\data" --logpath="C:\MongoDB\logs\mongodb.log" --auth
   ```

4. 登录客户端mongo.exe

   1. use admin
   2. db.auth('userfzbz','xxx')

