---
layout: posts
title: 尚硅谷在线教育项目技术总结
date: 2020-02-20 23:48:00
updated: 2020-02-21 15:55:05
tags: 
categories: 
 - Java
---
***
**使用SpringBoot + Vue 前后端分离式开发**


## 前端部分：
###  1.前端使用vscode 安装nodejs 使用npm进行项目管理 
```shell
	nmp常用命令：
		全局安装组件 ：nmp install -g xxx
		更新依赖 ： nmp install (一般在导入时使用)
		运行项目 : nmp run dev (dev表示开发环境）
```
###  2.安装Vue、Element

使用id选择器以及插值表达式对div内容进行渲染：

```html
<div id="app">
{{ message }}
</div>

var app = new Vue({
    el: '# app',
    data: {
    message: 'Hello Vue!'
    }
})
```



#### vue常用语法：
**插入文本<br>**
插值表达式：  {{ }}<br>
	<span>Message: {{ msg }}</span>	

**插入html文本**：      v-html="rawHtml"
	<span v-html="rawHtml"></span>


#### vue常用指令：
**条件判断** ： v-if
	 //当seen为true时 text才会显示
    <p v-if="seen">text</p>
			   
对应的还有： v-else
	 //当seen为false时 text才会显示
    <p v-else="seen">text</p>

**HTML属性取值**：  v-bind:id="dynamicId" 缩写为 :id 
	//这里的id是某一个元素的id属性
    <div v-bind:id="dynamicId"></div>
    	//缩写 
    <div :id="dynamicId"></div>

**双向数据绑定**： v-model=""
	//当原始数据或者input里的值某一个发生变化另一个随之改变
    <input v-model="message">

**绑定事件** ： v-on:click="doSomething" 缩写为 @:click
	<a v-on:click="doSomething">
	//缩写  
     <a @click="doSomething"></a>

**循环**： v-for="变量 in 数据"

    <!--循环遍历-->
    <ul>
      <template v-for="site in sites">
    	<li>{{ site.name }}</li>
      </template>
    </ul>

#### 路由绑定:

    {
        path: '/teacher',
        component: Layout,
        redirect: '/teacher/list',
        name: '讲师管理',
        meta: { title: '讲师管理', icon: 'example' },
        children: [
          {
            path: 'list',
            name: '讲师列表',
            component: () => import('@/views/edu/teacher/list'),
            meta: { title: '讲师列表', icon: 'table' }
          },
          {
            path: 'edit/:id', //传递id
            name: '修改讲师',
            component: () => import('@/views/edu/teacher/add'),
            meta: { title: '修改讲师', icon: 'tree' },
            hidden: true //隐藏该路由
          }
        ]
      },

#### 监听路由:
	 watch:{ //监听路由
	        $route(to,from){
	            console.log('watch $route')
	            this.init()//一般用于页面初始化清空参数
	        }
	    },

## 页面布局:
每个页面都由两部分组成
	
	</template>
		//页面显示内容
		...
	</template>
	<script>
		//script代码
		//首先引入要使用的js文件 JS是引用名 可以自定义
		import JS from '@/api/edu/teacher'
		export default{
	    data(){ //定义变量和初始值
	        return{
	            var1:"1",
				var2:{}
				...
	        }
	    },
		
		watch:{ //监听路由
	        $route(to,from){
	            console.log('watch $route')
	            this.xxx()
	        }
	    },
	
	    created(){//在页面渲染之前会执行该方法
	        this.xxx()
	       
	    },
		
	    methods:{//具体的方法调用
			xxx(){
				 JS.xxx(xxx) //调用JS中的xxx方法
				 .then(response=>{ //请求成功执行该方法
					})
				 .catch(()=>){ //请求失败执行该方法
					})	
			}
		}
	</script>

## 关于JS文件定义方法:
	//模板提供的组件 axios的封装
	import request from '@/utils/request'
	export default{
		 //具体方法
	    xxx(var1,var2,...){
	            return request({
	                //后台接口路径 携带普通参数使用 +var的方式
	                url: '/接口地址/'+var1,
	                //提交方式
	                method: 'post',
	                // 传递复杂数据（json）
	                data: var2
	                // params：serchObj  
	             })
	    },	   


​			 
## 后端部分:
### 1.创建数据库

### 2.创建SpringBoot项目根据需求分模块

### 3.在pom.xml文件中导入并管理依赖

### 4.配置application.properties

```properties
# 服务端口
server.port=8101

# 服务名
spring.application.name=xxxx

# 环境设置：dev、test、prod
spring.profiles.active=dev

# mysql数据库连接
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.url=jdbc:mysql://localhost:3306/database?characterEncoding=utf-8&useSSL=false
spring.datasource.username=username
spring.datasource.password=password

# Hikari是Spring Boot 2.0之后默认整合的数据库连接池，比druid更快的数据库连接池
# 数据源类型
spring.datasource.type=com.zaxxer.hikari.HikariDataSource
# 连接池名称，默认HikariPool-1
spring.datasource.hikari.pool-name=GuliHikariPool

# 最大连接数，小于等于0会被重置为默认值10；大于零小于1会被重置为minimum-idle的值
spring.datasource.hikari.maximum-pool-size=12

# 连接超时时间:毫秒，小于250毫秒，否则被重置为默认值30秒
spring.datasource.hikari.connection-timeout=60000

# 最小空闲连接，默认值10，小于0或大于maximum-pool-size，都会重置为maximum-pool-size
spring.datasource.hikari.minimum-idle=10

# 空闲连接超时时间，默认值600000（10分钟），大于等于max-lifetime且max-lifetime>0，会被重置为0；不等于0且小于10秒，会被重置为10秒。
# 只有空闲连接数大于最大连接数且空闲时间超过该值，才会被释放
spring.datasource.hikari.idle-timeout=500000

# 连接最大存活时间.不等于0且小于30秒，会被重置为默认值30分钟.设置应该比mysql设置的超时时间短
spring.datasource.hikari.max-lifetime=540000

# 连接测试查询
spring.datasource.hikari.connection-test-query=SELECT 1

# mybatis日志
mybatis-plus.configuration.log-impl=org.apache.ibatis.logging.stdout.StdOutImpl

# json时间格式
spring.jackson.date-format=yyyy-MM-dd HH:mm:ss
spring.jackson.time-zone=GMT+8
```


### 5.导入velocity 模板引擎
```xml
<!-- velocity 模板引擎, Mybatis Plus 代码生成器需要 -->
<dependency>
    <groupId>org.apache.velocity</groupId>
    <artifactId>velocity-engine-core</artifactId>
</dependency>
```
### 6.导入lombok swagger
```xml
<!--lombok用来简化实体类：需要安装lombok插件-->
<dependency>
   <groupId>org.projectlombok</groupId>
   <artifactId>lombok</artifactId>
</dependency>

 <!--swagger-->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
</dependency>
```
### 7.使用代码构造器生成 service层 dao层 bean层
```java
import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
import com.baomidou.mybatisplus.generator.config.GlobalConfig;
import com.baomidou.mybatisplus.generator.config.PackageConfig;
import com.baomidou.mybatisplus.generator.config.StrategyConfig;
import com.baomidou.mybatisplus.generator.config.po.TableFill;
import com.baomidou.mybatisplus.generator.config.rules.DateType;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import org.junit.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;

@SpringBootTest
public class CodeGenerator {
	@Test
	public void genCode() {
	
		String moduleName = "edu";
		
		// 1、创建代码生成器
		AutoGenerator mpg = new AutoGenerator();
		
		// 2、全局配置
		GlobalConfig gc = new GlobalConfig();
		String projectPath = System.getProperty("user.dir");
		gc.setOutputDir(projectPath + "/src/main/java");
		gc.setAuthor("Chenxinyi");//作者
		gc.setOpen(false); //生成后是否打开资源管理器
		gc.setFileOverride(false); //重新生成时文件是否覆盖
		gc.setServiceName("%sService");	//去掉Service接口的首字母I
		gc.setIdType(IdType.ID_WORKER_STR); //主键策略
		gc.setDateType(DateType.ONLY_DATE);//定义生成的实体类中日期类型
		gc.setSwagger2(true);//开启Swagger2模式
		
		mpg.setGlobalConfig(gc);
		
		// 3、数据源配置
		DataSourceConfig dsc = new DataSourceConfig();
		dsc.setUrl("jdbc:mysql://localhost:3306/eduonline");
		dsc.setDriverName("com.mysql.jdbc.Driver");
		dsc.setUsername(" ");
		dsc.setPassword(" ");
		dsc.setDbType(DbType.MYSQL);
		mpg.setDataSource(dsc);
		
		// 4、包配置
		PackageConfig pc = new PackageConfig();
		//pc.setModuleName(moduleName); //模块名
		pc.setParent("com.eduonline.eduservice");
		pc.setController("controller");
		pc.setEntity("entity");
		pc.setService("service");
		pc.setMapper("mapper");
		mpg.setPackageInfo(pc);
		
		// 5、策略配置
		StrategyConfig strategy = new StrategyConfig();
		strategy.setInclude(moduleName + "_\\w*");//设置要映射的表名
		strategy.setNaming(NamingStrategy.underline_to_camel);//数据库表映射到实体的命名策略
		strategy.setTablePrefix(pc.getModuleName() + "_");//设置表前缀不生成
		
		strategy.setColumnNaming(NamingStrategy.underline_to_camel);//数据库表字段映射到实体的命名策略
		strategy.setEntityLombokModel(true); // lombok 模型 @Accessors(chain = true) setter链式操作
		
		strategy.setLogicDeleteFieldName("is_deleted");//逻辑删除字段名
		//strategy.setEntityBooleanColumnRemoveIsPrefix(true);//去掉布尔值的is_前缀
		
		//自动填充
		TableFill gmtCreate = new TableFill("gmt_create", FieldFill.INSERT);
		TableFill gmtModified = new TableFill("gmt_modified", FieldFill.INSERT_UPDATE);
		ArrayList<TableFill> tableFills = new  ArrayList<TableFill>();
		tableFills.add(gmtCreate);
		tableFills.add(gmtModified);
		strategy.setTableFillList(tableFills);
		
		strategy.setVersionFieldName("version");//乐观锁列
		
		strategy.setRestControllerStyle(true); //restful api风格控制器
		strategy.setControllerMappingHyphenStyle(true); //url中驼峰转连字符
		
		mpg.setStrategy(strategy);
		
		// 6、执行
		mpg.execute();
	}
}
```
### 8.在实体Bean类上标注     @Data注解 免除写geteer/settter
### 9.定义返回数据实体类
```java
package com.eduonline.common;

/**
 * 在接口内部定义状态码 实现类可通过链式编程调用
 */
public interface ResultCode {

    int SUCCESS=20000;//成功
    
    int ERROR=20001;//失败
    
    int AUTH=30000;//没有权限
}
```

具体的类：

```java
package com.eduonline.common;

import lombok.Data;

import java.util.HashMap;
import java.util.Map;

/**
 * 定义具体的数据格式
 */
@Data
public class R implements ResultCode{

private Boolean success; //操作是否成功

private Integer code;   //响应状态码

private String message; //响应消息

private Map<String,Object> data = new HashMap<>(); //响应数据

private R(){}
    
    //操作成功 调用该方法
    public static R ok(){
    	R r = new R();
    	r.setSuccess(true);
    	r.setCode(ResultCode.SUCCESS);
    	r.setMessage("操作成功");
    	return r;
    	}
    	
    	//操作失败
    	public static R error(){
    	R r = new R();
    	r.setSuccess(false);
    	r.setCode(ResultCode.ERROR);
    	r.setMessage("操作失败");
    	return r;
    	}
    	
    	public R success(Boolean success){
    	this.setSuccess(success);
    	return this;
    	}
    	
    	public R message(String message){
    	this.setMessage(message);
    	return this;
    	}
    	
    	public R code(Integer code){
    	this.setCode(code);
    	return this;
    	}
    	
    	public R data(String key, Object value){
    	this.data.put(key, value);
    	return this;
    	}
    	
    	public R data(Map<String, Object> map){
    	this.setData(map);
    	return this;
    }
    
}
```


​    
### 8.编写Controller控制器
别忘了@CrossOrigin注解 解决跨域问题
    
```java
@CrossOrigin //解决跨域
@RestController
@RequestMapping("/edu-teacher")
public class EduTeacherController {

}
```
### 9.特别的 


```java
/**
 * 查询条件封装类
 * 前端传入的查询数据可能会与实体类字段有出入，
 *我的做法是专门定义一个类用于封装前端传递的查询条件
 */
import lombok.Data;   
    @Data
    public class QueryTeacher {
    private String name;
    private String level;
    private String begin;
    private String end;
}
```







