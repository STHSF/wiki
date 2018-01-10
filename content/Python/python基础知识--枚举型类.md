---
title: "python基础知识--枚举型类的用法"
layout: page
date: 2018-01-09 00:00
---

# python 中的枚举
python中定义枚举是使用类的方式来定义的，需要继承enum类模块。

```python
from enum import Enum, unique
@unique
class Color(Enum):
    red = 1
    bollo = 2
    yellow = 3

reds = Color.red
print reds
```