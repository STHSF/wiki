---
title: "python基础知识--修饰函数(wraps)"
layout: page
date: 2019-04-10 00:00
---
[TOC]

# 写在前面
修饰函数在某种程度上可以帮助程序员方便的代码复用等技巧, 灵活使用修饰函数可以起到事半功倍的效果.

Python 装饰器中的@wraps的作用：
- 装饰器的作用:    在不改变原有功能代码的基础上,添加额外的功能,如统计时间, 打log等
- @wraps(view_func)的作用:     不改变使用装饰器原有函数的结构(如__name__, __doc__)
- 不使用wraps可能出现的ERROR:   view_func...endpoint...map...

# 使用技巧
## 技巧一, 统计函数的运行时间
示例:

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
import functools
import time


def wrap_timer(func):
    @functools.wraps(func)
    def timer(*args, **kwargs):
        t_begin = time.time()
        result = func(*args, **kwargs)
        t_end = time.time()
        print(("%s(%s, %s)" % (func, args, kwargs)))
        print("Time: %f " % (t_end - t_begin))
        return result

    return timer

# 类中使用
class ClassTest:
    def __init__(self):
        pass

    @wrap_timer
    def test(self):
        time.sleep(10)

# 单个函数使用
@wrap_timer
def test_func(num):
    for i in range(num):
        time.sleep(1)

```
运行输出:
```
# 类测试
test_mode = ClassTest()
test_mode.test()
# 单函数测试
test_func(5)

<function ClassTest.test at 0x7f14400bb510>((<__main__.ClassTest object at 0x7f144010d278>,), {})
Time: 10.010076 
<function test_func at 0x7f144011c6a8>((5,), {})
Time: 5.005338
```
## 技巧二, 函数运行前后的log输出
示例:

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

def wrap_logger(func):
    @functools.wraps(func)
    def logger(*args, **kwargs):
        print(("%s(%s, %s)" % (func, args, kwargs)))
        print("before execute")
        result = func(*args, **kwargs)
        print("after execute")
        return result

    return logger

# 类测试
class TestClass:
    def __init__(self):
        pass

    @wrap_logger
    def test(self, a, b, c):
        print(a, b, c)

# 单函数测试
@wrap_logger
def test_func(num):
    for i in range(num):
        time.sleep(1)
```
输出:
```python 
t = TestClass()
t.test(1, 2, 3)

test_func(5)

<function TestClass.test at 0x7f14400bb950>((<__main__.TestClass object at 0x7f14400cea90>, 1, 2, 3), {})
before execute
1 2 3
after execute
<function test_func at 0x7f1440360730>((5,), {})
before execute
after execute
```




# 参考文献
[使用functools模块wrap方法装饰函数](https://blog.csdn.net/kongxx/article/details/51654751)