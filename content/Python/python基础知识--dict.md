---
title: "python基础知识--合并两个有相同key的字典"
layout: page
date: 2099-06-02 00:00
---


# 
现有list：

list1 = [{a: 123}, {a: 456},{b: 789}]

合并成：

list2 = [{a: [123,456]},{b: [789]}]
# 使用方法

```python
lst = [{'a': 123}, {'a': 456},{'b': 789}]

dic ={}

for _ in lst:
    for k, v in _.items():
        dic.setdefault(k, []).append(v)

print dic
>>> {'a': [123, 456], 'b': [789]}
```
