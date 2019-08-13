---
title: "Getting Started"
layout: page
date: 2018-08-09 00:00
---
[TOC]

# 写在前面
1.numpy和pytorch实现梯度下降法
2.设定初始值
3.求取梯度
4.在梯度方向上进行参数的更新
5.numpy和pytorch实现线性回归
6.pytorch实现一个简单的神经网络

导入的包
```
import os
import torch
import torch.nn as nn
import torch.utils.data as Data
import torchvision
```

读取数据
```
EPOCH = 1  # train the training data n times, to save time, we just train 1 epoch
BATCH_SIZE = 1
DOWNLOAD_MNIST = False
LR = 0.001

# Mnist digits dataset
if not (os.path.exists('./mnist/')) or not os.listdir('./mnist/'):
    # not mnist dir or mnist is empyt dir
    DOWNLOAD_MNIST = True

train_data = torchvision.datasets.MNIST(
    root='./mnist/',
    train=True,  # this is training data
    transform=torchvision.transforms.ToTensor(),
    download=DOWNLOAD_MNIST,
)

# Data Loader for easy mini-batch return in training, the image batch shape will be (50, 1, 28, 28)
train_loader = Data.DataLoader(dataset=train_data, batch_size=BATCH_SIZE)  # , shuffle=True)
```
## sigmoid函数
sigmoid函数，将数据R映射到（0,1）区间上了。

## softmax函数
softmax是将根据n个数值的大小来分配概率区间

一般来说，为了避免数值越界的话，会要求减去最大值。

但是这里我们是用logistic regression，数值都会在0，1区间中，不会太大，因此不用担心这个问题。
## cross_Entropy函数
cross_Entropy 就是交叉熵。

这里，一旦我们给出了标准的label之后，我们就知道实际的p值分布为

只有一个元素为1，其他元素为0的概率分布了。

也就是对应label的概率越大越好~

## 任务描述
采用SDG，和DG算法

本文采用了pytorch实现，主要是为了避免手动算梯度。pytorch有autograd的机制。

本文一直采用的是固定步长
- 实现SDG的部分代码
从logistics regression模型中获取了
```
A, b = [i for i in logits.parameters()]
A.cuda()
b.cuda()
```
通过查看pytorch的源码实现中关于优化器部分的实现，手动设置了梯度归零的操作，不然就会是累积梯度了。
```
if A.grad is not None:
	A.grad.zero_()
	b.grad.zero_()
```
- 梯度下降更新梯度
```
A.data = A.data - alpha * A.grad.data
b.data = b.data - alpha * b.grad.data
```

# 参考文献