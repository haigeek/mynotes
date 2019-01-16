# Java的反射

> 参考自https://www.sczyh30.com/posts/Java/java-reflection-1/

## 什么是反射

> Java 反射机制在程序**运行时**，对于任意一个类，都能够知道这个类的所有属性和方法；对于任意一个对象，都能够调用它的任意一个方法和属性。这种 **动态的获取信息** 以及 **动态调用对象的方法** 的功能称为 **java 的反射机制**。

反射是Java语言的特征之一，他允许运行中的Java程序获取自身的信息，并且可以操作类或者对象的内部属性。通过反射，可以得知在运行的时候才能够得知的名称的.class文件，然后生成其对象实体、或对其 fields（变量）设值、或调用其 methods（方法）。

同样的也可以通过反射来创实例，调用实例方法。

## 使用反射获取类的信息

### 获取class对象

**使用Class的forName静态方法**

```java
 public static Class<?> forName(String className)
//比如在 JDBC 开发中常用此方法加载数据库驱动:
 Class.forName(driver);
```

**获取一个对象的class**

```java
Class<?> kclass=int.class;
Class<?> classInt=Integer.TYPE;
```

**调用某个对象的getClass()方法**

```java
StringBuilder str = new StringBuilder("123");
Class<?> klass = str.getClass();
```

### 判断是否为某个对象的实例

```java
public native boolean isInstance(Object obj);
```

### 创建实例

**使用Class对象的newInstance()方法创建Class对象的实例**

```java
Class<?> c = String.class;
Object str = c.newInstance();
```

**通过Class对象获取指定的Constructor对象，再调用Constructor的newInstance()方法来创建实例。这种方法可以用指定的构造器构造类的实例。**

```java
//获取String所对应的Class对象
Class<?> c = String.class;
//获取String类带一个String参数的构造器
Constructor constructor = c.getConstructor(String.class);
//根据构造器创建实例
Object obj = constructor.newInstance("23333");
System.out.println(obj);
```

### 获取方法

`getDeclaredMethods` 方法返回类或接口声明的所有方法，包括公共、保护、默认（包）访问和私有方法，但不包括继承的方法。

```java
	public Method[] getDeclaredMethods() throws SecurityException
```

`getMethods` 方法返回某个类的所有公用（public）方法，包括其继承类的公用方法。

```java
	public Method getMethod(String name, Class<?>... parameterTypes)
```

`getMethod` 方法返回一个特定的方法，其中第一个参数为方法名称，后面的参数为方法的参数对应Class的对象

```java
	public Method getMethod(String name, Class<?>... parameterTypes)
```

### 获取构造器信息

获取类构造器的用法与上述获取方法的用法类似。主要是通过Class类的getConstructor方法得到Constructor类的一个实例，而Constructor类有一个newInstance方法可以创建一个对象实例:

```java
	public T newInstance(Object ... initargs)
```

### 获取类的成员变量字段信息

- `getFiled`：访问公有的成员变量
- `getDeclaredField`：所有已声明的成员变量，但不能得到其父类的成员变量

`getFileds` 和 `getDeclaredFields` 方法用法同上（参照 Method）。

### 调用方法

当我们从类中获取了一个方法后，我们就可以用 `invoke()` 方法来调用这个方法。`invoke` 方法的原型为:

```java
public Object invoke(Object obj, Object... args)
        throws IllegalAccessException, IllegalArgumentException,
           InvocationTargetException
```

### 利用反射创建数组

数组在Java里是比较特殊的一种类型，它可以赋值给一个Object Reference

```java
public static void testArray() throws ClassNotFoundException {
        Class<?> cls = Class.forName("java.lang.String");
        Object array = Array.newInstance(cls,25);
        //往数组里添加内容
        Array.set(array,0,"hello");
        Array.set(array,1,"Java");
        Array.set(array,2,"fuck");
        Array.set(array,3,"Scala");
        Array.set(array,4,"Clojure");
        //获取某一项的内容
        System.out.println(Array.get(array,3));
    }
```



##             

​        

