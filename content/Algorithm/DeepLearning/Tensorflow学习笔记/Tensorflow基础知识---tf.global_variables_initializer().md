---
title: "Tensorflow基础知识---tf.global_variables_initializer()"
layout: page
date: 2017-08-07 16:00
---

# ```tf.global_variables_initializer()```
该函数是用来初始化变量的，一般在使用过程中不会出现什么问题，但今天我在写代码的时候出现的错误让我摸不着头脑，后来发现这个函数放的位置错了，导致有线变量没有初始化，所以记录下来。
我在定义RNN框架的使用一般喜欢将其封装成类，然后在后面直接调用RNN类，这样做自己觉得结构清晰。今天在写代码的时候不小心将这个类放到了变量初始化函数的后面，然后导致出现了一系列莫名其妙的问题，都不知道原因在哪里。
这就是一些细节问题，一般很难发现。
出现的错误如下：
```
tensorflow.python.framework.errors_impl.FailedPreconditionError: Attempting to use uninitialized value rnn/lstm_cell/biases
	 [[Node: rnn/lstm_cell/biases/read = Identity[T=DT_FLOAT, _device="/job:localhost/replica:0/task:0/cpu:0"](rnn/lstm_cell/biases)]]
```

如果出现上面类似的错误，可能就需要检查下你所定义的变量是不是都在```tf.global_variables_initializer()```变量初始化之前。


# 参考文献
[fine-tune](https://blog.csdn.net/b876144622/article/details/79962759)