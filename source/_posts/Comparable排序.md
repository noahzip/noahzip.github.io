---
layout: posts
title: Comparable排序
categories:
  - 算法
  - 算法入门
abbrlink: 31472
date: 2020-03-09 20:22:00
updated: 2020-03-09 20:22:40
tags:
---
### 实体类实现Comparable接口：

```java
public class Student implements Comparable<Student> {
    private int age;
    private String name;

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Student{" +
                "age=" + age +
                ", name='" + name + '\'' +
                '}';
    }

    public int compareTo(Student o) {
		//排序条件构造
        return this.age-o.age;
    }
}
```

### 定义排序方法：
其实就是利用Comparable接口的CompareTo方法

```java
public static Comparable getMaxAge(Comparable c1 ,Comparable c2){
    int result = c1.compareTo(c2);
    if (result>=0){
        return c1;
    }else {
        return c2;
    }
}
```
### 方法调用：

```java
public static void main(String[] args) {
    Student s1 = new Student();
    s1.setName("张三");
    s1.setAge(20);
    Student s2 = new Student();
    s2.setName("李四");
    s2.setAge(21);
    Comparable maxAge = getMaxAge(s1, s2);
    System.out.println(maxAge);
}
```
### 打印结果：
```java
Student{age=21, name='李四'}
```