---
layout: posts
title: 单项链表crud简单实现
date: 2020-04-27 15:28:00
updated: 2020-04-27 15:32:45
tags: 
categories: 
 - 数据结构
---
```java
class SingleLinkedList {

    /**
     * 头节点的指针 始终指向头节点
     */
    private HeroNode head = new HeroNode(0,null);

    public HeroNode getHead() {
        return head;
    }

    /**
     * 修改节点 根据heroNode.id
     * @param heroNode
     */
    public void update(HeroNode heroNode){
        //判空
        if (head.next == null){
            System.out.println("链表为空");
            return;
        }
        //获取头节点
        HeroNode cur = head.next;
        //遍历
        while (cur!=null){
            //id相等修改值
            if (cur.id == heroNode.id){
                cur.name = heroNode.name;
                return;
            }
            //指针后移
            cur = cur.next;
        }
    }

    /**
     * 按照id顺序插入链表
     * @param newNode
     * @return
     */
    public boolean addNodeById(HeroNode newNode){
        //获取头节点的指针
        HeroNode temp  =  head;
        //遍历链表 寻找插入的位置
        while (temp.next!= null){
            if (temp.next.id == newNode.id){
                System.out.printf("节点编号%d已存在请校验数据！\n",newNode.id);
                return false;
            }
            if (temp.next.id > newNode.id){
               //添加元素不处于链表末尾
                break;
            }
            //移动指针
            temp = temp.next;
        }
        //temp指向尾部节点 并且链表中没有相同的节点id
        newNode.next = temp.next;
        temp.next = newNode;
        return true;
    }

    /**
     * 按照servantid删除节点
     * @param id
     * @return
     */
    public boolean delNode(int id){
        //获取头节点的指针
        HeroNode temp = head;
        //从第一个节点开始遍历链表
        while(temp.next != null){
            if (temp.next.id == id){
                //如果id相同就执行删除
                //当删除的为第一个节点时 移动头指针 相当于 head.next = head.next.next
                temp.next = temp.next.next;
                return true;
            }
            //移动指针
            temp = temp.next;
        }
        System.out.printf("要删除的%d号数据不存在\n",id);
        return false;
    }

    /**
     * 插入到末尾
     * @param newNode
     */
    public void addNode(HeroNode newNode){
        //获取头节点的指针
        HeroNode temp =  head;
        //移动指针到链表末尾 如果链表为null则直接插入
        while(temp.next != null){
           temp = temp.next;
        }
        //插入到末尾
        temp.next = newNode;
    }

    /**
     * 打印链表
     */
    public void list(){
        //头指针无需打印 获取第一个节点
        HeroNode temp = head.next;
        //遍历链表
        while(temp != null){
            System.out.println(temp.toString());
            temp = temp.next;
        }
    }

    /**
     * 反转链表
     * @param head
     */
    public void revsLinkedList(HeroNode head){

        //链表为空或只有一个节点 不执行操作
        if (head.next == null || head.next.next == null){
            return;
        }

        //头节点
        HeroNode cur = head.next;
        //反转后的头指针
        HeroNode revs = new HeroNode(0,"");
        //后继节点
        HeroNode next;
        while (cur != null){
            //保存后继节点
            next = cur.next;
            //让当前节点指向revs的下一个节点
            cur.next = revs.next;
            //让revs指向当前节点
            revs.next = cur;
            //移动指针
            cur = next;
        }
        //让原始指针指向反转后的第一个节点
        head.next = revs.next;
    }

    /**
     * 计算有效节点的个数
     * @param head
     * @return
     */
    public int countLikedNode(HeroNode head ){
        //统计变量
        int count = 0;
        //获取第一个节点
        HeroNode cur = head.next;
        //链表为空 返回0
        if(cur == null){
            return count;
        }
        while (cur!=null){
            //统计变量自增
            count++;
            //移动指针
            cur = cur.next;
        }
        return count;
    }

    /**
     * 返回从末位数的第index个节点
     *
     * @param head
     * @param index
     * @return
     */
    public HeroNode lastIndexOfNode(HeroNode head, int index){
        if(head.next == null){
            System.out.println("链表为空");
            return null;
        }
        //统计节点的个数
        int count = countLikedNode(head);
        //校验索引是否合法
        if (index>count||index<=0){
            System.out.println("索引不合法,size : "+count);
            return null;
        }
        HeroNode cur = head.next;
        for (int i = 0; i < count-index ; i++) {
            cur = cur.next;
        }
        return cur;
    }

    /**
     * 逆序打印链表 利用栈
     * @param head 链表的头指针
     */
    public void revsPrint(HeroNode head){
        if (head.next == null){
            System.out.println("链表为空");
        }
        HeroNode cur = head.next;
        Stack<HeroNode> nodeStack = new Stack<>();
        //压栈
        while (cur!=null){
            nodeStack.push(cur);
            cur = cur.next;
        }
        //弹栈
        while(nodeStack.size()>0){
            HeroNode pop = nodeStack.pop();
            System.out.println(pop);
        }
    }

}
class HeroNode {
    public int id;
    public String name;
    public HeroNode next;

    public HeroNode(int id, String name) {
        this.id = id;
        this.name = name;
    }

    @Override
    public String toString() {
        return "HeroNode{" +
                "id=" + id +
                ", name='" + name + '\'' +
                '}';
    }
}
```

## 测试

```java
public static void main(String[] args) {
    HeroNode h = new HeroNode(1,"saber");
    HeroNode h1 = new HeroNode(3,"caster");
    HeroNode h2 = new HeroNode(2,"lancer");
    SingleLinkedList singleLinkedList = new SingleLinkedList();
    singleLinkedList.addNode(h);
    singleLinkedList.addNode(h1);
    singleLinkedList.addNode(h2);
    int i = singleLinkedList.
            countLikedNode(singleLinkedList.getHead());
    System.out.printf("链表一共有%d个节点\n",i);
    System.out.println("反转前");
    singleLinkedList.list();
    //singleLinkedList.revsLinkedList(singleLinkedList.getHead());

	//        singleLinkedList.addNodeById(h2);
	//        singleLinkedList.addNodeById(h);
	//        singleLinkedList.delNode(1);
    singleLinkedList.addNodeById(h1);
    System.out.println("反转后");
    singleLinkedList.list();

    System.out.println("查找倒数第二个节点");
    HeroNode node =
            singleLinkedList.lastIndexOfNode(
                    singleLinkedList.getHead(),2);
    System.out.println(node.toString());

    System.out.println("逆序打印=========>");
    singleLinkedList.revsPrint(singleLinkedList.getHead());

    HeroNode h3 = new HeroNode(2,"archer");
    singleLinkedList.update(h3);
    System.out.println("修改后");
    singleLinkedList.list();
}
```

## 打印

```java
链表一共有3个节点
反转前
HeroNode{id=1, name='saber'}
HeroNode{id=3, name='caster'}
HeroNode{id=2, name='lancer'}
节点编号3已存在请校验数据！
反转后
HeroNode{id=1, name='saber'}
HeroNode{id=3, name='caster'}
HeroNode{id=2, name='lancer'}
查找倒数第二个节点
HeroNode{id=3, name='caster'}
逆序打印=========>
HeroNode{id=2, name='lancer'}
HeroNode{id=3, name='caster'}
HeroNode{id=1, name='saber'}
修改后
HeroNode{id=1, name='saber'}
HeroNode{id=3, name='caster'}
HeroNode{id=2, name='archer'}
```