---
layout: posts
title: 关于element 文件上传出现跨域问题
date: 2020-03-03 20:31:02
updated: 2020-03-03 20:31:02
tags: 
categories: 
 - Java
---
控制台报错：

    Access to XMLHttpRequest at 'http://localhost:9001/eduvideo/uploadAliyunVideo' from origin 'http://localhost:9528' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.
    Failed to load resource: net::ERR_FAILED
### 问题排查：

### 1.检查后端代码：

```java
//可以发现已标注跨域注解@CrossOrigin
@CrossOrigin
@RestController
@RequestMapping("/eduvideo")

public class VideoController {

    @Autowired
    VideoService videoService;
    
    //上传视频到阿里云
    @PostMapping("uploadAliyunVideo")
    public R uploadAliyunVideo(MultipartFile file){
	    String videoId = videoService.uploadAliyunVideo(file);
	    return R.ok().data("items",videoId);
	}
}
```

### 2.使用swagger文档测试结果正常，那么问题一定在前台

### 3.检查前台代码
```html
<el-form-item label="上传视频">
<el-upload
  class="upload-demo"
  action='http://localhost:9001/eduvideo/uploadAliyunVideo'
  :on-success="handleVodUploadSuccess"
   :on-exceed="handleUploadExceed"
  :file-list="fileList">
  <el-button size="small" type="primary">上传视频</el-button>
 <div slot="content">最大支持1G，<br>
支持3GP、ASF、AVI、DAT、DV、FLV、F4V、<br>
GIF、M2T、M4V、MJ2、MJPEG、MKV、MOV、MP4、<br>
MPE、MPG、MPEG、MTS、OGG、QT、RM、RMVB、<br>
SWF、TS、VOB、WMV、WEBM 等视频格式上传</div>
<i class="el-icon-question"/>
</el-upload> 
```
#### *3.1
    首先该段代码复制于element官方文档只修改了action属性
    应该不会是代码本身的问题
    那么只能是人为写错路径造成的吗？但为什么不是404？
#### *3.2
	通过百度、谷歌搜索国内外论坛相关问题，基本上所有的回答都牛头不对马嘴。在国外某论坛看到一个猜想：
			会不会是element本身禁止跨域请求？
#### *3.3 通过文档定义到配置文件 修改代理配置项
入口：config ====> index.js

```html
	//target 对应要代理的路径
 proxyTable: {
  '/api': {
	target: 'http://localhost:9001/eduvideo/uploadAliyunVideo',
    changeOrigin: true,
    pathRewrite: {
      '^/api': ''
    }
  },
},
```
#### *3.4 修改接口调用 固定写法
	 action='/api'
#### *3.5 重启前端项目 进行测试 
	//之前的跨域报错消失了
	//出现了一个新的报错
	element-ui.common.js:25924 POST http://localhost:9528/api 413 (Request Entity Too Large)
#### *3.6 报错定位为服务器端问题

###  413报错原因：
	由于是多模块项目使用nginx进行了代理
	而nginx文件上传默认最大值为1024*1024字节 也就是1MB
#### 解决方法：
	修改nginx配置文件 在 http 内添加
		http {
		    ...
			client_max_body_size 1024m;
			...
		}

### 至此问题解决！

​		 