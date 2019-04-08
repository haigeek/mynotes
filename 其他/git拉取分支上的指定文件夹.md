### git拉取分支上的指定文件夹

```git
# 克隆项目
git clone http://elb-zentao-361931552.cn-northwest-1.elb.amazonaws.com.cn:5335/xdata/SH2018GH115/back-end/dgpoms-server-root.git

#切换到远程dev分支
git checkout -b dev origin/dev

# 开启sparsecheckout模式
git config core.sparsecheckout true

# 设置允许拉取的文件夹
echo dgp-dubbo-server-base >> .git/info/sparse-checkout
echo dgp-dg-server-api >> .git/info/sparse-checkout
...
...

#重新拉取
git checkout dev


参考：https://blog.csdn.net/doujiang_zheng/article/details/78635725
```



### 一个本地分支同时向多个远程分支提交代码

```git
项目根路径中右击git bash

# 添加一个远程仓库
 git remote add origin https://git.oschina.net/Jicklin/bokeyuan.git

其中的origin是仓库的名称 可以换成别的

#再添加另外一个
  git remote set-url --add origin https://github.com/jicklin/bokeyuan.git

 
参考：https://www.jianshu.com/p/dee791260538
```





 

 

 

 