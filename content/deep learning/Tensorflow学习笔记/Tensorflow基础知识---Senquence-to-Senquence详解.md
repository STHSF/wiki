---
title: "Tensorflow基础知识---Senquence-to-Senquence详解"
layout: page
date: 2017-07-06 00:00
---

# 写在前面
Seq2Seq是基于tensorflow的一种通用编码器&解码器框架，可用于机器翻译，文本摘要，会话模型，图像描述等。

# Sequence_to_Sequence Model
常见的语言模型的研究对象是单一序列，例如（文本生成），而Sequence_to_Sequence Model同时研究两个序列之间的关系。Encoder-Decoder的基本结构如下：
<img src="/wiki/static/images/Encoder-Decoder基本结构.jpg" alt="Encoder-Decoder基本结构"/>
上图是一个已经在时间维度上展开的Encoder-Decoder模型，典型的Sequence_to_Sequence Model通常是由两个RNN网络构成，一个被称为编码器，另一个被称为译码器，encoder负责把variable-length的序列编码成fixed-length的语义表示向量，decoder则
负责把fixed-length的语义向量解码成variable-length的输出序列，并且每个时刻t输出词的概率都与前t-1时刻的输出有关。
## Encoder
Encoder的过程比较简单，一般直接用RNN(LSTM)进行语义向量的生成：
$$
h_t = f(x_t, h_{t-1})\\
c = \phi(h_1,h_2,...,h_T)
$$
其中f是非线性激活函数，$(h_{t-1})$是上一个隐节点输出，$(x_t)$是当前时刻的输入，向量c通常为RNN的最后一个隐节点（h,Hidden state）,或者是多个隐节点的加权和。
## Decoder
该模型的decoder过程是使用另一个RNN通过当前状态$(h_t)$来预测当前的输出符号$(y_t)$, 其中的$(h_t)$,$(y_t)$都与其前一个隐状态和输出有关：
$$
h_t= f(h_{t-1}, y_{t-1}, c)\\
P(y_t|y_{t-1},...,y_1,c)=g(h_t, y_{t-1}, c)
$$








[通用编码器&解码器框架seq2seq](https://www.oschina.net/p/seq2seq)

[TensorFlow中Sequence-to-Sequence样例代码详解](http://blog.csdn.net/diligent_321/article/details/53590289)

[sequence_loss_by_example(logits, targets, weights)](http://blog.csdn.net/appleml/article/details/54017873)

[tensorflow的legacy_seq2seq模块](http://blog.csdn.net/u012871493/article/details/72350332)

[tf.contrib.legacy_seq2seq.sequence_loss_by_example](https://www.tensorflow.org/api_docs/python/tf/contrib/legacy_seq2seq/sequence_loss_by_example)

[tensorflow学习笔记（十一）：seq2seq Model](http://www.2cto.com/kf/201611/561130.html)
[tensorflow学习笔记（十一）：seq2seq Model相关接口介绍](http://blog.csdn.net/u012436149/article/details/52976413)

[RNN回归例子](http://www.360doc.com/content/17/0321/10/10408243_638692790.shtml)

[Styles of Truncated Backpropagation](https://r2rt.com/styles-of-truncated-backpropagation.html)

[lstm分类的例子涉及dynamic_nn](http://www.360doc.com/content/17/0321/10/10408243_638692495.shtml)

[tensorflow高阶教程:tf.dynamic_rnn](http://blog.csdn.net/u010223750/article/details/71079036)

[ tensorflow笔记：多层LSTM代码分析](http://blog.csdn.net/u014595019/article/details/52759104)

[RNNs in Tensorflow, a Practical Guide and Undocumented Features](http://www.wildml.com/2016/08/rnns-in-tensorflow-a-practical-guide-and-undocumented-features/)

[解析Tensorflow官方PTB模型的demo](http://blog.csdn.net/mydear_11000/article/details/52440115)

[tensorflow0.10.0 ptb_word_lm.py 源码解析](http://blog.csdn.net/u012436149/article/details/52828786)

[ tensorflow学习笔记（二十六）：构建TF代码](http://blog.csdn.net/u012436149/article/details/53843158)

[tensorflow学习笔记（三）：损失函数](http://blog.csdn.net/u012436149/article/details/52874718)