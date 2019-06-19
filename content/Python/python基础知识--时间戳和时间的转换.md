---
title: "python基础知识--时间戳和时间的转换"
layout: page
date: 2018-06-02 00:00
---
[TOC]

# 写在前面
整理time和datetime的异同

## time
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
```
输出:
```
time.struct_time(tm_year=2012, tm_mon=1, tm_mday=3, tm_hour=0, tm_min=0, tm_sec=0, tm_wday=1, tm_yday=3, tm_isdst=-1)
<class 'time.struct_time'>

2012-01-03
<class 'str'>
```

## datetime
```
# str -> datetime.datetime
start_time = datetime.strptime(str(strNow), "%Y-%m-%d")
print(start_time)
print(type(start_time))

# datetime.datetime -> str
start_time = datetime.strftime(start_time, "%Y-%m-%d")
print(start_time)
print(type(start_time))
```
结果:
```
2012-01-03 00:00:00
<class 'datetime.datetime'>

2012-01-03
<class 'str'>
```

## datetime
#### 获取当前时间之前的某个时间点
```
from datetime import datetime, timedelta
# 获取当前时间
trade_date = datetime.today()
# 前1分钟
time_array = trade_date - timedelta(minutes=1)
date_time_1 = datetime.strftime(time_array, "%Y-%m-%d %H:%M:%S")
# 前一小时
time_array = trade_date - timedelta(hours=1)
date_time_2 = datetime.strftime(time_array, "%Y-%m-%d %H:%M:%S")
# 前一天
time_array = trade_date - timedelta(days=1)
date_time_3 = datetime.strftime(time_array, "%Y-%m-%d %H:%M:%S")
# 前一周
time_array = trade_date - timedelta(weeks=1)
date_time_4 = datetime.strftime(time_array, "%Y-%m-%d %H:%M:%S")
# 前一个月
time_array = trade_date - timedelta(days=3)
date_time_5 = datetime.strftime(time_array, "%Y-%m-%d %H:%M:%S")
# 前一年
time_array = trade_date - timedelta(days=365)
date_time_6 = datetime.strftime(time_array, "%Y-%m-%d %H:%M:%S")
print('当前时间: %s' % trade_date)
print('前1分钟: %s'% date_time_1)
print('前一小时: %s'% date_time_2)
print('前一天: %s'% date_time_3)
print('前一周: %s'% date_time_4)
print('前一月: %s'% date_time_5)
print('前一年: %s'% date_time_6)
```

输出结果:
```
当前时间: 2019-06-19 14:51:05.860482
前1分钟: 2019-06-19 14:50:05
前一小时: 2019-06-19 13:51:05
前一天: 2019-06-18 14:51:05
前一周: 2019-06-12 14:51:05
前一月: 2019-06-16 14:51:05
前一年: 2018-06-19 14:51:05
```

### 总结
相对来说, datetime比time使用方便


# 参考文献