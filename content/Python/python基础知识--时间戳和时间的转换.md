---
title: "python基础知识--时间戳和时间的转换"
layout: page
date: 2018-06-02 00:00
---
[TOC]

# 写在前面



```
import time
from datetime import datetime

strNow = '2012-01-03'
nowDate = time.strptime(strNow, "%Y-%m-%d")
print(nowDate)
print(type(nowDate))
nowDate = time.strftime("%Y-%m-%d", nowDate)
print(nowDate)
print(type(nowDate))


start_time = datetime.strptime(str(strNow), "%Y-%m-%d")
print(start_time)
print(type(start_time))
start_time = datetime.strftime(start_time, "%Y-%m-%d")
print(start_time)
print(type(start_time))
```


结果:

```
time.struct_time(tm_year=2012, tm_mon=1, tm_mday=3, tm_hour=0, tm_min=0, tm_sec=0, tm_wday=1, tm_yday=3, tm_isdst=-1)
<class 'time.struct_time'>
2012-01-03
<class 'str'>
2012-01-03 00:00:00
<class 'datetime.datetime'>
2012-01-03
<class 'str'>
```

# 参考文献
[使用Python完美管理和调度你的多个任务](https://blog.csdn.net/oh5W6HinUg43JvRhhB/article/details/78589009)