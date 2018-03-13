---
title: "Intellij IDEA 使用scala连接SQL Server教程"
layout: page
date: 2018-03-13 10:00
---
[TOC]

# 写在前面
在数据处理过程中免不了会对数据库进行操作，本文主要介绍在intellij下使用scala连接sqlServer数据库。之前我在介绍[scala 使用JDBC方式访问Mysql](http://blog.csdn.net/u013041398/article/details/50968602)时，java是有关于mysql驱动的依赖包的，但是SQLServer好像没有相关的依赖包。需要从外部添加相关的jar包。


# 下载Microsoft SQL Server JDBC 驱动程序
在微软的官网上我们可以找到Microsoft SQL Server JDBC 驱动程序 6.0的镜像文件。[下载地址](https://www.microsoft.com/zh-CN/download/details.aspx?id=11774)，本文是在Mac下搭建的环境，所以后面的操作都是UNIX版本的操作。

下载完成后，解压。会得到下面的文件。
<center><img src="/wiki/static/images/spark/sqljdbc.jpg" alt="jdbc" height="400" width="300"/></center>

# 在工程中导入jdbc.jar文件
点击File > Project Structure, 然后依次点击Modules，以及有面的Dependencies，你会看到下面类似的图片。
<center><img src="/wiki/static/images/spark/projectstructure.jpg" alt="jdbc" height="400" width="400"/></center>

然后点击左下角的加号，选择```JARS or directions```, 跳转到第一步下载的驱动目录下, 根据工程中java的版本选择不同的jar包。本文选择的是jre8下面的jar包，如下图。
<center><img src="/wiki/static/images/spark/jar.jpg" alt="jdbc" height="400" width="400"/></center>

添加完成之后，点击右下角的Apply和OK按钮。这样驱动包就导入完毕。下面编写数据库连接代码。


# 数据库连接




# 参考文献