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


# 参考文献
[Understanding Learning Rates and How It Improves Performance in Deep Learning](https://towardsdatascience.com/understanding-learning-rates-and-how-it-improves-performance-in-deep-learning-d0d4059c1c10)