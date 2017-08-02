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

# 代码详解
```
import numpy as np
import tensorflow as tf

```

## 数据预处理
```
# 填充标记
PAD = 0
# 结束标记
EOS = 1
# 词汇量的大小
vocab_size = 10
# 输入数据的词嵌套的大小
input_embedding_size = 20
# 编码中RNN的隐藏单元的个数
encoder_hidden_units = 25
# 解码中RNN的隐藏单元的个数
decoder_hidden_units = encoder_hidden_units
```
定义编码输入，解码输入和输出
```
# encoder_inputs:[max_time, batch_size]
encoder_inputs = tf.placeholder(shape=(None, None), dtype=tf.int32, name='encoder_inputs')
# decoder_targets: [max_time, batch_size]
decoder_targets = tf.placeholder(shape=(None, None), dtype=tf.int32, name='decoder_targets')
# decoder_inputs: [max_time, batch_size]
# 实际上是不用手动feeddecoder_inputs的，
decoder_inputs = tf.placeholder(shape=(None, None), dtype=tf.int32, name='decoder_inputs')
```
对输入数据进行embedding操作
```
embeddings = tf.Variable(tf.random_uniform([vocab_size, input_embedding_size], -1.0, 1.0), dtype=tf.float32)
# encoder_inputs_embeded: [max_time, batch_size, input_embedding_size]
encoder_inputs_embeded = tf.nn.embedding_lookup(embeddings, encoder_inputs)
# decoder_inputs_embeded: [max_time, batch_size, input_embedding_size]
decoder_inputs_embeded = tf.nn.embedding_lookup(embeddings, decoder_inputs)
decoder_inputs_embeded
```
## Encoder过程
```
# 定义编码RNNCell
encoder_cell = tf.contrib.rnn.LSTMCell(encoder_hidden_units)
# dynamic RNN在改变batch_size或者sequence_length的时候是不需要重新训练的，但是如果改变了vocabulary size的时候是需要重新训练模型的
# time_major=True表示batch_size在第二列，即encoder_inputs_embeded的结构为[max_time, batch_size, embedding_dim]
# 如果time_major=True则表示batch_size在第二列，即encoder_inputs_embeded的机构为[batch_size, max_time, embedding]
encoder_outputs, encoder_final_state = tf.nn.dynamic_rnn(encoder_cell,
                                                         encoder_inputs_embeded,
                                                         dtype=tf.float32, time_major=True)
# decoder过程中不需要encoder的输出，所以将其删除，仅保留运行输出的隐藏状态
del encoder_outputs
```
## Decoder过程
```
# 定义解码RNNCell
decoder_cell = tf.contrib.rnn.LSTMCell(decoder_hidden_units)
# 
decoder_outputs, decoder_final_state = tf.nn.dynamic_rnn(decoder_cell, 
                                                         decoder_inputs_embeded,
                                                         initial_state=encoder_final_state,
                                                         dtype=tf.float32, time_major=True,scope='plain_decoder')
```