# java错题总结

1. Thread类不是抽象类，可以不重写run()方法
2. 过滤字节流输出都是 FilterOutputStream抽象类的子类
3. java源文件最多只能有一个public类，其他类的个数不限
4. 运行异常，可以通过java虚拟机来自行处理。非运行异常，我们应该捕获或者抛出
5. String 是length方法(length())，数组Array是length属性，集合是size()方法
6. new和malloc申请的在堆区,函数局部变量和函数参数在栈区,全局和静态变量在全局区(静态区)
7. i++ 先引用后增加；++i 先增加后引用