---
layout: posts
title: Swagger通用配置
date: 2020-09-07 15:15:00
updated: 2020-09-07 15:15:45
tags: 
categories: 
 - 总结
---
```java
import com.google.common.base.Predicates;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
    import springfox.documentation.builders.PathSelectors;
    import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
    import springfox.documentation.spi.DocumentationType;
    import springfox.documentation.spring.web.plugins.Docket;
    import springfox.documentation.swagger2.annotations.EnableSwagger2;
    
    /**
    
     * swagger配置类

     * @author saber
   */
       @EnableSwagger2
   @Configuration
       public class SwaggerConfig {
       @Bean
       public Docket webApiConfig(){
           return new Docket(DocumentationType.SWAGGER_2)
                   .groupName("在线教育API")
                   .apiInfo(webApiInfo())
                   .select()
               .paths(Predicates.not(PathSelectors.regex("/admin/.*")))
                .paths(Predicates.not(PathSelectors.regex("/error.*")))
                .build();
    }
 
    private ApiInfo webApiInfo(){
        return new ApiInfoBuilder()
                .title("网站-课程中心API文档")
                .description("本文档描述了课程中心微服务接口定义")
                .version("1.0")
                .contact(new Contact("saber", "xxxx", "xxx@qq.com"))
                .build();
    }
 }
```

 

