---
layout: posts
title: OOM实例
date: 2020-09-20 21:09:34
updated: 2020-09-20 21:09:34
tags: 
categories: 
 - 总结
---
####  java引用 ：

- 强 普通引用 

  ```java
  M m = new M();
  m = null;
  System.gc();
  sout(m)
  ```

- 软 当堆内存不够用时才回收 

  ```java
  //设置最大堆大小为20
  //m指向强引用SoftReference SoftReference指向软引用10m的数组
  SoftReference<byte[]> m = new SoftReference<> (new byte[1024*1024*10]);
  sout(m.get());
  System.gc();
  sout(m.get()) //还能拿到值
  //当堆内存不够用时才回收
  byte[] b = new byte[1024*1024*15]
  sout(m.get()) //为null 
  ```

- 弱 （当他不存在）gc时立即回收

  ```java
  WeakReference<M> m = new WeakReference<>(new M());
  sout(m)
  System.gc();
  sout(m)//null
  ```

- 虚 跟踪gc回收 管理直接内存（堆外内存）零拷贝

  ```java
  //gc时查询引用队列 发出通知此对象要被回收了
  PhantomReference<M> m = new PhantomReference<>(new M(),new ReferenceQueue<M>());
  sout(m.get());//null
  //堆外缓冲区
  ByteBuffer b = ByteBuffer.allocateDirect(1024);
  ```

  

#####  ThreadLocal 底层是一个map set时 key为当前线程，v为值

```java
ThreadLocal<Persion> t  = new ThreadLocal<>();
//t指向的ThreadLocal是强引用 当t = null时 ThreadLocal里的map对象需要被回收 
//如果map为强引用则 map不会被回收 会造成oom
//k为null时 v访问不到但是不会被回收 所以ThreadLocal必须使用remove方法
t.remove();
//对于线程池来说 如果不执行remove()方法线程归还后v的值还在 再次获取线程会复用旧值造成值错乱
```

#####  程序、进程、线程：

**程序：** qq.exe

**进程：** 程序启动分配内存 资源分配的基本单位

**线程：** 程序执行的基本单位



**程序的执行顺序：**a = 2+3

1. 通过总线读取数据到寄存器里

2. 使用ALU计算单元完成计算返回到内存

3. pc寄存器指向下一个指令

   CPU的运行顺序：读指令--pc，读数据--register ，计算--AlU，会写--内存，下一条指令

   





#####  CAS：

**操作流程**：

拿到旧值old1--执行计算v = old1+1--再次读取old2--进行比较old1==old2，相等就写回，不相等就再次读取一直重试

![W_U9_Y__ND__QJ8_446~4YG.png](https://i.loli.net/2020/09/10/jPiG21S8cRTpfaE.png)

**ABA问题：**

​     读取的旧值为0，操作完成后再次读取还是为0，但是执行了0-8-0这个过程

​     解决方法 加上版本号，每次执行时版本号增加，写回时读取并比较版本号

**CAS原子性问题**：

​	 在操作数据时必须保证原子性，不能被其他线程修改；

​     底层使用汇编指令保证 lock（锁总线） cmpxchg

**AtomicInteger**实现自旋锁：

```
private static AtomicInteger m = new AtomicInteger(0);
//m++
m.incrementAndGet(); 

//底层调用 
unsafe.getAndAddInt(this,valueOffset,1)+1;

//getAndAddInt()调用
this.compareAndSwapInt(var1,var2,var5,var5+var4);
```



**Synchronize实现原理：**

（对象锁）通过monitorenter和monitorexit来实现的

（方法锁）使用ACC_SYNCHRONIZED修饰，。它会在常量池中增加一个标识符，获取它的monitor。



锁的四种状态：一个线程偏向锁--多个线程轻度竞争--多个线程重度竞争（或自旋次数过多）重量锁

**new：**

**轻量级锁：**

​	用户解决的锁

​	cas自旋while（） 竞争很激烈时cpu上下文切换频繁消耗资源

**重量级锁：**

​    需要操作系统调度的锁

​	加入等待队列由操作系统调度

**偏向锁：**

​    偏向于第一个访问锁的线程，如果在运行过程中，同步锁只有一个线程访问，不存在多线程争用的情况，则线程是不需要触发同步的，这种情况下，就会给线程加一个偏向锁。 

![UQ_Y3I0_IULC@Y__4RP`M_K.png](https://i.loli.net/2020/09/10/s1oRtKhraJlXkFO.png)

**寄存器的层次结构**：

cache line一次加载64个字节

pc寄存器的指令计算需要x的值 首先会按序加载L1-->L2-->L3-->内存 寄存器将x交给ALU计算 然后写回 pc寄存器读取下一个指令
内核2需要y的值直接从L3中读取

![V_BMVR@QU_AOB_SL@UURIMX.png](https://i.loli.net/2020/09/10/QheuWkdCc3yMz6O.png)

缓存行对齐：

​	xy处于同一行 当并发修改时，内核c1修改完x会通知内核c2，c2去内存中再次读取修改y，再通知c1这个过程很耗时

   假设xy都为long（占用8个字节）类型，在x的前面填充7个long类型对象，在其后添加8个long对象，再执行操作，由于xy不处于同一缓存行，省去通知、读取的时间



#####  缓存一致性协议：MESI Cache（一致性协议）

**Modified：修改**

**Exclusive：独占**

**Shared：共享**

**Invalid：失效**

假设缓存行在两个核心中使用，当c1修改后会通知c2，c2将该行数据标记为Invalid，c2需要重新从内存中读取。



#####  volatile：

**线程间通信**

- volatile修饰的变量被当前线程修改后其他线程会感知到	

**禁止指令重排序**

- 如果不用volatile修饰可能发生指令重排序，**invokespecial**在**astore_1**之后执行，o拿到的时一个半初始化状态的对象

- #####  Object o  = new Object()的初始化过程：

1. **new**：申请一块内存空间用来存放对象
2. **invokespecial**：调用构造方法对属性赋值（半初始化对象)
3. **astore_1**：建立o和对象的关联（指针指向堆内存）











#####  单例模式为什么需要dlc操作：

如果不用volatile修饰可能发生指令重排序，**invokespecial**在**astore_1**之后执行，INSTACE拿到的时一个半初始化状态的对象

细化锁的力度将锁加载在方法内部时，当线程T1执行到第17行时被暂停，T2执行创建、返回对象，T1再次执行创建、返回对象

![Q_S`@`U82B8_G8_Z_KCM_ID.png](https://i.loli.net/2020/09/10/F9pB75xCHKscm38.png)

**解决方法：dcl(double check lock):**

加锁前检查一次（减少并发下的竞争），加锁后再检查一次

![M2_KX7_BNP3IISU1S_~F_CF.png](https://i.loli.net/2020/09/10/OT9kEtDHJNG2XfB.png)



#####  内存屏障：

**JVM层面**：（happens-before原则）

- 写操作 在前面添加StoreStore 在后面添加StoreLoad
- 读操作  在之后添加LoadLoad LoadStore

**Hotspot实现：**

- **lock addl**总线锁定 
  - 对共享内存的独占使用
  - 将当前处理器的缓存刷新到内存，使其他处理器的缓存失效
  - 指令无法越过这个内存屏障







#####  jvm如何确定一个对象是垃圾：

- 引用计数 reference count

- 根可达性 root searching

  

#####  GC算法有哪些：

- **mark-sweep 标记清除**（效率高 会产生碎片化问题）
- **copying 复制**（浪费空间 Eden区 8:1:1 使用此算法，每次使用一半的空间，有用的拷贝到to，清除from区）
- **mark-compact标记压缩**（效率低节约空间 老年代使用此算法）



#####  垃圾回收器：

分代：将内存分为两大块

分区：将内存分为一片一片

![wYghWR.png](https://s1.ax1x.com/2020/09/11/wYghWR.png)

#####  堆内存的逻辑分区：

![LB0I_1AC2`VEA_M0_3_DA50.png](https://i.loli.net/2020/09/11/NxmGJP8M43v5Tph.png)

#####  对象的生命周期：

new对象 

- 进入栈？（逃逸分析和标量替换）出栈消亡

  JVM通过逃逸分析确定该对象不会被外部访问。那就通过标量替换将该对象分解在栈上分配内存

  - **逃逸分析**：分析在程序的哪些地方可以访问到该指针，避免野指针

  - **标量替换：**A中数据都为基本数据类型，可以用两个int数据替代

    ```java
    class A{
    	private int a;
    	private int b;
    }
    ```

    

- 进入老年代（对象很大） 发生FullGC

- 进入TLAB （Thread Local Allocation Buffer）线程本地内存分配缓冲区

  - 进入 Eden  发生YoungGC

对象创建后进入Eden区，第一次GC时存活的对象（包括to区的）拷贝到from区，将from和to交换，清空Eden和from区，对象年龄+1，当年龄大于15后进入老年代

