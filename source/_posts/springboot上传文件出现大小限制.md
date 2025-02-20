---
layout: posts
title: springboot上传文件出现大小限制
date: 2020-03-04 16:30:00
updated: 2020-03-04 16:30:33
tags: 
categories: 
 - 经验&bug
---
 ### 在application.properties中添加如下配置即可  
```yml
# 设置上传文件限制大小
# 单个文件最大 1g
spring.servlet.multipart.max-file-size=1024MB
# 最大总上传量 1g
spring.servlet.multipart.max-request-size=1024MB
```
