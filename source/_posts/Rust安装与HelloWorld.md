---
layout: posts
title: Rust安装与HelloWorld
date: 2025-02-20 14:14:57
updated: 2025-02-20 14:14:57
tags: 
categories: 
 - Rust
---

## 1.官方文档安装指引

```
https://doc.rust-lang.org/stable/book/ch01-01-installation.html
```

![官方安装页面](https://raw.githubusercontent.com/NoahChen1994/picgo/main/img/image-20250220130852361.png)



### 1.1windows系统安装页面

```
https://www.rust-lang.org/tools/install
```

![image-20250220132838413](https://raw.githubusercontent.com/NoahChen1994/picgo/main/img/rust安装页面-20250220132838413.png)

### 1.12选择适合的版本下载

```
我的系统是windows10 64位 选择 DOWNLOAD RUSTUP-INIT.EXE (64-BIT)
```

## 2.配置 rust 安装下载源

```
Rust Toolchain 反向代理
​mirrors.ustc.edu.cn/help/rust-static.html

由于 rust 安装过程中会使用网络下载文件，默认从国外下载，所以我们需要配置 rust 安装镜像源。

我们需要配置环境变量 RUSTUP_DIST_SERVER（默认指向 https://static.rust-lang.org）和 RUSTUP_UPDATE_ROOT （默认指向https://static.rust-lang.org/rustup），让其指向国内源。
配置位置：环境变量->新建 

# 清华大学
RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup

# 中国科学技术大学
RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# 上海交通大学
RUSTUP_DIST_SERVER=https://mirrors.sjtug.sjtu.edu.cn/rust-static/
```

## 3. 运行 rustup-init.exe 安装程序

```
进入安装界面，输入 1 并回车：
```

![image-20250220133345748](https://raw.githubusercontent.com/NoahChen1994/picgo/main/img/运行 rustup-init.exe 安装程序-20250220133345748.png)

```
然后会安装 Visual Studio 根据提示操作即可，Visual studio安装完成后回回到之前的安装界面，回车继续即可
```

## 4.我们还需要配置 cargo 的国内镜像源

```toml
rust 安装完成后，我们的用户目录下会出现 .cargo 文件夹，我们需要在 .cargo 文件夹下新建 config.toml 文件加入如下配置：
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"

# 替换成你偏好的镜像源
replace-with = 'tuna'

# 清华大学
[source.tuna]
registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"

# 中国科学技术大学
[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"

# 上海交通大学
[source.sjtu]
registry = "https://mirrors.sjtug.sjtu.edu.cn/git/crates.io-index"

# rustcc社区
[source.rustcc]
registry = "git://crates.rustcc.cn/crates.io-index"
```

## 5.helloworld

```cmd
# 初始化一个rust项目
cargo new HelloWorld 

# 查看目录结构
D:\study\rust-study\HelloWorld>dir
     D:\study\rust-study\HelloWorld 的目录
    2025/02/20  12:35    <DIR>          .
    2025/02/20  12:35    <DIR>          ..
    2025/02/20  12:35                 8 .gitignore
    2025/02/20  12:35                81 Cargo.toml
    2025/02/20  12:35    <DIR>          src
                   2 个文件             89 字节
                   3 个目录 305,301,803,008 可用字节
                   
# 运行
D:\study\rust-study\HelloWorld>cargo run
   Compiling HelloWorld v0.1.0 (D:\study\rust-study\HelloWorld)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.30s
     Running `target\debug\HelloWorld.exe`
	Hello, world!
```

