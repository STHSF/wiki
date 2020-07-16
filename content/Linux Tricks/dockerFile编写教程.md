---
title: "DokcerFile编写教程"
layout: page
date: 2019-06-02 00:00
---
[TOC]

# 一 写在前面
生成镜像的两种方法：dockerfile创建和手动创建

Dockerfile是由一系列命令和参数构成的脚本，这些命令应用于基础镜像并最终创建一个新的镜像。它们简化了从头到尾的流程并极大的简化了部署工作。Dockerfile从FROM命令开始，紧接着跟随者各种方法，命令和参数。其产出为一个新的可以用于创建容器的镜像，类似于makefile

# 二 Dockerfile基础知识
## 2.1 常用命令列表
|部分 |命令 |
|---|---|
基础镜像信息|FROM
维护者信息|MAINTAINER
镜像操作指令|RUN、COPY、ADD、EXPOSE、WORKDIR、ONBUILD、USER、VOLUME等
容器启动时执行指令|CMD、ENTRYPOINT

## 2.2 各命令详解
### 2.2.1 FROM
指定一个镜像作为当前镜像的基础镜像, 如:
```
FROM ubuntu:16.04
```
### 2.2.2 MAINTAINER
指明该镜像的作者和电子邮件, 如:
```
MAINTAINER <aiministrator> <aimin@163.com>
```
### 2.2.3 RUN
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
### 2.2.4 COPY
将主机的文件复制到镜像内, 如果目的位置不存在, Docker会自动创建所需要的目录结构, 但是COPY操作只是进行单纯的复制操作, 如:
```
COPY configure.conf /home/work/workspace/src/
```
**注意：需要复制的目录一定要放在Dockerfile文件的同级目录下**
### 2.2.5 ADD
将主机的文件复制到镜像内, 与COPY的使用方式一样, 唯一不同的就是, ADD会对压缩文件（tar, gzip, bzip2, etc）做提取和解压操作.
### 2.2.6 EXPOSE
暴露镜像的端口供主机映射使用, 启动镜像时, 使用-P参数镜像指定的端口和主机的某一个端口做映射. expose可以指定多个, 如:
```
EXPOSE 22
EXPOSE 8080
EXPOSE 8989
```
### 2.2.7 USER
指定该镜像以什么样的用户去执行, 如:
```
USER mongo
```
### 2.2.8 WORKDIR
在构建镜像时, 指定工作目录, 之后的所有命令都是基于此工作目录, 如果不存在则会自动创建, 如:
```
WORKDIR /home/work
WORKDIR src
RUN echo "hello word" > text.txt
# 最终会在/home/work/src/下面生成一个text.txt文件.
```
### 2.2.9 ENV
设置docker的环境变量, 如
```
ENV CORE_DIR=/home/work/src
ENV SCRIPT_DIR=$CORE_DIR/script
RUN $SCRIPT_DIR/run.sh
```
### 2.2.10 VOLUME
用来向基于镜像创建的容器添加卷. 比如, 你可以将mongodb镜像中的存储数据的data文件指定为主机的某个文件.
```
# VOLUME 主机目录 容器目录
VOLUME data/db /data/onfigdb
```
### 2.2.11 CMD
容器启动时需要执行的命令, 如
```
CMD bin/bash
```
同样可以使用exec的写法,
```
CMD ["bin/bash"]
```
**当有多个CMD时, 只有最后一个生效**
### 2.2.12 ENTRYPOINT
与CMD的用法一样, 但是CMD和ENTRYPOINT同样作为容器启动时执行的命令,会有以下的区别:

- CMD的命令会被docker run 命令所覆盖, 但是ECTRYPOINT不会. 而是把docker run 后面的命令当作ENTRYPOINT执行命令的参数
  
  如 Dockerfile中有:
  ```
  ENTRYPOINT ["/usr/sbin/nginx"]
  ```
  然后通过启动build之后的容器
  ```
  docker run -it <image> -g "daemon off"
  ```
  此时, ```-g "daemon off"```会被当作参数传递给ENTRYPOINT, 最后执行的命令变成了
  ```
  /usr/sbin/nginx -g "daemon off"
  ```

- CMD和ENTRYPOINT同时存在时, CMD的指令会变成ENTRYPOINT的参数，并且此CMD提供的参数会被 docker run 后面的命令覆盖，如
  ```
  ENTRYPOINT ["echo", "hello", "i am"]
  CMD ["docker]
  ```
  之后启动构建之后的容器
  
  - 使用```docker run -it <image>```
    输出 hello i am docker
  - 使用```docker run -it <iamge> "word"```
    输出```hello i am word```

### 2.2.13 简单的demo
```
FROM ubuntu:16.04
MAINTAINER jerry jerry@163.com

WORKDIR /usr/local/docker
EXPOSE 22
RUN groupadd -r jerry && useradd -r -g jerry jerry
RUN mkdir ./src
USER jerry

ENTRYPOINT ["/bin/bash"]
```
build过程
```
jerry@jerry:~/workshop/projects/docker_test$ sudo docker build -t dockertest:1.0 .
[sudo] password for jerry:
Sending build context to Docker daemon  2.048kB
Step 1/8 : FROM ubuntu:16.04
 ---> 7e87e2b3bf7a
Step 2/8 : MAINTAINER jerry jerry@163.com
 ---> Running in 5b2c4c331bc9
Removing intermediate container 5b2c4c331bc9
 ---> 73189b8ceeec
Step 3/8 : WORKDIR /usr/local/docker
 ---> Running in 8ddfcbe19c73
Removing intermediate container 8ddfcbe19c73
 ---> 6a49fe822d3f
Step 4/8 : EXPOSE 22
 ---> Running in b481784335cc
Removing intermediate container b481784335cc
 ---> 9b990c863e69
Step 5/8 : RUN groupadd -r jerry && useradd -r -g jerry jerry
 ---> Running in c0a84adf513f
Removing intermediate container c0a84adf513f
 ---> 8a8ea468875a
Step 6/8 : RUN mkdir ./src
 ---> Running in ebde8480c3c6
Removing intermediate container ebde8480c3c6
 ---> 47f29299b140
Step 7/8 : USER jerry
 ---> Running in cb74c81ea036
Removing intermediate container cb74c81ea036
 ---> 24d938766125
Step 8/8 : ENTRYPOINT ["/bin/bash"]
 ---> Running in 17c9e3dca85d
Removing intermediate container 17c9e3dca85d
 ---> bd07ab03e9d9
Successfully built bd07ab03e9d9
Successfully tagged dockertest:1.0
```
进入docker之后,注意一些变化
```bash
root@jerry:/home/jerry/workshop/projects/docker_test# docker run -it ba0
jerry@051e0e29e94f:/usr/local/docker$ ls
src
```
注意, docker的用户名和RUN产生的结果.


# 三 基础镜像制作
基础镜像是镜像中运行的项目或者启动的一些服务，都要在一个基础镜像之上才能运行这些服务，比如一个django项目或者mysql数据库等，都要在Linux操作系统之上来运行，所以打包我们自己的项目时，必须要有个基础镜像来当作我们项目运行的基础环境。

基础镜像一般为某个linux操作系统, 比如centos, ubuntu等. 里面可以包含一些通用的服务, 比如python版本,等等
## 3.1 基础镜像的Dockerfile
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

其中, run.sh脚本里面的内容也可以直接在dockerfile里面使用RUN编写一些安装过程.

例如, 我们创建一个以centos为基础镜像, 然后在此基础上添加python环境的Dockerfile.

```Dockerfile
# 基础镜像Dockerfile, 包含python3.6.8
FROM centos:7.6.1810
MAINTAINER liyu

ENV PATH $PATH:/usr/local/python3/bin/
ENV PYTHONIOENCODING utf-8

RUN set -ex \
	&& mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
	&& curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
	&& yum makecache \
	&& sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo \
  # 使用yum安装在安装python时需要的工具包
	&& yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make wget \
	&& yum clean all \
	&& mkdir /usr/local/python3 \
	&& wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tar.xz \
	&& tar -xvJf  Python-3.6.8.tar.xz && rm -f Python-3.6.8.tar.xz \
	&& cd Python-3.6.8 \
	&& ./configure prefix=/usr/local/python3 \
	&& make && make install \
	# 使用软连接之后，yum的配置文件需要修改， 具体参考https://www.cnblogs.com/Trees/p/7497268.html
	# 暂时的解决方案是进入到docker中对yum等配置文件进行修改
	&& ln -s -f /usr/local/python3/bin/python3.6 /usr/bin/python \
	&& ln -s -f /usr/local/python3/bin/pip3.6 /usr/bin/pip \
	&& cd .. \
	&& rm -rf Python-3.6.8

RUN rm -rf /tmp

CMD ["bin/bash"]
```

Dockerfile文件编写完成之后,执行下面的命令
```bash
docker build -t <REPOSITORY>:<TAG>
```

这样,就可以生成一个基础镜像了.

当然, 也可以有另外的方式进行安装, 比如, 我们可以直接pull一个纯净的镜像, 然后启动镜像, 在contanier中执行所需要的安装, 安装完成之后可以直接push成image, 这个image跟上面Dockerfile启动的基本上应该没什么区别
# 四 项目镜像
基础镜像中包含了通用的一些信息, 这些信息大部分项目中都可能会用到, 或者需要跟某些正式环境中相互一致的信息, 而项目镜像中则需要根据不同项目的需求安装自己的库.比如某个项目需要使用到http和tcp服务等. 同时还可以把自己的项目代码通过Dockerfile复制到容器内, 熟练使用将会非常方便的部署Docker

## 4.1 项目镜像的Dockerfile(Ubuntu)
以ubuntu为基础镜像生成项目镜像
```Dockerfile
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

## 4.2 项目镜像的Dockerfile(CentOS)
以centos为基础镜像生成项目镜像
```Dockerfile
# 推荐系统排序模型DockerFile
FROM deepq:1.0
MAINTAINER liyu

RUN mkdir -p /root/ai/files/recsys/rank-model/rankmodel_lgb/0.0.1-install_files/

COPY ./install_files/* /root/ai/files/recsys/rank-model/rankmodel_lgb/0.0.1-install_files/

ENV LANG "en_US.UTF-8"

# 基础环境配置
RUN chmod +x /root/ai/files/recsys/rank-model/rankmodel_lgb/0.0.1-install_files/start_api \
    && mkdir /root/ai/files/recsys/rank-model/rankmodel_lgb/0.0.1-install_files/.rankmodel_lgb \
    && mkdir /root/ai/files/recsys/rank-model/rankmodel_lgb/0.0.1-install_files/.rankmodel_lgb/log \
    && mkdir /root/ai/files/recsys/rank-model/rankmodel_lgb/0.0.1/ \
    && pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip install --no-cache-dir -r /root/ai/files/recsys/rank-model/rankmodel_lgb/0.0.1-install_files/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip install --no-cache-dir /root/ai/files/recsys/rank-model/rankmodel_lgb/0.0.1-install_files/rankmodel_lgb-0.0.2-py3-none-any.whl

# LightGBM安装
RUN set -ex \
    && yum install -y git \
    && yum install -y gcc gcc-c++ make automake \
    && yum install -y cmake \
    && yum install -y setuptool

RUN git clone --recursive --branch v3-release --depth 1 https://github.com/Microsoft/LightGBM && \
    mkdir LightGBM/build && \
    cd LightGBM/build && \
    cmake .. && \
    make -j4 && \
    make install && \
    cd ../ && \
    cd python-package/ && \
    python setup.py install && \
    cd ../.. && \
    rm -rf LightGBM

# java环境配置
RUN yum install java-1.8.0-openjdk* -y \
    && export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6.x86_64 \
    && export JRE_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6.x86_64 \
    && export CLASSPATH=.:JAVAHOME/jre/lib:JAVA_HOME/lib \
    && export PATH=PATH:JAVA_HOME/bin

RUN set -ex rm -rf /tmp

RUN echo =******=================== \
    && ls -al /root/ai/files/recsys/rank-model/rankmodel_lgb/0.0.1-install_files/ \
    && pip list\
    && echo =****************===================================

RUN yum clean all

CMD ["bin/bash"]
```

# 五 容器管理
## Portainer
轻量级图形页面管理
### 5.1、查看, 下载portainer镜像
```bash
docker search portainer
docker pull portainer/portainer
```
### 5.2、启动dockerUI镜像
```
docker run -d --name portainerUI -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
```
启动完成之后, 浏览器访问 http://IP:9000 , 设置一个密码即可，然后点击创建用户(Create user), 就可以在页面中查看和管理本地机器的docker了.

# 六、kubernetes管理容器


# 七、坑
### 7.1、CMD[]中的命令有问题

<center><img src="/wiki/static/images/docker/docker_run_failed.png" alt="run_failed" height="80" width="800"/></center>

运行docker镜像的代码 ```docker run -q images:tags```

出现这种情况的主要原因是在启动docker镜像的时候没有指定执行命令, 此时, 就会执行Dockerfile中预设的CMD命令, 但是用于当时Dockerfile中的CMD命令是```CMD["usr", "bin", "bash"]```, 所以运行镜像会出现上图的错误. 

可以将CMD修改成通用的比如```CMD["/bin/bash"]```等. 

### 7.2、执行```docker -d run```之后, 后台却没有启动
- 想要后台运行docker, 然后使用```docker run -d --name server images:tags ```, 然后使用```docker ps ```查看, 却发现后台没有运行成功

主要原因就是镜像构建过程中Dockerfile添加了```CMD["/bin/bash"]```命令, 意味着在执行```run -d ```在后台运行的时候，这个镜像创建的容器会首先执行/bin/bash，这意味着，当在后台运行（-d）时，shell立即退出。所以除非命令未在前台运行，否则容器会立即停止

解决方案, 通过```-i```或者```-t```为```-d```提供一个伪"tty n"

比如```docker run -i -t -d images:tags ```

另外, Docker官方更是提倡-i 和 -t搭配使用，使其行为类似于shell。

更多细节在官方文档有提到哦
[分离模式](https://docs.docker.com/engine/reference/run/#detached--d) and in [前台模式 (-t, -i or -it)](https://docs.docker.com/engine/reference/run/#foreground)



# 八 参考文献
[Docker Dockerfile 定制镜像](https://blog.csdn.net/wo18237095579/article/details/80540571)

[将应用制作成镜像发布到服务器k8s上作为容器微服务运行](https://blog.csdn.net/luanpeng825485697/article/details/81256680)

[python项目打包成docker镜像并发布](https://blog.csdn.net/bocai_xiaodaidai/article/details/92838984)

[python项目代码打包成Docker镜像](https://www.cnblogs.com/sammy1989/p/9406899.html)

[Docker应用配置文件管理的正确姿势](https://www.sohu.com/a/156424469_151779)

