---
title: "ubuntu下node快速安装"
layout: page
date: 2018-06-02 00:00
---
[TOC]

# 写在前面


# 1、直接使用已经编译好的包
从[Node官网](https://nodejs.org/dist/)现在已经编译好的版本,下载完成后直接解压使用:
选择自己需要的版本例如```/v10.15.3/node-v10.15.3-linux-arm64.tar.gz ```:

```
wget https://nodejs.org/dist//v10.15.3/node-v10.15.3-linux-arm64.tar.gz    // 下载
tar -xzvf  node-v10.15.3-linux-arm64.tar.gz       // 解压
cd node-v10.15.3-linux-arm64/                  // 进入解压目录
# 然后使用下面的命令查看node版本
./bin/node -v                               // 执行node命令 查看版本
```
为安装包创建软连接

```
# 现将文件夹重命名
mv node-v10.15.3-linux-arm64 nodejs

# 创建软连接
ln -s /usr/local/software/nodejs/bin/npm /usr/local/bin/
ls -s /usr/local/software/nodejs/bin/node /usr/local/bin/
```

# 2、源码安装
从官网或者github下载对应的源码包,下载方式同上

```
# 下载解压完成之后需要修改文件目录的权限
sudo chmod -R 755 node

# 使用./configure创建编译文件
cd node
sudo ./configure
# 编译安装
sudo make
sudo make install
```
安装结束,这里不需要创建软连接或者配置环境变量

# 3、 apt-get install
命令格式如下:
```
sudo apt-get update
sudo apt-get install nodejs
sudo apt-get install npm
```
**注意, 使用apt-get安装的node和npm版本都太低,有时不太适用其他的兼容包的需求,就算使用```npm install -g npm```等方式更新npm也不行,不知道什么原因. 如果你知道可以issue我.**

# 参考文献