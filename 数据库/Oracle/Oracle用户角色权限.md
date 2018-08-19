# Oracle用户角色权限

## Oracle用户管理

创建用户

```
create user username
identified by password
default tablespace tablespace
temporary tablespace tablespace
profile profile
```

查询用户

```
select username, default_tablespace, temporary_tablespace from dba_users;--查询用户默认表空间，临时表空间
select * from dba_profiles;--查询系统资源文件名
```

创建用户的profile文件

```
 create profile student limit  // student为资源文件名
 FAILED_LOGIN_ATTEMPTS  3  //指定锁定用户的登录失败次数
 PASSWORD_LOCK_TIME 5  //指定用户被锁定天数
 PASSWORD_LIFE_TIME 30  //指定口令可用天数
```

修改用户

```
1、修改口令字：
SQL>Alter user acc01 identified by "12345";
2、修改用户缺省表空间：
SQL> Alter user acc01 default tablespace users;
3、修改用户临时表空间
SQL> Alter user acc01 temporary tablespace temp_data;
4、强制用户修改口令字：
SQL> Alter user acc01 password expire;
5、将用户加锁
SQL> Alter user acc01 account lock;  // 加锁
SQL> Alter user acc01 account unlock;  // 解锁
```

监视用户

```sql
1、查询用户会话信息：
SQL> select username, sid, serial#, machine from v$session;
2、删除用户会话信息：
SQL> Alter system kill session 'sid, serial#';
3、查询用户SQL语句：
SQL> select user_name, sql_text from v$open_cursor;
```

删除用户

```sql
SQL>drop user 用户名;  //用户没有建任何实体
SQL> drop user 用户名 CASCADE;  // 将用户及其所建实体全部删除
注意：当前正连接的用户不得删除。
```

## Oracle角色管理

角色是一组权限的集合，将角色赋给一个用户，这个用户就拥有了这个角色中的所有权限

### 系统预定义角色

预定义角色是在数据库安装后，系统自动创建的一些常用的角色。

1. CONNECT, RESOURCE, DBA

2. DELETE_CATALOG_ROLE， EXECUTE_CATALOG_ROLE， SELECT_CATALOG_ROLE
   这些角色主要用于访问数据字典视图和包。

3. EXP_FULL_DATABASE， IMP_FULL_DATABASE  

   这两个角色用于数据导入导出工具的使用。

4. AQ_USERROLE， AQ_ADMINISTRATOR_ROLE

   这两个角色用于oracle高级查询功能。

5. SNMPAGENT
   用于oracle enterprise manager和Intelligent Agent

6. RECOVERY_CATALOG_OWNER
   用于创建拥有恢复库的用户。

7. HS_ADMIN_ROLE
   A DBA using Oracle's heterogeneous services feature needs this role to access appropriate tables in the data dictionary.

### 管理角色

1. 建立一个角色

   create role role1;

2. 授权给角色

   grant create any table,create procedure to role1;

3. 授予角色给用户

   grant role1 to user1;

4. 查看角色所包含的权限

   select * from role_sys_privs

5. 创建带有口令的角色

   create role role1 indentified by password1;

6. 修改角色：是否需要口令

   alter role role1 not indentified

   alter role role1 indentified by password1

7. 设置当前用户要生效的角色

   ```sql
   sql>set role role1;//使role1生效
   sql>set role role,role2;//使role1,role2生效
   sql>set role role1 identified by password1;//使用带有口令的role1生效
   sql>set role all;//使用该用户的所有角色生效
   sql>set role none;//设置所有角色失效
   sql>set role all except role1;//除role1外的该用户的所有其它角色生效。
   sql>select * from SESSION_ROLES;//查看当前用户的生效的角色。
   ```

8. 修改指定用户，设置其默认角色

   alter user user1 default role role1;

9. 删除角色

   drop role role1

   角色删除后，原来拥用该角色的用户就不再拥有该角色了，相应的权限也就没有。

10. 不能使用WITH GRANT OPTION为角色授予对象权限，可以使用WITH ADMIN OPTION 为角色授予系统权限,取消时不是级联

## Oracle权限管理

### 权限分类

系统权限：系统规定用户使用数据库的权限。（系统权限是对用户而言)。

实体权限：某种权限用户对其它用户的表或视图的存取权限。（是针对表或视图而言的）。

### 系统权限管理

1. 系统权限分类

   DBA: 拥有全部特权，是系统最高权限，只有DBA才可以创建数据库结构。

   RESOURCE:拥有Resource权限的用户只可以创建实体，不可以创建数据库结构。

   CONNECT:拥有Connect权限的用户只可以登录Oracle，不可以创建实体，不可以创建数据库结构。

   对于普通用户：授予connect、resource权限

   对于dba用户：授予connect、resource权限

2. 系统权限授权命令

   系统权限只能有DBA用户授出：sys/system（最开始是这两个用户）

   授权命令：SQL> grant connect, resource, dba to 用户名1 [,用户名2]...;

   普通用户通过授权可以具有和system相同的权限，但是不能达到和sys相同的用户权限，system用户的权限也可以被回收

   ​

3. 系统权限传递与回收

   增加with admin opinion 选项，则得带的权限可以传递

   ```
   grant connect, resorce to user1 with admin option;  //可以传递所获权限。
   ```

   系统权限的回收只能由DBA用户回收

   ```
   revoke connect,resource from user1
   ```

   如果使用WITH ADMIN OPTION为某个用户授予系统权限，那么对于被这个用户授予相同权限的所有用户来说，取消该用户的系统权限并不会级联取消这些用户的相同权限。

   系统权限无级联，即A授予B权限，B授予C权限，如果A收回B的权限，C的权限不受影响；系统权限可以跨用户回收，即A可以直接收回C用户的权限。

### 实体权限管理

1. 实体权限分类

   select,update,insert,alter,index,delete,all(all包含所有权限),execute(执行存储过程的权限)

2. 实体权限的授予

   将权限授予用户

   ```
    grant select, update, insert on product to user02;
    grant all on product to user02;
   ```

   将表的操作授予全体用户

   ```
   grant all on tablename to public
   ```

3. dba的实体权限

   DBA用户可以操作全体用户的任意基表(无需授权，包括删除)

4. 实体权限传递与回收

   ```
   grant select, update on product to user02 with grant option; // user02得到权限，并可以传递。
   Revoke select, update on product from user02;  //传递的权限将全部丢失。
   ```

   如果取消某个用户的对象权限，那么对于这个用户使用WITH GRANT OPTION授予权限的用户来说，同样还会取消这些用户的相同权限，也就是说取消授权时级联的。