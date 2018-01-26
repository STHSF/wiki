---
title: "Tensorflow基础知识---concat用法"
layout: page
date: 2018-01-17 00:00
---

# 写在前面
主要注意参数中的维度选择


```python
import tensorflow as tf
import numpy as np
```

```python
t1 = [[1,2,3], [4,5,6]]
t2 = [[7,8,9], [3,4,5]]

t3 = tf.concat([t1, t2], 0)
t4 = tf.concat([t1, t2], 1)
```

```python
sess = tf.InteractiveSession()
sess.run(tf.global_variables_initializer())

print sess.run(t3)
print sess.run(t4)
```

    [[1 2 3]
     [4 5 6]
     [7 8 9]
     [3 4 5]]
    [[1 2 3 7 8 9]
     [4 5 6 3 4 5]]

