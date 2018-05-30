---
title: "Tensorflow---tf.summary使用的坑"
layout: page
date: 2018-05-30 00:00
---

# 写在前面
Tensorboard可以方便的展示神经网络搭建过程，方便查看其中的每一个变量，主要的函数接口就是tf.summary。最近我在搭建神经网络模型的时候遇到了一些问题，记录下来。原先我使用的tensorflow是1.4版本，最近更新到了1.8版本。升级tensorflow的同时，原来代码中的一些接口有相应的变化。

原本在构建神经网络类的时候，使用的是tf.summary.merge_all(), 但是merge_all()是将训练过程中的所有的变量全部保存下来，后来替换成了tf.summary.merge(), 运行过程中出现了下面的错误一，提示inputs参数没有输入，刚开始以为是函数接口改变了，然后还是换成tf.summary.merge_all(),提示没有输入参数，或者输入参数类型不对。在修改了参数之后依然是相同的报错。网上搜到一些相同的报错，但是错误的内容都不一样。
# 详细错误提示
### 错误一
```
Traceback (most recent call last):
  File "/Users/li/PycharmProjects/RBFuture/src/lstm_n_to_1/model_training.py", line 160, in <module>
    main()
  File "/Users/li/PycharmProjects/RBFuture/src/lstm_n_to_1/model_training.py", line 117, in main
    train_model = RBlstm(train_scope)
  File "/Users/li/PycharmProjects/RBFuture/src/lstm_n_to_1/lstm_model.py", line 46, in __init__
    self.merged = tf.summary.merge(tf.get_collection(tf.GraphKeys.SUMMARIES, name_scope))
  File "/Users/li/PycharmProjects/RBFuture/venv/lib/python2.7/site-packages/tensorflow/python/summary/summary.py", line 298, in merge
    val = _gen_logging_ops.merge_summary(inputs=inputs, name=name)
  File "/Users/li/PycharmProjects/RBFuture/venv/lib/python2.7/site-packages/tensorflow/python/ops/gen_logging_ops.py", line 468, in merge_summary
    "MergeSummary", inputs=inputs, name=name)
  File "/Users/li/PycharmProjects/RBFuture/venv/lib/python2.7/site-packages/tensorflow/python/framework/op_def_library.py", line 570, in _apply_op_helper
    (input_name, op_type_name, len(values), num_attr.minimum))
ValueError: List argument 'inputs' to 'MergeSummary' Op with length 0 shorter than minimum length 1.
```
### 错误二
```
Traceback (most recent call last):
  File "/Users/li/PycharmProjects/RBFuture/src/lstm_n_to_1/model_training.py", line 160, in <module>
    main()
  File "/Users/li/PycharmProjects/RBFuture/src/lstm_n_to_1/model_training.py", line 154, in main
    summary = session.run(train_model.merged, feed_dict=feed_dict)
  File "/Users/li/PycharmProjects/RBFuture/venv/lib/python2.7/site-packages/tensorflow/python/client/session.py", line 900, in run
    run_metadata_ptr)
  File "/Users/li/PycharmProjects/RBFuture/venv/lib/python2.7/site-packages/tensorflow/python/client/session.py", line 1120, in _run
    self._graph, fetches, feed_dict_tensor, feed_handles=feed_handles)
  File "/Users/li/PycharmProjects/RBFuture/venv/lib/python2.7/site-packages/tensorflow/python/client/session.py", line 427, in __init__
    self._fetch_mapper = _FetchMapper.for_fetch(fetches)
  File "/Users/li/PycharmProjects/RBFuture/venv/lib/python2.7/site-packages/tensorflow/python/client/session.py", line 242, in for_fetch
    type(fetch)))
TypeError: Fetch argument None has invalid type <type 'NoneType'>
```

## 解决方式
对于错误二，google上有很多人遇到这个问题，但是大部分错误的原因都是某一个op重新赋值导致变量变成None。等等其他原因。后来我突然发现我使用tf.summary来搜集参数，可是我的模型中却没有添加一些summaries，最后导致了这个问题，所以我在模型中通过tf.summary.scalar()和tf.summary.histogram()等需要记录的变量之后问题就解决了。

## 疑惑
具体使用tf.summary.merge_all()和tf.summary.merge()的区别在哪里我还没有搞懂，后面用到之后再讨论。

# 参考文献
[TypeError: Fetch argument None has invalid type <class 'NoneType'> ](https://github.com/RobRomijnders/LSTM_tsc/issues/3)
[Tensorflow TypeError: Fetch argument None has invalid type <type 'NoneType'>?](https://stackoverflow.com/questions/39114832/tensorflow-typeerror-fetch-argument-none-has-invalid-type-type-nonetype)