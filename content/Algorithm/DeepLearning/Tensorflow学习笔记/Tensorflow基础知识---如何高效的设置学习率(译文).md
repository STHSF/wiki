---
title: "Tensorflow基础知识---如何高效的设置学习率(译文)"
layout: page
date: 2018-02-08 00:00
---

[TOC]

# 写在前面
本文是翻译一篇来自Hafidz Zulkifli的一篇博文[Understanding Learning Rates and How It Improves Performance in Deep Learning](https://towardsdatascience.com/understanding-learning-rates-and-how-it-improves-performance-in-deep-learning-d0d4059c1c10)
这片文章介绍了机器学习中测学习速率的基本概念，以及不同的学习速率对模型loss的影响。有助于我们更好的了解机器学习建模过程。

# 序言
这篇文章讨论我对下面一些主题的理解：
- 什么是学习速率？设置学习速率的意义？
- 如何有效的找到好的学习速率？
- 为什么要在训练过程中调整学习速率？
- 当使用训练好的模型继续训练时应该如何处理学习速率？

本文的大部分内容都是参考之前发表在fast.ai上面的东西[1][2][3][5], 这些是一个简略的版本，方便大家能够快速的掌握其精髓所在。更详细的内容可以参考参考文献。

# 首先，什么是学习速率
学习速率是一个超参数(hyper-patameter), 他是用来调整在网络中计算权重的梯度，学习速率的值越小，梯度下降的速度越慢。为了确保我们不会错过任何一个局部最小值，使用比较小的学习速率是一个比较好的方法。但是这意味着我们需要消耗很长的时间来使得函数收敛，特别是当困在比较高的地方。
下面的公式显示了他们之间的关系：
```
new_weight = existing_weight - learning_rate * gradient
```
<img src="/wiki/static/images/deeplearning/learningrate/01.png" alt="learningrate01"/>
使用大数值(上)和小数值(下)的学习速率的梯度下降示意图，来源于Andrew Ng的机器学习教程

一般情况下，学习速率是由使用者随机的设定的。很多情况下使用者会根据之前的经验或者一些学习资料来设置最佳的学习速率值。

因此，通常情况下很难一下子就选择正确。下面这张图显示了设置不同的学习速率对loss的影响。
<img src="/wiki/static/images/deeplearning/learningrate/01.png" alt="learningrate01"/>

而且, 学习速率影响模型收敛到一个局部最小值（或者达到最优解）的速度，因此，一开始获得恰当的学习速率将意味着使用较短的时间来训练模型。
```
越短的训练时间，越少的钱花费在GPU云计算上
```
# 有确定学习速率的方法么？
在文章“训练神经网络的周期性学习速率”的第3.3节，Leslie N. Smith建议我们可以在最初训练模型的时候使用比较小的学习速率，在每次迭代的过程中线性的或者呈几何级数的增加学习速率的大小这样的方式来估算一个比较好的学习速率，如下图所示

如果记录在训练过程中每一次迭代的训练速率(取对数)和loss，并把他们画出来，我们可以观察到随着学习速率的不断增长，loss会出现一个停止下降并且开始上升的转折点，在实践中，学习速率的理想的位置应该是最低点左边的位置(如下图展示的)，在这张图中，最佳取值再0.001-0.01的位置。

# 上面的方法似乎是有用的，那应该如何实现呢？
      


# 参考文献
[Understanding Learning Rates and How It Improves Performance in Deep Learning](https://towardsdatascience.com/understanding-learning-rates-and-how-it-improves-performance-in-deep-learning-d0d4059c1c10)