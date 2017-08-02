---
title: "Seq2Seq的简单实现"
layout: page
date: 2017-08-02 00:00
---

# 写在前面
在[Tensorflow基础知识---Senquence-to-Senquence详解]()一文中详细讲述了sequence-to-sequence的原理，本文主要是基于前文中的讲述内容，使用tensorflow实现出来，便于对原理的理解。
本文主要参考[ematvey](https://github.com/ematvey/tensorflow-seq2seq-tutorials)在github上的代码。

# simple seq2seq model with dynamic unrolling
本文实现的是一个最简单的seq2seq模型，即只包含前向传播的编码过程，和没有注意力机制的解码过程。并且没有使用```tf.contrib.seq2seq```接口。本代码主要的结构是参考的是 Sutskever, Vinyals and Le (2014)中提到的encoder-decoder结构。

具体描述参见[Tensorflow基础知识---Senquence-to-Senquence详解]()图一的详细解释。
## Encoder过程



## Decoder过程