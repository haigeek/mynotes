# js基础知识

## javasprict输出

### 操作html元素

使用 document.getElementById(id) 方法，使用 "id" 属性来标识 HTML 元素

### 写到文档输出

	<!DOCTYPE html>
	<html>
	<body>
	
	<h1>My First Web Page</h1>
	
	<script>
	document.write("<p>My First JavaScript</p>");
	</script>
	
	</body>
	</html>
### 警告

使用 document.write() 仅仅向文档输出写内容,如果在文档已完成加载后执行 document.write，整个 HTML 页面将被覆盖：

	<!DOCTYPE html>
	<html>
	<body>
	
	<h1>My First Web Page</h1>
	
	<p>My First Paragraph.</p>
	
	<button onclick="myFunction()">点击这里</button>
	
	<script>
	function myFunction()
	{
	document.write("糟糕！文档消失了。");
	}
	</script>
	
	</body>
	</html>
## js语句

 JavaScript 语句向浏览器发出的命令。语句的作用是告诉浏览器该做什么。JavaScript 是脚本语言。浏览器会在读取代码时，逐行地执行脚本代码。而对于传统编程来说，会在执行前对所有代码进行编译。

### 分号

分号用于分隔 JavaScript 语句，通常我们在每条可执行的语句结尾添加分号。

### js代码

浏览器会按照编写顺序来执行每条语句。


- js代码块

  块的作用是使语句序列一起执行，JavaScript 函数是将语句组合在块中的典型例子。

- js对大小写敏感
- js会忽略多余的空格
- 对代码块进行折行

  可以在文本字符串中使用反斜杠对代码行进行换行

## js变量

  可以把变量看做存储数据的容器。

### JavaScript变量

- 变量必须以字母开头
- 变量也能以$ 和 _ 符号开头（不推荐）
- 变量名称对大小写敏感（y 和 Y 是不同的变量），JavaScript 语句和 JavaScript 变量都对大小写敏感。

### JavaScript数据类型

  JavaScript 变量有很多种类型，字符串、数字、布尔、数组、对象、Null、Undefined，主要使用数字和字符串。

- 对象由花括号分隔。在括号内部，对象的属性以名称和值对的形式 (name : value) 来定义。属性由逗号分隔：

  	var person={firstname:"Bill", lastname:"Gates", id:5566};

  空格和折行无关紧要

  对象属性有两种寻址方式

  	name=person.lastname;
  	name=person["lastname"];

### 声明JavaScript变量

- 使用var关键词来声明变量
- 对变量赋值使用等号，也可以在声明时赋值
- 以在一条语句中声明很多变量。该语句以 var 开头，并使用逗号分隔变量即可
- 如果重新声明 JavaScript 变量，该变量的值不会丢失

## js函数

### JavaScript中函数语法

函数就是包裹在花括号中的代码块，前面使用了关键词 function：

```
function functionname()
{
这里是要执行的代码
}
```

### 调用带参数的函数

```
myFunction(argument1.argument2)
fouction myFunction(var1,var2)
{
  执行代码
}
```

### 带有返回值的函数

有时，我们会希望函数将值返回调用它的地方，通过使用 return 语句就可以实现，在使用 return 语句时，函数会停止执行，并返回指定的值

### JavaScript局部与全局变量

- 在 JavaScript 函数内部声明的变量（使用 var）是*局部*变量，所以只能在函数内部访问它，（该变量的作用域是局部的），可以在不同的函数中使用名称相同的局部变量，因为只有声明过该变量的函数才能识别出该变量，只要函数运行完毕，本地变量就会被删除。
- 局部变量会在函数运行以后被删除，全局变量会在页面关闭后被删除。
- 如果把值赋给尚未声明的变量，该变量将被自动作为全局变量声明。

## JavaScript循环

### 不同的循环

JavaScript 支持不同类型的循环：

- *for* - 循环代码块一定的次数
- *for/in* - 循环遍历对象的属性
- *while* - 当指定的条件为 true 时循环指定的代码块
- *do/while* - 同样当指定的条件为 true 时循环指定的代码块

### for/in循环

```
var person={fname:"John",lname:"Doe",age:25};

for (x in person)
  {
  txt=txt + person[x];
  }
```

# JS HTML DOM

## DOM简介

当网页被加载时，浏览器会创建页面的文档对象模型（Document Object Model），HTML DOM 模型被构造为对象的树。通过可编程的对象模型，JavaScript 获得了足够的能力来创建动态的 HTML。

- JavaScript 能够改变页面中的所有 HTML 元素
- JavaScript 能够改变页面中的所有 HTML 属性
- JavaScript 能够改变页面中的所有 CSS 样式
- JavaScript 能够对页面中的所有事件做出反应

### 查找html元素

- 通过id查找

  ```
  var x=document.getElementById("intro");
  ```

- 通过标签名查找html元素

  ```
  //查找 id="main" 的元素，然后查找 "main" 中的所有 <p> 元素
  var x=document.getElementById("main");
  var y=x.getElementsByTagName("p");
  ```