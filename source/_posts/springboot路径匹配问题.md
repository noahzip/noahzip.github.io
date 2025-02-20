---
layout: posts
title: SpringBoot路径匹配问题
date: 2020-12-10 16:30:00
updated: 2020-12-10 16:30:33
tags: 
categories: 
 - 经验&bug
---

### 近日在为公司项目搭建大数据平台展示模块时遇到一个错误：

```shell
Error starting ApplicationContext. To display the conditions report re-run your application with 'debug' enabled.
[2020-12-10 11:42:58.356] ERROR 15436 --- [                main] o.s.b.d.LoggingFailureAnalysisReporter   : 

***************************
APPLICATION FAILED TO START
***************************

Description:

Invalid mapping pattern detected: /**/login/**
^
No more pattern data allowed after {*...} or ** pattern element

Action:

Fix this pattern in your application or switch to the legacy parser implementation with `spring.mvc.pathpattern.matching-strategy=ant_path_matcher`.

Disconnected from the target VM, address: '127.0.0.1:63242', transport: 'socket'

Process finished with exit code 1
```

### 很明显的提示：

```shell
Invalid mapping pattern detected: /**/login/**
```

### 关于PathPattern`与`AntPathMatcher官方论坛大佬的解释：

https://spring.io/blog/2020/06/30/url-matching-with-pathpattern-in-spring-mvc

### 仔细排查后发现在配置Security时确实存在此问题：

```java
@Configuration
@EnableWebSecurity
public class WebSecurityConfig11 extends WebSecurityConfigurerAdapter {
    /**
     * 配置安全
     * */
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.formLogin()
                .loginPage("/needLogin")
                .loginProcessingUrl("/login").permitAll()
                .and()
                .authorizeRequests()
                // 授权不需要登录权限的URL
                .antMatchers("/needLogin",
                        "/swagger*//**",
                        "/v2/api-docs",
                        "/swagger-ui//**",
                        "/webjars*//**").permitAll()
                .requestMatchers(CorsUtils::isPreFlightRequest).permitAll().
                and().exceptionHandling().
                and().cors().and().csrf().disable();
    }
}
```

**虽然发现了问题，但这是一个公共配置文件，修改后会引发其他业务的正常运行，遂继续排查**

### 经过仔细排查后确定该问题是SpringBoot版本差异所导致的，将spring-boot-starter版本回退至2.1.3.RELEASE后问题解决：

```xml
<groupId>org.springframework.boot</groupId>
<artifactId>spring-boot-starter-parent</artifactId>
<version>2.1.3.RELEASE</version>
<relativePath/> <!-- lookup parent from repository -->
```