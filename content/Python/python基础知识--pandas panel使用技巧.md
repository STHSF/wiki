---
title: "python基础知识--pandas panel和multiindex使用技巧.md"
layout: page
date: 2099-06-02 00:00
---


# 写在前面
我们可以将panel理解成是多个DataFrame的层叠,每个DataFrame的名称对应为Panel的Minor_axis, 对于每一层的DataFrame而言, DataFrame的index为pandel的Major_aixs, DataFram的keys为panel的Items, 聚宽上读取的股票行情数据就是Panel格式的.

# Panle使用技巧
## 从Minor_axis轴比较数据
例如:
```
p1 = pd.DataFrame({'stock1':[1,2,3,4], 'stock2':[2,3,4,5]}, index=['2010','2011','2012','2013'])
p2 = pd.DataFrame({'stock1':[2,3,4,5], 'stock2':[3,4,5,6]}, index=['2010','2011','2012','2013'])

>>>
<class 'pandas.core.panel.Panel'>
Dimensions: 2 (items) x 4 (major_axis) x 2 (minor_axis)
Items axis: item1 to item2
Major_axis axis: 2010 to 2013
Minor_axis axis: stock1 to stock2
```
我们想要得到两个dataframe的最大值,类似下面的结果, 其中每个值取的是最大值
```
      stock1  stock2
2010       2       3
2011       3       4
2012       4       5
2013       5       6
```

实现方法
```
func = lambda x: x[0] if x[0] >= x[1] else x[1]
re_df = pd.DataFrame()
# 提取minor_axis维数据, 比较完成之后重新构建一个dataframe
for i in pn.minor_axis:
    re_df[i] = pn.minor_xs(i).apply(func, axis=1)
```
输出结果
```
      stock1  stock2
2010       2       3
2011       3       4
2012       4       5
2013       5       6
```
# multiindex
但是最近在使用pannel的时候,系统提示Panel结构在未来会被弃用, 建议使用DataFrame的MultiIndex代替,详细warning如下:
```
/opt/conda/lib/python3.6/site-packages/jqresearch/api.py:87: FutureWarning: 
Panel is deprecated and will be removed in a future version.
The recommended way to represent these types of 3-dimensional data are with a MultiIndex on a DataFrame, via the Panel.to_frame() method
Alternatively, you can use the xarray package http://xarray.pydata.org/en/stable/.
Pandas provides a `.to_xarray()` method to help automate this conversion.
```

pandasde multiindex比Panel更加直观, 易于展示.

multiindex创建比较简单, 只要将DataFrame中的某两列指定为index即可.
```
df1 = pd.DataFrame({'课程':['语文','语文','数学','数学'],'得分':['最高','最低','最高','最低'],'分值':[90,50,100,60]})
df2 = df1.set_index(['课程','得分'])

>>> df1

课程	得分	分值
0	语文	最高	90
1	语文	最低	50
2	数学	最高	100
3	数学	最低	60

>>> df2
            分值
课程  得分	
语文  最高	 90
     最低	50
数学  最高	 100
     最低	60
```

同样还可以使用DataFrame.stack和unstack来操作mutiindex

DataFrame.reset_index(), 可以将multimindex转换成单个dataframe

两个index互换可以通过DataFrame.swaplevel

索引内部排序, DataFrame.sortlevel

# 参考文献
[Pandas-4. Panel](https://www.jianshu.com/p/0865813c590e)

[用一个月整理的Pandas的教程！最全面的教程没有之一！先收藏吧！](https://www.jianshu.com/p/5aa6579f70b1)

[Pandas面板（Panel）](https://www.yiibai.com/pandas/python_pandas_panel.html)

[在pandas多重索引multiIndex中选定指定索引的行](https://blog.csdn.net/PIPIXIU/article/details/80232805)

[Pandas reshape相关函数介绍（pivot，pivot_table，stack，unstack，melt）](https://blog.csdn.net/wj1066/article/details/82261458)

[数分笔记整理15 - 数据处理综合运用 - 多层次索引MultiIndex](https://blog.csdn.net/qq_42442369/article/details/86662641)

[在MultiIndex中为缺少的日期插入0值](https://codeday.me/bug/20190401/860405.html)

[在Pandas MultiIndex中查找NaN值](https://codeday.me/bug/20190607/1193787.html)

