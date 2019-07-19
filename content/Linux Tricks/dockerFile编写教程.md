---
title: "DokcerFile编写教程"
layout: page
date: 2019-06-02 00:00
---
[TOC]

# 写在前面


# 1、基础镜像
基础镜像是镜像中运行的项目或者启动的一些服务，都要在一个基础镜像之上才能运行这些服务，比如一个django项目或者mysql数据库等，都要在Linux操作系统之上来运行，所以打包我们自己的项目时，必须要有个基础镜像来当作我们项目运行的基础环境。

基础镜像一般为某个linux操作系统, 比如centos, ubuntu等. 里面可以包含一些通用的服务, 比如python版本,等等
## 基础镜像的Dockerfile
首先我们看一下本地机器的文件目录如下:
```
root@jerry:/home/jerry/workshop/projects/docker# ll
total 12
drwxr-xr-x  3 root  root  4096 Jul 18 20:08 ./
drwxrwxrwx 31 jerry jerry 4096 Jul 18 20:00 ../
-rw-r--r--  1 root  root     0 Jul 18 20:01 Dockerfile
drwxr-xr-x  2 root  root  4096 Jul 18 20:08 scripts/
```
scripts/目录下保存的是run.sh文件, 文件内容为:
```
#!/bin/bash

apt-get update
apt-get install -y gcc make \
                -y wget \
                -y net-tools \
                -y inetutils-ping \
                -y apt-utils
#python3.5
wget https://www.python.org/ftp/python/3.5.4/Python-3.5.4.tgz
tar -zxvf Python-3.5.4.tgz
cd Python-3.5.4
./configure
make && make install

ln -s /usr/bin/python3 /usr/bin/python
rm -rf Python-3.5.4*

#pip3
apt-get update && apt-get install -y  python3-pip
```
实际上就是简单的安装python3和pip3的过程

下面是一个比较简单的Dockerfile, 主要功能是基于基础镜像, 在基础镜像的基础上执行run.sh中的内容.
```
#基础镜像为centos，版本为7，build镜像时会自动下载
FROM ubuntu:16.04
 
#制作者信息
MAINTAINER liyu52577@163.com
 
#设置环境变量
ENV CODE_DIR=/opt/workshop
ENV DOCKER_SCRIPTS=$CODE_DIR/base_image/scripts
 
#将scripts下的文件复制到镜像中的DOCKER_SCRIPTS目录
COPY ./scripts/* $DOCKER_SCRIPTS/
 
#执行镜像中的provision.sh脚本
RUN chmod a+x $DOCKER_SCRIPTS/*
RUN $DOCKER_SCRIPTS/run.sh
```
其中, run.sh脚本里面的内通, 当然,你也可以直接在dockerfile里面使用RUN编写一些安装过程

Dockerfile文件编写完成之后,执行下面的命令
```
docker build -t <REPOSITORY>:<TAG>
```
这样,就可以生成一个基础镜像了.

当然, 也可以有另外的方式进行安装, 比如, 我们可以直接pull一个纯净的镜像, 然后启动镜像, 在contanier中执行所需要的安装, 安装完成之后可以直接push成image, 这个image跟
# 2、项目镜像

# 3、容器管理

# 4、kubernetes管理容器

# 参考文献
[将应用制作成镜像发布到服务器k8s上作为容器微服务运行](https://blog.csdn.net/luanpeng825485697/article/details/81256680)

[]()

[]()

[]()