---
title: "XGBoost GPU安装"
layout: page
date: 2019-07-08 00:00
---
[TOC]

# 写在前面

# 安装过程
### 1、下载源码
在git clone下来的xgboost中执行
```
git submodule init
git submodule update
```
更新子依赖
### 2、新建build文件目录
在/xgboost, 目录下新建/build文件夹
```
cd xgboost
mkdir build
```
### 3、编译源码
执行cmake
```
cmake .. -DUSE_CUDA=ON
```
执行结果如下图所示:
<center><img src="/wiki/static/images/essemble/xgboost/xgboost_3.jpg" alt="xgboost-3"/></center>

### make
执行make
```
make -j4
```
执行过程和执行结果如下图:
<center><img src="/wiki/static/images/essemble/xgboost/xgboost_4.jpg" alt="xgboost-4"/></center>

<center><img src="/wiki/static/images/essemble/xgboost/xgboost_5.jpg" alt="xgboost-5"/></center>

***PS***很多教程中提到, 在make的过程中不需要用到-j4中的4, 他的解释是使用后会自动生成build目录, 但是我的理解是在新建的build目录下执行上面的命令, 所以不太理解他的做法, 另外我在pull源码下来后, 源码里事先没有build文件目录, 需要手动新建.

### virtualenv中更新XGBoost
一般的, 为了不污染原始环境, 我们都会使用虚拟环境隔离开发环境, 比如virtualenv或conda. 我使用的是vitrualenv, 所以介绍virtualenv中如何更新, 其实方式比较简单.

直接```pip uninstall XGBoost```先卸载掉原始的XGBoost 然后重新安装即可. 虚拟环境下可以完美调用GPU运行XGBoost.
调用情况如下:
<center><img src="/wiki/static/images/essemble/xgboost/xgboost_6.jpg" alt="xgboost-6"/></center>


# 注意点
### 1、cmake 版本更新
在编译过程中,可能会出现下面的问题, 原因是cmake的版本太低, 需要更新cmake版本.
```
CMake Error at CMakeLists.txt:62 (cmake_minimum_required):
  CMake 3.12 or higher is required.  You are running version 3.5.1
```
版本更新教程见[StackExcahnge](https://askubuntu.com/questions/829310/how-to-upgrade-cmake-in-ubuntu)
简单的安装步骤:
```
step 0: sudo apt remove cmake
step 1: cd /opt
step 2: wget https://github.com/Kitware/CMake/releases/download/v3.15.0-rc3/cmake-3.15.0-rc3-Linux-x86_64.sh
step 3: chmod +x cmake-3.*your_version*.sh
step 4: sudo bash cmake-3.*your_version*.sh
step 5: sudo ln -s /opt/cmake-3.*your_version*/bin/* /usr/local/bin
```

### 2、安装XGBoost gpu版本, python的版本必须大于3.5
报错如下:
```
RuntimeError: Python version >= 3.5 required.
```



# 参考文献

[linux下安装XGBoost并支持GPU（anaconda3）](https://blog.csdn.net/wl2858623940/article/details/80546140)