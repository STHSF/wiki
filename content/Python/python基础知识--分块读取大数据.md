---
title: "python基础知识--分块读取大数据,避免内存不足"
layout: page
date: 2018-06-02 00:00
---
[TOC]

# 写在前面
python读取大文件时,可能会出现Memoryerror,为了避免内存不足, 可以参考下面的办法.
# 示例
```python
def read_data(file_name):
    inputfile = open(file_name, 'rb)
    chunk_data = pd.read_csv(inputfile, iterator=True)
    loop = True
    chunk_size = 1000
    chunks = []
    while loop:
        try:
            chunk = chunk_data.get_chunk(chunk_size)
            chunks.append(chunk)
        except StopIteration:
            loop = False
            print("Iteration is stopped")
    data = pd.concat(chunks, ignore_index=True)
return data
```

# Python如何处理大数据？3个技巧效率提升攻略
01、大型文件的读取效率

面对100w行的大型数据，经过测试各种文件读取方式，得出结论：

with open(filename,"rb") as f:
 for fLine in f:
 pass
方式最快，100w行全遍历2.7秒。

基本满足中大型文件处理效率需求。如果rb改为r，慢6倍。但是此方式处理文件，fLine为bytes类型。但是python自行断行，仍旧能很好的以行为单位处理读取内容。

02、文本处理效率问题

这里举例ascii定长文件,因为这个也并不是分隔符文件，所以打算采用列表操作实现数据分割。但是问题是处理20w条数据，时间急剧上升到12s。本以为是byte.decode增加了时间。遂去除decode全程bytes处理。但是发现效率还是很差。

最后用最简单方式测试，首次运行，最简单方式也要7.5秒100w次。

想知道这个方式处理的完整代码是什么吗？扫描文末二维码，联系小编可以获取哦~

那么关于python处理大文件的技巧，从网络整理三点：列表、文件属性、字典三个点来看看。

1.列表处理

def fun(x):尽量选择集合、字典数据类型，千万不要选择列表，列表的查询速度会超级慢，同样的，在已经使用集合或字典的情况下，不要再转化成列表进行操作，比如：
values_count = 0
# 不要用这种的
if values in dict.values():
 values_count += 1
# 尽量用这种的
if keys,values in dict:
 values_count += 1
后者的速度会比前者快好多好多。

2. 对于文件属性

如果遇到某个文件，其中有属性相同的，但又不能进行去重操作，没有办法使用集合或字典时，可以增加属性，比如将原数据重新映射出一列计数属性，让每一条属性具有唯一性，从而可以用字典或集合处理：

 return '(' + str(x) + ', 1)'
list(map(fun,[1,2,3]))
使用map函数将多个相同属性增加不同项。

3. 对于字典

多使用iteritems()少使用items()，iteritems()返回迭代器：

>>> d = {'a':1,'b':2}
>>> for i in d.items() :
.... print i
('a',1)
('b',2)
>>> for k,v in d.iteritems() :
... print k,v
('a',1)
('b',2)
字典的items函数返回的是键值对的元组的列表,而iteritems使用的是键值对的generator，items当使用时会调用整个列表 iteritems当使用时只会调用值。

除了以下5个python使用模块，你还有什么技巧解决大文件运行效率的问题吗？深入了解更多Python实用模块，快速提升工作效率~

读写文件技术，今后会用到测试数据的参数化和测试报告写作功能中~

数据处理技术，今后测试脚本的测试数据处理过程可以用到~

数据统计分析技术，今后会在测试结果分析中用到

图表展示技术，在今后的测试框架中相关测试报告会用到

程序自动触发技术，可用于测试脚本程序的自动执行。

# 参考文献

[使用Python Pandas处理亿级数据](http://www.justinablog.com/archives/1357)