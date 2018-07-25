---
title: "docker使用教程"
layout: page
date: 2018-07-25 10:00
---

# 写在前面
linux队

# 启动和关闭docker服务

### 启动
```
service docker start
或
systemctl start docker
```
### 关闭
```
service docker stop
或
systemctl stop docker
```
# 运行image实例container
对于Docker来说，image是静态的，类似于操作系统快照，而container则是动态的，是image的运行实例。
先使用```sudo docker images```查看pull下来的iamge。
如：
```
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
tensorflow/serving   latest-devel-gpu    e8667aaa087d        5 days ago          4.34GB
```
则可以通过下面两种方式启动
```
sudo docker run -i -t tensorflow/serving:latest-devel-gpu /bin/bash
或
sudo docker run -i -t e8667aaa087d
```
具体参数可以网上搜索

这样就可以进入container了
```
root@f906aeaa80e7:
```
同时。我们可以在container所在的外部操作系统中运行```sudo docker ps```和```sudo docker ps -a```来分别查看运行中的container和所有的包括未运行的container。
```
CONTAINER ID        IMAGE                                 COMMAND             CREATED             STATUS                   PORTS                    NAMES
1a2b5c8e0f69        tensorflow/serving:latest-devel-gpu   "/bin/bash"         9 hours ago         Exited (1) 9 hours ago                            hardcore_rosalind
c820900be758        tensorflow/serving:latest-devel-gpu   "/bin/bash"         20 hours ago        Exited (0) 2 hours ago                            brave_agnesi
aad1b70763ab        tensorflow/serving:latest-devel-gpu   "/bin/bash"         20 hours ago        Created                                           condescending_jackson
f906aeaa80e7        tensorflow/serving:latest-devel-gpu   "/bin/bash"         20 hours ago        Up 2 hours               0.0.0.0:8500->8500/tcp   mystifying_sinoussi
```
# 退出container
直接使用Ctrl + d或者在container中运行exit


# 重新启动某个image的container
对于docker还是小白的我曾经遇到这样一个问题，我pull了一个image到本地，然后运行这个image，这时候系统会生成一个contaner ID，我在contaner中安装了很多东西，比如vim，pip 之类的简单应用，并且编译了一些程序。完成之后直接退出。第二天使用的时候我还是运行了这个image，但是之前所有的配置全部没了。后来发现是自己错了，我每次运行的都是第一次pull下来的image，相当于每次启动的都是一个新的container，而我原来配置编译的那个container需要使用```sudo docker ps -a```就能看出来了。

如果想要再次打开之前使用过的container，则可以运行：
```
sudo docker start container_name
或
sudo docker start CONTAINER_ID
```
启动该container之后，使用```sudo docker attach container_name/container_id```进入该container。



# 参考文献
[如何进入、退出docker的container](https://blog.csdn.net/dongdong9223/article/details/52998375)
[Using TensorFlow Serving via Docker](https://github.com/tensorflow/serving/blob/master/tensorflow_serving/g3doc/docker.md)