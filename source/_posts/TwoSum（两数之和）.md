---
layout: posts
title: TwoSum（两数之和）
date: 2020-12-19 16:30:00
updated: 2012-19-04 16:30:33
categories: 
 -  LeetCode
---

### N1TwoSum（两数之和）

```text
Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.
You may assume that each input would have exactly one solution, and you may not use the same element twice.
You can return the answer in any order.

Example :
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Output: Because nums[0] + nums[1] == 9, we return [0, 1].

Constraints:
2 <= nums.length <= 103
-109 <= nums[i] <= 109
-109 <= target <= 109
Only one valid answer exists.
来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/two-sum
```

### 解法：

1. #### 暴力解法：(SpaceComplexity：0，TimeComplexity：n*n)

   - 最容易想到的方法是指针遍历数组中的每一个数 **x**，寻找数组中是否存在 **target - x**。**第一个指针i从0开始**依次指向后面的元素，由于规定不允许重复计算【**2+3和3+2是同一个结果**】**第二个指针j从i+1开始**依次指向后面的元素，当满足**arr[i]+arr[j]=target**时，返回**[i,j]**即可。

     

     ![1.png](https://i.loli.net/2020/12/18/CNa5ixHpFBtcjIZ.png)

     

     ```java
     class Solution {
         public int[] twoSum(int[] nums, int target) {
             for (int i = 0; i < nums.length; i++) {
                 for (int j = i+1; j < nums.length; j++) {
                     if (nums[i]+nums[j]==target){
                         return new int[]{i,j};
                     }
                 }
             }
             return new int[]{-1,-1};
         }
     }
     ```

1. #### dictionary解法：(SpaceComplexity：n ，TimeComplexity：n)

   - 使用HashMap生成)字典**(key(元素值):value(下标值)**，**使用一个指针i**遍历元素集合，判断key是否包含**target - arr[i]**，如果包含则返回**[map.get(target - arr[i]),i]**

     ![2.png](https://i.loli.net/2020/12/18/j6By9cGrKX5NZYE.png)

     

     ```java
     class Solution {
         public int[] twoSum(int[] nums, int target) {
             //key存储值 value存储下标
             HashMap<Integer, Integer> map = new HashMap<>();
             for (int i = 0; i < nums.length; i++) {
                 //计算和值与当前元素的差值
                 int tem = target - nums[i];
                 //如果map的key包含差值说明存在 直接返回
                 if (map.containsKey(tem)){
                     return new int[]{map.get(tem),i};
                 }
                 //将元素的值作为key 下标作为value存入map
                 map.put(nums[i],i);
             }
             return null;
         }
     }
     ```

