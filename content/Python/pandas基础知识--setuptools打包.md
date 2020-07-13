---
title: "pandas基础知识--setuptools打包"
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

# 打包非```.py```文件以外的静态资源--```MANIFEST.in```
## 模板
1、在setup.py中设置include_package_data=True

```python
from setuptools import setup, find_packages

setup(
    name='your_project_name',
    version='0.1',
    description='A description.',
    packages=find_packages(exclude=['ez_setup', 'tests', 'tests.*']),
    include_package_data=True,
    install_requires=[],
)
```

2、在根目录下新建 MANIFEST.in

```shell
include MANIFEST.in
include README.md
include *.txt  #包含根目录下的所有txt文件
recursive-include examples *.txt *.py  #包含所有位置的examples文件夹下的txt与py文件
prune examples/sample?/build  #排除所有位置examples/sample?/build
```

3、其他书写方式
```
include pat1 pat2 ...   #include all files matching any of the listed patterns
exclude pat1 pat2 ...   #exclude all files matching any of the listed patterns
recursive-include dir pat1 pat2 ...  #include all files under dir matching any of the listed patterns
recursive-exclude dir pat1 pat2 ... #exclude all files under dir matching any of the listed patterns
global-include pat1 pat2 ...    #include all files anywhere in the source tree matching — & any of the listed patterns
global-exclude pat1 pat2 ...    #exclude all files anywhere in the source tree matching — & any of the listed patterns
prune dir   #exclude all files under dir
graft dir   #include all files under dir
```


# 问题
## 问题1
使用```python setup.py install```安装完成之后, 调用包接口, 显示```No module named XXX```, setup.py文件中的```name```跟```XXX```是一致的, 而且也添加了```__init__.py```文件

## 原因 
刚开始怀疑目录下面缺少```__init__.py```文件, 但实际上在查看生成的build文件时发现, 原来将setup.py放在了安装包文件目录的内部, 打包完成之后发现```./build/lib/```目录下并不是以```XXX```为主目录的包结构, 而是以```XXX```命名的目录下的文件, 由此可以看出setup.py文件放错了位置, 而是应该放在以```XXX```为主目录的包结构的外面, 这样, 打包之后才能将以```XXX```命名的文件全部打包进去.

正确打包的build结果如下:
<center><img src="/wiki/static/images/python/Snipaste_2020-07-07_18-39-52.png" alt="build"/></center>
