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



# 参考文献