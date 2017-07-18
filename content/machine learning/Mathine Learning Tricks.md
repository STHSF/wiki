---
title: "Mathine Learning Tricks"
layout: page
date: 2099-06-02 00:00
---

# Feature Scaling
让不同的输入特征数据具有相同的分布，这样在梯度下降中更新参数时效率更高。
### 方法
方法很多种，其中之一就是求特征向量每个维度的均值和方差。
假设对于样本数据集$(X=[X^1, X^2, X^3, ....,X^r])$, 其中$X^r=[x_1^r, x_2^r, x_3^r, ..., x_i^r]$
分别求每一个维度$(i)$的均值和方差。
mean: $(m_i)$
standard deviation: $(\sigma_i)$
则，每个特征元素可重新表示为：
$$
x_i^r=\frac{x_i^r-m_i}{\sigma_i}
$$
修改后是的每个维度数据的均值为0，方差为1。



