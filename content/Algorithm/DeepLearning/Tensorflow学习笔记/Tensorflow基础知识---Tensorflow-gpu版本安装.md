---
title: "Tensorflow基础知识---ubuntu下安装tensotflow-gpu版本、安装cuda、cuddn"
layout: page
date: 2017-12-12 14:00
---

# 写在前面

# 一、N卡驱动安装
## 1、ubuntu自带
安装之前使用```sudo apt-get install upgrade```将系统的软件进行升级。
然后在System Settings -> Software&Update -> Additional Drivers 下，等待刷新完毕后，会出现 NVIDIA Corporation：Unknown，然后勾选第一个选项，然后点击更新。更新完成后重启电脑。

打开终端，输入nvidia-smi，就会出现显卡的相关信息, 如下图所示。

<center><img src="/wiki/static/images/tensorgpu/nvidia-driver.png" alt="nvidia-driver"/></center>


## 2、nvidia官网下载对应显卡驱动安装
待完善......

# 二、安装cuda

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
```

运行之后会跳出readme文件，然后按住ctr+ c跳过。
然后会依次出现以下提示：
```
Do you accept the previously read EULA，  输入 accept，进入下一步。
INSTALL NVIDIA Accelerates Graphics Driver for Linux-x86_64 375.26，  输入n，进入下一步；
Install the  CUDA 8.0 Toolkit?，  输入y， 进入下一步；
Enter Tookit Location 点击enter， 进入下一步；
Do you want to install a symbolic link at /usr/local/cuda，  输入y，进入下一步；
Install the CUDA 8.0 Samples?  输入y， 进入下一步；
Enter CUDA Samples Location 点击enter， 进入下一步；
程序开始安装。。。
```

安装完成之后，会提示一个summary；大致内容如下。
```
Driver: Not Selectd
Toolkit: INstalled in /usr/local/cuda-8.0
Samples: Installed in /home/jerry, but missing recommended libraries
```

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

# 三、安装cudnn

在CUDA安装好之后，CUDNN安装相对比较容易，根据官网教程，首先从官网上下载四个文件，
```
cudnn-8.0-linux-x64-v7.tgz

libcudnn7_7.0.5.15-1+cuda8.0_amd64.deb

libcudnn7-dev_7.0.5.15-1+cuda8.0_amd64.deb

libcudnn7-doc_7.0.5.15-1+cuda8.0_amd64.deb
```

根据对应的系统和cuda版本下载，我的系统是ubuntu16.04，cuda版本为8.0.然后需要注意的是cuda的安装路径，如果在安装cuda使用的默认路径/usr/local/cuda/，则不需要修改。

在存放四个文件的下载目录下。
```
# 解压 cuDNN package.
$ tar -xzvf cudnn-8.0-linux-x64-v7.tgz
# 将下面的文件复制到 CUDA Toolkit 文件目录下。
$ sudo cp cuda/include/cudnn.h /usr/local/cuda/include
$ sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
$ sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
# 安装 runtime library,
sudo dpkg -i libcudnn7_7.0.5.15-1+cuda8.0_amd64.deb
# 安装 developer library,
sudo dpkg -i libcudnn7-dev_7.0.5.15-1+cuda8.0_amd64.deb
# 安装 code samples and the cuDNN Library User Guide
sudo dpkg -i libcudnn7-doc_7.0.5.15-1+cuda8.0_amd64.deb
```

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

# 四、安装gpu版tensorflow
本文使用的是virtualenv安装的tensorflow。
现在tensorflow越来越成熟了，所以在虚拟环境下直接可以用```pip install --upgrade tensorflow-gpu```即可安装成功。
安装完成后，进入python环境测试一下，问题来了。

### 错误提示
```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/home/jerry/workshop/virtualenv/tensor/local/lib/python2.7/site-packages/tensorflow/__init__.py", line 24, in <module>
    from tensorflow.python import *
  File "/home/jerry/workshop/virtualenv/tensor/local/lib/python2.7/site-packages/tensorflow/python/__init__.py", line 49, in <module>
    from tensorflow.python import pywrap_tensorflow
  File "/home/jerry/workshop/virtualenv/tensor/local/lib/python2.7/site-packages/tensorflow/python/pywrap_tensorflow.py", line 59, in <module>
    raise ImportError(msg)
ImportError: Traceback (most recent call last):
  File "/home/jerry/workshop/virtualenv/tensor/local/lib/python2.7/site-packages/tensorflow/python/pywrap_tensorflow.py", line 48, in <module>
    from tensorflow.python.pywrap_tensorflow_internal import *
  File "/home/jerry/workshop/virtualenv/tensor/local/lib/python2.7/site-packages/tensorflow/python/pywrap_tensorflow_internal.py", line 28, in <module>
    _pywrap_tensorflow_internal = swig_import_helper()
  File "/home/jerry/workshop/virtualenv/tensor/local/lib/python2.7/site-packages/tensorflow/python/pywrap_tensorflow_internal.py", line 24, in swig_import_helper
    _mod = imp.load_module('_pywrap_tensorflow_internal', fp, pathname, description)
ImportError: libcudnn.so.6: cannot open shared object file: No such file or directory


Failed to load the native TensorFlow runtime.

See https://www.tensorflow.org/install/install_sources#common_installation_problems

for some common reasons and solutions.  Include the entire stack trace
above this error message when asking for help.
```
在网上查资料发现，需要进行软链接配置，主要原因依然是环境变量的问题，但是按照一些方式还是提示上面的错误，后来查看lib64下面的文件发现我安装的是.so.8.0的版本，本来是想都安装最新版本的，慢慢发现google和nvidia两家根本不同步，版本的一致性问题很头疼。没办法，在nvidia官网重新下载6.0版本的cudnn按照上面的方式重新安装后，在没有重新设置环境变量的情况下，helloword程序跑通了
下面是执行session时输出的信息，GPU信息显示出来了。
```
2017-12-12 13:36:43.894722: I tensorflow/core/platform/cpu_feature_guard.cc:137] Your CPU supports instructions that this TensorFlow binary was not compiled to use: SSE4.1 SSE4.2 AVX AVX2 FMA
2017-12-12 13:36:44.024230: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:892] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2017-12-12 13:36:44.024467: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1030] Found device 0 with properties:
name: GeForce GTX 1080 major: 6 minor: 1 memoryClockRate(GHz): 1.7335
pciBusID: 0000:01:00.0
totalMemory: 7.92GiB freeMemory: 7.34GiB
2017-12-12 13:36:44.024480: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1120] Creating TensorFlow device (/device:GPU:0) -> (device: 0, name: GeForce GTX 1080, pci bus id: 0000:01:00.0, compute capability: 6.1)

```
具体运行结果如下图所示：
<center><img src="/wiki/static/images/tensorgpu/tensorflow.png" alt="tensorflow"/></center>

至此，基于Ubuntu的tensorflow-gpu版本就安装配置完成，下面就可以畅快的"吃鸡"啦。

# 五、一些问题
### 关于cuda环境变量问题，
### 关于更新软链接
### 添加lib库路径


# 六、参考文献

[Ubuntu 14.04 安装 CUDA 问题及解决](https://www.cnblogs.com/gaowengang/p/6068788.html)
[Ubuntu16.04+cuda8.0+caffe安装教程](http://blog.csdn.net/autocyz/article/details/52299889/)
[CUDNN Installation Guide](http://developer2.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.0.5/prod/Doc/cuDNN-Installation-Guide.pdf?1RL9HfeGELbC3I_J6F0c5RpXvy64oKHaWa0lZVIHWvzPbVKxDtV4_ivmxT2kIC6z1lE_h2bxuVgKEhGGW6R5n_GHnem5SFsA9jQI6LWMt68_sjV_HuOFBYO3EHzSwncT9iu1uUqar7UMgfrEOjgjE6hYCZcNNzBLgWrFa5VCRa2DsE1G8htULohvZqErOvFXRw)
[Ubuntu16.04 下安装GPU版TensorFlow（包括Cuda和Cudnn）](https://segmentfault.com/a/1190000008234390)
["libcudnn.so.5 cannot open shared object file: No such file or directory" ](http://blog.csdn.net/u014696921/article/details/60140264)
[ldconfig提示is not a symbolic link警告的去除方法 ](http://blog.csdn.net/liukun321/article/details/6908635)
[Ubuntu16.04.1如何安装TensorFlow1.1.0（GPU版）](http://blog.csdn.net/binglel/article/details/70230276)