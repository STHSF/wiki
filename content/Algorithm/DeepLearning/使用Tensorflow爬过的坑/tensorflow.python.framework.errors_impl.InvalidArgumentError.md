---
title: "tensorflow.python.framework.errors_impl.InvalidArgumentError:"
layout: page
date: 2017-11-06 00:00
---

# 写在前面
我们使用tensorflow搭建深度神经网络的时候，如果模型比较复杂，很难直观的去理解模型。TensorBoard可视化工具包可以帮助我们更好的理解网络结构和参数，网络上大部分教程在定义神经网络模型的时候都是相对比较简单的方式，一般套路都是输入数据、输入层、隐藏层、输出层、损失、session初始化、模型训练。
在这过程中使用summary.scalar或者histogram等将过程中所要展示的变量标记出来，然后使用merge_all()将图形和训练过程等数据合并在一起并使用summary.FileWriter()保存到某一文件夹下。
一般地，基本上不会出现问题。但是如果我在模型的training过程中想要使用Dropout将input或者网络结构中的某些节点drop掉，但是我在使用valid和test的过程中却不需要使用这个op，所以需要建立多个模型，让他们共享变量，这时候我们在可视化数据的时候往往可能会出现问题。


# 错误提示
```
Traceback (most recent call last):
  File "/Users/li/PycharmProjects/StockIndexFutures/src/model.py", line 282, in <module>
    valid_acc, valid_cost = run_epoch(valid, valid_model, session)  # valid
  File "/Users/li/PycharmProjects/StockIndexFutures/src/model.py", line 206, in run_epoch
    summary_ = session.run(model.merged, feed_dict=feed_dict_)
  File "/Users/li/workshop/virtualenv/stockindexfuture/lib/python2.7/site-packages/tensorflow/python/client/session.py", line 889, in run
    run_metadata_ptr)
  File "/Users/li/workshop/virtualenv/stockindexfuture/lib/python2.7/site-packages/tensorflow/python/client/session.py", line 1120, in _run
    feed_dict_tensor, options, run_metadata)
  File "/Users/li/workshop/virtualenv/stockindexfuture/lib/python2.7/site-packages/tensorflow/python/client/session.py", line 1317, in _do_run
    options, run_metadata)
  File "/Users/li/workshop/virtualenv/stockindexfuture/lib/python2.7/site-packages/tensorflow/python/client/session.py", line 1336, in _do_call
    raise type(e)(node_def, op, message)
tensorflow.python.framework.errors_impl.InvalidArgumentError: You must feed a value for placeholder tensor 'Train/Model/input_data/inputs' with dtype int32 and shape [100,6]
	 [[Node: Train/Model/input_data/inputs = Placeholder[dtype=DT_INT32, shape=[100,6], _device="/job:localhost/replica:0/task:0/device:CPU:0"]()]]

Caused by op u'Train/Model/input_data/inputs', defined at:
  File "/Users/li/PycharmProjects/StockIndexFutures/src/model.py", line 221, in <module>
    train_model = language_model(train_scope, is_training=True, config=train_conf)
  File "/Users/li/PycharmProjects/StockIndexFutures/src/model.py", line 91, in __init__
    self.graph()
  File "/Users/li/PycharmProjects/StockIndexFutures/src/model.py", line 107, in graph
    shape=(self.batch_size, self.seq_length), name='inputs')    # [batch_size, seq_length]
  File "/Users/li/workshop/virtualenv/stockindexfuture/lib/python2.7/site-packages/tensorflow/python/ops/array_ops.py", line 1599, in placeholder
    return gen_array_ops._placeholder(dtype=dtype, shape=shape, name=name)
  File "/Users/li/workshop/virtualenv/stockindexfuture/lib/python2.7/site-packages/tensorflow/python/ops/gen_array_ops.py", line 3091, in _placeholder
    "Placeholder", dtype=dtype, shape=shape, name=name)
  File "/Users/li/workshop/virtualenv/stockindexfuture/lib/python2.7/site-packages/tensorflow/python/framework/op_def_library.py", line 787, in _apply_op_helper
    op_def=op_def)
  File "/Users/li/workshop/virtualenv/stockindexfuture/lib/python2.7/site-packages/tensorflow/python/framework/ops.py", line 2956, in create_op
    op_def=op_def)
  File "/Users/li/workshop/virtualenv/stockindexfuture/lib/python2.7/site-packages/tensorflow/python/framework/ops.py", line 1470, in __init__
    self._traceback = self._graph._extract_stack()  # pylint: disable=protected-access

InvalidArgumentError (see above for traceback): You must feed a value for placeholder tensor 'Train/Model/input_data/inputs' with dtype int32 and shape [100,6]
	 [[Node: Train/Model/input_data/inputs = Placeholder[dtype=DT_INT32, shape=[100,6], _device="/job:localhost/replica:0/task:0/device:CPU:0"]()]]
```

# 解决方法
刚开始，我将tf.summary.merge_all()移到Graph中，就是说后面在定义不同的模型是merged_summary也是不同的，后面在主程序中使用不同的数据进行feed，但是问题依然存在，在运行train_model的时候没有出现问题。但是在运行valid_model时依然会提示类似于上面的错误。

后来在网上找到有人将tf.summary.merge_all()替换成tf.summary.marge(),并且在其中添加参数tf.get_collection(tf.GraphKeys.SUMMARIES, name_scope)，其中name_scope是指后面声明的train_model、valid_model和test_model。

这里面涉及到不同model的summary的定义，tensorflow中Summary被收集在tf.GraphKeys.SUMMARYIES的collection中。Summary是对网络中Tensor的取值进行监测的一种opetation。所以tensorflow中的各种collection还需仔细理解一下。

下面是调试后的部分源码：
## Graph中的定义

```
class language_model:
    def __init__(self, scope, config, is_training=True):

        self.learning_rate = config.learning_rate
        self.num_layers = config.num_layers
        self.hidden_units = config.hidden_units
        self.is_training = is_training
        self.keep_prob = config.keep_prob
        self.grad_clip = config.grad_clip
        self.num_classes = config.num_classes
        self.batch_size = config.batch_size
        self.seq_length = config.num_steps
        self.graph()
        self.merged = tf.summary.merge(tf.get_collection(tf.GraphKeys.SUMMARIES, scope))

        with tf.name_scope('saver'):
            self.saver = tf.train.Saver(max_to_keep=100)

    def graph(self):
        # if self.is_training:
        #     self.batch_size = config.batch_size
        #     self.seq_length = config.num_steps
        # else:
        #     self.batch_size = 1
        #     self.seq_length = config.num_steps
        with tf.name_scope('input_data'):
            self.x = tf.placeholder(tf.int32,
                                    shape=(self.batch_size, self.seq_length), name='inputs')    # [batch_size, seq_length]
            self.y = tf.placeholder(tf.int32,
                                    shape=(self.batch_size, self.seq_length), name='targets')   # [batch_size, seq_length]
            # One-hot编码
            self.inputs = tf.one_hot(self.x, self.num_classes)           # [batch_size, seq_length, num_classes]
            # self.inputs = tf.reshape(self.y, [-1, self.num_classes])
            self.targets = tf.one_hot(self.y, self.num_classes)          # [batch_size, seq_length, num_classes]

        with tf.name_scope('multi_cell'):
            stacked_cells = tf.contrib.rnn.MultiRNNCell([self.lstm_cell() for _ in range(self.num_layers)],
                                                        state_is_tuple=True)

        with tf.name_scope('initial_state'):
            # initial_state: [batch_size, hidden_units * num_layers]
            self.initial_state = stacked_cells.zero_state(self.batch_size, dtype=tf.float32)

        with tf.name_scope('dynamic_rnn'):
            # cell_output: [batch_size, seq_length, hidden_units]
            # final_state: [batch_size, hidden_units * num_layers]
            self.cell_outputs, self.final_state = tf.nn.dynamic_rnn(cell=stacked_cells,
                                                                    inputs=self.inputs,
                                                                    initial_state=self.initial_state)

            seq_output = tf.concat(self.cell_outputs, axis=1)
            output = tf.reshape(seq_output, [-1, self.hidden_units])  # y0: [batch_size * seq_length, hidden_units]
            # y0 = tf.reshape(self.cell_outputs, [-1, self.hidden_units]) # y0: [batch_size * seq_length, hidden_units]

        with tf.name_scope('output_layer'):
            with tf.name_scope('softmax'):
                sofmax_w = tf.Variable(tf.truncated_normal([self.hidden_units, self.num_classes], stddev=0.1))
                softmax_b = tf.Variable(tf.zeros(self.num_classes))

            with tf.name_scope('wx_plus_b'):
                self.logits = tf.matmul(output, sofmax_w) + softmax_b  # logits: [batch_size * seq_length, num_classes]
            self.prediction = tf.nn.softmax(logits=self.logits, name='prediction')

        with tf.name_scope('acc_compute'):
            correct_prediction = tf.equal(tf.cast(tf.argmax(self.prediction, 1), tf.int32), tf.reshape(self.y, [-1]))
            # aa = tf.reshape(self.targets, [-1, self.num_classes])
            # correct_prediction = tf.equal(tf.cast(tf.argmax(self.prediction, 1), tf.int32),
            #                               tf.cast(tf.argmax(aa, 1), tf.int32))
            self.accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
            tf.summary.scalar('acc', self.accuracy)

        with tf.name_scope('loss'):
            # y_reshaped: [batch_size * seq_length, num_classes]
            y_reshaped = tf.reshape(self.targets, self.logits.get_shape())

            # Softmax cross entropy loss
            # _loss: [batch_size, seq_length]
            _loss = tf.nn.softmax_cross_entropy_with_logits(logits=self.logits, labels=y_reshaped)
            # 带权重的交叉熵计算
            # loss = tf.contrib.seq2seq.sequence_loss(
            #     [self.logits],   # output [batch*numsteps, vocab_size]
            #     [tf.reshape(self.y, [-1])],  # target, [batch_size, num_steps] 然后展开成一维【列表】
            #     [tf.ones([self.batch_size , self.seq_length], dtype=tf.float32)])  # weight

            self.loss = tf.reduce_mean(_loss)
            tf.summary.scalar("Loss", self.loss)

            if not self.is_training:
                return

            with tf.name_scope('optimizer'):
                tvars = tf.trainable_variables()
                grads, _ = tf.clip_by_global_norm(tf.gradients(self.loss, tvars), self.grad_clip)
                train_op = tf.train.AdamOptimizer(self.learning_rate)
                self.train_op = train_op.apply_gradients(zip(grads, tvars),
                                                         global_step=tf.train.get_or_create_global_step())

    def lstm_cell(self):
        # Or GRUCell, LSTMCell(args.hiddenSize)
        with tf.variable_scope('lstm_cell'):
            cell = tf.contrib.rnn.BasicLSTMCell(self.hidden_units,
                                                state_is_tuple=True)

        if self.is_training:
            cell = tf.contrib.rnn.DropoutWrapper(cell,
                                                 input_keep_prob=1.0,
                                                 output_keep_prob=self.keep_prob)
        return cell
```

## 会话中的调用
```
with tf.Graph().as_default():
    initializer = tf.random_uniform_initializer(-train_conf.init_scale, train_conf.init_scale)

    with tf.name_scope("Train") as train_scope:
        with tf.variable_scope("Model", reuse=None, initializer=initializer):
            train_model = language_model(train_scope, is_training=True, config=train_conf)
            # tf.summary.scalar("Training Loss", train_model.loss)
            # tf.summary.scalar("Training acc", train_model.accuracy)

    with tf.name_scope("Valid") as valid_scope:
        with tf.variable_scope("Model", reuse=True, initializer=initializer):
            valid_model = language_model(valid_scope, is_training=False, config=valid_conf)
            # tf.summary.scalar("Valid Loss", valid_model.loss)
            # tf.summary.scalar("Valid acc", valid_model.accuracy)

    with tf.name_scope("Test")as test_scope:
        with tf.variable_scope("Model", reuse=True, initializer=initializer):
            test_model = language_model(test_scope, is_training=False, config=valid_conf)

    # CheckPoint State
    # ckpt = tf.train.get_checkpoint_state(conf.model_save_path)
    # if ckpt:
    #     print("Loading model parameters from %s" % ckpt.model_checkpoint_path)
    #     train_model.saver.restore(session, tf.train.latest_checkpoint(conf.model_save_path))
    # else:
    #     print("Created model with fresh parameters.")

    with tf.Session() as session:

        train_summary_writer = tf.summary.FileWriter('./model/tensorflowlogs/train', session.graph)
        test_summary_writer = tf.summary.FileWriter('./model/tensorflowlogs/test')
        session.run(tf.global_variables_initializer())
```

# 参考文献
[常用集合: Variable, Summary, 自定义](http://blog.csdn.net/shenxiaolu1984/article/details/52815641)
[tensorflow学习笔记（二十九）：merge_all引发的血案](http://blog.csdn.net/u012436149/article/details/53894364)