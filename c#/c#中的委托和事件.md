# c# 委托与事件
## 委托的定义
委托是一种引用类型，表示对具有特定参数列表和返回类型的方法的引用。 在实例化委托时，可以将其实例与任何具有兼容签名和返回类型的方法相关联。 可以通过委托实例调用方法，委托用于将方法作为参传递给其他方法，这种将方法动态地赋给参数的做法，可以避免在程序中大量使用If-Else(Switch)语句，同时使得程序具有更好的可扩展性。事件处理程序，就是通过委托调用的方法，如我们可以创建一个自定义方法，当发生特定事件时，某个类（如 Windows 控件）就可以调用你的方法。 下面的示例演示了一个委托声明：
```c#
public delegate int DoEventHandler();
```
delegate是关键词，而一般的方法是下面的这个样子
```c#
public void Do()
{
    方法体
}
```
区别主要在于，委托是一个命令，真正执行的是别的方法
### 使用委托
以一个具体的情境为例：GreetingPeople
定义委托
```c#
public delegate void GreetingDelegate(string name);
```
定义GreetPeople方法
```c#
public void GreetPeople(string name, GreetingDelegate MakeGreeting){
    MakeGreeting(name);
}
```
完整代码
```c#
public delegate void GreetingDelegate(string name);
    class Program {

    private static void EnglishGreeting(string name) {
        Console.WriteLine("Morning, " + name);
    }

    private static void ChineseGreeting(string name) {
        Console.WriteLine("早上好, " + name);
    }
    //此方法接受一个GreetingDelegate类型的方法作为参数
    private static void GreetPeople(string name, GreetingDelegate MakeGreeting) {
        MakeGreeting(name);
    }

    static void Main(string[] args) {
        GreetPeople("Jimmy Zhang", EnglishGreeting);
        GreetPeople("张子阳", ChineseGreeting);
        Console.ReadKey();
    }
}
```
输出结果：
```
Morning, Jimmy Zhang
早上好, 张子阳
```
### 将方法绑定到委托
可以将多个方法赋给同一个委托，或者叫将多个方法绑定到同一个委托，当调用这个委托的时候，将依次调用其所绑定的方法
举例说明：
```c#
static void Main(string[] args) {
    GreetingDelegate delegate1;
    delegate1 = EnglishGreeting; // 先给委托类型的变量赋值
    delegate1 += ChineseGreeting;   // 给此委托变量再绑定一个方法

     // 将先后调用 EnglishGreeting 与 ChineseGreeting 方法
    GreetPeople("Jimmy Zhang", delegate1);  
    Console.ReadKey();
}
```
输出结果：
```
Morning, Jimmy Zhang
早上好, 张子阳
```
注意这里，第一次用的“=”，是赋值的语法；第二次，用的是“+=”，是绑定的语法。如果第一次就使用“+=”，将出现“使用了未赋值的局部变量”的编译错误。
也可以使用如下的代码简化这个过程
```c#
GreetingDelegate delegate1=new GreetingDelegate(EnglishGreeting)
delegate1+=ChineseGreeting;//给此委托变量再绑定一个方法
```
委托可以绑定一个方法，也有办法取消对方法的绑定，使用语法“-=”：
```c#
static void Main(string[] args) {
    GreetingDelegate delegate1 = new GreetingDelegate(EnglishGreeting);
    delegate1 += ChineseGreeting;   // 给此委托变量再绑定一个方法

    // 将先后调用 EnglishGreeting 与 ChineseGreeting 方法
    GreetPeople("Jimmy Zhang", delegate1);  
    Console.WriteLine();

    delegate1 -= EnglishGreeting; //取消对EnglishGreeting方法的绑定
    // 将仅调用 ChineseGreeting 
    GreetPeople("张子阳", delegate1); 
    Console.ReadKey();
}
```
## 事件
### 事件的定义
类或对象可以通过事件向其他类或对象通知发生的相关事情
- 发行器(publisher)：发送或者引发事件的类，包含事件和委托定义的对象。事件和委托之间的联系也定义在这个对象中。这个类或对象会自行维护本身的状态信息，当本身状态信息变动时，便触发一个事件，并通知所有的事件订阅者。
- 订阅器(subscriber): 接受或者处理事件的类，在发布器（publisher）类中的委托调用订阅器（subscriber）类中的方法（事件处理程序）。简单理解：对事件感兴趣的对象，可以注册感兴趣的事件，在事件发行者触发一个事件后，会自动执行这段代码。
### 事件的实例
1. 基本的事件实例
```c#
using System;
namespace SimpleEvent
{
    using System;
    /****发布器类*****/
    public class EvenTest
    {
        private int value;
        //声明该事件的委托类型
        public delegate void NumManipulationHandler();
        //基于上面的委托定义事件
        public event NumManipulationHandler ChangeNum;
        protected virtual void OnNumChanged()
        {
            if(ChangeNum!=null)
            {
                ChangeNum;//事件被触发
            }
            else{
                Console.WriteLine( "event not fire" );
                Console.ReadKey(); /* 回车继续 */
            }
        }
        public EvenTest()
        {
            int n=5;
            SetValue(n);
        }
        public void SetValue(int n)
        {
            if(value!=n)
            {
                value=n;
                OnNumChanged();
            }
        }
    }
    /****订阅器类*****/
    public class subscribEvent
    {
        public void printf()
        {
        Console.WriteLine( "event fire" );
        Console.ReadKey(); /* 回车继续 */
        }
    }
    /****触发*****/
    public class MainClass
    {
        public static void Main()
        {
            //实例化发布者对象，第一次没有触发事件
            EvenTest e=new EvenTest();
            //实例化订阅者对象
            subscribEvent v=new subscribEvent();
            //给这个数字变动的事件注册订阅者
            e.ChangeNum+=new EvenTest.NumManipulationHandler(v.printf);
            //发布者触发事件变动
            e.SetValue( 7 );
            e.SetValue( 11 );
        }
    }
}
```
在使用事件的时候，必须要使用对应的委托

2. 热水器烧水的实例（以Observer设计模式实现
> Observer设计模式是为了定义对象间的一种一对多的依赖关系，以便于当一个对象的状态改变时，其他依赖于它的对象会被自动告知并更新。Observer模式是一种松耦合的设计模式。
在本例中，事情发生的顺序应该是这样的
1. 警报器和显示器告诉热水器，它对热水器的温度感兴趣（注册）
2. 热水器知道后保留对警报器和显示器的引用。
3. 热水器进行烧水这一动作，当水温超过95度时，通过对警报器和显示器的引用，自动调用警报器的MakeAlert()方法、显示器的ShowMsg()方法。
```c#
//热水器
public class Heater
{
    private int temperature;
    public delegate void BoilHander(int param);//声明委托
    public event BoilHander BoilEvent;//声明事件
    //烧水
    public void BoilWater(){
        for(int i=0;i<100;i++){
            temperature=i;
            if(temperature>95){
                if(BoilEvent!=null){//如果有对象注册
                    BoilEvent(temperature);//调用所有注册对象的方法
                }
            }
        }
    }
}
//警报器
public class Alarm {
    public void MakeAlert(int param) {
        Console.WriteLine("Alarm：嘀嘀嘀，水已经 {0} 度了：", param);
    }
}
//显示器
public class Display{
    public static void ShowMsg(int param){
        Console.WriteLine("Display:水快烧开了，当前温度:{0}度",param);
    }
}
class Program{
    static void Main(){
        Heater heater=new Heater();
        Alarm alarm=new Alarm();
        heater.BoilEvent+=alarm.MakeAlert;//注册方法
        heater.BoilEvent+=(new Alarm()).MakeAlert;//给匿名对象注册方法
        heater.BoilEvent+=Display.ShowMsg;//注册静态方法
        heater.BoilWater();//烧水，会自动调用注册过对象的方法
    }
}
```
输出结果：
```
Alarm：嘀嘀嘀，水已经 96 度了：
Alarm：嘀嘀嘀，水已经 96 度了：
Display：水快烧开了，当前温度：96度。
// 省略...
```
### .Net Framework中的委托与事件
.Net Framework的编码规范：
- 委托类型的名称都应该以EventHandler结束
- 委托的原型定义：有一个void返回值，并结束两个输入参数：一个Object类型，一个EventArgs类型（或继承自EventArgs）
- 事件的命名为委托去掉 EventHandler之后剩余的部分。 
- 继承自EventArgs的类型应该以EventArgs结尾。
改写热水器例子，使之符合.Net Framework的编码规范
```c#
//热水器
public class Heater{
    private int temperature;
    public string type = "RealFire 001";       // 添加型号作为演示
    public string area = "China Xian";         // 添加产地作为演示
    //声明委托
    public delegate void BoiledEventHandler(Object sender,BoiledEventArgs e);
    //声明事件
    public event BoiledEventHandler Boiled;
    //定义BoiledEventArgs类，传递给Observer感兴趣的信息
    public class BoiledEventArgs:EventArgs{
        public readonly int temperature;
        public BoiledEventArgs(int temperature){
            this.temperature=temperature;
        }
    }
    //可以供继承自Heater的类的重写，以便继承类拒绝其他对象对他的监视
    protected virtual void OnBoiled(BoiledEventArgs e){
        if(Boiled!=null){//如果有对象注册
            Boiled(this,e);//调用所有注册对象的方法
        }
    }
    //烧水，事件需要在方法里触发
    public void BoilWater(){
        for(int i=0;i<100;i++){
            temperature=i;
            if(temperature>95){
            //建立BoiledEvevtArgs对象
            BoiledEventArgs e= new BoiledEventArgs(temperature);
            OnBoiled(e);//调用OnBolied方法
            }
        }
    }
}
//警报器，对温度感兴趣
public class Alarm{
    public void MakeAlert (Object sender,Heater.BoiledEventArgs e){
        Heater heater=(Heater) sender;
        //访问sender中的公共字段
        Console.WriteLine("Alarm：{0} - {1}: ", heater.area, heater.type);
        Console.WriteLine("Alarm: 嘀嘀嘀，水已经 {0} 度了：", e.temperature);
        Console.WriteLine();
    }
}
//显示器，对温度感兴趣
public class Display{
    public static void ShowMsg(Object sender,Heater.BoiledEventArgs e){
        Heater heater=(Heater)sender;
        Console.WriteLine("Display：{0} - {1}: ", heater.area, heater.type);
        Console.WriteLine("Display：水快烧开了，当前温度：{0}度。", e.temperature);
        Console.WriteLine();
    }
}
class Program{
    static void main(){
        Heater heater=new Heater();
        Alarm alarm=new Alarm();
        heater.Boiled+=alarm.MakeAlert;//注册方法
        heater.Boiled+=(new Alarm().MakeAlert;//注册匿名方法
        heater.Boiled+=new Heater.BoiledEventHandler(alarm.MakeAlert);//也可以这么注册
        heater.Boiled+=Display.ShowMsg;//注册静态方法
        heater.BoilWater();//烧水，会自动调用注册过对象的方法
    }
}

```

> 参考：http://www.cnblogs.com/wudiwushen/archive/2010/04/20/1703763.html
http://www.cnblogs.com/JimmyZhang/archive/2007/09/23/903360.html





