---
layout: posts
title: Java面试题
date: 2020-09-12 10:52:00
updated: 2020-09-20 21:07:09
tags: 
categories: 
 - 面试
---
## 一、java基础：
####  面向对象和面向过程的区别：

- **面向过程**： 性能高  没有面向对象易维护、易扩展

- **面向对象**：性能比面向对象低 易维护、易扩展、易复用

####  Java** 语言有哪些特点：

1. 简单易学；

2. 面向对象（封装，继承，多态）；

3. 平台无关性（ Java 虚拟机实现平台无关性）；

4. 可靠性；

5. 安全性；
6. 支持多线程
7. 支持网络编程并且很方便
8. 编译与解释并存；

####  **构造器** **Constructor** **是否可被** **override**

父类的私有属性和构造方法并不能被继承，所以Constructor 也就不能被 override（重写）,但是可以 overload（重载）,所以一个类中有多个构造函数。

####  **重载和重写的区别**

**重载：** 发生在同一个类中，方法名必须相同，参数类型不同、个数不同、顺序

不同，方法返回值和访问修饰符可以不同，发生在编译时。

**重写：** 发生在父子类中，方法名、参数列表必须相同，返回值范围小于等于父

类，抛出的异常范围小于等于父类，访问修饰符范围大于等于父类；如果父类

方法访问修饰符为 private 则子类就不能重写该方法

**Java** **面向对象编程三大特性****:** **封装 继承 多态**

**封装**：把一个对象的属性私有化，同时提供一些可以被外界访问的属性的方法

**多态**：程序中定义的引用变量所指向的具体类型和通过该引用变量发出的方法调用在编程时并不确定

```
Person p = new Teacher();
```

**继承**：使用已存在的类的定义作为基础建立新类，方便代码复用

- 子类拥有父类非 private 的属性和方法。
- 子类可以拥有自己属性和方法，即子类可以对父类进行扩展。
- 子类可以用自己的方式实现父类的方法。

**String** **为什么是不可变的**

String 类中使用 final 关键字字符数组保存字符串，所以 String 对象是不可变的。

```java
private final char value[]
```

####  **String StringBuffer** **和** **StringBuilder** **的区别****是什么

 他们都继承自**AbstractStringBuilder**

|                | StringBuilder | StringBuffer |
| :------------: | :-----------: | :----------: |
| **线程安全性** |      否       |      是      |
|    **性能**    |   比sb快10%   |      好      |

####  **在** **Java** **中定义一个不做事的无惨构造****方法的作用**

Java 程序在执行子类的构造方法之前，如果没有用 super() 来调用父类特定的构造方法，则会调用父类中“没有参数的构造方法”。

####  **对象的相等与指向他们的引用相等，两者有什么不同？**

**对象相等**：是内存中存放的内容是否相等。

**引用相等**：指向的内存地址是否相等

####  **==** **与** **equals**

**==** : 判断地址是否相等，是否为同一对象（基本数据类型比较的是值，引用数据类型比较的是内存地址)

**equals()** : 它的作用也是判断两个对象是否相等。但它一般有两种使用情况：

- 情况 1：没有重写 equals() 方法时，等价于通过“==”比较这两个对象。

- 情况 2：类重写equals() 方法。一般，我们都覆盖 equals() 方法来两个对象的内容相等；若它们的内容相等，则返回 true (即，认为这两个对象相等)。

####  **hashCode** **与** **equals**

- **hashCode()** ：获取哈希码，返回一个 int 整数。

- **为什么要有** **hashCode**：对于HashSet 而言，需要检查重复元素，在添加元素前会根据hashcode计算位置，再次添加时先判断hashcode是否是否相等，减少**equals**的次数提升了效率。
- **hashCode****（）与** **equals****（）的相关规定**
  1.  如果两个对象相等，则 hashcode 一定也是相同的
  2. 两个对象相等,对两个对象分别调用 equals 方法都返回 true
  3. 两个对象有相同的 hashcode 值，它们也不一定是相等的
  4. 重写equals时必须重写hashcode
  5. hashCode() 的默认行为是对堆上的对象产生独特值。如果没有重写hashCode()，则该 class 的两个对象无论如何都不会相等

####  **final** **关键字的一些总结**

1. 对于一个 final 变量，如果是基本数据类型，则其数值在初始化之后不能更改；如果是引用类型，则在对其初始化之后便不能再让其指向另一个对象。

2. 当用 final 修饰一个类时，表明这个类不能被继承。final 类中的所有成员方法都会被隐式地指定为 final 方法。

3. 使用 final 方法的原因有两个:
   - 第一个原因是把方法锁定，以防任何继承类修改它的含义；
   - 第二个原因是效率。在早期的 Java 实现版本中，会将final 方法转为内嵌调用。

**在以下** **4** **种特殊情况下，finally 块不会被执行：**

1. 在 finally 语句块中发生了异常。

2. 在前面的代码中用了 System.exit()退出程序。

3. 程序所在的线程死亡。

4. 关闭 CPU。

------

##  二、集合框架

**ArrayList 和 Vector 的区别**

这两个类都实现了 List 接口，存储的元素的是有序可重复的

- **ArrayList**：线程不安全 适合多线程 扩容为原来的1.5倍
- **Vector**：线程安全 单线程效率高 默认扩容为原来的2倍

####  **ArrayList,Vector, LinkedList 的存储性能和特性。**

- **ArrayList 和 Vector** ：Object数组实现 查询快 增删慢
- **LinkedList** ：使用双向链表实现 增删快 查询慢

####  **快速失败 (fail-fast) 和安全失败 (fail-safe) 的区别是什么？**

快速失败的迭代器会抛出ConcurrentModificationException 异常，而安全失败的迭代器永远不会抛出这样的异常。

####  **hashmap 的数据结构**

Hashmap 实际上是一个数组和链表的结合体

####  **HashMap 的工作原理是什么?**

以键值对 (key-value) 的形式存储元素的。使用 hashCode()和 equals()方法来添加和检索元素。当调用 put() 方法的时候，HashMap 会计算 key 的 hash 值，然后把键值对存储在集合中合适的索引上。 如果 key 已经存在了，value 会被更新成新值。HashMap 的一些重要的特性是它的容量 (capacity)，负载因子 (load factor) 和扩容极限(threshold resizing）

####  **Hashmap 什么时候进行扩容呢？**

当 hashmap 中的元素个数超过数组大小 *0.75 时，就会进行数组扩容

####  **两个对象值相同 (x.equals(y) == true)，但却可有不同的 hash code，这句话对不对?**

对。如果对象保存在 HashSet 或 HashMap 中，它们的 equals 相等，hashcode 值就必须相等。

如果不是要保存在 HashSet 或 HashMap，则与 hashcode 没有什么关系了，这时候 hashcode 不等是可以的，

####  **Java 集合类框架的基本接口有哪些**

- **Collection：**代表一组对象，每一个对象都是它的子元素。

- **Set：**不包含重复元素的 Collection。

- **List：**有顺序的 collection，并且可以包含重复元素。

- **Map：**可以把键 (key) 映射到值 (value) 的对象，键不能重复。

**HashSet** ：

由一个 hash 表来实现，它的元素是无序的， 值是作为 HashMap 的 key 存储在HashMap 中，

####  **什么是迭代器 (Iterator)？**

Iterator 接口提供了很多对集合元素进行迭代的方法，可以在迭代的过程中删除底层集合的元素, 但是不可以直接调用集合的 remove(Object Obj) 删除，可以通过迭代器的 remove() 方法删除

####  **Iterator 和 ListIterator 的区别是什么？**

- Iterator：

  可用来遍历 Set 和 List 前向遍历

- ListIterator ：

  只能遍历 List 前向、后向遍历

####  **Java 集合类框架的最佳实践有哪些？**

- 假如元素的大小是固 定的，而且能事先知道，我们就应该用 Array 而不是ArrayList。 

- 有些集合类允许指定初始容量。因此，如果我们能估计出存储的元素的数目，我们可以设置 初始容量来避免重新计算 hash 值或者是扩容。

- 为了类型安全，可读性和健壮性的原因总是要使用泛型。同时，使用泛型还可以避免运行时的 ClassCastException。 

- 使用 JDK 提供的不变类 (immutable class) 作为 Map 的键可以避免为我们自己的类实现 hashCode()和 equals()方法。

- 编程的时候接口优于实现。

- 底层的集合实际上是空的情况下，返回长度是 0 的集合或者是数组，不要返回 null。

##  三、并发编程

##  **Synchronized 相 关 问 题**：

####  **问 题 一 ：** Synchronized 用 过 吗 ， 其 原 理 是 什 么 ？

Synchronized 是 由 JVM 实 现 的 一 种 实 现 互 斥 同 步 的 一 种 方 式 ， 会 发 现 ，被 Synchronized 修 饰 过 的 程 序 块 ， 在 编 译 前 后 被 编 译 器 生 成 了monitorenter 和 monitorexit 两 个 字 节 码 指 令 。

**monitorenter** ：尝试获 取 对 象 的 锁 ，成功计数+1，失败就阻塞等待

**monitorexit**： 计数-1

当计数器为0，锁释放

####  **问 题 二 ：** 你 刚 才 提 到 获 取 对 象 的 锁 ， 这 个 “ 锁 ” 到 底 是 什 么 ？ 如 何 确 定对 象 的 锁 ？

在并发编程中，经常会遇到多个线程访问同一个共享变量，当同时对共享变量进行读写操作时，就会产生数据不一致的情况。JVM为了保证同一时刻只有一个线程执行对应的代码块就引入了锁的概念。

#####  “ 锁 ” 的 本 质 其 实 是 monitorenter 和 monitorexit 字 节 码 指 令 的 一个 Reference 类 型 的 参 数 ， 即 要 锁 定 和 解 锁 的 对 象 。

1. 如 果 Synchronized 明 确 指 定 了 锁 对 象 ， 比 如 Synchronized（ 变 量名 ） 、 Synchronized(this) 等 ， 说 明 加 解 锁 对 象 为 该 对 象 。

2. 如 果 没 有 明 确 指 定 ：
   - 若 Synchronized 修 饰 的 方 法 为 非 静 态 方 法 ， 表 示 此 方 法 对 应 的 对 象 为锁 对 象 ；
   - 若 Synchronized 修 饰 的 方 法 为 静 态 方 法 ， 则 表 示 此 方 法 对 应 的 类 对 象为 锁 对 象 。

- **注 意 ， 当 一 个 对 象 被 锁 住 时 ， 对 象 里 面 所 有 用 Synchronized 修 饰 的方 法 都 将 产 生 堵 塞 ， 而 对 象 里 非 Synchronized 修 饰 的 方 法 可 正 常 被调 用 ， 不 受 锁 影 响** 

####  **问 题 三 ：** 什 么 是 可 重 入 性 ， 为 什 么 说 Synchronized 是 可 重 入 锁 ？

**可 重 入 性** ：当前线程已经拥有了该锁的前提下，还能继续的获取该锁

-  在 执 行monitorenter 指 令 时 ， 如 果 这 个 对 象 没 有 锁 定 ， 或 者 当 前 线 程 已 经 拥有 了 这 个 对 象 的 锁 （ 而 不 是 已 拥 有 了 锁 则 不 能 继 续 获 取 ） ， 就 把 锁 的 计数 器 +1， 其 实 本质 上 就 通 过 这 种 方 式 实 现 了 可 重 入 性 

####  **问 题 四 ：** JVM 对 Java 的 原 生 锁 做 了 哪 些 优 化 ？

锁升级：

**锁的四种状态：**

- **new：**

- **轻量级锁：**
  - 用户解决的锁cas自旋while（） 竞争很激烈时cpu上下文切换频繁消耗资源

- **重量级锁：**
  -  需要操作系统调度的锁，加入等待队列由操作系统调度

- **偏向锁：**
  -  偏向于第一个访问锁的线程，如果在运行过程中，同步锁只有一个线程访问，不存在多线程争用的情况，则线程是不需要触发同步的，这种情况下，就会给线程加一个偏向锁。

![](https://i.loli.net/2020/09/10/s1oRtKhraJlXkFO.png)

####  **问 题 五 ：** 为 什 么 说 Synchronized 是 非 公 平 锁 ？

非公平主要表现在获取锁的行为上，并非是按照申请锁的时间前后给等待线程分配锁的，每当锁被释放后，任何一个线程都有机会竞争到锁，这样做的目的是为了提高执行性能，缺点是可能会产生线程饥饿现象。

####  **问 题 六 ：** 什 么 是 锁 消 除 和 锁 粗 化 ？

- 锁 消 除 ： 指 虚 拟 机 即 时 编 译 器 在 运 行 时 ， 对 一 些 代 码 上 要 求 同 步 ， 但 被 检 测 到 不 可 能 存 在 共 享 数 据 竞 争 的 锁 进 行 消 除 。 主 要 根 据 逃 逸 分 析 。 

-  锁消除：指虚拟机即时编译器在运行时，对一些代码上要求同步，但被检测到不可能存在共享数据竞争的锁进行消除。主要根据逃逸分析。

**.为 什 么 说 Synchronized 是 一 个 悲 观 锁 ？ 乐 观 锁 的 实 现 原 理 又 是 什 么 ？ 什 么 是 CAS， 它 有 什 么 特 性 ？**

- Synchronized的并发策略是悲观的：不管是否产生竞争，任何的数据操作都必须加锁

- 乐观锁的核心算法是CAS，它涉及到三个操作数：内存值、预期值、新值。当且仅当预期值和内存值相等时才将内存值修改为新值。

-  CAS具有原子性，在操作数据时必须保证原子性，不能被其他线程修改；它的原子性由编指令保证

  ```cmd
  lock（锁总线） cmpxchg
  ```

####  **问 题 八 ：** 乐 观 锁 一 定 就 是 好 的 吗 ？

乐观锁避免了悲观锁独占对象的现象 ，同时也提高了并发性能

**缺点**：

1. 乐观锁只能保证一个共享变量的原子操作。如果多一个或几个变量，乐观锁将变得力不从心，但互斥锁能轻易解决，不管对象数量多少及对象颗粒度大小。

2. 长时间自旋可能导致开销大。假如CAS长时间不成功而一直自旋，会给CPU带来很大的开销。

3. ABA问题。CAS的核心思想是通过比对内存值与预期值是否一样而判断内存值是否被改过，但这个判断逻辑不严谨，假如内存值原来是A，后来被一条线程改为B，最后又被改成了A，则CAS认为此内存值并没有发生改变，但实际上是有被其他线程改过的，这种情况对依赖过程值的情景的运算结果影响很大。解决的思路是引入版本号，每次变量更新都把版本号加一。

##  **可 重 入 锁 ReentrantLock 及 其 他 显 式 锁 相 关 问 题**

####  **问 题 一 ：** 跟 Synchronized 相 比 ， 可 重 入 锁 ReentrantLock 其 实 现 原 理 有 什 么 不 同 ？

其实锁的实现原理基本是为了达到一个目的：让所有的线程都能看到某种标记

- **Synchronized**：通过在对象头中设置标记实现了这一目的，是一种JVM原生的锁实现方式
- **ReentrantLock**：通过用一个volitile修饰的int型变量，并保证每个线程都能拥有对该int的可见性和原子修改，其本质是基于AQS框架。

####   **问 题 二 ：** 那 么 请 谈 谈 AQS 框 架 是 怎 么 回 事 儿 ？

1. AQS在内部定义了一个volatileintstate变量，表示同步状态：当线程调用lock方法时，如果state=0，说明没有任何线程占有共享资源的锁，可以获得锁并将state=1；如果state=1，则说明有线程目前正在使用共享变量，其他线程必须加入同步队列进行等待。

2. 2.AQS通过Node内部类构成的一个双向链表结构的同步队列，来完成线程获取锁的排队工作，当有线程获取锁失败后，就被添加到队列末尾。Node类是对要访问同步代码的线程的封装，包含了线程本身及其状态叫waitStatus（有五种不同取值，分别表示是否被阻塞，是否等待唤醒，是否已经被取消），每个Node结点关联其prev结点和next结点，方便线程释放锁后快速唤醒下一个在等待的线程，是一个FIFO的过程。

- -Node类有两个常量，SHARED和EXCLUSIVE，分别代表共享模式和独占模式。所谓共享模式是一个锁允许多条线程同时操作（信号量Semaphore就是基于AQS的共享模式实现的），独占模式是同一个时间段只能有一个线程对共享资源进行操作，多余的请求线程需要排队等待（如ReentranLock）。

3. AQS通过内部类ConditionObject构建等待队列（可有多个），当Condition调用wait()方法后，线程将会加入等待队列中，而当Condition调用signal()方法后，线程将从等待队列转移动同步队列中进行锁竞争。

4. AQS和Condition各自维护了不同的队列，在使用Lock和Condition的时候，其实就是两个队列的互相移动。

####  **问题三：**请尽可能详尽地对比下Synchronized和ReentrantLock的异同。

ReentrantLock是Lock的实现类，是一个互斥的同步锁。从功能角度，ReentrantLock比Synchronized的同步操作更精细（因为可以像普通对象一样使用），甚至实现Synchronized没有的高级功能，如：

- 等待可中断：当持有锁的线程长期不释放锁的时候，正在等待的线程可以选择放弃等待，对处理执行时间非常长的同步块很有用。
- 带超时的获取锁尝试：在指定的时间范围内获取锁，如果时间到了仍然无法获取则返回。
- 可以判断是否有线程在排队等待获取锁。
- 可以响应中断请求：与Synchronized不同，当获取到锁的线程被中断时，能够响应中断，中断异常将会被抛出，同时锁会被释放。
- 可以实现公平锁。

1. 从锁释放角度，Synchronized在JVM层面上实现的，不但可以通过一些监控工具监控Synchronized的锁定，而且在代码执行出现异常时，JVM会自动释放锁定；但是使用Lock则不行，Lock是通过代码实现的，要保证锁定一定会被释放，就必须将unLock()放到finally{}中。
2. 从性能角度，Synchronized早期实现比较低效，对比ReentrantLock，大多数场景性能都相差较大。但是在Java6中对其进行了非常多的改进，在竞争不激烈时，Synchronized的性能要优于ReetrantLock；在高竞争情况下，Synchronized的性能会下降几十倍，但是ReetrantLock的性能能维持常态。

####  **问题四：**ReentrantLock是如何实现可重入性的？

加锁的时候通过CAS算法，将线程对象放到一个双向链表中，每次获取锁的时候，看下当前维护的那个线程ID和当前请求的线程ID是否一样，一样就可重入了。

####  问题五：除了ReetrantLock，你还接触过JUC中的哪些并发工具

- CountDownLatch、CyclicBarrier、Semaphore等，比Synchronized更加高级，可以实现更加丰富多线程操作的同步结构。
- ConcurrentHashMap、有序的ConcunrrentSkipListMap，或者通过类似快照机制实现线程安全的动态数组CopyOnWriteArrayList等，各种线程安全的容器。
- ArrayBlockingQueue、SynchorousQueue或针对特定场景的PriorityBlockingQueue等，各种并发队列实现。
- Executor框架，可以创建各种不同类型的线程池，调度任务运行等。

问题六：请谈谈ReadWriteLock、StampedLock。

- ReadWriteLock 代表了一对锁，能够对读写操作单独加锁,比起Synchronized粒度更细

```java
ReentrantReadWriteLock l = new ReentrantReadWriteLock();
Map<String,String> m = new HashMap<>();
Lock r = l.readLock();
Lock w = l.writeLock();

public String get(String key){
	r.lock();
	try{
		return m.get(key);
	}finaly{
	  r.unlock
	}
}

public void put(String key,String v){
	w.lock();
	try{
		w.pyt(key,v);
	}finaly{
	  r.unlock
	}
}
```

- StampedLock，在提供类似读写锁的同时，还支持优化读模式。优化读基于假设，大多数情况下读操作并不会和写操作冲突，其逻辑是先试着修改，然后通过validate方法确认是否进入了写模式，如果没有进入，就成功避免了开销；如果进入，则尝试获
  取读锁。

####  **问题七：**如何让Java的线程彼此同步？你了解过哪些同步器？请分别介绍下

**CountDownLatch**：倒计数 ，允许一个或多个线程等待某些操作完成

- 图书馆管理员：等到所有人全都离开后开关门

  ```java
  /**
   * @author: saber
   * @description: 模拟关门
   */
  public class CountDownLatchTest {
  
      public static void main(String[] args) throws InterruptedException {
          //设置计数器为6
          CountDownLatch latch = new CountDownLatch(6);
  
          for (int i = 0; i < 6; i++) {
              new Thread(()->{
                  System.out.println(Thread.currentThread().getName()+"已经离开");
                  latch.countDown();
              },String.valueOf(i+1)).start();
          }
  		//等待计数器归零
          latch.await();
          System.out.println("所有人都已离开，管理员关门");
  
      }
  ```

**CyclicBarrier**：叫循环栅栏，它实现让一组线程等待至某个状态之后再全部同时执行

- ​	聚会吃饭

  ```java
  /**
   * @author: saber
   * @description: 聚会吃饭
   * */
  public class CyclicBarrierTest {
      public static void main(String[] args) {
          //6人到齐之后开饭
          CyclicBarrier cyclicBarrier =
                  new CyclicBarrier(6, () -> System.out.println("所有人都已到齐，开饭"));
          for (int i = 0; i < 6; i++) {
              new Thread(()->{
                  try {
                      System.out.println(Thread.currentThread().getName()+"到了");
                      //等待所有人到齐
                      cyclicBarrier.await();
                  } catch (Exception e) {
                      e.printStackTrace();
                  } 
              }).start();
          }
      }
  }
  ```

  

**Semaphore**：版本的信号量实现，用于控制同时访问的线程个数，来达到限制通用资源访问的目的，通过**acquire()**获取一个许可，如果没有就等待，而**release()**释放一个许可。

- 车位停车：

  ```java
  **
   * @author: saber
   * @description: 抢车位
   */
  public class SemaphoreTest {
      public static void main(String[] args) {
          Semaphore semaphore = new Semaphore(3);
  
          for (int i = 0; i < 8; i++) {
              new Thread(()->{
                  try {
                      semaphore.acquire();
                      System.out.println(Thread.currentThread().getName()+"抢到了车位");
                      Thread.sleep(2000);
                      semaphore.release();
                      System.out.println(Thread.currentThread().getName()+"离开了车位");
                  }catch (Exception e){
  
                  }
              }).start();
          }
      }
  }
  ```

**问题八：CyclicBarrier和CountDownLatch区别在哪儿？**

- CountDownLatch是不可以重置，CyclicBarrier可以重置（reset()方法）。

- CountDownLatch的基本操作组合是countDown/await，线程阻塞等待足够的次数，

  CyclicBarrier的基本操作组合是await，当所有的伙伴都调用了await，才会继续进行任务，并自动进行重置。

- CountDownLatch目的是让一个线程等待其他N个线程达到某个条件后，自己再去做某个事。

  CyclicBarrier的目的是让N多程互相等待直到所有的都达到某个状态，再继续执行各自后续

##  **Java线程池相关问题**

####  问题一：Java中的线程池是如何实现的？

- 线程池中的“线程”，其实是一个静态内部类Worker，它基于AQS实现，存放在线程池的HashSet<Worker>workers成员变量中；
- 而需要执行的任务则存放在成员变量workQueue（BlockingQueue<Runnable>workQueue）中。
- 基本实现：从workQueue中不断取出需要执行的任务，放在Workers中进行处理。

####  问题二：创建线程池的几个核心构造参数？

七大参数

```java
**
 * @author: saber
 * @description: 线程池
 */
public class ThreadPoolTest {
    public static void main(String[] args) {
        ThreadPoolExecutor pool = new ThreadPoolExecutor(
                2, //核心线程池大小
                5, //最大线程池大小
                4, //超时释放等待时间
                TimeUnit.SECONDS, //时间单位
                new LinkedBlockingDeque<>(3), //阻塞队列 当最大线程池满了就进入这个队列 多余的按照拒绝策略处理
                Executors.defaultThreadFactory(), //线程工程
                new ThreadPoolExecutor.DiscardOldestPolicy()); //拒绝策略
        try {
            for (int i = 1; i <= 9 ; i++) {
                pool.execute(()-> System.out.println(Thread.currentThread().getName()+"----ok"));
            }
        }catch (Exception e){

        }finally {
            pool.shutdown();
        }
    }
}
```

####  **问题三：**线程池中的线程是怎么创建的？是一开始就随着线程池的启动创建好的吗？

显然不是的。线程池默认初始化后不启动Worker，等待有请求时才启动。每当我们调用execute()方法添加一个任务时，线程池会做如下判断：

- 如果正在运行的线程数量小于corePoolSize，那么马上创建线程运行这个任务；
- 如果正在运行的线程数量大于或等于corePoolSize，那么将这个任务放入队列；
- 如果这时候队列满了，而且正在运行的线程数量小于maximumPoolSize，那么还是要创建非核心线程立刻运行这个任务；
- 如果队列满了，而且正在运行的线程数量大于或等于maximumPoolSize，那么线程池会抛出异常RejectExecutionException。
- 当一个线程完成任务时，它会从队列中取下一个任务来执行。当一个
  线程无事可做，超过一定的时间（keepAliveTime）时，线程池会判
  断超时。
- 如果当前运行的线程数大于corePoolSize，那么这个线程就被停掉。
  所以线程池的所有任务完成后，它最终会收缩到corePoolSize的大
  小

####  **问题四：既然提到可以通过配置不同参数创建出不同的线程池，那么Java中默认实现好的线程池又有哪些呢？请比较它们的异同。**

**1. SingleThreadExecutor 线程池**

-   只有一个核心线程的线程池，也就是相当于单线程串行执行所有任务。如果这个唯一的线程因为异常结束，那么会有一个新的线程来替代它。此线程池保证所有任务的执行顺序按照任务的提交顺序执行。

**2. FixedThreadPool 线程池**

- 固定大小的线程池，只有核心线程。每次提交一个任务就创建一个线程，直到线程达到线程池的最大大小。线程池的大小一旦达到最大值就会保持不变，如果某个线程因为执行异常而结束，那么线程池会补充一个新线程。
- FixedThreadPool多数针对一些很稳定很固定的正规并发线程，多用于服务器。

**3. CachedThreadPool 线程池**

- 无界线程池，如果线程池的大小超过了处理任务所需要的线程，那么就会回收部分空闲（60秒不执行任务）线程，当任务数增加时，此线程池又可以智能的添加新线程来处理任务。线程池大小完全依赖于操作系统（或者说JVM）能够创建的最大线程大小。

**4. ScheduledThreadPool 线程池**

- 核心线程池固定，大小无限的线程池。用于定时以及周期性执行任务。

####  **问题五：**如何在Java线程池中提交线程？

1. **execute()**：接收一个Runable实例，它用来执行一个任务：

2. **submit()**：方法返回的是Future对象。可以用isDone()来查询Future是否已经完成，当任务完成时，它具有一个结果，可以调用get()来获取结果。也可以不用isDone()进行检查就直接调用get()，在这种情况下，get()将阻塞，直至结果准备就绪。

##  四、JVM

####  **Java 内 存 模 型 相 关 问 题**

####  **问题一：**什么是Java的内存模型，Java中各个线程是怎么彼此看到对方的变量的？

- 所有的变量都存储在主内存，
- 每条线程还有自己的工作内存，保存了被该线程使用到的变量的主内存副本拷贝。
- 线程对变量的所有操作（读取、赋值）都必须在工作内存中进行，不能直接读写主内存的变量。
- 不同的线程之间也无法直接访问对方工作内存的变量，线程间变量值的传递需要通过主内存。

####  问题二：请谈谈volatile有什么特点，为什么它能保证变量对所有线程的可见性？

- **线程间通信**
  
- volatile修饰的变量被当前线程修改后其他线程会感知到
  
- **禁止指令重排序**

  - 如果不用volatile修饰可能发生指令重排序，**invokespecial**在**astore_1**之后执行，o拿到的时一个半初始化状态的对象

  - #####   Object o = new Object()的初始化过程：

    ```
    new：申请一块内存空间用来存放对象
    invokespecial：调用构造方法对属性赋值（半初始化对象)
    astore_1：建立o和对象的关联（指针指向堆内存）
    ```

    

####  问题三：基于volatile变量的运算是并发安全的？

- 基于volatile变量的运算在并发下不一定是安全的。虽然volatile变量在各个线程的工作内存，不存在一致性问题，但是Java里面的运算并非原子操作，导致volatile变量的运算在并发下一样是不安全的。

####  问题四：请对比下volatile对比Synchronized的异同。

- Synchronized既能保证可见性，又能保证原子性，而volatile只能
  保证可见性，无法保证原子性。

####  问题五：请谈谈ThreadLocal是怎么解决并发安全的？

- ThreadLocal这是Java提供的一种保存线程私有信息的机制，因为其在整个线程生命周期内有效，所以可以方便地在一个线程关联的不同业务模块之间传递信息，比如事务ID、Cookie等上下文相关信息。
- ThreadLocal为每一个线程维护变量的副本，把共享数据的可见范围限制在同一个线程之内，其实现原理是，在ThreadLocal类中有一个Map，用于存储每一个线程的变量的副本。

####  **问题六：**很多人都说要慎用ThreadLocal，谈谈你的理解，使用ThreadLocal需要注意些什么？

- ThreadLocal的实现是基于一个的ThreadLocalMap，它的key是一个弱引用。在回收时不会清除数据，再次的调用线程池就会导致值错乱、oom
- remove()；

####  JVM内存：

####  问题一：内存模型以及分区，需要详细到每个区放什么？

- 方法区：主要是存储类信息，常量池（static常量和static变量），编译后的代码（字节码）等数据
- 堆：初始化的对象，成员变量（那种非static的变量），所有的对象实例和数组都要在堆上分配
- 栈：栈的结构是栈帧组成的，调用一个方法就压入一帧，帧上面存储局部变量表，操作数栈，方法出口等信息，局部变量表存放的是8大基础类型加上一个应用类型，所以还是一个指向地址的指针
- 本地方法栈：主要为Native方法服务
- 程序计数器：记录当前线程执行的行号

####  问题二：堆里面的分区，各自的特点。

- **新生代**： 复制算法
  - Eden区   8
  - Survivor区
    - form  1
    - to      1
- **老年代**：标记压缩、清除
- **元空间**：

####  问题三：jvm如何确定一个对象是垃圾？

- **引用计数 reference count**
- **根可达性 root searching**

####  问题四：GC算法有哪些？

- **mark-sweep 标记清除**（效率高 会产生碎片化问题）
- **copying 复制**（浪费空间 Eden区 8:1:1 使用此算法，每次使用一半的空间，有用的拷贝到to，清除from区）
- **mark-compact标记压缩**（效率低节约空间 老年代使用此算法）

####  问题五：GC 收集器有哪些？

![](https://s1.ax1x.com/2020/09/11/wYghWR.png)

####  问题六. 几种常用的内存调试工具

- jstack 可以看当前栈的情况，
- jmap 查看内存
- hat 进行 dump 堆的信息

####  问题七：java 类加载过程?

- **加载**

1. 通过一个类的全限定名获取该类的二进制流。

2. 将该二进制流中的静态存储结构转化为方法去运行时数据结构。

3. 在内存中生成该类的 Class 对象，作为该类的数据访问入口。

- **验证**

1. 文件格式验证：验证字节流是否符合 Class 文件的规范，如主次版本号是否在当前虚拟机范围内，常量池中的常量是否有不被支持的类型.

2. 元数据验证:对字节码描述的信息进行语义分析，如这个类是否有父类，是否集成了不被继承的类等。

3. 字节码验证：是整个验证过程中最复杂的一个阶段，通过验证数据流和控制流的分析，确定程序语义是否正确，主要针对方法体的验证。如：方法中的类型转换是否正确，跳转指令是否正确等。4. 符号引用验证：这个动作在后面的解析过程中发生，主要是为了确保解析动作能正确执行。

- **准备**：为类的静态变量分配内存并将其初始化为默认值

- **解析**：完成符号引用到直接引用的转换

- **初始化**：开始执行类中定义的 Java 程序代码。
- **使用**
- **卸载**

####  问题八：**简述 java 类加载机制**

- 虚拟机把描述类的数据从 Class 文件加载到内存，并对数据进行校验，解析和初始化，最终形成可以被虚拟机直接使用的 java 类型

####  问题九：**类加载器双亲委派模型机制？**

- 当一个类收到了类加载请求时，不会自己先去加载这个类，而是将其委派给父类，由父类去加载，如果此时父类不能加载，反馈给子类，由子类去完成类的加载。

####  问题十**.什么是类加载器，类加载器有哪些?**

1. 启动类加载器(Bootstrap ClassLoader)用来加载 java 核心类库，无法被 java 程序直接引用。

2. 扩展类加载器(extensions class loader):它用来加载 Java 的扩展库。

3. 系统类加载器（system class loader）：根据 Java 应用的类路径（CLASSPATH）来加载 Java 类。

4. 用户自定义类加载器，通过继承 java.lang.ClassLoader 类的方式实现
   

##  五、**Tomcat**

####  问题一：**Tomcat** **的缺省端口是多少，怎么修改？**

- 8080
- 修改conf文件夹下的server.xml

####  问题二：**tomcat** **有哪几种** **Connector** 运行模式？

- bio：传统的 Java I/O 操作，同步且阻塞 IO。
- nio：JDK1.4 开始支持，同步阻塞或同步非阻塞 IO。
- aio(nio.2)：JDK7 开始支持，异步非阻塞 IO。

####  问题三：**Tomcat** **有几种部署方式**？

1. 直接把 Web 项目放在 webapps 下，Tomcat 会自动将其部署
2. 在 server.xml 文件上配置<Context>节点，设置相关的属性即可
3. 通过 Catalina 来进行配置:进入到 conf\Catalina\localhost 文件下，创建一个xml 文件，该文件的名字就是站点的名字。编写 XML 的方式来进行设置。

####  问题四：**tomcat** **容器是如何创建** **servlet** **类实例？用到了什么原理？**

- 读取在 webapps 目录下所有的 web 应用中的 web.xml 文件
- 解析xml文件，读取 servlet 注册信息。
- 将每个应用中注册的 servlet 类都进行加载，
- 并通过反射的方式实例化。（有时候也是在第一次请求时实例化）在 servlet 注册时加上如果为正数，在一开始就实例化，如果不写或为负数，则第一次请求实例化。

####  问题五：**tomcat** **如何优化？**

- 优化连接配置.这里以 tomcat7 的参数配置为例，需要修改 conf/server.xml文件，修改连接数，关闭客户端 dns 查询
- 给 Tomcat 配置 gzip 压缩(HTTP 压缩)功能

####  问题六：**内存调优垃圾回收策略调优**

-  catalina.sh 中，调整 JAVA_OPTS 变量

####  问题六：一次请求的完整过程

1. 请求被发送到本机端口 8080，被在那里侦听的 Coyote HTTP/1.1Connector 获得
2. Connector 把该请求交给它所在的 Service 的 Engine 来处理，并等待来自Engine 的回应
3. Engine 获得请求 localhost/yy/index.jsp，匹配它所拥有的所有虚拟主机 Host
4.  Engine 匹配到名为 localhost 的 Host（即使匹配不到也把请求交给该 Host处理，因为该 Host 被定义为该 Engine 的默认主机）
5.  localhost Host 获得请求/yy/index.jsp，匹配它所拥有的所有 Context
6. Host 匹配到路径为/yy 的 Context（如果匹配不到就把该请求交给路径名为”“的 Context 去处理）
7. path=”/yy”的 Context 获得请求/index.jsp，在它的 mapping table 中寻找对应的 servlet
8. Context 匹配到 URL PATTERN 为*.jsp 的 servlet，对应于 JspServlet 类
9. 构造 HttpServletRequest 对象和 HttpServletResponse 对象，作为参数调用JspServlet 的 doGet 或 doPost 方法
10. Context 把执行完了之后的 HttpServletResponse 对象返回给 Host
11. Host 把 HttpServletResponse 对象返回给 Engine
12. Engine 把 HttpServletResponse 对象返回给 Connector
13. Connector 把 HttpServletResponse 对象返回给客户 browser

####  问题七：**Tomcat** **工作模式？**

- Tomcat 作为应用程序服务器：请求来自于前端的 web 服务器，这可能是Apache, IIS, Nginx 等
- Tomcat 作为独立服务器：请求来自于 web 浏览器；


##  六、Nginx

####  **1、请解释一下什么是 Nginx?**

- Nginx 是一个 web 服务器和反向代理服务器，用于 HTTP、HTTPS、SMTP、POP3和 IMAP 协议。

####  **2、请列举 Nginx 的一些特性。**

- 反向代理/L7 负载均衡器

- 嵌入式 Perl 解释器

- 动态二进制升级

- 可用于重新编写 URL，具有非常好的 PCRE 支持

####  **3、请列举 Nginx 和 Apache 之间的不同点**

- Apache是同步多进程模型，一个连接对应一个进程
- Nginx是异步的，多个连接（万级别）可以对应一个进程。

####  **4、请解释 Nginx 如何处理 HTTP 请求。**

- Nginx 使用反应器模式。主事件循环等待操作系统发出准备事件的信号，这样数据就可以从套接字读取，在该实例中读取到缓冲区并进行处理。单个线程可以提供数万个并发连接。

####  **5、在 Nginx 中，如何使用未定义的服务器名称来阻止处理请求?**

- 只需将请求删除的服务器就可以定义为：

```
Server {
	listen 80;
	server_name “ “ ;
	return 444;
}
```

- 服务器名被保留为一个空字符串，它将在没有“主机”头字段的情况下匹配请求，而一个特殊的 Nginx 的非标准代码 444 被返回，从而终止连接。

####  **6、 使用“反向代理服务器”的优点是什么?**

- 反向代理服务器可以隐藏源服务器的存在和特征。它充当互联网云和 web 服务器之间的中间层。这对于安全方面来说是很好的，特别是当您使用 web 托管服务时。

####  **7、请列举 Nginx 服务器的最佳用途。**

- Nginx 服务器的最佳用法是在网络上部署动态 HTTP 内容，使用 SCGI、WSGI 应用程序服务器、用于脚本的 FastCGI 处理程序。它还可以作为负载均衡器。

####  **8、请解释 Nginx 服务器上的 Master 和 Worker 进程分别是什么?**

- Master 进程：读取及评估配置和维持

- Worker 进程：处理请求

####  **9、请解释你如何通过不同于 80 的端口开启 Nginx?**

- 进入/etc/Nginx/sitesenabled/，如果这是默认文件，那么你打开名为“default”的文件。放置在你想要的端口：

  ```
  Like server { listen 81; }
  ```

####  **10、请解释是否有可能将 Nginx 的错误替换为 502 错误、503?**

- fastcgi_intercept_errors 被设置为 ON，并使用错误页面指令。

```
Location / {
	fastcgi_pass 127.0.01:9001;
	fastcgi_intercept_errors on;e
	rror_page 502 =503/error_page.html;
	# …
}
```

####  **11、在 Nginx 中，解释如何在 URL 中保留双斜线?**

- 使用 merge_slashes_off;

####  **12、请解释 ngx_http_upstream_module 的作用是什么?**

- 定义可通过 fastcgi 传递、proxy 传递、uwsgi传递递、memcached 传递和 scgi 传递指令来引用的服务器组。

####  **13、请解释什么是 C10K 问题?**

- C10K 问题是指无法同时处理大量客户端(10,000)的网络套接字。

####  **14、请陈述 stub_status 和 sub_filter 指令的作用是什么?**

- Stub_status 指令：该指令用于了解 Nginx 当前状态的当前状态，如当前的活动连接，接受和处理当前读/写/等待连接的总数

- Sub_filter 指令：它用于搜索和替换响应中的内容，并快速修复陈旧的数据

####  **15、解释 Nginx 是否支持将请求压缩到上游?**

- 使用 Nginx 模块 gunzip 将请求压缩到上游。它可以对不支持“gzip”编码方法的客户机或服务器使用“内容编码:gzip”来解压缩响应。

####  **16、解释如何在 Nginx 中获得当前的时间?**

- 使用 SSI 模块、$date_gmt 和$date_local 的变量。

```
Proxy_set_header THE-TIME $date_gmt;
```

####  **17、用 Nginx 服务器解释-s 的目的是什么?**

- 用于运行 Nginx -s 参数的可执行文件。


####  七、数据库

####  **请简洁描述 MySQL 中 InnoDB 支持的四种事务隔离级别名称，以及逐级之间的区别？**：

- **read uncommited ：**读到未提交数据

- **read committed：**脏读，不可重复读

- **repeatable read：**可重读

- **serializable ：**串行事物

####  **在 MySQL 中 ENUM 的用法是什么？**

- ENUM 是一个字符串对象，用于指定一组预定义的值，并可在创建表时使用。

```sql
Create table size(name ENUM('Smail,'Medium','Large');
```

####  **CHAR 和 VARCHAR 的区别？**

- CHAR 和 VARCHAR 类型在存储和检索方面有所不同。

- CHAR 列长度固定为创建表时声明的长度，长度值范围是 1 到 255。 

- 当 CHAR 值被存储时，它们被用空格填充到特定长度，检索 CHAR 值时需删除尾随空格。

####  **列的字符串类型可以是什么？**

- SET

- BLOB

- ENUM

- CHAR

- TEXT

- VARCHAR

####  **MySQL 中使用什么存储引擎？**

- 存储引擎称为表类型，数据使用各种技术存储在文件中。

- 技术涉及：
  - Storage mechanism
  - Locking levels
  - Indexing
  - Capabilities and functions.

####  **TIMESTAMP 在 UPDATE CURRENT_TIMESTAMP 数据类型上做什么？**

- 创建表时 TIMESTAMP 列用 Zero 更新。只要表中的其他字段发生更改，UPDATECURRENT_TIMESTAMP 修饰符就将时间戳字段更新为当前时间。

####  **主键和候选键有什么区别？**

- 表格的每一行都由主键唯一标识, 一个表只有一个主键。主键也是候选键。按照惯例，候选键可以被指定为主键，并且可以用于任何外键引用。

**MySQL 数据库服务器性能分析的方法命令有哪些?**

```sql
-- 列出MySQL服务器运行各种状态值：
show global status;
-- 慢查询
show variables like '%slow%';
-- 连接数
show variables like 'max_connections'; 
show variables like ‘key_buffer_size’; 
```

**BLOB 和 TEXT 有什么区别？**

- **BLOB** 是一个二进制对象，可以容纳可变数量的数据。有四种类型的 BLOB
  - TINYBLOB
  - BLOB
  - MEDIUMBLOB 和
  - LONGBLOB

- TEXT 是一个不区分大小写的 BLOB。四种 TEXT 类型
  - TINYTEXT
  - TEXT
  - MEDIUMTEXT 和 
  - LONGTEXT

- BLOB 和 TEXT 类型之间的唯一区别在于对 BLOB 值进行排序和比较时区分大小写，对 TEXT 值不区分大小写。

####  **数据库的三范式？**

- 第一范式：数据库表的每一个字段都是不可分割的。

- 第二范式：数据库表中的非主属性只依赖于主键。

- 第三范式：不存在非主属性对关键字的传递函数依赖关系。

**MySQL 表中允许有多少个 TRIGGERS？** 

- 在 MySQL 表中允许有六个触发器，如下：
  - BEFORE INSERT
  - AFTER INSERT
  - BEFORE UPDATE
  - AFTER UPDATE
  - BEFORE DELETE 
  - AFTER DELETE

####  **什么是通用 SQL 函数？**

#####  数学函数

- Abs（num）求绝对值


- floor（num）向下取整


- ceil（num）向上取整


#####  字符串函数

- insert (s1,index,length,s2) 替换函数


- upper（str），ucase（str）将字母改为大写


- lower（str），lcase（str）将字母改为小写


- left（str，length）返回 str 字符串的前 length 个字符


- right（str，length）返回 str 字符串的后 length 个字符


- substring（str，index，length）返回 str 字符串从 index 位开始长度为
- length 个字符（index 从 1 开始）
- reverse（str）将 str 字符串倒序输出

#####  日期函数

- curdate（）、current_date( ) 获取当前日期
- curtime（）、current_time( ) 获取当前日期
- now（）获取当前日期和时间

- datediff（d1、d2）d1 和 d2 之间的天数差


- adddate（date，num）返回 date 日期开始，之后 num 天的日期


- subdate（date，num）返回 date 日期开始，之前 num 天的日期
- 
- 日期函数

- Count（字段）根据某个字段统计总记录数（当前数据库保存到多少条数据）

#####  聚合函数

- sum（字段）计算某个字段的数值总和


- avg（字段）计算某个字段的数值的平均值


- Max（字段）、min（字段）求某个字段最大或最小值

####  **MySQL 中有哪几种锁？**

- MyISAM 支持表锁，

- InnoDB 支持表锁和行锁，默认为行锁。

- 表级锁：开销小，加锁快，不会出现死锁。锁定粒度大，发生锁冲突的概率最高，并发量最低。

- 行级锁：开销大，加锁慢，会出现死锁。锁力度小，发生锁冲突的概率小，并发度最高。

####  **MySQL 数据优化。**

- **优化数据类型**
  -  避免使用 NULL，NULL 需要特殊处理, 大多数时候应该使用 NOTNULL，或者使用一个特殊的值，如 0，-1 作为默认值。 
  - 仅可能使用更小的字段，MySQL 从磁盘读取数据后是存储到内存中的，然后使用 cpu 周期和磁盘 I/O 读取它，这意味着越小的数据类型占用的空间越小. 

- **小心字符集转换**
  - 客户端或应用程序使用的字符集可能和表本身的字符集不一样，这需要MySQL 在运行过程中隐含地进行转换，此外，要确定字符集如 UTF-8 是否支持多字节字符，因此它们需要更多的存储空间。

- **_优化 count(mycol) 和 count()**** 

- **优化子查询**
  - 遇到子查询时，MySQL 查询优化引擎并不是总是最有效的，这就是为什么经常将子查询转换为连接查询的原因了，优化器已经能够正确处理连接查询了，当然要注意的一点是，确保连接表 (第二个表) 的连接列是有索引的，在第一个表上 MySQL 通常会相对于第二个表的查询子集进行一次全表扫描，这是嵌套循环算法的一部分。

- **优化 UNION**
  - 在跨多个不同的数据库时使用 UNION 是一个有趣的优化方法，UNION 从两个互不关联的表中返回数据，这就意味着不会出现重复的行，同时也必须对数据进行排序，我们知道排序是非常耗费资源的，特别是对大表的排序。
  - UNION ALL 可以大大加快速度，如果你已经知道你的数据不会包括重复行，或者你不在乎是否会出现重复的行，在这两种情况下使用UNION ALL 更适合。此外，还可以在应用程序逻辑中采用某些方法避免出现重复的行，这样 UNION ALL 和 UNION 返回的结果都是一样的，但 UNION ALL 不会进行排序。

####  **MySQL 的关键字。**

#####  添加索引：

```
alter table** tableName **add** 索引（索引字段）

主键：primary key

唯一：unique

全局：fulltext

普通：index

多列： index index_name

页级: 引擎 BDB。次锁定相邻的一组记录。

表级: 引擎 MyISAM ， 理解为锁住整个表，可以同时读，写不行。 

行级: 引擎INNODB ， 单独的一行记录加锁，对指定的记录进行加锁，这样其它进程还是可以对同一个表中的其它记录进行操作。 表级锁速度快，但冲突多，行级冲突少，但速度慢。
```

####  **存储引擎。**

- 存储引擎说白了就是如何存储数据、如何为存储的数据建立索引和如何更新、查询数据等技术的实现方法。

- MyISAM：这种引擎是 mysql 最早提供的。
  - 静态 MyISAM：如果数据表中的各数据列的长度都是预先固定好的，服务器将自动选择这种表类型。因为数据表中每一条记录所占用的空间都是一样的，所以这种表存取和更新的效率非常高。当数据受损时，恢复工作也比较容易做。
  - 动态 MyISAM：如果数据表中出现 varchar、text 或 BLOB 字段时，服务器将自动选择这种表类型。相对于静态 MyISAM，这种表存储空间比较小，但由于每条记录的长度不一，所以多次修改数据后，数据表中的数据就可能离散的存储在内存中，进而导致执行效率下降。同时，内存中也可能会出现很多碎片。因此，这种类型的表要经常用optimize table 命令或优化工具来进行碎片整理。
  - 压缩 MyISAM：以上说到的两种类型的表都可以用 myisamchk 工具压缩。这种类型的表进一步减小了占用的存储，但是这种表压缩之后不能再被修改。另外，因为是压缩数据，所以这种表在读取的时候要先时行解压缩。但是，不管是何种 MyISAM 表，目前它都不支持事务，行级锁和外键约束的功能。

- MyISAM Merge 引擎：这种类型是 MyISAM 类型的一种变种。合并表是将几个相同的 MyISAM 表合并为一个虚表。常应用于日志和数据仓库。 InnoDB：InnoDB 表类型可以看作是对 MyISAM 的进一步更新产品，它提供了事务、行级锁机制和外键约束的功能。

- memory(heap)：这种类型的数据表只存在于内存中。它使用散列索引，所以数据的存取速度非常快。因为是存在于内存中，所以这种类型常应用于临时表中。

-  archive：这种类型只支持 select 和 insert 语句，而且不支持索引。

- Desc[ribe] tablename：查看数据表的结构。

-  show engines：命令可以显示当前数据库支持的存储引擎情况。

####  **数据库备份。**

#####  必须要在未登录状态下

```sql
-- 导出整个数据库
mysqldump -u 用户名 -p 数据库名 > 导出的文件名

-- 导出一个表
mysqldump -u 用户名 -p 数据库名 表名> 导出的文件名

-- 导出一个数据库结构
mysqldump -u dbuser -p -d --add-drop-table
dbname >d:/dbname_db.sql
-d 没有数据 --add-drop-table 在每个 create 语句之前增加一个 drop table
```

####  **truncate delete drop 的区别。**

- **drop(DDL 语句)：**是不可逆操作，会将表所占用空间全部释放掉；
- **truncate(DDL 语句)：**只针对于删除表的操作，在删除过程中不会激活与表有关的删除触发器并且不会把删除记录放在日志中；当表被 truncate 后，这个表和索引会恢复到初始大小；
- **delete(DML 语句)：**可以删除表也可以删除行，但是删除记录会被计入日志保存，而且表空间大小不会恢复到原来；

#####  执行速度：drop>truncate>delete。



####  **Redis 是什么？两句话做一下概括。**

- 是一个完全开源免费的 key-value 内存数据库  通常被认为是一个数据结构服务器，主要是因为其有着丰富的数据结构 strings、map、 list、sets、 sorted sets。 

-  Redis 使用最佳方式是全部数据 in-memory。 

-  Redis 更多场景是作为 Memcached 的替代者来使用。

- 当需要除 key/value 之外的更多数据类型支持时，使用 Redis 更合适。

-  当存储的数据不能被剔除时，使用 Redis 更合适。

####  **Redis（管道，哈希）。**

-  Redis 不仅仅支持简单的 k/v 类型的数据，同时还提供 list，set，zset，hash 等数据结构的存储。

- Redis 支持数据的备份，即 master-slave 模式的数据备份。

-  Redis 支持数据的持久化，可以将内存中的数据保持在磁盘中，重启的时候可以再次加载进行使用。**Redis 实现原理或机制。**

- Redis 是一个 key-value 存储系统。支持更多无化的 value 类型，除了和 string 外，还支持lists（链表）、sets（集合）和 zsets（有序集合）几种数据类型。这些数据类型都支持 push/pop、add/remove 及取交集并集和差集及更丰富的操作，而且这些操作都是原子性的。

- Redis 是一种基于客户端 - 服务端模型以及请求 / 响应协议的 TCP 服务。这意味着通常情况下一个请求会遵循以下步骤：
  - 客户端向服务端发送一个查询请求，并监听 Socket 返回，通常是以阻塞模式，等待服务端响应。服务端处理命令，并将结果返回给客户端。
  - 在服务端未响应时，客户端可以继续向服务端发送请求，并最终一次性读取所有服务端的响应。

- **Redis 管道技术**最显著的优势是提高了 Redis 服务的性能。

####  Resis分区:

将数据分割到多个 Redis 实例的处理过程，每个实例只保存 key 的一个子集。

通过利用多台计算机内存的和值，允许我们构造更大的数据库。

**Redis 有两种类型分区。**

- 按范围分区，映射一定范围的对象到特定的 Redis 实例。

- 哈希分区：这对任何 key 都适用，用一个 hash 函数将 key 转换为一个数字，比如使用 crc32 hash 函数。对 keyfoobar 执行 crc32(foobar) 会输出类似 93024922 的整数。对这个整数取模，将其转化为 0-3 之间的数字，就可以将这个整数映射到 4 个Redis 实例中的一个了。93024922 % 4 = 2，就是说 key foobar 应该被存到 R2实例中。注意：取模操作是取除的余数，通常在多种编程语言中用 % 操作符实现。

- 实际上，上面的集群模式还存在两个问题：
  - 扩容问题：因为使用了一致性哈稀进行分片，那么不同的 key 分布到不同的 RedisServer 上，当我们需要扩容时，需要增加机器到分片列表中，这时候会使得同样的 key 算出来落到跟原来不同的机器上，这样如果要取某一个值，会出现取不到的情况，对于这种情况，
  -  单点故障问题：
    - 还是用到 Redis 主从复制的功能，两台物理主机上分别都运行有 RedisServer，其中一个 Redis-Server 是另一个的从库，采用双机热备技术，客户端通过虚拟 IP 访问主库的物理 IP，当主库宕机时，切换到从库的物理 IP。只是事后修复主库时，应该将之前的从库改为主库（使用命令 slaveof noone），主库变为其从库（使命令 slaveof IP PORT），这样才能保证修复期间新增数据的一致性。



####  **这里对 Redis 数据库做下小结。**

1. 提高了 DB 的可扩展性，只需要将新加的数据放到新加的服务器上就可以了

2. 提高了 DB 的可用性，只影响到需要访问的 shard 服务器上的数据的用户

3. 提高了 DB 的可维护性，对系统的升级和配置可以按 shard 一个个来搞，对服务产生的影响较小

4. 小的数据库存的查询压力小，查询更快，性能更好


##  八、MySQL数据库

####  1.数据库三范式是什么?

1. 第一范式（1NF）：字段具有原子性,不可再分。(所有关系型数据库系统都满足第一范式数据库表中的字段都是单一属性的，不可再分)

2. 第二范式（2NF）是在第一范式（1NF）的基础上建立起来的，即满足第二范式（2NF）必须先满足第一范式（1NF）。要求数据库表中的每个实例或行必须可以被惟一地区分。通常需要为表加上一个列，以存储各个实例的惟一标识。这个惟一属性列被称为主关键字或主键。

3. 满足第三范式（3NF）必须先满足第二范式（2NF）。简而言之，第三范式（3NF）要求一个数据库表中不包含已在其它表中已包含的非主关键字信息。 >所以第三范式具有如下特征：
   -  每一列只有一个值 
   - 每一行都能区分。 
   - 每一个表都不包含其他表已经包含的非主关键字信息。

####  **2.有哪些数据库优化方面的经验**?

1. 用 PreparedStatement， 一般来说比 Statement 性能高：一个 sql发给服务器去执行，涉及步骤：语法检查、语义分析， 编译，缓存。

2. 有外键约束会影响插入和删除性能，如果程序能够保证数据的完整性，那在设计数据库时就去掉外键。

3. 表中允许适当冗余，譬如，主题帖的回复数量和最后回复时间等

4. UNION ALL 要比 UNION 快很多，所以，如果可以确认合并的两个结果集中不包含重复数据且不需要排序时的话，那么就使用 UNIONALL。 

####  **3.**请简述常用的索引有哪些种类?

1. 普通索引: 即针对数据库表创建索引

2. 唯一索引: 与普通索引类似，不同的就是：MySQL 数据库索引列的值必须唯一，但允许有空值

3. 主键索引: 它是一种特殊的唯一索引，不允许有空值。一般是在建表的时候同时创建主键索引

4. 组合索引: 为了进一步榨取 MySQL 的效率，就要考虑建立组合索引。将数据库表中的多个字段联合起来作为一个组合索引。

####  **4.在** **mysql** **数据库中索引的工作机制是什么？

- 数据库索引是数据库管理系统中一个排序的数据结构，以协助快速查询、更新数据库表中数据。索引的实现通常使用 B 树及其变种 B+树

####  **5.MySQL** **的基础操作命令**:

1. MySQL 是否处于运行状态:Debian 上运行命令 service mysql status，在 RedHat 上运行命令 service mysqld status

2. 开启或停止 MySQL 服务 :运行命令 service mysqld start 开启服务；运行命令 service mysqld stop 停止服务

3. Shell 登入 MySQL: 运行命令 mysql -u root -p

4. 列出所有数据库:运行命令 show databases;

5. 切换到某个数据库并在上面工作:运行命令 use database*name;* *进入*名为*database*name 的数据库

6. 列出某个数据库内所有表: show tables;

7. 获取表内所有 Field 对象的名称和类型 :describe table_name;

####  **6.mysql** **的复制原理以及流程。**

- 将 Mysql 的数据分布到多个系统上去，通过将 Mysql 的某一台主机的数据复制到其它主机（slaves）上，并重新执行一遍来实现的。 
- 复制过程中一个服务器充当主服务器，而一个或多个其它服务器充当从服务器。主服务器将更新写入二进制日志文件，并维护文件的一个索引以跟踪日志循环。这些日志可以记录发送到从服务器的更新。 当一个从服务器连接主服务器时，它通知主服务器在日志中读取的最后一次成功更新的位置。从服务器接收从那时起发生的任何更新，然后封锁并等待主服务器通知新的更新。 
- 过程如下 
  - 1. 主服务器把更新记录到二进制日志文件中。 
    2. 从服务器把主服务器的二进制日志拷贝到自己的中继日志（replay log）中。 、
    3.  从服务器重做中继日志中的时间，把更新应用到自己的数据库上。

####  **7.mysql** **支持的复制类型**?

1. 基于语句的复制： 在主服务器上执行的 SQL 语句，在从服务器上执行同样的语句。MySQL 默认采用基于语句的复制，效率比较高。 一旦发现没法精确复制时，会自动选着基于行的复制。

2. 基于行的复制：把改变的内容复制过去，而不是把命令在从服务器上执行一遍. 从 mysql5.0 开始支持

3. 混合类型的复制: 默认采用基于语句的复制，一旦发现基于语句的无法精确的复制时，就会采用基于行的复制。

####  **8.mysql** **中** **myisam** **与** **innodb** **的区别？**

-  MyISAM**：强调的是性能，每次查询具有原子性**,执行速度比 InnoDB 类型更快，但是不提供事务支持。 

- InnoDB：提供事务支持事务，外部键等高级数据库功能。 具有事务(commit)、回滚(rollback)和崩溃修复能力(crash recovery capabilities)的事务安全(transaction-safe (ACID compliant))型表。

- InnoDB 支持行级锁，而 MyISAM 支持表级锁. 
  - 用户在操作myisam 表时，select，update，delete，insert 语句都会给表自动加锁，如果加锁以后的表满足 insert 并发的情况下，可以在表的尾部插入新的数据。

- InnoDB 支持 MVCC, 而 MyISAM 不支持
- InnoDB 支持外键，而 MyISAM 不支持

-  MyISAM：允许没有任何索引和主键的表存在，索引都是保存行的地址。 
-  InnoDB：如果没有设定主键或者非空唯一索引，就会自动生成一个 6 字节的主键(用户不可见)，数据是主索引的一部分，附加索引保存的是主索引的值。

- InnoDB 不支持全文索引，而 MyISAM 支持。

-  MyISAM**：数据是以文件的形式存储，所以在跨平台的数据转移中会很方便。在备份和恢复时可单独针对某个表进行操作。 
- InnoDB：免费的方案可以是拷贝数据文件、备份binlog，或者用 mysqldump，在数据量达到几十 G 的时候就相对痛苦了

- 每个 MyISAM 在磁盘上存储成三个文件。第一个文件的名字以表的名字开始，扩展名指出文件类型。**.frm 文件存储表定义。数据文件的扩展名为*.MYD (MYData)。索引文件的扩展名**是**.MYI (MYIndex)**。
- nnoDB：所有的表都保存在同一个数据文件中（也可能是多个文件，或者是独立的表空间文件），InnoDB 表的大小只受限于操作系统文件的大小，一般为 2GB。

####  **9.mysql** **中** **varchar** **与** **char** **的区别以及** **varchar(50)**中的 **50** **代表的涵**义？

1. varchar 与 char 的区别: char 是一种固定长度的类型，varchar 则是一种可变长度的类型.

2. varchar(50)中 50 的涵义 : 最多存放 50 个字节

3. int（20）中 20 的涵义: int(M)中的 M indicates the maximumdisplay width (最大显示宽度)for integer types. The maximumlegal display width is 255.

####  **10.MySQL** **中** **InnoDB** **支持的四种事务隔离级别名称，以及逐级之间的区**别？

1. **Read Uncommitted（读取未提交）** 
   
- 在该隔离级别，所有事务都可以看到其他未提交事务的执行结果。读取未提交的数据，也被称之为脏读（Dirty Read）。
   
2. **Read Committed（读已提交）** 

   一个事务只能看见已经提交事务所做的改变。这种隔离级别也支持所谓的

3. **Repeatable Read（可重复读）** 

   -  这是 MySQL 的默认事务隔离级别，它确保同一事务的多个实例在并发读取数据时，会看到同样的数据行。

4. **Serializable（可串行化）** 
   
   -  通过强制事务排序，在每个读的数据行上加上共享锁。使之不可能相互冲突，从而解决幻读问题。

####  **11.表中有大字段X，且字段** **X** **不会经常更新，以读为为主，将该字段拆成子表好处是什么？**

- MYSQL 数据库的记录存储是按行存储的，数据块大小是固定的16K，每条记录越小，相同的块存储的记录就越多。此时把大字段拆走，，就能提高效率。

**12.MySQL** **中** **InnoDB** **引擎的行锁是通过加在什么上完成（或称实现）的？**

- InnoDB 行锁是通过给索引上的索引项加锁来实现的，InnoDB 这种行锁实现特点意味着：只有通过索引条件检索数据，InnoDB 才使用行级锁，否则，InnoDB 将使用表锁！

####  **13.MySQL** **中控制内存分配的全局参数，有哪些？**

1. Key*buffer*size： 指定索引缓冲区的大小，它决定索引处理的速度，尤其是索引读的速度。

2. innodb*buffer*pool_size ：表示缓冲池字节大小，InnoDB缓存

3. query*cache*size ：查询结果缓存

4. read*buffer*size >是 MySQL 读入缓冲区大小。

####  **14.若一张表中只有一个字段 VARCHAR(N)类型，utf8编码，则N最大值为多少**

- 由于 utf8 的每个字符最多占用 3 个字节。而 MySQL 定义行的长度不能超过65535，因此 N 的最大值计算方法为：(65535-1-2)/3。减去 1 的原因是实际存储从第二个字节开始，减去 2 的原因是因为要在列表长度存储实际的字符长度，除以 3 是因为 utf8 限制：每个字符最多占用 3 个字节。

####  **15. [SELECT \*]** 和[SELECT** **全部字段****]的 **2** **种写法有何优缺点?**

1. 前者要解析数据字典，后者不需要

2. 结果输出顺序，前者与建表列顺序相同，后者按指定字段顺序。

3. 表字段改名，前者不需要修改，后者需要改

4. 后者可以建立索引进行优化，前者无法优化

5. 后者的可读性比前者要高

####  **16.HAVNG** **子句 和** **WHERE** **的异同点?**

1. 语法上：where 用表中列名，having 用 select 结果别名

2. 影响结果范围：where 从表读出数据的行数，having 返回客户端的行数

3. 索引：where 可以使用索引，having 不能使用索引，只能在临时结果集操作

4. where 后面不能使用聚集函数，having 是专门使用聚集函数的。

####  **17.MySQL **当记录不存在时** **insert,当记录存在时 **update语句怎么写？**

```sql
INSERT INTO table (a,b,c) VALUES (1,2,3) ON DUPLICATE KEY
UPDATE c=c+1;
```

**18.MySQL** **的** **insert** **和** **update** **的** **select** **语句语法**

```sql
SQL insert into student (stuid,stuname,deptid) select 10,'xzm',3

from student where stuid > 8;

update student a inner join student b on b.stuID=10 set

a.stuname=concat(b.stuname, b.stuID) where a.stuID=10 ; 
```

##  九、Redis

####  问题一：Redis 支持哪几种数据类型？

- String、List、Set、Sorted Set、hashes

####  问题二：Redis 有哪几种数据淘汰策略？

1. noeviction:返回错误当内存限制达到，并且客户端尝试执行会让更多内存被使用的命令。
2. allkeys-lru: 尝试回收最少使用的键（LRU），使得新添加的数据有空间存放。
3. volatile-lru: 尝试回收最少使用的键（LRU），但仅限于在过期集合的键,使得新添加的数据有空间存放。
4. allkeys-random: 回收随机的键使得新添加的数据有空间存放。
5. volatile-random: 回收随机的键使得新添加的数据有空间存放，但仅限于在过期集合的键。
6. volatile-ttl: 回收在过期集合的键，并且优先回收存活时间（TTL）较短的键,使得新添加的数据有空间存放。

####  问题三：Redis 集群方案应该怎么做？都有哪些方案？

- **官方cluster方案**
  - 采用无中心结构，每个节点保存数据和整个集群状态，每个节点都和其他节点连接。
- **twemproxy代理方案**
  - 利用**twemproxy做分片的技术。twemproxy处于客户端和服务器的中间，将客户端发来的请求，进行一定的处理后（sharding），再转发给后端真正的redis服务器。
- **Sentinel哨兵模式**
  - 每个Sentinel以每秒钟一次的频率向它所知的Master、Slave以及其他Sentinel实例发送一个PING命令。并在被监视的主服务器进入下线状态时，自动将下线主服务器属下的某个从服务器升级为新的主服务器。
- **codis**
- **客户端分片**
  - 分区的逻辑在客户端实现，由客户端自己选择请求到哪个节点。方案可参考一致性哈希，这种方案通常适用于用户对客户端的行为有完全控制能力的场景。

####  问题四：Redis 集群方案什么情况下会导致整个集群不可用？

- 有 A，B，C 三个节点的集群,在没有复制模型的情况下,如果节点 B 失败了，那么整个集群就会以为缺少5501-11000 这个范围的槽（slot）而不可用

####  问题五：如何保证 redis 中的数据都是热点数据？

- 限定 Redis 占用的内存，Redis 会根据自身数据淘汰策略，留下热数据到内存。所以，数据大约占用的内存，然后设置一下 Redis 内存限制即可，并将淘汰策略为volatile-lru或者allkeys-lru。 

####  问题六：Redis 有哪些适合的场景？

- 会话缓存（Session Cache）
- 全页缓存（FPC）
- 队列
- 排行榜/计数器
- 发布/订阅

####  问题七：Redis 和 Redisson 有什么关系？

- Redisson 是一个高级的分布式协调 Redis 客服端，实现了分布式和可扩展的 Java 数据结构。

####  问题八：说说 Redis 哈希槽？

- Redis 集群没有使用一致性 hash,而是引入了哈希槽的概念，Redis 集群有 16384 个哈希槽，每个 key 通 过 CRC16 校验后对 16384 取模来决定放置哪个槽，集群的每个节点负责一部分 hash 槽。

####  问题九：Redis 集群的主从复制模型是怎样的？

- 为了使在部分节点失败或者大部分节点无法通信的情况下集群仍然可用，所以集群使用了主从复制模型,每个节点都会有 N-1 个复制品

####  问题十：Redis 集群会有写操作丢失吗？为什么？

- 会，因为redis不保证数据的强一致性。

####  问题十一：Redis 中的管道有什么用？

- 在旧的请求还未被响应时，能够处理新的请求，而不用等待回复。最后在一个步骤中读取该回复。
  - 比如邮件的pop3服务

####  问题十二：怎么理解 Redis 事务？

- 一个单独的隔离操作：事务中的所有命令都会序列化、按顺序地执行，事务在执行的过程中，不会被其他客户端发送来的命令请求所打断

####  问题十三：使用过 Redis 分布式锁么，它是怎么实现的？

- 某个客户端要加锁。首先根据hash节点选择一台机器（互斥锁），然后就会发送一段 lua 脚本到 redis 上，通过这个命令设置一个 hash 数据结构，存储锁的标记以及释放时间。
- 当客户端二尝试加锁时先判断锁是否存在，然后再判断这个标记的value里是否存在客户端2的id，由于存储的时第一个客户端的id，于是客户端二开始自旋等待。
- 假设客户端设置30s的超时时间，但是30s后业务还未完成，后台启动的watch dog会不断的自动延期
  - watch dog：一旦加锁成功后台就会启动一个线程，每隔10s检查一下，如果上锁的客户端还未释放就自动延期
- 代码实现：
  - 先拿 setnx 来争抢锁，抢到之后，再用 expire 给锁加一个过期时间防止锁忘记了释放。

####  问题十四：**Redis** **分布式锁的缺点**

- **在** **redis master** **实例宕机的时候，可能导致多个客户端同时完成加锁**

####  问题十五：**使用过 Redis 做异步队列么，你是怎么用的？有什么缺点？**

- 使用 list 结构作为队列，rpush 生产消息，lpop 消费消息。当 lpop 没有消息的时候，要适当 sleep一会再重试。

- 缺点：
  - 在消费者下线的情况下，生产的消息会丢失，得使用专业的消息队列如 rabbitmq 等。

- 能不能生产一次消费多次呢？：
  - 使用 pub/sub 主题订阅者模式，可以实现 1:N 的消息队列。

####  问题十六：**什么是缓存穿透？如何避免？什么是缓存雪崩？何如避免？**

- **缓存穿透**：大量请求携带不存在的id发起查询，由于缓存中不存在就会打到数据库，造成数据库服务器宕机。
  - 解决：
    - 不存在的id也缓存
    - 参数过滤
    - ip禁止
    - 布隆过滤器
- **缓存雪崩**：大量的热点数据在同一时间失效，请求打到数据库，造成服务器宕机
  - 解决：
    - 使用随机过期时间
    - 分节点缓存数据
    - 定时任务刷新缓存
    - 设置永不过期

- **缓存击穿**：某个热点数据失效，请求打到数据库，造成服务器宕机
  - 解决：
    - 定时器刷新
    - 永不过期
    - 使用互斥锁：使用如 Redis 的 setnx 去设置一个互斥锁，当操作成功返回时查询数据库会写缓存

####  问题十七：**知道** **redis** **的持久化吗？底层如何实现的？有什么优点缺点？**

- RDB：基于时间段的数据快照磁盘同步
- AOF：记录redis执行过的指令

##  十二、mybatis

####  MyBatis 的缓存

- MyBatis 的缓存分为一级缓存和二级缓存,

  - 一级缓存放在 session 里面,默认就有,

  - 二级缓存放在它的命名空间里,默认是不打开的,使用二级缓存属性类需要实现 Serializable 序列化接口(可用来保存对象的状态),可在它的映射文件中配置<cache/>

####  Mybatis 是如何进行分页的？分页插件的原理是什么？

1. Mybatis 使用 RowBounds 对象进行分页，也可以直接编写 sql 实现分页，也可以使用Mybatis 的分页插件。
2. 分页插件的原理：实现 Mybatis 提供的接口，实现自定义插件，在插件的拦截方法内拦截待执行的 sql，然后重写 sql。

####  简述 Mybatis 的插件运行原理

- Mybatis 仅可以编写针对 ParameterHandler、ResultSetHandler、StatementHandler、Executor 这 4 种接口的插件，Mybatis 通过动态代理，为需要拦截的接口生成代理对象以实现接口方法拦截功能，每当执行这 4 种接口对象的方法时，就会进入拦截方法，具体就是InvocationHandler 的 invoke()方法，

####  Mybatis 动态 sql 怎么实现的

- 使用 OGNL 从 sql 参数对象中计算表达式的值，根据表达式的值动态拼接 sql，以此来完成动态 sql 的功能。

####  \# {}和${}的区别是什么？

1. # {}是预编译处理，${}是字符串替换为变量值。
2. Mybatis 在处理# {}时，会将 sql 中的# {}替换为?号，调用 PreparedStatement 的 set 方法来赋值；
3. 使用# {}可以有效的防止 SQL 注入，提高系统安全性。

####  Mybatis 是如何将 sql 执行结果封装为目标对象并返回的？都有哪些映射形式？

1. 使用<resultMap>标签，逐一定义列名和对象属性名之间的映射关系。
2. 是使用 sql 列的别名功能，将列别名书写为对象属性名

####  Mybatis 都有哪些 Executor 执行器？它们之间的区别是什么？

1. **SimpleExecutor**：每执行一次 update 或 select，就开启一个 Statement 对象，用完立刻关闭 Statement 对象。
2. **ReuseExecutor**：执行 update 或 select，以 sql 作为key 查找 Statement 对象，存在就使用，不存在就创建，用完后，不关闭 Statement 对象，而是放置于 Map
3. **BatchExecutor**：完成批处理。

####  在 mapper 中如何传递多个参数？

1. 直接在方法中传递参数，xml 文件用# {0} # {1}来获取
2. 使用 @param 注解:这样可以直接在 xml 文件中通过# {name}来获取




##  十三、SpringCloud

![](https://i.loli.net/2020/09/09/u1ctq9lkRCaJUET.png)

####  注册中心

####  CAP 理论：

- C：一致性
- A :可用性
- P：分区容错性 (一定时间内完成一致性，避免造成分区数据不一致)

####  eureka：

####  微服务概述：

- 微服务是一种用于构建应用的架构方案，将应用拆分成多个核心功能。每个功能都被称为一项服务，可以单独构建和部署，这意味着各项服务在工作（和出现故障）时不会相互影响。

####  Eureka的服务注册与发现：

- 没有服务注册中心,也可以服务间调用,为什么还要服务注册?
  - 当服务很多时,单靠代码手动管理是很麻烦的,需要一个公共组件,统一管理多服务,包括服务是否正常运行等

####  **spring cloud 的核心组件有哪些？**

- Eureka：服务注册于发现。
- Feign：基于动态代理机制，根据注解和选择的机器，拼接请求 url 地址，发起请求。
- Ribbon：实现负载均衡，从一个服务的多台机器中选择一台。
- Hystrix：提供线程池，不同的服务走不同的线程池，实现了不同服务调用的隔离，避免了服务雪崩的问题。
- Zuul：网关管理，由 Zuul 网关转发请求给对应的服务。
- config：配置中心

####  SpringCloud和Dubbo ：

1. **SpringCloud**是Apache旗下的Spring体系下的微服务解决方案 使用RestApi
   - 使用Netflix Eureka实现注册中心
   - REST是轻量级的接口,服务的提供和调用不存在代码之间的耦合
2. **Dubbo**是阿里系的分布式服务治理框架 使用RPC远程调用
   - Dubbo使用了第三方的ZooKeeper作为其底层的注册中心
   - 服务提供方和调用方式之间依赖太强,我们需要为每一个微服务进行接口的定义,并通过持续继承发布

####  什么是服务雪崩、服务熔断?什么是服务降级

- 服务雪崩：

  - 多个微服务之间调用的时候，假设微服务A调用微服务B和微服务C，微服务B和微服务C有调用其他的微服务，这就是所谓的”扇出”，如扇出的链路上某个微服务的调用响应式过长或者不可用，对微服务A的调用就会占用越来越多的系统资源，进而引起系统雪崩，所谓的”雪崩效应”。

- 为了解决某个微服务的调用响应时间过长或者不可用进而占用越来越多的系统资源引起雪崩效应就要进行服务熔断和服务降级处理。

- **服务熔断**：

  - 指的是某个服务故障或异常一起类似显示世界中的“保险丝"当某个异常条件被触发就直接熔断整个服务，而不是一直等到此服务超时。
  - 主启动类标注**@EnableCircuitBreaker**开启Hystrix支持
  - 在controller标注**@HystrixCommand(fallbackMethod = "")**指定兜底方法
  - 定义兜底方法 方法签名和返回值与接口保持一致

- **服务降级**：

  - 在客户端完成，与服务端没有关系。当某个服务熔断之后，服务器将不再被调用，此刻客户端可以自己准备一个本地的fallback回调，返回一个缺省值，这样做，虽然服务水平下降，但好歹可用，比直接挂掉要强

  - ```properties
    # 开启服务熔断
    feign.hystrix.enabled=true
    # 设置超时时间
    hystrix.command.default.execution.isolation.thread.timeoutInMilliseconds=6000
    ```

  - 编写远程调用接口标注注解

    ```
    @FeignClient(name = "service-vod",fallback = xxx.class) 
    ```

  - 编写实现类完成逻辑代码

####  eureka自我保护机制是什么?

- 当Eureka Server 节点在短时间内丢失了过多实例的连接时（比如网络故障或频繁启动关闭客户端）节点会进入自我保护模式，保护注册信息，不再删除注册数据，故障恢复时，自动退出自我保护模式。

####   什么是Ribbon？

- ribbon是一个负载均衡客户端，可以很好的控制htt和tcp的一些行为。feign默认集成了ribbon。

####  什么是feigin？它的优点是什么？

1. feign采用的是基于接口的注解
2. feign整合了ribbon，具有负载均衡的能力
3. 整合了Hystrix，具有熔断的能力
   - 添加pom依赖。
   - 启动类添加@EnableFeignClients
   - 定义一个接口@FeignClient(name=“xxx”)指定调用哪个服务

####   Ribbon和Feign的区别？

1. 启动类注解不同，Ribbon是@RibbonClient feign的是@EnableFeignClients
2. 服务指定的位置不同，Ribbon是在@RibbonClient注解上声明，Feign则是在定义抽象方法的接口中使用@FeignClient声明。
3. 调用方式不同，Ribbon需要自己构建http请求，模拟http请求然后使用RestTemplate发送给其他服务，步骤相当繁琐。Feign需要将调用的方法定义成抽象方法即可。
