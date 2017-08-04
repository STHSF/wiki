---
title: "linux 添加自定义的命令"
layout: page
date: 2017-07-07 17:30
---

# 写在前面
在linux下想要找到多层目录下的某个文件，如果对目录结构不是很熟需要不停的cd到该目录下，推出终端后又要重复以上的步骤。对于一些经常用到的命令，我们可以自定义到shell脚本里面，这样我们只要用一个简单的字符，替代原来很多重复的命令，从而节省了很多时间。

# 具体做法：

举个例子，比如我经常使用到```source /home/source/book/tensorflow/bin/activate``` 这个命令，如果在不熟悉目录结构的情况下，

```bash
cd /home
ls
cd source/
ls
cd book/
ls
cd tensorflow/
ls
cd bin/
ls
source activate
```

这样通常会比较浪费时间, 同样如果熟悉目录结构输入```source /home/source/book/tensorflow/bin/activate```这条命令也比较长，因此我们可以使用一个字符来替代这条长长的命令。其实我们只需要在～／.bashrc 这个文件下添加几行代码就可以了。

主要的步骤是在.bashrc这个文件中添加下一这条命令

```bash
alias [tensor]=['source /home/source/book/tensorflow/bin/activate']
```
然后保存退出，最后```source ~/.bashrc```使得bash生效。

这时候我们就可以使用tensor这个命令来替换原来那么长的命令行来。