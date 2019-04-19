---
title: "python基础知识--pandas panel使用技巧.md"
layout: page
date: 2099-06-02 00:00
---


# 写在前面
我们可以将panel理解成是多个DataFrame的层叠,每个DataFrame的名称对应为Panel的Minor_axis, 对于每一层的DataFrame而言, DataFrame的index为pandel的Major_aixs, DataFram的keys为panel的Items

# 使用技巧
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

# 参考文献
[pandas apply 函数 实现多进程的示例讲解](https://www.jb51.net/article/138584.htm)

[Parallelize apply after pandas groupby](https://stackoverflow.com/questions/26187759/parallelize-apply-after-pandas-groupby)

[pandas apply 函数 多进程实现](https://blog.csdn.net/Jerr__y/article/details/71425298?utm_source=blogxgwz1#commentBox)

[pandas apply应用并行进程，多核加快运行速度](https://blog.csdn.net/sinat_30353259/article/details/83818646)