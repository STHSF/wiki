---
title: "Mathine Learning Tricks - 特征工程"
layout: page
date: 2017-07-18 14:00
---
# 特征工程
## 1、Feature Scaling（normalization）
让不同的输入特征数据具有相同的分布，这样在梯度下降中更新参数时效率更高。
### 方法
scaling的方法很多种，其中之一就是求特征向量每个维度的均值和方差。
假设对于样本数据集$(X=[X^1, X^2, X^3, ....,X^r])$, 其中$(X^r=[x_1^r, x_2^r, x_3^r, ..., x_i^r])$
分别求每一个维度$(i)$的均值和方差。
- mean: $(m_i)$
- standard deviation: $(\sigma_i)$
则，每个特征元素可重新表示为：
$$
x_i^r=\frac{x_i^r-m_i}{\sigma_i}
$$
修改后是的每个维度数据的均值为0，方差为1。

##
最小冗余最大关联特征选择

将所有的想法整合起来就能得出我们的算法，即 mRMR 特征选择。算法背后的考虑是，同时最小化特征的冗余并最大化特征的关联。因此，我们需要计算冗余和关联的方程：

冗余:

$$
Relevance = \frac{ \sum_{i=1}^{n}c_ix_i}{\sum_{i=1}^nx_i}
$$

关联:

$$
Redundancy = \frac{\sum_{i,j=1}^na_{ij}x_ix_j}{(\sum_{i=1}^nx_i)^2}
$$

让我们用虚构的数据写一个快速脚本来实现 mRMR：

```python
from scipy.optimize import minimize
import numpy as np

matrix = np.array([
    [0,1,2,1,2],
    [0,1,3,2,3],
    [5,2,3,3,5],
    [10,3,3,4,12],
    [20,5,2,5,15],
    [25,8,4,6,20],
    [23,7,2,7,18],
    [20,6,4,8,16],
    [8,4,2,9,12],
    [2,1,3,10,8],
    [0,1,2,11,4],
    [0,1,2,12,3]

])

corrcoef = np.corrcoef(np.transpose(matrix))
relevancy = np.transpose(corrcoef)[0][1:]

# set initial to all dimensions on
x0 = [1,1,1,1]

# minimize the redundancy minus relevancy
fun = lambda x: sum([corrcoef[i+1, j+1] * x[i] * x[j] for i in range(len(x)) for j in range(len(x))]) / (sum(x) ** 2) - (sum(relevancy * x) / sum(x))

res = minimize(fun, x0, bounds=((0,1), (0,1), (0,1), (0,1)))

print(res.x)

```


