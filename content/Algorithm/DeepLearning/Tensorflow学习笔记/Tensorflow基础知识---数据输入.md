---
title: "Tensorflow基础知识---数据输入"
layout: page
date: 2017-10-23 10:00
---
[TOC]

#写在前面#

关于Tensorflow读取数据，官网给出了三种方法：

- 供给数据(Feeding)
- 从文件读取数据
- 预加载数据

## 供给数据
在TensorFlow程序运行的每一步， 让Python代码来供给数据。

## 从文件中读取数据
在TensorFlow图的起始， 让一个输入管线从文件中读取数据，而且已经给设计好了多线程读写模型。

一般典型的文件读取管线会包含下面这些步骤：

- 文件名列表
- 可配置的 文件名乱序(shuffling)
- 可配置的 最大训练迭代数(epoch limit)
- 文件名队列
- 针对输入文件格式的阅读器(首先要知道你要读取的文件的格式，选择对应的文件读取器)
- 纪录解析器
- 可配置的预处理器
- 样本队列

### 1、从csv中读取数据
用的文件读取器和解码器就是 TextLineReader 和 decode_csv

### 2、 .bin 格式的二进制文件
用 tf.FixedLengthRecordReader 和 tf.decode_raw 读取固定长度的文件读取器和解码器

### 3、把网络或者内存中的数据转化为tensorflow的专用格式tfRecord,存文件后再读取。
如果你要读取的数据是图片，或者是其他类型的格式，那么可以先把数据转换成 TensorFlow 的标准支持格式 tfrecords ，它其实是一种二进制文件，通过修改 tf.train.Example 的Features，将 protocol buffer 序列化为一个字符串，再通过 tf.python_io.TFRecordWriter 将序列化的字符串写入 tfrecords，然后再用跟上面一样的方式读取tfrecords，只是读取器变成了tf.TFRecordReader，之后通过一个解析器tf.parse_single_example ，然后用解码器 tf.decode_raw 解码。


## 预加载数据

在TensorFlow图中定义常量或变量来保存所有数据。这仅用于可以完全加载到存储器中的小的数据集。有两种方法：

- 存储在常数中。
- 存储在变量中，初始化后，永远不要改变它的值。


# 参考文献
[TF Boys (TensorFlow Boys ) 养成记（二）： TensorFlow 数据读取](http://www.cnblogs.com/Charles-Wan/p/6197019.html)
[数据读取](http://wiki.jikexueyuan.com/project/tensorflow-zh/how_tos/reading_data.html)
[TensorFlow高效读取数据的方法](http://blog.csdn.net/u012759136/article/details/52232266)
[]()
[]()
