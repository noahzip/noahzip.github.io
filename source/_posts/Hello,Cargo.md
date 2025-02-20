---
layout: posts
title: Hello,Cargo!
date: 2025-02-20 15:34:57
updated: 2025-02-20 15:34:57
tags: 
categories: 
 - Rust
---

## 1.简介

```c
  Cargo 是 Rust 的构建系统和包管理器。大多数 Rustacean 们使用 Cargo 来管理他们的 Rust 项目，因为它可以为你处理很多任务，比如构建代码、下载依赖库，以及编译这些库。（我们把代码所需要的库叫做依赖（dependency））。
  
  如果使用“安装” 部分介绍的官方安装包的话，则自带了 Cargo。如果通过其他方式安装的话，可以在终端输入如下命令检查是否安装了 Cargo：
$ cargo --version
```

## 2.使用 Cargo 创建项目


这行命令新建了名为 hello_cargo 的项目，并且Cargo在一个同名目录中创建项目文件。

```cmd
#我们使用 Cargo 创建一个新项目
$ cargo new hello_cargo
```

## 3.目录结构

进入 *hello_cargo* 目录并列出文件。将会看到 Cargo 生成了两个文件和一个目录：一个 *Cargo.toml* 文件，一个 *src* 目录，以及位于 *src* 目录中的 *main.rs* 文件。

它也在 *hello_cargo* 目录初始化了一个 Git 仓库，并带有一个 *.gitignore* 文件。如果在现有的 Git 仓库中运行 `cargo new`，则不会生成 Git 文件；但你可以使用 `cargo new --vcs=git` 来无视此限制，强制生成 Git 文件。

```cmd
$ cd hello_cargo
$ hello_cargo dir
    2025/02/20  15:35    <DIR>          .
    2025/02/20  15:35    <DIR>          ..
    2025/02/20  15:35                 8 .gitignore
    2025/02/20  15:35                81 Cargo.toml
    2025/02/20  15:35    <DIR>          src
```

### 3.1*Cargo.toml* 文件：

```
#[package]，是一个表块（section）标题，表明下面的语句用来配置一个包（package）。随着我们在这个文件增加更多的信息，还将增加其他表块。
[package] 
#项目名称
name = "hello_cargo"
#项目版本号
version = "0.1.0"
#使用的 Rust 大版本号
edition = "2021"

[dependencies]
```

### 3.2 *src/main.rs* 

```rust
fn main() {
    println!("Hello, world!");
}
```

## 4.构建并运行 Cargo 项目

```cmd
cargo build
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 2.85 secs
```

这个命令会在 *target\debug\hello_cargo.exe*创建一个可执行文件你可以使用下面的命令来运行它：

```cmd
$ .\target\debug\hello_cargo.exe
Hello, world!
```

我们刚刚使用 cargo build 构建了项目，并使用 ./target/debug/hello_cargo 运行了程序，但是，我们也可以使用 cargo run 命令，一次性完成代码编译和运行的操作：

```cmd
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

## 5发布构建

当项目最终准备好发布时，可以使用 `cargo build --release` 来优化编译项目。这会在 *target/release* 而不是 *target/debug* 下生成可执行文件。这些优化可以让 Rust 代码运行的更快，不过启用这些优化也需要消耗更长的编译时间。