---
title: "Mathine Learning Tricks - 特征工程之归一化方法(Normalization Method)"
layout: page
date: 2017-07-18 14:00
---

# 特征工程
数据预处理在众多深度学习算法中都起着重要作用，实际情况中，将数据做归一化和白化处理后，很多算法能够发挥最佳效果。然而除非对这些算法有丰富的使用经验，否则预处理的精确参数并非显而易见。



## 1、Feature Scaling（normalization）
让不同的输入特征数据具有相同的分布，即使数据集中的所有特征都具有零均值和单位方差，这样在梯度下降中更新参数时效率更高。
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

一般做机器学习应用的时候大部分时间是花费在特征处理上，其中很关键的一步就是对特征数据进行归一化，为什么要归一化呢？很多同学并未搞清楚，维基百科给出的解释：
- 归一化后加快了梯度下降求最优解的速度;如果机器学习模型使用梯度下降法求最优解时，归一化往往非常有必要，否则很难收敛甚至不能收敛。

- 归一化有可能提高精度;
一些分类器需要计算样本之间的距离（如欧氏距离），例如KNN。如果一个特征值域范围非常大，那么距离计算就主要取决于这个特征，从而与实际情况相悖（比如这时实际情况是值域范围小的特征更重要）。

# K-folds交叉验证
交叉验证的基本思想是把在某种意义下将原始数据进行分组, 一部分作为训练集, 另一部分作为验证集.

K折交叉验证, 就是把原始数据(初始采样)分割成K个子集, 将其中一个子集作为验证集, 其余K-1个子集作为训练集. 交叉验证重复K次, 每个子集验证一次, 将K次结果通平均或者其他的某种方式最终得到一个单一的估测, 以此来作为评价分类器的性能指标.

交叉验证的好处是防止过拟合,挑选最合适的模型.

### StratifiedKFold实例
简要介绍sklern中的StratifiedKFold用法
#### StratifiedKFold参数说明
- n_splits:折叠次数，默认为3，至少为2。
- shuffle:是否在每次分割之前打乱顺序。
- random_state:随机种子，在shuffle==True时使用，默认使用np.random。


#### sklearn 
```python
import pandas as pd
import numpy as np
from sklearn.model_selection import StratifiedKFold
import warnings
import lightgbm as lgb
from sklearn.metrics import roc_auc_score
warnings.filterwarnings('ignore')

def get_data():
    train=pd.read_csv('/home/kesci/input/round11379/train_round_1.csv')
    test=pd.read_csv('/home/kesci/input/round11379/test_round_1.csv')
    data = pd.concat([train, test], axis=0, ignore_index=True)
    data = data.fillna(-1)
    return data

def split_train_test(data):
    train_data = data[data['purchase'] != -1]
    test_data = data[data['purchase'] == -1]

    submit = test_data[['user_id','Product_id']].copy()
    train_data = train_data.drop(['user_id','Product_id','seller'], axis=1)
    test_data = test_data.drop(['user_id','Product_id','seller'], axis=1)
    test_data = test_data.drop(['purchase','favorite'], axis=1)
    return train_data,test_data,submit


def train_lgb(train_x, train_y, test_x,test_y,res,col):
    kfold = StratifiedKFold(n_splits=5, shuffle=True, random_state=2019) #shuffle:是否在每次分割之前打乱顺序
    lgb_paras ={
        'learning_rate': 0.1,
        'boosting_type': 'gbdt',
        'objective': 'binary',
        'metric': 'auc',
        'num_leaves': 63,
        'feature_fraction': 0.8,
        'bagging_fraction': 0.8,
        'bagging_freq': 5,
        'seed': 1,
        'bagging_seed': 1,
        'feature_fraction_seed': 7,
        'min_data_in_leaf': 20,
        'nthread': -1,
        'verbose': -1
    }
    scores=[]
    test_pred =  np.zeros(len(test_x))
    for n_fold,(tr_idx, val_idx) in enumerate(kfold.split(train_x, train_y)):
        print(f'the {n_fold} training start ...')
        tr_x, tr_y, val_x, val_y = train_x.iloc[tr_idx], train_y[tr_idx], train_x.iloc[val_idx], train_y[val_idx]
        train_set = lgb.Dataset(tr_x, tr_y)
        val_set = lgb.Dataset(val_x, val_y)
        lgb_model = lgb.train(lgb_paras, train_set,
                              valid_sets=[val_set], early_stopping_rounds=50, num_boost_round=40000, verbose_eval=50)
        val_pred = lgb_model.predict(
            val_x, num_iteration=lgb_model.best_iteration)
        test_pred+=lgb_model.predict(
            test_x, num_iteration=lgb_model.best_iteration)/ kfold.n_splits
        val_score = roc_auc_score(val_y, val_pred)
        scores.append(val_score)
    print('cv: ', scores)
    print('cv : ', np.mean(scores))
    res[col]=test_pred
    return res


if __name__ == "__main__":
    for fea in ['purchase', 'favorite']:
        if fea == 'purchase':
            data = get_data()
            train, test_x, submit_purchase = split_train_test(data)
            train_x = train.drop(['purchase', 'favorite'], axis=1)
            train_y = train['purchase']
            submit_purchase = train_lgb(train_x, train_y, test_x, submit_purchase, 'purchase', 10)
            del data, train, test_x, train_x, train_y
            submit_purchase.columns = ['user_id', 'product_id', 'pred_purchase']
        else:
            data = get_data()
            train, test_x, submit_favorite = split_train_test(data)
            train_x = train.drop(['purchase', 'favorite'], axis=1)
            train_y = train['favorite']
            submit_favorite = train_lgb(train_x, train_y, test_x, submit_favorite, 'favorite', 5)
            del data, train, test_x, train_x, train_y
            submit_favorite.columns = ['user_id', 'product_id', 'pred_favorite']

```

### TimeSeriesSplit实例
对于时间序列的数据类型, 这种数据具有高度的自相关性, 前后相邻时段的数据关联程度非常高. 使用简单随机抽样的方式对时间序列数据采样容易破坏其时段的连续性, 同时,也有可能引入未来数据.

#### sklearn

```python
from sklearn.model_selection import TimeSeriesSplit
import numpy as np

X = np.random.randint(1,10,20)

kf = TimeSeriesSplit(n_splits=4)

for train,test in kf.split(X):
    print(train,'\n',test)
```

[Sklearn-CrossValidation交叉验证](https://blog.csdn.net/cherdw/article/details/54986863)

[交叉验证及其用于参数选择、模型选择、特征选择的例子](https://blog.csdn.net/jasonding1354/article/details/50562513)

[tensorflow数据归一化，z-score,min-max几种方法](http://www.mtcnn.com/?p=517)

[k折交叉验证sklearn中的StratifiedKFold](https://blog.csdn.net/weixin_44110891/article/details/95240937)

[Cross-validation: evaluating estimator performance](https://scikit-learn.org/stable/modules/cross_validation.html#cross-validation)

# 特征选择
特征选择防止模型过拟合降低模型的泛化误差, 可以减少硬件资源的损耗, 降低模型的开发成本, 减少训练时间.

### 过拟合
如果一个模型在训练集上的表现明显高于测试集上, 则说明模型可能过拟合了.

过拟合是指模型的参数对于对于训练数据的特定观测值拟合的非常接近, 而训练数据的分布与真实数据的分布并不一致, 所以模型具有较高的方差.

产生过拟合的原因是对于训练集上的模型过于复杂.

降低模型过拟合的方法
- 准备更多的训练数据
- 引入正则化惩罚项
- 降低模型的复杂度, 选择一个模型参数相对较少的模型
- 降低数据的维度

# 参考文献
https://www.cnblogs.com/sddai/p/6250094.html

[异常检测论文大列表：方法、应用、综述](http://www.zhuanzhi.ai/document/a63d9faf42e18c06b5e8d4c9e3735840)

