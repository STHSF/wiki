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


# Tensorflow中的loss function实现

## `cross_entropy`交叉熵

```python
def softmax_cross_entropy_with_logits(_sentinel=None,  # pylint: disable=invalid-name
                                      labels=None, logits=None,
                                      dim=-1, name=None):
    """Computes softmax cross entropy between `logits` and `labels`."""
```
- logits: 神经网络的最后一层输出，如果有batch的话，它的大小为[batch_size, num_classes], 单样本的话大小就是num_classes
- labels: 样本的实际标签，大小与logits相同。

具体的执行流程大概分为两步，第一步首先是对网络最后一层的输出做一个softmax，这一步通常是求取输出属于某一类的概率，对于单样本而言，就是输出一个num_classes大小的向量$([Y_1, Y_2, Y_3, ....])$, 其中$(Y_1, Y_2, Y_3)$分别表示属于该类别的概率， softmax的公式为：

$$
softmax(x)_i={{exp(x_i)}\over{\sum_jexp(x_j)}}
$$

第二步是对softmax输出的向量$([Y_1, Y_2, Y_3,...])$和样本的时机标签做一个交叉熵，公式如下：

$$
H_{y'}(y)=-\sum_i{y_i'}log(y_i)
$$

其中$(y_i')$指代实际标签向量中的第i个值，$(y_i)$就是softmax的输出向量$([Y_1, Y_2, Y_3,...])$中的第i个元素的值。
显而易见。预测$(y_i)$越准确，结果的值就越小（前面有负号），最后求一个平均，就得到我们想要的loss了

这里需要注意的是，这个函数返回值不是一个数，而是一个向量，如果要求交叉熵，我们要在做一步tf.resuce_sum操作，就是对向量里面的所有元素求和，最后就能得到$(H_{y'}(y))$,如果要求loss，则需要做一步tf.reduce_mean操作，对向量求均值。
下面这段代码可以测试上面的理论：

```python
import tensorflow as tf  
  
#our NN's output  
logits=tf.constant([[1.0,2.0,3.0],[1.0,2.0,3.0],[1.0,2.0,3.0]])  
#step1:do softmax  
y=tf.nn.softmax(logits)  
#true label  
y_=tf.constant([[0.0,0.0,1.0],[0.0,0.0,1.0],[0.0,0.0,1.0]])  
#step2:do cross_entropy  
cross_entropy = -tf.reduce_sum(y_*tf.log(y))  
#do cross_entropy just one step  
cross_entropy2=tf.reduce_sum(tf.nn.softmax_cross_entropy_with_logits(logits, y_))#dont forget tf.reduce_sum()!!  
  
with tf.Session() as sess:  
    softmax=sess.run(y)  
    c_e = sess.run(cross_entropy)  
    c_e2 = sess.run(cross_entropy2)  
    print("step1:softmax result=")  
    print(softmax)  
    print("step2:cross_entropy result=")  
    print(c_e)  
    print("Function(softmax_cross_entropy_with_logits) result=")  
    print(c_e2) 
```
输出结果：

```
step1:softmax result=  
[[ 0.09003057  0.24472848  0.66524094]  
 [ 0.09003057  0.24472848  0.66524094]  
 [ 0.09003057  0.24472848  0.66524094]]  
step2:cross_entropy result=  
1.22282  
Function(softmax_cross_entropy_with_logits) result=  
1.2228 
```

从结果可以看出softmax_cross_entropy_with_logits()与我们个公式逻辑是相符合的，整个过程可以大概了解到softmax_cross_entropy_with_logits()的操作情况。
