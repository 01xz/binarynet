# Verilog 编码规范指南

## 1. 基础规范

### 1.1 文件拓展名

本规范使用的文件扩展名如下：

- `.v`  表示一个包含模块定义的Verilog-2001文件
- `.vh` 表示一个Verilo-2001头文件

只有`.v`文件是用来作为编译单元的。`.vh`文件只能被包含在其它文件中。

除了网表文件外，每个`.v`文件应该只包含一个模块，并且名称应该是相关的。例如，文件`foo.v`应该只包含模块`foo`。

### 1.2 文件通用规范

- 字符编码：无论使用中文或英文注释，统一使用`UTF-8`编码。
- 换行：LF，即使用`\n`换行。(Windows操作系统为CRLF)
- POSIX文件结尾：非空文件的所有行以`\n`结尾。
- 单行最大字符数：单行字符数不得超过100。
- 不使用Tabs：不要在任何地方使用Tabs。
- 无尾部空格：每行的行尾不要留有空格。

### 1.3 begin / end

以所示方式使用`begin`和`end`，除非整条语句可以被写进同一行。

&#x1f44d;
```verilog {.good}
// Wrapped procedural block requires begin and end.
always @(posedge clk) begin
  q <= d;
end
```

&#x1f44d;
```verilog {.good}
// The exception case, where begin and end may be omitted as the entire
// structure fits on a single line.
always @(posedge clk) q <= d;
```

&#x1f44e;
```verilog {.bad}
// Incorrect because a wrapped statement must have begin and end.
always @(posedge clk)
  q <= d;
```

`begin`必须与前面的关键字在同一行，并作为该行的结尾。

`end`必须开始在一个新的行。`end else begin`必须一起在同一行。

&#x1f44d;
```verilog {.good}
// "end else begin" are on the same line.
if (condition) begin
  foo = bar;
end else begin
  foo = bum;
end
```

&#x1f44d;
```verilog {.good}
// begin/end are omitted because each semicolon-terminated statement fits on
// a single line.
if (condition) foo = bar;
else foo = bum;
```

&#x1f44e;
```verilog {.bad}
// Incorrect because "else" must be on the same line as "end".
if (condition) begin
  foo = bar;
end
else begin
  foo = bum;
end
```

上述风格也适用于case语句中的单个条件选项。

如果单个条件选项和对应的表达式都在一行中，可以省略`begin`和`end`。

否则，请在与条件选项相同的行中使用`begin`关键字，如下文所示。

&#x1f44d;
```verilog {.good}
// Consistent use of begin and end for each case item is good.
case (state_q)
  StIdle: begin
    state_d = StA;
  end
  StA: begin
    state_d = StB;
  end
  StB: begin
    state_d = StIdle;
    foo = bar;
  end
  default: begin
    state_d = StIdle;
  end
endcase
```

&#x1f44d;
```verilog {.good}
// Case items that fit on a single line may omit begin and end.
case (state_q)
  StIdle: state_d = StA;
  StA: state_d = StB;
  StB: begin
    state_d = StIdle;
    foo = bar;
  end
  default: state_d = StIdle;
endcase
```

&#x1f44e;
```verilog {.bad}
case (state_q)
  StIdle:           // These lines are incorrect because we should not wrap
    state_d = StA;  // case items at a block boundary without using begin
  StA:              // and end.  Case items should fit on a single line, or
    state_d = StB;  // else the procedural block must have begin and end.
  StB: begin
    foo = bar;
    state_d = StIdle;
  end
  default: begin
    state_d = StIdle;
  end
endcase
```

### 1.4 缩进

- 每级缩进使用两个空格，不要使用tabs。可以通过设置代码编辑器来实现在敲下tabs键时输入两个空格。
- 在如下`关键字对`中使用缩进：
  - `begin` / `end`
  - `module` / `endmodule`
  - `function` / `endfunction`
- 表达式太长时，可以将表达式的其余部分写至下一行，并使用四个空格缩进，如下：

&#x1f44d;

```verilog {.good}
assign zulu = enabled && (
    alpha < bravo &&
    charlie < delta
);
```

- 或为提高可读性，使用如下方式缩进：

&#x1f44d;

```verilog {.good}
assign zulu = enabled && (alpha < bravo &&
                          charlie < delta);
```

### 1.5 空格

- 对于一行中使用逗号分隔的多个元素，必须在逗号和下一个字母间使用空格。为增加可读性而使用的空格也是被允许的。

&#x1f44d;
```verilog {.good}
bus = {addr, parity, data};
a = myfunc(lorem, ipsum, dolor, sit, amet, consectetur, adipiscing, elit,
           rhoncus);
mymodule mymodule(.a(a), .b(b));
```

&#x1f44e;
```verilog {.bad}
bus = {parity,data};
a = myfunc(a,b,c);
mymodule mymodule(.a(a),.b(b));
```

- 表格对齐：本指南推荐对具有相似内容的行进行分组，通过插入空格实现表格式对齐。

&#x1f44d;

```verilog
logic [7:0]  my_interface_data;
logic [15:0] my_interface_address;
logic        my_interface_enable;

logic       another_signal;
logic [7:0] something_else;
```

&#x1f44d;

```verilog
mod u_mod (
  .clk_i,
  .rst_ni,
  .sig_i          (my_signal_in),
  .sig2_i         (my_signal_out),
  // comment with no blank line maintains the block
  .in_same_block_i(my_signal_in),
  .sig3_i         (something),

  .in_another_block_i(my_signal_in),
  .sig4_i            (something)
);
```

- 表达式：所有双目运算符两侧均使用空格。

&#x1f44d;

```verilog {.good}
assign a = ((addr & mask) == My_addr) ? b[1] : ~b[0];  // good
```

&#x1f44e;

```verilog {.bad}
assign a=((addr&mask)==My_addr)?b[1]:~b[0];  // bad
```

**注：** 声明向量时，为使内容更紧凑，可以不使用空格。

&#x1f44d;

```verilog {.good}
wire [WIDTH-1:0] foo;   // this is acceptable
wire [WIDTH - 1 : 0] foo;  // fine also, but not necessary
```

当把含条件运算符的表达式分割成多行时，使用类似于等价的if-then-else行的格式。如：

&#x1f44d;

```verilog {.good}
assign a = ((addr & mask) == `MY_ADDRESS) ?
           matches_value :
           doesnt_match_value;
```

 

### 1.6 圆括号

### 1.7 注释

### 1.8 模板

## 2. 命名



## 3. 语言特性

## Reference
