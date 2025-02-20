---
layout: posts
title: flutter基础
categories:
  - 前端
  - flutter
abbrlink: 8524
date: 2020-10-20 22:18:00
updated: 2020-10-26 22:19:48
tags:
---
##  本文章知识来自于jspang（https://jspang.com/detailed?id=42# toc219），仅用于学习记录。

##  Flutter页面的基本写法main.dart:

```dart
//导入组件
import 'package:flutter/material.dart';

//启动入口
void main(){
  runApp(MyApp());
}

//自定义的运行模块？
//需要继承自 StatelessWidget 并重写build方法
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //app名称
      title: "Hello",
       //页面展示的内容
 	  home: Scaffold(
        //bar
        appBar: AppBar(
          title: Text("world"),
        ),
        //内容
        body: Center(
          child: Text("hello world "),
        ),
      ),
    );
  }
}
```

**运行效果：**

![0Y_Q0@`U1_A_ZPE_3559__C.png](https://i.loli.net/2020/10/20/joc9fil76LPmZqw.png)



##  调整文本：

```dart
import 'package:flutter/material.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //app名称
      title: "Hello",
       //页面展示的内容
 	  home: Scaffold(
        //bar
        appBar: AppBar(
          title: Text("world"),
        ),
        //内容
       body: Center(
          child: Text(
              "Stack Overflow is an open community "
                  "for anyone that codes. We help you get "
                  "answers to your toughest coding questions, "
                  "share knowledge with your coworkers in private, "
                  "and find your next dream job.",
              //左对齐
            textAlign: TextAlign.left,
              //最大显示1行
            maxLines: 1,
              //超出显示的部分怎么处理
            overflow: TextOverflow.ellipsis,
              //调整文本的样式
            style: TextStyle(
                //字号
              fontSize: 25.0,
                //颜色
              color: Color.fromARGB(255, 255, 125, 125),
                //下划线
              decoration: TextDecoration.underline,
                //下划线的类型
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}
```

**运行效果：**

![NP~IGB90UZCLQ__3M33GLA6.png](https://i.loli.net/2020/10/20/OWL74SmzuqjrPeM.png)

##  页面容器Container：

```dart
import 'package:flutter/material.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello",
 	  home: Scaffold(
        appBar: AppBar(
          title: Text("world"),
        ),
        body: Center(
            //内部是一个Container
          child: Container(
            child: new Text(
                //显示的文本
                "hello saber",
                //文本的样式...
                style: TextStyle(
                  fontSize: 40.0,
                ),
            ),
            //容器靠左上浮动
            alignment: Alignment.topLeft,
            //容器的尺寸
            width: 500.0,
            height: 400.0,
            // color: Colors.lightGreenAccent,
            //内边距
            padding: const EdgeInsets.fromLTRB(10.0,30.0,0.0,0.0),
            //外边距
            margin: const EdgeInsets.all(10.0),
            //颜色渐变
            decoration: new BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.lightBlue,Colors.green,Colors.purple]
              ),
              //边框
              border: Border.all(width:2.0,color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
```

**运行效果：**

![U6QOXZ8ZE6XFDP_S~_8L1_Y.png](https://i.loli.net/2020/10/20/HZn96JqCP1W2XVd.png)

##  导入图片：

```dart
import 'package:flutter/material.dart';

void main(){
    runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
            title: "hello",
            home: Scaffold(
                appBar: AppBar(
                    title: new Text("MyApp"),
                ),
                body: Center(
                    //引入容器
                    child: Container(
                        //引入网络图片 本地图片使用file
                        child: new Image.network(
                            'https://picabstract-preview-ftn.weiyun.com/'
                                    'ftn_pic_abs_v3/6d37e151e59ca439abe2654102a31'
                                    '63bee41ca67113bb3add51aa2fc9e16f27d0959cef2'
                                    'a9b3625f7174e0aa15dbd830?pictype=scale&from='
                                    '30113&version=3.3.3.3&uin=1170398847&fname='
                                    'httpi0.hdslb.combfsarticledc607d09ad1347811af3fdb.'
                                    'jpg&size=750miui.com%2Fforum%2F201311%2F27%2F222526bjdipmjgzj1ibim7.jpg',
                            //对图像进行缩放 一般使用fill调整
                            scale: 1.0,
                            
                            //图像重复平铺整个容器 X、Y表示只用于横、纵向
                            //repeat: ImageRepeat.repeat,

                            //填充整个容器
                            //fit: BoxFit.fill,
                            //全图显示
                            //fit: BoxFit.contain,
                            //按比例放大填充整个容器
                            fit: BoxFit.cover,
                            //高度充满
                            //fit: BoxFit.fitHeight,
                            //宽度充满
                            //fit: BoxFit.fitWidth,
                            //和contain类似，但是不允许显示超过原图片大小
                            //fit: BoxFit.scaleDown,

                            //要混合的颜色
                            color: Colors.greenAccent,
                            //图片颜色混合模式
                            colorBlendMode: BlendMode.exclusion,

                        ),
                        //容器尺寸 可以从context中动态获取以适应不同设备
                        width: 450.0 ,
                        height: 610.0,
                        //容器 颜色
                        color: Colors.lightBlue,
                    ),
                ),

            ),
        );
  }
    
}
```

**运行效果：**

	**未开启图片颜色混合：**

![XF8J3OKY_@I_QHL_H7@J2DI.png](https://i.loli.net/2020/10/21/kU78jEalWZpXtCQ.png)

	**开启图片颜色混合：**

![DZN18~V7H@JT_XC__BH9TBI.png](https://i.loli.net/2020/10/21/izDm56LYqBMfgec.png)



##  	纵向ListView列表组件:

```dart
import 'package:flutter/material.dart';
void main(){
    runApp(myApp());
}

class myApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "myApp",
      home: Scaffold(
        appBar: AppBar(
          title: new Text("ListView"),
        ),
        //定义listview
        body: new ListView(
          children: <Widget>[
            new ListTile(
              //图表类型
              leading: new Icon(Icons.access_time),
              //名称
              title: new Text("access_time"),
            ),
            new ListTile(
              leading: new Icon(Icons.account_balance),
              title: new Text("account_balance"),
            ),
            //图片
            new Image.network(
              'https://picabstract-preview-ftn.weiyun.com/'
                  'ftn_pic_abs_v3/6d37e151e59ca439abe2654102a31'
                  '63bee41ca67113bb3add51aa2fc9e16f27d0959cef2'
                  'a9b3625f7174e0aa15dbd830?pictype=scale&from='
                  '30113&version=3.3.3.3&uin=1170398847&fname='
                  'httpi0.hdslb.combfsarticledc607d09ad1347811af3fdb.'
                  'jpg&size=750miui.com%2Fforum%2F201311%2F27%2F222526bjdipmjgzj1ibim7.jpg',
            )
          ],
      ),
    ),
    );
  }
}
```

**运行效果：**

![64KDKJ__O2PXL7B`796GEFC.png](https://i.loli.net/2020/10/25/arUEo5vGuxVRY1s.png)



##  横向ListView列表组件:

```dart
import 'package:flutter/material.dart';
void main(){
  runApp(myApp());
}

class myApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'myApp',
      home: Scaffold(
       body: Center(
         child: Container(
           height: 200.0,
           child: new ListView(
             //滚动方式 横向：Axis.horizontal  纵向：Axis.vertical
             scrollDirection: Axis.horizontal,
             children:<Widget> [
               new Container(
                 width: 100.0,
                 color: Colors.lightBlue,
                 child: Center(
                    child: new Text("lightBlue"),
                 ),
                
               ),
               new Container(
                 width: 100.0,
                 color: Colors.amber,
                 child: Center(
                   child: new Text("amber"),
                 ),
               ),
               new Container(
                 width: 100.0,
                 color: Colors.deepOrange,
                 child: Center(
                   child: new Text("deepOrange"),
                 ),
               ),
               new Container(
                 width: 100.0,
                 color: Colors.deepOrangeAccent,
                 child: Center(
                   child: new Text("deepAccent"),
                 ),
               ),
             ],
           ),
         ),
       ),
      ),
    );
  }
}
```

**运行效果：**

![3R_I~_6U___WJH_YWO`7YGV.png](https://i.loli.net/2020/10/25/YkpBQLlwoFsNWnU.png)

​	**代码优化**

```dart
import 'package:flutter/material.dart';
void main(){
  runApp(myApp());
}

class myApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ListView Widget",
      home: Scaffold(
        body: Center(
          child: Container(
            height: 100.0,
            //引用定义的组件
            child: MyList(),
          ),
        ),
      ),
    );
  }
}

//新建一个类继承StatelessWidget 返回一个ListView
class MyList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children:<Widget> [
        new Container(
          width: 100.0,
          color: Colors.lightBlue,
          child: Center(
            child: new Text("lightBlue"),
          )
        ),
        new Container(
        width: 100.0,
        color: Colors.amber,
        child: Center(
        child: new Text("amber"),
        ),
        ),
        new Container(
        width: 100.0,
        color: Colors.deepOrange,
        child: Center(
        child: new Text("deepOrange"),
        ),
        ),
        new Container(
        width: 100.0,
        color: Colors.deepOrangeAccent,
        child: Center(
        child: new Text("deepAccent"),
        ),
        )
      ],
    );
  }
}
```

**运行效果：**

![WI_7BR_S_KTH3Y2WP_I_8OV.png](https://i.loli.net/2020/10/25/X6h4D2vOxEWbc9o.png)



##  动态ListView列表:

```dart
import 'package:flutter/material.dart';
void main(){
  runApp(app(
    //传入一个数组
    items: new List<String>.generate(10, (index) => "item $index")
  ));
}

class app extends StatelessWidget{
  final List<String> items;
  app({Key key,@required this.items}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "app",
      home: Scaffold(
        //构建列表
        body: new ListView.builder(
          //取出列表的容量
          itemCount: items.length,
          itemBuilder: (context,index){
            return new ListTile(
              title: new Text("${items[index]}"),
            );
          },
        ),
      ),
    );
  }
}
```

**运行效果：**

![E__VHL01_ER8WS1L__R6UKE.png](https://i.loli.net/2020/10/25/j6EehdSZvl5HcKI.png)



##  GridView网格列表:

###  文字网格：

```dart
import 'package:flutter/material.dart';
void main(){
  runApp(app());
}

class app extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "app",
      home: Scaffold(
        body: GridView.count(
          //内边距
          padding: const EdgeInsets.all(50.0),
          //网格的数量（一行放几个元素）
          crossAxisCount: 3,
          //网格间的间隙
          crossAxisSpacing: 10.0,
          children:<Widget> [
            const Text("Stack Overflow is an open community"),
            const Text("for anyone that codes. We help you get"),
            const Text("answers to your toughest coding questions"),
            const Text("share knowledge with your coworkers in private"),
            const Text("and find your next dream job"),
            const Text("Don't give up,you can make a difference!")
          ],
        ),
      ),
    );
  }
}
```

**运行效果：**

![LOOUZZL_Q~CG8UXF_8P6_BA.png](https://i.loli.net/2020/10/25/ew2f3xtOvjsXNLW.png)

##  网格图片列表：

```dart
import 'package:flutter/material.dart';
void main(){
  runApp(app());
}

class app extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "app",
      home: Scaffold(
        appBar: AppBar(
          title: new Text("电影列表"),
          backgroundColor: Colors.lightBlue,
        ),
        body: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              //网格之间的距离
              mainAxisSpacing: 2.0,
              //横轴的间距
              crossAxisSpacing: 2.0,
              //childAspectRatio:宽高比，宽是高的2倍就写2.0，如果高是宽的2倍就写0.5。
              childAspectRatio: 0.68
          ),
          children:<Widget> [
            new Image.network('http://img5.mtime.cn/mt/2018/10/22/104316.77318635_180X260X4.jpg',fit: BoxFit.cover),
            new Image.network('http://img5.mtime.cn/mt/2018/10/10/112514.30587089_180X260X4.jpg',fit: BoxFit.cover),
            new Image.network('http://img5.mtime.cn/mt/2018/11/13/093605.61422332_180X260X4.jpg',fit: BoxFit.cover),
            new Image.network('http://img5.mtime.cn/mt/2018/11/07/092515.55805319_180X260X4.jpg',fit: BoxFit.cover),
            new Image.network('http://img5.mtime.cn/mt/2018/11/21/090246.16772408_135X190X4.jpg',fit: BoxFit.cover),
            new Image.network('http://img5.mtime.cn/mt/2018/11/17/162028.94879602_135X190X4.jpg',fit: BoxFit.cover),
            new Image.network('http://img5.mtime.cn/mt/2018/11/19/165350.52237320_135X190X4.jpg',fit: BoxFit.cover),
            new Image.network('http://img5.mtime.cn/mt/2018/11/16/115256.24365160_180X260X4.jpg',fit: BoxFit.cover),
            new Image.network('http://img5.mtime.cn/mt/2018/11/20/141608.71613590_135X190X4.jpg',fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
```

**运行效果：**

![_1VKHD`~6`1FIRO7OF_3HF4.png](https://i.loli.net/2020/10/25/j4T839ZiUmte61W.png)

##  Row 水平（横向）布局：

```dart
import 'package:flutter/material.dart';
void main(){
  runApp(app());
}

class app extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "app",
      home: Scaffold(
        appBar: AppBar(
          title: new Text("水平方向布局"),
        ),
        //横向布局
        body: new Row(
          children:<Widget> [
            //不灵活的横向布局
            new RaisedButton(
              onPressed:(){} ,
              color: Colors.lightBlue,
              child: new Text("row1"),
            ),
            //灵活的横向布局
            Expanded(child:
            new RaisedButton(
              onPressed:(){} ,
              color: Colors.lightGreen,
              child: new Text("row2"),
            ),
            ),
            Expanded(child:
            new RaisedButton(
              onPressed:(){} ,
              color: Colors.lightGreenAccent,
              child: new Text("row3"),
            ),
            ),
            Expanded(child:
            new RaisedButton(
              onPressed:(){} ,
              color: Colors.lightGreenAccent,
              child: new Text("row3"),
            ),
            ),
            Expanded(child:
            new RaisedButton(
              onPressed:(){} ,
              color: Colors.lightBlueAccent,
              child: new Text("row4"),
            ),
            ),
            new RaisedButton(
              onPressed:(){} ,
              color: Colors.red,
              child: new Text("row5"),
            ),
          ],
        ),
      ),
    );
  }
}
```

**运行效果：**

![R~OFE1XHH0__@_6W835W_~T.png](https://i.loli.net/2020/10/25/cuHoOJw3DyEdSYW.png)



##  Column 垂直（纵向）布局：

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
void main(){
  runApp(app());
}

class app extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "app",
      home: Scaffold(
        appBar: AppBar(
          title: new Text("垂直方向布局"),
        ),
        //纵向布局
       body: Center(
         child: Column(
           //文字 副轴对齐方式
           crossAxisAlignment: CrossAxisAlignment.center,
           //文字 主轴对齐方式
           mainAxisAlignment: MainAxisAlignment.center,
           children:<Widget> [
             Text("Stack Overflow is an open community"),
             Expanded(child: Text("answers to your toughest coding questions"),),
             Expanded(child: Text("share knowledge with your coworkers in private"),),
             Expanded(child:  Text("and find your next dream job"),),
             Text("Don't give up,you can make a difference!")
           ],
         ),
       )
      ),
    );
  }
}
```

**运行效果：**

![_YTU_E9T8E5_LFV87_WN9AK.png](https://i.loli.net/2020/10/25/o1xQ6ZCb8ayvGqH.png)



##  Stack层叠布局：

###  使用container的方式：

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
void main(){
  runApp(app());
}

class app extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //层叠布局
    var stack = new Stack(
      //对齐方式, 主轴和副轴
      alignment: const FractionalOffset(0.5, 0.8),
      children:<Widget> [
        //头像
        new CircleAvatar(
          backgroundImage: new NetworkImage('https://picabstract-preview-ftn.weiyun.com/'
                                            'ftn_pic_abs_v3/6d37e151e59ca439abe2654102a31'
                                            '63bee41ca67113bb3add51aa2fc9e16f27d0959cef2'
                                            'a9b3625f7174e0aa15dbd830?pictype=scale&from='
                                            '30113&version=3.3.3.3&uin=1170398847&fname='
                                            'httpi0.hdslb.combfsarticledc607d09ad1347811af3fdb.'
                                            'jpg&size=750miui.com%2Fforum%2F201311%2F27%2F22252'

                                            '6bjdipmjgzj1ibim7.jpg'),
          //弧度
          radius: 100.0,
        ),
        //容器
        new Container(
          decoration: new BoxDecoration(
            color: Colors.lightBlue,
          ),
          //边距
          padding: EdgeInsets.all(5.0),
          child: new Text("avatar"),
        )
      ],
    );
    return MaterialApp(
      title: "app",
      home: Scaffold(
        appBar: AppBar(
          title: new Text("层叠布局"),
        ),
       body: Center(
         //引入变量
        child: stack,
       )
      ),
    );
  }
}
```

**运行效果：**

![I@_7AC2_N~XHE_3__HLGPIW.png](https://i.loli.net/2020/10/25/3JaSbxOpoKWkl1g.png)

###  使用Positioned的方式：

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
void main(){
  runApp(app());
}

class app extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //层叠布局
    var stack = new Stack(
      //对齐方式, 主轴和副轴
      alignment: const FractionalOffset(0.5, 0.8),
      children:<Widget> [
        //头像
        new CircleAvatar(
          backgroundImage: new NetworkImage('https://picabstract-preview-ftn.weiyun.com/'
                                            'ftn_pic_abs_v3/6d37e151e59ca439abe2654102a31'
                                            '63bee41ca67113bb3add51aa2fc9e16f27d0959cef2'
                                            'a9b3625f7174e0aa15dbd830?pictype=scale&from='
                                            '30113&version=3.3.3.3&uin=1170398847&fname='
                                            'httpi0.hdslb.combfsarticledc607d09ad1347811af3fdb.'
                                            'jpg&size=750miui.com%2Fforum%2F201311%2F27%2F22252'

                                            '6bjdipmjgzj1ibim7.jpg'),
          //弧度
          radius: 100.0,
        ),
        new Positioned(
          //顶部
          top: 10.0,
          left: 85.0,
          child: new Text("avatar"),
        ),
        new Positioned(
          //底部
          bottom: 10.0,
          right: 85.0,
          child: new Text("头像"),
        )
      ],
    );
    return MaterialApp(
      title: "app",
      home: Scaffold(
        appBar: AppBar(
          title: new Text("层叠布局"),
        ),
       body: Center(
         //引入变量
        child: stack,
       )
      ),
    );
  }
}
```

**运行效果：**

![3TI7_N_@9KU~D~WOHY2M8_Q.png](https://i.loli.net/2020/10/25/sYnxMjTyRkudqa2.png)



##  卡片式布局：

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
void main(){
  runApp(app());
}

class app extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //卡片布局
    var card = new Card(
      child: Column(
        children:<Widget> [
          ListTile(
            //主标题
            title: new Text("重庆市夔牛科技有限公司",style: TextStyle(fontWeight: FontWeight.w500),),
            //副标题
            subtitle: new Text("陈先生:12345678911"),
            //图标
            leading: new Icon(Icons.account_box,color: Colors.lightBlue,),
          ),
          //分割线
          new Divider(),
          ListTile(
            //主标题
            title: new Text("重庆市夔牛科技有限公司",style: TextStyle(fontWeight: FontWeight.w500),),
            //副标题
            subtitle: new Text("陈先生:12345678911"),
            //图标
            leading: new Icon(Icons.account_box,color: Colors.lightBlue,),
          ),
          //分割线
          new Divider(),
          ListTile(
            //主标题
            title: new Text("重庆市夔牛科技有限公司",style: TextStyle(fontWeight: FontWeight.w500),),
            //副标题
            subtitle: new Text("陈先生:12345678911"),
            //图标
            leading: new Icon(Icons.account_box,color: Colors.lightBlue,),
          ),
          //分割线
          new Divider(),
          ListTile(
            //主标题
            title: new Text("重庆市夔牛科技有限公司",style: TextStyle(fontWeight: FontWeight.w500),),
            //副标题
            subtitle: new Text("陈先生:12345678911"),
            //图标
            leading: new Icon(Icons.account_box,color: Colors.lightBlue,),
          ),
          //分割线
          new Divider(),
          ListTile(
            //主标题
            title: new Text("重庆市夔牛科技有限公司",style: TextStyle(fontWeight: FontWeight.w500),),
            //副标题
            subtitle: new Text("陈先生:12345678911"),
            //图标
            leading: new Icon(Icons.account_box,color: Colors.lightBlue,),
          ),
          //分割线
          new Divider(),
          ListTile(
            //主标题
            title: new Text("重庆市夔牛科技有限公司",style: TextStyle(fontWeight: FontWeight.w500),),
            //副标题
            subtitle: new Text("陈先生:12345678911"),
            //图标
            leading: new Icon(Icons.account_box,color: Colors.lightBlue,),
          ),
        ],
      ),
    );
    return MaterialApp(
      title: "app",
      home: Scaffold(
        appBar: AppBar(
          title: new Text("卡片式布局"),
        ),
       body: Center(
         //引入变量
        child: card,
       )
      ),
    );
  }
}
```

**运行效果：**

![0NHQ56_6_WDKVY__KBPY1TP.png](https://i.loli.net/2020/10/25/znV2R6QlhJAqSuD.png)



##  RaisedButton按钮组件（页面跳转）:

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(new MaterialApp(
    title: "navigator",
    //这里需要一个Scaffold
    home: new FirstSreen(),
  ));
}

class FirstSreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //所以这里返回一个Scaffold
    return new  Scaffold(
      appBar: AppBar(
        title: new Text("导航页"),
        ),
      body: Center(
        //使用RaisedButton
        child: RaisedButton(
          //设置按钮的名称
          child: new Text("查看详情"),
          //绑定点击事件
          onPressed: (){
            Navigator.push(context, new MaterialPageRoute(
              //点击后去创建一个SecondScreen
              builder: (context) => new SecondScreen()
            ));
          },
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("详情页"),
      ),
      body: Center(
        child: RaisedButton(
          child: new Text("返回"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
```

**运行效果：**

#####  导航页：

![J4R7YOIGO@GAVXK`~NZ_`QO.png](https://i.loli.net/2020/10/25/nC2GxMYlryg7E4W.png)



#####  详情页：

![TUGVHTKQZ~1_E_@`A_ECS@A.png](https://i.loli.net/2020/10/25/WZ6NYiLPnDrEwHF.png)



##  导航参数的传递：

```dart
import 'package:flutter/material.dart';
class Product{
  final String title;
  final String description;
  Product(this.title,this.description);
}

void main(){
  runApp(MaterialApp(
    title: "app",
    home: ProductList(
      products:List.generate(11,
              (i) => Product('商品 $i', '这是一个商品详情页，标号为$i'))
    ),
  ));
}

class ProductList extends StatelessWidget{
  final List<Product> products;
  ProductList({Key key,@required this.products}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("商品列表"),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context,index){
          return ListTile(
            title: new Text(products[index].title),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => new ProductDetail(product: products[index])
              ));
            },
          );
        },
      ),
    );
  }
}

class ProductDetail extends StatelessWidget{
  final Product product;
  ProductDetail({Key key,@required this.product}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('${product.description}'),
      ),
      body: Center(
        child: new Text('${product.description}'),
      ),
    );
  }
}
```

**运行效果：**

#####  导航页：

![_LGP_I_XLJW2_L8KY3__AM5.png](https://i.loli.net/2020/10/26/VIugYDXtUZMe3dz.png)

**详情页：**

![RRNR_PM_R_1F_XMQRP_7_G5.png](https://i.loli.net/2020/10/26/dHgSq1rWiNzbKe5.png)

