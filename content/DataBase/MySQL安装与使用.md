---
title: "Linux下MySQL安装与使用.md"
layout: page
date: 2099-06-02 00:00
---

# MySQL安装
```
sudo apt-get install mysql-server
sudo apt-get install mysql-client
sudo apt-get install libmysqlclient-dev
```
在第一步安装的过程中会弹出窗口要求输入root用户的密码，需要记住这个密码。

# 检查是否安装成功
输入命令：
```
netstat -tap | grep mysql
```
输出的正确结果为：
```
tcp        0      0 localhost:mysql         *:*                     LISTEN      23368/mysqld
```
出现以上结果就代表安装成功了。


