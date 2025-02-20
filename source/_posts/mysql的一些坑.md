---
layout: posts
title: mysql的一些坑
date: 2020-07-14 09:58:00
updated: 2020-07-14 09:59:44
tags: 
categories: 
 - 经验&bug
---
**Mysql5.7大坑：Expression # 2 of SELECT list is not in GROUP BY clause and contains** 
**nonaggregated column ‘sss.month_id’ which is not functionally** 
**dependent on columns in GROUP BY clause; this is incompatible with** 
**sql_mode=only_full_group_by**

​	MySQL 5.7.5及以上功能依赖检测功能。如果[`ONLY_FULL_GROUP_BY`](https://dev.mysql.com/doc/refman/5.7/en/sql-mode.html# sqlmode_only_full_group_by)启用了 SQL模式（默认情况下），则MySQL将拒绝对该选项列表，`HAVING`条件或 `ORDER BY`列表引用的子集中既不指定的`GROUP BY`非集合列的查询，也不在功能上依赖于它们。


```mysql
-- 去掉ONLY_FULL_GROUP_BY
SET @@global.sql_mode ='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
```





####  远程连接的一系列解决方法：

​	**ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)**
​		数据库密码错误 通过修改配置文件跳过验证 ：

```shell
# 关闭mysql服务
systemctl stop mysql
vim /etc/my.cnf	(注：windows下修改的是my.ini) 
# 在文档内搜索mysqld定位到[mysqld]文本段：
# /mysqld(在vim编辑状态下直接输入该命令可搜索文本内容)
# 在[mysqld]后面任意一行添加“skip-grant-tables”用来跳过密码验证的过程
# :wq保存退出
# 重启mysql
systemctl start mysql
# 直接使用mysql进去数据库
mysql
# 更改密码
use mysql;
update user set password=password("你的新密码") where user="root";
flush privileges;
quit;
# 打开刚才修改的配置文件
vim /etc/my.cnf
# 注释刚才添加的内容
# skip-grant-tables
# 使用新密码登录
mysql -uroot -p你的新密码
```



​	**MYSQL ERROR 2003 (HY000): Can't connect to MySQL server on 'xxx.xx' (111)** 

​		mysql默认监听本地连接，添加其他ip的监听

```sql
-- 如果想让192.168.xx.xx获取连接权限
GRANT ALL PRIVILEGES ON *.* TO '指定的用户名'@'192.168.xx.xx' IDENTIFIED BY '对应的密码' WITH GRANT OPTION;

-- 如果想让所有主机获取连接权限
GRANT ALL PRIVILEGES ON *.* TO '指定的用户名'@'%' IDENTIFIED BY '对应的密码' WITH GRANT OPTION;
```

​	

​	**1130, "Host 'xxxx' is not allowed to connect to this MySQL server"**	

​     mysql权限表限制

```sql
-- 查看权限表
use mysql;
select host,user from user;
-- 修改权限，但是报了一个1062错误，我们不予理会
update user set host='%' where user='root';
flush privileges;
--再次查看 发现多了一行% root
select host,user from user;
```



​	**ERROR 1819 (HY000): Your password does not satisfy the current policy requirements**

​	自定义密码比较简单，不符合密码策略

```sql
--设置密码的验证强度等级 修改后就只验证密码的长度了
set global validate_password_policy=LOW;
--设置密码的长度（INT类型）
set global validate_password_length=长度;


关于 mysql 密码策略相关参数；
1、validate_password_length  固定密码的总长度；
2、validate_password_dictionary_file 指定密码验证的文件路径；
3、validate_password_mixed_case_count  整个密码中至少要包含大/小写字母的总个数；
4、validate_password_number_count  整个密码中至少要包含阿拉伯数字的个数；
5、validate_password_policy 指定密码的强度验证等级，默认为 MEDIUM；
    关于 validate_password_policy 的取值：
    			0/LOW：只验证长度；
                1/MEDIUM：验证长度、数字、大小写、特殊字符；
                2/STRONG：验证长度、数字、大小写、特殊字符、字典文件；
6、validate_password_special_char_count 整个密码中至少要包含特殊字符的个数；
```



**查看已连接过mysql的主机地址**

```sql
select SUBSTRING_INDEX(host,':',1) as ip , count(*) from information_schema.processlist group by ip;
```