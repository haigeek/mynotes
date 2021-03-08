# Java常见异常总结
## 异常的分类
### 异常的继承结构

![image-20190328224810387](https://ws4.sinaimg.cn/large/006tKfTcly1g1iw8aret8j317m0pk404.jpg)

Error,Exception继承于Throwable，在java中只有Throwable的异常才可以被抛出或者捕获，它是异常处理机制的基本组成类型。

RuntimeException，IOException继承于Exception,Error和RuntimeException及其子类成为未检查异常（unchecked），其它异常成为已检查异常（checked）Error和RuntimeException及其子类成为未检查异常（unchecked），其它异常成为已检查异常（checked）

- Error
  一般是指与虚拟机有关的问题，如系统崩溃，虚拟机错误，内存空间不足，方法调用栈溢。对于这类错误的导致的应用程序中断，仅靠程序本身无法恢复和预防，遇到这样的错误，建议是让程序停止
- Exception
  Exception异常一个派生于RuntimeException，另一个分支包含其他异常，是可以处理的异常,可以捕获且可能恢复，遇到这类异常，应该尽可能处理异常，使程序恢复运行，而不应该随意终止异常

Exception 又分为可检查（checked）异常和不检查异常

- unchecked异常
  派生于Error类和RuntimeException类的异常成为非受查异常，指的是程序的瑕疵和错误，并在运行时无法恢复

- check异常
  代表程序不能直接控制的无效的外界的情况（如用户输入，数据库问题，网络异常，文件丢失等），Java认为Checked异常都是可以被处理的异常，所以Java程序必须显示处理Checked异常。如果程序没有处理Checked异常，该程序在编译时就会发生错误无法编译。
## 常见异常的总结
|   类型|  异常名称 |说明   |
| ------------ | ------------ | ------------ |
| RuntimeException  |OutOfMemoryError   | 内存溢出  |
| RuntimeException |  IndexOutOfBoundsException | 数组访问越界  |
| RuntimeException  | NullPointerException  | 空指针异常  |
| RuntimeException  | ClassCastException  | 类型转换异常  |
|  RuntimeException |  ArithmeticExecption | 算术异常类  |
| RuntimeException  |  IllegalArgumentException |传递了不合法的参数   |
| RuntimeException| IllegalStateException| 违法的状态异常|
|Exception|||

## 异常处理的规范

一、尽量不要捕捉类似Exception 这样的通用异常，而是应该捕获特定异常；要保证程序不会捕获到我们不希望捕获的异常，例如我们希望 RuntimeException 被扩散出来，而不是被捕获。

二、Throw early, catch late 原则

```java
public void readPreferences(String filename) {
	Objects. requireNonNull(filename);
	//...perform other operations... 
	InputStream in = new FileInputStream(filename);
	 //...read the preferences file...
}
```

在异常被捕获之后，最简单的处理方式是将异常的错误信息进行输出，或者站在业务角度进行新的处理。

三、try-catch代码段会产生额外的性能开销，会影响jvm对代码进行优化，因此尽量只捕获必要的代码段，而不是将一个代码块全部包围。Java每次实例化一个Exception，都会对当前栈进行快快照，是一个比较重的操作。

四、上传和下载不能抛异常

### NoClassDefFoundError 和 ClassNotFoundException有什么区别

NoClassDefFoundError是一个错误(Error)，而ClassNOtFoundException是一个异常，在Java中对于错误和异常的处理是不同的，我们可以从异常中恢复程序但却不应该尝试从错误中恢复程序。
ClassNotFoundException的产生原因：

Java支持使用Class.forName方法来动态地加载类，任意一个类的类名如果被作为参数传递给这个方法都将导致该类被加载到JVM内存中，如果这个类在类路径中没有被找到，那么此时就会在运行时抛出ClassNotFoundException异常。

ClassNotFoundException的产生原因：

Java支持使用Class.forName方法来动态地加载类，任意一个类的类名如果被作为参数传递给这个方法都将导致该类被加载到JVM内存中，如果这个类在类路径中没有被找到，那么此时就会在运行时抛出ClassNotFoundException异常。
ClassNotFoundException的产生原因主要是：
Java支持使用反射方式在运行时动态加载类，例如使用Class.forName方法来动态地加载类时，可以将类名作为参数传递给上述方法从而将指定类加载到JVM内存中，如果这个类在类路径中没有被找到，那么此时就会在运行时抛出ClassNotFoundException异常。
解决该问题需要确保所需的类连同它依赖的包存在于类路径中，常见问题在于类名书写错误。
另外还有一个导致ClassNotFoundException的原因就是：当一个类已经某个类加载器加载到内存中了，此时另一个类加载器又尝试着动态地从同一个包中加载这个类。通过控制动态类加载过程，可以避免上述情况发生。

NoClassDefFoundError产生的原因在于：
如果JVM或者ClassLoader实例尝试加载（可以通过正常的方法调用，也可能是使用new来创建新的对象）类的时候却找不到类的定义。要查找的类在编译的时候是存在的，运行的时候却找不到了。这个时候就会导致NoClassDefFoundError.
造成该问题的原因可能是打包过程漏掉了部分类，或者jar包出现损坏或者篡改。解决这个问题的办法是查找那些在开发期间存在于类路径下但在运行期间却不在类路径下的类。