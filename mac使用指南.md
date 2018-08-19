# mac使用指南
### 基本使用
- mac的大小写切换为caplock键
- mac的command可以理解为win的ctrl
- mac才的control在系统中的符号是^，主要作用是在按住control的时候，进行点按，可以做到鼠标右键的效果
- mac中finder中是没有剪切的选项了，要进行剪切操作的时候，先command+c，在要剪切到的位置使用option+command+v即可
- mac退出软件使用 command+q
- 强制退出软件 option+command+esc 
### 终端
mac默认的终端为bash，和Linux的终端是一致的，我们可以使用命令
`cat /etc/shells`
来查看系统支持的终端。可以使用命令
`chsh -s /bin/zsh`来进行终端的切换，zsh表示我要进行切换的终端
### finder
- finder快捷键 command+N
### 截图
系统自带的截图
- command+shift+3 截整个屏幕
- command+shift+4 选择截图
- command+shift+4+空格 截窗口带阴影
- command+shift+4+空格 确定截图面积移动（鼠标按住）
- command+shift+4+shift 拉伸x或者y截图（鼠标按住）
- command+shift+4+option 以中心微为主拉伸（鼠标按住）
## mac的重装系统
在mac下和win下的重装系统逻辑基本一致，我选择磁盘操作-->外置启动盘启动，初次之外还有连接网络下载系统的方式，由于网络的原因，(不推荐)
1. 备份
2. 制作启动盘，在appstore下载系统镜像，使用U盘进行启动盘的制作。
## 环境搭建
### 环境变量
使用
