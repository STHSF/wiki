---
title: "Markdown 编辑数学公式"
layout: page
date: 2099-06-02 00:00
---

# 写在前面
在markdown下写文章比较方便，但对于初学者而言数学表达式的编写还是有点困难的，本文记载了markdown中的一些常用的数学表达式的编码规则，这种编码规则使用的时LaTeX的编码规则，了解一些常见的编码规则，可以为自己的工作带来便利。


# 基本用法
行间公式：
```
$$
"公式"
$$

```
行内公式:```$"公式"$```

# 常见的转字符

- 求和: \sum_{i=1}^n{x_i}  ($(\sum_{i=1}^n{x_i})$)
- 趋近于: \to  ($(\to)$)
- 无穷大: \infty ($(\infty)$)
- 二元关系: \times ($(\times)$), \div ($(\div)$), \pm ($(\pm)$), \circ ($(\circ)$), \cdot ($(\cdot)$)
- 关系运算符：如\leq(≤), \geq(≥), \subset(⊂), \supset(⊃), \in(∈); 
- 否定关系运算符：如\not=(≠), \not<(≮), \not\supset (⊅); 
- 箭头, \leftarrow(←), \rightarrow(→), \longrightarrow(⟶), \uparrow(↑)等; 
- 其它符号, \nabla(∇), \angle(∠), \forall(∀), \exists(∃), \prime(导数的撇′). 
- 而对于专有名词,如一些函数名, 如sin x中的sin, 就要用罗马体, 而不是一般的数学斜体排印,我们可以用sinx, 也可以用TeX提供的直接在函数名前加”\”的方法: sinx,一般的函数均有定义, 如\sin, \cos, \lim, \log等.

# 参考文献
[MarkDown(LaTex) 数学公式](http://blog.csdn.net/Linear_Luo/article/details/52224996)