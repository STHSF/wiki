---
title: "random forest"
layout: page
date: 2018-08-05 00:00
---
[TOC]

# 写在前面
随机森林是一种有监督学习算法，是以决策树为基学习器的集成学习算法。随机森林非常简单，易于实现，计算开销也很小，但是它在分类和回归上表现出非常惊人的性能，因此，随机森林被誉为“代表集成学习技术水平的方法”。

# 随机森林的构建过程
1，从原始训练集中使用Bootstraping方法随机有放回采样取出m个样本，共进行n_tree次采样。生成n_tree个训练集

2，对n_tree个训练集，我们分别训练n_tree个决策树模型

3，对于单个决策树模型，假设训练样本特征的个数为n，那么每次分裂时根据信息增益/信息增益比/基尼指数 选择最好的特征进行分裂

4，每棵树都已知这样分裂下去，知道该节点的所有训练样例都属于同一类。在决策树的分裂过程中不需要剪枝

5，将生成的多颗决策树组成随机森林。对于分类问题，按照多棵树分类器投票决定最终分类结果；对于回归问题，由多颗树预测值的均值决定最终预测结果

注意：OOB（out-of-bag ）：每棵决策树的生成都需要自助采样，这时就有1/3的数据未被选中，这部分数据就称为袋外数据。

# 随机森林的随机性

- 1，数据集的随机选取

从原始的数据集中采取有放回的抽样（bagging），构造子数据集，子数据集的数据量是和原始数据集相同的。不同子数据集的元素可以重复，同一个子数据集中的元素也可以重复。

- 2，待选特征的随机选取

与数据集的随机选取类似，随机森林中的子树的每一个分裂过程并未用到所有的待选特征，而是从所有的待选特征中随机选取一定的特征，之后再在随机选取的特征中选取最优的特征

# 随机森林的特性
1，随机森林既可以用于分类问题，也可以用于回归问题

2，过拟合是个关键的问题，可能会让模型的结果变得糟糕，但是对于随机森林来说，如果随机森林的树足够多，那么分类器就不会过拟合模型

3，随机森林分类器可以处理缺失值

4，随机森林分类器可以用分类值建模

# 随机森林的优缺点
优点
- 由于采用了集成算法，本身精度比大多数单个算法要好，所以准确性高
- 在测试集上表现良好，由于两个随机性的引入，使得随机森林不容易陷入过拟合（样本随机，特征随机）
- 在工业上，由于两个随机性的引入，使得随机森林具有一定的抗噪声能力，对比其他算法具有一定优势
- 由于树的组合，使得随机森林可以处理非线性数据，本身属于非线性分类（拟合）模型
- 它能够处理很高维度（feature很多）的数据，并且不用做特征选择，对数据集的适应能力强：既能处理离散型数据，也能处理连续型数据，数据集无需规范化
- 训练速度快，可以运用在大规模数据集上
- 可以处理缺省值（单独作为一类），不用额外处理
- 由于有袋外数据（OOB），可以在模型生成过程中取得真实误差的无偏估计，且不损失训练数据量
- 在训练过程中，能够检测到feature间的互相影响，且可以得出feature的重要性，具有一定参考意义
- 由于每棵树可以独立、同时生成，容易做成并行化方法
- 由于实现简单、精度高、抗过拟合能力强，当面对非线性数据时，适于作为基准模型

缺点
- 当随机森林中的决策树个数很多时，训练时需要的空间和时间会比较大
- 随机森林中还有许多不好解释的地方，有点算是黑盒模型
- 在某些噪音比较大的样本集上，RF的模型容易陷入过拟合


# 参考文献
[随机森林算法](https://baijiahao.baidu.com/s?id=1612329431904493042&wfr=spider&for=pc)