```
# 启动docker并建立映射关系（此步骤不用做了）
sudo docker run -d -p 1521:1521 -p 10022:22 --name=oracle11g -v ~/oracleData:/oracleData filemon/oracle_11g 

# 进入容器中（docker ps命令查看容器中oracle的containerid）
sudo docker exec -it 容器ID /bin/bash

# 配置系统环境变量（此步骤不用做了）
$ vi ~/.bash_profile

export ORACLE_SID=orcl
export ORACLE_HOME=/home/oracle/app/oracle/product/11.2.0/dbhome_2
export PATH=$ORACLE_HOME/bin:$PATH

# 加载环境变量
source /home/oracle/.bash_profile

# sys登陆oracle
sqlplus sys/sys as sysdba

# 删除用户(可选)
drop user jhyzt cascade

# 删除表空间(可选)
drop tablespace dgpims including contents and datafiles cascade constraint;

# 创建表空间
create tablespace dgpnr_ims logging datafile '/oracleData/dgpnr_ims.dbf' size 100m autoextend on next 100m maxsize 10000m extent management local;

# 创建用户并配置表空间，授权
create user dgpnr_ims identified by dgpnr_ims DEFAULT TABLESPACE dgpnr_ims;
grant dba to dgpnr_ims;

# =====exit退出oracle命令行，执行下面的命令（imp方式）=====
imp dgpnr_ims/dgpnr_ims@127.0.0.1/orcl file="/oracleData/dgpnr_ims.dmp" full=y ignore=y statistics=none

# =====执行下面的命令（impdp方式，将dmp文件放到宿主机的~/oracleData目录下）=====
# 创建dgpnr目录
create directory dgpnr as '/oracleData';

# 授权目录读写权限
grant read,write on directory dgpnr to dgpnr_ims;

# expdp导出（可选）
expdp dgpnr_pro/pass@orcl DIRECTORY=dpump dumpfile=dgpnr_pro20190321.dmp logfile=dgpnr_pro20190321.log SCHEMAS=dgpnr_pro

# impdp方式导入
impdp dgpnr_ims/dgpnr_ims@orcl directory=dgpnr dumpfile=DGPNR_PRO20190321.DMP logfile=DGPNR_PRO20190321.log Remap_tablespace=dgpnr_pro:dgpnr_ims Remap_schema=dgpnr_pro:dgpnr_ims;

```

