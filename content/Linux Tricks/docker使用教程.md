---
title: "docker使用教程"
layout: page
date: 2018-07-25 10:00
---

# 写在前面
linux的使用过程中经常需要涉及到编译，运行等过程。最麻烦的就是在不同的机器上重复相同的劳动，docker的存在让一切变得简单很多，下面介绍docker的一些基本知识和操作。


# 符号约定
- < >自定义内容

- [xxx] 可选内容

- [< xxx >] 自定义可选内容

# 启动和关闭docker服务

- 启动
```
service docker start
或
systemctl start docker
```
- 关闭
```
service docker stop
或
systemctl stop docker
```
# 基本操作
#### 搜索docker镜像
```
docker search [镜像名]
```
#### 拉取或者下载镜像
```
docker pull [NAME]
```

# 运行image实例container
对于Docker来说，image是静态的，类似于操作系统快照，而container则是动态的，是image的运行实例。
先使用```sudo docker images```查看pull下来的iamge。
如：
```
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
tensorflow/serving   latest-devel-gpu    e8667aaa087d        5 days ago          4.34GB
```
则可以通过下面两种方式创建一个守护态的Docker容器
```
sudo docker run -i -t [tensorflow/serving:latest-devel-gpu] /bin/bash
或
sudo docker run -i -t [e8667aaa087d]
```
具体参数可以网上搜索

这样就可以进入container了
```
root@f906aeaa80e7:
```
同时。我们可以在container所在的外部操作系统中运行```sudo docker ps```和```sudo docker ps -a```来分别查看运行中的container id和所有的包括未运行的container id。

```
CONTAINER ID        IMAGE                                 COMMAND             CREATED             STATUS                   PORTS                    NAMES
1a2b5c8e0f69        tensorflow/serving:latest-devel-gpu   "/bin/bash"         9 hours ago         Exited (1) 9 hours ago                            hardcore_rosalind
c820900be758        tensorflow/serving:latest-devel-gpu   "/bin/bash"         20 hours ago        Exited (0) 2 hours ago                            brave_agnesi
aad1b70763ab        tensorflow/serving:latest-devel-gpu   "/bin/bash"         20 hours ago        Created                                           condescending_jackson
f906aeaa80e7        tensorflow/serving:latest-devel-gpu   "/bin/bash"         20 hours ago        Up 2 hours               0.0.0.0:8500->8500/tcp   mystifying_sinoussi
```
# 启动和停止某个image的container
对于docker还是小白的我遇到这样一个问题，我pull了一个image到本地，然后运行这个image，这时候系统会生成一个contaner ID，我在contaner中安装了很多东西，比如vim，pip 之类的简单应用，并且编译了一些程序。完成之后直接退出。第二天使用的时候我还是运行了这个image，但是之前所有的配置全部没了。后来发现是自己错了，我每次运行的都是第一次pull下来的image，相当于每次启动的都是一个新的container，而我原来配置编译的那个container需要使用```sudo docker ps -a```就能看出来了。

- **启动某个container**

如果想要再次打开之前使用过的container，则可以运行：
```
sudo docker start [container_name]
或
sudo docker start [CONTAINER_ID]
```
- **重启某个container**
```
sudo docker restart [container_name]
或
sudo docker restart [CONTAINER_ID]
```
启动该container之后，使用```sudo docker attach container_name/container_id```进入该container。

- **进入Docker Container**
1、Docker提供了attach命令来进入Docker容器(不建议)
```
sudo docker attach [CONTAINER_ID]
```
2、使用ssh进入Docker容器(不建议使用)

3、使用nsenter进入Docker容器(建议)
[Looking to start a shell inside a Docker container?](https://github.com/jpetazzo/nsenter)

4、使用docker exec 进入Docker容器
使用docker提供的新的命令exec进入容器

```
sudo docker ps
sudo docker exec -it [CONTAINER_ID] /bin/bash
```

- **退出某个Container**
```
直接使用Ctrl +d 或者在container中运行exit
```

# docker常用命令
- **在Container和宿主机之间复制文件**
```
从主机复制到容器:
sudo docker cp host_path containerID:container_path
从容器复制到主机:
sudo docker cp containerID:container_path host_path
```
- **创建Docker镜像**
```
docker build -t fensme:v1 .
```
- 运行镜像
```
docker run fensme
```
- 运行镜像并进入
```
docker run  -i -t fensme  /bin/bash
```
- 登录镜像平台
```
docker login --username=bsspirit --email=bsspirit@163.com
```
- 增加镜像空间名
```
docker tag 8496b10e857a bsspirit/fensme:latest
```
- 提交镜像
```
docker push bsspirit/fensme
```
- 删除镜像
```
docker rmi <image id>
```
- 删除所有镜像
```
docker rmi $(docker images  -q)
```
- 进入镜像修改后，保存产生新镜像
```
docker commit $(container id前三位) ubuntu_sshd_gerry:14.04
```
- 停止所有的container 
```
docker  stop $(docker ps -a -q)
```
- 删除所有的contrainer
```
docker rm $(docker ps -a -q)
```
- 进入正在运行的contrainer
```
docker attach db3 
docker attach d48b21a7e439
```

- SSH启动
```
docker run -d -it -p 1000:22 vnpy:1.2 /usr/sbin/sshd -D
```
- 重启容器
```
sudo docker restart ac01d678fcae Restart a running container
```
- docker容器运行中添加端口映射
```
https://my.oschina.net/u/266ΩΩΩ752/blog/541433
```
- docker下安装vim 、telnet、ifconfig命令
```
# 同步 /etc/apt/sources.list 和 /etc/apt/sources.list.d 中列出的源的索引，这样才能获取到最新的软件包。
apt-get update
# 安装telnet
​apt-get install  telnet 
# 安装ifconfig
apt-get install  net-tools
# vim
apt-get install vim
```
# 通过容器提交镜像（docker commit）以及推送镜像（docker push)
[笔记](https://www.cnblogs.com/kevingrace/p/9599988.html)


# docker端口映射
## 容器的端口映射
```
run [-P][-p]
```
-P , -publish-all=true | false, 大写的P表示为容器暴露的所有的端口进行映射;

-p, -publish=[], 小写的p表示为容器指定的端口进行映射, 有四种形式:

- containerPort: 只指定容器的端口, 宿主机端口随机映射;

- hostPort:containerPort: 同时指定容器与宿主机端口一一映射;

- ip::containerPort: 指定ip和容器的端口;

- ip:hostPort:containerPort: 指定ip、宿主机端口以及容器端口.

例如:
```
docker run -p 80 -i -t ubuntu /bin/bash
docker run -p 8080:80 -i -t ubuntu /bin/bash
docker run -p 0.0.0.0::80 -i -t ubuntu /bin/bash
docker run -p 0.0.0.0:8080:80 -i -t ubuntu /bin/bash
```
#### docker 多端口映射多卷映射
如果一个参数的选项格式是[],比如
-H=[]host
-p=[]portdirection
这都意味着这个flag可以多次出现，所以此处可以多次指定端口映射规则。

```
docker run -d -p 80:80 -p 22:22
```
# Docker 挂载本地目录
docker 挂载目录跟端口映射方法类似, 都是需要在docker启动的过程中配置相应的参数.

挂载目录后镜像内就可以共享宿主机里面的文件
通过```run -v```参数指定挂载目录(格式: 宿主机目录:镜像内挂在目录), 如果宿主机目录不存在则自动创建

实例:
```
# 启动一个镜像,运行一个容器, 并设置挂在目录
sudo docker run -it -v /home/ubuntu/downloads/data:/data [IMAGE ID/ REPOSITORY]
```
此时从宿主机上/home/ubuntu/downloads/文件夹下多出来/data目录




## docker开启ssh服务
### 需要安装的软件
```
apt-get update
apt-get install vim
apt-get install openssh-server
apt-get net-tools
```


## docker 添加用户




# 参考文献
[如何进入、退出docker的container](https://blog.csdn.net/dongdong9223/article/details/52998375)

[Using TensorFlow Serving via Docker](https://github.com/tensorflow/serving/blob/master/tensorflow_serving/g3doc/docker.md)

[Docker学习之路（六）用commit命令创建镜像](https://segmentfault.com/a/1190000002567459)

[Docker容器进入的4种方式](https://www.cnblogs.com/xhyan/p/6593075.html)

[docker 启动，端口映射，挂载本地目录](https://www.cnblogs.com/YasinXiao/p/7736075.html)

[详解Docker 端口映射与容器互联](https://www.jb51.net/article/142459.htm)

[Docker 给运行中的容器设置端口映射的方法](https://www.jb51.net/article/127630.htm)

[docker容器如何优雅的终止详解](https://www.jb51.net/article/96617.htm)

[docker-image container 基本操作 -常用命令](https://www.cnblogs.com/xiadongqing/p/6144053.html)