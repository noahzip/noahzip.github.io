---
layout: posts
title: Guess Number
date: 2025-02-20 16:34:57
updated: 2025-02-20 16:34:57
tags: 
categories: 
 - Rust

---

### 1. **项目结构与初始化**

- 创建新项目：通过 `cargo new guessing_game` 命令创建一个名为 `guessing_game` 的 Rust 项目。
- 项目包含的文件：
  - `Cargo.toml`：项目的元数据文件，包含项目的配置信息。
  - `src/main.rs`：主程序代码文件，包含游戏逻辑。

### 2. **基本功能实现**

- **导入标准库**：使用 `std::io` 来处理输入输出，使用 `rand` 库来生成随机数。
- **生成随机数**：通过 `rand::Rng` 生成一个 1 到 100 的随机数，作为秘密数字。
- **循环猜测**：使用 `loop` 创建一个无限循环，不断提示用户输入并根据输入与随机数进行比较。
- **输入读取**：使用 `io::stdin().read_line(&mut guess)` 获取用户输入，存储到 `guess` 变量中。
- **输入解析**：将用户输入的字符串转换为 `u32` 类型，处理错误输入。

### 3. **猜测的比较与反馈**

- 使用 `match` 来比较用户的输入与随机数：

  - `Ordering::Less`：猜的数字太小，输出 "Too small"。
  - `Ordering::Greater`：猜的数字太大，输出 "Too big"。
  - `Ordering::Equal`：猜对了，输出 "You win!" 并结束游戏。

### 4. **错误处理与优化**

- **处理无效输入**：如果用户输入的不是数字，程序会提示并继续请求输入。

- **优化输入验证**：确保用户输入的值是有效的数字，若无效则跳过本次循环，继续请求有效输入。

### 5. **完整代码示例**

```rust
use std::{cmp::Ordering, io};

use rand::Rng;

fn main() {
    println!("Hello, world! This is my Rust application!");

    // 生成一个 1 到 100 的随机数作为猜谜的正确答案
    let secret_number:u32 = rand::thread_rng().gen_range(1..100);

    loop {
         // 初始化一个字符串，用于存储用户的输入
        let mut guess = String::new();

        println!("Please input a number!");

        // 读取用户输入的数字
        io::stdin().read_line(&mut guess).expect("Read Error!");

        // 尝试将输入的内容转换为数字（u32类型），如果失败则跳过本次循环
        let guess:u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_)=>{
                println!("Input a number!");
                continue;
            }
        };
        println!("u guess number: {}",guess);

         // 与秘密数字进行比较
        match guess.cmp(&secret_number) {
            Ordering::Less => println!("To small"),
            Ordering::Greater => println!("To big"),
            Ordering::Equal => {
                println!("U win!");
                 // 猜对了，退出循环
                break;
            }
        }
    }
}
```

