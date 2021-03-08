# git fork项目

如何和远程保持更新？

主要的操作命令：

1. 查看目前仓库可以远程更新的信息
    git remote -v
2. 配置一个远程更新链接，要拥有git仓库访问权限的
    git remote add upstream [git@github.com](mailto:git@github.com):xxx/xxx.git
3. 拉取远程仓库的代码
    git fetch upstream
4. 合并远程仓库的代码
    git merge upstream/master
5. 把远程仓库的代码作为新源提交到自己的服务器仓库中
    git push

#### 

```
git branch branch_name   remote_name/branch 
```

 基于远程仓库创建新分支

```
git checkout -b branch_name   remote_name/branch
```

基于远程仓库创建新分支并且切换到新分支

