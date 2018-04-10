---
title: "pandas DataFrame的创建和基本操作"
layout: page
date: 2018-03-02 00:00
---
[TOC]

# 写在前面
DataFrame是Pandas中的一个表结构的数据结构，包括三部分信息，表头（列的名称），表的内容（二维矩阵），索引（每行一个唯一的标记）。

## 一、DataFrame的创建

有多种方式可以创建DataFrame，下面举例介绍。

### 例1： 通过list创建
'''
>>> import pandas as pd
>>> df = pd.DataFrame([[1,2,3],[4,5,6]])
>>> df
   0  1  2
0  1  2  3
1  4  5  6

[2 rows x 3 columns]
'''

# 参考文献