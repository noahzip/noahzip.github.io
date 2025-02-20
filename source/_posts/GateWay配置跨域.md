---
layout: posts
title: GateWay配置跨域
categories:
  - 经验&bug
abbrlink: 20119
date: 2020-08-06 04:10:39
updated: 2020-08-06 04:10:39
tags:
---
####  gateway路径重写失效：

#####  1.检查配置文件

```yml
spring:
  cloud:
      routes:	# 路由规则
        - id: admin_route
          uri: lb://renren-fast
          predicates:  # 带上/api
            - Path=/api/**
          filters:
              # 路径重写
              # GateWay -version2.3之前的写法 具体参考官方文档
#          - RewritePath=/api/(?<segment>/.*),/项目名（模块名）$\{segment} 
			# GateWay -version2.3之后的写法
            - RewritePath=/api(?<segment>/?.*),/项目名（模块名）/$\{segment}
```

#####  3.检查是否加载使用了配置中心的配置文件

#####  4.检查被访问服务是否有项目名前缀

#####  5.检查路径是否需要权限认证

------

####  跨域问题：

出于安全考虑，远程调用遵循同源协议，简单来说就是**协议名**（http,https）、**域名**、**端口名**有任何一个不相同就会被禁止访问。



具体的方式是常见的请求会发送一个哨兵去探路，返回200表示真正的请求能够发出。如果不允许跨域则403

![99E_7RB4_35K294O_8@_1YO.png](https://i.loli.net/2020/08/06/ZxC6gByVan2bvSY.png)



**常见的解决办法**：

#####  第一种方式：把前端和后端都部署到nginx。（更安全）

![7OX_8R_@ZL79_CM~KCB@@5R.png](https://i.loli.net/2020/08/06/wlPfOLqE8DNS4gz.png)

#####  第二种方式：配置网关允许跨域

第一种配置方式：注册bean

```java
@Configuration
public class CorsConfig{

    /**
     * 配置跨域
     * @return
     */
    @Bean
    public CorsWebFilter corsWebFilter(){
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration configuration = new CorsConfiguration();
        //允许的请求头 * 代表所有
        configuration.addAllowedHeader("*");
        //允许的请求方式
        configuration.addAllowedMethod("*");
        //允许的请求来源
        configuration.addAllowedOrigin("*");
        //允许携带cookie跨域
        configuration.setAllowCredentials(true);
        source.registerCorsConfiguration("/**",configuration);
        return new CorsWebFilter(source);
    }
}
```

第二种配置方式：配置文件

```yaml
spring:
  cloud:
    gateway:
      globalcors: # 跨域配置
        cors-configurations:        # 允许任意路径
          '[/**]':
            allowCredentials: true  # 允许携带cookie
            allowedOrigins: "*"     # 允许任意来源
            allowedMethods: "*"     # 允许任意请求方式
            allowedHeaders: "*"     # 允许任意请求头
```

**再次测试：**依然失败

![TI3TB__TCXW9DW`~6_PZ0WU.png](https://i.loli.net/2020/08/06/D1IldoLiMneVtK3.png)

**原因：存在多份跨域配置**

**解决方法：删除模块里单独的跨域配置，由网关服务统一管理**

