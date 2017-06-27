---
title: "Mac下使用simiki搭建个人wiki"
layout: page
date: 2017-06-02 00:00
---

# 写在前面
本人搭建个人wiki也是机缘巧合，最近一直在尝试学习一点前端的知识，尝试着使用github弄个[个人博客](https://sthsf.github.io/)啥的玩玩，扩充自己的知识。同时，自己从事算法类的工作，其实也是程序猿的一种啦，这两天在网上查找资料的时候发现了[tracholar](https://tracholar.github.io/wiki/)的个人wiki，我觉得写得不错，同时也是整理自己平时学习的东西的一个好的方案。我也尝试了很多知识管理类的软件，比如百度云笔记，Evrnote等都觉得不是很方便。主要是搜索起来比较麻烦，不便于记忆。于是尝试使用这个个人wiki。

# simiki介绍
Simiki 是一个简单的个人Wiki框架。使用Markdown书写Wiki, 生成静态HTML页面。Wiki源文件按目录分类存放, 方便管理维护。

## 目录结构
主要介绍一下content和output两个文件夹。

使用simiki新建初始化(_simiki init_)之后会出现四个文件或文件夹，其中content下存储的是源文件(目前只支持markdown)，后面simiki
编译的时候会将content下的文件编译成静态文件目录，并存放到output中。



# Mac下部署
本文中关于simiki的部署主要还是参考官网，但对于新手来说还是有一定的坑的，所以我把整个流程再详细的解释一遍。

安装完相关的包之后
