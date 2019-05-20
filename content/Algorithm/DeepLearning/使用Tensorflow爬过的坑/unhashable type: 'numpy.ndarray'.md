---
title: "TypeError: unhashable type: 'numpy.ndarray'"
layout: page
date: 2019-05-20 23:30
---
[TOC]

# 写在前面

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

# 参考文献
