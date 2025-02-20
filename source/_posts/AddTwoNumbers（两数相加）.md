---
layout: posts
title: AddTwoNumbers（两数相加）
date: 2020-12-19 17:38:21
updated: 2020-12-19 17:38:21
categories:  

 - LeetCode

---

N2AddTwoNumbers（两数相加）



```
You are given two non-empty linked lists representing two non-negative integers. The digits are stored in reverse order, and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.
You may assume the two numbers do not contain any leading zero, except the number 0 itself.

Input: l1 = [2,4,3], l2 = [5,6,4]
Output: [7,0,8]

Explanation: 342 + 465 = 807.
来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/add-two-numbers
```

### 解法：

- 将两个链表看成是相同长度的进行遍历，如果一个链表较短则在后面面补 0，比如 999 + 99 = 999 + 990 = 8901
  每一位计算的同时需要考虑上一位的进位问题，而当前位计算结束后同样需要更新进位值
  小技巧：对于链表问题，返回结果为头结点时，通常需要先初始化一个预先指针 pre，该指针的下一个节点指向真正的头结点head。使用预先指针的目的在于链表初始化时无可用节点值，而且链表构造过程需要指针移动，进而会导致头指针丢失，无法返回结果。

  

  ![1.png](https://i.loli.net/2020/12/18/HndhBC7DaGxsAWI.png)

  

```java
class Solution {
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
       //用于标识头部的指针
       ListNode pre = new ListNode(0);
       //用于记录每个节点值的指针
       ListNode cur = pre;
       //进位标记
       int carry = 0;

       //当两个链表都置于尾部时跳出
       while(l1!=null || l2!=null){
           //节点如果为null则补零
           int x=l1==null?0:l1.val;
           int y=l2==null?0:l2.val;
           //计算两数之和 需要带上进位标记值
           int sum = x + y +carry;
           //获取进位标记
           carry = sum / 10;
           //获取和值
           sum = sum % 10;
           //将值写入下个节点 （因为是从0开始）
           cur.next = new ListNode(sum);
           //移动记录指针
           cur = cur.next;
           //移动递归指针
           if (l1 != null){
               l1 = l1.next;
           }
           if(l2 != null){
               l2 = l2.next;
           }
       }
       //当两个链表都走到结尾还存在进位标记时则需将进位值写入下一位
       if (carry == 1){
           cur.next = new ListNode(carry);
       }
       //返回记录链表
       return pre.next;
    }
}
```