---
layout: posts
title: Rust 安装与 HelloWorld
date: 2025-02-20 14:14:57
updated: 2025-02-20 14:14:57
tags: 
categories: 
  - Rust

---

## 1. 官方文档安装指引

可以通过以下链接访问 Rust 官方的安装文档：

[官方安装文档](https://doc.rust-lang.org/stable/book/ch01-01-installation.html)

![官方安装页面](https://raw.githubusercontent.com/NoahChen1994/picgo/main/img/image-20250220130852361.png)

### 1.1 Windows 系统安装页面

对于 Windows 用户，可以访问以下链接下载适用于 Windows 系统的安装工具：

[Windows 安装页面](https://www.rust-lang.org/tools/install)

![Windows 安装页面](https://raw.githubusercontent.com/NoahChen1994/picgo/main/img/rust安装页面-20250220132838413.png)

### 1.2 选择适合的版本下载

根据系统版本选择适合的安装包。如果你使用的是 Windows 10 64 位版本，选择 **DOWNLOAD RUSTUP-INIT.EXE (64-BIT)**。

## 2. 配置 Rust 安装下载源

Rust 安装过程中会使用网络下载文件，默认从国外源下载，为了加速下载，可以配置 Rust 镜像源。配置步骤如下：

Rust Toolchain 反向代理链接：[Rust Toolchain 反向代理](https://mirrors.ustc.edu.cn/help/rust-static.html)

你需要配置以下环境变量：

- `RUSTUP_DIST_SERVER`：指向镜像源，默认指向 `https://static.rust-lang.org`
- `RUSTUP_UPDATE_ROOT`：用于 Rust 安装更新，默认指向 `https://static.rust-lang.org/rustup`

### 配置国内源

你可以选择以下镜像源，并在环境变量中进行配置：

- **清华大学镜像**：

  ```bash
  RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
  ```

- **中国科学技术大学镜像**：

  ```bash
  RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
  RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
  ```

- **上海交通大学镜像**：

  ```bash
  RUSTUP_DIST_SERVER=https://mirrors.sjtug.sjtu.edu.cn/rust-static/
  ```

## 3. 运行 `rustup-init.exe` 安装程序

下载并运行 `rustup-init.exe` 安装程序，进入安装界面后，输入 `1` 并回车继续：

```bash
# 输入 1 并回车
```

安装过程中，程序会提示安装 Visual Studio，按提示完成安装，安装完 Visual Studio 后，继续安装 Rust。

![运行 rustup-init.exe 安装程序](https://raw.githubusercontent.com/NoahChen1994/picgo/main/img/运行 rustup-init.exe 安装程序-20250220133345748.png)

## 4. 配置 Cargo 的国内镜像源

Rust 安装完成后，用户目录下会出现 `.cargo` 文件夹，我们需要在 `.cargo` 文件夹下创建 `config.toml` 文件，并添加如下配置来加速 Cargo 下载依赖：

```bash
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"

# 替换成你偏好的镜像源
replace-with = 'tuna'

# 清华大学镜像
[source.tuna]
registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"

# 中国科学技术大学镜像
[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"

# 上海交通大学镜像
[source.sjtu]
registry = "https://mirrors.sjtug.sjtu.edu.cn/git/crates.io-index"

# rustcc社区镜像
[source.rustcc]
registry = "git://crates.rustcc.cn/crates.io-index"
```

## 5. HelloWorld 示例

创建一个新的 Rust 项目并运行一个简单的 "Hello, World!" 程序：

```bash
初始化一个 Rust 项目
$ cargo new HelloWorld
```

查看项目目录结构：

```bash
D:\study\rust-study\HelloWorld>dir
     D:\study\rust-study\HelloWorld 的目录
    2025/02/20  12:35    <DIR>          .
    2025/02/20  12:35    <DIR>          ..
    2025/02/20  12:35                 8 .gitignore
    2025/02/20  12:35                81 Cargo.toml
    2025/02/20  12:35    <DIR>          src
                   2 个文件             89 字节
                   3 个目录 305,301,803,008 可用字节
```

运行项目：

```bash
$ cargo run
   Compiling HelloWorld v0.1.0 (D:\study\rust-study\HelloWorld)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.30s
     Running `target\debug\HelloWorld.exe`
    Hello, world!
```
