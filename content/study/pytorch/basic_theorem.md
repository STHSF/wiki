---
title: "basic_theorem.md"
layout: page
date: 2018-08-05 00:00
---
[TOC]

# 写在前面
## 1.什么是Pytorch，为什么选择Pytroch？
Facebook在机器学习和科学计算工具Torch的基础上, 针对python语言发布的一个全新的机器学习工具包. Pytorch支持动态图创建, 作为numpy的代替,支持GPU的Tensor库. PyTroch将会直接指向代码定义的确切位置,节省开发者寻找BUG的时间, 同时代码简洁, 可以快速实现神经网络构建.

## 2.Pytroch的安装
可以使用pip或者conda直接安装.
### 配置Python环境和管理
可以使用隔离器来进行python环境的安装和管理

主要的隔离环境包括virtualenv和annaconda

#### virtualenv安装
```
pip install virtualenv
```
安装完成之后可以通过
```
virtualenv venv
```
来创建一个名字为venv的虚拟环境, 同时可以在后面指定python的版本.
#### annaconda
annaconda安装需要从shell脚本安装, annaconda[使用过程中的坑](https://sthsf.github.io/wiki/Linux%20Tricks/annaconda%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B.html)

### 通过命令行安装PyTorch
virtualenv下安装pytorch
```
pip install torch
```
conda安装
```
pip install torch
or
conda install torch
```

## 3.PyTorch基础概念
### 张量
Tensor类似于Numpy中的ndarray.
```
import torch
z = torch.Tensor(4, 5)
print(z)
```
输出:
```
tensor([[ 1.5196e-38,  0.0000e+00,  2.8026e-44,  0.0000e+00,  1.5245e-37],
        [ 0.0000e+00, -9.5466e-39,  4.5595e-41, -2.5964e-31,  4.5595e-41],
        [-9.5235e-39,  4.5595e-41,  0.0000e+00,  0.0000e+00,  5.3254e-37],
        [ 0.0000e+00,  0.0000e+00,  0.0000e+00,  0.0000e+00,  0.0000e+00]])
```



## 4.通用代码实现流程(实现一个深度学习的代码流程)

# 参考文献