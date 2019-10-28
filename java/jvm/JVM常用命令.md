# JVM常用命令

jvm区域总体分两类，heap区和非heap区。heap区又分：Eden Space（伊甸园）、Survivor Space(幸存者区)、Tenured Gen（老年代-养老区）。 非heap区又分：Code Cache(代码缓存区)、Perm Gen（永久代）、Jvm Stack(java虚拟机栈)、Local Method Statck(本地方法栈)。

- 查看所有的的java程序

  jps

- 查看java进程jvn的内存分布情况和占用情况

  jstat -gc pid

S0C: 第一个survivor区的容量（单位是KB）

S1C：第二个survivor区的容量（单位是KB）

S0U：第一个survivor区使用的空间（单位KB）

S1U: 第二个survivor区使用的空间（单位KB）

EC：年轻代中Eden区的容量（KB）

EU：年轻代中Eden区使用的空间（单位KB）

OC：Old代（年老代）的容量（单位KB）

OU：Old代（年老代）使用的空间（单位KB）

PC：Perm（持久代）的容量（KB）

PU：Perm（持久代）使用的空间（KB）

YGC： 从程序启动到采样时年轻代GC的次数（Young GC次数）

YGCT：从程序启动到采样时年轻代GC所用的时间（单位s）

FGC：从程序启动到采样时old代GC（FullGC）的次数，准确的说是产生非YGC产生的STW的次数。

​     表示非YGC的GC时STW的次数，所以如果发生了CMS GC，这个值+2，如果是Parallel Old GC，则+1，如果是full gc，也是+1 ， 此参数的含义在CMS引入之后定义比较模糊。 FGC>0不一定是产生了FullGC。有可能是CMS GC

FGCT：从程序启动到采样时old代GC（FullGC）所用的时间（s）

GCT：从程序启动到采样时GC所用的时间



**jstat -gcutil <pid>**

GC情况统计，可以查看GC情况，最常用的一个功能

jstat -gcutil <pid> 1000 10

每1000ms打印一次 一共打印10次

S0 年轻代中第一个survivor（幸存区）已使用的占当前容量百分比 

S1 年轻代中第二个survivor（幸存区）已使用的占当前容量百分比 

E 年轻代中Eden（伊甸园）已使用的占当前容量百分比 

O old代已使用的占当前容量百分比 

P perm代已使用的占当前容量百分比 

YGC 从应用程序启动到采样时年轻代中gc次数 

YGCT 从应用程序启动到采样时年轻代中gc所用时间(s) 

FGC 从应用程序启动到采样时old代(全gc)gc次数 （实际为非YGC产生的STW次数）

FGCT 从应用程序启动到采样时old代(全gc)gc所用时间(s) 

GCT 从应用程序启动到采样时gc用的总时间(s)

- 使用java自带的jconsole进行分析



获取dump文件

jmap -dump:format=b,file=path pid



查看主线程下的子线程

top -hd pid 

查看线程信息

jsatck 1dc81



## gc日志配置

XX:+PrintGC 输出GC日志
-XX:+PrintGCDetails 输出GC的详细日志
-XX:+PrintGCTimeStamps 输出GC的时间戳（以基准时间的形式）
-XX:+PrintGCDateStamps 输出GC的时间戳（以日期的形式，如 2013-05-04T21:53:59.234+0800）
-XX:+PrintHeapAtGC 在进行GC的前后打印出堆的信息
-Xloggc:../logs/gc.log 日志文件的输出路径





jmap -histo:live





-Xms：java Heap初始大小， 默认是物理内存的1/64。
-Xmx：java Heap最大值，不可超过物理内存。
-Xmn：young generation的heap大小，一般设置为Xmx的3、4分之一 。增大年轻代后，将会减小年老代大小，可以根据监控合理设置。
-Xss：每个线程的Stack大小，而最佳值应该是128K,默认值好像是512k。
-XX:PermSize：设定内存的永久保存区初始大小，缺省值为64M。
-XX:MaxPermSize：设定内存的永久保存区最大大小，缺省值为64M。
-XX:SurvivorRatio：Eden区与Survivor区的大小比值，设置为8，则两个Survivor区与一个Eden区的比值为2:8，一个Survivor区占整个年轻代的1/10。
-XX:+UseParallelGC：F年轻代使用并发收集，而年老代仍旧使用串行收集。
-XX:+UseParNewGC：设置年轻代为并行收集，JDK5.0以上，JVM会根据系统配置自行设置，所无需再设置此值。
-XX:ParallelGCThreads：并行收集器的线程数，值最好配置与处理器数目相等 同样适用于CMS。
-XX:+UseParallelOldGC：年老代垃圾收集方式为并行收集(Parallel Compacting)。
-XX:MaxGCPauseMillis：每次年轻代垃圾回收的最长时间(最大暂停时间)，如果无法满足此时间，JVM会自动调整年轻代大小，以满足此值。
-XX:+ScavengeBeforeFullGC：Full GC前调用YGC,默认是true。

实例如：JAVA_OPTS=”-Xms4g -Xmx4g -Xmn1024m -XX:PermSize=320M -XX:MaxPermSize=320m -XX:SurvivorRatio=6″