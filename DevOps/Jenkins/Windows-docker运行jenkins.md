使用docker安装jenkins，使用jenkins构建的时候希望使用宿主机的docker进行打包和发布。

在使用默认的配置时，输入docker ps 命令，会提示

```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

处理方式：

在运行jenkins镜像的时候将宿主机的docker.sock文件进行挂载

```
-v /var/run/docker.sock:/var/run/docker.sock 
```

虽然在Windows目录下并不能找到这个位置，但是确实可以使用，参考[此处](https://forums.docker.com/t/solved-using-docker-inside-another-container/12222)

完整运行命令如下

```
docker run --name jenkins -d -p 8888:8080 -p 50000:50000 -v /d/jenkins:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkinsci/blueocean:latest
```

需要注意的是

`/var/run/docker.sock`的所有者和组都是`root`，其他用户不允许独写。

而blueocean镜像，jenkins是以`jenkins`用户运行的，所以无法访问。

因此以管理员身份进入容器，执行命令

```
sudo chmod a+rw /var/run/docker.sock
```

