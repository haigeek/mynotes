## docker 安装基本环境

在安装环境的时候需要考虑宿主机与容器的网络通信问题

同一台主机上的docker容器默认的网段是相同的，容器之间是可以互相通信的，但是每次容器启动后的ip会按照网段的ip自动获取

zookeeper

docker -p 2181:2181 192.168.1.2:2181 2181

mongo

-p 

oracle 

-p 

## 安装nginx

本地启动

```
docker run --name nginx -p 8079:80 -v /Users/haigeek/software/docker/nginx/www:/usr/share/nginx/html -v /Users/haigeek/software/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /Users/haigeek/software/docker/nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf --privileged=true nginx
```

服务器配置

```
docker run --name nginx -p 8079:80 -v 
/usr/local/nginx/www:/usr/share/nginx/html -v /usr/local/nginx/conf/nginx.conf:/etc/nginx/nginx.conf --privileged=true nginx
```

启动第二个

```
docker run --name nginx2 -p 8080:80 -v /usr/local/nginx/nginx2/www:/usr/share/nginx/html -v /usr/local/nginx/nginx2/conf/nginx.conf:/etc/nginx/nginx.conf --privileged=true nginx
```





安装oracle



docker run -d -v /Users/haigeek/software/docker/oracleData:/data/oracle_data  -p 1521:1521 wnameless/oracle-xe-11g





```
docker run --name oracle11g -d -v /usr/software/oradata:/oradata -p 1521:1521 -e ORACLE_ALLOW_REMOTE=true registry.cn-shanghai.aliyuncs.com/haigeek/oracle11g:1.0
```



## 安装mongo

拉取镜像

```
docker pull mongo:latest
```

启动容器

```
docker run -itd --name mongo -p 17017:27017 mongo --auth
```

设置用户名与密码









## 安装pg

```
docker run -p 5432:5432 -v /Users/haigeek/software/docker/postgres/pgdata:/var/lib/postgresql/data mypg
```

