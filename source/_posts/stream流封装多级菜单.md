---
layout: posts
title: stream流封装多级菜单
date: 2020-08-05 23:20:00
updated: 2020-08-05 23:25:51
tags: 
categories: 
 - 经验&bug
---


```java
/**
 * 查询所有品牌分类并返回树形菜单
 * @return
 */
@Override
public List<CategoryEntity> listWithTree() {
    //查询出所有菜单
    List<CategoryEntity> entities = categoryDao.selectList(null);

    //过滤 排序封装菜单
    List<CategoryEntity> levelOneMenus = entities.stream()
            .filter(item -> item.getParentCid() == 0)
            .map(menu->{
                 menu.setChildren(listCategoryChildren(menu,entities));
                 return menu;
            }).sorted((item1,item2)->{
                return (item1.getSort() == null ? 0 : item1.getSort()) - (item1.getSort() == null ? 0 : item1.getSort());
            }).collect(Collectors.toList());
    return levelOneMenus;
}
```


```java
/**
 * 递归查找 返回当前菜单的子菜单
 * @param entity 当前的菜单
 * @param list   所有的菜单集合
 * @return
 */
private List<CategoryEntity> listCategoryChildren(CategoryEntity entity,List<CategoryEntity> list ){
    List<CategoryEntity> menu = list.stream()
            .filter(item -> item.getParentCid().equals(entity.getCatId()))
            .map(item -> {
                item.setChildren(listCategoryChildren(item, list));
                return item;
            })
            .sorted((item1, item2) -> {
                return (item1.getSort() == null ? 0 : item1.getSort()) - (item1.getSort() == null ? 0 : item1.getSort());
            }).collect(Collectors.toList());
    return menu;
}
```

