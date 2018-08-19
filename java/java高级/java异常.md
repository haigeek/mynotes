# Java常见异常总结
## 异常的分类
### 异常的继承结构
![](http://www.nideyuan.com/wp-content/uploads/2017/03/java_exption.png)

Error,Exception继承与Throwable，RuntimeException，IOException继承于Exception,Error和RuntimeException及其子类成为未检查异常（unchecked），其它异常成为已检查异常（checked）Error和RuntimeException及其子类成为未检查异常（unchecked），其它异常成为已检查异常（checked）
- Error
一般是指与虚拟机有关的问题，如系统崩溃，虚拟机错误，内存空间不足，方法调用栈溢。对于这类错误的导致的应用程序中断，仅靠程序本身无法恢复和预防，遇到这样的错误，建议是让程序停止
- Exception
Exception异常一个派生于RuntimeException，另一个分支包含其他异常
是可以处理的异常,可以捕获且可能恢复，遇到这类异常，应该尽可能处理异常，使程序恢复运行，而不应该随意终止异常
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