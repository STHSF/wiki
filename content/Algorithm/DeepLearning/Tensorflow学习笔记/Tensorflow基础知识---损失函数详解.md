---
title: "Tensorflow基础知识---损失函数详解"
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
交叉熵刻画的是两个概率分布之间的距离，是分类问题中使用比较广泛的损失函数之一。给定两个概率分布p和q，通过交叉熵计算的两个概率分布之间的距离为：
$$
H(X=x)=-\sum_x{p(x)logq(x)}
$$
我们通过softmax回归将神经网络前向传播得到的结果变成交叉熵要求的概率分布得分。
Tensorflow中定义的交叉熵函数如下：
```python
def softmax_cross_entropy_with_logits(_sentinel=None,  # pylint: disable=invalid-name
                                      labels=None, logits=None,
                                      dim=-1, name=None):
    """Computes softmax cross entropy between `logits` and `labels`."""
```
- logits: 神经网络的最后一层输出，如果有batch的话，它的大小为[batch_size, num_classes], 单样本的话大小就是num_classes
- labels: 样本的实际标签，大小与logits相同。且必须采用labels=y_，logits=y的形式将参数传入。

具体的执行流程大概分为两步，第一步首先是对网络最后一层的输出做一个softmax，这一步通常是求取输出属于某一类的概率，对于单样本而言，就是输出一个num_classes大小的向量$([Y_1, Y_2, Y_3, ....])$, 其中$(Y_1, Y_2, Y_3)$分别表示属于该类别的概率， softmax的公式为：

$$softmax(x)_i={{exp(x_i)}\over{\sum_jexp(x_j)}}$$

第二步是对softmax输出的向量$([Y_1, Y_2, Y_3,...])$和样本的时机标签做一个交叉熵，公式如下：

$$H_{y'}(y)=-\sum_i{y_i'}log(y_i)$$

其中$(y_i')$指代实际标签向量中的第i个值，$(y_i)$就是softmax的输出向量$([Y_1, Y_2, Y_3,...])$中的第i个元素的值。
显而易见。预测$(y_i)$越准确，结果的值就越小（前面有负号），最后求一个平均，就得到我们想要的loss了

**这里需要注意的是，这个函数返回值不是一个数，而是一个向量，如果要求交叉熵，我们要在做一步tf.resuce_sum操作，就是对向量里面的所有元素求和, 最后就能得到$(H_{y'}(y))$,如果要求loss，则需要做一步tf.reduce_mean操作，对向量求均值.**

**warning：**

- Tenosrflow中集成的交叉熵操作是施加在未经过Softmax处理的logits上, 这个操作的输入logits是未经缩放的, 该操作内部会对logits使用Softmax操作。
- 参数labels，ligits必须有相同的shape,如:[batch_size, num_classes]和相同的类型, 如:[(float16, float32, float64)中的一种]。

下面这段代码可以测试上面的理论：
```python
# coding=utf-8
import tensorflow as tf  

# 神经网络的输出
logits=tf.constant([[1.0,2.0,3.0],[1.0,2.0,3.0],[1.0,2.0,3.0]])  
# 使用softmax的输出
y=tf.nn.softmax(logits)  
# 正确的标签
y_=tf.constant([[0.0,0.0,1.0],[0.0,0.0,1.0],[0.0,0.0,1.0]])  
# 计算交叉熵  
cross_entropy = -tf.reduce_sum(y_*tf.log(tf.clip_by_value(y, 1e-10, 1.0)))  
# 使用tf.nn.softmax_cross_entropy_with_logits()函数直接计算神经网络的输出结果的交叉熵。
# 但是不能忘记使用tf.reduce_sum()!!!!
cross_entropy2 = tf.reduce_sum(tf.nn.softmax_cross_entropy_with_logits(logits, y_)) 
  
with tf.Session() as sess:
    softmax=sess.run(y)
    c_e = sess.run(cross_entropy)
    c_e2 = sess.run(cross_entropy2)
    print("step1:softmax result=", softmax)
    print("step2:cross_entropy result=", c_e)
    print("Function(softmax_cross_entropy_with_logits) result=", c_e2)
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
其中tf.clip_by_calue()函数可将一个tensor的元素数值限制在指定的范围内，这样可以防止一些错误运算，起到数值检查的作用。
从结果可以看出softmax_cross_entropy_with_logits()与我们个公式逻辑是相符合的，整个过程可以大概了解到softmax_cross_entropy_with_logits()的操作情况。

## tf.nn.sparse_softmax_cross_entropy_with_logits(logits, labels, name=None)
```python
def sparse_softmax_cross_entropy_with_logits(_sentinel=None,  # pylint: disable=invalid-name
                                             labels=None, 
                                             logits=None,
                                             name=None):
  """Computes sparse softmax cross entropy between `logits` and `labels`.
  Args:
    _sentinel: Used to prevent positional parameters. Internal, do not use.
    labels: `Tensor` of shape `[d_0, d_1, ..., d_{r-1}]` (where `r` is rank of
      `labels` and result) and dtype `int32` or `int64`. Each entry in `labels`
      must be an index in `[0, num_classes)`. Other values will raise an
      exception when this op is run on CPU, and return `NaN` for corresponding
      loss and gradient rows on GPU.
    logits: Unscaled log probabilities of shape
      `[d_0, d_1, ..., d_{r-1}, num_classes]` and dtype `float32` or `float64`.
    name: A name for the operation (optional).

  Returns:
    A `Tensor` of the same shape as `labels` and of the same type as `logits`
    with the softmax cross entropy loss.

  Raises:
    ValueError: If logits are scalars (need to have rank >= 1) or if the rank
      of the labels is not equal to the rank of the labels minus one.
  """
```
该函数与tf.nn.softmax_cross_entropy_with_logits()函数十分相似，唯一的区别在于labels的shape，该函数的labels要求是排他性的即只有一个正确的类别，如果labels的每一行不需要进行one_hot表示，可以使用tf.nn.sparse_softmax_cross_entropy_with_logits()。
### Demo
下面的代码列举了sparse_softmax_cross_entropy_with_logits()和softmax_cross_entropy_with_logits()的输入输出。
```python
def cost_compute(logits, target_inputs, num_classes):
    # shape = [batch_size * num_steps, ]
    # labels'shape = [batch_size * num_steps, num_classes]
    # logits'shape = [shape = [batch_size * num_steps, num_classes]]
    # 这里可以使用tf.nn.sparse_softmax_cross_entropy_with_logits()和tf.nn.softmax_cross_entropy_with_logits()两种方式来计算rnn
    # 但要注意labels的shape。
    # eg.1
    # loss = tf.nn.sparse_softmax_cross_entropy_with_logits(labels=tf.reshape(target_inputs, [-1]),
    #                                                       logits=logits, name='loss')

    # eg.2
    targets = tf.one_hot(target_inputs, num_classes)  # [batch_size, seq_length, num_classes]
    # 不能使用logit.get_shape(), 因为在定义logit时shape=[None, num_steps], 这里使用会报错
    # y_reshaped = tf.reshape(targets, logits.get_shape())  # y_reshaped: [batch_size * seq_length, num_classes]
    loss = tf.nn.softmax_cross_entropy_with_logits(labels=tf.reshape(targets, [-1, num_classes]),
                                                   logits=logits, name='loss')

    cost = tf.reduce_mean(loss, name='cost')
    return cost
```
完整代码请参考[bi_lstm_advanced.py](https://github.com/STHSF/DeepNaturalLanguageProcessing/tree/develop/ChineseSegmentation/src)

## tf.nn.sigmoid_cross_entropy_with_logits(logits, targets, name=None)
sigmoid_cross_entropy_with_logits是TensorFlow最早实现的交叉熵算法。这个函数的输入是logits和labels，logits就是神经网络模型中的 W * X矩阵，注意不需要经过sigmoid，而labels的shape和logits相同，就是正确的标签值，例如这个模型一次要判断100张图是否包含10种动物，这两个输入的shape都是[100, 10]。注释中还提到这10个分类之间是独立的、不要求是互斥，这种问题我们称为多目标（多标签）分类，例如判断图片中是否包含10种动物中的一种或几种，标签值可以包含多个1或0个1。

## tf.nn.weighted_cross_entropy_with_logits(logits, targets, pos_weight, name=None)	
weighted_sigmoid_cross_entropy_with_logits是sigmoid_cross_entropy_with_logits的拓展版，多支持一个pos_weight参数，在传统基于sigmoid的交叉熵算法上，正样本算出的值乘以某个系数。

## tf.nn.log_softmax(logits, name=None)	


# sampled loss functions
## tf.nn.nce_loss(weights, biases, inputs, labels, num_sampled,num_classes, num_true=1, sampled_values=None,remove_accidental_hits=False, partition_strategy=’mod’,name=’nce_loss’)
## tf.nn.sampled_softmax_loss(weights, biases, inputs, labels, num_sampled, num_classes, num_true=1, sampled_values=None,remove_accidental_hits=True, partition_strategy=’mod’, name=’sampled_softmax_loss’)

# sequence to sequence中的loss function
## sequence_loss_by_example(logits, targets, weights)
## tf.contrib.legacy_seq2seq.sequence_loss_by_example

# 参考文献
[1](http://blog.csdn.net/marsjhao/article/details/72630147)

[tensorflow学习笔记（三）：损失函数](http://blog.csdn.net/u012436149/article/details/52874718)
[sequence_loss_by_example(logits, targets, weights）](http://blog.csdn.net/appleml/article/details/54017873)

