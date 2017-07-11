---
title: "ValueError: Variable lstm_cell/rnn/multi_rnn_cell/cell_0/basic_lstm_cell/kernel already exists,     disallowed. Did you mean to set reuse=True in VarScope? Originally defined at:"
layout: page
date: 2017-07-10 09:00
---
# 写在前面
最近在学习使用tensorflow构建language model，将其中遇到的问题记录下来，供大家参考，学习交流。

# 错误提示
 48 Traceback (most recent call last):
 49   File "anna_writer.py", line 274, in <module>
 50     samp = generate_samples(checkpoint, 20000, prime="The ")
 51   File "anna_writer.py", line 234, in generate_samples
 52     conf.lstm_size, conf.keep_prob, conf.grad_clip, False)
 53   File "anna_writer.py", line 74, in __init__
 54     self.add_lstm_cell()
 55   File "anna_writer.py", line 110, in add_lstm_cell
 56     initial_state=self.initial_state)
 57   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/rnn.py", line 574, ii
    n dynamic_rnn
 58     dtype=dtype)
 59   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/rnn.py", line 737, ii
    n _dynamic_rnn_loop
 60     swap_memory=swap_memory)
 61   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/control_flow_ops.py""
    , line 2770, in while_loop
 62     result = context.BuildLoop(cond, body, loop_vars, shape_invariants)
 63   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/control_flow_ops.py""
    , line 2599, in BuildLoop
 64     pred, body, original_loop_vars, loop_vars, shape_invariants)
 65   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/control_flow_ops.py""
    , line 2549, in _BuildLoop
 66     body_result = body(*packed_vars_for_body)
 67   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/rnn.py", line 722, ii
    n _time_step
 68     (output, new_state) = call_cell()
 69   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/rnn.py", line 708, ii
    n <lambda>
 70     call_cell = lambda: cell(input_t, state)
 71   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/rnn_cell_impl.py", ll
    ine 180, in __call__
 72     return super(RNNCell, self).__call__(inputs, state)
 73   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/layers/base.py", line 444
    1, in __call__
 74     outputs = self.call(inputs, *args, **kwargs)
 75   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/rnn_cell_impl.py", l    ine 916, in call
 76     cur_inp, new_state = cell(cur_inp, cur_state)
 77   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/rnn_cell_impl.py", l    ine 752, in __call__
 78     output, new_state = self._cell(inputs, state, scope)
 79   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/rnn_cell_impl.py", l    ine 180, in __call__
 80     return super(RNNCell, self).__call__(inputs, state)
 81   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/layers/base.py", line 44    1, in __call__
 82     outputs = self.call(inputs, *args, **kwargs)
 83   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/rnn_cell_impl.py", l    ine 383, in call
 84     concat = _linear([inputs, h], 4 * self._num_units, True)
 85   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/rnn_cell_impl.py", l    ine 1017, in _linear
 86     initializer=kernel_initializer)
 87   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/variable_scope.py",     line 1065, in get_variable
 88     use_resource=use_resource, custom_getter=custom_getter)
 89   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/variable_scope.py",     line 962, in get_variable
 90     use_resource=use_resource, custom_getter=custom_getter)
 91   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/variable_scope.py",     line 360, in get_variable
 92     validate_shape=validate_shape, use_resource=use_resource)
 93   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/variable_scope.py",     line 1405, in wrapped_custom_getter
 94     *args, **kwargs)
 95   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/rnn_cell_impl.py", l    ine 183, in _rnn_get_variable
 96     variable = getter(*args, **kwargs)
 97   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/rnn_cell_impl.py", l    ine 183, in _rnn_get_variable
 98     variable = getter(*args, **kwargs)
 99   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/variable_scope.py",     line 352, in _true_getter
100     use_resource=use_resource)
101   File "/home/tf1.0/local/lib/python2.7/site-packages/tensorflow/python/ops/variable_scope.py",     line 664, in _get_single_variable
102     name, "".join(traceback.format_list(tb))))
**103 ValueError: Variable lstm_cell/rnn/multi_rnn_cell/cell_0/basic_lstm_cell/kernel already exists,     disallowed. Did you mean to set reuse=True in VarScope? Originally defined at:**
104
105   File "anna_writer.py", line 110, in add_lstm_cell
106     initial_state=self.initial_state)
107   File "anna_writer.py", line 74, in __init__
108     self.add_lstm_cell()
109   File "anna_writer.py", line 172, in train
110     conf.grad_clip, is_training=True)

# 解决方法
这个问题困扰了我两天，始终找不到解决方案，当我的训练模型和预测模型分开运行时程序没有报错，但是两个程序放在一起运行时就会出现问题，网上搜索的结果大都是关于[共享权重的问题](https://stackoverflow.com/questions/43957967/tensorflow-v1-1-0-multi-rnn-basiclstmcell-error-reuse-parameter-python-3-5)，错误提示是
```bash
ValueError: Variable hello/rnn/basic_lstm_cell/weights already exists, disallowed. Did you mean to set reuse=True in VarScope?
```
，这个error跟我的错误还是有一定的区别的。这些问题主要原因在于使用多层lstm_cell或者双向lstm的时候忽略了定义变量的variable_scope，导致lstm_cell的作用域不一样，但是程序加载的时候并不知道，所以当声明的cell不是同一个的时候，需要用
```python
with tf.variable_scope(name):
```
来定义不同的作用范围就可以了，具体还要根据实际情况。

而我的问题好像网上还没有这样的解释，我仔细看错误的提示，分析我的代码，当train和predict放在一起的时候，会调用两次class language_model：这时候就会出现系统里应该存在两个不同的lstm_cell模型，但是系统无法辨别出来，所以会提示**kernel already exists**，而不是**weights already exists**。

而tensorflow有一个reset_default_graph()函数，

```python
def reset_default_graph():
  """Clears the default graph stack and resets the global default graph.

  NOTE: The default graph is a property of the current thread. This
  function applies only to the current thread.  Calling this function while
  a `tf.Session` or `tf.InteractiveSession` is active will result in undefined
  behavior. Using any previously created `tf.Operation` or `tf.Tensor` objects
  after calling this function will result in undefined behavior.
  """
```
我对python多线程不是很清楚，贴下源码，反正在类中添加这个函数之后之前的问题就解决了。

题外话：tensorflow1.2版本之后，定义多层lstm(```MultiRNNCell```)与原来的版本改变比较大，可以看考[PTB tutorials---Stacking multiple LSTMs](https://www.tensorflow.org/tutorials/recurrent#recurrent-neural-networks).

# 参考文献

[1](http://blog.csdn.net/u014283248/article/details/64440268)
[2](http://www.cnblogs.com/max-hu/p/7101164.html)
[How to reuse weights in MultiRNNCell?](https://stackoverflow.com/questions/43935609/how-to-reuse-weights-in-multirnncell)
[ValueError: Attempt to reuse RNNCell with a different variable scope than its first use.](https://github.com/tensorflow/tensorflow/issues/8191)