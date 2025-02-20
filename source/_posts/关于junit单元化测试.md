---
layout: posts
title: 关于junit单元化测试
date: 2020-04-23 10:51:42
updated: 2020-04-23 10:51:42
tags: 
categories: 
 - 经验&bug
---
### junit是自动化单元测试，不支持手动录入数据。

#### 第一种方式：参数化测试
1.固定参数:

    public void test(){
        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream("saber".getBytes());
        System.setIn(byteArrayInputStream);
        Scanner sc = new Scanner(System.in);
        String s = sc.nextLine();
        System.out.println("输入的是"+s);
    }

2.复杂参数举例：
	
	/**
	 * @author cxy
	 * 参数化测试斐波那契额数列
	 * 当类被@RunWith注解修饰，或者类继承了一个被该注解修饰的类，
	 * JUnit将会使用这个注解所指明的运行器（runner）来运行测试，而不使用JUnit默认的运行器。
	 */
	@RunWith(Parameterized.class)
	public class FibonacciTest {
	
	    /**
	     * 测试多个参数
	     * Junit4 中通过 Parameterized 运行器实现参数化测试。该方法必须是静态的
	     * {index}: 当前参数的索引
	     * {0}, {1}, …: 第一个参数，第二个参数等,参数值..
	     */
	    @Parameterized.Parameters(name = "{index}: fib({0})={1}")
	    public static Collection<Object[]> data() {
	        return Arrays.asList(new Object[][]{
	                {0, 0}, {1, 1}, {2, 1}, {3, 2}, {4, 3}, {5, 5}, {6, 8}
	        });
	    }
	
	    //如果你的测试只需要单个参数，则不需要将其包装成数组
	    //@Parameterized.Parameters
	    //public static Iterable<? extends Object> data() {
	    //    return Arrays.asList("first test", "second test");
	    //}
	
	    /**
	     * 使用无参构造必须 @Parameterized.Parameter注入属性
	     */
	    public FibonacciTest() {
	    }
	
	    /**
	     * 输入参数
	     * 如果使用无参构造 @Parameterized.Parameter 属性注入
	     */
	    @Parameterized.Parameter
	    public int fInput;
	
	    /**
	     * 期待的结果
	     */
	    @Parameterized.Parameter(1)
	    public int fExpected;
	
	    //使用带参构造注入属性
	    //    public FibonacciTest(int input, int expected){
	    //        fInput = input;
	    //        fExpected = expected;
	    //    }
	
	    /**
	     * 待测试的方法
	     */
	    public static class Fibonacci {
	        public static int compute(int n) {
	            int result = 0;
	
	            if (n <= 1) {
	                result = n;
	            } else {
	                result = compute(n - 1) + compute(n - 2);
	            }
	            return result;
	        }
	    }
	
	    @Test
	    public void testFibonacci() {
	        Assert.assertEquals(fExpected, Fibonacci.compute(fInput));
	    }
	}
##### 第二种方式：读取资源文件测试
将待测试的类放到test的资源文件中，如果是复杂类型选择json文件读取时解析

	public class MainTest {
	 
	    private List<String> datas;
	 
	    @Before
	    public void init() throws IOException {
			//输入流读取文件
	        InputStream inputStream = this.getClass().getResource("/data.txt").openStream();
	        datas = IOUtils.readLines(inputStream, Charset.forName("utf-8"));
	    }
	 
	    @Test
	    public void test() {
	        SomeClass someClass = new SomeClass();
	        for (String line : datas) {
	            String[] split = line.split(",");
	            Assert.assertEquals(split[1], someClass.someMethod(split[0]));
	        }
	 
	    }
	}
### 那么我就想手动输入测试数据呢？
可以使用以下的方式
#### 1、直接使用main函数

```java
public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    System.out.println("请输入一个单词:");
    String s = sc.nextLine();
    System.out.println("输入的是" + s);
}
```


#### 2、修改虚拟机参数 设置参数为

-Deditable.java.test.console=true

```java
@Test
public void test02() {
    Scanner sc = new Scanner(System.in);
    System.out.println("请输入一个单词:");
    String s = sc.nextLine();
    System.out.println("输入的是" + s);
}
```