---
title: "Nvidia-Docker安装"
layout: page
date: 2018-06-02 00:00
---
[TOC]

# 写在前面
nvidia-docker是一个可以使用GPU的docker，nvidia-docker是在docker上做了一层封装，通过nvidia-docker-plugin，然后调用到docker上，其最终实现的还是在docker的启动命令上携带一些必要的参数。

# 安装docker-ce和nvidia驱动
在安装nvidia-docker之前，还是需要安装docker的。

# 安装nvidia-docker
安装过程主要参考[官网安装](https://github.com/NVIDIA/nvidia-docker), 安装nvidia-docker之前必须确保已经安装了NVIDIA driver, 且安装的Docker版本>19.03.

如果是第一次使用GPUs和Docker的用户, 可以直接使用下面的命令:
```
# Add the package repositories
$ distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
$ curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
$ curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

$ sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
$ sudo systemctl restart docker
```
运行过程如下:
<center><img src="/wiki/static/images/docker/nvidia-docker_install.png" alt="nvidia-docker"/></center>




# 参考文献
[如何在ubuntu上安装nvidia-docker同时与宿主共享GPU cuda加速](https://www.liangzl.com/get-article-detail-3784.html)

[ubuntu16.04下docker和nvidia-docker安装](https://blog.csdn.net/qq_41493990/article/details/81624419)

[安装NVIDIA-DOCKER](https://www.jianshu.com/p/f25ccedb996e)

[nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

[ubuntu16.04下docker和nvidia-docker安装](https://blog.csdn.net/qq_41493990/article/details/81624419)