---
layout: posts
title: Spring注解开发
date: 2020-05-19 20:33:00
updated: 2020-05-21 10:19:50
tags: 
categories: 
 - 总结
---
# Spring注解开发

##  注册组件：

##    一、常规的xml配置注解：

###  1.准备要加入容器中的类

```java
public class Person {
    private String name;
    private Integer age;

    public Person() {
    }

    public Person(String name, Integer age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
```

```java
@Service
public class BookService {
}

@Repository
public class BookDao {
}

@Controller
public class BookController {
}
```

###  2.建立一个bean.xml文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd 
       http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd">

    <!-- 扫描此包下@Controller @Service @Component @Repository -->
    <context:component-scan base-package="org.example.bean"></context:component-scan>

    <bean class="org.example.bean.Person" id="person">
        <property name="age" value="18"></property>
        <property name="name" value="saber"></property>
    </bean>

</beans>
```

###  3.测试

```java
/**
     * 配置文件注册bean
     */
    @Test
    void testXmlConfig(){
        ApplicationContext ioc =
                new ClassPathXmlApplicationContext("bean.xml");
        Person person = (Person) ioc.getBean("person");
        System.out.println(person);
    }
```

###  结果：

```
Person{name='saber', age=18}
```

------

##  二、使用配置类加入组件：

###  1.通过实现TypeFilter接口自定义组件扫描过滤条件

```java
/**
 * 自定义组件扫描过滤规则
 * @author cxy
 */
public class CustomFilter implements TypeFilter {

    /**
     *
     * @param metadataReader 当前扫描到的类的信息
     * @param metadataReaderFactory 其它类的信息
     * @return
     * @throws IOException
     */
    @Override
    public boolean match(MetadataReader metadataReader,
                         MetadataReaderFactory metadataReaderFactory)
            throws IOException {
        //获取当前扫描的类的注解信息
        AnnotationMetadata annotationmetadata = metadataReader.getAnnotationMetadata();
        //获取当前扫描到的类的类信息
        ClassMetadata classMetadata = metadataReader.getClassMetadata();
        //获取当前正在扫描类类路径信息
        Resource resource = metadataReader.getResource();
         //如果类名包含er就加入扫描规则
        String type = "er";
        if (classMetadata.getClassName().contains(type)){
            return true;
        }
        return false;
    }
}
```

###  2.自定义配置类可以指定要扫描的包和扫描过滤条件

@Configuration：表明该类是一个配置类

@ComponentScan：指定扫描规则

```java
/**
 * 配置类
 * @author cxy
 * @ComponentScan：  
 *				   value：批量加入要装配的组件所在的包
 *                  excludeFilters： 排除规则
 *                  includeFilter：  只包含那些组件,前提是禁用默认过滤规则useDefaultFilters = false
 *				   useDefaultFilters：是否使用默认过滤策略 
 *                  排除规则的取值： 	
 *  				   FilterType.ANNOTATION：以注解类型作为规则
 *                  	FilterType.ASSIGNABLE_TYPE: 以指定类的类型作为规则（包含它的子类）
 *                  	FilterType.CUSTOM: 自定义规则
 */
@Configuration
//@ComponentScan(value = "org.example",excludeFilters = {
//                                               //以注解排除            要排除的注解类
//        @ComponentScan.Filter(type = FilterType.ANNOTATION,classes = {Service.class,Repository.class})
//})

//@ComponentScan(value = "org.example",includeFilters = {
//                                               //以注解包含            要包含的注解类
//        @ComponentScan.Filter(type = FilterType.ANNOTATION,classes = {Service.class,Repository.class})
//        //禁用默认过滤规则
//},useDefaultFilters = false)
@ComponentScan(value = "org.example",includeFilters = {
        @ComponentScan.Filter(type = FilterType.CUSTOM,classes = CustomFilter.class)},useDefaultFilters = false)
public class MainConfig {

    /**
     * @Bean 指定组件的名称 默认为方法名
     * @return 返回值就是要注册组件的类型
     */
    @Bean(value = "person")
    public Person person01(){
        return new Person("saber",18);
    }
}
```

###  3.测试

```java
    @Test
    void test01(){
        ApplicationContext ioc =
            				//指定自定义的配置类
                new AnnotationConfigApplicationContext(MainConfig.class);
        String[] names = ioc.getBeanDefinitionNames();
        for (String name : names) {
            System.out.println(name);
        }
    }
```

###  结果：

```
org.springframework.context.annotation.internalConfigurationAnnotationProcessor
org.springframework.context.annotation.internalAutowiredAnnotationProcessor
org.springframework.context.annotation.internalCommonAnnotationProcessor
org.springframework.context.event.internalEventListenerProcessor
org.springframework.context.event.internalEventListenerFactory
mainConfig
person
bookController
customFilter
bookService
```

------

##  *@Scope指定组件的作用域

```java
@Configuration
public class MainConfig2 {

    /**
     * @Scope( value: 指定实例的范围 )
     *          prototype 多实例 ioc启动时不会创建对象 每次获取对象就创建一个对象（懒汉模式 延迟加载
     *          singleton 单实例 默认值 ioc启动时就创建一个对象 以后每次都返回这个对象（饿汉模式
     *        需要web环境：
     *          request 单次请求
     *          session 一次会话
     * @return
     */
    @Scope(value = "prototype")
    @Bean("person")
    public Person person(){
        return new Person("caster",19);
    }
```

###  测试

```java
@Test
void test02(){
    ApplicationContext ioc =
            new AnnotationConfigApplicationContext(MainConfig2.class);
    Person person1 = ioc.getBean("person", Person.class);
    Person person2 = ioc.getBean("person", Person.class);
    System.out.println(person1 == person2);
}
```

###  结果：

```
false
```

------

##  *@Conditional 按指定条件添加组件

```java
/**
 * @author cxy
 */
@Configuration
public class MainConfig2 {
    @Bean("person")
    public Person person(){
        return new Person("caster",19);
    }

    /**
     * 如果是windows系统注册bell
     *   @Conditional 指定条件加入容器 需要自定义条件
     * @return
     */
    @Bean(value = "bell")
    @Conditional(WindowsCondition.class)
    public Person perso01(){
        return new Person("bell",48);
    }

    /**
     * 如果是Linux注册linux
     * @return
     */
    @Bean(value = "linux")
    @Conditional(LinuxCondition.class)
    public Person perso02(){
        return new Person("linux",48);
    }
}
```

###  通过实现Condition接口自定义过滤条件

```java
/**
 * @author cxy
 * WINDOWS
 */
public class WindowsCondition implements Condition {

    /**
     * @param context 判断条件能使用的上下文  (ioc
     * @param metadata 标注了Conditional的注解信息
     * @return true:加入容器 false：忽略
     */
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        String NAME = "Windows";
        //获取当前的运行环境信息
        Environment environment = context.getEnvironment();
        //获取操作系统名
        String name = environment.getProperty("os.name");
        if (name.contains(NAME)){
            return true;
        }
        return false;
    }
}
```

```java
/**
 * @author cxy
 * LINUX
 */
public class LinuxCondition  implements Condition {

    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        String NAME = "Linux";
        Environment environment = context.getEnvironment();
        String name = environment.getProperty("os.name");
        if (NAME.equals(name)){
            return true;
        }
        return false;
    }
}
```

###  测试（环境为Windows10）

```java
@Test
void test03(){
    ApplicationContext ioc =
            new AnnotationConfigApplicationContext(MainConfig2.class);
    String[] names = ioc.getBeanNamesForType(Person.class);
    for (String name : names) {
        System.out.println(name);
    }
}
```

###  结果：

```
person
bell 
```

------

##  *@Import注解：

####  我们先来回顾注册组件的几种常见方式：

1. #####  包扫描(@ComponentScan)+组件注解（@Controller/@Service....) 一般用于加载我们自定义的类

2. #####  @Bean 导入第三方的包里的组件

3. #####  @Import 快速的给容器导入一个组件

   1. @Import(要导入的组件) 组件名为组件的全路径类名
   2. @Import(自定义的ImportSelecttor)
   3. @Import(自定义的registerBeanDefinitions)

4. #####  使用FactoryBean的getObject()方法

   

###  第一种方式

###  1.要加入的组件：

```java
public class Color {}

public class Price{}
```

###  2.配置类：

```java
/**
 * @author cxy
 *  使用@Import加载组件
 */
@Configuration
@Import({Color.class, Price.class})
public class MainConfig3 {
}
```

###  3.测试

```java
@Test
void test04(){
    ApplicationContext ioc =
            new AnnotationConfigApplicationContext(MainConfig3.class);
    String[] names = ioc.getBeanDefinitionNames();
    for (String name : names) {
        System.out.println(name);
    }
}
```

###  4.结果：

```java
org.springframework.context.annotation.internalConfigurationAnnotationProcessor
org.springframework.context.annotation.internalAutowiredAnnotationProcessor
org.springframework.context.annotation.internalCommonAnnotationProcessor
org.springframework.context.event.internalEventListenerProcessor
org.springframework.context.event.internalEventListenerFactory //ioc自己的组件
mainConfig3 
org.example.bean.Color  //Import导入的组件
org.example.bean.Price

```

###  第二种方式：

###  1.要加入的组件：

```java
public class Color {}

public class Price{}
```

###  2.配置类：

```java
/**
 * @author cxy
 * 使用ImportSelector导入组件
 */
@Configuration
@Import(MyImportSelector.class)
public class MainConfig4 {
}
```

###  3.自定义ImportSelector

```java
/**
 * @author cxy
 * 自定义@Import的选择器
 */
public class MyImportSelector implements ImportSelector {
    /**
     * @param importingClassMetadata 当前标注@Import注解的类的所有注解信息
     * @return 要导入组件的全类名
     */
    @Override
    public String[] selectImports(AnnotationMetadata importingClassMetadata) {
        //返回一个要导入类的字符串数组
        return new String[]{"org.example.bean.Price","org.example.bean.Color",};
    }
}
```

###  4.测试

```java
@Test
void test05(){
    ApplicationContext ioc =
            new AnnotationConfigApplicationContext(MainConfig4.class);
    String[] names = ioc.getBeanDefinitionNames();
    for (String name : names) {
        System.out.println(name);
    }
}
```

###  结果：

```
org.springframework.context.annotation.internalConfigurationAnnotationProcessor
org.springframework.context.annotation.internalAutowiredAnnotationProcessor
org.springframework.context.annotation.internalCommonAnnotationProcessor
org.springframework.context.event.internalEventListenerProcessor
org.springframework.context.event.internalEventListenerFactory
mainConfig4
org.example.bean.Price
org.example.bean.Color
```

###  第三种方式 在Color导入后导入Type

###  1.要导入的组件

```
public class Color {}

public class Type {}
```

###  2.配置类

```java
/**
 * @author cxy
 * 使用Import(registerBeanDefinitions)注册组件
 */
@Configuration
@Import({Color.class,MyImportBeanDefinitionRegistrar.class})
public class MainConfig5 {
}
```

###  3.自定义ImportBeanDefinitionRegistrar

```java
public class MyImportBeanDefinitionRegistrar implements ImportBeanDefinitionRegistrar {

    /**
     *把所有需要添加到容器的组件注册进去
     * @param metadata： 当前类的注解信息
     * @param registry： BeanDefinition 注册类
     */
    @Override
    public void registerBeanDefinitions(AnnotationMetadata metadata,
                                        BeanDefinitionRegistry registry){
        //判断注册类中是否包含Color
       if( registry.containsBeanDefinition("org.example.bean.Color")){
           //定义要添加的组件信息(类名，作用域...)
           RootBeanDefinition definition = new RootBeanDefinition(Type.class);
           //使用自定义组件名和组件定义完成注册
           registry.registerBeanDefinition("type",definition);
       }
    }
}
```

###  4.测试类

```java
@Test
void test06(){
    ApplicationContext ioc =
            new AnnotationConfigApplicationContext(MainConfig5.class);
    String[] names = ioc.getBeanDefinitionNames();
    for (String name : names) {
        System.out.println(name);
    }
}
```

###  结果：

```java
org.springframework.context.annotation.internalConfigurationAnnotationProcessor
org.springframework.context.annotation.internalAutowiredAnnotationProcessor
org.springframework.context.annotation.internalCommonAnnotationProcessor
org.springframework.context.event.internalEventListenerProcessor
org.springframework.context.event.internalEventListenerFactory
mainConfig5
org.example.bean.Color 
type  //type跟随Color的加载而加载
```

###  第四种方式：

###  1.要注册的组件

```java
public class Color {}
```

###  2.自定义FactoryBean

```java
/**
 * @author cxy
 * 使用spring定义的工厂Bean导入组件
 */
public class ColorFactoryBean implements FactoryBean<Color> {

    /**
     * 返回一个对象 该对象会被加载到容器中
     * @return 要加入容器的对象
     * @throws Exception
     */
    @Override
    public Color getObject() throws Exception {
        //实际注册的是此处返回的类
        return new Color();
    }

    /**
     * @return 对象的类型
     */
    @Override
    public Class<?> getObjectType() {
        return Color.class;
    }

    /**
     * 指定添加组件的作用域
     * @return true为单例 false为多实例
     */
    @Override
    public boolean isSingleton() {
        return true;
    }
}
```

###  3.配置类

```java
/**
 * @author cxy
 * FactoryBean注册组件
 */
@Configuration
public class MainConfig6 {

    @Bean
    public ColorFactoryBean colorFactoryBean(){
        return new ColorFactoryBean();
    }
}
```

###  4.测试

```java
@Test
void test07(){
    ApplicationContext ioc =
            new AnnotationConfigApplicationContext(MainConfig6.class);
    String[] names = ioc.getBeanDefinitionNames();
    for (String name : names) {
        System.out.println(name);
    }

    Object colorFactoryBean1 = ioc.getBean("colorFactoryBean");
    System.out.println("实际注册的bean "+colorFactoryBean1.getClass());
    Object colorFactoryBean2 = ioc.getBean("colorFactoryBean");
    System.out.println(colorFactoryBean1 == colorFactoryBean2);
    //组件名前添加&符能获取到工厂类本身 否则返回的是实际注册的类
    System.out.println("获取工厂本身： "+ioc.getBean("&colorFactoryBean").getClass());
}
```

###  结果：

```java
org.springframework.context.annotation.internalConfigurationAnnotationProcessor
org.springframework.context.annotation.internalAutowiredAnnotationProcessor
org.springframework.context.annotation.internalCommonAnnotationProcessor
org.springframework.context.event.internalEventListenerProcessor
org.springframework.context.event.internalEventListenerFactory
mainConfig6
colorFactoryBean  //注册成功
实际注册的bean： class org.example.bean.Color
true  //isSingleton()返回true，两次获取的对象是同一对象
获取工厂本身： class org.example.bean.ColorFactoryBean
```

------

##  生命周期:bean从初始化到销毁的过程

###  指定初始化和销毁方法的方式

####  	1.通过@Bean(initMethod = "init",destroyMethod = "destroy")

####      2. 通过实现InitializingBean , DisposableBean接口

####  	3. 使用JSR250 （回调通知）

####  4. bean的后置处理器 BeanPostProcessor 在bean初始化前后进行处理工作 BeanPostProcessor 大量的用于spring底层 如：自动注入，数据校验 ，生命周期注册。。。

​		

###  第一种方式

1. ####  定义要注册的bean

   ```java
   /**
    * 用于测试bean生命周期
    * @author cxy
    */
   public class Car {
       public Car() {
           System.out.println("Car Constructor ...");
       }
   
       /**
        * 初始化方法
        */
       public void init(){
           System.out.println("Car init ...");
       }
   
       /**
        * 销毁方法
        */
       public void destroy(){
           System.out.println("Car destroy ...");
       }
   }
   ```

2. ####  配置类

   ```
   /**
    * 自定义bean的初始化和销毁方法
    * @author cxy
    * bean的生命周期
    *      创建 -> 初始化 -> 销毁
    */
   @Configuration
   public class MainConfigOfLifeCycle {
   
       @Bean(initMethod = "init",destroyMethod = "destroy")
       public Car car(){
           return new Car();
       }
   }
   ```

3. ####  测试类

   ```java
   @Test
   void test01(){
       AnnotationConfigApplicationContext ioc =
               new AnnotationConfigApplicationContext(MainConfigOfLifeCycle.class);
       System.out.println("容器创建成功...");
       Car car = ioc.getBean("car", Car.class);
       ioc.close();
   }
   ```

4. ####  结果：

   ```java
   Car Constructor ...
   Car init ...
   容器创建成功...
   Car destroy ...
   ```

###  第二种方式

1. ####  定义要注册的bean

   ```java
   /**
    * 测试生命周期
    * @author cxy
    */
   public class AirCondition  implements InitializingBean , DisposableBean {
   
       public AirCondition() {
           System.out.println("AirCondition Constructor ...");
       }
   
       /**
        * 销毁时执行该方法
        * @throws Exception
        */
       @Override
       public void destroy() throws Exception {
           System.out.println("AirCondition destroy ...");
       }
   
       /**
        * 在组件属性装载完之后调用该方法 相当于init方法
        * @throws Exception
        */
       @Override
       public void afterPropertiesSet() throws Exception {
           System.out.println("AirCondition afterPropertiesSet ...");
       }
   }
   ```

2. ####  配置类

   ```java
   @Configuration
   public class MainConfigOfLifeCycle2 {
   
       @Bean()
       public AirCondition airCondition(){
           return new AirCondition();
       }
   }
   ```

3. ####  测试类

   ```java
   @Test
   void test02(){
       AnnotationConfigApplicationContext ioc =
               new AnnotationConfigApplicationContext(MainConfigOfLifeCycle2.class);
       System.out.println("容器创建成功...");
       AirCondition airCondition = ioc.getBean("airCondition", AirCondition.class);
       ioc.close();
   }
   ```

4. ####  结果：

   ```java
   AirCondition Constructor ...
   AirCondition afterPropertiesSet ...
   容器创建成功...
   AirCondition destroy ...
   ```

###  第三种方式

1. ####  定义要注册的组件

   ```java
   /**
    * 使用JSR250 测试bean生命周期
    * @author cxy
    */
   public class Kettle {
   
       public Kettle() {
           System.out.println("Kettle Constructor ...");
       }
   
       /**
        * 对象创建并赋值之后执行该方法
        */
       @PostConstruct
       public void init(){
           System.out.println("Kettle PostConstruct ...");
       }
   
   
       /**
        *在容器移除对象之前调用该方法
        */
       @PreDestroy
       public void destroy(){
           System.out.println("Kettle PreDestroy ...");
       }
   }
   ```

2. ####  配置类

   ```java
   @Configuration
   public class MainConfigOfLifeCycle3 {
   
       @Bean
       public Kettle kettle(){
           return new Kettle();
       }
   }
   ```

3. ####  测试类

   ```java
   @Test
   void test03(){
       AnnotationConfigApplicationContext ioc =
               new AnnotationConfigApplicationContext(MainConfigOfLifeCycle3.class);
       System.out.println("容器创建成功...");
       Kettle kettle = ioc.getBean("kettle", Kettle.class);
       ioc.close();
   }
   ```

   ####  结果：

   ```
   Kettle Constructor ...
   Kettle PostConstruct ...
   容器创建成功...
   Kettle PreDestroy ...
   ```

###  第四种方式

1. ####  要注册的类

   ```java
   @Component
   public class Mobile {
       public Mobile() {
           System.out.println("Mobile Constructor..");
       }
   }
   ```

2. ####  bean后置处理器

   ```java
   /**
    * bean后置处理器 测试生命周期
    * @Component 加入容器
    * @author cxy
    */
   @Component
   public class MyBeanPostProcessor implements BeanPostProcessor {
       @Override
       public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
           System.out.println("postProcessAfterInitialization ..."+beanName+"==>"+bean);
           return bean;
       }
   
       /**
        * @param bean 刚才创建的实例
        * @param beanName 实例的名称
        * @return 原来的实例（也可以进行包装
        * @throws BeansException
        */
       @Override
       public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
           System.out.println("postProcessBeforeInitialization ..."+beanName+"==>"+bean);
           return bean;
       }
   }
   ```

3. ####  配置类

   ```java
   @Configuration
   @ComponentScan("org.example.beanpostprocessor")
   public class MainConfigOfLifeCycle4 {
   }
   ```

4. ####  测试类

   ```java
   @Test
   void test04(){
       AnnotationConfigApplicationContext ioc =
               new AnnotationConfigApplicationContext(MainConfigOfLifeCycle4.class);
       System.out.println("容器创建成功...");
       String[] names = ioc.getBeanDefinitionNames();
       for (String name : names) {
           System.out.println(name);
       }
       ioc.close();
   }
   ```

5. ####  结果：

   ```java
   postProcessBeforeInitialization ...mainConfigOfLifeCycle4==>org.example.lifecycle.MainConfigOfLifeCycle4$$EnhancerBySpringCGLIB$$a404839e@3c73951
   postProcessAfterInitialization ...mainConfigOfLifeCycle4==>org.example.lifecycle.MainConfigOfLifeCycle4$$EnhancerBySpringCGLIB$$a404839e@3c73951
   Mobile Constructor..  //这里实例加载的时机和init方式有关 不同的方式 处理器接入的时机不同
   postProcessBeforeInitialization ...mobile==>org.example.beanpostprocessor.Mobile@3d5c822d
   postProcessAfterInitialization ...mobile==>org.example.beanpostprocessor.Mobile@3d5c822d
   容器创建成功...
   org.springframework.context.annotation.internalConfigurationAnnotationProcessor
   org.springframework.context.annotation.internalAutowiredAnnotationProcessor
   org.springframework.context.annotation.internalCommonAnnotationProcessor
   org.springframework.context.event.internalEventListenerProcessor
   org.springframework.context.event.internalEventListenerFactory
   mainConfigOfLifeCycle4
   mobile
   myBeanPostProcessor
   ```
------

###  @Value注入属性值   @PropertySource导入配置文件

1. ####     要注册的组件

   ```java
   /**
    * 测试@value
    * @author cxy
    * @value的取值 :1、基本类型
    *              2、spEl(spring表达式 # {})
    *              3、${} 取出配置文件中的值
    */
   public class Player {
       @Value("saber")
       private String name;
       @Value("# {20-2}")
       private Integer id;
       @Value("${saber}")
       private  String nickName;
   	//省略构造方法 getter/setter toString
   }
   ```

2. ####  配置文件

   ```java
   /**
    * @Value 注解测试配置文件
    * @author cxy
    * @PropertySource 加载配置文件
    * @Import 加载的组件Bean名称为组件的全路径类名
    */
   @Configuration
   @Import(Player.class)
   @PropertySource("classpath:player.properties")
   public class MainConfigOfValuePropertiesTest {
   }
   ```

3. ####  测试类

   ```java
   @Test
   void valueAnnotationTest(){
       ApplicationContext ioc =
               new AnnotationConfigApplicationContext(MainConfigOfValuePropertiesTest.class);
       Player player = ioc.getBean("org.example.bean.Player", Player.class);
       System.out.println(player);
   }
   ```

4. ####  结果：

   ```java
   Player{name='saber', id=18, nickName='"lion"'} //成功注入
   ```

------

###  自动注入(DI)：

###  @Autowired  (Spring规范) **推荐使用此注解**

1. ####  默认按照类型去容器找对应的组件

2. ####  如果找到多个相同的组件再使用属性的名称去匹配

3. ####  @Qualifier 可以指定需要装配的组件id 

4. ####  @Autowired 默认必须完成装配 如果匹配不上会报错

5. ####  @Autowired(required = false)  不需完成装配 能通过编译

6. ####  @Primary 首选装配 比@Qualifie的优先级低

###  @Resource(JSR250)、@Inject(JSR330) (java规范,Spring也支持) 

1. ####  @Resource：和@Autowired一样实现自动装配，默认是按照组件名称进行装配的，不支持@Primary 首选装配 不支持required = false

2. ####  @Inject：需要导入javax.inject包，和@Autowired一样实现自动装配，**支持@Primary 首选装配** 不支持required = false

###  @Autowired标注的位置：（都是从容器中获取参数组件的值完成自动注入）

- ####  成员属性位置

- ####  方法位置：使用@Bean的方式 在方法参数位置上@Autowired默认不写

- ####  构造器位置：如果组件只有一个有参构造@Autowired可以省略

- ####  参数位置

####  自动装配：

####  	使用AutowiredAnnotationBeanPostProcessor解析完成自动装配

```java
org.springframework.beans.factory.annotation
Class AutowiredAnnotationBeanPostProcessor
java.lang.Object 
org.springframework.beans.factory.config.InstantiationAwareBeanPostProcessorAdapter
org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor

 
public class AutowiredAnnotationBeanPostProcessor
extends InstantiationAwareBeanPostProcessorAdapter
implements MergedBeanDefinitionPostProcessor, org.springframework.core.PriorityOrdered, BeanFactoryAware
BeanPostProcessor implementation that autowires annotated fields, setter methods, and arbitrary config methods. Such members to be injected are detected through annotations: by default, Spring's @Autowired and @Value annotations.
Also supports JSR-330's @Inject annotation, if available, as a direct alternative to Spring's own @Autowired.
Autowired Constructors
Only one constructor of any given bean class may declare this annotation with the 'required' attribute set to true, indicating the constructor to autowire when used as a Spring bean. Furthermore, if the 'required' attribute is set to true, only a single constructor may be annotated with @Autowired. If multiple non-required constructors declare the annotation, they will be considered as candidates for autowiring. The constructor with the greatest number of dependencies that can be satisfied by matching beans in the Spring container will be chosen. If none of the candidates can be satisfied, then a primary/default constructor (if present) will be used. If a class only declares a single constructor to begin with, it will always be used, even if not annotated. An annotated constructor does not have to be public.
Autowired Fields
Fields are injected right after construction of a bean, before any config methods are invoked. Such a config field does not have to be public.
Autowired Methods
Config methods may have an arbitrary name and any number of arguments; each of those arguments will be autowired with a matching bean in the Spring container. Bean property setter methods are effectively just a special case of such a general config method. Config methods do not have to be public.
Annotation Config vs. XML Config
A default AutowiredAnnotationBeanPostProcessor will be registered by the "context:annotation-config" and "context:component-scan" XML tags. Remove or turn off the default annotation configuration there if you intend to specify a custom AutowiredAnnotationBeanPostProcessor bean definition.
NOTE: Annotation injection will be performed before XML injection; thus the latter configuration will override the former for properties wired through both approaches.
@Lookup Methods
In addition to regular injection points as discussed above, this post-processor also handles Spring's @Lookup annotation which identifies lookup methods to be replaced by the container at runtime. This is essentially a type-safe version of getBean(Class, args) and getBean(String, args). See @Lookup's javadoc for details.
Since:
2.5
Author:
Juergen Hoeller, Mark Fisher, Stephane Nicoll, Sebastien Deleuze, Sam Brannen
See Also:
setAutowiredAnnotationType(java.lang.Class<? extends java.lang.annotation.Annotation>), Autowired, Value
All Implemented Interfaces:
Aware, BeanFactoryAware, BeanPostProcessor, InstantiationAwareBeanPostProcessor, SmartInstantiationAwareBeanPostProcessor, MergedBeanDefinitionPostProcessor, org.springframework.core.Ordered, org.springframework.core.PriorityOrdered
```

###  Aware接口：

- ####  自定义组件想要使用Spring容器底层的一些组件（ApplicationContext、BeanFactory...)需要实现xxxAware，在对象创建时会调用接口规定的方法注入相关组件，底层是使用xxxAwareProcessors实现

  1. ####  需要注册的组件

     ```java
     /**
      * 用于测试Aware
      * @author cxy
      */
     @Component
     public class Computer implements ApplicationContextAware, BeanNameAware, EmbeddedValueResolverAware {
     	//储存下来方便使用
         ApplicationContext applicationContext;
     
         /**
          * @param name 当前Bean的名称
          */
         @Override
         public void setBeanName(String name) {
             System.out.println("当前Bean的名称：" + name);
         }
     
         /**
          * @param applicationContext 获取到的ioc对象
          * @throws BeansException
          */
         @Override
         public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
             this.applicationContext = applicationContext;
             System.out.println("传入的ioc:" + applicationContext);
         }
     
         /**
          * @param resolver 解析器
          *                 可以用于解析spEL ${}
          */
         @Override
         public void setEmbeddedValueResolver(StringValueResolver resolver) {
             String stringValue = resolver.resolveStringValue("Hello ${os.name},I'm # {1+1}");
             System.out.println(stringValue);
         }
     }
     ```

  2. ####  配置类

     ```java
     /**
      * Aware 测试配置类
      * @author cxy
      */
     @Configuration
     @ComponentScan("org.example.bean")
     public class MainConfigOfAwareTest {
     }
     ```

  3. ####  测试类

     ```java
     @Test
     void test01(){
         AnnotationConfigApplicationContext ioc = new AnnotationConfigApplicationContext(MainConfigOfAwareTest.class);
         Computer bean = ioc.getBean(Computer.class);
     }
     ```

  4. ####  结果：

     ```java
     当前Bean的名称：computer
     Hello Windows 10,I'm 2
     传入的ioc:org.springframework.context.annotation.AnnotationConfigApplicationContext@453da22c, started on Thu May 21 08:59:28 CST 2020
     ```

     ------

     ###  @Profile指定环境   默认为default

     1. ####  需要加载的组件

        ```java
        public class Color {}
        ```

     2. ####  配置类

        ```java
        /**
         * 测试@Profile
         * @author cxy
         */
        public class MainConfigOfProfileTest {
        
            @Bean
            @Profile("test")
            public Color colorTest(){
                System.out.println("test...");
                return new Color();
            }
        
            @Bean
            @Profile("dev")
            public Color colorDev(){
                System.out.println("dev...");
                return new Color();
            }
            @Bean
            @Profile("prod")
            public Color colorProd(){
                System.out.println("prod...");
                return new Color();
            }
        }
        ```

     3. ####  测试类·

        ```
          /**
             * 也可以用虚拟机参数设置环境
             *  -Dspring.profiles.active=test
             */
            @Test
            void testProfile(){
                //获取容器
                AnnotationConfigApplicationContext ioc = new AnnotationConfigApplicationContext();
                //设置运行环境
                ioc.getEnvironment().setActiveProfiles("test");
                //注册主配置类
                ioc.register(MainConfigOfProfileTest.class);
                //启动刷新容器
                ioc.refresh();
            }
        ```

     4. ####  结果：

        ```
        test...
        ```

        