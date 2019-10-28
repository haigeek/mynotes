# java面试题目总结

## java基础

### Java语言的认识

1. 什么是java虚拟机？为什么java被称作是“平台无关的编程语言” 

   java虚拟机是一个可以执行java字节码的虚拟机进程，java源文件被编译成能被java虚拟机执行的字节码文件。java被设计成允许应用程序可以 运行在任意平台，而不需要在每一个平台单独编写或者编译。java虚拟机使这个变成可能，因为他知道底层硬件平台的指令的长度和其他特性。 

2. JDK和JRE的区别是什么 

   java运行时环境（JRE）是将要执行java程序的虚拟机，他同时也包含了执行applt需要的浏览器插件。

   java开发工具包（JDK）是完整的java软件开发包，包含了JRE，编译器和其他的工具（比如JavaDoc，Java调试器），可以让开发者开发开发，编译，执行java程序。 

3. static关键字是什么意思？java中是否可以覆盖（override）一个private或者static的方法 

   static关键字表明一个成员变量或者成员方法可以在没有所属的类的实例变量的情况下访问 

   java中static方法不能被覆盖，因为方法覆盖是基于运行时动态绑定的，而static方法是编译时静态绑定的。static方法跟类的任何实例都不相关，所以概念上不适用。 

4. 是否可以在static环境中访问非static变量 

   static变量在java中是属于类的，他在所有的实例中的值是一样的。当类被java虚拟机载入的时候，会对static变量进行初始化。如果代码尝试不用实例来访问非static的变量，编译器会报错，因为这些变量还没有被创建出来，还没有跟任何实例关联上。 

5. java支持的数据类型有哪些？

   java语言支持的8中数据类型是： 

   byte short int long float double boolean char 
   
6. 什么是自动拆装箱？ 
  
   - 装箱：将基本类型用他们对应的引用类型包装起来
   - 拆箱：将包装类型转换为基本的数据类型：
   
   自动装箱时java编译器在基本数据类型和对应的对象包装类型之间的一个转化，比如：把int转化为integer，double转化为Double，等等；反之，就是自动拆箱 
   
   java使用自动装箱和拆箱机制，节省了常用数值的内存开销和创建对象的开销，提高了效率，由编译器来完成，编译器会在编译期根据语法决定是否进行装箱和拆箱操作

7. 访问控制符public、protected、private、以及默认的区别

   - private只能在本类中才可以访问；
   - public在任何地方都可以访问
   - protected在同包内的类及包外的子类能访问
   - 默认不写在同包内可以访问
   - 排序：public>protected>default>private

8. 怎么理解Java的final关键字

   final能不能被同一个包的类访问和final无关，有 public protect default private决定，final本身的引用不可以改变，值可以改变

9. equals和==的区别

   -  ==是判断两个变量或实例是不是指向同一个内存空间， equals是判断两个变量或实例所指向的内存空间的值是不是相同
   -  ==是指对内存地址进行比较，equals()是对字符串的内容进行比较 
   -  ==指引用是否相同， equals()指的是值是否相同 

10. serialVersionUID 的作用

   java的序列化机制是通过在运行时判断类的serialVersionUID来验证版本一致性的。在进行反序列化时，JVM会把传来的字节流中的serialVersionUID与本地相应实体（类）的serialVersionUID进行比较，如果相同就认为是一致的，可以进行反序列化，否则就会出现序列化版本不一致的异常。

   当实现java.io.Serializable接口的实体（类）没有显式地定义一个名为serialVersionUID，类型为long的变量时，Java序列化机制会根据编译的class自动生成一个serialVersionUID作序列化版本比较用，这种情况下，只有同一次编译生成的class才会生成相同的serialVersionUID 。

   如果我们不希望通过编译来强制划分软件版本，即实现序列化接口的实体能够兼容先前版本，未作更改的类，就需要显式地定义一个名为serialVersionUID，类型为long的变量，不修改这个变量值的序列化实体都可以相互进行串行化和反串行化。

11. 是否可以继承string类
    String类是final类故不能继承，一切由final修饰过的都不能继承

12. String和StringBuffer、StringBuilder的区别

    可变性

    - String类使用字符串数组保存字符串，private final char value[] 所以string对象是不可变的
    - StringBulider和StringBuffer都继承自AbstractStringBuffer类，在AbstractStringBuffer中也是使用字符数组保存字符串，char[] value，这两种对象都是可变的

    线程安全性

    - String中对象是不可变的，也就可以理解为常量，线程安全
    - AbstractStringBuffer是StringBulider和StringBuffer的公共父类，定义了一些字符串的基本操作，StringBuffer对方法加了同步锁或者对调用的方法加了同步锁，所以是线程安全的，StringBulider并没有对方法加同步锁，所以是非线程安全的

13. hashCode和equals方法的关系
    equals()反应的是对象或者变量具体的值，即两个对象里面包含的的值，可能是对象的引用，也可能是值类型的值。而hashcode()是对象或者变量通过哈希算法计算出的哈希值
    equals相等，hashcode必相等，hashcode相等，equals可能不相等

### oop

1. 面向对象和面向过程的区别

  - 面向过程：

    优点：性能比面向对象高，因为类调用的时候，需要实例化，开销比较大，比较消耗资源，单片机，嵌入式开发，linux一般采用面向过程开发，性能是最重要的因素；
    缺点：没有面向对象易维护，易复用，易拓展；

  - 面向对象：

    易维护，易复用，易拓展，由于面向对象有封装，继承，多态性的特性。可以设计低耦合的系统，是系统更加灵活，更加易于维护；缺点：性能比面向过程低。

2. java的四个基本特性（抽象、封装、继承、多态）

  - 抽象：就是把现实生活中的某一类东西提取出来，用程序代码表示，我们通常叫做类或者接口。抽象包括两个方面：一个是数据抽象一个是过程抽象。数据抽象也就是对象的属性，过程抽象是对象的行特征。
  - 封装：把客观事物封装成抽象的类，并且类可以把自己的数据和方法只让可信的类或者对象操作，对不可信的进行封装和隐藏。封装分为属相的封装和方法的封装
  - 继承：是对有着共同特性的多项事物，进行再抽象一个类，这个类就是多项事物的父类。父类的意义在于抽取多类事物的共性；子类可以继承父类的特征和行为，使得子类对象对象（实例）具有父类的实例域和方法，或子类从父类的继承方法，使得子类具有父类相同的行为
  - 多态：允许不同类的对象对同一消息做出响应。方法的重载，类的覆盖体现了多态

3. Overload和Override的区别

  - 重载（Overload）：发生在同一个类中，方法名必须相同，参数类型不同，个数不同，顺序不同，方法返回值和访问修饰符可以不同，发生在编译时。
  - 重写（Override）：发生在父子类，方法名，参数列表必须相同，返回值小于等于父类，抛出的异常小于等于父类，访问修饰大于等于父类；如果父类方法访问修饰符为private则子类中就不是重写
  - java中的方法重载发生在同一个类里面两个或者是多个方法的方法名但是参数不同的情况；方法覆盖是说子类重新定义了父类的方法，方法覆盖必须有相同的方法名，参数列表和返回类型。覆盖者可能不会限制他所覆盖的方法的访问。 

4. 构造器Constructor是否可 以被override
    构造器不能被重写，不能用static修饰构造器，只能用public private protected 这三个权限修饰符。且不能有返回语句

11. 抽象类和接口的区别

   - 语法层次：不同的语法定义
   - 设计层次：抽象层次不同，抽象类是对类抽象，而接口是对行为抽象。抽象类是对整个类进行抽象，包括属性、行为，但是接口是对类局部（行为）的抽象
   - 抽象类中的方法可以有方法体，就是能实现方法的具体功能，但是接口中的方法不行
   - 抽象类的成员变量可以是各种类型的，而接口中的成员变量只能是public static final 类型的
   - 接口中不能含有静态代码块以及静态方法的，而抽象类是可以有静态代码块和静态方法
   - 一个类只能继承一个抽象类，而一个类可以实现多个接口

12. Java中的接口

   - 接口（interface）是一个抽象类型，是抽象方法的集合，一个类通过继承接口的方法，从而继承接口的抽象方法
   - 接口并不是类，编写接口的方式和类很相似，但是它们属于不同的概念。类描述对象的属性和方法。接口则包含类要实现的方法。

13. 什么是泛型、为什么要使用以及泛型擦除
   - 泛型，即参数化类型，该集合只能保存其指定类型的元素，避免使用强制类型转换
   - java编译器生成的字节码是不包含泛型信息的，泛型类型信息将在编译处理时候被擦除，这个过程即类型擦除。泛型擦除可以简单理解为将泛型java代码转换为普通java代码，只不过编译器更直接一点，讲泛型java代码直接转换为普通java字节码
   - 类型擦除的主要过程:1.将所有的泛型参数用其最左边界（最顶级的父类型）类型替换；2.移除所有的类型参数

### 集合类

#### 简单描述下Java 中的集合


- List和Set继承自Collection接口 

- Set无序且不允许元素重复，HashSet和TreeSet是两个主要的实现类 

- List有序且允许元素重复，ArrayList、LinkList和Vector是三个主要的实现类 

- Map也属于集合系统，但和Collection接口没关系，Map是Key-Value的映射集合，其中key列就是一个集合，key不能重复，但是value的值可以重复，HashMap、TreeMap和HashTable是三个主要实现的类 

- SortedSet和SortedMap接口对元素按照指定规则排序，SortedMap是对Key列进行排序 

#### HashMap和HashTable的区别 

1. HashTable的方法前面都有synchronized来同步，是线程安全的；HashMap未经同步，是非线程安全的 

2. HashTable不允许null值（key和value都不可以）；HashMap允许NUll值（key和value都可以） 

3. HashTable有一个contains(Object value)功能和containsValue(Object value)功能一样 

4. HashTable使用Enumeration进行遍历；HashMap使用Iterator进行遍历。 

5. HashTable中hash数组默认大小是11，增加的方式是 old*2+2；HashMap中hash数组的默认大小是16，而且一定是2的指数 

6. 哈希值的使用不同，HashTable直接使用对象的hashCode； HashMap重新计算hash值，而且用与代替求模。 

#### ArrayLIst和Vector的区别 

1. ArrayList和 Vector 都实现了List接口 

2. ArrayList是非线程安全的，Vector是线程安全的 

3. List第一次创建的时候，会有一个初始大小，随着不断向List中增加元素，当 List 认为容量不够的时候就会进行扩容。Vector缺省情况下自动增长原来一倍的数组长度，ArrayList增长原来的50%。 

#### ArrayList和LinkedList区别及使用场景 

1. ArrayList底层是用数组实现的，可以认为ArrayList是一个可改变大小的数组。随着越来越多的元素被添加到ArrayList中，其规模是动态增加的。 

2. LinkedList底层是通过双向链表实现的， LinkedList和ArrayList相比，增删的速度较快。但是查询和修改值的速度较慢。同时，LinkedList还实现了Queue接口，所以他还提供了offer(), peek(), poll()等方法。 

3. LinkedList更适合从中间插入或者删除（链表的特性）。 ArrayList更适合检索和在末尾插入或删除（数组的特性）

1. java中的集合类以及关系图

   set无序不允许元素重复，HashSet和TreeSet是两个主要的实现类

      List有序且允许元素重复。ArrayList、LinkList和Vector是三个主要的实现类

      Map也属于集合系统，但和Collection接口没关系。Map是key对value的映射集合，其中key类就是一个集合，key不能重复，但是value可以重复，HashMap、TreeMap和HashTable是三个主要实现的类

      SortedSet和SortedMap接口对元素按指定规则排序，SortedMap是对key列进行排序

2. hashMap、LinkedHashMap、hashTable、treeMap分别是什么

   hashMap根据键的hashCode的值来存储数据，访问速度较快，在取数据的时候是随机的。HashMap最多只允许一条记录的键为Null;允许多条记录的值为 Null;

   HashMap不支持线程的同步，即任一时刻可以有多个线程同时写HashMap;可能会导致数据的不一致。如果需要同步，可以用 Collections的synchronizedMap方法使HashMap具有同步的能力，或者使用ConcurrentHashMap。

   Hashtable与 HashMap类似,它继承自Dictionary类，不同的是:它不允许记录的键或者值为空;它支持线程的同步，即任一时刻只有一个线程能写Hashtable,因此也导致了 Hashtable在写入时会比较慢。

   LinkedHashMap保存了记录的插入顺序，在用Iterator遍历LinkedHashMap时，先得到的记录肯定是先插入的.也可以在构造时用带参数，按照应用次数排序。在遍历的时候会比HashMap慢，不过有种情况例外，当HashMap容量很大，实际数据较少时，遍历起来可能会比LinkedHashMap慢，因为LinkedHashMap的遍历速度只和实际数据有关，和容量无关，而HashMap的遍历速度和他的容量有关。

   TreeMap实现SortMap接口，能够把它保存的记录根据键排序,默认是按键值的升序排序，也可以指定排序的比较器，当用Iterator 遍历TreeMap时，得到的记录是排过序的。

3. HashSet、TreeSet、LinkedHashSet

   HashSet实现了Set接口，它不允许集合中有重复的值，当我们提到HashSet时，第一件事情就是在将对象存储在HashSet之前，要先确保对象重写equals()和hashCode()方法，这样才能比较对象的值是否相等，以确保set中没有储存相等的对象。如果我们没有重写这两个方法，将会使用这个方法的默认实现。

   LinkedHashSet集合同样是根据元素的hashCode值来决定元素的存储位置，但是它同时使用链表维护元素的次序。这样使得元素看起 来像是以插入顺序保存的，也就是说，当遍历该集合时候，LinkedHashSet将会以元素的添加顺序访问集合的元素。LinkedHashSet在迭代访问Set中的全部元素时，性能比HashSet好，但是插入时性能稍微逊色于HashSet。

   TreeSet是SortedSet接口的唯一实现类，TreeSet可以确保集合元素处于排序状态。TreeSet支持两种排序方式，自然排序 和定制排序，其中自然排序为默认的排序方式。向TreeSet中加入的应该是同一个类的对象。

4. HashMap实现原理

5. HashTable实现原理

6. ArrayList和vector区别
     arrayList和Vector都实现了list接口，都是通过数组实现的
     Vector是线程安全的，而Arraylist是非线程安全的
     list第一次创建的时候，会有一个初始大小，随着不断向List增加元素，当list认为容量不够的时候就会进行扩容，vector缺省情况下自动增长为原来一倍的数组长度，ArrayList增长为原来的50%

7. **ArrayList和LinkList区别以及使用场景**
  - ArrayList底层是使用数组实现的，可以认为ArrayList是一个可以改变大小的数组，随着越来越多的元素被添加到ArrayList中，其规模是动态增加的
  - LinkList底层是通过双向链表实现的，LinkList和ArrayList相比，增删的速度比较快，但是查询和修改值的速度较慢。同时，LinkList还实现可Queue接口，所以提供了offer()（添加一个元素并并返回tu）,peek()（返回队列头部的元素）,pool()（移除并返回队列头部的元素）等方法
  - LinkList更适合从中间插入或者删除（链表的特性），ArrayList更适合检索和在末尾插入和删除（数组的特性）

8. Collection和Collections的区别
     java.util.Collection是一个集合接口，他提供了对集合对象进行基本操作的通用接口方法。Collection接口在java类库中有很多具体的实现。Collection接口的意义是为各种具体的集合提供可最大化的统一的操作方式。
     java.util.Collections是一个包装类，他包含各种有关集合操作的静态多态方法。此类不能实例化，就像一个工具类，服务于java的Collection框架

12. Concurrenthashmap实现原理

### java异常

1. Error、Exception区别
    Error和Exception类的父类都是throwable类，区别是：

   - Error一般是指与虚拟机相关的问题，如系统崩溃，虚拟机错误，内存空间不足，方法调用栈溢。对于这类错误的导致的应用程序中断，仅靠程序本身无法恢复和预防，遇到这样的错误，建议是让程序停止
   - Exception类表示程序可以处理的异常，可以捕获且可能恢复，遇到这类异常，应该尽可能处理异常，使程序恢复运行，而不应该随意终止异常

21. UncheckedException和Checked Exception，各列举几个
      UncheckedException

   - 指的是程序的瑕疵或逻辑错误，并且在运行时无法恢复
   - 包括Error与RuntimeException及其子类，如OutOfMemoryError（内存溢出），UndeclaredThrowableException，IllegalArgumentException（传递了不合法的参数），IllegalMonitorStateException（违法的监控异常,当某个线程试图等待一个自己并不拥有的对象（O）的监控器或者通知其他线程等待该对象（O）的监控器时，抛出该异常),NullPointerException(空指针异常)，IllegalStateException（无效的状态异常），IndexOutOfBoundsException（数组越界）
   - 语法上不需要声明抛出异常

   Checked Exception：

   - 代表程序不能直接控制的无效的外界的情况（如用户输入，数据库问题，网络异常，文件丢失等）
   - 除了Error和RuntimeException及其子类之外，如ClassNotFoundException（无法找到的类的异常），NamingException（数据源配置异常），ServletException，SQLException，IOException等
   - 需要try catch处理或者throws声明抛出异常

### Java线程

1. 多线程实现方式
      继承Thread类，实现Runnable接口、使用ExecutorService、Callable、Future实现有返回结果的多线程

24. 线程的状态转换

25. 如何停止一个线程

26. 什么是线程安全
      线程安全就是多线程访问同一代码，不会产生不确定的结果

27. 如何保证线程安全

   - 对非安全的代码进行枷加锁控制
   - 使用线程安全的类
   - 多线程并发的情况下，线程共享的变量改为方法级的局部变量

28. Synchronized如何使用
      Synchronized是java中的关键字，是一种同步锁，它修饰的对象有以下几种：

   - 修饰一个代码块，被修饰的代码块被称为同步语句块，其作用的范围是大括号{}括起来的代码，作用的对象是调用这个代码块的对象


   - 修饰一个方法，被修饰的代码称为同步方法，其作用的范围是整个方法，作用的对象是调用这个方法的对象
   - 修饰一个静态方法，其作用的范围是整个静态方法，作用的对象是这个类的所有对象
   - 修改一个类，其作用的范围是synchronize后面括号括起来的部分 ，作用主的对象是这个类的所有对象

7. synchronized和Lock的区别
      主要相同点：Lock能完成synchronize所实现的所有功能
      主要不同点：Lock有比synchronize更精准的线程语义和更好的性能，Lock的锁定是通过代码实现的，而synchronize是在JVM层面实现的，synchronize会自动释放锁，而Lock一定要求程序员手工释放，并且必须在finally从句中释放。Lock还有更强大的功能，例如他的tryLock方法可以非阻塞方式去拿锁，Lock锁的范围有局限性，块范围、而synchronize可以锁住块、对象、类

30. 多线程如何进行信息交互
   - void notify()唤醒此对象监视器的等待的单个线程
   - void notifyAll() 唤醒在此对象监视器等待的所有的进程
   - void wait() 导致当前的线程等待，直到其他线程调用此对象的notity()方法或者notifyAll()方法
   - void wait(long timeout) 导致当前的线程等待，直到其他线程调用此对象的notify()方法或notifyAll()方法，或者超过指定的时间量。
   - void wait(long timeout,int nanos)导致当前的线程等待，直到其他线程调用此对象的notify()方法或notifyAll()方法，或者其他某个线程中断当前线程，或者已超过某个实际时间量。

31. sleep和wait的区别（考察的方向是是否会释放锁）
   - sleep()方法是Thread类中方法，而wait()方法是object方法
   - sleep方案导致了程序暂停执行指定的时间，让出cpu给其他线程，但他的监控状态依然保持着，当指定的时间到了又会自动恢复到运行状态，在调用sleep方法的过程中，线程不会释放对象锁。而调用wait方案的时候，线程会释放对象锁，进入等待此对象的等到锁定池，只有针对此对象调用notify方法后本线程才进入对象锁定池准备

32. 多线程与死锁
      死锁是指两个或两个以上的进程在执行过程中，因争夺资源而造成的一种互相等待的现象，若无外力作用，他们都将无法进行下去
      产生死锁的原因：因为系统资源不足；进程运行推进的顺序不合适；资源分配不当

33. 如何才能产生死锁
      产生死锁的四个必要条件

   - 互斥条件：所谓互斥就是在某一时间独占资源
   - 请求与保持条件：一个进程因请求资源而阻塞的时，对已获得的资源保持不放
   - 不剥夺条件：进程已获得资源，在未使用完之前，不能强行剥夺
   - 循环等待条件：若干进程之间形成的一种头尾相接的循环等待资源关系

12. 死锁的预防
      打破产生死锁的四个必要条件中的一个或几个，保证系统不会进入死锁状态

   - 打破互斥条件，即允许进程同时访问某些资源，但是有的资源是不允许被同时访问的，像打印机等等,这是由资源本身的属性据决定的，所以这种方案并无实用价值
   - 打破不可抢占条件，即允许进程强行从占用者那里夺取，就是说当一个进程已经占有了某些资源，以后再重新申请，他所释放的资源可以分配给其他进程，这就相当于该进程占有的资源被隐蔽地强占了，这种预防死锁的方法实现起来困难，会降低系统性能

13. 什么叫守护线程，用什么方法实现守护线程
      守护进程是为其他线程的运行提供服务的进程；setDaemon（boolean on）方法的设置线程的Daemon模式，ture为守护模式，false为用户模式
36. java线程池技术与原理
37. java并发包concurrent及常用的类
38. volatile关键字

### Java高级

1. java中如何实现代理机制（JDK,CGLIB)

35. java中的NIO、BIO、AIO分别是什么

   - BIO 同步并阻塞，服务器实现模式为一个连接一个线程，即服务端有连接请求时服务器就需要启动一个线程进行处理，如果这个连接不做任何事情会造成不必要的进程开销。可以通过线程池机制改善，BIO方式适用于连接数目比较小且固定的架构，这种方式对服务器资源要求比较高，并发局限于应用中，JDK1.4以前唯一的选择，但程序简单直观容易理解
   - NIO 同步非阻塞，服务器实现模式为一个请求一个进程，即客户端发送的连接请求都会注册到多路复用器上。多路复用器轮询到连接有I/O请求时才启动一个线程进行处理，NIO方式适应于连接数目多且连接比较短的架构，jdk1.4后开始支持
   - AIO 异步无阻塞，服务器实现模式为一个有效请求一个进程，客户端的IO请求都是由OS先完成了再3通知服务器应用去启动线程进行处理，AIO方式使用于连接数目多且连接比较长（重操作）的架构，比如相册服务器，充分调用OS参与并发操作，JDK1.7后开始支持

36. IO与NIO的区别

   - IO是面向流的，NIO是面向缓冲区的
   - IO的各种流是阻塞的，NIO是非缓冲模式
   - java NIO的选择器允许一个单独的线程来监视多个输入通道，可以注册多个通道使用一个选择器，然后使用一个单独的线程来选择通道，这些通道里已经有可以处理的输入，或者选择已准备写入的通道，这种选择机制，使得一个单独的线程很容易管理管理多个线程

37. 序列化与反序列化

   - 把对象转换为字节序列的过程称为对象的序列化
   - 把字节序列恢复为对象的过程称为对象的反序列化

   对象的序列化主要有两个用途

   - 把对象的字节序列永久地保存到硬盘上，通常存放到一个文件
   - 在网络上传送对象的字节序列
   - 当两个进程在进行远程通信的时候，彼此可以发送各种类型的数据，无论是何种类型的数据，都会以二进制序列的形式

38. 常见的序列化协议
      Protobuf，Thrift，Hessian，Kryo

### jvm

1. 内存溢出与内存泄漏的区别
      内存溢出是指程序在申请内存时，没有足够的内存空间供其使用，出现out of memory
      内存泄漏是指分配出去的内存不再使用，但是无法回收
36. java内存模型及各个区域的OOM，如何重现OOM
37. 出现OOM如何解决
38. 用什么工具可以查出内存泄漏
39. java内存管理及回收算法
40. java类加载器及如何加载类（双亲委派）
41. xml解析方式

   - DOM（jaxp Crimson解析器）
   - SAX
   - JDOM
   - DOM4J
42. Statement和PreparedStatement之间的区别

   - PreparedStatement是预编译的，对于批量处理可以大大提高效率，也叫jdbc存储过程
   - 使用 Statement 对象。在对数据库只执行一次性存取的时侯，用 Statement 对象进行处理。PreparedStatement 对象的开销比Statement大，对于一次性操作并不会带来额外的好处。
   - statement每次执行sql语句，相关数据库都要执行sql语句的编译，preparedstatement是预编译得, preparedstatement支持批处理









