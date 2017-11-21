---
title: "全面详解Tensorflow使用LSTM进行MNIST手写字符分类"
layout: page
date: 2017-11-21 00:00
---

# 写在前面
使用LSTM进行MNIST手写字符分类的Tensorflow代码其官方教程中就已经给出，很多其他的教程中也就把他拿过来作为lstm在分类中的应用作为讲解，但是很多代码依然是基于tensorflow官网代码。

本教程中主要的代码跟官网没有差别，比如rnn_cell的定义，超参的设置也基本相同，本文主要的侧重点在给出了training_model和testing_model,并且结合tensorboard将训练和测试过程中的accuracy和loss展现出来。
这里面设计的主要问题是训练模型和测试模型的参数共享，以及tf.summary的应用。

首先，我们先看下结果：
### 模型训练和测试的accuracy 和cost
<center><img src="/wiki/static/images/mnist/train_test.jpg" alt="scalaers"/></center>

### tensorboard 中的GRAPHS
<center><img src="/wiki/static/images/mnist/graphs.jpg" alt="GRAPHS"/></center>
### GRAPH展开
<center><img src="/wiki/static/images/mnist/graph_unrolling.jpg" alt="GRAPHS_UNROLLING"/></center>




## 实现过程中踩过的坑
### tf.summary的使用
为了防止模型的过拟合，tensorflow提供了droupout机制，在训练过程中drop掉某些节点来防止过拟合，但是测试模型并不需要使用到dorp以及一些train_op,因此有的教程中会将is_training作为模型的一个变量。
为了

### 模型的变量共享
