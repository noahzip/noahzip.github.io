---
layout: posts
title: mybatis配置
date: 2020-09-07 15:37:00
updated: 2020-09-07 15:55:44
tags: 
categories: 
 - 总结
---
####  配置类：

```java
import com.baomidou.mybatisplus.core.injector.ISqlInjector;
import com.baomidou.mybatisplus.extension.injector.LogicSqlInjector;
import com.baomidou.mybatisplus.extension.plugins.PaginationInterceptor;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * mybatis配置
 * @author saber
 */
@Configuration
@MapperScan("com.zjm.eduservice.mapper")
public class EduConfig {
    /**
     * 逻辑删除插件 需要配合逻辑删除注解
     *@ApiModelProperty(value = "逻辑删除 1（true）已删除， 0（false）未删除")
     *@TableLogic
     *private Integer isDeleted;
     */
    @Bean
    public ISqlInjector sqlInjector() {
        return new LogicSqlInjector();
    }

    /**
     * 分页插件
     */
    @Bean
    public PaginationInterceptor paginationInterceptor() {
        return new PaginationInterceptor();
    }
    
    /**
     *插入更新时间在数据库配置
     CREATE TABLE `tbl_hive_hour` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `tb_name` varchar(255) DEFAULT NULL COMMENT '被执行表名',
      `sale_time` varchar(255) DEFAULT NULL COMMENT '执行的为哪一天的数据,格式为yyyyMMddhh',
      `partition_string` varchar(255) DEFAULT NULL COMMENT '分区值，存储格式为year=2018,month=12,day=05,hour=08',
      `run_status` int(11) NOT NULL COMMENT '执行状态，0未执行，1执行成功且大于0条，2执行结果为0',
      `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
      `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次修改时间',
      PRIMARY KEY (`id`)
    )
     */
    
    /**
     * SQL执行效率插件 性能分析插件
     */
    @Bean
    @Profile({"dev","test"})// 设置 dev test 环境开启
    public PerformanceInterceptor performanceInterceptor() {
        PerformanceInterceptor performanceInterceptor =  new PerformanceInterceptor();
        //格式化语句
        performanceInterceptor.setFormat(true);
        //执行时间超过多少秒会抛出异常
        //performanceInterceptor.setMaxTime(5);
        return  performanceInterceptor;

}

```



####  自动填充字段：

```java
import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.stereotype.Component;

import java.util.Date;

/**
 * mp自动填充
 * @author saber
 */
@Component
public class MyMetaObjectHandler implements MetaObjectHandler {
    @Override
    public void insertFill(MetaObject metaObject) {
        //类中的属性名称 非数据库字段
        this.setFieldValByName("gmtCreate", new Date(), metaObject);
        this.setFieldValByName("gmtModified", new Date(), metaObject);
    }

    @Override
    public void updateFill(MetaObject metaObject) {
        this.setFieldValByName("gmtModified", new Date(), metaObject);
    }
}

```



####  实体类：

```Java
/**
 * 实体类
 * @author saber
 * @time 2020-03-29
 */

@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value="EduTeacher对象", description="讲师")
public class EduTeacher implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "讲师ID")
    @TableId(value = "id", type = IdType.ID_WORKER_STR)
    private String id;

    @ApiModelProperty(value = "讲师姓名")
    private String name;

    @ApiModelProperty(value = "讲师简介")
    private String intro;

    @ApiModelProperty(value = "讲师资历,一句话说明讲师")
    private String career;

    @ApiModelProperty(value = "头衔 1高级讲师 2首席讲师")
    private Integer level;

    @ApiModelProperty(value = "讲师头像")
    private String avatar;

    @ApiModelProperty(value = "排序")
    private Integer sort;

    @ApiModelProperty(value = "逻辑删除 1（true）已删除， 0（false）未删除")
    @TableLogic
    private Integer isDeleted;

    @ApiModelProperty(value = "创建时间")
    @TableField(fill = FieldFill.INSERT)
    private Date gmtCreate;

    @ApiModelProperty(value = "更新时间")
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date gmtModified;

```



```
	33003
		33004
			33007
38005
```

