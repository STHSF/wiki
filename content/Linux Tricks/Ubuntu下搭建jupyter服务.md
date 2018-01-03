---
title: "Ubuntu下搭建jupyter服务"
layout: page
date: 2018-01-03 00:00
---

# 写在前面
在使用python做一些数据处理等任务时，及时了解每一步的输出结果有助于程序的调试，但是在程序中会写上大量的print，不是很方便。jupyter这种交互式编码让我们减少了很多不必要的代码量。


# jupyter安装
为了尽量减少对全局环境的影响，我都是在服务器上搭建的环境都是使用virtualenv搭建的，全局环境下的搭建过程类似。
```
# python2
pip install jupyter
# python3
pip3 install jupyter
```
# jupyter配置

## 设置密钥的sha1码
很多教程中使用的是ipython来生成sha1码，我这里直接在python终端下设置的,如下图所示:
<center><img src="/wiki/static/images/linuxtricks/jupyter1.jpg" alt="sha1码"/></center>

## 产生并配置 jupyter_notebook_config.py 文件
cd 到 ～/.jupyter/文件目录下，查看当前目录下是否有jupyter_notebook_config.py 文件，如果没有，则使用 jupyter notebook --generate-config 命令产生一个默认jupyter_notebook_config.py的配置都使用#注释掉，下面需要开启所需要的命令。
```
## The full path to an SSL/TLS certificate file. 这个步骤是可以选择的，如果不设置，也可以在局域网中使用jupyter
c.NotebookApp.certfile = u'/home/users/.jupyter/mycert.pem

## The IP address the notebook server will listen on.
c.NotebookApp.ip = '192.168.1.1'

## The string should be of the form type:salt:hashed-password.
## 这里password 一项要使用前面产生的sha1值
c.NotebookApp.password = u'sha1:96d749b4e109:17c2968d3bc899fcd41b87eb0853a42ceb48c521'

## The port the notebook server will listen on.
c.NotebookApp.port = 8888

## 设置不自动打开浏览器
c.NotebookApp.open_browser = False
　　
## 配置Jupyter notebook的默认目录，这边自己设置自己的文件目录
c.NotebookApp.notebook_dir = u'/home/users/Jupyter'
```
## 启动Jupyter notebook
在~/.jupyter目录下，输入下面命令即可

```
## 如果使用openssl设置了，则执行下面的代码，如果在全局环境下则需要在前面添加sudo
jupyter notebook --certfile=mycert.pem --keyfile mykey.key

## 如果没有设置openssl，直接使用下面的命令启动notebook
jupyter notebook
```
然后在其他机器上，输入 https://192.168.1.1:8888 (这里的ip是根据你自己的环境和在jupyter_notebook_config.py 文件配置的ip)

再输入密码即可访问上面设置的文件目录下面的文件。