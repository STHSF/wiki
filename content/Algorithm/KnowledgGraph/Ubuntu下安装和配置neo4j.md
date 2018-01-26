---
title: "Ubuntu下安装和配置neo4j"
layout: page
date: 2018-01-26 00:00
---

[TOC]

# 写在前面
## Neo4j的优点
- 它很容易表示连接的数据
- 检索/遍历/导航更多的连接数据是非常容易和快速的
- 它非常容易地表示半结构化数据
- Neo4j CQL查询语言命令是人性化的可读格式，非常容易学习
- 它使用简单而强大的数据模型
- 它不需要复杂的连接来检索连接的/相关的数据，因为它很容易检索它的相邻节点或关系细节没有连接或索引
## Neo4j的缺点或限制
- AS的Neo4j 2.1.3最新版本，它具有支持节点数，关系和属性的限制。
- 它不支持Sharding。

# 安装环境
Ubuntu 16.04.3 LTS

# 安装准备
## 1、下载、配置java jdk
安装配置neo4j需要jdk的版本必须是1.8以上的，不然会报错。所以本文下载的是jdk的版本是(java SE Development Kit 8u161)

```shell
下载地址：http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
文件名：jdk-8u161-linux-x64.tar.gz
```

文件下载到本地之后使用```tar -xf 'filename'```解压对应的文件。

解压完成之后配置jdk环境变量。

首先注意自己的解压目录，一般会将解压的jdk文件放到/usr/lib/下。但你也可以自己指定位置。然后在bash的配置文件中添加下面的几行代码.***注意，可能你用的不是bash，可能是zsh等终端，所以在配置的时候需要注意，如果你自己使用的是ubuntu自带的bash，那么你就修改～/.bashrc文件。如果使用的是zsh则需要修改～/.zshrc，不同的bash添加的内容相同，如果添加的文件搞错了，后面配置的时候会识别不了。***

```
export JAVA_HOME=your_jdk_path 
export JRE_HOME=${JAVA_HOME}/jre 
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib 
export PATH=${JAVA_HOME}/bin:$PATH 
```

添加完成之后，保存退出。然后使用source来使修改的文件生效。

```
source ~/.bashrc 或者 source ~/.zshrc
```
完了之后使用```java -version```，如果显示了java的版本则表示安装成功。接下来就可以下载配置neo4j了。

## 2、下载neo4j源文件

首先去官网下载neo4j源文件，本文使用的是Neo4j 3.3.2(tar)版本。下载到本地之后，解压文件。

解压完成之后直接进入bin目录下面,使用命令```./neo4j console```然后就可以启动了。这时候你在本机的浏览器中输入http://localhost:7474/就可以在浏览器中进行访问了。当然你也可以使用```./neo4j start```让neo4j后台运行。

登陆neo4j的初始用户名和密码都是neo4j，初次登陆之后他会提示让你修改密码。至此，Neo4j就已经安装完毕，你可以在上面创建你的图数据库了。

# 问题总结
## 1、neo4j启动之后，本机通过localhost可以访问。但是局域网中访问不了。
这需要修改$NEO4J_HOME}/conf/neo4j.conf文件，在文件中找到Network connector configuration这块，大概在49-83行左右。然后将```dbms.connectors.default_listen_address=0.0.0.0```前面的注释#符号去掉，保存。然后重新运行，你就可以在局域网中使用本机的ip和7474端口来访问neo4j了。


