---
layout: posts
title: Mybatis逆向工程使用方法
date: 2020-02-21 15:26:00
updated: 2020-02-21 15:32:29
tags: 
categories: 
 - Java
---
### 1.pom导入mybatis代码构造器坐标依赖

```xml
<dependency>
   <groupId>org.mybatis.generator</groupId>
   <artifactId>mybatis-generator-core</artifactId>
   <version>1.4.0</version>
</dependency>
```
### 2.创建xml配置文件

```xml
    <!DOCTYPE generatorConfiguration PUBLIC
    "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
    "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">
    
    <generatorConfiguration>
       <context id= "testTables" targetRuntime= "MyBatis3" >
       <commentGenerator>
       <!-- 是否去除自动生成的注释 true：是 ： false:否 -->
       <property name= "suppressAllComments" value= "true" />
    </commentGenerator>
    
    <!--数据库连接的信息：驱动类、连接地址、用户名、密码 -->
    <jdbcConnection driverClass="com.mysql.jdbc.Driver"
       connectionURL= "jdbc:mysql://localhost:3306/xxx"
       userId= "username"
       password= "password" >
    </jdbcConnection>
       <!-- 生成POJO类的位置
       targetPackage:包名
       targetProject：路径名-->
       <javaModelGenerator targetPackage= "com.xxx.xxx.bean"
       targetProject= "src\main\java" >
    </javaModelGenerator>
    
    <!-- mapper映射文件生成的位置 -->
    <sqlMapGenerator targetPackage= "mapper"
        targetProject= "src\main\resources" >
    </sqlMapGenerator>
    
    <!-- mapper接口生成的位置 -->
    <javaClientGenerator type= "XMLMAPPER"
        targetPackage= "com.xxx.xxx.dao"
        targetProject= "src\main\java" >
    </javaClientGenerator>
    
    <!-- 要逆向的每一张表
    		domainObjectName:指定类名
     	-->
    <table tableName="tabler" domainObjectName="UmsMember" />
    
    </context>
</generatorConfiguration>
```

### 3.使用代码生成器

```java
package com;

import org.mybatis.generator.api.MyBatisGenerator;
import org.mybatis.generator.config.Configuration;
import org.mybatis.generator.config.xml.ConfigurationParser;
import org.mybatis.generator.internal.DefaultShellCallback;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class TestMBG {
    public static void main(String[] args)  throws Exception{
	    List<String> warnings = new ArrayList<String>();
	    boolean overwrite = true;
	    	//指定配置文件的全路径类名 注意不能有空格
	    File configFile = new File("C:\\Users\\xxx\\testMBG\\src\\main\\resources\\mbg.xml");
	    ConfigurationParser cp = new ConfigurationParser(warnings);
	    Configuration config = cp.parseConfiguration(configFile);
	    DefaultShellCallback callback = new DefaultShellCallback(overwrite);
	    MyBatisGenerator myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
	    myBatisGenerator.generate(null);
	    System.out.println("生成成功！");
    }
}
```

