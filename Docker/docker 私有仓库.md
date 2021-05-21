# docker 私有仓库

docker配置私有仓库

```
vim  /etc/sysconfig/docker

# OPTIONS='--insecure-registry 161.189.83.164'    #CentOS 7系统
# other_args='--insecure-registry 10.20.26.52:5000' #CentOS 6系统
```

添加镜像源

```
 /etc/docker/daemon.json
```

添加

```
{
		"registry-mirrors": ["https://registry.cn-hangzhou.aliyuncs.com"]
}
```

重启

```
systemctl daemon-reload
```



## # 登录私服

## 创建私有仓库

docker run -d -p 5000:5000 --restart=always -v /opt/data/registry:/var/lib/registry --name registry registry

-d 后台运行

-p 5000:5000 端口映射

-v  /opt/data/registry:/var/lib/registry 将docker中的镜像仓库文件镜像地址映射到宿主机的 /opt/data/registry 文件夹

-name registry 文件启动名称

## 上传镜像到私有仓库

### 1、为镜像打tag

将本地镜像标记为私有仓库的镜像

docker tag hello-docker:latest 127.0.0.1:5000/hello-docker:latest

### 2、上传镜像到私有仓库

 docker push 127.0.0.1/hello-docker:latest

### 3、验证镜像是否成功上传到私有仓库

curl 127.0.0.1:5000/v2/_catalog

或者打开浏览器 访问http://127.0.0.1:5000/v2/_catalog 查看输出

### 取消HTTPS 上传限制

如果你不想使用 127.0.0.1:5000 作为仓库地址，比如想让本网段的其他主机也能把镜像推送到私有仓库。你就得把例如 192.168.199.100:5000 这样的内网地址作为私有仓库地址，这时你会发现无法成功推送镜像。

## 客户端从私有仓库上pull镜像

修改etc/sysconfig/docker配置文件

添加如下内容

OPTIONS=’–insecure-registry 192.168.1.40:5000′**（IP地址及端口，可根据实际情况填写）**

修改后，重启docker服务

## 私有仓库镜像的删除

删除需要进行两步操作

1.  使用删除api进行镜像的删除
2. 进入镜像文件夹进行垃圾回收

