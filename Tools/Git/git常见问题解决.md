## 常见问题的解决

git推送到远程错误的文件怎么处理

先回退到前一个版本：

`git reset --hard HEAD^`

然后强制推送当前这个版本到云端

`git push origin HEAD --force`

git取消对某个文件的追踪

```
$ git rm --cached <filename>

如果是目录的话：

$ git rm -r --cached <foldername>

```

git 合并某个分支的某个文件或者文件夹

```
git checkout dev /root/src/main/xxxx
```

其中 `/root/src/main/xxxx`表示路径 可以是具体的文件 也可以文件夹

## git使用情境

- 在本地将一个文件夹初始化为一个仓库，然后又在远程新建了一个仓库，怎么将本地和远程仓库关联

1. 首先尝试将本地的仓库和远程，使用命令 `git remote add origin [url]`
2. git 提示我们将本地的分支与远程的分支进行关联，使用`git push --set-upstream origin master`
3. 将远程仓库的数据使用 `git pull ...` 进行拉取，这个命令相当于拉取并合并，但是在和本地的分支进行合并的时候，会出现冲突
   `fatal: refusing to merge unrelated histories` 这是因为git 认为合并了两个不同的开始提交的仓库，这两个仓库可能不是同一个。
4. 使用`git pull origin master --allow-unrelated-histories`来进行合并来告诉git我们将这两个仓库进行合并
5. 建议还是先在远程积进行仓库的建立再clone本地进行开发
6. 更新远程分支列表  git remote update origin  --prune