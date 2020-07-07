---
title: "pandas基础知识--数据筛选"
layout: page
date: 2018-01-30 13:00
---

# enumerate
- enumerate()是python的内置函数
- enumerate在字典上是枚举、列举的意思
- 对于一个可迭代的（iterable）/可遍历的对象（如列表、字符串），enumerate将其组成一个索引序列，利用它可以同时获得索引和值
- enumerate多用于在for循环中得到计数

# 使用方法

```
list1 = ["这", "是", "一个", "测试"]
for index, item in enumerate(list1, 1):
    print index, item
>>>
1 这
2 是
3 一个
4 测试
```

# 当用行号索引的时候, 尽量用 iloc 来进行索引; 而用标签索引的时候用 loc ,  ix 尽量别用。