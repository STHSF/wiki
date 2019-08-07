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

## 机器学习中的评估方法
1、 AUC、ROC曲线：
在引入查全率和查准率之前我们必须先理解到什么是混淆矩阵（Confusionmatrix）。这个名字起得是真的好，初学者很容易被这个矩阵搞得晕头转向。

根据混淆矩阵我们可以得到TP,FN,FP,TN四个值，显然TP+FP+TN+FN=样本总数。这四个值中都带两个字母，单纯记忆这四种情况很难记得牢，我们可以这样理解：第一个字母表示本次预测的正确性，T就是正确，F就是错误；第二个字母则表示由分类器预测的类别，P代表预测为正例，N代表预测为反例。比如TP我们就可以理解为分类器预测为正例（P），而且这次预测是对的（T），FN可以理解为分类器的预测是反例（N），而且这次预测是错误的（F），正确结果是正例，即一个正样本被错误预测为负样本。

- 查准率(Precision）是指在所有系统判定的“真”的样本中，确实是真的的占比
- 查全率（Recall）是指在所有确实为真的样本中，被判为的“真”的占比

注意, precision和accuracy（正确率）不一样的，accuracy针对所有样本，precision针对部分样本，即正确的预测/总的正反例.

查准率和查全率是一对矛盾的度量，一般而言，查准率高时，查全率往往偏低；而查全率高时，查准率往往偏低。我们从直观理解确实如此：我们如果希望好瓜尽可能多地选出来，则可以通过增加选瓜的数量来实现，如果将所有瓜都选上了，那么所有好瓜也必然被选上，但是这样查准率就会越低；若希望选出的瓜中好瓜的比例尽可能高，则只选最有把握的瓜，但这样难免会漏掉不少好瓜，导致查全率较低。通常只有在一些简单任务中，才可能使查全率和查准率都很高。

再说PRC， 其全称就是PrecisionRecall Curve，它以查准率为Y轴，、查全率为X轴做的图。它是综合评价整体结果的评估指标。所以，哪总类型（正或者负）样本多，权重就大。也就是通常说的『对样本不均衡敏感』，『容易被多的样品带走』。

- ROC全称是“受试者工作特征”（Receiver Operating Characteristic）曲线，ROC曲线以“真正例率”（TPR）为Y轴，以“假正例率”（FPR）为X轴，对角线对应于“随机猜测”模型，而（0,1）则对应“理想模型”。

-  AUC（Area Under Curve）的值为ROC曲线下面的面积，若分类器的性能极好，则AUC为1。但现实生活中尤其是工业界不会有如此完美的模型，一般AUC均在0.5到1之间，AUC越高，模型的区分能力越好，上图AUC为0.81。若AUC=0.5，即与上图中红线重合，表示模型的区分能力与随机猜测没有差别。若AUC真的小于0.5，请检查一下是不是好坏标签标反了，或者是模型真的很差。
# 参考文献