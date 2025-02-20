---
layout: posts
title: ssm整合shiro
date: 2020-07-25 09:17:00
updated: 2020-07-25 09:36:14
tags: 
categories: 
 - 总结
---
![shiro.png](https://i.loli.net/2020/07/25/TCxpAZJwRkBEHLs.png)



####  **1、在 maven 项目中引入 Shiro 依赖：**

```xml
<!-- shiro  -->
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-all</artifactId>
    <version>1.3.2</version>
</dependency>
<!-- 引入ehcache的依赖,给shiro做缓存权限用的 -->		
<dependency>
    <groupId>net.sf.ehcache</groupId>
    <artifactId>ehcache</artifactId>
    <version>2.10.6</ve
</dependency>
```

####  **2、在 web.xml 中配置 Shiro 的拦截器：**

```xml
<!-- 配置 shiro 拦截器  -->
<filter>
    <filter-name>shiroFilter</filter-name>
    <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
    <init-param>
        <param-name>targetFilterLifecycle</param-name>
        <param-value>true</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>shiroFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

####  **3、在 spring.xml 中配置 Shiro 的核心组件和拦截规则：**

#####  1）核心组件，并配置缓存和自己实现的Realm：

```xml
<!-- 配置 shiro 的核心组件：securityManager -->
<bean id="securityManager" class="org.apache.shiro.web.mgt.DefaultWebSecurityManager">
    <!-- 配置缓存 -->
    <property name="cacheManager" ref="cacheManager"/> 
    <!-- 配置域realm，用户名，密码，角色都保存在域里：实现从数据库中获取用户信息，需要我们自己创建一个类（实现Realm接口） -->
    <property name="realm" ref="shiroRealm"/>
</bean>
    
<!-- 配置ehcache缓存bean，导入ehcache并新建配置文件 也可使用redis-->
    <bean id="cacheManager" class="org.apache.shiro.cache.ehcache.EhCacheManager">
	<property name="cacheManagerConfigFile" value="classpath:ehcache.xml"></property>
    </bean>
	
<!-- 配置自己域realm实现  -->
<bean id="securityManager" class="org.apache.shiro.web.mgt.DefaultWebSecurityManager">
    <!-- 配置realm 需要一个实现realm的类 -->
    <property name="realm" ref="ShiroRealm" />
</bean>
```

#####    2）Shiro 拦截规则：

```xml
<!-- 配置ShiroFilter
        id名和web.xml中的shiroFilter id必须一致
        否则部署时抛出 NoSuchBeanDefinitionException-->
<bean id="shiroFilter"
      class="org.apache.shiro.spring.web.ShiroFilterFactoryBean">
    <!-- securityManager 权限认证失败，则跳转到指定页面-->
    <property name="securityManager" ref="securityManager" />

    <!-- 登录页面 不存在的页面也会被重定向到该页面-->
    <property name="loginUrl" value="/login" />

    <!-- 登录成功页面 -->
    <property name="successUrl" value="/admin/index" />

    <!-- 无权限页面 -->
    <property name="unauthorizedUrl" value="/unauthorized" />

    <!-- 配置受保护的页面，已经访问这些页面所需要的权限 -->
    <property name="filterChainDefinitions">
        <value>
        <!-- 注意：规则是有顺序的，从上到下，拦截范围必须是从小到大的 -->
        <!-- anon:可以被匿名访问 -->
        /login = anon
        /logout = logout
        <!-- authc:必须登陆之后才能访问 -->
        /admin/** = authc
        /**							= authc
        </value>
    </property>
</bean>
```

####  **4、在 springmvc.xml 中配置 Shiro 的注释：**

#####   使用 shiro 注解一般在 controller 中

```xml
<!-- 配置shiro开启注解支持 -->
<bean id="lifecycleBeanPostProcessor" class="org.apache.shiro.spring.LifecycleBeanPostProcessor"/>
<bean class="org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator"
          depends-on="lifecycleBeanPostProcessor"/>
<bean class="org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor">
        <property name="securityManager" ref="securityManager"/>
</bean>
```

####  **5、LoginController 实现 访问控制：**

 登录 index.jsp 页面，访问 url 可以是 项目根路径(主要是注销是自动返回web根目录)，也可以是 /login

#####   1）获取到shiro的认证核心组件Subject接口的对象（这个对象封装了登录用户对象信息），并调用Subjent接口的实现对象的login方法来验证用户名和密码，

#####  2）注意：Subjent接口的实现对象的 login 方法，实质上是将参数 token（含有登录用户对象信息）传到我们自定义的ShiroRealm 类中的实现方法里处理

```java
@Controller
public class LoginController {
 
	@GetMapping(value= {"/","/login"})
	public String login() {
		return "login";
	}
	
	@PostMapping("/login")
	public String login(User user) {
		//使用 shiro 登录验证
		//1 认证的核心组件：获取 Subject 对象
		Subject subject = SecurityUtils.getSubject();
		//2 将登陆表单封装成 token 对象
		UsernamePasswordToken token = new UsernamePasswordToken(user.getUsername(), user.getPazzword());
		try {
			//3 让 shiro 框架进行登录验证：
			subject.login(token);
		} catch (Exception e) {
			e.printStackTrace();
			return "loginError";
		}
		return "redirect:/admin/index";
	}
	
	@GetMapping("/admin/index")
	public String admin(Model model) {
		System.out.println("admin");
		return "admin/index";
	}
}
```

和 Shiro 拦截规则 的跳转 url 保持一致，jsp页面简单写了几个字

![](https://img-blog.csdnimg.cn/20190228103721872.png)

####  **6、自定义 ShiroRealm 实现：**

如果**实现 Realm 接口**，参数 token 会被传递到 supports 方法上

继承 **AuthenticatingRealm** 类，参数 token 会被传递到 **doGetAuthenticationInfo** 方法上

```java
public class ShiroRealm extends AuthenticatingRealm{
	@Autowired
	private UserMapper userMapper;
	/**
	 *  登录的验证实现方法
	 * @param token
	 * @return
	 * @throws AuthenticationException
	 */
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
		UsernamePasswordToken token2 = (UsernamePasswordToken) token;
		String username = token2.getUsername();
		User user = userMapper.getUserByUsername(username);
		if(user == null) {
			throw new UnknownAccountException("用户名或密码有误！");
		}
		if(user.getStatus() == 0) {
			throw new UnknownAccountException("用户名已被禁用，请联系系统管理员！");
		}
		
		/**
		 * principals: 可以使用户名，或d登录用户的对象
		 * hashedCredentials: 从数据库中获取的密码
		 * credentialsSalt：密码加密的盐值
		 * RealmName:  类名（ShiroRealm）
		 */
		AuthenticationInfo info = new SimpleAuthenticationInfo(user, user.getPazzword(), null, getName());
		return info; //框架完成验证
	}	
 }
```

------

####  shiro 登录步骤分析:

#####   1）表单提交后进入login方法后 调用 subject.login(token);

![](https://img-blog.csdnimg.cn/20190301103821902.png)

#####  2）Subject 是通过 securityManager 调用 login() 方法 来进行登录操作

![](https://img-blog.csdnimg.cn/20190301104227765.png)

![](https://img-blog.csdnimg.cn/20190301104312474.png)

#####  3） DefaultSecurityManager 类

 该方法里会验证登录信息，如果登录通过会返回登录信息，如不通过则抛出异常；authenticate 方法定义在父类AuthenticatingSecurityManager 中；

![](https://img-blog.csdnimg.cn/20190301104527760.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNDAyODU0,size_16,color_FFFFFF,t_70)

#####  4）AuthenticatingSecurityManager 类

![](https://img-blog.csdnimg.cn/20190301105327873.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNDAyODU0,size_16,color_FFFFFF,t_70)

#####  5）AbstractAuthenticator 类

![](https://img-blog.csdnimg.cn/20190301111316794.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNDAyODU0,size_16,color_FFFFFF,t_70)

#####  **6）ModularRealmAuthenticator 类**

 4、5 的 **authenticate** 方法 都交给了 这个类的 **doAuthenticate** 方法执行(单个realm的处理方法 **doSingleRealmAuthentication**)

![](https://img-blog.csdnimg.cn/20190301111948175.png)

#####  7）ModularRealmAuthenticator 类

红色标记部分，就是真正的**调用Reaml来实现登录**

![](https://img-blog.csdnimg.cn/20190301112026568.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNDAyODU0,size_16,color_FFFFFF,t_70)

#####  **8）AuthenticatingRealm 类**

#####  第一个标记是从缓存中查看，该用户是否已经登录。如果已经登录怎么直接完成了登录流程；

#####  第二个标记是根据用户信息，去获取数据库保存的该用户的密码等信息；

#####  第三个标记是利用第二个标记得到的数据库该用户的信息和本次登录该用户的信息经行比较，如果正确则验证通过，返回用户信息。如果不通过则验证失败，登录不成功，抛出错误

![](https://img-blog.csdnimg.cn/20190301112531602.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNDAyODU0,size_16,color_FFFFFF,t_70)

------

####  Shiro如何完成验证：

1）在 UsernamePasswordToken 类的 方法打断点

![](https://img-blog.csdnimg.cn/20190301113629187.png)

2）在 SimpleCredentialsMatcher 类 打断点：

![](https://img-blog.csdnimg.cn/20190301113709918.png)

![](https://img-blog.csdnimg.cn/20190301113918596.png)

#####  3）shiro进行对比密码的是一个接口：CredentialsMatcher

此接口的实现类：

**SimpleCredentialsMatcher**：**没有对密码进行加密**，

**HashedCredentialsMatcher**： **实现了对密码的加密**

**返回结果后，如果密码对比正确，跳转到登录成功后的页面**

**密码对比不正确，抛出异常：IncorrectCredentialsException**