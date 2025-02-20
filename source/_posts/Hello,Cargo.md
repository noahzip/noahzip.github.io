---
layout: posts
title: Hello, Cargo!
date: 2025-02-20 15:34:57
updated: 2025-02-20 15:34:57
tags: 
categories: 
  - Rust
---

## 1. 简介

Cargo 是 Rust 的构建系统和包管理器。大多数 Rustacean 们使用 Cargo 来管理他们的 Rust 项目，因为它可以为你处理很多任务，比如构建代码、下载依赖库，以及编译这些库。（我们把代码所需要的库叫做依赖 `dependency`）。

如果使用官方安装包进行安装，Cargo 会自动安装。如果通过其他方式安装，可以在终端输入以下命令检查是否安装了 Cargo：

```bash
$ cargo --version
```

## 2. 使用 Cargo 创建项目

通过以下命令，我们可以创建一个名为 `hello_cargo` 的项目，并且 Cargo 会在一个同名目录中生成项目文件。

```bash
# 使用 Cargo 创建一个新项目
$ cargo new hello_cargo
```

## 3. 目录结构

进入 `hello_cargo` 目录并列出文件，你将看到 Cargo 生成了两个文件和一个目录：

- `Cargo.toml` 文件
- `src` 目录
- 位于 `src` 目录中的 `main.rs` 文件

此外，Cargo 还在 `hello_cargo` 目录初始化了一个 Git 仓库，并带有一个 `.gitignore` 文件。如果你在已有 Git 仓库中运行 `cargo new`，则不会自动生成 Git 文件；但你可以通过 `cargo new --vcs=git` 强制生成 Git 文件。

```bash
$ cd hello_cargo
$ dir
2025/02/20  15:35    <DIR>          .
2025/02/20  15:35    <DIR>          ..
2025/02/20  15:35                 8 .gitignore
2025/02/20  15:35                81 Cargo.toml
2025/02/20  15:35    <DIR>          src
```

### 3.1 `Cargo.toml` 文件

`Cargo.toml` 文件的主要配置项如下：

```toml
#[package] 是一个表块（section）标题，表明下面的语句用于配置一个包（package）。
[package] 
# 项目名称
name = "hello_cargo"
# 项目版本号
version = "0.1.0"
# 使用的 Rust 大版本号
edition = "2021"

[dependencies]
```

### 3.2 `src/main.rs`

在 `src/main.rs` 中，你会看到一个简单的 Rust 程序：

```rust
fn main() {
    println!("Hello, world!");
}
```

## 4. 构建并运行 Cargo 项目

在命令行中运行以下命令来构建项目：

```bash
cargo build
```

输出类似于：

```bash
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 2.85 secs
```

这个命令会在 `target/debug/hello_cargo.exe` 下生成一个可执行文件。你可以使用以下命令来运行它：

```bash
$ .\target\debug\hello_cargo.exe
Hello, world!
```

当然，我们也可以使用 `cargo run` 命令，它会自动完成编译和运行的操作：

```bash
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

## 5. 发布构建

当项目最终准备好发布时，你可以使用 `cargo build --release` 来优化编译项目。这样会在 `target/release` 目录下生成一个优化过的可执行文件。启用这些优化可以让 Rust 代码运行得更快，但需要更多的编译时间。

```bash
cargo build --release
```