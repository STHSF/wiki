---
title: "DokcerFile编写教程"
layout: page
date: 2019-06-02 00:00
---
[TOC]

# 写在前面
# Dockerfile基础知识
## 1) 常用命令列表
|||
|---|---|
部分|命令
基础镜像信息|FROM
维护者信息|MAINTAINER
镜像操作指令|RUN、COPY、ADD、EXPOSE、WORKDIR、ONBUILD、USER、VOLUME等
容器启动时执行指令|CMD、ENTRYPOINT
## 2) 各命令详解
### FROM
指定一个镜像作为当前镜像的基础镜像, 如:
```
FROM ubuntu:16.04
```
###  MAINTAINER
指明该镜像的作者和电子邮件, 如:
```
MAINTAINER <aiministrator> <aimin@163.com>
```
### RUN
在新镜像内部运行对应的命令, 主要用于新建文件, 文件目录, 安装软件, 配置一些基础信息等, 如:
```bash
RUN mkdir /home/work/workspace \
    echo "hello word" > \ 
    /home/work/hello.txt \
    apt-get install -y python3.5
```
可以使用换行符```\```来进行换行操作.

当然, 也可以使用exec的格式的命令, 如:"RUN ["executable", "param1", "param2"]", 其中, executable是命令, 后面的param是参数.
```
RUN ["apt-get", "-y", "nginx"]
```
### COPY
将主机的文件复制到镜像内, 如果目的位置不存在, Docker会自动创建所需要的目录结构, 但是COPY操作只是进行单纯的复制操作, 如:
```
COPY configure.conf /home/work/workspace/src/
```
**注意：需要复制的目录一定要放在Dockerfile文件的同级目录下**

### ADD
将主机的文件复制到镜像内, 


# 1、基础镜像
基础镜像是镜像中运行的项目或者启动的一些服务，都要在一个基础镜像之上才能运行这些服务，比如一个django项目或者mysql数据库等，都要在Linux操作系统之上来运行，所以打包我们自己的项目时，必须要有个基础镜像来当作我们项目运行的基础环境。

基础镜像一般为某个linux操作系统, 比如centos, ubuntu等. 里面可以包含一些通用的服务, 比如python版本,等等
## 基础镜像的Dockerfile
首先我们看一下本地机器的文件目录如下:
```bash
root@jerry:/home/jerry/workshop/projects/docker# ll
total 12
drwxr-xr-x  3 root  root  4096 Jul 18 20:08 ./
drwxrwxrwx 31 jerry jerry 4096 Jul 18 20:00 ../
-rw-r--r--  1 root  root     0 Jul 18 20:01 Dockerfile
drwxr-xr-x  2 root  root  4096 Jul 18 20:08 scripts/
```
scripts/目录下保存的是run.sh文件, 文件内容为:
```bash
#!/bin/bash

apt-get update
apt-get install -y gcc make \
                -y wget \
                -y net-tools \
                -y inetutils-ping \
                -y apt-utils
# python3.5
wget https://www.python.org/ftp/python/3.5.4/Python-3.5.4.tgz
tar -zxvf Python-3.5.4.tgz
cd Python-3.5.4
./configure
make && make install

ln -s /usr/bin/python3 /usr/bin/python
rm -rf Python-3.5.4*

# pip3
apt-get update && apt-get install -y  python3-pip
```
实际上就是简单的安装python3和pip3的过程

下面是一个比较简单的Dockerfile, 主要功能是基于基础镜像, 在基础镜像的基础上执行run.sh中的内容.
```Dockerfile
# 基础镜像为ubuntu，版本为16.04，build镜像时会自动下载
FROM ubuntu:16.04

# 制作者信息
MAINTAINER liyu liyu52577@163.com

# 设置环境变量
ENV CODE_DIR=/opt/workshop
ENV DOCKER_SCRIPTS=$CODE_DIR/base_image/scripts

# 将scripts下的文件复制到镜像中的DOCKER_SCRIPTS目录
COPY ./scripts/* $DOCKER_SCRIPTS/

# 执行镜像中的provision.sh脚本
RUN chmod a+x $DOCKER_SCRIPTS/*
RUN $DOCKER_SCRIPTS/run.sh
```

其中, run.sh脚本里面的内通, 当然,你也可以直接在dockerfile里面使用RUN编写一些安装过程

Dockerfile文件编写完成之后,执行下面的命令
```bash
docker build -t <REPOSITORY>:<TAG>
```

这样,就可以生成一个基础镜像了.

当然, 也可以有另外的方式进行安装, 比如, 我们可以直接pull一个纯净的镜像, 然后启动镜像, 在contanier中执行所需要的安装, 安装完成之后可以直接push成image, 这个image跟上面Dockerfile启动的基本上应该没什么区别
# 2、项目镜像
基础镜像中包含了通用的一些信息, 这些信息大部分项目中都可能会用到, 或者需要跟某些正式环境中相互一致的信息, 而项目镜像中则需要根据不同项目的需求安装自己的库.比如某个项目需要使用到http和tcp服务等. 同时还可以把自己的项目代码通过Dockerfile复制到容器内, 熟练使用将会非常方便的部署Docker

项目镜像的Dockerfile：
```
#基础镜像
FROM ubuntu_base:1.2
 
#语言编码设置
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
ENV LC_ALL zh_CN.UTF-8
 
#将项目目录文件复制到镜像中,CODE_DIR是在基础镜像中定义的
COPY ./jerry $CODE_DIR/jerry/
 
#安装项目依赖包
RUN pip install -r $CODE_DIR/jerry/requirements.txt
 
#暴露端口
EXPOSE 8989

#启动项目
CMD ["python", "/opt/workshop/jerry/src/hello.py"]
```



# 3、容器管理

# 4、kubernetes管理容器

# 参考文献
[Docker Dockerfile 定制镜像](https://blog.csdn.net/wo18237095579/article/details/80540571)

[将应用制作成镜像发布到服务器k8s上作为容器微服务运行](https://blog.csdn.net/luanpeng825485697/article/details/81256680)

[python项目打包成docker镜像并发布](https://blog.csdn.net/bocai_xiaodaidai/article/details/92838984)

[python项目代码打包成Docker镜像](https://www.cnblogs.com/sammy1989/p/9406899.html)

[]()