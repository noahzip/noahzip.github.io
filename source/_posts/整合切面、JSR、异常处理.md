---
layout: posts
title: 整合切面、JSR、异常处理
date: 2020-03-16 19:56:00
updated: 2020-03-16 20:10:55
tags: 
categories: 
 - 总结
---
##  1.切面编写
* 1)导入切面场景
		
	   ```xml
	<dependency>
	    <groupId>org.springframework.boot</groupId>
	    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
	```
	
* 2) 编写切面<br>
	
	1、标注@Aspect<br>
	
	2、编写切入点表达式<br>
	
	3、使用通知：

		前置通知：方法执行之前触发
		后置通知：方法执行之后触发
		返回通知：方法正常返回之后触发
		异常通知：方法出现异常触发
		环绕通知：以上4合1
* 3) 执行流程

		正常执行：   前置通知==>返回通知==>后置通知
		异常执行：   前置通知==>异常通知==>后置通知

##  2.编写异常处理器

```java
/**
 * 统一处理异常信息
 */
@Slf4j
@RestControllerAdvice //当前类是一个异常处理类 并返回json数据
public class GlobalExceptionHandler {

    /**
     * 处理数学异常
     * @param exception
     * @return
     */
    @ExceptionHandler(value = {ArithmeticException.class})
    public Object handlerArithmeticException(Exception exception){
        log.error("系统全局异常感知，信息：{}",exception.getStackTrace());
        return new CommonResult().validateFailed("数学计算出现错误！");
    }

    /**
     * 处理空指针异常
     * @param exception
     * @return
     */
    @ExceptionHandler(value = {NullPointerException.class})
    public Object handlerNullPointerException(Exception exception){
        log.error("系统全局异常感知，信息：{}",exception.getStackTrace());
        return new CommonResult().validateFailed("空指针了！");
    }
}
```


##  3.整合JSR303和异常处理器 切记**务必抛出异常**
```java
@Aspect //标注切面类
@Component 
@Slf4j
public class DataVaildAspect {
                //com.saber.gmall.admin下任意修饰符任意类的任意参数的任意方法
    @Around("execution(* com.saber.gmall.admin..*Controller.*(..))")
    public Object vaildAround(ProceedingJoinPoint point){

        log.debug("校验切面介入工作。。。");
        log.debug("JSR303校验开始。。。");
        //方法返回的结果
        Object proceed = null;
        try {
            Object[] args = point.getArgs();
            for (Object arg : args) {
                if(arg instanceof BindingResult){ //判断是否包含BandingResult
                    BindingResult r = (BindingResult) arg;
                    int errorCount = r.getErrorCount(); //取得BandingResult的错误条数
                    if(errorCount>0){
                        log.debug("JSR303校验失败。。。");
                        return new CommonResult().validateFailed(r);
                    }
                }
            }
            log.debug("JSR303校验成功。。。");
            //System.out.println("前置通知");
            //相等于反射的 method.invoke()
            proceed = point.proceed(point.getArgs());
            log.debug("校验切面放行目标方法。。。{}",proceed);
            //System.out.println("返回通知");
        } catch (Throwable throwable) {
            //System.out.println("异常通知");
            throw new RuntimeException(throwable); //一定要抛出异常 否则不会进入异常处理类
        } finally {
            //System.out.println("后置通知");
        }
        return proceed;
    }

}
```
## 测试：
```java
//在controller里制造除0异常
int a = 10 /0;
```
### 结果：

	2020-03-16 19:42:07.024 DEBUG 16040 --- [nio-8081-exec-5] c.saber.gmall.admin.aop.DataVaildAspect  : 校验切面介入工作。。。
	2020-03-16 19:42:07.024 DEBUG 16040 --- [nio-8081-exec-5] c.saber.gmall.admin.aop.DataVaildAspect  : JSR303校验开始。。。
	2020-03-16 19:42:07.024 DEBUG 16040 --- [nio-8081-exec-5] c.saber.gmall.admin.aop.DataVaildAspect  : JSR303校验成功。。。
	2020-03-16 19:42:07.024 DEBUG 16040 --- [nio-8081-exec-5] c.s.g.a.u.controller.UmsAdminController  : 需要注册的用户详情：UmsAdminParam(username=saber, password=saber, icon=string, email=string@qq.com, nickName=null, note=string)
	2020-03-16 19:42:07.025 DEBUG 16040 --- [nio-8081-exec-5] .m.m.a.ExceptionHandlerExceptionResolver : Using @ExceptionHandler com.saber.gmall.admin.aop.GlobalExceptionHandler# handlerArithmeticException(Exception)
	2020-03-16 19:42:07.025 ERROR 16040 --- [nio-8081-exec-5] c.s.g.admin.aop.GlobalExceptionHandler   : 系统全局异常感知，信息：com.saber.gmall.admin.aop.DataVaildAspect.vaildAround(DataVaildAspect.java:68)
	2020-03-16 19:42:07.025 DEBUG 16040 --- [nio-8081-exec-5] m.m.a.RequestResponseBodyMethodProcessor : Using 'application/json', given [*/*] and supported [application/json, application/*+json, application/json, application/*+json]
	2020-03-16 19:42:07.025 DEBUG 16040 --- [nio-8081-exec-5] m.m.a.RequestResponseBodyMethodProcessor : Writing [{"code":404,"message":"数学计算出现错误！"}]
	2020-03-16 19:42:07.026 DEBUG 16040 --- [nio-8081-exec-5] .m.m.a.ExceptionHandlerExceptionResolver : Resolved [java.lang.RuntimeException: java.lang.ArithmeticException: / by zero]
	2020-03-16 19:42:07.026 DEBUG 16040 --- [nio-8081-exec-5] o.s.web.servlet.DispatcherServlet        : Completed 200 OK