# mysql命令查询手册
## 常用指令
- 建立数据库
`create datebase [name]`
- 设置数据库编码
`set names utf8`
- 删除数据库
`drop datebase [name]`
- 导出sql文件
`mysqldump -h[主机所在IP] -u[用户名] -p [要导出的数据库]>[导出的路径//[文件名].sql]`
`mysqldump -h localhost -u root -p test1>f://coding/test1.sql`
- 导入sql文件
`source [sql文件path][sql文件名称]`
- 显示数据库所有表
`show tables`
- 显示表的结构
`describe 表名;`
- 显示表的数据
`select * from table`
## 需要注意的问题
- linux下mysql大小写敏感
    >在mysqld下添加
    `lower_case_table_names=1`
    重启 mysql service mysql restart