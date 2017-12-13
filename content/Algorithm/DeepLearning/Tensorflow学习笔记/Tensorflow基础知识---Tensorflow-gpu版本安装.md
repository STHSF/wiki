---
title: "Tensorflow基础知识---ubuntu下安装安装CUDA、cuDNN和tensotflow-gpu版本流程和问题总结"
layout: page
date: 2017-12-12 14:00
---

# 写在前面
使用tensorflow接近一年时间，然而一直使用的是cpu版本的，而且还是在笔记本上跑程序的，所以当训练模型时，你懂的，我都心疼我的笔记本，最近公司刚刚给配了台带了块GTX 1080的台式机。嗯，终于算入门了，台式机的配置如下：
```
CPU: Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz
MemTotal: 16295024 kB
GPU: GeForce GTX 1080
```
目前来说够用了。大佬就可以忽略这段的。下面说说我在安装配置tensorflow-gpu的时候遇到的问题

# 一、N卡驱动安装
#### 1、ubuntu自带
安装之前使用```sudo apt-get install upgrade```将系统的软件进行升级。
然后在System Settings -> Software&Update -> Additional Drivers 下，等待刷新完毕后，会出现 NVIDIA Corporation：Unknown，如下图所示。然后勾选第一个选项，然后点击更新。更新完成后重启电脑。
<center><img src="/wiki/static/images/tensorgpu/settings.png" alt="settings"/></center>


重新打开终端，输入nvidia-smi，就会出现显卡的相关信息, 如下图所示。

<center><img src="/wiki/static/images/tensorgpu/nvidia-driver.png" alt="nvidia-driver"/></center>


#### 2、Nvidia官网下载对应显卡驱动安装
待完善......，本文暂时没有使用这种方式安装，所以等用过之后再完善。

# 二、安装cuda

#### 1、禁用自带的nouveau nvidia驱动

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
修改后需要重新启动系统，确认下nouveau是否已经被干掉了，```lsmod | grep nouveau```

#### 2、```Ctrl + Alt + F1``` 进入命令行模式，执行，
```
$ sudo service lightdm stop      // 关闭桌面服务
```
在安装CUDA的过程中必须得关闭桌面服务。当然，你也可以在终端中执行关闭桌面服务操作，然后使用 ```Ctrl + Alt + F4``` 登陆你的账号。

#### 3、安装CUDA.run文件
我用的是是CUDA8.0的版本，刚开始安装的是最新9.0的版本，后来好像在某篇教程中看到tensorflow目前还不支持CUDA9.0版本的，所以重装了8.0的，也有可能我没有理解他的意思，我没有经过实测。还有就是很多教程直接使用.deb安装的CUDA，同事反应在升级的过程中直接安装没有问题，但是后面使用的时候就会出现一些问题，所以我也没有直接安装，后面遇到的问题也没办法复现。
```
sudo sh cuda_8.0.44_linux_ubuntu_14.04.run --no-opengl-libs
```
在.run文件后面添加--no-opengl-libs的详解见[Ubuntu 14.04 安装 CUDA 问题及解决](https://www.cnblogs.com/gaowengang/p/6068788.html)，安装完成后需要将opengl的相关lib重新安装一下。

运行之后会跳出readme文件，然后按住```Ctrl + C```跳过。然后会依次出现以下提示：
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
更详细的提示见[Ubuntu16.04 下安装GPU版TensorFlow（包括Cuda和Cudnn）](https://segmentfault.com/a/1190000008234390)


安装完成之后，会提示一个summary；大致内容如下。
```
Driver: Not Selectd
Toolkit: INstalled in /usr/local/cuda-8.0
Samples: Installed in /home/jerry, but missing recommended libraries
```

***注意***
这时候会有一个提示，类似于下图，fail的原因是CUDA Driver没有安装。也有人说是因为双显卡(独立显卡和集成显卡)的原因。
<center><img src="/wiki/static/images/tensorgpu/devicequeryerror.png" alt="devicequeryerror"/></center>

根据提示，在.run文件后面添加-silent -driver，有提示的图片忘记保存了。以后遇到在加上。
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
sudo make clean && make
sudo ./deviceQuery
```

如果显示的是一些关于GPU的信息，则说明安装成功了，详细信息见下图。
<center><img src="/wiki/static/images/tensorgpu/devicequery.png" alt="devicequery"/></center>


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

在CUDA安装好之后，CUDNN安装相对比较容易，根据官网教程，首先从官网上下载四个文件。
```
cudnn-8.0-linux-x64-v7.tgz

libcudnn7_7.0.5.15-1+cuda8.0_amd64.deb

libcudnn7-dev_7.0.5.15-1+cuda8.0_amd64.deb

libcudnn7-doc_7.0.5.15-1+cuda8.0_amd64.deb
```
***注意***
在安装cudnn的时候要特别注意tensorflow目前支持的cudnn版本，我这边直接下载的是最新的，后面在安装完tensorflow-gpu 1.4.1之后调用cudnn时就出现了错误，错误提示为ImportError: libcudnn.so.6: cannot open shared object file: No such file or directory。
我的解决方法是从官网上直接下载cudnn.6.0版本的，至于软链接等方式我试过了没有成功，后面有详细介绍，也可能是我添加环境变量错误导致。

根据对应的系统和cuda版本下载，我的系统是ubuntu16.04，cuda版本为8.0.最好再注意下tensorflow支持的cudnn版本，然后需要注意的是cuda的安装路径，如果在安装cuda使用的默认路径/usr/local/cuda/，则不需要修改。

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
详细运行结果如下图所示：
<center><img src="/wiki/static/images/tensorgpu/mnist.png" alt="mnist"/></center>


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
### 1、驱动问题
我在安装过程中涉及到两个驱动问题，一个是显卡驱动，还有一个是CUDA驱动。***显卡驱动***我直接先是使用```sudo apt-get install upgrade```升级安装包，然后在Ubuntu的设置里面更新的Nvidia显卡驱动。并没有从官网下载安装对应版本的显卡驱动。***CUDA驱动***，我最初在安装CUDA的时候选项全部选择的是yes，导致最后的Driver、Toolkit和Samples都没有安装成功，后来所有教程中都加第二步是否安装图形显卡驱动时选择No，按照教程设置后Toolkit和Samples都安装成功了，但是Driver先是没有选择，安装结束后又一个warning，CUDA的驱动没有安装，根据提示在CUDA.run文件后面添加```-silent -driver```之后,对应的log文件中会先是```Driver: Installed```.
### 2、关于cuda环境变量和更新软链接问题
问题提示""failed call to cuInit: CUDA_ERROR_UNKNOWN""
<center><img src="/wiki/static/images/tensorgpu/CUDA_ERROR_UNKNOWN.jpeg" alt="CUDA_ERROR_UNKNOWN"/></center>
解决方法```sudo apt-get install nvidia-modprobe```

### 3、添加lib库路径


# 六、参考文献

[Ubuntu 14.04 安装 CUDA 问题及解决](https://www.cnblogs.com/gaowengang/p/6068788.html)
[Ubuntu16.04+cuda8.0+caffe安装教程](http://blog.csdn.net/autocyz/article/details/52299889/)
[CUDNN Installation Guide](http://developer2.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.0.5/prod/Doc/cuDNN-Installation-Guide.pdf?1RL9HfeGELbC3I_J6F0c5RpXvy64oKHaWa0lZVIHWvzPbVKxDtV4_ivmxT2kIC6z1lE_h2bxuVgKEhGGW6R5n_GHnem5SFsA9jQI6LWMt68_sjV_HuOFBYO3EHzSwncT9iu1uUqar7UMgfrEOjgjE6hYCZcNNzBLgWrFa5VCRa2DsE1G8htULohvZqErOvFXRw)
[Ubuntu16.04 下安装GPU版TensorFlow（包括Cuda和Cudnn）](https://segmentfault.com/a/1190000008234390)
["libcudnn.so.5 cannot open shared object file: No such file or directory" ](http://blog.csdn.net/u014696921/article/details/60140264)
[ldconfig提示is not a symbolic link警告的去除方法 ](http://blog.csdn.net/liukun321/article/details/6908635)
[Ubuntu16.04.1如何安装TensorFlow1.1.0（GPU版）](http://blog.csdn.net/binglel/article/details/70230276)