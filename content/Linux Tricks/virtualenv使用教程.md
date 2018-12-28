---
title: "virtualenv使用教程"
layout: page
date: 2018-12-28 10:00
---

# 写在前面
使用virtualenv创建虚拟环境,如果环境中又安装了conda,在使用source activate的时候可能会遇到不可遇见的问题,比如说环境混乱,特别是在使用复制过来的venv时很容易出错,所以建议一般使用requirement.txt重新安装.

# 创建环境
### 创建python2环境
```shell
virtualenv venv
or
virtualenv -p /usr/bin/python2 venv
```
###  创建python3环境
```shell
virtualenv -p /usr/bin/python3 venv
```
### 创建完全纯净的python环境
```shell
virtualenv --no-site-packages venv
```

## 激活虚拟环境
```shell
source venv/bin/activate
```
### 注
- 同时安装virtualenv和annconda后,在激活虚拟环境时可能会混乱,比如激活virtualenv缺激活了conda环境.可能需要重复使用```conda deactivate```, ```deactivate```等命令退出虚拟环境,然后重新source.