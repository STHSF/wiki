---
title: "have a second RNNCell use the weights of a variable scope"
layout: page
date: 2017-08-07 22:10
---
# 写在前面
最近在实现seq2seq的时候遇到这样一个问题，我在同一段代码里需要定义两个不同的RNNcell，并且要分别使用dynamic_rnn去计算两个RNNCell的输出，虽然两个RNNCell我都定义了不同的variable_scope但是还是会报错，错误的提示如下：

# 错误提示

```
ValueError: Attempt to have a second RNNCell use the weights of a variable scope that already has weights: 'rnn/lstm_cell'; and the cell was not constructed as LSTMCell(..., reuse=True).  To share the weights of an RNNCell, simply reuse it in your second calculation, or create a new one with the argument reuse=True.
```

# 涉及的部分代码
```
def get_encoder_layer():
    encoder_inputs_embedded = embedding(encoder_inputs)
        with tf.variable_scope('encoder'):
        encoder_cell = tf.contrib.rnn.LSTMCell(encoder_hidden_units)
    encoder_output, encoder_final_state = tf.nn.dynamic_rnn(encoder_cell,
                                                            encoder_inputs_embedded,
                                                            dtype=tf.float32,
                                                            time_major=True)
def get_decoder_layer():
    decoder_inputs_embedded = embedding(decoder_inputs)
    with tf.variable_scope('decoder'):
        decoder_cell = tf.contrib.rnn.LSTMCell(decoder_hidden_units)
    decoder_outputs, decoder_final_state = tf.nn.dynamic_rnn(decoder_cell,
                                                             decoder_inputs_embedded,
                                                             initial_state=self.encoder_final_state,
                                                             dtype=tf.float32,
                                                             time_major=True)
```
代码里分别调用了两次LSTMCell，并分别使用dynamic_cell计算不同的输入数据，运行的时候会出现上面的错误。

在查了源码和一些资料后，在dynamic_rnn中添加了scope参数之后这个问题就解决了。
# 修改后的代码
```
def get_encoder_layer():
    encoder_inputs_embedded = embedding(encoder_inputs)
        with tf.variable_scope('encoder_cell'):
        encoder_cell = tf.contrib.rnn.LSTMCell(encoder_hidden_units)
    encoder_output, encoder_final_state = tf.nn.dynamic_rnn(encoder_cell,
                                                            encoder_inputs_embedded,
                                                            dtype=tf.float32,
                                                            time_major=True,
                                                            scope='encode_cell')
def get_decoder_layer():
    decoder_inputs_embedded = embedding(decoder_inputs)
    with tf.variable_scope('decoder_cell'):
        decoder_cell = tf.contrib.rnn.LSTMCell(decoder_hidden_units)
    decoder_outputs, decoder_final_state = tf.nn.dynamic_rnn(decoder_cell,
                                                             decoder_inputs_embedded,
                                                             initial_state=self.encoder_final_state,
                                                             dtype=tf.float32,
                                                             time_major=True,
                                                             scope='decode_cell')
```
源码中对scope的解释是：```scope: VariableScope for the created subgraph; defaults to "rnn".```
其他地方没有太多的解释。我也刚刚接触tensorflow，对这些参数的理解不是很透彻，简单的讲，对于tensorflow入门比较简单，网上很多tutorials，但是想要真正的理解每个函数的意义并不是一件简单的事。

#### 参考代码[seq2seq_basic_advanced.py](https://github.com/STHSF/DeepNaturalLanguageProcessing/tree/develop/Seq2Seq)











