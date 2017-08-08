---
title: "Tensorflow基础知识---tf.dyanmic_rnn"
layout: page
date: 2017-07-25 23:00
---

# 写在前面
dynamic_rnn是在定义了RNN的主体结构后，对RNNCell进行计算的函数，本文主要来解释```tf.nn.dynamic_rnn()```的参数，

dynamic_rnn中主要的参数包括cell, inputs, initial_state=None, time_major=False, scope=None
    - cell是指定义的RNNCell；
    - inputs是指输入的数据，它的基本格式如[batch_size, max_time, inputs_dim]
        - 如果inputs的格式是[batch_size, max_time, inputs_dim], 则time_major=False
        - 如果inputs的格式是[max_time, batch_size, inputs_dim], 则time_major=True
    - initial_state：state初始化输入。
    - scope：
    
    
# 疑问
关于initial_state的疑问：
1、是否在调用dynamic_rnn的时候都需要对其state进行初始化
2、每一个batch训练结束之后，当前batch的final_state是否是要通过赋值给下一个batch的initial_state，如果没有赋值,是不是每个batch的state是不搭嘎的，即每个batch都是重新计算state，并且final_state都没有利用起来
