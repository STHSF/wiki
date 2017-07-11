---
title: "Tensorflow中的损失函数详解"
layout: page
date: 2017-07-06 11:40
---

[TOC]
# 写在前面
本文先介绍loss function的基本概念，然后主要归纳一下tensorflow中的loss_function.

# Loss function
在机器学习中，loss function（损失函数）也称cost function（代价函数），是用来计算预测值和真实值的差距。然后以loss function的最小值作为目标函数进行反向传播迭代计算模型中的参数，这个让loss function的值不断变小的过程称为优化。

设总有$(N)$个样本的样本集为$((X,Y)=(x_i, y_i))$,那么总的损失函数为
$$ L=\sum_{i=1}^{n}{l(y_i, f(x_i))} $$
其中 $(y_i,i\in[1, N])$为样本$i$的真实值，$(f(x_i), i\in[1, N])$为样本$(i)$的预测值， $(f())$为分类或者回归函数。

常见的损失函数有Zero-one Loss（0-1损失），Perceptron Loss（感知损失），Hinge Loss（Hinge损失），Log Loss（Log损失），Cross Entropy（交叉熵），Square Loss（平方误差），Absolute Loss（绝对误差），Exponential Loss（指数误差）等

一般来说，对于分类或者回归模型进行评估时，需要使得模型在训练数据上似的损失函数值最小，即使得经验风险函数（Empirical risk）最小化，但是如果只考虑经验风险，容易出现过拟合，因此还需要考虑模型的泛化性，一般常用的方法就是在目标函数中加上正则项，有损失项（loss term）加上正则项（regularization term）构成结构风险（Structural risk），那么损失函数变为：
$$
L =\sum_{i=1}^{N}{l(y_i, f(x_i))} +\lambda R(w)
$$
其中$(\lambda)$为正则项超参数，常用的正则化方法包括：L1正则和L2正则

