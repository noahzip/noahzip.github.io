---
layout: posts
title: JSR303结合AdviceController开启全局数据校验
date: 2020-08-14 09:45:00
updated: 2020-08-14 11:59:45
tags: 
categories: 
 - 总结
---
###  业务场景：

- #####  项目本身需要感知处理各种异常

- #####  前端传递的数据都需要校验其合法性

- #####  如果在每一个controller上编写异常处理与数据校验就会显得很臃肿

  

###  解决方案：

- 使用JSR303在controller标注数据校验注解，向上抛出异常

- 使用AdviceController全局异常感知完成数据校验与异常处理

  

###  分组校验的业务场景：

- #####  执行添加操作由于ID递增，所以数据对象不需要id字段

- #####  执行更新操作由ID确定更新数据，所以必须携带id字段

------

###  实现流程：

####  1.导入依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

####  2.编写JSR303分组标记接口

```java
/**
 * @author: saber
 * @description: 添加操作 数据校验的分组标记
 */
public interface AddGroup {
}

/**
 * @author: saber
 * @description: 修改操作 数据校验的分组标记
 */
public interface UpdateGroup {
}
```



####  3.bean标注注解

```java
 public class BrandEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	/**
	 * messag制定错误信息
	 * groups指定分组标记接口集合 未指定分组的规则在分组校验的情况下不生效
	 */
	@Null(message = "新增操作品牌id必须为空",groups = {AddGroup.class})
	@NotNull(message = "修改操作品牌id不能为空",groups = {UpdateGroup.class})
	@TableId
	private Long brandId;
	
	@NotBlank(message = "品牌名不能为空",groups = {UpdateGroup.class,AddGroup.class})
	private String name;
 }
```

####  4.Controller标注注解开启验证

```java
@RestController
public class UserController{
    
 	/**此处不能带上BindingResult 否则异常不能被AdviceController感知
 	 *
     * @param brand  bean
     * Validated()指定当前使用的分组 
     * @return
     */
    @RequestMapping("/save")
    public R save(@Validated(AddGroup.class) @RequestBody BrandEntity brand){
           brandService.save(brand);
           return R.ok();
    }
    
    @RequestMapping("/update")
    public R update(@Validated(UpdateGroup.class) @RequestBody BrandEntity brand){
            brandService.updateById(brand);
            return R.ok();
    }
    
}
```

####  5.统一响应枚举类

```java
public enum BizCodeEnum {
    UNKNOWN_EXCEPTION(10000,"系统未知异常"),
    VALID_EXCEPTION(10001,"参数格式校验失败");
    
    private Integer code;
    private String msg;


    BizCodeEnum(Integer code,String msg){
        this.code = code;
        this.msg = msg;
    }

    public Integer getCode() {
        return code;
    }

    public String getMsg() {
        return msg;
    }
}

```



####  6.编写统一异常处理类

```java
@RestControllerAdvice(basePackages = "com.saber.mall.product.controller")
public class ExceptionControllerAdvice {

    /**
     *处理数据校验异常
     * @param e
     */
    @ExceptionHandler(value = MethodArgumentNotValidException.class)
    public R handleValidException(MethodArgumentNotValidException e){
        Map<String,String> map = new HashMap<>();
        //获取BindingResult对象
        BindingResult result = e.getBindingResult();
        result.getFieldErrors().forEach((item)->map.put(item.getField(),item.getDefaultMessage()));
        return R.error(BizCodeEnum.VALID_EXCEPTION.getCode(),BizCodeEnum.VALID_EXCEPTION.getMsg()).put("data",map);
    }
}
```



####  7.测试结果

```json
# 新增请求携带id：
{
    "brandId":1,
    "showStatus":1,
    "name": ""
}
# 结果:{
    "msg": "参数格式校验失败",
    "code": 10001,
    "data": {
        "brandId": "新增操作品牌id不能为空",
        "name": "品牌名不能为空"
    }
}

# 修改请求不携带id：
{
    "showStatus":1,
    "name": "xiaomi"
}
# 结果：
{
    "msg": "参数格式校验失败",
    "code": 10001,
    "data": {
        "brandId": "修改操作品牌id不能为空"
    }
}
```

------

####  对于某些特殊字段,自带的校验注解无法支持。

###  这时候需要我们自己实现：

####  1.导入依赖

```xml
<!-- 校验注解 -->
<dependency>
    <groupId>javax.validation</groupId>
    <artifactId>validation-api</artifactId>
    <version>1.1.0.Final</version>
</dependency>
```

####  2.编写注解类

```java
/**
 * @author: saber
 * @description: 自定义校验注解
 */
@Documented
//这里需要指定校验器
@Constraint(validatedBy = {ListValueConstraintValidator.class})
@Target({ElementType.METHOD, ElementType.FIELD, ElementType.ANNOTATION_TYPE, ElementType.CONSTRUCTOR, ElementType.PARAMETER, ElementType.TYPE_USE})
@Retention(RetentionPolicy.RUNTIME)
public @interface ListValue {
    String message() default "{javax.validation.constraints.NotBlank.message}";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    int[] values() default {};
}

```

####  3.编写校验器

```java
/**
 * @author: saber
 * @description:校验器
 */
public class ListValueConstraintValidator implements ConstraintValidator<ListValue,Integer> {
	//保存注解上指定的值
    private Set<Integer> set = new HashSet<>();

    /**
     * 初始化方法 可以拿到注解标注的值 @ListValue(values = {1,2})
     * @param listValue
     */
    @Override
    public void initialize(ListValue listValue) {
        int[] values = listValue.values();
        if (values==null || values.length>0){
            throw new NullPointerException();
        }
        for (int value : values) {
            set.add(value);
        }
    }

    /**
     * 校验操作
     * @param integer 需要校验的值
     * @param constraintValidatorContext
     * @return
     */
    @Override
    public boolean isValid(Integer integer, ConstraintValidatorContext constraintValidatorContext) {
        return set.contains(integer);
    }
}

```

####  4.实体类标注注解

```java
public class BrandEntity implements Serializable {
	...
	@ListValue(values = {0,1},groups = {AddGroup.class,UpdateGroup.class},message = "只能为0或1")
	private Integer sort;
}	
```

####  5.测试

```json
{
    "brandId":1,
    "showStatus":2,
    "name": ""
}
# 结果：
{
    "msg": "参数格式校验失败",
    "code": 10001,
    "data": {
        "sort": "只能为0或1"
    }
}
```

