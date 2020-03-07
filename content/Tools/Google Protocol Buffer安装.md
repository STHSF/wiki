---
title: "Google Protocol Buffer安装"
layout: page
date: 2018-06-02 00:00
---
[TOC]

### 安装
- 下载protobuf源代码（当前最新版本为：2.5.0） (https://github.com/google/protobuf/releases) protobuf-all-3.6.0.tar.gz
- 解压,编译，安装
    - tar zxvf protobuf-2.5.0.tar.gz 
    - cd protobuf-2.5.0 
    - ./configure 
    - make && make check && make install
- 继续安装protobuf的python模块
    - cd ./python 
    - python setup.py build 
    - python setup.py test 
    - python setup.py install
    - pip install -U protobuf
- 安装完成 验证:protoc –version

### 编译命令
- python：
    - protoc -I=${SRC_DIR} --python_out=${DET_DIR} ./testpb.proto 





来源:https://blog.csdn.net/u010029983/article/details/48997603