---
title: "XGBoost GPU安装"
layout: page
date: 2019-07-08 00:00
---
[TOC]

# 写在前面
随着业务场景的慢慢深入, 数据量的逐步增大, 模型的训练时间不断的变长, 导致模型训练成本逐步增大. 所以需要更加高效的提高硬件计算资源的利用率, 本文主要介绍安装GPU版本的XGBoost.
# 单机部署
安装前提是需要GPU驱动, cudnn等安装正确, 如果这步没有安装, 请参见[Ubuntu16.04下安装安装CUDA9.0、cuDNN7.0和tensotflow-gpu 1.8.0以上的版本流程和问题总结](https://sthsf.github.io/wiki/Algorithm/DeepLearning/Tensorflow%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/Tensorflow%E5%9F%BA%E7%A1%80%E7%9F%A5%E8%AF%86---Tensorflow-gpu%E7%89%88%E6%9C%AC%E5%AE%89%E8%A3%85(2).html)的具体安装方式.
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

### 4、make
执行make
```
make -j4
```
执行过程和执行结果如下图:
<center><img src="/wiki/static/images/essemble/xgboost/xgboost_4.jpg" alt="xgboost-4"/></center>

<center><img src="/wiki/static/images/essemble/xgboost/xgboost_5.jpg" alt="xgboost-5"/></center>

***PS***很多教程中提到, 在make的过程中不需要用到-j4中的4, 他的解释是使用后会自动生成build目录, 但是我的理解是在新建的build目录下执行上面的命令, 所以不太理解他的做法, 另外我在pull源码下来后, 源码里事先没有build文件目录, 需要手动新建.

## virtualenv中更新XGBoost
一般的, 为了不污染原始环境, 我们都会使用虚拟环境隔离开发环境, 比如virtualenv或conda. 我使用的是vitrualenv, 所以介绍virtualenv中如何更新, 其实方式比较简单.

直接```pip uninstall XGBoost```先卸载掉原始的XGBoost 然后重新安装即可. 虚拟环境下可以完美调用GPU运行XGBoost.
调用情况如下:
<center><img src="/wiki/static/images/essemble/xgboost/xgboost_6.jpg" alt="xgboost-6"/></center>

annaconda下面没有测试过, 可能也需要重新安装.

# XGBoost的多GPU部署
待更新.....

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
[Installation Guide](https://xgboost.readthedocs.io/en/latest/build.html#building-with-gpu-support)

[linux下安装XGBoost并支持GPU（anaconda3）](https://blog.csdn.net/wl2858623940/article/details/80546140)

[ubuntu安装xgboost，CPU版和GPU版配置](https://blog.csdn.net/u011587516/article/details/78995186)

[GPU加速xgboost——win10下配置](https://blog.csdn.net/voidfaceless/article/details/78338678)

[Ubuntu16.04安装GPU版xgboost](https://blog.csdn.net/Perfect_Accepted/article/details/81989486)

[xgboost 多gpu支持 编译](https://www.cnblogs.com/kdyi/p/10636988.html)