Oracle数据库监听配置常见问题
- ORA-12710 连接超时
> 解决：可能是防火墙问题，在入站规则添加对应的端口即可，默认端口为1521
- ORA-12514 TNS 监听程序当前无法识别连接描述符中请求服务
> 解决：使用net configuration assistant重新配置本地网络名配置
- 使局域网的电脑可以访问本机的数据库
> 在服务端的listener.ora文件进行如下编辑，除了localhost之外，添加一行地址设置本机ip
```xml
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
      (ADDRESS = (PROTOCOL = TCP)(HOST = 你的主机IP地址)(PORT = 1521))
    )
  )
```