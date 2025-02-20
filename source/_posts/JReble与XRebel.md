---
layout: posts
title: JReble与XRebel
date: 2020-12-16 17:38:21
updated: 2020-12-16 17:38:21
tags: 
categories: 
 - Java
---


## 关于jReble的实际使用可前往

#### [**沉默的反补**]https://www.bilibili.com/video/BV1rz4y1k7ii

### 1.安装插件、重启idea



![result1.png](https://i.loli.net/2020/12/16/zv2WX6eCU7d1BFf.png)



### 2.下载反向代理工具



```
根据系统选择工具版本地址为：
https://github.com/ilanyu/ReverseProxy/releases/tag/v1.4

Windows64位版本下载地址：
https://github.com/ilanyu/ReverseProxy/releases/download/v1.4/ReverseProxy_windows_amd64.exe
```

### 3.运行反向代理工具



![result7.png](https://i.loli.net/2020/12/16/gsetnpTxbdL8UfI.png)



### 4.打开jRebel的激活界面，输入激活地址和自己邮箱地址



![result6.png](https://i.loli.net/2020/12/16/Jj4HWNfpzKCcdsr.png)



**激活地址随便从下面4个地址中选一个可用的即可：**



```
http://127.0.0.1:8888/Zephyr
http://127.0.0.1:8888/88414687-3b91-4286-89ba-2dc813b107ce
http://127.0.0.1:8888/ff47a3ac-c11e-4cb2-836b-9b2b26101696
http://127.0.0.1:8888/11d221d1-5cf0-4557-b023-4b4adfeeb36a
```

### 5.查看console是否激活



![result.png](https://i.loli.net/2020/12/16/PBnhJCQHj2rIAvM.png)



### 6.设置离线使用



![result3.png](https://i.loli.net/2020/12/16/o8s2ATV6mtbxQyp.png)



### 7.使用jrebel启动即可享受热部署与异常分析



![result6.png](https://i.loli.net/2020/12/16/f6Js4TYFltyCoEd.png)



##### 修改代码后只需build即可热部署，但是对于实体类以及原生mapper结果字段的修改必须重启才能生效