---
title: "TypeError: unhashable type: 'numpy.ndarray'"
layout: page
date: 2019-05-20 23:30
---
[TOC]

# 写在前面
这个错误很蛋疼, 你会去检查feed数据的数据类型和palceholder的定义类型是否一致, 你会检查feed_dict的输入类型支不支持numpy.ndarray, 甚至于你还会去查unhashable的原因. 或者会试图把ndarray改写成list. 很有可能你会解决这个问题, 但是我的解决方式却非常的神奇, stackoverflow上有人剔骨类似的问题, 然后有人提示让你注意一下变量的名字, 然后我检查了一下我的代码, 发现定义的placeholder和输入变量的名字是一样的, 然后我尝试把两者使用不同的命名, 问题解决 


# 错误提示
```
Traceback (most recent call last):
  File "demo.py", line 193, in <module>
    detector()
  File "demo.py", line 175, in detector
    preds = sess.run(decodes, feed_dict={bbox:roi.reshape(1, 4), feature_map_np: feature_map_np})
TypeError: unhashable type: 'numpy.ndarray'
```
这是由于变量名与占位符名冲突导致的

# 解决方法
```
# 部分代码
feature_map_np_p = tf.placeholder(tf.float32, shape=[1, None, None, 512], name='feature_map_np')
bbox = tf.placeholder(tf.float32, shape=[1,4], name='rol')
....
....
preds = sess.run(decodes, feed_dict={bbox:roi.reshape(1, 4), feature_map_np_p: feature_map_np})
# 注意placeholder那边也要修改

```


# 参考文献
[TypeError: unhashable type: 'numpy.ndarray' Tensorflow](https://stackoverflow.com/questions/43664985/typeerror-unhashable-type-numpy-ndarray-tensorflow)