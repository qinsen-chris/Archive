# JVM

java -Xms3G -Xmx3G -Xmn2G -Xss1M -XX:MetaspaceSize=512M -XX:MaxMetaspaceSize=512M -jar microservice-eureka-service.jar 

Eden区和Survivor0、Survivor1区 8:1:1 比例分配

Old    1G 

eden 1.6G

S0     200M

S1     200M

拿电商大促举例，一个订单（加上优惠券、活动等等对象）假设请求为60M， 没有占S0区的一半，可以放到S0区，在年轻代可以进行GC。



## JVM非标准参数(-X)

java -X 可以查看非标准参数又称为扩展参数 

-Xms

指定jvm堆的初始大小，默认为物理内存的1/64，最小为1M；可以指定单位，比如k、m，若不指定，则默认为字节。

-Xmx

指定jvm堆的最大值，默认为物理内存的1/4或者1G，最小为2M；单位与-Xms一致。

-Xss

设置单个线程栈的大小，一般默认为512k。


## JVM非Stable参数（-XX）

获取方法:  java -XX:+PrintFlagsInitial
这些参数可以被松散的聚合成三类：

行为参数（Behavioral Options）：用于改变jvm的一些基础行为；

性能调优（Performance Tuning）：用于jvm的性能调优；

调试参数（Debugging Options）：一般用于打开跟踪、打印、输出等jvm参数，用于显示jvm更加详细的信息；

行为参数(功能开关)
 
-XX:-DisableExplicitGC  禁止调用System.gc()；但jvm的gc仍然有效
 
-XX:+MaxFDLimit 最大化文件描述符的数量限制
 
-XX:+ScavengeBeforeFullGC   新生代GC优先于Full GC执行
 
-XX:+UseGCOverheadLimit 在抛出OOM之前限制jvm耗费在GC上的时间比例
 
-XX:-UseConcMarkSweepGC 对老生代采用并发标记交换算法进行GC
 
-XX:-UseParallelGC  启用并行GC
 
-XX:-UseParallelOldGC   对Full GC启用并行，当-XX:-UseParallelGC启用时该项自动启用
 
-XX:-UseSerialGC    启用串行GC
 
-XX:+UseThreadPriorities    启用本地线程优先级
 
性能调优
 
-XX:LargePageSizeInBytes=4m 设置用于Java堆的大页面尺寸
 
-XX:MaxHeapFreeRatio=70 GC后java堆中空闲量占的最大比例
 
-XX:MaxNewSize=size 新生成对象能占用内存的最大值
 
-XX:MaxPermSize=64m 老生代对象能占用内存的最大值
 
-XX:MinHeapFreeRatio=40 GC后java堆中空闲量占的最小比例
 
-XX:NewRatio=2  新生代内存容量与老生代内存容量的比例
 
-XX:NewSize=2.125m  新生代对象生成时占用内存的默认值
 
-XX:ReservedCodeCacheSize=32m   保留代码占用的内存容量
 
-XX:ThreadStackSize=512 设置线程栈大小，若为0则使用系统默认值
 
-XX:+UseLargePages  使用大页面内存
 
调试参数
 
-XX:-CITime 打印消耗在JIT编译的时间
 
-XX:ErrorFile=./hs_err_pid<pid>.log 保存错误日志或者数据到文件中
 
-XX:-ExtendedDTraceProbes   开启solaris特有的dtrace探针
 
-XX:HeapDumpPath=./java_pid<pid>.hprof  指定导出堆信息时的路径或文件名
 
-XX:-HeapDumpOnOutOfMemoryError 当首次遭遇OOM时导出此时堆中相关信息
 
-XX:OnError="<cmd args>;<cmd args>" 出现致命ERROR之后运行自定义命令
 
-XX:OnOutOfMemoryError="<cmd args>;<cmd args>"  当首次遭遇OOM时执行自定义命令
 
-XX:-PrintClassHistogram    遇到Ctrl-Break后打印类实例的柱状信息，与jmap -histo功能相同
 
-XX:-PrintConcurrentLocks   遇到Ctrl-Break后打印并发锁的相关信息，与jstack -l功能相同
 
-XX:-PrintCommandLineFlags  打印在命令行中出现过的标记
 
-XX:-PrintCompilation   当一个方法被编译时打印相关信息
 
-XX:-PrintGC    每次GC时打印相关信息
 
-XX:-PrintGC Details    每次GC时打印详细信息
 
-XX:-PrintGCTimeStamps  打印每次GC的时间戳
 
-XX:-TraceClassLoading  跟踪类的加载信息
 
-XX:-TraceClassLoadingPreorder  跟踪被引用到的所有类的加载信息
 
-XX:-TraceClassResolution   跟踪常量池
 
-XX:-TraceClassUnloading    跟踪类的卸载信息
 
-XX:-TraceLoaderConstraints 跟踪类加载器约束的相关信息




