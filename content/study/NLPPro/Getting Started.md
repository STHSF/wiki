---
title: "数据集探索"
layout: page
date: 2018-06-02 00:00
---
[TOC]

# 写在前面
THUCNews和IMDB数据集都是用来做文本分类的数据集

## 中文数据集：THUCNews
1 数据集下载
本文采用了清华NLP组提供的THUCNews新闻文本分类数据集的子集, 数据下载链接：
THUCNews数据子集：https://pan.baidu.com/s/1hugrfRu 密码：qfud

2 数据描述

该数据集使用了其中的10个分类，每个分类6500条，总共65000条新闻数据。

数据集共有三个文件，如下：
```
cnews.train.txt: 训练集(500010条)
cnews.val.txt: 验证集(50010条)
cnews.test.txt: 测试集(1000*10条)
```
3 数据展示
```
import pandas as pd
train_data=pd.read_csv('cnews_train.txt',sep='\t',names=['label','content'])
test_data=pd.read_csv('cnews.test.txt',sep='\t',names=['content'])
train_data.info()
```


## 英文数据集：IMDB数据集

# 参考文献