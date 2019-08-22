---
title: "pycharm中调用Docker环境"
layout: page
date: 2018-06-02 00:00
---
[TOC]

# 写在前面


## docker 启动
方法一
```
docker run -it \
-p 8080:8080 \
-p 8081:8081 \
-v /home/gpyz/workshop:/home/li/workshop \
-v /usr/include:/usr/include \
--privileged=True \
--gpus all \
[REPOSITORY:TAG] /bin/bash
```
方法二
```
nvidia-docker run -it \
-p 8080:8080 \
-p 8081:8081 \
-v /home/gpyz/workshop:/home/li/workshop \
-v /usr/include:/usr/include \
--privileged=True \
--runtime=nvidia \
[REPOSITORY:TAG] /bin/bash

```

方法一

```bash
docker run -it \
-p 8022:22 \
--restart always \
--privileged=True \
--runtime=nvidia \
--name quant_ \
sthsf/ubuntu_base:0.1 /usr/sbin/sshd -D
```

在基础镜像中安装配置好openssh, 然后commi成最新的基础镜像