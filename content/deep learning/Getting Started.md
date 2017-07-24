---
title: "Tensorflow中准备一个batch的数据的看法"
layout: page
date: 2099-06-02 00:00
---

# 写在前面
在深度学习中除了模型最重要之外，数据更为重要，数据格式是模型输入的第一步，这里暂时只讨论batch_size的含义，如何准备batch_size的训练集数据,并不去过多的讨论如何batch_size的大小对学习效果的影响。

# batch_size
准备batch_size的数据的原因主要是训练集在执行反向传播时需要用到梯度下降算法，使用所有样本进行训练的时候，会使得训练的时间复杂度大大增加，因此采用mini-batch的形式来进行参数寻优。
主要的思想就是每次训练使用batch_size个数据进行参数寻优，一批中的数据共同决定了本次梯度的方向。

# batch_size中涉及到的参数
## 时间序列的数据
对于时间序列的数据集，模型的输入格式为$([batch_size, seq_length, input_dim])$, 其中，batch_size表示一个batch中的样本的个数，seq_length表示序列的长度，input_dim表示输入样本的维度。
那实际工程下如何取准备这些数据呢，我们假设样本训练集$([x_1, x_2, x_3, ..., x_{datalength}])$的长度为data_length，事实上有两种截取方式。
### 法一
第一种就是先按照seq_length这个窗口进行截取，然后按照bacth_size个数据向后依次截取，则总的迭代次数iterations = data_length// 则一个batch中的第一行数据可以表示为$([x_1, x_2, ...,x_{seqlength}])$,第二行的数据可以表示为$([x_{seqlength+1}, x_{seqlength+2}, ..., x_{seqlength+x_{seqlength+1}}])$, 最后一行数据可以表示为$([x_{batch_size}])$
### 程序模拟
假设序列为:[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]

```python
import numpy as np

batch_size = 10
seq_length = 3
raw_data = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]

def get_batch(raw_data, batch_size, seq_length):
    data = np.array(raw_data)
    data_length = data.shape[0]
    num_steps = data_length - seq_length + 1
    iterations = num_steps // batch_size
    xdata=[]
    ydata=[]
    for i in range(num_steps-1):
        xdata.append(data[i:i+seq_length])
        ydata.append(data[i+1:i+1+seq_length])

    for batch in range(iterations):
        x = np.array(xdata)[batch * batch_size: batch * batch_size + batch_size, :]
        y = np.array(xdata)[batch * batch_size + 1: batch * batch_size + 1 + batch_size, :]
        yield x, y
```
输出的训练集数据的格式为：
```
x1: [[1 2 3]
     [2 3 4]
     [3 4 5]
     [4 5 6]]
y1: [[2 3 4]
     [3 4 5]
     [4 5 6]
     [5 6 7]]
x2: [[ 5  6  7]
     [ 6  7  8]
     [ 7  8  9]
     [ 8  9 10]]
y2: [[ 6  7  8]
     [ 7  8  9]
     [ 8  9 10]
     [ 9 10 11]]
x3: [[ 9 10 11]
     [10 11 12]
     [11 12 13]
     [12 13 14]]
y3: [[10 11 12]
     [11 12 13]
     [12 13 14]
     [13 14 15]]
x4: [[13 14 15]
     [14 15 16]
     [15 16 17]
     [16 17 18]]
y4: [[14 15 16]
     [15 16 17]
     [16 17 18]
     [17 18 19]]
```


### 法二
第二种方法以bacth_size和seq_length为基础一个batch中应该包含的数据个数为batch_size * seq_length个数据，那么iterations= data_length//(batch_size * seq_length).
- step1、利用numpy中的矩阵技巧，先将序列reshpe成[batch_size, seq_length* iterations]的形状，
- step2、然后利用for循环将reshape后的数据截取成若干个batch。

### 程序模拟

```python
import numpy as np

batch_size = 4
seq_length = 3
raw_data = [1,2,3,4,5,6,7,8,9,10,11,12,13,
            14,15,16,17,18,19,20, 21, 22, 
            23, 24, 25, 26, 27, 28, 29, 30, 
            31, 32, 33, 34, 35, 36, 37, 38, 39, 40]

def get_batch2(raw_data, batch_size, seq_length):
    data = np.array(raw_data)
    data_length = data.shape[0]
    iterations = (data_length - 1) // (batch_size * seq_length)
    round_data_len = iterations * batch_size * seq_length
    xdata = data[:round_data_len].reshape(batch_size, iterations*seq_length)
    ydata = data[1:round_data_len+1].reshape(batch_size, iterations*seq_length)

    for i in range(iterations):
        x = xdata[:, i*seq_length:(i+1)*seq_length]
        y = ydata[:, i*seq_length:(i+1)*seq_length]
        yield x, y
```
step1 产生的结果为：

```
x：
[[ 1  2  3  4  5  6  7  8  9]
 [10 11 12 13 14 15 16 17 18]
 [19 20 21 22 23 24 25 26 27]
 [28 29 30 31 32 33 34 35 36]]
对应的标签y为：
[[ 2  3  4  5  6  7  8  9 10]
 [11 12 13 14 15 16 17 18 19]
 [20 21 22 23 24 25 26 27 28]
 [29 30 31 32 33 34 35 36 37]]
```
step2 生成的结果为：
```
x1: [[ 1  2  3]
     [10 11 12]
     [19 20 21]
     [28 29 30]]
y1: [[ 2  3  4]
     [11 12 13]
     [20 21 22]
     [29 30 31]]
x2: [[ 4  5  6]
     [13 14 15]
     [22 23 24]
     [31 32 33]]
y2: [[ 5  6  7]
     [14 15 16]
     [23 24 25]
     [32 33 34]]
x3: [[ 7  8  9]
     [16 17 18]
     [25 26 27]
     [34 35 36]]
y3: [[ 8  9 10]
     [17 18 19]
     [26 27 28]
     [35 36 37]]
```

#总结
目前我还不能确定第一种方法的正确性，但是从生产的结果上来看我没有找到明显的错误，第二种方法是我看到的大部分人在准备训练集的时候所用的方法，可能代码的思想不一样，但是思路应该差不多。
对比两种方法，
