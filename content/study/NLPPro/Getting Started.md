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
数据集来自 IMDB 的 25,000 条电影评论，以情绪（正面/负面）标记。评论已经过预处理，并编码为词索引（整数）的序列表示。为了方便起见，将词按数据集中出现的频率进行索引，例如整数 3 编码数据中第三个最频繁的词。这允许快速筛选操作，例如：「只考虑前 10,000 个最常用的词，但排除前 20 个最常见的词」。

1、IMDB主要用于情感分析

2、数据描述
直接使用keras接口读取数据
```
from keras.datasets import imdb

(x_train, y_train), (x_test, y_test) = imdb.load_data(path="imdb.npz",
                                                      num_words=None,
                                                      skip_top=0,
                                                      maxlen=None,
                                                      seed=113,
                                                      start_char=1,
                                                      oov_char=2,
                                                      index_from=3)
```

```
import numpy as np
print('shape of x_train {}'.format(np.shape(x_train)))
print('shape of y_train {}'.format(np.shape(y_train)))
print('shape of x_test {}'.format(np.shape(x_test)))
print('shape of y_test {}'.format(np.shape(y_test)))
```
```
shape of x_train (25000,)
shape of y_train (25000,)
shape of x_test (25000,)
shape of y_test (25000,)
```

```
# 设定向量的最大长度，小于这个长度的补0，大于这个长度的直接截端
x_train = keras.preprocessing.sequence.pad_sequences(x_train, maxlen=100)
x_test = keras.preprocessing.sequence.pad_sequences(x_test, maxlen=100)
print('x_train shape:', x_train.shape)
print('x_test shape:', x_test.shape)
print(x_train)
```

```
x_train shape: (25000, 100)
x_test shape: (25000, 100)

array([[ 1415,    33,     6, ...,    19,   178,    32],
       [  163,    11,  3215, ...,    16,   145,    95],
       [ 1301,     4,  1873, ...,     7,   129,   113],
       ...,
       [   11,     6,  4065, ...,     4,  3586, 22459],
       [  100,  2198,     8, ...,    12,     9,    23],
       [   78,  1099,    17, ...,   204,   131,     9]], dtype=int32)

```


# 参考文献