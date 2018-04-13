---
title: "pandas DataFrame的创建和基本操作"
layout: page
date: 2018-03-02 00:00
---
[TOC]

# 写在前面
DataFrame是Pandas中的一个表结构的数据结构，包括三部分信息，表头（列的名称），表的内容（二维矩阵），索引（每行一个唯一的标记）。

## 一、DataFrame的创建

有多种方式可以创建DataFrame，下面举例介绍。

### 例1: 通过list创建
```
>>> import pandas as pd
>>> df = pd.DataFrame([[1,2,3],[4,5,6]])
>>> df
   0  1  2
0  1  2  3
1  4  5  6

[2 rows x 3 columns]
```
上面代表，创建了一个2行3列的表格，创建时只指定了表格的内容（通过一个嵌套的list），没有指定列名和索引。这时列名就自动为 0,1,2 ；索引自动为数值0,1.

我们可以指定列表和索引，如：

```
>>> df = pd.DataFrame([[1,2,3], [4,5,6]], index=['r1', 'r2'], columns=['c1', 'c2', 'c3'])

      c1  c2  c3
r1   1   2   3
r2   4   5   6

[2 rows x 3 columns]

```
可以看出，上面的代码通过index和columns参数指定了索引和列名。

### 例2: 创建例子

```
>>> import numpy as np
>>> dates = pd.date_range('20121001', periods=6)
>>> df = pd.DataFrame(np.random.randn(6, 4), index=dates, columns=list('abcd'))
>>> df

                   a         b         c         d
2012-10-01 -0.236220  0.586985  0.784953 -0.507129
2012-10-02 -1.020807 -1.316997 -0.747997  1.909333
2012-10-03  0.085208 -0.281736  1.112287  1.572577
2012-10-04  0.008708 -0.925711 -0.615752 -1.183397
2012-10-05  1.158198 -1.393678  0.586624  0.202499
2012-10-06  1.149878 -2.383863  1.646403  1.647935

[6 rows x 4 columns]
```
上面代码创建的dates是个时间索引，np.random.randn方法创建一个6行4列的随机数矩阵。

最后的df使用dates作为索引，使用np.random.randn方法创建的矩阵作为内容，使用list('abcd')作为列名。

## 二、DataFrame的一些基本操作

### 1、获取数据行数
```
len(df) or len(df.index)
```
### 2、显示索引、列和底层的numpy数据

```
>>> df.index
<class 'pandas.tseries.index.DatetimeIndex'>
[2012-10-01, ..., 2012-10-06]
Length: 6, Freq: D, Timezone: None
>>> df.columns
Index([u'a', u'b', u'c', u'd'], dtype='object')
>>> df.values
array([[-0.2362202 ,  0.58698529,  0.78495289, -0.50712897],
       [-1.02080723, -1.31699704, -0.74799734,  1.90933343],
       [ 0.08520807, -0.28173589,  1.11228743,  1.57257716],
       [ 0.00870768, -0.92571109, -0.6157519 , -1.18339719],
       [ 1.15819829, -1.39367835,  0.586624  ,  0.20249899],
       [ 1.14987847, -2.38386297,  1.64640287,  1.64793523]])
```
说明，这个例子中的df使用的是上面创建的 DataFrame对象

### 3、显示数据

```
df.head([n])  # 获取df中的前n行数据。n不指定默认为5
df.tail([n])  # 获取df中的后n行数据，n不指定默认为5
```

```
>>> dates = pd.date_range('20121001',periods=100)
>>>df = pd.DataFrame(np.random.randn(100,4) , index = dates,columns=list('abcd' ))  
>>> df.head()
                   a         b         c         d
2012-10-01 -1.010746  0.176277 -0.838870  0.742626
2012-10-02  0.111174  0.182840  0.193215  1.517350
2012-10-03 -0.757385  1.137521 -0.247181  0.659187
2012-10-04 -1.157838  1.464957 -2.106226  1.160796
2012-10-05  0.141747  0.032917  0.647210 -0.861413

[5 rows x 4 columns]
>>> df.tail()
                   a         b         c         d
2013-01-04 -0.225416 -1.436526 -0.349813 -0.130948
2013-01-05 -1.544653 -0.214760  1.455662  0.050591
2013-01-06  0.582737 -0.646163 -1.763772 -1.463706
2013-01-07 -0.694467  0.710954 -2.227337 -0.257376
2013-01-08  0.282839 -1.100346  1.526374  1.658781
```
主意，head和tail返回的是一个新的dattaframe，与原来的无关

### 4、按照索引排序

```
newdf = df.sort_index(asccending=False, inpalce=True)
ascending=False 参数指定按照索引值以降序方式排序，默认的是以升序排序。
inplace=True 指定为True时，表示会直接对df中的数据进行排序，函数返回的值为None，newdf的指为None；
如果不设置为True，默认为false，则不会对df中的数据直接进行修改，会返回一个新的df，这时，newdf就有内容，是一个新的排序后的df。
````
### 5、添加数据（append方法）
append方法可以添加数据到一个DataFrame中，主意append方法不会影响原来的DataFrame，会自动返回一个新的DataFrame。

语法：
```python
DataFrame.append(otherData, ignore_index=False, verify_integrity=False)
```
其中otherData参数是要添加的新数据，支持多种格式。

ignore_index参数默认值为False，如果为True，会对新生成的DataFrame使用新的索引（自动产生），忽略原来的数据索引。

verify——integrity参数默认为False，如果为True，当ignore_index为False时，会检查添加的数据索引是否冲突，如果冲突，则会添加失败。
#### 举例说明1：
```
dates = pd.date_range('20121001',periods=10)
df = pd.DataFrame(np.random.randn(10,4) , index = dates,columns=list('abcd')) 

dates1 = pd.date_range('20121001',periods=2)
df1 = pd.DataFrame(np.random.randn(2,4) , index = dates1,columns=list('abcd')) 

df.append(df1) # df1中的2行数据会加到df中，且新产生的df的各行的索引就是原来数据的索引
df.append(df1,ignore_index=True) # df1中的2行数据会加到df中，且新产生的df的索引会重新自动建立
df.append(df1,verify_integrity=True) #会报错，因为df1的索引和df2的索引冲突了
```
说明，df1的列名必须和df一致，否则不是简单的添加行。而是会添加列，再添加行。

#### 举例2:

```python
>>> df.append({'a':10,'b':11,'c':12,'d':13},ignore_index=True)

            a          b          c          d
  -0.471061  -0.937725  -1.444073   0.640439
  -0.732039  -1.617755   0.281875   1.179076
   1.115559   0.136407  -2.225551   0.119433
   0.695137   0.380088  -0.318689  -0.048248
   1.483151  -0.124202  -0.722126   0.035601
   0.326048  -0.139576  -0.172726   0.931670
   0.858305   0.857661  -0.279078   0.583740
  -0.041902   0.408085  -1.019313   0.005968
   0.626730   0.143332  -0.404894   0.377950
  -1.850168   0.430794  -0.534981  -0.738701
 10.000000  11.000000  12.000000  13.000000
```
上面代码是新产生的df会添加一行。这种操作，ignore_index参数值必须设置为True，否则会报错。

举例3
```python
>>> df.append({'e':10},ignore_index=True)

           a         b         c       d   e
 -0.471061 -0.937725 -1.444073  0.640439 NaN
 -0.732039 -1.617755  0.281875  1.179076 NaN
  1.115559  0.136407 -2.225551  0.119433 NaN
  0.695137  0.380088 -0.318689 -0.048248 NaN
  1.483151 -0.124202 -0.722126  0.035601 NaN
  0.326048 -0.139576 -0.172726  0.931670 NaN
  0.858305  0.857661 -0.279078  0.583740 NaN
 -0.041902  0.408085 -1.019313  0.005968 NaN
  0.626730  0.143332 -0.404894  0.377950 NaN
 -1.850168  0.430794 -0.534981 -0.738701 NaN
      NaN       NaN       NaN       NaN  10

```
可以看出，如果插入的数据，指定的列名不存在，新产生的df不仅会增加行，还会增加列。

### 6、遍历数据
示例代码：
```
for index,row in df.iterrows():
    print index #获取行的索引
    print row.a #根据列名获取字段
    print row[0]#根据列的序号（从0开始）获取字段
```
### 7、查找数据

创建如下的dataframe
```
dates = pd.date_range('20121001',periods=10)
df = pd.DataFrame(np.random.randn(10,4) , index = dates,columns=list('abcd'))
```
可以有各种方式获取df中的全部或部分数据

df['a']  #按照列名获取指定的列，返回的是一个Series，其中key是索引，value是该列对应的字段值

df[:2] #获取前2行数据，效果等同 df[0:2]，返回的是一个新的dataframe

df[2:5] #获取第3行~5行 这3条记录，返回的是一个新的dataframe

df.loc['20121009'] #获取指定索引的行，等同于  df.loc['2012-10-09']，返回的是一个Series，其中key是列名，value是该列对应的字段值

df.iloc[3]  #获取指定序号的行，这里是第4行


### 8、删除数据

```
del df['a']  #删除dataframe中指定的列，这个是直接影响当前的dataframe，注意 del不是函数，是python中的内置语句，没有返回值

df.drop(['a'],axis=1)  #删除指定的列，与上面的区别是不会影响原来的dataframe，dop方法会返回一个删除了指定列的新的dataframe
```
说明，dop方法既可以删除列，也可以删除行，但上面创建的df无法被删除行（?），下面这个例子可以删除行
```
data = pd.DataFrame(np.arange(16).reshape((4, 4)),index=['Ohio', 'Colorado', 'Utah', 'New York'],columns=['one', 'two', 'three', 'four'])

data.drop(['Colorado', 'Ohio'])
```
上面代码中的dop方法删除了指定索引的两行，注意同删除列一样，drop方法不会影响原来的dataframe，会返回一个删除后的新的dataframe

 

### 9、增加列

例子代码如下
```
dates = pd.date_range('20121001',periods=10)
df = pd.DataFrame(np.random.randn(10,3) , index = dates,columns=list('abc')) 

df['d'] = pd.Series(np.random.randn(10),index=df.index)
上面代码先是创建了一个dataframe，然后通过df['d'] 插入了一个新的列。如果指定的列名存在，会修改列的内容。
```
 

### 10、修改指定行或单元格数据

df.values[i][j]= xxx  #其中i是行号，j是列号，都是从0开始

df.values[1]=12  # 会把一行中的所有列中的数据设置为同一个值，这里的参数1是序号，这里为第2行数据

df['a'] = 12  #这样会把指定列的所有数据都设置为同一个值，如这里的12。注意，如果指定的列名不存在，会新增列

 

### 11、插入行

前面介绍的append方法是产生一个新的 dataframe，不会改变原来的dataframe。

那有没有办法直接在当前的frame中插入一行数据呢？  上面介绍的 df[列名] = xxx 是用来插入或修改列的信息。

### 12、去重函数
如果我们想要对DataFrame中的行进行去重操作，比如说按照某一个columns进行去重，pandas有两个函数：

```
DataFrame.duplicated()  # 返回的是一个布尔型的Series，表示各行是否是重复行。

DataFrame.drop_duplicates() # 返回一个移除重复行的DataFrame，如果要对某一列进行去重，只需在参数重添加列名即可，如DataFrame.drop_duplicates(['columns_name'])
```


### 13、数据筛选
可以对某一列进行特定的筛选：
```
DataFrame[DataFrame["columns"]>100] # 筛选出columns列大于100的行
```
可以使用&(并) 与 |(或)实现多条件筛选
```
DataFrame[(DataFrame["columns1"]>100) &(DataFrame["columns2"]>=1000)] # 筛选出columns1列大于100且columns2列小于1000的行

DataFrame[(DataFrame.columns1>100) | (DataFrame.columns1 < 10)]  # 筛选出columns1列大于100或者columns1列小于10的行
```
也可以挑选出DataFrame中的某几列。

```
DataFrame[["columns3", "columns4"]][(DataFrame["columns1"]>100) &(DataFrame["columns2"]>=1000)] # 筛选出columns1列大于100的行且columns2列小于1000的行,但只挑选columns3和columns4两列。
```
也可以使用isin方法筛选一些特定值：

```
testlist = []
DataFrame["columns1"].isin(testlist) # 返回的是一个True/False的Series
```

# 参考文献

[1](http://www.cnblogs.com/51kata/p/5406355.html)

[Pandas 数据框增、删、改、查、去重、抽样基本操作](https://blog.csdn.net/claroja/article/details/65661826)

[十分钟搞定pandas](https://www.cnblogs.com/chaosimple/p/4153083.html)