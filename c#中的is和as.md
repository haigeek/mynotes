# c#中的is和as的用法
c# 中 is和as 操作符是用来进行强制类型转换的
## is
检查一个对象是否兼容于其他指定的类型，并返回于一个bool值，不会抛出异常
```c#
object o = new object();  
 
if (o is Label)  
 {  
     Label lb = (Label)o;  
 
     Response.Write("类型转换成功");  
 }  
 else 
 {  
     Response.Write("类型转换失败");  
 } 
```
在上面的代码,CLR实际上会检查两次对象的类型,is操作符先核实一次,如果o兼容于Lable,那么在(Label)o时会再次核实一次,效率比较低,不建议使用
## as
as的作用与is的作用是一致的，但是效率要高于is，不会抛出异常，如果无法转换，会抛出null；请注意，as 运算符仅执行引用转换、可以为 null 的转换和装箱转换。 as 运算符无法执行其他转换，例如用户定义的转换，应使用转换表达式执行此转换。
```c#
object o = new object();  
 
 Label lb = o as Label;  
 
 if (lb == null)  
 {  
     Response.Write("类型转换失败");  
 }  
 else 
 {  
     Response.Write("类型转换成功");  
 } 
```
在上面的代码中,CLR只会进行一次类型核实,效率要高于 is


