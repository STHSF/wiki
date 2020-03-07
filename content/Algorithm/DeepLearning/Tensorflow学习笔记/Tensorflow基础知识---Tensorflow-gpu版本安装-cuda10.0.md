---
title: "Tensorflow基础知识---Ubuntu16.04下安装安装CUDA10.0、cuDNN7.4和tensotflow-gpu 1.8.0以上的版本流程和问题总结"
layout: page
date: 2018-06-01 03:00
---

# 写在前面
Tensorflow版本更新太快了，最新版已经更新到1.8.0了，Tensorflow在1.7的时候就已经对cuda和cudnn的版本有所要求，所以下面介绍安装cuda9.0和cudnn9.0的安装。台式机的配置如下：
```
System：Ubuntu 16.04 LTS
CPU: Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz
MemTotal: 16295024 kB
GPU: GeForce GTX 1080
```
**注意, cuda10.0安装部分来自cuda9.0安装版本, 所以里面会有不能错误**

# 一、N卡驱动安装
## Nvidia官网下载对应显卡驱动安装
### 1、驱动下载
去[nvidia官网](http://www.nvidia.cn/Download/index.aspx?lang=cn)下载对应的驱动，根据自己的显卡型号和操作系统手动查找对应的驱动文件，我的显卡型号是GTX1080，所以下载的驱动文件名为**NVIDIA-Linux-x86_64-390.48.run**。如下图所示。
<center><img src="/wiki/static/images/tensorgpu/nvidia_driver.jpg" alt="nvidia-driver"/></center>

### 2、先卸载原有N卡驱动
```
#for case1: original driver installed by apt-get:
sudo apt-get remove --purge nvidia*

#for case2: original driver installed by runfile:
sudo chmod +x *.run
sudo ./NVIDIA-Linux-x86_64-384.59.run --uninstall
```

如果原驱动是用apt-get安装的，就用第1种方法卸载。 
如果原驱动是用runfile安装的，就用–uninstall命令卸载。其实，用runfile安装的时候也会卸载掉之前的驱动，所以不手动卸载亦可。

### 3、禁用nouveau驱动

创建或更新blacklist-nouveau.conf，有的教程中会更新blacklist.conf

```
sudo vi /etc/modprobe.d/blacklist-nouveau.conf
or
sudo vi /etc/modprobe.d/blacklist.conf
```
在文本最后添加：（禁用nouveau第三方驱动，之后也不需要改回来）
```
blacklist nouveau
options nouveau modeset=0
```
然后执行：```sudo update-initramfs -u```, 重新生成 kernel initramfs

重启后，执行：lsmod | grep nouveau。如果没有屏幕输出，说明禁用nouveau成功。

### 4、禁用X-Window服务
```
sudo service lightdm stop #这会关闭图形界面，但不用紧张
```
按Ctrl-Alt+F1进入命令行界面，输入用户名和密码登录即可。

**小提示**：在命令行输入：sudo service lightdm start ，然后按Ctrl-Alt+F7即可恢复到图形界面。
### 5、命令行安装驱动
```
#给驱动run文件赋予执行权限：
sudo chmod +x NVIDIA-Linux-x86_64-390.48.run
#后面的参数非常重要，不可省略：
sudo ./NVIDIA-Linux-x86_64-390.48.run –no-opengl-files
```
- –no-x-check：表示安装驱动时不检查X服务，非必需。
- –no-nouveau-check：表示安装驱动时不检查nouveau，非必需。
- -Z, --disable-nouveau：禁用nouveau。此参数非必需，因为之前已经手动禁用了nouveau。
- -A：查看更多高级选项。

必选参数解释：因为NVIDIA的驱动默认会安装OpenGL，而Ubuntu的内核本身也有OpenGL、且与GUI显示息息相关，一旦NVIDIA的驱动覆写了OpenGL，在GUI需要动态链接OpenGL库的时候就引起问题。之后，按照提示安装，成功后重启即可。 
如果提示安装失败，不要急着重启电脑，重复以上步骤，多安装几次即可。

**PS: Ubuntu系统会自动更新linux内核，服务器重启之后会出现nvidia Driver找不到的情况，重新安装驱动之后问题解决。所以建议关闭Linux内核自动更新。**
**UPDATE 20190510**ubuntu系统更新或者软件更新后,可能可能nvidia驱动会丢失,[使用Nvidia-smi显示不了显卡信息] ,我在碰到这个问题之后,直接是选择将显卡驱动重装一遍, 按照上面的方式重装之后显卡信息就可以显示了.驱动重装之后最好也在检查一下cuda和cudnn有没有问题.

### 6、Driver测试：
```
nvidia-smi # 若列出GPU的信息列表，表示驱动安装成功
nvidia-settings # 若弹出设置对话框，亦表示驱动安装成功(该命令只能在GUI下才能使用，关闭图形界面是无法弹出什么对话框的)
```

# 二、安装cuda

## 1、检查自带的nouveau nvidia驱动是否禁用。
如果安装cuda和安装显卡驱动没有同时进行，则需要检查这一步，同样安装cuda和显卡驱动都需要禁用nouveau驱动。

## 2、```Ctrl + Alt + F1``` 进入命令行模式，执行，
```
$ sudo service lightdm stop      // 关闭桌面服务
```
在安装CUDA的过程中必须得关闭桌面服务。

当然，你也可以在终端中执行关闭桌面服务操作，然后使用 ```Ctrl + Alt + F1``` 登陆你的账号。我在安装的过程中是先关闭桌面服务然后使用```Ctrl + Alt + F1```进入终端然后重新登陆账号密码的。

**注，在安装nvidia显卡驱动和cuda的时候都需要关闭桌面服务，或者可以在安装完显卡驱动之后不恢复图形界面，直接安装cuda。**

## 3、安装CUDA.run文件
我安装的是CUDA10.0的版本，到[nvidia开发者社区](https://developer.nvidia.com/cuda-10.0-download-archive?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1604&target_type=runfilelocal)根据选项挑选对应的安装版本，如下图所示。
<center><img src="/wiki/static/images/tensorgpu/CUDA Toolkit 10.0.png" alt="cuda-10.0"/></center>
本文下载的cuda.run文件版本为: **cuda_10.0.130_410.48_linux.run**
```
sudo sh cuda_10.0.130_410.48_linux.run --no-opengl-libs
```
在.run文件后面添加--no-opengl-libs的详解见[Ubuntu 14.04 安装 CUDA 问题及解决](https://www.cnblogs.com/gaowengang/p/6068788.html)，安装完成后需要将opengl的相关lib重新安装一下。

运行之后会跳出readme文件，然后按住```Ctrl + C```跳过。然后会依次出现以下提示：
```
Do you accept the previously read EULA，  输入 accept，进入下一步。
INSTALL NVIDIA Accelerates Graphics Driver for Linux-x86_64 375.26，  输入n，进入下一步；
Install the  CUDA 9.0 Toolkit?，  输入y， 进入下一步；
Enter Tookit Location 点击enter， 进入下一步；
Do you want to install a symbolic link at /usr/local/cuda，  输入y，进入下一步；
Install the CUDA 9.0 Samples?  输入y， 进入下一步；
Enter CUDA Samples Location 点击enter， 进入下一步；
程序开始安装。。。
```
更详细的提示见[Ubuntu16.04 下安装GPU版TensorFlow（包括Cuda和Cudnn）](https://segmentfault.com/a/1190000008234390)

安装完成之后，会提示一个summary；大致内容如下。
```
Driver: Not Selectd
Toolkit: INstalled in /usr/local/cuda-9.0
Samples: Installed in /home/jerry, but missing recommended libraries
```

***注意***
这时候会有一个提示，类似于下图，fail的原因是CUDA Driver没有安装。也有人说是因为双显卡(独立显卡和集成显卡)的原因。
<center><img src="/wiki/static/images/tensorgpu/devicequeryerror.png" alt="devicequeryerror"/></center>
程序下面又一个warning：
```
***WARNING: Incomplete installation! This installation did not install the CUDA Driver. A driver of version at least 361.00 is required for CUDA 8.0 functionality to work.
To install the driver using this installer, run the following command, replacing <CudaInstaller> with the name of this run file:
    sudo <CudaInstaller>.run -silent -driver
```

根据warning提示，在.run文件后面添加-silent -driver，有提示的图片忘记保存了。以后遇到在加上。
```
sudo sh cuda_9.0.176_384.81_linux.run -silent -driver
```

安装完成之后，启动桌面
```
$ sudo service lightdm start     // 重启桌面服务
```

为了检查安装是否正确，从cuda的samples中选择样例进行测试。
```
cd /usr/local/cuda-10.0/samples/1_Utilities/deviceQuery
sudo make clean && make
sudo ./deviceQuery
```
**注意，我在升级tensorflow至1.7后，此时cuda需要升级到cuda9.0,在安装cuda9.0的过程中，Driver显示的是Not Selectd，但是使用```sudo <CudaInstaller>.run -silent -driver```的方式并没有能够安装成功。但是我在使用samples中的样例测试也是可以的，没有出问题。所以这边Driver有没有select好像没有什么区别。对后面安装cudnn和tensorflow-gpu都没有什么影响。后面没有出现问题，所以也就没有去解决。(更新时间4月18日)**

**附**[CUDA官方安装教程](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)

如果显示的是一些关于GPU的信息，则说明安装成功了，详细信息见下图。
<center><img src="/wiki/static/images/tensorgpu/devicequery9.0.png" alt="devicequery"/></center>


## CUDA配置环境变量
在CUDA安装完成之后，log日志中有提示需要声明环境变量，不然后面安装cudnn时会出现找不到.so文件。所以需要在/etc/profile(*最好在~/.bashrc中添加*)中添加下面的内容。

```
PATH=/usr/local/cuda/bin:$PATH
export PATH
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
export LD_LIBRARY_PATH
```
最后```source /etc/profile```即可。

# 三、安装cudnn

## 1、cudnn 下载
cudnn的下载需要注册之后才能下载。

在CUDA安装好之后，CUDNN安装相对比较容易，根据官网教程，首先从官网上下载四个文件。如下图所示：
<center><img src="/wiki/static/images/tensorgpu/cudnndownload.png" alt="cudnn"/></center>
**上面的图片是后面更新文档的时候添加上的，跟我下面的安装列表有所区别，我之后在官网上没有找到对应的版本。但是直接在搜索框中输入下面的文件名是可以搜到的。**
```
cudnn-9.0-linux-x64-v7.1.tar   # the cuDNN package

libcudnn7_7.1.3.16-1+cuda9.0_amd64-2.deb   # runtime library

libcudnn7-dev_7.1.3.16-1+cuda9.0_amd64-2.deb   # developer library

libcudnn7-doc_7.1.3.16-1+cuda9.0_amd64.deb   # the code samples and the cuDNN Library User Guide 
```
***注意***
在安装cudnn的时候要特别注意tensorflow目前支持的cudnn版本，我这边直接下载的是最新的，后面在安装完tensorflow-gpu 1.4.1之后调用cudnn时就出现了错误，错误提示为ImportError: libcudnn.so.6: cannot open shared object file: No such file or directory。
我的解决方法是从官网上直接下载cudnn.6.0版本的，至于软链接等方式我试过了没有成功，后面有详细介绍，也可能是我添加环境变量错误导致。

根据对应的系统和cuda版本下载，我的系统是ubuntu16.04，cuda版本为9.0.最好再注意下tensorflow支持的cudnn版本，然后需要注意的是cuda的安装路径，如果在安装cuda使用的默认路径/usr/local/cuda/，则不需要修改。

在存放四个文件的下载目录下。
```
# 解压 cuDNN package.
$ tar -xzvf cudnn-9.0-linux-x64-v7.1.tgz
# 将下面的文件复制到 CUDA Toolkit 文件目录下。
$ sudo cp cuda/include/cudnn.h /usr/local/cuda/include
$ sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
$ sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
# 安装 runtime library,
sudo dpkg -i libcudnn7_7.1.3.16-1+cuda9.0_amd64-2.deb
# 安装 developer library,
sudo dpkg -i libcudnn7-dev_7.1.3.16-1+cuda9.0_amd64-2.deb
# 安装 code samples and the cuDNN Library User Guide
sudo dpkg -i libcudnn7-doc_7.1.3.16-1+cuda9.0_amd64.deb
```
**附** [cuDNN官方的安装和验证教程](https://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html#install-linux)

## 验证cudnn是否安装正确
```
1. 将某一个 cuDNN 样例复制到某一可读写文件目录下
$ cp -r /usr/src/cudnn_samples_v7/ $HOME
2. 进入该文件目录， 本文选择的是mnistCUDNN测试
$ cd $HOME/cudnn_samples_v7/mnistCUDNN
3. 编译 mnistCUDNN 样例.
$ make clean && make
4. 运行 mnistCUDNN 样例.
$ ./mnistCUDNN
5. 如果安装成功，程序的最后则会显示
Test passed!
```
详细运行结果如下图所示：
<center><img src="/wiki/static/images/tensorgpu/mnistdnn.png" alt="mnist"/></center>

##### **版本更新**
**UPDATE20190510**
升级tensorflow之后(tensorflow-gpu 1.13)更新版本, 对应的cuda和cudnn

|NVIDIA driver|CUDA|CUDNN| 
|:---:|:---:|:---:|
|418.74| 10.0 |7.4.2|

### 详细版本
### NVIDIA Driver
- NVIDIA-Linux-x86_64-418.74.run 

[下载地址](http://www.nvidia.cn/Download/index.aspx?lang=cn)
### CUDA
- cuda_10.0.130_410.48_linux.run

[下载地址](https://developer.nvidia.com/cuda-10.0-download-archive)
### CUDNN
- cudnn-10.0-linux-x64-v7.4.2.24.tgz

- libcudnn7_7.4.2.24-1+cuda10.0_amd64.deb

- libcudnn7-dev_7.4.2.24-1+cuda10.0_amd64.deb

- libcudnn7-doc_7.4.2.24-1+cuda10.0_amd64.deb

[下载地址](https://developer.nvidia.com/rdp/cudnn-archive)


# 四、安装gpu版tensorflow
本文使用的是virtualenv安装的tensorflow。
现在tensorflow越来越成熟了，所以在虚拟环境下直接可以用```pip install --upgrade tensorflow-gpu```即可安装成功。
安装完成后，进入python环境测试一下.


至此，基于Ubuntu的tensorflow-gpu版本就安装配置完成，下面就可以畅快的"吃鸡"啦。


## 错误1
tensorflow升级至1.7版本后，如果继续使用cuda 8.0则会报下面的错误：

```
---------------------------------------------------------------------------
ImportError                               Traceback (most recent call last)
<ipython-input-1-64156d691fe5> in <module>()
----> 1 import tensorflow as tf

/home/jerry/workshop/virtualenv/tensor_jupyer/local/lib/python2.7/site-packages/tensorflow/__init__.py in <module>()
     22 
     23 # pylint: disable=wildcard-import
---> 24 from tensorflow.python import *  # pylint: disable=redefined-builtin
     25 # pylint: enable=wildcard-import
     26 

/home/jerry/workshop/virtualenv/tensor_jupyer/local/lib/python2.7/site-packages/tensorflow/python/__init__.py in <module>()
     47 import numpy as np
     48 
---> 49 from tensorflow.python import pywrap_tensorflow
     50 
     51 # Protocol buffers

/home/jerry/workshop/virtualenv/tensor_jupyer/local/lib/python2.7/site-packages/tensorflow/python/pywrap_tensorflow.py in <module>()
     72 for some common reasons and solutions.  Include the entire stack trace
     73 above this error message when asking for help.""" % traceback.format_exc()
---> 74   raise ImportError(msg)
     75 
     76 # pylint: enable=wildcard-import,g-import-not-at-top,unused-import,line-too-long

ImportError: Traceback (most recent call last):
  File "/home/jerry/workshop/virtualenv/tensor_jupyer/local/lib/python2.7/site-packages/tensorflow/python/pywrap_tensorflow.py", line 58, in <module>
    from tensorflow.python.pywrap_tensorflow_internal import *
  File "/home/jerry/workshop/virtualenv/tensor_jupyer/local/lib/python2.7/site-packages/tensorflow/python/pywrap_tensorflow_internal.py", line 28, in <module>
    _pywrap_tensorflow_internal = swig_import_helper()
  File "/home/jerry/workshop/virtualenv/tensor_jupyer/local/lib/python2.7/site-packages/tensorflow/python/pywrap_tensorflow_internal.py", line 24, in swig_import_helper
    _mod = imp.load_module('_pywrap_tensorflow_internal', fp, pathname, description)
ImportError: libcublas.so.9.0: cannot open shared object file: No such file or directory

Failed to load the native TensorFlow runtime.

See https://www.tensorflow.org/install/install_sources#common_installation_problems

for some common reasons and solutions.  Include the entire stack trace
above this error message when asking for help.
```
也就是说 tensorflow兼容的cuda也已经升级至9.0了，下面介绍下在ubuntu 16.04下升级安装cuda 9.0，这里本来想在cuda8.0的基础上直接覆盖安装cuda9.0的，结果没有成功，编译cuda实例源码的时候使用提示没有找到driver。在这之前一直是使用ubuntu系统本身的升级系统来更新nvidia驱动的，并没有使用源码安装显卡驱动。后来不停的重装cuda的过程中反而把系统给弄坏了，最后实在没办法重装系统。

**在这里我又跳到坑里了，tensorflow 1.7目前暂时不支持cudnn9.1，所以我又得重新安装cudnn了（4月17号更新）**
**注意，在安装cuda和dudnn的时候版本一定要一致。重装系统后，我装了cuda_9.0.176_384.81_linux和cudnn-9.0-linux-x64-v7.1，tensorflow的版本为1.7.0，安装过程中没有出现什么太大的问题，基本跟cuda8.0安装过程差不多。**

## 更新(2018.10.16)
在安装cudnn之后需要添加环境变量,上文提到了在/etc/profile中添加相应的语句,然后source.我在将tensorflow1.7升级到tensorflow1.10之后出现了问题一的情况,后面我将环境变量添加到~/.bashrc中,然后source之后问题没了.

**UPDATE20190511**[tensorlfow cuda cudnn的版本对应](https://tensorflow.google.cn/install/source)
部分截图(UPGDATE20190710):
<center><img src="/wiki/static/images/tensorgpu/version.jpg" alt="version"/></center>

**UPDATE20190710***
## NCCL2
NCCL是Nvidia Collective multi-GPU Communication Library的简称，它是一个实现多GPU的collective communication通信（all-gather, reduce, broadcast）库，Nvidia做了很多优化，以在PCIe、Nvlink、InfiniBand上实现较高的通信速度。

## 下载安装
NCCL的[官网下载地址](https://developer.nvidia.com/nccl/nccl-download)

需要根据本机系统的linux系统和cuda版本选择下载对应的NCCL版本.如下图所示.

<center><img src="/wiki/static/images/tensorgpu/https-::developer.nvidia.com:nccl:nccl-download.jpg" alt="NCCL2"/></center>






# 六、参考文献
[CUDA官方安装教程](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
[cuDNN官方的安装和验证教程](https://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html#install-linux)
[ubuntu下安装安装CUDA、cuDNN和tensotflow-gpu版本流程和问题总结](https://sthsf.github.io/wiki/Algorithm/DeepLearning/Tensorflow学习笔记/Tensorflow基础知识---Tensorflow-gpu版本安装.html)
[Ubuntu 14.04 安装 CUDA 问题及解决](https://www.cnblogs.com/gaowengang/p/6068788.html)
[Ubuntu16.04+cuda8.0+caffe安装教程](http://blog.csdn.net/autocyz/article/details/52299889/)
[CUDNN Installation Guide](http://developer2.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.0.5/prod/Doc/cuDNN-Installation-Guide.pdf?1RL9HfeGELbC3I_J6F0c5RpXvy64oKHaWa0lZVIHWvzPbVKxDtV4_ivmxT2kIC6z1lE_h2bxuVgKEhGGW6R5n_GHnem5SFsA9jQI6LWMt68_sjV_HuOFBYO3EHzSwncT9iu1uUqar7UMgfrEOjgjE6hYCZcNNzBLgWrFa5VCRa2DsE1G8htULohvZqErOvFXRw)
[Ubuntu16.04 下安装GPU版TensorFlow（包括Cuda和Cudnn）](https://segmentfault.com/a/1190000008234390)
["libcudnn.so.5 cannot open shared object file: No such file or directory" ](http://blog.csdn.net/u014696921/article/details/60140264)
[ldconfig提示is not a symbolic link警告的去除方法 ](http://blog.csdn.net/liukun321/article/details/6908635)
[Ubuntu16.04.1如何安装TensorFlow1.1.0（GPU版）](http://blog.csdn.net/binglel/article/details/70230276)
[failed call to cuInit: CUDA_ERROR_UNKNOWN in python programs using Ubuntu bumblebee](https://github.com/tensorflow/tensorflow/issues/394)