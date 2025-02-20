---
layout: posts
title: EasyExcel操作Excel
categories:
  - 总结
abbrlink: 57467
date: 2020-09-08 16:52:38
updated: 2020-09-08 16:52:38
tags:
---
####  1.引入依赖

```xml
<!-- 本质是对POI的封装所以需要POI的依赖导入 注意版本匹配 -->
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>easyexcel</artifactId>
    <version>2.1.1</version>
</dependency>

<!--xls-->
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi</artifactId>
    <version>3.1.7</version>
</dependency>

<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>3.1.7</version>
</dependency>
```

####  2.创建Excel实体类

```java
import com.alibaba.excel.annotation.ExcelProperty;
import lombok.Data;

/**
 * Excel实体类
 * @author saber
 */
@Data
public class SubjectData {

    /**
     * 一级分类 设置表头名称
     */
    @ExcelProperty(index = 0)
    private String oneSubjectName;

    /**
     * 二级分类
     */
    @ExcelProperty(index = 1)
    private String twoSubjectName;
}
```

####  3.写操作

```java
public static void main(String[] args){
    //设置写入文件路径
    String name = "F:\\test.xlsx"
    //需要写入的数据
    List<SubjectData> list = new ArrayList<>();
    SubjectData data = new SubjectData("level1","level2")
    list.put(data)
    //写操作
    EasyExcel.read(name,SubjectData.class).sheet("课程分类列表").doWrite(list);
}     
```

####  4.读操作需要创建监听器

```java
import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.zjm.eduservice.entity.EduSubject;
import com.zjm.eduservice.entity.excel.SubjectData;
import com.zjm.eduservice.service.EduSubjectService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zjm.servicebase.exceptionhandler.MSException;

/**
 * easyExcel监听器
 * @author saber
 */
public class SubjectExcelListener extends AnalysisEventListener<SubjectData> {
    
    /**
     * SubjectExcelListener不能交给spring 不能注入其他对象
     */
    public EduSubjectService edusubjectService;
    
    public SubjectExcelListener() {}  
    public SubjectExcelListener(EduSubjectService subjectService) {  //有参
        this.edusubjectService = subjectService;
    }


    /**
     * 按行加载Excel数据
     * @param subjectData
     * @param analysisContext
     */
    @Override
    public void invoke(SubjectData subjectData, AnalysisContext analysisContext) {
        if(subjectData == null) {
            throw new MSException(20001,"文件数据为空");
        }

        //每次读取有两个值，第一个值一级分类，第二个值二级分类
        //判断一级分类是否重复
        EduSubject existOneSubject = this.existOneSubject(edusubjectService, subjectData.getOneSubjectName());
        //没有相同一级分类，进行添加
        if(existOneSubject == null) {
            existOneSubject = new EduSubject();
            existOneSubject.setParentId("0");
            //一级分类名称
            existOneSubject.setTitle(subjectData.getOneSubjectName());
            edusubjectService.save(existOneSubject);
        }

        //获取一级分类id值 作为二级分类的父id
        String pid = existOneSubject.getId();
        //添加二级分类
        //判断二级分类是否重复
        EduSubject existTwoSubject = this.existTwoSubject(edusubjectService, subjectData.getTwoSubjectName(), pid);
        if(existTwoSubject == null) {
            existTwoSubject = new EduSubject();
            existTwoSubject.setParentId(pid);
            //二级分类名称
            existTwoSubject.setTitle(subjectData.getTwoSubjectName());
            edusubjectService.save(existTwoSubject);
        }
    }

    /**
     * 判断一级分类不能重复添加
     * @param subjectService
     * @param name
     * @return
     */
    private EduSubject existOneSubject(EduSubjectService subjectService,String name) {
        QueryWrapper<EduSubject> wrapper = new QueryWrapper<>();
        wrapper.eq("title",name);
        wrapper.eq("parent_id","0");
        EduSubject oneSubject = subjectService.getOne(wrapper);
        return oneSubject;
    }

    /**
     * 判断二级分类不能重复添加
     * @param subjectService
     * @param name
     * @return
     */
    private EduSubject existTwoSubject(EduSubjectService subjectService,String name,String pid) {
        QueryWrapper<EduSubject> wrapper = new QueryWrapper<>();
        wrapper.eq("title",name);
        wrapper.eq("parent_id",pid);
        EduSubject twoSubject = subjectService.getOne(wrapper);
        return twoSubject;
    }

    @Override
    public void doAfterAllAnalysed(AnalysisContext analysisContext) {

    }
}
```

####  5.读操作

```java
public void saveSubject(MultipartFile file, EduSubjectService eduSubjectService) {
    try {
        //文件输入流
        InputStream in = file.getInputStream();
        //调用方法进行读取
        EasyExcel.read(in, SubjectData.class,new SubjectExcelListener(eduSubjectService)).sheet().doRead();
    }catch(Exception e){
        e.printStackTrace();
    }
}
```

