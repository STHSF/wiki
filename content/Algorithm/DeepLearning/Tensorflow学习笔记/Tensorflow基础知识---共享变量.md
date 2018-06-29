---
title: "Tensorflow基础知识---共享变量(name_scope()和variable_scope()的区别)"
layout: page
date: 2017-07-25 23:00
---

# 写在前面
工作之余，学习tensorflow已经有一段时间了，时间总是零零碎碎，期间也用tensorflow搭建过一些框架，但是代码都是在参考别人的基础上实现的，随着对模型的深入，开始自己写代码框架，在写的过程中发现自己的基础不是很扎实，特别是对Tensorflow的一些基础的api并不是完全领会，当初只是知道别人是这么用的，所以我也跟着用了。现在自己的定义的时候发现他们之间的差别不是很清楚，所以还是得静下心来把这些基础知识弄清楚。

# tf.Variable() & tf.get_variable()
在了解tf.name_scope() & tf.variable_scope()的之间的区别的时候，我们的先需要了解Tensorflow中的变量的定义。

### 代码1
```
import tensorflow as tf

var1 = tf.Variable(name='var1', initial_value=[1], dtype=tf.float32)
var2 = tf.Variable(name='var2', initial_value=[2], dtype=tf.float32)

initializer = tf.constant_initializer(value=1)
var3 = tf.get_variable(name='var3', initializer=initializer, shape=[1], dtype=tf.float32)
var4 = tf.get_variable(name='var4', initializer=initializer, shape=[1], dtype=tf.float32)

with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())
    print(var1.name)
    print(sess.run(var1))
    print(var2.name)
    print(sess.run(var2))
    
    print(var3.name)
    print(sess.run(var3))
    print(var4.name)
    print(sess.run(var4))
```
运行结果：
```
var1:0
[1.]
var2:0
[2.]
var3:0
[1.]
var4:0
[1.]
```
在保持其他代码不变的情况下，我们把name修改成相同的之后，运行代码
### 代码2
```
import tensorflow as tf

var1 = tf.Variable(name='var1', initial_value=[1], dtype=tf.float32)
var2 = tf.Variable(name='var1', initial_value=[2], dtype=tf.float32)

with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())
    print(var1.name)
    print(sess.run(var1))
    print(var2.name)
    print(sess.run(var2))
```
输出结果
```
var1:0
[1.]
var1_1:0
[2.]
```
### 代码3
```
import tensorflow as tf

initializer = tf.constant_initializer(value=1)
var3 = tf.get_variable(name='var3', initializer=initializer, shape=[1], dtype=tf.float32)
var4 = tf.get_variable(name='var3', initializer=initializer, shape=[1], dtype=tf.float32)

with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())
    print(var3.name)
    print(sess.run(var3))
    print(var4.name)
    print(sess.run(var4))
```
输出结果
```
ValueError: Variable var3 already exists, disallowed. Did you mean to set reuse=True or reuse=tf.AUTO_REUSE in VarScope? Originally defined at:

  File "<ipython-input-2-02038677e4f2>", line 7, in <module>
    var3 = tf.get_variable(name='var3', initializer=initializer, shape=[1], dtype=tf.float32)
  File "/home/jerry/workshop/virtualenv/tensor_jupyer/local/lib/python2.7/site-packages/IPython/core/interactiveshell.py", line 2878, in run_code
    exec(code_obj, self.user_global_ns, self.user_ns)
  File "/home/jerry/workshop/virtualenv/tensor_jupyer/local/lib/python2.7/site-packages/IPython/core/interactiveshell.py", line 2818, in run_ast_nodes
    if self.run_code(code, result):
```
**代码1中可以看出，如果变量名不重复的情况下，两种variabe的op是没有问题的，但是如果在同样的变量名重复使用的情况下，tf.Varibale()操作会自动的创建新的对象，并以一定的命名方式保存（代码2），就是说在使用tf.Variable()定义变量时，如果系统检测到命名冲突，系统会自己处理，但是在使用tf.get_variable()时，系统不会自动处理，而是会报错(代码2)，这里面涉及到Tensorflow的变量共享的问题。**

**在深度学习的一些结构中比如RNN，需要用到共享变量，这时候就需要使用tf.get_variable()来让变量得到共享，该函数就是为了共享变量而准备的，在其他情况下，两种方法的用法是一样的**

# tf.name_scope() & tf.variable_scope()
那么如何使用共享变量呢，Tensorflow给出了两个作用域函数，tf.name_scope()和tf.variable_scope()函数，同样我们先看一组对比。

```
import tensorflow as tf
# 1
var1 = tf.Variable(name='var1', initial_value=[1], dtype=tf.float32)
var2 = tf.Variable(name='var1', initial_value=[2], dtype=tf.float32)
# 2
with tf.variable_scope('var_scope1'):
    var3 = tf.Variable(name='var1', initial_value=[1], dtype=tf.float32)
    var4 = tf.Variable(name='var1', initial_value=[2], dtype=tf.float32)
# 3    
with tf.name_scope('name_scope1'):
    var5 = tf.Variable(name='var1', initial_value=[1], dtype=tf.float32)
    var6 = tf.Variable(name='var1', initial_value=[2], dtype=tf.float32)
# 4
with tf.variab_scope('var_scope2'):
    var7 = tf.Variable(name='var1', initial_value=[1], dtype=tf.float32)
# 5
with tf.name_scope('name_scope2'):
    var8 = tf.Variable(name='var1', initial_value=[1], dtype=tf.float32)
# 6
initializer = tf.constant_initializer(value=1)
with tf.variable_scope('var_scope3', reuse=tf.AUTO_REUSE):
    var9 = tf.get_variable(name='var', initializer=initializer, shape=[1], dtype=tf.float32)
    var10 = tf.get_variable(name='var', initializer=initializer, shape=[1], dtype=tf.float32)
# 7    
with tf.name_scope('name_scope3'):
    var11 = tf.get_variable(name='var1', initializer=initializer, shape=[1], dtype=tf.float32)
    var12 = tf.get_variable(name='var', initializer=initializer, shape=[1], dtype=tf.float32)

with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())
    print(var1.name)
    print(sess.run(var1))
    print(var2.name)
    print(sess.run(var2))
    
    print(var3.name)
    print(sess.run(var3))
    print(var4.name)
    print(sess.run(var4))
    
    print(var5.name)
    print(sess.run(var5))
    print(var6.name)
    print(sess.run(var6))

    print(var7.name)
    print(sess.run(var7))
    print(var8.name)
    print(sess.run(var8))
    
    print(var9.name)
    print(sess.run(var9))
    print(var10.name)
    print(sess.run(var10))

    print(var11.name)
    print(sess.run(var11))
    print(var12.name)
    print(sess.run(var12))
```
输出结果
```
var1:0
[1.]
var1_1:0
[2.]

var_scope1/var1:0
[1.]
var_scope1/var1_1:0
[2.]

name_scope1/var1:0
[1.]
name_scope1/var1_1:0
[2.]

var_scope2/var1:0
[1.]

name_scope2/var1:0
[1.]

var_scope3/var:0
[1.]
var_scope3/var:0
[1.]

var1_2:0
[1.]
var:0
[1.]
```
**观察代码块2和代码块3，同一个Variable_scope或者name_scope下的tf.Variable()同名变量会被自动设置别名，而tf.get_variable()则会报错**
**对比代码块2，3，4，5，不同Variable_scope或者name_scope下的tf.Variable()同名变量，其完整变量名不同，(因为Variable_scope或者name_scope不同)，所以他们不是同一个变量**
**代码块6，要设置tf.get_variable()同名变量，需要在tf.Variable_scope()下申明共享。variable_scope下声明共享后，tf.Variable()同名变量指向两个不同变量实体，而tf.get_variable ()同名变量则指向同一个变量实体。**
**对比代码块1,代码块2和代码块3的结果,当使用tf.Variable定义变量的时候，tf.name_scope和tf.variable_scope的作用相同，都受到了层级控制。其他没有变化**
**对比代码块1和代码块5的结果，tf.Variable()所创建的变量受name_scope的层级控制，而tf.get_variable()则不受name_scope的层级控制。所以使用tf.name_scope和tf.get_variable()联合使用没有效果。**
** tf.Variable()的变量名称是可选参数，而tf.get_variable()的变量名称是必填参数。**
****
****


# 参考文献
[ tensorflow学习笔记（二十三）：variable与get_variable](http://blog.csdn.net/u012436149/article/details/53696970)
[tensorflow学习笔记(十五): variable scope](http://www.2cto.com/kf/201611/562404.html)
[tf.variable_scope和tf.name_scope的用法](http://blog.csdn.net/uestc_c2_403/article/details/72328815)
[TF Boys (TensorFlow Boys ) 养成记（三）： TensorFlow 变量共享](http://www.cnblogs.com/Charles-Wan/p/6200446.html)
