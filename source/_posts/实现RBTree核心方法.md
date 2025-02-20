---
layout: posts
title: 实现RBTree核心方法
date: 2020-04-21 15:15:00
updated: 2020-04-21 15:21:32
tags: 
categories: 
 - 数据结构
---
### 1、自定义RbTree

```java
public class RbTree<K extends Comparable<K>, V> {
	private static final boolean RED = true;
	private static final boolean BLACK = false;
	// 根节点
	private RbNode root;

	public RbTree(RbNode root) {
		this.root = root;
	}

	public RbTree() {
	}
	
	//RbNode节点
	static class RbNode<K extends Comparable<K>, V> {
		private boolean color;
		private RbNode parent;
		private RbNode left;
		private RbNode right;
		private K key;
		private V value;

		public RbNode() {
		}

		public RbNode(boolean color, RbNode parent, RbNode left, RbNode right, K key, V value) {
			this.color = color;
			this.parent = parent;
			this.left = left;
			this.right = right;
			this.key = key;
			this.value = value;
		}

		public boolean isColor() {
			return color;
		}

		public void setColor(boolean color) {
			this.color = color;
		}

		public RbNode getParent() {
			return parent;
		}

		public void setParent(RbNode parent) {
			this.parent = parent;
		}

		public RbNode getLeft() {
			return left;
		}

		public void setLeft(RbNode left) {
			this.left = left;
		}

		public RbNode getRight() {
			return right;
		}

		public void setRight(RbNode right) {
			this.right = right;
		}

		public K getKey() {
			return key;
		}

		public void setKey(K key) {
			this.key = key;
		}

		public V getValue() {
			return value;
		}

		public void setValue(V value) {
			this.value = value;
		}
	}
}
```

### 2、左旋
```java


/**
* 左旋
* @param x
* 		p        	 p
* 		|		  	|
* 	 	x	 --->	y
* 		/ \		   / \
* 		lx y       x  ry
* 		/  \     / \
* 		ly  ry   lx ly

* 1.y的左子节点ly变为x的右子节点 ly的父节点变为x

* 2.x的父节点变为y的父节点 p的子节点变为y

* 3.x的父节点变为y y的左子节点变为x
*/
private void leftRotate(RbNode x) {
    //获取x的右子节点y
    RbNode y = x.right;
    //如果不存在右子节点不进行任何操作
    if (y == null) {
    return;
    }
    // x 的右子节点变为ly
    x.right = y.left;
    if(y.left != null){
    //ly父节点变为当x
    y.left.parent = x;
    }
    if (x.parent!=null){
    //x的父节点变为y的父节点
    y.parent = x.parent;
    //指定子树
    if(x == x.parent.left){
    x.parent.left = y;
    }else {
    x.parent.right = y;
    }
    //将当前节点的父节点指定为右子节点
    y.parent = x;
    //将右子节点的的左子节点指定为当前节点
    x.left = y;

    //x的父节点变为y
    x.parent = y;
    //y的左子节点变为x
    y.left = x;

    }else {
    //x为根节点 跟新根节点
    this.root = y;
    //置空父节点
    this.root.parent = null;
    }
}
```



### 3、右旋
```java
/**
 * 右旋
 * @param y
 * 		p        	p
 * 		|		  	|
 * 	 	y	 --->	x
 * 	   / \		   / \
 * 	  x  ry       lx  y
 * 	 / \	         / \
 * 	lx rx   	    rx ry
 */
private void rightRotate(RbNode y){
	//获取左子节点
	RbNode x = y.left;
	if (x == null){
		return;
	}
	//y的左子节点变为x的右子节点
	y.left = x.right;
	if (x.right != null){
		//rx的父节点变为y
		x.right.parent = y;
	}
	if(y.parent != null){
		//x的父节点变为y的父节点
		x.parent = y.parent;
		if (y == y.parent.left){
			y.parent.left = x;
		}else {
			y.parent.right = x;
		}
		//x右节点变为y
		x.right = y;
		//y的父节点变为x
		y.parent = x;

	}else{
		//y为根节点 更新根节点为x
		this.root = x;
		//置空父节点
		this.root.parent = null;
	}
}
```
### 4、插入节点
```java
/**
 * 插入节点
 * @param key
 * @param value
 */
public void insert(K key,V value){
	RbNode<K, Object> node = new RbNode<>();
	node.setKey(key);
	node.setValue(value);
	//新节点一定为红色
	node.setColor(RED);
	insert(node);
}

/**
 * 套娃插入节点
 * @param node
 */
private void insert(RbNode node){
	//从根节点开始查找插入结点的父节点
	//记录当前查找的节点
	RbNode parent = null;
	RbNode x = this.root;
	while (x != null){
		parent = x;
		//比较node的key和x的key的大小
		int cmp = node.key.compareTo(x.key);
		if (cmp == 0){
			//当前节点key等于查找的节点 覆盖值
			x.setValue(node.getValue());
			return;
		}else if(cmp > 0){
			//前往节点的右子树查找
			x = x.right;
		}else {
			//前往节点的左子树查找
			x = x.left;
		}
	}
	//新插节点的父节点为当前查找的节点
	node.parent = parent;
	if (parent!=null){
		//比较key的大小 判断新插节点为父节点的左子节点或右子节点
		int cpm = node.key.compareTo(parent.key);
		if (cpm>0){
			parent.right = node;
		}else {
			parent.left = node;
		}
	}else {
		//RbTree为空 新插节点为根节点
		this.root = node;
	}
	//修复红黑树平衡
	insertFixUp(node);
}
```
### 5.修复平衡
```java
/**
 * 红黑树自平衡
 * 新插节点父节点为黑色、新插节点key已存在(只是value覆盖)无需处理
 * @param node
 */
private void insertFixUp(RbNode node) {
	//插入节点为根节点
	this.root.setColor(BLACK);

	//父节点
	RbNode parent = parentOf(node);
	//祖父节点
	RbNode gParent = parentOf(parent);

	//插入节点的父节点为红色 一定存在祖父节点 因为根节点不可能为红色
	if(parent != null&& isRed(parent)){
		RbNode uncle = null;
		if (parent == gParent.left){
			//父节点为祖父节点的左节点
			uncle = gParent.right;
			if(uncle != null && isRed(uncle)){
				//叔叔节点存在 并且 父-叔双红
				//父节点染为黑色 祖父节点染为红色
				setBlack(parent);
				setBlack(uncle);
				setRed(gParent);
				//把祖父节点作为当前节点进行处理
				insertFixUp(gParent);
				return;
			}
			if(uncle == null || isBlack(uncle)){
				//叔叔节点不存在或者为黑色
				if(node == parent.left){
					//左左(父子)双红
					//父节点染为黑色 祖父节点染为红色
					setBlack(parent);
					setRed(gParent);
					//以祖父节点为当前节点右旋
					rightRotate(gParent);
					return;
				}
				if (node == parent.right){
					//左右双红 以父节点为当前节点左旋形成左左双红
					leftRotate(parent);
					//以父节点为当前节点进行下一次操作
					insertFixUp(parent);
					return;
				}
			}
		}else {
			//父节点为祖父节点的右节点
			uncle = gParent.left;
			if(uncle != null && isRed(uncle)){
				//叔叔节点存在 并且 父-叔双红
				//父节点染为黑色 祖父节点染为红色
				setBlack(parent);
				setBlack(uncle);
				setRed(gParent);
				//把祖父节点作为当前节点进行处理
				insertFixUp(gParent);
				return;
			}
			if (uncle == null || isBlack(uncle)){
				//叔叔节点不存在或者叔叔节点为黑色
				if (node == parent.left){
					//右左双红 以父节点作为当前节点进行右旋
					rightRotate(parent);
					//以父节点作为当前节点进行下一次操作
					insertFixUp(parent);
					return;
				}
				if (node == parent.right){
					//右右双红
					//父节点染为黑色，祖父节点染为红色
					setBlack(parent);
					setRed(gParent);
					//以祖父节点为当前节点进行左旋操作
					leftRotate(gParent);
					return;
				}
			}
		}
	}
}
```
### 6、辅助方法
```java
/**
 * 获取当前节点的父节点
 *
 * @param node
 * @return
 */
private RbNode parentOf(RbNode node) {
	if (node != null) {
		return node.parent;
	}
	return null;
}

/**
 * 判断是否为红色节点
 *
 * @param node
 * @return
 */
private boolean isRed(RbNode node) {
	if (node != null) {
		return node.color == RED;
	}
	return false;
}

/**
 * 判断是否为黑色节点
 *
 * @param node
 * @return
 */
private boolean isBlack(RbNode node) {
	if (node != null) {
		return node.color == BLACK;
	}
	return false;
}

/**
 * 设置为红色节点
 *
 * @param node
 */
private void setRed(RbNode node) {
	if (node != null) {
		node.color = RED;
	}
}

/**
 * 设置为黑色节点
 *
 * @param node
 */
private void setBlack(RbNode node) {
	if (node != null) {
		node.color = BLACK;
	}
}
```
