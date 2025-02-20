---
layout: posts
title: Zull网关
date: 2020-03-09 11:14:24
updated: 2020-03-09 11:14:24
tags: 
categories: 
 - Java
---
### 1.导入依赖
```xml
<dependencies>
    <!--网关-->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-netflix-zuul</artifactId>
    </dependency>
</dependencies>
```
### 2.配置application.properties
```properties
服务端口
server.port=9003
# 服务名
spring.application.name=edugateway
```
### 3.创建启动类 标注@EnableZuulProxy
```java
@SpringBootApplication
@EnableZuulProxy //作为网关启动
public class EduGatewayApplication {
    public static void main(String[] args) {
        SpringApplication.run(EduGatewayApplication.class);
    }
}
```

### 4.功能配置 
##### 4.1 端口映射 （不适用于集群服务器）
```properties
## 输入的路径包含eduservice 跳转到 8101端口
# zuul.routes.api-edu.path=/eduservice/**
# zuul.routes.api-edu.url=http://localhost:8101/eduservice/
```
访问方式: http://localhost:网关端口/eduservice/controller路径
##### 4.2 在服务中心注册以支持集群 通过服务名访问
```properties
# 指定注册中心地址
eureka.client.service-url.defaultZone=http://127.0.0.1:9002/eureka/
# eureka上传获取的是服务器id地址 否则是主机名
eureka.instance.prefer-ip-address=true
```
需要注意的是需要在网关启动类上标注 @EnableEurekaClient<br>
访问方式:http://localhost:网关端口/服务名/controller路径
##### 4.3 禁止暴露接口
```properties
## 禁止eduservice对外提供接口
# zuul.ignored-services=eduservice
```
##### 4.4 禁止通过网关访问路由
```properties
###  禁止通过网关访问路由 
# zuul.ignored-patterns=/**/eduservice/**
```
##### 4.5 自定义路由映射
```properties
###  自定义路由映射 起别名 
# zuul.routes.eduservice=/service/**
```
### 5.特别注意 Zuul默认不传递cookie
##### 使用postman的设置header提交
##### cookie="cokie"
##### token="token" 

```java
public void zuulCookieTest(HttpServletRequest request){
	String cookie = request.getHeader("cookie");
	String token = request.getHeader("token");
	System.out.println("cookie:"+cookie);
	System.out.println("token:"+token);
}	
```

##### 打印结果: 
cookie:null 

token:token

```properties
# 还原被网关过滤的请求头
zuul.sensitive-headers=
```


##### 打印结果: 
cookie:cookie

token:token

-----
### 6.Zull过滤器
#### 6.1生命周期：

##### 1.Pre:到达网关前执行
##### 2.Routing:经过网关到达服务器之前执行
##### 3.Post:经过服务器之后执行
##### 4.Error:发生错误执行
---
#### 6.2过滤器的配置与使用
```java
/**
 * 模拟鉴权
 */
@Component
public class LoginFilter extends ZuulFilter {

    /**
     * 定义过滤器的类型（生命周期）
     * @return  PRE_TYPE:到达网关前执行
     *          ROUTE_TYPE:经过网关到达服务器之前执行
     *          POST_TYPE:经过服务器之后执行
     *          ERROR_TYPE:发生错误执行
     */
    @Override
    public String filterType() {
        return PRE_TYPE;
    }

    /**
     * 过滤器执行顺序
     * @return  返回的值越小越先执行
     */
    @Override
    public int filterOrder() {
        return 1;
    }

    /**
     * 决定是否要执行下面的run()方法
     * @return  false:过滤器放行 不执行run()
     *          true :过滤器拦截 执行run()
     */
    @Override
    public boolean shouldFilter() {
        //判断：访问路径包含 eduvideo/getPlayAuth 进行登录校验
        String playUrl = "eduvideo/getPlayAuth";
        //1.获取请求路径uri
        RequestContext currentContext = RequestContext.getCurrentContext();
        HttpServletRequest request = currentContext.getRequest();
        String requestURI = request.getRequestURI();
        System.out.println(requestURI);

        //2.根据uri判断
        if (!StringUtils.isEmpty(requestURI) &&requestURI.contains(playUrl)){
            //拦截
            return true;
        }else {
            //放行
            return false;
        }
    }

    /**
     * 过滤器的具体逻辑
     * @return
     * @throws ZuulException
     */
    @Override
    public Object run() throws ZuulException {
        System.out.println("run执行了");
        RequestContext currentContext = RequestContext.getCurrentContext();
        HttpServletRequest request = currentContext.getRequest();
        String token = request.getParameter("token");
        if (StringUtils.isEmpty(token)){
            //用户未登录 不包含token
            currentContext.setSendZuulResponse(false);//后面不能访问
            //设置状态码
            currentContext.setResponseStatusCode(HttpStatus.UNAUTHORIZED.value());
        }
        return null;
    }
}
```




