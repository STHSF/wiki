---
title: "ImportError: this is MySQLdb version (1, 2, 3, 'final', 0), but _mysql is version (1, 2, 5, 'final', 1)"
layout: page
date: 2017-08-16 08:59
---

## MySQLdb 安装
- 从[MySQL for Python](https://sourceforge.net/projects/mysql-python/files/mysql-python/1.2.3/)上下载安装压缩包。
```
wget  http://sourceforge.net/projects/mysql-python/files/mysql-python/1.2.3/MySQL-python-1.2.3.tar.gz
```
- 解压压缩包
```
tar zxvf MySQL-python-1.2.3.tar.gz 
```
- 编译
```
python setup.py build
python setup.py install
```
如果过程中没有报错则表示安装成功。
然后在python环境中输入```import MySQLdb```, 应该是不会报错的。

## 问题：
但是我在import MySQLdb的时候出现一下问题：
```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "MySQLdb/__init__.py", line 23, in <module>
    (version_info, _mysql.version_info))
ImportError: this is MySQLdb version (1, 2, 3, 'final', 0), but _mysql is version (1, 2, 5, 'final', 1)
```
## 解决方案
将原来编译好的MySQL-python-1.2.3包删除。
```
rm -rf MySQL-python-1.2.3
```
上面的问题就解决了。