---
title: "docker使用教程"
layout: page
date: 2018-07-25 10:00
---
[TOC]

# 写在前面
linux的使用过程中经常需要涉及到编译，运行等过程。最麻烦的就是在不同的机器上重复相同的劳动，docker的存在让一切变得简单很多，下面介绍docker的一些基本知识和操作。


# 符号约定
- < xxx >自定义内容

- [ xxx ] 可选内容

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
sudo docker run -i -t --privileged=true [tensorflow/serving:latest-devel-gpu] /bin/bash
或
sudo docker run -it --privileged=true [e8667aaa087d]
```
具体参数可以网上搜索, 此处必须添加--privileged=true使得容器真正获取主机硬件资源，包括GPU显卡资源.

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

如果想退出某个docker但是又不想停止docker运行,则可以使用```Ctrl + p + q```即可.

# Docker常用命令
docker的常用命令
```
# 创建Docker镜像
docker build -t fensme:v1

# 运行镜像
docker run fensme

# 运行镜像并进入
docker run  -i -t fensme  /bin/bash

# 登录镜像平台
docker login --username=bsspirit --email=bsspirit@163.com

# 增加镜像空间名
docker tag 8496b10e857a bsspirit/fensme:latest

# 提交镜像
docker push bsspirit/fensme

# 删除镜像
docker rmi <image id>

# 删除所有镜像
docker rmi $(docker images  -q)

# 进入镜像修改后，保存产生新镜像
docker commit $(container id前三位) ubuntu_sshd_gerry:14.04
就是将修改后的continer保存为image.

# 停止所有的container
docker  stop $(docker ps -a -q)
stop 后面跟 container id 则为停止该container

# 删除所有的contrainer
docker rm $(docker ps -a -q)

# 进入正在运行的contrainer
docker attach db3 
docker attach d48b21a7e439
attach 后面可以为container id 也可以是container name

# SSH启动
docker run -d -it -p 10022:22 vnpy:1.2 /usr/sbin/sshd -D
注意, /usr/sbin/sshd是在linux环境下使用的, windows环境可能不使用
上面的命令是将宿主机的10022端口和docker container的22端口做映射,并且在启动container的同时启动了ssh服务

# 重启容器
sudo docker restart ac01d678fcae
restart 后面可以跟container id 或者container name

# docker容器运行中添加端口映射
https://my.oschina.net/u/266ΩΩΩ752/blog/541433
```

#### Docker下安装vim 、telnet、ifconfig命令
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

#### 通过容器提交镜像（docker commit）以及推送镜像（docker push)

[笔记](https://www.cnblogs.com/kevingrace/p/9599988.html)


# docker端口映射
## 创建容器时指定映射的端口
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
```bash
$ docker run -p 80 -i -t ubuntu /bin/bash
$ docker run -p 8080:80 -i -t ubuntu /bin/bash
$ docker run -p 0.0.0.0::80 -i -t ubuntu /bin/bash
$ docker run -p 0.0.0.0:8080:80 -i -t ubuntu /bin/bash
```
另外在容器上也是可以看到对应的端口是否被docker容器监听
```bash
$ netstat -tunlp

Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      778/sshd
tcp6       0      0 :::22                   :::*                    LISTEN      778/sshd
```

### 宿主机添加端口放行
如果宿主机没有开启 ip 转发功能，会导致外部网络访问宿主机对应端口时没能转发到 Docker Container 所对应的端口上.

如果存在这种情况,则说明宿主机的这些端口对外是关闭的,则需要我们手动去打开.
```bash
$ iptables -A INPUT -p tcp --dport [8080] -j ACCEPT
$ service iptables save
```

### docker 多端口映射多卷映射
如果一个参数的选项格式是[],比如
-H=[]host
-p=[]portdirection
这都意味着这个flag可以多次出现，所以此处可以多次指定端口映射规则。

```bash
$ docker run -d -p 80:80 -p 22:22 -it [CONTAINERID]
```


# Docker 文件传输系统
##  Docker 挂载本地目录

docker 挂载目录跟端口映射方法类似, 都是需要在docker启动的过程中配置相应的参数.

挂载目录后镜像内就可以共享宿主机里面的文件
通过```run -v```参数指定挂载目录(格式: 宿主机目录:镜像内挂在目录), 如果宿主机目录不存在则自动创建

```
-v {宿主机路径}:{docker container路径}
```
实例:
```
# 启动一个镜像,运行一个容器, 并设置挂在目录
sudo docker run -it -v /home/ubuntu/downloads/data:/data [IMAGE ID/ REPOSITORY]
```
此时从宿主机上/home/ubuntu/downloads/文件夹下多出来/data目录

并且,在container中操作/data下面的内容时,宿主机上对应目录下也会有相应的操作.

***注意***
如果挂载的是windows下面的文件目录, 则需要设置Docker for windows Shared Drivers, 具体设置过程可以参考[docker 官网](https://blogs.msdn.microsoft.com/stevelasker/2016/06/14/configuring-docker-for-windows-volumes/), 设置完成之后挂在方式不变.

错误提示如下:
```shell
>>> docker run -p 10080:80 -p 10022:22 -p 18080:8080 -p 18000:8000 -it -v C:\workshop:/home/jerry/workshop/venv 3cd92bc30026

>>>
docker: Error response from daemon: Drive has not been shared.
See 'docker run --help'.
```

## Docker 和宿主机中相互传递文件
### 根据docker中的container的名字传送
```bash
# Container -> 宿主机
$ docker cp [OPTIONS] <CONTAINER:SRC_PATH> <DEST_PATH>

# 宿主机 -> Container
$ docker cp [OPTIONS] <SRC_PATH> <CONTAINER:DEST_PATH>
```
示例
将宿主机中 /File_kk目录 拷贝到Container 3000202323dcf 的/home/work目录下.
```bash
$ docker cp File_kk 3000202323dcf:/home/cloude
```
将Container 3000202323dcf 的/home/work/File_kk目录 拷贝到宿主机中 /work目录下
```bash
$ docker cp 3000202323dcf:/home/cloude/File_kk /work
```
### 通过scp传送
如果Container开启ssh服务,则可以通过指定的ssh端口向Container中传送文件,开启ssh服务就可以类似服务器之间传送文件一样.
```bash
$ scp -P <port> <SRC_PATH> <USER_NAME>@<IP>:<DEST_PATH>

# 注,传输文件和文件目录参照scp规则
```

示例
假设Container开启了ssh服务,并且与宿主机的端口映射为10022, 现在将jerry.zip复制到Container的/home/jerry/workshop/work
```bash
$ scp -P 10022 jerry.zip jerry@192.168.79.1:/home/jerry/workshop/work
```


## Docker开启ssh服务
### 修改root密码,安装openssh服务
```bash
$ apt-get update
$ apt-get install vim
$ apt-get install openssh-server
$ apt-get net-tools
```
### 修改配置文件
安装成功之后,修改容器的配置文件,使得可以直接使用root登陆
```bash
$ vim  /etc/ssh/sshd_config
```
- 在配置文件中找到```#PermitRootLogin prohibit-password```,修改成```PermitRootLogin yes```
- 将```UsePAM yes```, 修改成```UsePAM no```
```bash
$ vi /etc/ssh/sshd_config 
$ PermitRootLogin yes  #允许root用户ssh登录
$ UsePAM no            ##禁用PAM
```
**注, 如果容器内配置文件不修改,容器可能会拒绝访问,卡在lastlogin提示, 同时还要保证宿主机开启了需要监听的端口**
### 启动ssh服务
```bash
$ service ssh start
```
我们也可以在启动docker的时候同时启动ssh
```bash
$ docker run -d -it -p 10022:22 <IMAGE_NAME> /usr/sbin/sshd -D
```
### 登录测试
在宿主机或者其他机器上输入对应的username和ip地址,测试是否可以连接
```bash
$ ssh -p 10022 <username>@<ip>
```
## Docker镜像跨服务器迁移
Docker的备份方式有export和save两种。
### 1、save
1)、镜像保存

登陆到已经部署好镜像的服务器上面，执行以下命令进行导出
```bash
$ docker save <IMAGE_ID前三位> > <IMAGE_NAME>.tar
```
or
```bash
$ docker save -o ./<FILE NAME>.tar <EPOSITORY:TAG>
```
2)、镜像导入

将刚才导出的镜像上传到你要导入的那台服务器上(使用scp), 执行以下命令镜像导入
```bash
$ docker load < <IMAGE_NAME>.tar
```
使用```docker images```查看你会发现load的镜像的TREPOSITORY和TAG为空, 可以使用下面的命令
```bash
$ docker tag <IMAGE_ID前三位> <REPOSITORY>:<TAG>
```
对新load的image重新命名

### 2、export
1) 导出容器
```bash
$ docker ps -a
$ docker export <CONTAINER ID> > <FILE NMAE>.tar
```
2) 导入到指定的服务器

同样需要将刚才的导出的容器备份上传到目标服务器上，执行下面的命令
```bash
$ cat <FILE NMAE>.tar |docker import - <REPOSITORY>:<TAG>
```
***注意：运行导入的镜像的时候必须带command(/bin/bash)，否则启动报如下错误***

### Dockerhub使用



# docker 添加用户

# docker 三剑客
## docker machine
## docker swarm
## docker compose
[Get started with Docker Compose](https://docs.docker.com/compose/gettingstarted/)

[docker-compose运行mysql、redis](https://www.jianshu.com/p/bf802ea2d7cf)

[Docker —— 从入门到实践](https://yeasy.gitbooks.io/docker_practice/content/)

# centos下安装docker
在使用```yum -y install docker```和```yum -y install docker-io````失败之后使用

```bash
yum install https://get.docker.com/rpm/1.7.1/centos-6/RPMS/x86_64/docker-engine-1.7.1-1.el6.x86_64.rpm
```
安装成功, ```service docker start```启动dokcer即可.

### 安装docker-ce

#### 方法 1
安装最新版
1) 安装必要的一些系统工具
```bash
$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```
2) 添加软件源信息
```bash
$ sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

3) 更新并安装 Docker-CE
```bash
sudo yum makecache fast
sudo yum -y install docker-ce
```
出现的问题,截图如下
```bash
Public key for docker-ce-cli-18.09.7-3.el7.x86_64.rpm is not installed
(1/3): docker-ce-cli-18.09.7-3.el7.x86_64.rpm                                                       |  14 MB  00:00:09
(2/3): docker-ce-18.09.7-3.el7.x86_64.rpm                                                           |  19 MB  00:00:02
containerd.io-1.2.6-3.3.el7.x8 FAILED                                          ========= ] 1.9 kB/s |  57 MB  00:10:17 ETA
https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm: [Errno 12] Timeout on https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm: (28, 'Operation too slow. Less than 1000 bytes/sec transferred the last 30 seconds')
Trying other mirror.
containerd.io-1.2.6-3.3.el7.x8 FAILED
https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm: [Errno 14] curl#6 - "Could not resolve host: mirrors.aliyun.com; Unknown error"
Trying other mirror.


Error downloading packages:
  containerd.io-1.2.6-3.3.el7.x86_64: [Errno 256] No more mirrors to try.
```
网上的解决方法:```yum clean all```后使用```yun install docker-ce```, 未成功, 错误截图
```bash
Error downloading packages:
  2:container-selinux-2.99-1.el7_6.noarch: [Errno 256] No more mirrors to try.
  3:docker-ce-18.09.7-3.el7.x86_64: [Errno 256] No more mirrors to try.
  containerd.io-1.2.6-3.3.el7.x86_64: [Errno 256] No more mirrors to try.
  1:docker-ce-cli-18.09.7-3.el7.x86_64: [Errno 256] No more mirrors to try.
```

// 4. 开启Docker服务(未到这一步)
sudo service docker start

#### 方法2
- SET UP THE REPOSITORY
  
Install required packages. yum-utils provides the yum-config-manager utility, and device-mapper-persistent-data and lvm2 are required by the devicemapper storage driver.
```bash
$ sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```
Use the following command to set up the stable repository.
```bash
$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```
Optional: Enable the nightly or test repositories.

These repositories are included in the docker.repo file above but are disabled by default. You can enable them alongside the stable repository. The following command enables the nightly repository.
```bash
$ sudo yum-config-manager --enable docker-ce-nightly
```
To enable the test channel, run the following command:
```bash
$ sudo yum-config-manager --enable docker-ce-test
```
You can disable the nightly or test repository by running the yum-config-manager command with the --disable flag. To re-enable it, use the --enable flag. The following command disables the nightly repository.
```bash
$ sudo yum-config-manager --disable docker-ce-nightly
```
Learn about nightly and test channels.

后面运行的过程中,系统提示会出现下面的提示

```bash
$ sudo yum-config-manager --save --setopt=docker-ce-nightly.skip_if_unavailable=true
```

- INSTALL DOCKER CE
  
Install the latest version of Docker CE and containerd, or go to the next step to install a specific version:
```bash
$ sudo yum install docker-ce docker-ce-cli containerd.io
```
***目前还是没有安装成功***
失败截图:
```bash
Error downloading packages:
  1:docker-ce-cli-19.03.0-2.3.rc3.el7.x86_64: [Errno 256] No more mirrors to try.
  containerd.io-1.2.6-3.3.el7.x86_64: [Errno 256] No more mirrors to try.
```
目前能找到的原因应该是网络的原因, yum安装失败的大部分原因都是网络问题.

第二天早上来运行安装命令, 尝试了两遍之后, 运行成功

第一遍:
```bash
[root@localhost psdz]$ sudo yum install docker-ce docker-ce-cli containerd.io
Loaded plugins: fastestmirror, langpacks
Repository base is listed more than once in the configuration
Repository updates is listed more than once in the configuration
Repository extras is listed more than once in the configuration
Repository centosplus is listed more than once in the configuration
Existing lock /var/run/yum.pid: another copy is running as pid 40267.
Another app is currently holding the yum lock; waiting for it to exit...
  The other application is: PackageKit
    Memory :  44 M RSS (386 MB VSZ)
    Started: Thu Jul 18 17:44:11 2019 - 00:01 ago
    State  : Sleeping, pid: 40267
Another app is currently holding the yum lock; waiting for it to exit...
  The other application is: PackageKit
    Memory :  44 M RSS (386 MB VSZ)
    Started: Thu Jul 18 17:44:11 2019 - 00:03 ago
    State  : Sleeping, pid: 40267
Another app is currently holding the yum lock; waiting for it to exit...
  The other application is: PackageKit
    Memory :  44 M RSS (386 MB VSZ)
    Started: Thu Jul 18 17:44:11 2019 - 00:05 ago
    State  : Sleeping, pid: 40267
Loading mirror speeds from cached hostfile
http://mirrors.163.com/centos/7/os/x86_64/repodata/repomd.xml: [Errno 14] curl#6 - "Could not resolve host: mirrors.163.com; Unknown error"
Trying other mirror.
https://download.docker.com/linux/centos/7/x86_64/stable/repodata/repomd.xml: [Errno 14] curl#6 - "Could not resolve host:download.docker.com; Unknown error"
Trying other mirror.
docker-ce-test                                                                                      | 3.5 kB  00:00:00
extras                                                                                              | 3.4 kB  00:00:00
libnvidia-container/x86_64/signature                                                                |  488 B  00:00:00
libnvidia-container/x86_64/signature                                                                | 2.0 kB  00:00:00 !!!
nvidia-container-runtime/x86_64/signature                                                           |  488 B  00:00:00
nvidia-container-runtime/x86_64/signature                                                           | 2.0 kB  00:00:00 !!!
nvidia-docker/x86_64/signature                                                                      |  488 B  00:00:00
nvidia-docker/x86_64/signature                                                                      | 2.0 kB  00:00:00 !!!
updates                                                                                             | 3.4 kB  00:00:00
Resolving Dependencies
--> Running transaction check
---> Package containerd.io.x86_64 0:1.2.6-3.3.el7 will be installed
--> Processing Dependency: container-selinux >= 2:2.74 for package: containerd.io-1.2.6-3.3.el7.x86_64
---> Package docker-ce.x86_64 3:19.03.0-2.3.rc3.el7 will be installed
---> Package docker-ce-cli.x86_64 1:19.03.0-2.3.rc3.el7 will be installed
--> Running transaction check
---> Package container-selinux.noarch 2:2.99-1.el7_6 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===========================================================================================================================
 Package                        Arch                Version                            Repository                     Size
===========================================================================================================================
Installing:
 containerd.io                  x86_64              1.2.6-3.3.el7                      docker-ce-stable               26 M
 docker-ce                      x86_64              3:19.03.0-2.3.rc3.el7              docker-ce-test                 24 M
 docker-ce-cli                  x86_64              1:19.03.0-2.3.rc3.el7              docker-ce-test                 39 M
Installing for dependencies:
 container-selinux              noarch              2:2.99-1.el7_6                     extras                         39 k

Transaction Summary
===========================================================================================================================
Install  3 Packages (+1 Dependent package)

Total size: 90 M
Total download size: 39 M
Installed size: 368 M
Is this ok [y/d/N]: y
Downloading packages:
No Presto metadata available for docker-ce-test
docker-ce-cli-19.03.0-2.3.rc3. FAILED                                                    ]  478 B/s |  28 MB  06:47:55 ETA
https://download.docker.com/linux/centos/7/x86_64/test/Packages/docker-ce-cli-19.03.0-2.3.rc3.el7.x86_64.rpm: [Errno 12] Timeout on https://download.docker.com/linux/centos/7/x86_64/test/Packages/docker-ce-cli-19.03.0-2.3.rc3.el7.x86_64.rpm: (28, 'Operation too slow. Less than 1000 bytes/sec transferred the last 30 seconds')
Trying other mirror.
warning: /var/cache/yum/x86_64/7/docker-ce-test/packages/docker-ce-cli-19.03.0-2.3.rc3.el7.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Public key for docker-ce-cli-19.03.0-2.3.rc3.el7.x86_64.rpm is not installed
docker-ce-cli-19.03.0-2.3.rc3.el7.x86_64.rpm                                                        |  39 MB  00:00:12
Retrieving key from https://download.docker.com/linux/centos/gpg


GPG key retrieval failed: [Errno 14] curl#7 - "Failed to connect to 2600:9000:2016:a800:3:db06:4200:93a1: Network is unreachable"
```

第二遍:
```bash
[root@localhost psdz]$ sudo yum install docker-ce docker-ce-cli containerd.io
Loaded plugins: fastestmirror, langpacks
Repository base is listed more than once in the configuration
Repository updates is listed more than once in the configuration
Repository extras is listed more than once in the configuration
Repository centosplus is listed more than once in the configuration
Loading mirror speeds from cached hostfile
base                                                                                                | 3.6 kB  00:00:00
docker-ce-stable                                                                                    | 3.5 kB  00:00:00
Resolving Dependencies
--> Running transaction check
---> Package containerd.io.x86_64 0:1.2.6-3.3.el7 will be installed
--> Processing Dependency: container-selinux >= 2:2.74 for package: containerd.io-1.2.6-3.3.el7.x86_64
---> Package docker-ce.x86_64 3:19.03.0-2.3.rc3.el7 will be installed
---> Package docker-ce-cli.x86_64 1:19.03.0-2.3.rc3.el7 will be installed
--> Running transaction check
---> Package container-selinux.noarch 2:2.99-1.el7_6 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===========================================================================================================================
 Package                        Arch                Version                            Repository                     Size
===========================================================================================================================
Installing:
 containerd.io                  x86_64              1.2.6-3.3.el7                      docker-ce-stable               26 M
 docker-ce                      x86_64              3:19.03.0-2.3.rc3.el7              docker-ce-test                 24 M
 docker-ce-cli                  x86_64              1:19.03.0-2.3.rc3.el7              docker-ce-test                 39 M
Installing for dependencies:
 container-selinux              noarch              2:2.99-1.el7_6                     extras                         39 k

Transaction Summary
===========================================================================================================================
Install  3 Packages (+1 Dependent package)

Total size: 90 M
Installed size: 368 M
Is this ok [y/d/N]: y
Is this ok [y/d/N]: y
Downloading packages:
warning: /var/cache/yum/x86_64/7/docker-ce-test/packages/docker-ce-cli-19.03.0-2.3.rc3.el7.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Retrieving key from https://download.docker.com/linux/centos/gpg
Importing GPG key 0x621E9F35:
 Userid     : "Docker Release (CE rpm) <docker@docker.com>"
 Fingerprint: 060a 61c5 1b55 8a7f 742b 77aa c52f eb6b 621e 9f35
 From       : https://download.docker.com/linux/centos/gpg
Is this ok [y/N]: y
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : 2:container-selinux-2.99-1.el7_6.noarch       1/4
  Installing : containerd.io-1.2.6-3.3.el7.x86_64            2/4
  Installing : 1:docker-ce-cli-19.03.0-2.3.rc3.el7.x86_64    3/4
  Installing : 3:docker-ce-19.03.0-2.3.rc3.el7.x86_64        4/4
  Verifying  : 1:docker-ce-cli-19.03.0-2.3.rc3.el7.x86_64    1/4
  Verifying  : 3:docker-ce-19.03.0-2.3.rc3.el7.x86_64        2/4
  Verifying  : containerd.io-1.2.6-3.3.el7.x86_64            3/4
  Verifying  : 2:container-selinux-2.99-1.el7_6.noarch       4/4

Installed:
  containerd.io.x86_64 0:1.2.6-3.3.el7  docker-ce.x86_64 3:19.03.0-2.3.rc3.el7  docker-ce-cli.x86_64 1:19.03.0-2.3.rc3.el7

Dependency Installed:
  container-selinux.noarch 2:2.99-1.el7_6

Complete!
```

# centos下安装nvidia-docker2
```bash
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
$ docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo yum remove nvidia-docker

# Add the package repositories
$ distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
$ curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | \
  sudo tee /etc/yum.repos.d/nvidia-docker.repo

# Install nvidia-docker2 and reload the Docker daemon configuration
$ sudo yum install -y nvidia-docker2
$ sudo pkill -SIGHUP dockerd
```
安装过程中, 系统会出现以下提示
```bash
 One of the configured repositories failed (nvidia-container-runtime),
 and yum doesn't have enough cached data to continue. At this point the only
 safe thing yum can do is fail. There are a few ways to work "fix" this:

     1. Contact the upstream for the repository and get them to fix the problem.

     2. Reconfigure the baseurl/etc. for the repository, to point to a working
        upstream. This is most often useful if you are using a newer
        distribution release than is supported by the repository (and the
        packages for the previous distribution release still work).

     3. Run the command with the repository temporarily disabled
            yum --disablerepo=nvidia-container-runtime ...

     4. Disable the repository permanently, so yum won't use it by default. Yum
        will then just ignore the repository until you permanently enable it
        again or use --enablerepo for temporary usage:

            yum-config-manager --disable nvidia-container-runtime
        or
            subscription-manager repos --disable=nvidia-container-runtime

     5. Configure the failing repository to be skipped, if it is unavailable.
        Note that yum will try to contact the repo. when it runs most commands,
        so will have to try and fail each time (and thus. yum will be be much
        slower). If it is a very temporary problem though, this is often a nice
        compromise:

            yum-config-manager --save --setopt=nvidia-container-runtime.skip_if_unavailable=true
```
```bash
# Test nvidia-smi with the latest official CUDA image
$ docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```


# 参考文献
[如何进入、退出docker的container](https://blog.csdn.net/dongdong9223/article/details/52998375)

[Using TensorFlow Serving via Docker](https://github.com/tensorflow/serving/blob/master/tensorflow_serving/g3doc/docker.md)

[Docker学习之路（六）用commit命令创建镜像](https://segmentfault.com/a/1190000002567459)

[Docker容器进入的4种方式](https://www.cnblogs.com/xhyan/p/6593075.html)

[docker 启动，端口映射，挂载本地目录](https://www.cnblogs.com/YasinXiao/p/7736075.html)

[详解Docker 端口映射与容器互联](https://www.jb51.net/article/142459.htm)

[Docker 给运行中的容器设置端口映射的方法](https://www.jb51.net/article/127630.htm)

[Docker容器内部端口映射到外部宿主机端口的方法小结](https://www.cnblogs.com/kevingrace/p/9453987.html)

[docker容器如何优雅的终止详解](https://www.jb51.net/article/96617.htm)

[docker-image container 基本操作 -常用命令](https://www.cnblogs.com/xiadongqing/p/6144053.html)

[Docker实战-为镜像添加SSH服务](https://www.cnblogs.com/jie-fang/p/7928406.html)

[Linux系统安装docker并用ssh登录docker容器](https://blog.csdn.net/hpf247/article/details/80078240)

[Docker 容器开启ssh登录](https://blog.csdn.net/qq_39626154/article/details/82856865)

[NVIDIA Container Runtime for Docker](https://github.com/NVIDIA/nvidia-docker)