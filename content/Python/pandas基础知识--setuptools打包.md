---
title: "pandas基础知识--setuptools打包.md"
layout: page
date: 2018-01-30 13:00
---

# 打包测试
```
python setup.py test
```
# 打包
```
python setup.py bdist_wheel
```

# 问题
## 问题1
使用```python setup.py install```安装完成之后, 调用包接口, 显示```No module named XXX```, setup.py文件中的```name```跟```XXX```是一致的, 而且也添加了```__init__.py```文件

## 原因 
刚开始怀疑目录下面缺少```__init__.py```文件, 但实际上在查看生成的build文件时发现, 原来将setup.py放在了安装包文件目录的内部, 打包完成之后发现```./build/lib/```目录下并不是以```XXX```为主目录的包结构, 而是以```XXX```命名的目录下的文件, 由此可以看出setup.py文件放错了位置, 而是应该放在以```XXX```为主目录的包结构的外面, 这样, 打包之后才能将以```XXX```命名的文件全部打包进去.

正确打包的build结果如下:
<center><img src="/wiki/static/images/python/Snipaste_2020-07-07_18-39-52.png" alt="build"/></center>
