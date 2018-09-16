# nginx使用遇到的问题
在windows下启动失败，报错：
```shell
nginx: [emerg] bind() to 0.0.0.0:80 failed (10013: An attempt was made to access
 a socket in a way forbidden by its access permissions)
```
问题：端口占用，经排查是iis占用了80端口