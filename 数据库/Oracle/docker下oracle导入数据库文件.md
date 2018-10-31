docker下oracle数据库导入
# 进入oracle docker环境
> * 假如使用的oracle镜像版本为：wnameless/oracle-xe-11g 这个镜像进入bash默认的用户为root，需要切换到oracle用户下进行操作 *
```shell
进入容器
docker exec -it containerid bash
# 切换为oracle用户
su - oracle 
#设置环境变量（设置过可忽略）
export ORACLE_SID=orcl
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export PATH=$ORACLE_HOME/bin:$PATH
```
# 使用impdp方式进行数据的导入
```shell
# 创建表空间
create tablespace dgpdg logging datafile '/u01/app/oracle/oradata/XE/dgpdg.dbf' size 1500m autoextend on next 100m maxsize 10000m extent management local;

# 创建用户并配置表空间，授权
create user dgpdg identified by pass DEFAULT TABLESPACE dgpdg;
grant dba to dgpdg;

# 创建dump目录,并将dmp文件放在该文件夹下
create directory dmp_dir as '/u01/app/oracle/dump'

# 授权目录读写权限
grant read,write on directory dmp_dir to dgpdg;

# impdp方式导入
impdp dgpsd/pass directory=dmp_dir dumpfile=DGPDG20181009.dmp full=y
```
# 可能遇到的问题
## 数据库编码问题
```shell
Could not convert to environment character set's handle
```
解决方案
```shell
-- 查看当前字符集
select userenv('language') from dual;

USERENV('LANGUAGE')
----------------------------------------------------
AMERICAN_AMERICA.AL32UTF8

-- 字符集修改ing
shutdown immediate;
startup mount
ALTER SYSTEM ENABLE RESTRICTED SESSION;
ALTER SYSTEM SET JOB_QUEUE_PROCESSES=0;
ALTER SYSTEM SET AQ_TM_PROCESSES=0;
alter database open;
ALTER DATABASE character set INTERNAL_USE ZHS16GBK;
shutdown immediate;
startup

-- 修改完毕
select userenv('language') from dual;

USERENV('LANGUAGE')
----------------------------------------------------
AMERICAN_AMERICA.ZHS16GBK
```
## impdp导入失败
```shell
ORA-39002: invalid operation
ORA-39070: Unable to open the log file.
ORA-29283: invalid file operation
ORA-06512: at "SYS.UTL_FILE", line 488
ORA-29283: invalid file operation
```
出现这个问题的原因是因为最开始建立的dump文件夹是在root用户下建立的，oracle用户并没有访问改文件夹的权限，解决方式有两种：
- 将dump文件夹放在oracle用户的文件夹下
- 对root用户下的dump文件夹进行授权

 


