---
layout: posts
title: SpringCloud 注册中心:Eureka
date: 2020-03-04 16:26:00
updated: 2020-03-04 16:27:18
tags: 
categories: 
 - Java
---
## 1.环境搭建
#### 1. 服务中心注册
##### 1.1 服务端导入依赖
	<!-- 注册服务 -->
	<dependency>
	 <groupId>org.springframework.cloud</groupId>
	 <artifactId>spring-cloud-starter-eureka-server</artifactId>
	 <version>1.4.7.RELEASE</version>
	</dependency>
##### 1.2 服务中心配置application.properties
    # 服务端口
    server.port=9002
    
    # 是否将自己注册到Eureka中，本身是服务器无需注册
    eureka.client.register-with-eureka=false
    
    # 是否从Eureka中获取注册信息
    eureka.client.fetch-registry=false
    
    # Eureka客户端与Eureka服务器进行通信的地址
    eureka.client.service-url.defaultZone=http://127.0.0.1:${server.port}/eureka/
##### 1.3 服务中心启动类添加注解 @EnableEurekaServer
    @SpringBootApplication
    @EnableEurekaServer
    public class EurekaServerApplication {
        public static void main(String[] args) {
        	SpringApplication.run(EurekaServerApplication.class, args);
        }
    
    }
#### 2. 客户端注册
##### 2.1 客户端导入依赖
```xml
<!-- 注册客户端 -->
 <dependency>
     <groupId>org.springframework.cloud</groupId>
     <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
     <version>1.4.7.RELEASE</version>
</dependency>
```
##### 2.2 客户端配置application.properties
```properties
# 指定注册中心地址
eureka.client.service-url.defaultZone=http://127.0.0.1:9002/eureka/
# eureka上传获取的是服务器id地址 否则是主机名
eureka.instance.prefer-ip-address=true
```

##### 2.3 客户端启动类添加注解 @EnableEurekaClient
```java
@SpringBootApplication
@EnableEurekaClient
public class EduossApplication {
    public static void main(String[] args) {
        SpringApplication.run(EduossApplication.class, args);
    }
}
```
## 2. 服务发现：
前往注册中心路径查看服务是否加载


## 3. 服务调用：

#### 3.1 在要使用服务调用的客户端中添加依赖
```java
<!-- 服务调用 -->
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-openfeign</artifactId>
  <version>2.2.1.RELEASE</version>
</dependency>
```

#### 3.2 在要使用服务调用的客户端的启动类上标@EnableFeignClients
```java
@SpringBootApplication
@EnableEurekaClient //这是一个客户端
@EnableFeignClients	//允许加载服务
public class EduServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(EduServiceApplication.class, args);
    }

}
```
#### 3.3 创建接口
```java
@FeignClient("eduvideo") //要调用的服务端
@Component
public interface VideoClient {

    //定义调用方法的路径  必须使用@PathVariable指定参数名称
    @DeleteMapping("/eduvideo/deleteAliyunVideoById/{videoId}")
    public R deleteAliyunVideoById(@PathVariable("videoId") String videoId);
}
```
#### 3.4 在类注入中刚才创建的接口
```java
@Service
public class EduVideoServiceImpl extends ServiceImpl<EduVideoMapper, EduVideo> implements EduVideoService {

    //注入client
    @Autowired
    private VideoClient videoClient;

	public void removeById(String eduvideo){
		 videoClient.deleteAliyunVideoById(eduvideo);
	}
}
```