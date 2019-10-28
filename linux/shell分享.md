# shell脚本分享

## 一、介绍shell

Shell 是一个用 C 语言编写的程序，它是用户使用 Linux 的桥梁。Shell 既是一种命令语言，又是一种程序设计语言。

Shell 是指一种应用程序，这个应用程序提供了一个界面，用户通过这个界面访问操作系统内核的服务。

Shell 脚本（shell script），是一种为 shell 编写的脚本程序。

业界所说的 shell 通常都是指 shell 脚本。

shell 编程跟 JavaScript、php 编程一样，只要有一个能编写代码的文本编辑器和一个能解释执行的脚本解释器就可以了。



为什么使用shell脚本？

简化对于多个重复命令的操作，适用于批处理。（原本是觉得docker没有怎么简化操作，每次都要敲那么多代码，后来发现可以用shell脚本写脚本批处理运行之）。



shell脚本以.sh为文件名的后缀(不强制，规范而已)

脚本第一行以`#!/bin/bash`或者 `#!/bin/sh` 开头（不是必须的）

执行：

	1. chmod +x 脚本名 : 授予执行权 然后可以 ./文件名运行
 	2. sh 脚本名
 	3. /bin/bash 脚本名
 	4. bash 脚本名



## 二、代码实操

### hello world

```shell
vim helloworld.sh

#!/bin/bash
echo "hello wolrd!!!"
```

运行

```shell
sh helloworld.sh
```



### 变量

```shell
# 给变量名赋值  注意等于号中间没有括号
变量名=变量值

#使用变量名
$变量名 或者  ${变量名}

#只读变量
readonly 变量名=变量值;
#变量名=变量值2;   标记了只读变量 修改会报错

#删除变量
unset 变量名
```

```shell
#!/bin/sh
  # 变量可以写在一行
  v1=1 v2="aa";
  # 将文件名赋值给变量v3
  v3=$0
  # 这里建议使用${}的形式使用变量
  echo "v1=${v1}, v2=$v2, v3=$v3"
  # 将打印结果赋值给变量 files
  files=`ls /usr/dev/sh`
  # 遍历输出
  for f in $files
  do
    echo $f;
  done
  
  readonly myUrl="www.qqq";
  #myUrl="111111";
  echo $myUrl

```



- 局部变量

  在函数中定义局部变量使其不影响函数外的同名变量

  ```shell
  #!/bin/sh
  
  c=3
  function f1() {
  	local a=1;
  	b=2;
  	echo "函数内变量a=$a";
  	echo "函数内变量b=$b";
  	echo "函数内变量c=$c";
  }
  f1;
  echo "函数外变量a=$a";  #不打印
  echo "函数外变量b=$b";  #打印
  echo "函数外变量b=$c";  #打印
  ```

  demo中的12行获取不到变量a的值，因为a是函数内的局部变量

- shell文件内部变量(全局变量)

  shell变量是由shell程序设置的特殊变量。shell变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了shell的正常运行

  上面的demo可以看出变量B可以被函数外部引用，那么b就是一个全局变量

  

- 环境变量

  所有的程序，包括shell启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。必要的时候shell脚本也可以定义环境变量。

  使用`env`或者`export`可以查看环境变量

  ```shell
  echo $HOME
  ```

  将变量升级为环境变量

  export str="aaa";

  或者 str="aaa";

  ​	export str

  只对当前用户的当前shell和子shell有效，退出脚本和退出登录后也失效

  - 设置永久的环境变量

   ```shell
  echo "NAME='QIAO'" >> /etc/profile
  # 查看profile中设置的内容
  cat /etc/profile|grep "NAME='QIAO'"
  #然后刷新profile文件
  source /etc/profile
  echo $NAME
  # 删除文件中的最后一行
  sed -i '$d' profile
   ```

- 位置变量和特殊变量

  - 位置变量

    ```shell
    #!/bin/sh
    echo $0
    echo "第一个:$1"
    echo "第二个:$2"
    echo "第三个:$3"
    echo "第四个:$4"
    echo "第五个:$5"
    shift 5;  #踢除前五个  下标会从1开始
    echo "第一个:$1"
    echo "第二个:$2"
    echo "第三个:$3"
    echo "第四个:$4"
    echo "第五个:$5"
    echo "第六个:$6"
    echo "第七个:$7"
    echo "第八个:$8"
    echo "第九个:$9"
    echo "第十个:$10"
    echo "第十一个:$11"
    ```

    sh lo.sh 1 2 3 4 5 6 7 8 9 10 11

    

  - 特殊变量

    ```shell
    $?：（常用）上一条代码执行的回传指令，回传0表示标准输出，即正确执行，否则为标准错误输出。
    $$：当前shell的PID。除了执行bash命令和shell脚本时，$$不会继承父shell的值，其他类型的子shell都继承。
    $BASHPID：当前shell的PID，这和"$$"是不同的，因为每个shell的$BASHPID是独立的。而"$$"有时候会继承父shell的值。
    $!：最近一次执行的后台进程PID。
    $#：（常用）统计参数的个数。	
    $@：（常用）所有单个参数，如"a""b""c""d"。
    $*：以一个单字符串显示所有向脚本传递的参数，如“abcd”。
    $0：（常用）脚本名。
    $1……$n：（常用）参数位置。
    ```

    lo.sh

    ```shell
    #!/bin/sh
    echo '$?:'$?
    echo '$$:'$$
    echo '$!:'$!
    echo '$#:'$#
    echo '$@:'$@
    echo '$*:'$*
    echo '$0:'$0
    echo '$1:'$1
    echo '$2:'$2
    echo '$3:'$3
    echo '$4:'$4
    for item in $@
    do
      echo $item
    done
    ```

    常用 `$?`,  `$#` `$@` `$0` `$1...$n`

### 数组

- 普通数组

  第一种 arr=(A B)

  ```shell
  #!/bin/sh
  arr=(1 2 3 4)
  echo ${arr[2]}
  ```

  这里要注意 数组内的元素以空格隔开 不是逗号

  第二种：自定义索引位置

  ```shell
  arr2[0]="a"
  arr2[2]="b"
  echo ${arr2[0]};
  echo ${arr2[2]}
  
  # 使用*或者打印数组内得所有元素
  echo ${arr2[*]}
  echo ${arr2[@]}
  
  # 获取数组的索引
  echo ${!arr2[*]}
  echo ${!arr2[@]}
  
  # 显示下标为1的数组变量的字符长度
  echo ${#arr2[0]}
  
  # 显示数组中的元素个数（只统计值不为空的元素）
  echo ${#arr2[*]}  
  echo ${#arr2[@]}
  ```

   下标可以不按顺序写

- 关联数组

  关联数组支持字符串作为数组索引。使用关联数组必须先使用declare -A声明它。

  ```shell
  # 声明一个关联数组
  declare -A arr3
  arr3=([name1]=zhangshan [name2]=li)
  echo ${arr3[name1]}
  
  declare -A arr4
  arr4[name1]=qiao
  arr4[name2]=gege
  echo ${arr4[name1]}
  
  # 查看数组的所有值  值是倒叙的 gege qiao这样
  echo ${arr4[*]}
  echo ${arr4[@]}
  
  # 查看数组的长度
  echo ${#arr4[*]}
  echo ${#arr4[@]}
  ```

  数组内元素的截取与替换
  
  ```shell
  # -----------数组的截取与替换-------
  arr5=(1 2 3 4 5 4)
  # 修改单个值
  arr5[1]=6;
  # 从数组全部元素中第2个元素向后截取2个元素出来（即3 4）
  arr5_1=${arr5[*]:2:2}
  # 将数组中的5替换称6
  arr5_2=${arr5[*]/4/6}
  
  echo ${arr5_1[*]};
  echo ${arr5_2[*]};
  ```
  
  遍历数组 #注意for后面的分号 ; 
  
  ```shell
  #!/bin/sh
  
  arr=(1 2 3 4 "qiao")
  
  # 通过元素的值
  for i in ${arr[*]}; do
      echo $i
  done
  
  # 通过索引
  for idx in ${!arr[*]}; do
     echo ${arr[${idx}]}
  done
  
  # 通过元素的个数
  for ((i=0; i<${#arr[*]};i++)); do
     echo ${arr[$i]}
  done
  
  # 遍历当前文件所在文件夹下的所有文件
  PRG="$0"  #文件名
  PRGDIR=`dirname "$PRG"` # 当前文件所在的文件夹
  echo $PRGDIR;
  
  for i in `ls ${PRGDI}`;do  # 遍历
      echo $i
  done
  ```
  

### String

```shell
#!/bin/sh
str="aaa"
echo "${str=111}"  # 默认为111

#字符串长度
str="abc"
echo ${#str}

# 字符串截取
str="abcdefcg"
echo ${str:5}

#指定长度截取 下标从0开始
echo ${str:2:3}

#从开头字符串删除 支持正则表达式 删除从a到c
echo ${str#a*c}

# 从开头开始删除最长的a到c串
echo ${str##a*c}

#从结尾删除 
echo ${str%f*g}

#从结尾删除最长的子串
echo ${str%%c*g}

# 字符串替换
# 用TEST替换str中的第一个bac
echo ${str/abc/TEST}

#  用m替换str中的所有c
echo ${str//c/m}

# 从str开头，用TEST替换最长的a*c
echo ${str/#a*c/TEST}

##### 使用  expr 操作字符串
str='1994-12-18'
len=`expr length $str`
echo $len

# 截取字符串
substr=`expr substr $str 1 4`

# 获取字符串的下标 下标从1开始  不存在返回0 如果是12结果就不正确--未解决
index=`expr index "$str" "2"`
echo $index

# split字符串
str="1994-12-18"
arr=(${str//-/})
echo ${arr[@]}

# 字符串连接
str1="qiao"
str2="gege"
echo ${str1}${str2}
```

博文链接: [Shell字符串操作大全](https://blog.csdn.net/u010376788/article/details/50463191)

```shell
(1) ${value:-word} # 这个常用来给变量默认值
	当变量未定义或者值为空时,返回值为word的内容,否则返回变量的值.
(2) ${value:=word}
	若变量未定义或者值为空时,在返回word的值的同时将word赋值给value
(3) ${value:?message}  ## 为空抛异常终止程序
	若变量有值的话,正常替换.否则将消息message送到标准错误输出(若	
	此替换出现在Shell程序中,那么该程序将终止运行)
(4) ${value:+word}
	若变量有值的话,其值才用word替换,否则不进行任何替换


# shell变量处理
#${value:-word}  若变量未定义或者值为空返回world， 否则返回value
str=""
echo "1: ${str:-hello}"

# 如果变量str不存在(未定义)返回world 否则返回str
echo "2: 变量不存在测试 ${qiao=world}"

# 如果str有值， 则返回world
str="abc"
echo "3: ${str:+world}"

# 如果str未空 抛异常 程序终止
echo "4: ${str:?我是异常信息}"
```

### 函数

 创建的两种方式

 注意：函数体之间不能为空

 ```shell
#!/bin/sh

f1() {
  echo $1
}
f1 22;

function f2(){
   echo "ni hao "  
}
f2

#  有返回值的函数
funWithReturn(){
    echo "这个函数会对输入的两个数字进行相加运算..."
    echo "输入第一个数字: "
    read aNum
    echo "输入第二个数字: "
    read anotherNum
    echo "两个数字分别为 $aNum 和 $anotherNum !"
    return $(($aNum+$anotherNum))
}
funWithReturn
echo "输入的两个数字之和为 $? !"

# 下面返回字符串运行将会报错 只能返回数字
function returnstr () {
        return "aa"
}
returnstr
$?
 ```

函数调用： 直接在函数名后面跟参数 参数之间以空格隔开（注意不是逗号）

函数的取值：使用`$1...$n`

返回值：$?， 只能返回数字



常用 `$? : 返回值`,  `$# ：参数个数` `$@ ：所有单个参数`  `$1...$n ： 顺序取值`,

 `$? :显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。 ` 可以用这个来判断上一个函数是否成功运行

### 循环与控制语句

循环标签

`for`

​	for循环在数组里面已经介绍过, 这里略过

`while`

```shell
#!/bin/sh

# 计算从1加到10
sum=0;
i=1;
while ((i <= 10))
do
 ((sum += i))
 ((i++))
done
echo ${sum}

# 遍历数组
arr=(1 2 3 4);
i=0
while ((i < ${#arr[*]}))
do
 echo ${arr[$i]}
 ((i++))
done
```

控制标签

`if`

```shell
if [ command ];then
     符合该条件执行的语句
elif [ command ];then
     符合该条件执行的语句
else
     符合该条件执行的语句
fi
```

注意：

```
1、[ ]表示条件测试。注意这里的空格很重要。要注意在'['后面和']'前面都必须要有空格
2、在shell中，then和fi是分开的语句。如果要在同一行里面输入，则需要用分号将他们隔开。
3、注意if判断中对于变量的处理，需要加引号，以免一些不必要的错误。
4、判断是不支持浮点值的
5、如果只单独使用>或者<号，系统会认为是输出或者输入重定向，虽然结果显示正确，但是其实是错误的，因此要对这些符号进行转义
6、数值比较时，建议双方同时加0，避免变量为空时报错
7、当变量可能为空的时候，强烈建议在变量的基础上加上其他辅助字符串
```

```shell
#!/bin/sh
v1=10;
v2="aa"

# v1有可能为空 加x防止空报错
if [ "${v1}x" = "10x" ]; then
        echo "v1等于10"
fi

# 这里加0也是为了防止空指针
if test $(($v1+0)) -eq $((10+0))
then
  echo "v1也等于10"
fi

v3="aa"
# -z检验字符串为空  [ ! -z ${v3} ] 否定校验字符串不为空
if [ -z ${v3} ]; then
 echo "v3为空";
elif [ "$v3x" = "bbbx" ]; then
 echo "v3为bbb"
else
  echo "v3为其他值${v3}"
fi

# -n 校验不为空
if [ -n ${v3} ]; then
  echo "v3不为空"
fi;

v4="abc.jar";
v5="abc.jar.jpa";
# 简单的正则表达式校验字符串的开头和结尾
if [[ "$v4" =~ "jar"$  ]]; then
 echo "v4以jar结尾";
fi;
if [[ "$v5" =~ ^"abc" ]]; then
 echo "v5以abc开头";
fi
```

`case`

```
case 值 in
模式1)
    command1
    command2
    command3
    ;;
模式2）
    command1
    command2
    command3
    ;;
*)  #相当于default
    command1
    command2
    command3
    ;;
esac
```

```shell
#!/bin/sh

echo 'Input a number between 1 to 4'
echo 'Your number is:\c'
read aNum
case $aNum in
    1)  echo 'You select 1'
    ;;
    2)  echo 'You select 2'
    ;;
    3)  echo 'You select 3'
    ;;
    4)  echo 'You select 4'
    ;;
    *)  echo 'You do not select a number between 1 to 4'
    ;;
esac

```



### 脚本之间的调用

当前脚本中的变量在子脚本中都可以访问（包括局部变量)

脚本 cont.sh

```shell
PRG="$0";
PRGDIR=`dirname "$PRG"`;
function func() {
 local v1="qiao";
 v2="gege"
 . "${PRGDIR}/subcont.sh";
 echo "子脚本中的c = $c";
}
func;
```

脚本 subcont.sh

```shell
echo “父脚本中的a = $v1“;
echo ”父脚本中的b = $v2”;
c="uncleqiao"
```

结果

```shell
“父脚本中的a = qiao“
”父脚本中的b = gege”
子脚本中的c = uncleqiao
```

## 三、介绍一个简单的部署脚本