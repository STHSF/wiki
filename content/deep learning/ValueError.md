---
title: "ValueError: Variable lstm_cell/rnn/multi_rnn_cell/cell_0/basic_lstm_cell/kernel already exists,     disallowed. Did you mean to set reuse=True in VarScope? Originally defined at:"
layout: page
date: 2017-07-10 09:00
---

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
103 ValueError: Variable lstm_cell/rnn/multi_rnn_cell/cell_0/basic_lstm_cell/kernel already exists,     disallowed. Did you mean to set reuse=True in VarScope? Originally defined at:
104
105   File "anna_writer.py", line 110, in add_lstm_cell
106     initial_state=self.initial_state)
107   File "anna_writer.py", line 74, in __init__
108     self.add_lstm_cell()
109   File "anna_writer.py", line 172, in train
110     conf.grad_clip, is_training=True)

# 解决方法

[stackoverflow](https://stackoverflow.com/questions/43957967/tensorflow-v1-1-0-multi-rnn-basiclstmcell-error-reuse-parameter-python-3-5)

