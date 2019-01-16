# expdp impdp使用
参考 http://blog.51cto.com/yemingtian/1851919
## 创建远程连接
假如我需要拷贝远程的数据库数据并将其迁移到我本机上，那么我不需要登录远程服务器，直接在本机与远程数据库建立连接即可
create public database link
connect to DGPDG identified by pass
using 'ip address/orcl';

## 创建导出目录 
创建逻辑目录，该命令不会在操作系统创建真正的目录（最好手工先建好），最好以administrator等管理员创建。

`SQL>create directory dir as 'd:\dump'; --dir名称可以随便命名 是oracle可识别的名字 但是存储目录 d:\dump 需要在系统硬盘上手工创建`

## 向用户授权读写目录
给用户赋予在指定目录下的读写权限

`Grant read,write on directory dir_name to user_name;`

## 执行导出
1. 按照表模式导出
2. 按照查询条件导出
3. 按照表空间导出
4. 按照用户导出
5. 导出整个数据库
## 执行导入
1. 按照表导入
2. 按照用户导入
3. 按照表空间导入
4. 全库导入
## 转换表空间迁移数据


expdp system/sys directory=dir_dp dumpfile=dgpfp.dmp logfile=dgpdg20171115.log SCHEMAS=dgpfp  

总结：
执行impdp时无需创建b用户，在导入时会自动创建并改名用户a为b（拥有a的所有权限等），自动设置默认表空间为转换后的表空间b。如果有多个表空间需要转换，则使用多个remap_tablespace=源表空间：目标表空间。此种方法只限于支持oracle10g以上版本。

expdp system/sys directory=exp_dir dumpfile=dgpfp.dmp logfile=dgpfp20180411.log SCHEMAS=dgpfp  

create directory expdir as 'D:/exp_dir';

expdp system/sys@orcl directory=expdir dumpfile=dgpfp20180411.dmp logfile=dgpdg20180411.log SCHEMAS=dgpfp

impdp system/sys@orcl directory=expdir dumpfile=dgpfp20180411.dmp remap_tablespace=dgpfp:dgpdg remap_schema=dgpfp:dgpdg logfile=impdgpfp.log

impdp dgpmobile/pass@orcl directory=expdir dumpfile=DGPTZHOU20180711.DMP remap_tablespace=dgptzhou:dgpmobile remap_schema=dgptzhou:dgpmobile logfile=impdgptzhou.log

impdp dgpdglc/pass@orcl directory=expdir dumpfile=DGPOMS.DMP remap_tablespace=dgpoms:dgpdglc remap_schema=dgpoms:dgpdglc logfile=impdgpoms.log

