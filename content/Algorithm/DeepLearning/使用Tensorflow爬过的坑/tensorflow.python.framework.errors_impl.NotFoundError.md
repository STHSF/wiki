---
title: "tensorflow.python.framework.errors_impl.NotFoundError:Key **** not found in checkpoint"
layout: page
date: 2017-09-20 09:39
---

# 写在前面
一般地，我们在使用tensorflow进行深度学习模型训练之后都可以将模型的训练参数保存下来保存下来，然后结合原有的网络结构就可以进行预测了，但是最近我在使用tf.train.saver保存模型训练参数之后，将程序和模型数据完整移动到另外一台机器上后却不能运行了，具体的错误如下，


# 详细错误提示
```
2017-09-20 09:34:53.387948: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_0/lstm_cell/biases/Adam not found in checkpoint
2017-09-20 09:34:53.388803: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_0/lstm_cell/biases not found in checkpoint
2017-09-20 09:34:53.389190: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/bw/multi_rnn_cell/cell_0/lstm_cell/biases not found in checkpoint
2017-09-20 09:34:53.389261: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/bw/multi_rnn_cell/cell_0/lstm_cell/biases/Adam not found in checkpoint
2017-09-20 09:34:53.389744: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/bw/multi_rnn_cell/cell_1/lstm_cell/weights/Adam_1 not found in checkpoint
2017-09-20 09:34:53.390125: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/bw/multi_rnn_cell/cell_0/lstm_cell/biases/Adam_1 not found in checkpoint
2017-09-20 09:34:53.390239: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/bw/multi_rnn_cell/cell_0/lstm_cell/weights not found in checkpoint
2017-09-20 09:34:53.390600: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/bw/multi_rnn_cell/cell_1/lstm_cell/weights/Adam not found in checkpoint
2017-09-20 09:34:53.391046: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/bw/multi_rnn_cell/cell_0/lstm_cell/weights/Adam not found in checkpoint
2017-09-20 09:34:53.391231: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/bw/multi_rnn_cell/cell_0/lstm_cell/weights/Adam_1 not found in checkpoint
2017-09-20 09:34:53.391686: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/bw/multi_rnn_cell/cell_1/lstm_cell/weights not found in checkpoint
2017-09-20 09:34:53.391904: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/bw/multi_rnn_cell/cell_1/lstm_cell/biases not found in checkpoint
2017-09-20 09:34:53.392092: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/bw/multi_rnn_cell/cell_1/lstm_cell/biases/Adam not found in checkpoint
2017-09-20 09:34:53.392783: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/bw/multi_rnn_cell/cell_1/lstm_cell/biases/Adam_1 not found in checkpoint
2017-09-20 09:34:53.393263: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_0/lstm_cell/biases/Adam_1 not found in checkpoint
2017-09-20 09:34:53.393405: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_0/lstm_cell/weights not found in checkpoint
2017-09-20 09:34:53.393778: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_0/lstm_cell/weights/Adam not found in checkpoint
2017-09-20 09:34:53.394227: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_0/lstm_cell/weights/Adam_1 not found in checkpoint
2017-09-20 09:34:53.394492: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_1/lstm_cell/biases not found in checkpoint
2017-09-20 09:34:53.394676: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_1/lstm_cell/biases/Adam not found in checkpoint
2017-09-20 09:34:53.395168: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_1/lstm_cell/biases/Adam_1 not found in checkpoint
2017-09-20 09:34:53.395385: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_1/lstm_cell/weights not found in checkpoint
2017-09-20 09:34:53.395447: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_1/lstm_cell/weights/Adam not found in checkpoint
2017-09-20 09:34:53.396207: W tensorflow/core/framework/op_kernel.cc:1152] Not found: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_1/lstm_cell/weights/Adam_1 not found in checkpoint
Traceback (most recent call last):
  File "/Users/li/workshop/MyRepository/DeepNaturalLanguageProcessing/segmentation/src/segment.py", line 36, in <module>
    saver.restore(sess, best_model_path)
  File "/Library/Python/2.7/site-packages/tensorflow/python/training/saver.py", line 1457, in restore
    {self.saver_def.filename_tensor_name: save_path})
  File "/Library/Python/2.7/site-packages/tensorflow/python/client/session.py", line 778, in run
    run_metadata_ptr)
  File "/Library/Python/2.7/site-packages/tensorflow/python/client/session.py", line 982, in _run
    feed_dict_string, options, run_metadata)
  File "/Library/Python/2.7/site-packages/tensorflow/python/client/session.py", line 1032, in _do_run
    target_list, options, run_metadata)
  File "/Library/Python/2.7/site-packages/tensorflow/python/client/session.py", line 1052, in _do_call
    raise type(e)(node_def, op, message)
tensorflow.python.framework.errors_impl.NotFoundError: Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_0/lstm_cell/biases/Adam not found in checkpoint
	 [[Node: save_1/RestoreV2_15 = RestoreV2[dtypes=[DT_FLOAT], _device="/job:localhost/replica:0/task:0/cpu:0"](_recv_save_1/Const_0, save_1/RestoreV2_15/tensor_names, save_1/RestoreV2_15/shape_and_slices)]]

Caused by op u'save_1/RestoreV2_15', defined at:
  File "/Users/li/workshop/MyRepository/DeepNaturalLanguageProcessing/segmentation/src/segment.py", line 32, in <module>
    saver = tf.train.Saver()
  File "/Library/Python/2.7/site-packages/tensorflow/python/training/saver.py", line 1056, in __init__
    self.build()
  File "/Library/Python/2.7/site-packages/tensorflow/python/training/saver.py", line 1086, in build
    restore_sequentially=self._restore_sequentially)
  File "/Library/Python/2.7/site-packages/tensorflow/python/training/saver.py", line 691, in build
    restore_sequentially, reshape)
  File "/Library/Python/2.7/site-packages/tensorflow/python/training/saver.py", line 407, in _AddRestoreOps
    tensors = self.restore_op(filename_tensor, saveable, preferred_shard)
  File "/Library/Python/2.7/site-packages/tensorflow/python/training/saver.py", line 247, in restore_op
    [spec.tensor.dtype])[0])
  File "/Library/Python/2.7/site-packages/tensorflow/python/ops/gen_io_ops.py", line 669, in restore_v2
    dtypes=dtypes, name=name)
  File "/Library/Python/2.7/site-packages/tensorflow/python/framework/op_def_library.py", line 768, in apply_op
    op_def=op_def)
  File "/Library/Python/2.7/site-packages/tensorflow/python/framework/ops.py", line 2336, in create_op
    original_op=self._default_original_op, op_def=op_def)
  File "/Library/Python/2.7/site-packages/tensorflow/python/framework/ops.py", line 1228, in __init__
    self._traceback = _extract_stack()

NotFoundError (see above for traceback): Key bi-lstm/bidirectional_rnn/fw/multi_rnn_cell/cell_0/lstm_cell/biases/Adam not found in checkpoint
	 [[Node: save_1/RestoreV2_15 = RestoreV2[dtypes=[DT_FLOAT], _device="/job:localhost/replica:0/task:0/cpu:0"](_recv_save_1/Const_0, save_1/RestoreV2_15/tensor_names, save_1/RestoreV2_15/shape_and_slices)]]
```

## 解决方式
我的模型是在一台装有ubuntu的linux机器上训练的，后来将模型完整移动到一台mac上运行时出现的错误。该错误让我一再觉得我的训练参数并没有完全保存下来，尝试了几种模型参数的保存配置包括在server中添加tf.trainable_variables()，在定义的网络模型中详细的添加各种name_scope()和variable_scope()。以及使用不同的restore的方式。可是还是会报同样的错误。

然后我又开始怀疑我在使用bi-lstm的时候使用了multi-layers，模型保存的时候各个layer里面的参数是否没有保存，但是在查阅很多调用multi_rnn_cell接口的源码中并没有过多的定义variable_scope。问题也不出在这边。

我开始怀疑两个操作系统的环境配置，两者除了python的小版本不同但大版本是相同的(python2.7.6和python2.7.12),python的依赖版本也都是形同的包括tensorflow的版本，为了弄清两台机器是否有问题，我将相同的代码分别在两台机器上训练，并保存参数，然后在同一台机器上load模型，两台机器没有报错。我交换两个保存的训练参数然后运行，两台机出现了相同的错误。

于是基本确定了可能存在问题的地方：1、python的版本原因。2、操作系统的原因。

关于python的版本问题，除了python2和python3的区别比较明显，在小版本之间的区别并不是很大，在这过程中我曾尝试将两台机器安装相同的python版本，奈何visualenv中的python依赖于系统环境，我又不想破坏系统环境，所以泛起了这个想法。

我把希望寄托于不同的操作系统的原因，为了这个原因，我将家里的windows台式机改成ubuntu系统(主要是windows下的linux虚拟机运行tensorflow太慢，实在受不了。)配置完运行环境之后，直接将原来的linux下的代码完整拷贝到这台机器上，运行没有出现问题。(注，两台linux的python也不相同，python2.7.6和python2.7.10)

这让我很欣慰，虽然并没有实质的解决这个问题，但是发现了问题的原因之一，**_两台不同的操作系统之间共享训练模型可能会出错。_**当然我并没有去再找一台mac，然后将两台mac的训练模型交换使用。但我猜测两台mac应该也是可以共享的。

在此过程中也有朋友提示我是否是保存的checkpoint中的路径换成绝对路径，但是测试之后问题依然没有解决。

## 疑惑
在上面的测试过程中，我曾尝试使用一个简单的模型保存程序测试两个不同的操作系统训练模型共享的问题。测试程序如下：
#### 训练程序
```python
import tensorflow as tf
config = tf.ConfigProto()
config.gpu_options.allow_growth = True
sess = tf.Session(config=config)

# Create some variables.
v1 = tf.Variable([1.0, 2.3], name="v1")
v2 = tf.Variable(55.5, name="v2")

# Add an op to initialize the variables.
init_op = tf.global_variables_initializer()

# Add ops to save and restore all the variables.
saver = tf.train.Saver()

ckpt_path = './ckpt/test-model.ckpt'
# Later, launch the model, initialize the variables, do some work, save the
# variables to disk.
sess.run(init_op)
save_path = saver.save(sess, ckpt_path, global_step=1)
print("Model saved in file: %s" % save_path)
```
#### load程序
```python
import tensorflow as tf
config = tf.ConfigProto()
config.gpu_options.allow_growth = True
sess = tf.Session(config=config)

# Create some variables.
v1 = tf.Variable([11.0, 16.3], name="v1")
v2 = tf.Variable(33.5, name="v2")

# Add ops to save and restore all the variables.
saver = tf.train.Saver()

# Later, launch the model, use the saver to restore variables from disk, and
# do some work with the model.
# Restore variables from disk.
ckpt_path = './ckpt/test-model.ckpt'
saver.restore(sess, ckpt_path + '-'+ str(1))
print("Model restored.")

print sess.run(v1)
print sess.run(v2)
```
**训练程序所保存的训练模型数据在两个不同的操作系统却是可以load的，这与上面的问题相冲突。**

## 结论
### 对于不同的操作系统之间的训练模型共享，笔者目前还没有找到相关的解决方法，如果你有好的解决方法请联系我，谢谢

# 续
上面的问题是我自己搞错了，实际上错误原因跟操作系统是没有关系的。最终的原因还是因为我的tensorflow的package版本不一样。原先我在比对两个操作系统python安装包的时候使用的是pip list来查看的，两个操作系统的主要的python包都一样。为了保险起见，我还使用requestment.txt将两个系统的python完全统一。按理说再出现错误就不是python环境的问题。但是至始至终我都忽略了一个问题，我在mac下使用的是pycharm来运行程序的，虽然我使用的interpreter是python2.7的那个环境，而且在pycharm的自带终端里使用pip list 也是显示的相同的包。

但是今天我在更换interpreter的时候偶然发现一个问题，从interpreter的预览的包版本和使用pip list的包版本竟然不一样，具体原因我先不深究。但我可以确定的是这两个图是同一个python环境。

<center><img src="/wiki/static/images/keng/Preferences.png" alt="p1"/></center>
<center><img src="/wiki/static/images/keng/preference2.png" alt="p2"/></center>

后来为了验证这个原因，我使用virtualenv安装了一个与上面的linux一样的python的虚拟环境，将虚拟环境设置为pycharm的interpreter，然后运行从linux上拷贝下来的程序和模型。运行没有出错。

# 所以最终的原因还是python依赖包的版本不同导致的。另外也间接说明了上面那个小程序的合理性，由于程序比较简单，不同版本的依赖包的兼容性问题并没有体现出来，所以没有报错。这个坑也是醉了，但是pycharm的那个问题还没解决，但是IDE的问题跟程序没什么太大的关联。


# 参考文献
[文中提示错误的相关代码---bidirectiona_rnn实现中文分词](https://github.com/STHSF/DeepNaturalLanguageProcessing/tree/master/segmentation)