---
title: "Markdown 编辑数学公式"
layout: page
date: 2017-06-02 00:00
---
[TOC]
# 写在前面
在markdown下写文章比较方便，但对于初学者而言数学表达式的编写还是有点困难的，本文记载了markdown中的一些常用的数学表达式的编码规则，这种编码规则使用的时LaTeX的编码规则，了解一些常见的编码规则，可以为自己的工作带来便利。


# 基本用法
行间公式：
```
$$
"公式"
$$

```
行内公式:```$"公式"$```  注：有的地方可能需要用小括号将公式括起来：```$("公式")$``` 

# 常见的转字符

- 求和: \sum_{i=1}^n{x_i}  ($(\sum_{i=1}^n{x_i})$)

- 趋近于: \to  ($(\to)$)

- 根号: \sqrt{x} ($(\sqrt{x})$)

- n次根号:\sqrt[n]{x}  ($(\sqrt[n]{x})$)

- 无穷大: \infty ($(\infty)$)

- 二元关系: \times ($(\times)$), \div ($(\div)$), \pm ($(\pm)$), \circ ($(\circ)$), \cdot ($(\cdot)$)

- 关系运算符：如\leq(≤), \geq(≥), \subset(⊂), \supset(⊃), \in(∈), \bigcup $(\bigcup)$, \bigcap $(\bigcap)$, \iint $(\iint)$, \int $(\int)$; 

- 否定关系运算符：如\not=(≠), \not<(≮), \not\supset (⊅); 

- 箭头, \leftarrow(←), \rightarrow(→), \longrightarrow(⟶), \uparrow(↑)等; 

- 上标, ^ ($(a^2)$) 下标, _ , ($(a_2)$). 如果上下标的内容多于一个字符,需要用()将这些内容扩成一个整体,上下标也可以嵌套,也可以同时使用. 例如:

$$ x^{y^z}=(1+{\rm e}^x)^{-2xy^w} $$


- 绝对值， \vert{x}\vert ($(\vert{x}\vert)$), \Vert{x}\Vert ($(\Vert{x}\Vert)$), \langle{x}\rangle ($(\langle{x}\rangle)$)

- 其它符号, \nabla(∇), \angle(∠), \forall(∀), \exists(∃), \prime(导数的撇′). 

- 而对于专有名词,如一些函数名, 如sin x中的sin, 就要用罗马体, 而不是一般的数学斜体排印,我们可以用sinx, 也可以用TeX提供的直接在函数名前加”\”的方法: sinx,一般的函数均有定义, 如\sin, \cos, \lim, \log等.

- 括号和分隔符

|           显示         |          输入        |
|:---------------------:|:-------------------:|
|$$\langle表达式\rangle$$|$\langle表达式\rangle$|
|$$\lceil表达式\rceil$$|$\lceil表达式\rceil$|
|$$\lfloor表达式\rfloor$$|$\lfloor表达式\rfloor$|
|$$\lbrace表达式\rbrace$$|$\lbrace表达式\rbrace$|

# 希腊字母

| 字母名称 | 大写 | markdown语法 | 小写 | markdown语法|
| :-------: |:---:| :--------:|:----:| :-------:|
|alpha |$(A)$|A|$(\alpha)$|\alpha|
|beta|$(B)$|B|$(\beta)$|\beta|
|gamma|$(\Gamma)$|\Gamma|$(\gamma)$|\gamma|
||$(\varGamma)$|\varGamma|||
|delta|$(\Delta)$|\Delta|$(\delta)$|\delta|
|epsilon|$(E)$|E|$(\epsilon)$|\epsilon|
||||$(\varepsilon)$|\varepsilon|
|zeta|$(Z)$|Z|$(\zeta)$|\zeta|
|eta|$(E)$|E|$(\eta)$|\eta|
|theta|$(\Theta)$|\Theta|$(\theta)$|\theta|
|iota|$(I)$|I|$(\iota)$|\iota|
|kappa|$(K)$|K|$(\kappa)$|\kappa|
|lambda|$(\Lambda)$|\Lambda|$(\lambda)$|\lambda|
|Mu|$(M)$|M|$(\mu)$	|\mu|
|nu|$(N)$|N|$(\nu)$|\nu|
|xi|$(\Xi)$|\Xi|$(\Xi)$|\xi|
|omicron|$(O)$|O|$(\omicron)$|\omicron|
|pi|$(Pi)$|	\Pi|$(\pi)$|pi|
|rho|$(P)$|	P|$(\rho)$|\rho|
|sigma|$(\Sigma)$|\Sigma|$(\sigma)$|\sigma|
|tau|$(T)$|T|$(\tau)$|\tau|
|upsilon|$(\Upsilon)$|\Upsilon|$(\upsilon)$|\upsilon|
|phi|$(\Phi)$|\Phi|$(\phi)$|\phi|
||$(\varPhi)$|\varPhi|$(\varphi)$|\varphi|
|chi|$(X)$|X|$(\chi)$|\chi|
|psi|$(\Psi)$|\Psi|$(\psi)$|\psi|

# 字体
- Use \mathbb or \Bbb for "blackboard bold":

    - $(\mathbb{abcefghijklmnopqrstuvwxyz})$
    - $(\mathbb{ABCDEFGHIJKLMNOPQRSTUVWXYZ})$

- Use \mathbf for boldface:
    - $(\mathbf{abcefghijklmnopqrstuvwxyz})$.
    - $(\mathbf{ABCDEFGHIJKLMNOPQRSTUVWXYZ})$.

- Use \mathtt for "typewriter" font:
    - $(\mathtt{abcefghijklmnopqrstuvwxyz})$
    - $(\mathtt{ABCDEFGHIJKLMNOPQRSTUVWXYZ})$

- Use \mathrm for roman font:
    - $(\mathrm{abcefghijklmnopqrstuvwxyz})$
    - $(\mathrm{ABCDEFGHIJKLMNOPQRSTUVWXYZ})$

- Use \mathsf for sans-serif font:
    - $(\mathsf{abcefghijklmnopqrstuvwxyz})$
    - $(\mathsf{ABCDEFGHIJKLMNOPQRSTUVWXYZ})$

- Use \mathcal for "calligraphic" letters:
    - $(\mathcal{abcefghijklmnopqrstuvwxyz})$
    - $(\mathcal{ABCDEFGHIJKLMNOPQRSTUVWXYZ})$

- Use \mathscr for script letters:
    - $(\mathscr{abcefghijklmnopqrstuvwxyz})$
    - $(\mathscr{ABCDEFGHIJKLMNOPQRSTUVWXYZ})$
    
- Use \mathfrak for "Fraktur" (old German style) letters:
    - $(\mathfrak{abcefghijklmnopqrstuvwxyz})$
    - $(\mathfrak{ABCDEFGHIJKLMNOPQRSTUVWXYZ})$

# 常见的表达式

- 分数：$$\frac{a+1}{a-1}$$
语法：

``` 
$$\frac{a+1}{a-1}$$
```
 
- $$\sum_{i=0}^n {i^2} ={\frac{(i+1)(i^2+6)}{i-1}}$$
语法：
```
\sum_{i=0}^n {i^2} ={\frac{(i+1)(i^2+6)}{i-1}}
```
- 分段函数

语法: 
```
$$函数名=\begin{cases}
公式1 & 条件1 \\
公式2 & 条件2 \\
公式3 & 条件3 
\end{cases}$$
```

$$
函数名 = \begin{cases}
公式1 & 条件1 \\
公式2 & 条件2 \\
公式3 & 条件3
\end{cases}
$$


# 参考文献
[MarkDown(LaTex) 数学公式](http://blog.csdn.net/Linear_Luo/article/details/52224996)

[MATHEMATICS meta](https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference)

[Markdown公式编辑学习笔记](https://www.cnblogs.com/q735613050/p/7253073.html)