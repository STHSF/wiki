---
title: "XGBoost GPU安装"
layout: page
date: 2019-07-08 00:00
---
[TOC]

# 写在前面

# 主要步骤

## step 1
在git clone下来的xgboost中执行
```
git submodule init
git submodule update
```
更新子依赖
## step 2
在/xgboost, 目录下新建/build文件夹
```
cd xgboost
mkdir build
```
## step 3
执行cmake
```
cmake .. -DUSE_CUDA=ON
```
执行结果如下图所示:
<center><img src="/wiki/static/images/essemble/xgboost/xgboost_3.jpg" alt="xgboost-3"/></center>

## step 4
执行make
```
make -j4
```
执行过程和执行结果如下图:
<center><img src="/wiki/static/images/essemble/xgboost/xgboost_4.jpg" alt="xgboost-4"/></center>

<center><img src="/wiki/static/images/essemble/xgboost/xgboost_5.jpg" alt="xgboost-5"/></center>

# 注意点
1、cmake 版本更新
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


# 参考文献