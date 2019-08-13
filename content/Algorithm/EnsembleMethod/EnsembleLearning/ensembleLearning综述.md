---
title: "EnsembleLearning综述"
layout: page
date: 2018-08-14 10:00
---

# 写在前面
[常用的集成学习方法](http://blog.51cto.com/yixianwei/2116117)
[从Boosting到Stacking，概览集成学习的方法与性能](https://www.sohu.com/a/167812554_465975)
[集成学习（Ensemble Learning）](https://blog.csdn.net/qq_32690999/article/details/78759463)
[CatBoost、LightGBM、XGBoost，这些算法你都了解吗？](https://blog.csdn.net/LrS62520kV/article/details/79620615)
[DC-hi_guides](https://github.com/yongyehuang/DC-hi_guides)
# GBDT
GBDT(Gradient Boosting Decision Tree)是boosting系列算法中的一个代表算法，它是一种迭代的决策树算法，由多棵决策树组成，所有树的结论累加起来作为最终答案
### GBDT思想
我们利用平方误差来表示损失函数，其中每一棵回归树学习的是之前所有树的结论和残差，拟合得到一个当前的残差回归树。其中残差=真实值-预测值，提升树即是整个迭代过程生成的回归树的累加。
### 负梯度拟合
在GBDT迭代过程中，假设我们前一轮迭代得到的强学习器是f_{t-1}(x)，损失函数是 L(y,f_{t-1}(x))，我们本轮迭代的目标是找到一个回归树模型的弱学习器h_t(x)，让本轮的损失 L(y,f_{t}(x))= L(y,f_{t-1}(x)+h_t(x))最小。也就是说，本轮迭代找到的决策树，要让样本的损失函数尽量变得更小。
### GBDT分类算法
GBDT分类算法在思想上和回归算法没有区别，但是由于样本输出不是连续的值，而是离散的类别，导致我们无法直接从输出类别去拟合类别输出的误差。为解决此问题，我们尝试用类似于逻辑回归的对数似然损失函数的方法，也就是说我们用的是类别的预测概率值和真实概率值来拟合损失函数。对于对数似然损失函数，我们有二元分类和多元分类的区别。

### RF与GBDT之间的区别与联系
相同点：
- 都是由多棵树组成；
- 最终的结果都由多棵树共同决定；
不同点：
- 组成随机森林的树可以分类树也可以是回归树，而GBDT只由回归树组成；
- 组成随机森林的树可以并行生成（Bagging）；GBDT 只能串行生成（Boosting）；这两种模型都用到了Bootstrap的思想；
- 随机森林的结果是多数表决表决的，而GBDT则是多棵树加权累加之和；
- 随机森林对异常值不敏感，而GBDT对异常值比较敏感；随机森林
- 是减少模型的方差，而GBDT是减少模型的偏差；
- 随机森林不需要进行特征归一化。而GBDT则需要进行特征归一化；
- 随机森林对训练集一视同仁权值一样，GBDT是基于权值的弱分类器的集成 ；
### 优缺点
优点
- 可以灵活处理各种类型的数据，包括连续值和离散值。
- 使用了一些健壮的损失函数，对异常值的鲁棒性非常强。比如 Huber损失函数和Quantile损失函数。
- 充分考虑的每个分类器的权重。
缺点
- 由于弱学习器之间存在依赖关系，难以并行训练数据。不过可以通过自采样的SGBT来达到部分并行。

# XGboost

# CatBoost
[原CatBoost参数解释和实战](https://blog.csdn.net/linxid/article/details/80723811)
[CatBoost参数解释](https://blog.csdn.net/AiirrrrYee/article/details/78224232?locationNum=3&fps=1)
[Parameter tuning](https://tech.yandex.com/catboost/doc/dg/concepts/parameter-tuning-docpage/)
[catboost_python_tutorial.ipynb](https://github.com/catboost/catboost/blob/master/catboost/tutorials/catboost_python_tutorial.ipynb)

# lightGBM
[机器不学习:一问看懂机器学习时代神器-LightGBM](http://www.360doc.com/content/17/1231/23/40769523_718019029.shtml)

# 参考文献