---
layout: posts
title: MySQL中表空间、数据⻚、数据⾏的物理存储
date: 2022-07-05 17:02:33
updated: 2022-07-05 17:02:33
categories: 
 -  MySQL
---
# MySQL中表空间、数据⻚、数据⾏的物理存储

## **1**. MySQL 各数据所在⽬录

MySQL的配置⽂件都是 /etc/my.cnf

```shell
[root@localhost mysql]# cat /etc/my.cnf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/5.7/en/server-configurationdefaults.html
[mysqld]
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
# Disabling symbolic-links is recommended to prevent assorted security
risks
symbolic-links=0
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
lower_case_table_names=1
sql-mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_
BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
```

- **MySQL的数据⽂件在 /var/lib/mysql**

- **MySQL的⽇志⽂件在 var/log/mysqld.log**

- 还有 sql-mode；

### MySQL的数据⽂件⽬录 /var/lib/mysql

```shell
[root@localhost mysql]# cd /var/lib/mysql
[root@localhost mysql]# ll
total 1368176
-rw-r-----. 1 mysql mysql         56 Feb 21  2020 auto.cnf
-rw-------. 1 mysql mysql       1675 Feb 21  2020 ca-key.pem
-rw-r--r--. 1 mysql mysql       1074 Feb 21  2020 ca.pem
-rw-r--r--. 1 mysql mysql       1078 Feb 21  2020 client-cert.pem
-rw-------. 1 mysql mysql       1675 Feb 21  2020 client-key.pem
-rw-r-----. 1 mysql mysql       1370 Sep 13  2021 ib_buffer_pool
-rw-r-----. 1 mysql mysql 1287651328 Jun 16 04:50 ibdata1
-rw-r-----. 1 mysql mysql   50331648 Jun 16 04:50 ib_logfile0
-rw-r-----. 1 mysql mysql   50331648 Jun 16 04:43 ib_logfile1
-rw-r-----. 1 mysql mysql   12582912 Jun 24 03:42 ibtmp1
drwxr-x---. 2 mysql mysql       4096 Feb 21  2020 mysql //
⽬录
srwxrwxrwx. 1 mysql mysql          0 Jun 16 00:07 mysql.sock
-rw-------. 1 mysql mysql          5 Jun 16 00:07 mysql.sock.lock
drwxr-x---. 2 mysql mysql       4096 Mar 19  2020 nsight //
⽬录
drwxr-x---. 2 mysql mysql       8192 Feb 21  2020 performance_schema //
⽬录
-rw-------. 1 mysql mysql       1679 Feb 21  2020 private_key.pem
-rw-r--r--. 1 mysql mysql        451 Feb 21  2020 public_key.pem
-rw-r--r--. 1 mysql mysql       1078 Feb 21  2020 server-cert.pem
-rw-------. 1 mysql mysql       1679 Feb 21  2020 server-key.pem
drwxr-x---. 2 mysql mysql       8192 Feb 21  2020 sys //
⽬录
drwxr-x---. 2 mysql mysql       4096 Jun 16 01:08 sysbench@002ddb //
⽬录
drwxr-x---. 2 mysql mysql       4096 Jun  1 23:22 test //
⽬录
```

上⾯这些⽂件⼤概是：

- ***.pem**等相关的都是mysql的⼀些安全性校验⽂件；

- **ib_buffer_pool**：前⾯说过，InnoDB使⽤了内存bufferpool来提升效率，但是在MySQL重启之后，那这些内存中的数据是不是就都没有了，然后所有的连接都需要重新从磁盘中加载，那这样性能肯定会受影响；所以在mysql5.6后，添加了这个新特性：
  - 在mysql关闭时，将bufferpool内存中的热数据，dump到磁盘⽂件中，也就是这⾥的ib_buffer_pool⽂件；
  - 在mysql重启时，将ib_buffer_pool⽂件的数据load到内存中；（虽然也读取了磁盘，但是load的是热数据）

- **ibdata1**：InnoDB将存储的数据按表空间（tablespace）进⾏存放，在默认配置下就会有⼀个初始⼤⼩为10M，名为ibdata1的⽂件，也就是默认的表空间⽂件（也是共享表空间）；（另外undolog⽇志⽂件也存在于这个共享表空间中）
- **ib_logfile0、ib_logfile1**：这两个⽂件就是InnoDB的redolog⽂件，也就是前⾯说的重做⽂件；为什么这⾥有两个，是因为redolog是⼀个逻辑上循环使⽤的⽂件，⼀个⽂件写满之后写另⼀个⽂件；
- 另外的⽬录这些，就表示的是⼀个数据库，⼀个数据库就是⼀个⽬录；

再进⼊到⼀个⽬录（数据库）：

```shell
-rw-r-----. 1 mysql mysql      8632 Jun 16 01:06 sbtest10.frm
-rw-r-----. 1 mysql mysql 297795584 Jun 16 04:50 sbtest10.ibd
-rw-r-----. 1 mysql mysql      8632 Jun 16 01:08 sbtest11.frm
-rw-r-----. 1 mysql mysql 297795584 Jun 16 04:50 sbtest11.ibd
-rw-r-----. 1 mysql mysql      8632 Jun 16 01:08 sbtest12.frm
-rw-r-----. 1 mysql mysql 297795584 Jun 16 04:50 sbtest12.ibd
-rw-r-----. 1 mysql mysql      8632 Jun 16 01:08 sbtest13.frm
-rw-r-----. 1 mysql mysql 297795584 Jun 16 04:50 sbtest13.ibd
```

- **sbtest10.frm**：前⾯表示表名，后⾯的.frm表示这是存放表结构的⽂件；
- **sbtest10.ibd**：同样前⾯表示表名，后⾯的.ibd表示这个存放数据的⽂件；（也就是说，InnoDB的表的数据就存放在这⾥⾯）

## **2**. 表空间的物理结构

表空间可以看做是InnoDB存储引擎结构的最⾼层，因为所有的数据都是存放在表空间中；从上⾯可以看到，有两种表空间：

- **共享表空间（ibdata1）**：也就是系统表空间，⼀些Undo的信息、事务信息等是存储在这⾥⾯的；
- **独⽴表空间（xxx.ibd）**：每个创建的表都对应了⼀个独⽴的表空间，命名为表名.ibd；这个⽂件中包含了表的数据；

**独⽴表空间的内容为：** 

- **段（Segment）**：表空间是由各个段（Segment）组成的，⼀般分为数据段和索引段；（共享表空间中还有回滚段）
  - 这⾥先提及⼀点MySQL索引的知识，mysql的索引由B+树组织，分为叶⼦节点和⾮叶⼦节点；叶⼦节点⻚存储了完整的数据，⽽⾮叶⼦节点⻚（也就是索引⻚）只存储了索引指针。
  - 如果把这些叶⼦节点⻚和⾮叶⼦节点⻚都通通放在⼀起的话，那叶⼦节点⻚与叶⼦节点⻚之间不就存在物理距离了。（当要执⾏全表扫描或者范围查询时（这个也就是对所有叶⼦节点⻚进⾏顺序扫描），如果都是间隔存放的，就会产⽣随机IO，导致扫描性能⼤⼤下降；）
  - 所以，这⾥就设计出了段这个概念：
    - 将叶⼦节点⻚所在的区放到叶⼦节点段；
    - 将⾮叶⼦节点⻚所在的区放到⾮叶⼦节点段

- **区（Extend）**：本质上，表空间可以直接由数据⻚组成；但是在数据量⼤的情况下，性能会受到影响；所以为了更好的利⽤和管理数据⻚，就设计出了区 这个概念；
  - **区就是数据⻚的集合，把64个数据⻚划分成为⼀个区，所以⼀个区的⼤⼩为1M**
  - 为什么有了区就可以提升使⽤⻚的性能？
    - 因为数据⻚是通过双向链表来连接的，上⼀⻚和下⼀⻚的物理位置可能很远，这样就会导致随机IO，性能低下；
    - 所以就引⼊了区，⼀个区就是在物理位置上连续的64个数据⻚（可以连续访问）；这样当表中数据量⼤的时候，为某个索引分配空间时，就不再按照⻚为单位分配了，⽽是按照区为单位分配；
    - 甚⾄在表中的数据特别多的时候，可以⼀次性分配多个连续的区。虽然可能造成⼀点点空间的浪费（数据不⾜填充满整个区），但是从性能⻆度看，可以消除很多的随机IO；也就说，尽量将物理位置不相邻的数据⻚，分配在相邻的位置；

- **组（ExtendGroup）：将256个区划分为⼀个组，所以⼀个组的⼤⼩为256M**；

  - 第⼀个组中第⼀个区的前三个⻚的类型的固定的，⽤来记录⼀些系统数据；
  - 其余各组的前两个⻚的类型固定，也是记录⼀些系统数据；：

    总体来说，表空间的结构为：

  很多个数据区分组（ExtendGroup），每个组中有256个数据区（Extend 256MB）,每个数据区中有64个数据页（1MB）,每个数据页中有很多数据行

![表空间结构](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729104152244.png)

## 3.数据⾏的物理结构

MySQL的数据⾏，有⼏种⾏格式，在创建表的时候就可以指定，这⾥我们⽤默认的COMPACT格式来讲解下⾯的东⻄；

![COMPACT行格式](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729141424118.png)

### **3**.**1** 变⻓字段的存储格式：

我们都知道在MySQL中有⼀个数据类型是varchar(x)，这个varchar是变⻓字段，也就是说字段的⻓度不固定；

（另外还有⼀些如VARBINARY(M)、TEXT、BLOG等类型的也是）那为了存储这种⻓度不固定的字段，是不是就需要额外的东⻄来记录各个字段真实的⻓度，不然你没法在物理结构上进⾏存储和读取的；也就是说这些编程字段占⽤的存储空间分为两部分：

- 真正存储的数据内容； 

- 数据占⽤的字节数；

在Compact⾏格式中，所有变⻓字段的真实数据占⽤的字节数都存放在开头部分，⼀起形成了⼀个变⻓字段列表：

![变长字段列表](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729111612578.png)

**这⾥为什么要逆序存储？**

这⾥的逆序存储，是为了提⾼缓存命中率，我们可以看到每个字段与它对应的⻓度信息，在内存中的距离是更近的（当然这⾥只有位置靠前的字段）；这样可以提⾼⾼速缓存中的内存命中率；（算是⼀个⽐较巧妙的设计）

#### 在这⾥做⼀个扩展：

**⼤家应该都知道数组有哪些特性：**

- 最重要的，**随机查找的时间复杂度是O(1)**；（什么叫随机查找，也就是⽐如arr[0],arr[5]）

- 那数组是怎么实现这种 O(1) 时间复杂度的随机访问呢？有⼏个点: 

  - 数组中所有元素的⼤⼩都是相同的（也就是相同类型的数据）；假设为data_type_size ； 

  - 并且是连续的内存空间，没有内存碎⽚；假设基地址为 base_address ； 

  - 基于这样的存储结构，就可以有⼀个寻址公式：
    - a[i]_address = base_address + i * data_type_size

但是这样的数组，有没有什么**缺点**呢？

- 所有元素的⼤⼩都是相同的，那也就是说你如果要存储不同类型的元素，你需要按照最⼤类型⼤⼩来申请内存空间； 
- 假设你要存储的数据⼤⼩为1,5,20,100的元素，那申请的内存空间为4个100的，但是第⼀个元素的数据才1这么⼤，你⽤100来存，是不是就是极⼤程度的浪费存储空间；

那这样缺点可以怎么去**优化**呢？ 

- 这⾥我们要跳出java的数组类型，不能按照Java⾥的int[]，String[]数组这种，都存储的是⼀样⼤⼩的；⽽把视线放到底层⼀点，底层语⾔层⾯，它可以存储不同类型的数据在数组⾥⾯；
- 这个时候再结合我们上⾯的对于要存储⻓度不固定的字段，就需要额外的东⻄来记录各个字段真实的⻓度；
- 那我们是不是可以记录数组的每个元素的⻓度，然后只⽤存储特定⼤⼩的元素即可；这时，在遍历的时候就知道每个节点的⻓度（占⽤内存⼤⼩），根据每个元素的⻓度，不就可以实现访问到所有元素了吗；

示例：

![数组](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729133248673.png)

其实，这⾥的扩展，也就是Redis中有⼀种数据结构，叫做压缩列表；它就是基于数组的思想，对于较⼩⻓度的字符串元素的空间进⾏压缩，也就是只分配它需要使⽤的⻓度的空间，然后增加⼀个length属性来记录每个元素的⼤⼩即可；

### **3**.**2** NULL值字段的存储格式：

在MySQL中，可以让你设置允许某些字段为NULL的，这些允许设置为NULL的字段，如果未赋值，显示出来就为NULL；

但是MySQL为了节约存储空间，并没有直接使⽤使⽤NULL这种字符串来存储空值的字段，⽽是直接使⽤⼆进制的bit位格式来存储；也就是⼀个bit位，代替了⾄少8个字节的存储空间；例如：

![image](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729141501575.png)

这样就可以根据变长字段长度列表和NULL值列表解析出有几个变长字段，有几个NULL值字段，并读取整行数据。

### **3**.**3** 三个隐藏字段 

InnoDB中，在每⾏数据⾥⾯，还会有⼀些隐藏字段，⽤来实现⼀些主键、事务、回滚等功能；分别为：

- **主键ID（DB_ROW_ID）**：这是InnoDB特有的，InnoDB内部给你搞的⼀个标识；当你的表没有指定主键和唯⼀所以的时候，InnoDB内部会⾃动加⼀个DB_ROW_ID作为主键；
- **事务ID（DB_TRX_ID**）：表明这⾏数据是由哪个事务来更新的，在实现事务时需要⽤到；
- **回滚指针（DB_ROLL_PTR）**：⽤来指向undolog的回滚指针的，也是实现事务时需要⽤到

|    列名     | 是否必须 | 占用空间 |           描述           |
| :---------: | :------: | :------: | :----------------------: |
|   row_id    |    否    |  6字节   | 行ID，一行记录的唯一标识 |
|   trx_id    |    是    |  6字节   |          事务ID          |
| roll_pinter |    是    |  7字节   |         回滚指针         |

### **3**.**4** 真实数据的存储

在理清楚了上⾯的变⻓字段列表、NULL值列表、三个隐藏字段，那来看看具体的真实数据是怎么存储的；使⽤前⾯的示例：

**0x09 0x04 00000101 数据头 jack m xx_school** 

这⾥看⻅的是字段的值是直接这样存储的，但是在磁盘上存储的时候，会是这样直接存储字符串吗？

其实不是的，⽽是根据数据库指定的字符集编码，将这些字符串进⾏编码之后，再进⾏存储的：最终这⼀⾏会看起来如下所示：

**0x09 0x04 00000101 数据头 616161 636320 6262626262**

那最终，**在磁盘中的数据⻚中的⼀⾏数据物理格式**⼤概为：

| 记录的额外信息                            |                              |                                                              | 记录的真实信息      |                     |                         |
| ----------------------------------------- | ---------------------------- | ------------------------------------------------------------ | ------------------- | ------------------- | ----------------------- |
| 变长字段长度列表<br />**0x09 <br />0x04** | NULL值列表<br />**00000101** | 数据头: <br />**00000000094C**（DB_ROW_ID） <br />**00000000032D**（DB_TRX_ID） <br />EA**000010078**E（DB_ROL_PTR） | 列1<br />**616161** | 列3<br />**636320** | 列5<br />**6262626262** |

### **3**.**5** 数据头（记录头）

![image](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729145107252.png)

这⾥的数据头是数据⾏中⾮常重要的结构，它表示了这⾏数据的很多元数据信息，⼀共占⽤5个字节（也就是40bit位）；⾥⾯的各种属性为：

![image](C:\Users\karakal\AppData\Roaming\Typora\typora-user-images\image-20220729143042383.png)

- **两个预留位**：可能就是历史原因，预留出来以防后续要使⽤的，但是没有使⽤；
- **deleted_flag**：⽤来标记当前记录⾏是否被删除了；（**0代表未被删除，1代表被删除**）；
  - 为什么要⽤这个删除标记？因为InnoDB中的数据⾏，被删除之后不是⻢上就从磁盘中删除了；
  - 为什么？因为如果你直接删除，那还得去重新调整和排列磁盘中剩下的记录，这些是会带来性能损耗的；
  - 所以，在删除的时候，只对这种记录添加⼀个标记即可；这些被标记删除了的记录⾏，会组成⼀个垃圾链表，这个垃圾链表中占⽤的空间也就是可重⽤的空间；当有新记录插⼊时，是可以重复覆盖掉这个空间的；
- **min_rec_flag**：这个是⽤于构建索引的，B+树中每层⾮叶⼦节点中的最⼩的⽬录项记录，会被添加这个标记（值赋为1）；在后⾯介绍索引的时候会再介绍；
- 剩下的就放在后⾯讲数据⻚⾥⾯去融合；

## **4**. 数据⻚的物理结构

![数据页结构](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729143409287.png)

这是数据⻚的结构总览，16KB⼤⼩的存储空间被划分成为了这些部分，不同部分有不同的功能；有的部分占⽤的字节数是确定的，⽽有的部分占⽤的字节数是不确定的；

|                   名称                   |  空间  |           描述           |
| :--------------------------------------: | :----: | :----------------------: |
|         File Header（⽂件头部）          | 38字节 |     ⻚的⼀些通⽤信息     |
|          Page Header（⻚⾯头部           | 56字节 |  数据⻚的专有的一些信息  |
| Infimum + Supremum（最⼩记录和最⼤记录） | 26字节 |     两个虚拟的⾏记录     |
|         User Records（⽤户记录）         | 不确定 |   实际存储的⾏记录内容   |
|          Free Space空闲空间（）          | 不确定 |    ⻚中尚未使⽤的空间    |
|        Page Directory（⻚⾯⽬录）        | 不确定 | ⻚中的某些记录的相对位置 |
|         File Trailer（⽂件尾部）         | 8字节  |      校验⻚是否完整      |

### **4**.**1** ⽤户记录在数据⻚中的存储 

⽤户记录（数据⾏）在数据⻚中的存储格式

MySQL中⽤户存储的数据⾏会按照指定的⾏格式存储到Records部分，但是在⼀开始⽣成⻚的时候，其实并没有UserRecords部分，每当插⼊⼀条记录时都会从FreeSpace部分（也就是尚未使⽤的存储空间）申请⼀个记录⼤⼩的空间，并将这个空间划分到UserRecords部分；

当FreeSpace部分的空间全部被UserRecords部分替代掉之后，也就意味着这个⻚使⽤完了，此时如果还有新的记录插⼊，就需要去申请新的⻚了；

![image](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729144835156.png)

为了更清晰的讲解后⾯数据⾏与数据⻚的组织构成，⽤⼀个简单的示例表举例：

```MySQL
mysql> CREATE TABLE page_demo(
  -> c1 INT,
  -> c2 INT,
  -> c3 VARCHAR(lOOOO) ,
  -> PRIMARY KEY (c1)
  -> ) CHARSET=ascii ROW_FORMAT=COMPACT;
```

pagedemo表有其中c1、c2列⽤来存储整数，c3列⽤来存储字符串，且c1列为主键；所以InnoDB就没必要再创建那个DB_ROW_ID隐藏列了；

再往这个表中插⼊⼏条数据：

```MySQL
mysql> INSERT INTO page_demo VALUES(1, 100, 'aaaa'), (2, 200, 'bbbb'), (3, 300, 'cccc'), (4, 400, 'dddd'); 
Query OK, 4 rows affected (0.00 sec) Records: 4 Duplicates: 0 Warnings: 0
```

为了⽅便⼤家分析这些记录在⻚的User Records部分中是怎么表示的，我把记录中头信息和实际的列数据都⽤⼗进制表示出来了（其实是⼀堆⼆进制位），所以这些记录的示意图就是：

![image](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729145410053.png)

看这个图的时候需要注意⼀下，各条记录在User Records中存储的时候并没有空隙，这⾥只是为了⼤家观看⽅便才把每条记录单独画在⼀⾏中。我们对照着这个图来看看记录头信息中的各个属性是啥意思：

- **delete_mask** 这个属性标记着当前记录是否被删除，占⽤1个⼆进制位，值为0的时候代表记录并没有被删除，为1的时候代表记录被删除掉了。(将这个delete_mask位设置为1和将被删除的记录加⼊到垃圾 链表中其实是两个阶段)

- **min_rec_mask** B+树的每层⾮叶⼦节点中的最⼩记录都会添加该标记

- **n_owned**

- **heap_no** 

  InnoDB 中把⼀条⼀条记录挨着排列的结构叫做 堆（heap）；为了⽅便管理这个堆，把每条记录在这个堆中的相对位置称为 heap_no；

  - 在⻚⾯前⾯⼀点的记录 heap_no 相对较⼩，⻚⾯后⾯的记录的 heap_no 相对较⼤，**每申请⼀条新的记录时，heap_no ⽐前⾯的 加1**； 

  这个属性表示当前记录在本⻚中的位置，从图中可以看出来，我们插⼊的4条记录在本⻚中的位置分别是：2、3、4、5，怎么不⻅heap_no值为0和1的记录呢？

  - 这其实是设计InnoDB⾃动给每个⻚⾥边⼉加了两个记录，由于这两个记录并不是我们⾃⼰插⼊的，所以有时候也称为伪记录或者虚拟记录。这两个伪记录⼀个代表最⼩记录，⼀个代表最⼤记录。

  - 两条记录的构造⼗分简单，都是由5字节⼤⼩的记录头信息和8字节⼤⼩的⼀个固定的部分组成的

    ![image](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729151741870.png)

  - 由于这两条记录不是我们⾃⼰定义的记录，所以它们并不存放在⻚的User Records部分，他们被单独放在⼀个称为Infimum + Supremum的部分

    ![image](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729151910124.png)

  - 这两条记录也算是堆中的⼀部分，所以他们的 heap_no 最⼩，为 0， 1

- **record_type** 这个属性表示当前记录的类型

  - 0表示普通记录 也就是叶⼦节点中（数据⻚中）的普通数据⾏的记录；（⽤户⾃⼰插⼊的记录）
  - 1表示B+树⾮叶⼦节点中（索引⻚中）的⽬录项（索引项）的记录
  - 2表示最⼩记录
  - 3表示最大记录

- **next_record** 表示从当前记录的真实数据到下⼀条记录的真实数据的地址偏移量

  如果这个属性值为 正，表示下⼀条记录在当前记录的后⾯；如果这个属性值为负，表示下⼀条记录在当前记录的前⾯；如图中：

  - 第⼀条记录的next_record值为32，意味着从第⼀条记录的真实数据的地址处向后找32个字节便是下⼀条记录的真实数据
  - 第四条记录的 next_record 为 -111，就表示从第四条记录向前找 111 字节便是下⼀条记录的真实数据的地址；（其实也就是Supremum记录了）

  - 下⼀条记录指得并不是按照我们插⼊顺序的下⼀条记录，⽽是按照主键值由⼩到⼤的顺序的下⼀条记录

  - ⽽且规定Infimum记录（也就是最⼩记录） 的下⼀条记录就本⻚中主 键值最⼩的⽤户记录，⽽本⻚中主键值最⼤的⽤户记录的下⼀条记录就是 Supremum记录（也就是最⼤记录）

    ![image](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729152054361.png)

  - 从图中可以看出来，我们的记录按照主键从⼩到⼤的顺序（**这里体现了MySQL数据的有序性**）形成了⼀个单链表（**Infimum -> 1 -> 2 -> 3 -> 4 -> Supremum** ）。最⼤记录的next_record的值为0，这也就是说最⼤记录是没有下⼀条记录了，它是这个单链表中的最后⼀ 个节点。

    - 为什么 next_record 指向的是下⼀条记录⾏的next_record位置呢？⽽不是指向下⼀条记录⾏的起始位置呢？
    - 原因是这个位置刚好，向左读取就是各种记录头的信息，向右读取就是真实的数据；⽐较巧妙的⼀个设计

  - 如果从中删除掉⼀条记录，这个链表也是会跟着变化的，⽐如我们把第2条记录删掉：

    ![image](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729152156354.png) 

- 从图中可以看出来，删除第2条记录前后主要发⽣了这些变化： 

  - 第1条记录的next_record指向了第3条记录。
  - 第2条记录并没有从存储空间中移除，⽽是把该条记录的delete_mask值设置为1。 
  
  - 第2条记录的next_record值变为了0，意味着该记录没有下⼀条记录了。 
  
  - 还有⼀点你可能忽略了，就是最⼤记录的n_owned值从5变成了4。 
  
  如果我们再次把这条记录插⼊到表中，会发⽣什么事呢： 
  
  ![image-20220729154033421](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729154033421.png)
  
  从图中可以看到，InnoDB并没有因为新记录的插⼊⽽为它申请新的存储空间，⽽是直接**复⽤了原来被删除记录的存储空间**
  
  所以，不论我们怎么对⻚中的记录做增删改操作，InnoDB始终会维护⼀条记录的单链表，链表中的各个节点是按照主键值由⼩到⼤的顺序连接起来的

### **4**.**2** 数据⻚中的其他属性 

#### **4**.**2**.**1** File Header 

File Header通⽤于各种类型的数据⻚，也就是说各种类型的数据⻚都会以 File Header 作为第⼀个组成部分，⽤它来描述⼀些通⽤信息，占⽤固定的38 字节；由以下内容组成：

![image](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729154219782.png)

我觉得需要了解的就三个东⻄： 

- **FIL_PAGE_OFFSET**：⻚号；每个数据⻚都有⾃⼰的编号，InnoDB通过⻚号来唯⼀确定⼀个⻚； 

- **FIL_PAGE_PREV**：上⼀个数据⻚的⻚号；FIL_PAGE_NEXT：下⼀个数据⻚的⻚号； 

- **FIL_PAGE_TYPE**：当前⻚的类型；InnoDB为了不同的⽬的将数据⻚分为不同的类型：

  ![image](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729154422969.png)
  
  - 其中⽤来存放记录⾏的数据⻚类型其实就是 **FIL_PAGE_INDEX**，也是索引⻚

#### **4**.**2**.**2** Page Header 

Page Header **⽤于记录存储在数据⻚中的记录的状态信息**；如：数据⻚中已经存储了多少条记录、Free Space 在⻚⾯中的偏移量、⻚⽬录中存储了多少个槽等；

![](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729154546388.png)

​             这些东⻄⼤概了解⼀下就⾏了，没必要去深究和记住；

#### **4**.**2**.**3** Page Directory 

Page Directory（⻚⽬录）；这个也是数据⻚中最重要的属性之⼀，**它跟 Infimum + Supremum 、User Records ⼀起实现了记录⾏在数据⻚中的存储**；

从前⾯的介绍⾥⾯，我们应该知道了记录⾏在数据⻚中的存储格式为：Infimum+按每⾏主键ID值从⼩到⼤串联成的单向链表+Supremum；

所以当我们要查找这样⼀⾏记录时，该怎么查找呢？

```MySQL
select * from page_demo where c1 = 6;
```

最简单直接的办法，肯定是从Infimum记录开始，沿着单向链表⼀条⼀条的往后遍历着找，总会找到（或者找不到）；

当数据⻚中记录较少时，这样查找肯定没有啥问题；但是当⻚中存储了⽐较多的记录⾏，这样的遍历操作肯定是较慢的，肯定不能使⽤这种来做为⼯业化软件的实现的；

**InnoDB为了解决这个问题，将数据⻚中的多条记录划分成了⼀个⼀个的组，这些组也叫做槽（slot）；**

这些slot也就是存**在于PageDirectory中**；

- **⼀个slot中的记录⾏数为4-8⾏**；
- **每个slot指向的是**这⼀组记录的最后⼀条记录（也就是**组中最⼤的那条记录**）的物理地址；
- 可以将这条记录看做这组记录的leader，**它的数据头⾥⾯的n_owned属性会记录它这组⼀共有⼏条记录**；

**示意图：**

![image](https://raw.githubusercontent.com/Mr-xinyichen/picgo/main/img/image-20220729155959265.png)

**InnoDB对每个分组中的记录条数**是有规定的： 

- 对于**最⼩记录所在的分组只能有 1 条记录**，
- **最⼤记录所在的分组拥有的记录条数只能在 1~8 条之间**，
- **剩下的分组中记录的条数范围只能在是 4~8 条之间**。

插⼊记录⾏时，slot的动态过程为：

- 初始情况下，⼀个数据⻚中只有Infimum和Supremum两条记录，它们分属于两个slot中的；也就是说，⻚⽬录中初始就有两个slot，分别指向了Infimum和Supremum的地址偏移量；

- 之后每插⼊⼀条记录，都会从⻚⽬录中找到，对应记录的主键ID⽐待插⼊记录的的差值最⼩的slot（因为slot指向的是这组记录中最⼤的⼀⾏记录⾏）；然后将这个slot指向的记录⾏的n_owned值+1；表示这组⼜添加了⼀⾏记录，直到该组中的记录数等于8个；

- 当⼀个组中的记录⾏数等于8之后，再插⼊⼀条记录，会将这个组中的记录拆分成两个组，其中⼀个组中4条记录，另外⼀个组中5条记录；这个拆分过程会在PageDirectory中新增⼀个slot，指向新增分组中的最⼤的记录⾏的地址；

  我们向表中加入了12条记录，现在就⼀共有16条正常的记录了（包括最⼩和最⼤记录），这些记录被分成了5个组，如图所示：

  ```MySQL
  mysql> INSERT INTO page_demo VALUES(5, 500, 'eeee'), (6, 600, 'ffff'), (7, 700, 'gggg'), (8, 800, 'hhhh'), (9, 900, 'iiii'), (10, 1000, 'jjjj'), (11, 1100, 'kkkk'), (12, 1200, 'llll'), (13, 1300, 'mmmm'), (14, 1400, 'nnnn'), (15, 1500, 'oooo'), (16, 1600, 'pppp'); 
  Query OK, 12 rows affected (0.00 sec) Records: 12 Duplicates: 0 Warnings: 0
  ```

  ![image-20220729160357368](C:\Users\karakal\AppData\Roaming\Typora\typora-user-images\image-20220729160357368.png)

那设计了slot之后，⼜**怎么来对数据⻚中的记录⾏进⾏查找**呢？ 

- 因为 slot 是挨着的，⽽⾥⾯记录的记录⾏是从⼩到⼤依次排序的，所以可以使⽤⼆分法快速进⾏查找； 

⼆分法查找：

- 计算中间槽的位置：(0+4)/2=2，所以查看槽2对应记录的主键值为8，⼜因为8 > 5，所以设置high=2，low保持不变；

- 重新计算中间槽的位置：(0+2)/2=1，所以查看槽1对应的主键值为4。所以设置low=1，high保持不变。
- 因为high - low的值为1，所以确定主键值为5的记录在槽2对应的组中，接下来就是通过遍历槽2对应的组的链表来进⾏查找了。

- 所以从这个分组内的最⼩的记录⾏（第⼀条记录⾏）开始，遍历进⾏查找即可；（这个遍历的过程，也就是next_record指针的查找过程）
  - 这⾥的怎么找最⼩的记录⾏？因为没有地⽅记录了分组中最⼩的记录⾏；
  - 所以需要找到当前slot2的前⼀个分组即slot1，slot1指向的就是前⼀个分组的最⼤记录⾏，那这个记录⾏的next_record即为slot2分组的最⼩的记录⾏；

- 由于⼀个组中包含的记录最多是8条，所以遍历⼀个组中所有记录的代价是很⼩的；等于就是将单向链表的遍历，给⼆分优化了，将n的时间复杂度，优化到了log(n)；那这个时候，⼤家想⼀下，对于单向链表，还有什么⽅式可以优化查找的时间复杂度？（跳表，也是log(n)，Redis⾥⾯就⽤的这个数据结构）

#### **4**.**2**.**4** Free Space 

Free Space 就是空闲的可以分配的空间，不⽤特别去关注它； 

#### **4**.**2**.**5** File Trailer 

File Trailer 也就是⽂件的尾部，通⽤与所有类型的⻚； 

它主要的功能是 和 File Header ⼀起 做⻚⾯的检验和，检测⼀个⻚是否完整（这个完整说的将内存中的 

脏⻚刷新到磁盘的时候，中间是否有断电等异常，导致只刷进去了部分数据等）；

## **5**. 总结 

到这⾥最后了，我们⼀起总结⼀下**InnoDB中数据⻚和数据⾏的存储结构**： 

- 多个数据⻚组成了⼀个双向链表，每个数据⻚中的记录⾏ 会按照主键ID从⼩到⼤的顺序组成⼀个单向链表； 

- 每个数据⻚中会将存储在它⾥⾯的记录⾏分成多个组；并⽣成⼀个⻚⽬录，在这个⻚⽬录中存在⼀个slot数组，数组中每个slot代表⼀个分组，slot 指向的是这个组最⼤的数据⾏； 

- 在通过主键ID查找时，先通过⼆分法查找对对应的slot，然后再遍历这个slot中的所有记录⾏即可