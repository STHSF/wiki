---
title: "Tensorflow基础知识---ubuntu下安装tensotflow-gpu版本、安装cuda、cuddn"
layout: page
date: 2017-12-12 14:00
---

# 写在前面

# 一、N卡驱动安装
## 1、ubuntu自带

在System Settings -> Software&Update -> Additional Drivers 下，等待刷新完毕后，会出现 NVIDIA Corporation：Unknown，然后勾选第一个选项，然后点击更新。更新完成后重启电脑。

打开终端，输入nvidia-smi，就会出现显卡的相关信息。

## 2、nvidia官网下载对应显卡驱动安装


# 安装cuda

## 1、禁用自带的nouveau nvidia驱动

创建或更新blacklist-nouveau.conf
```
vi /etc/modprobe.d/blacklist-nouveau.conf
```

并在文件中添加如下内容
```
blacklist nouveau
options nouveau modeset=0
```

然后更新一下，重新生成 kernel initramfs
```
sudo update-initramfs -u
```
修改后需要重新启动系统，确认下nouveau是否已经被干掉了，```lsmod |grep nouveau```

## 2、重启系统，Ctrl + Alt + F1 进入命令行模式，执行，
```
$ sudo service lightdm stop      // 关闭桌面服务
```

## 3、安装.run文件
```
sudo sh cuda_8.0.44_linux_ubuntu_14.04.run --no-opengl-libs

运行之后会跳出readme文件，然后按住ctro + c 跳过。

然后会出现 Do you accept the previously read EULA 输入 accept，进入下一步。

INSTALL NVIDIA Accelerates Graphics Driver for Linux-x86_64 375.26 输入n，进入下一步；

Install the  CUDA 8.0 Toolkit? 输入y， 进入下一步；

Enter Tookit Location 点击enter，进入下一步；

Do you want to install a symbolic link at /usr/local/cuda 输入y，进入下一步；

Install the CUDA 8.0 Samples? 输入y， 进入下一步；

Enter CUDA Samples Location 点击enter， 进入下一步；

程序开始安装。。。

```
安装完成之后，会提示一个summary；大致内容如下。
Driver: Not Selectd
Toolkit: INstalled in /usr/local/cuda-8.0
Samples: Installed in /home/jerry, but missing recommended libraries

***注意***
这时候会有一个提示，CUDA Driver没有安装，根据提示，在.run文件后面添加-silent -driver。

```
sudo sh cuda_8.0.44_linux_ubuntu_14.04.run -silent -driver
```

安装之后，启动x-window
```
$ sudo service lightdm start     // 重启桌面服务
```
为了检查安装是否正确，从cuda的samples中选择样例进行测试。
```
cd /usr/local/cuda-7.5/samples/1_Utilities/deviceQuery
make
sudo ./deviceQuery
```
如果显示的是一些关于GPU的信息，则说明安装成功了。

## 配置环境变量
在CUDA安装完成之后，log日志中有提示需要声明环境变量，不然后面安装cudnn时会出现找不到.so文件。所以需要在/etc/profile中添加下面的内容。

```
PATH=/usr/local/cuda/bin:$PATH
export PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
export LD_LIBRARY_PATH
```
最后```source /etc/profile```即可。

# 安装cuddn

