---
title: "Sqlite3常用命令"
layout: page
date: 2017-08-22 09:00
---

# 写在前面
记录事情sqlite数据库的点点滴滴，主要是平时不常用到数据库操作，很多代码经常会忘记，记录下来以便用的时候查验。部分命令跟mysql的操作类似。

# 常用命令
- 启动数据库: ```sqlite3 "database_name"```
- 查看数据库中的表: ```.tables```
- 查看表的结构: ```.schema "table_name"```
- 查看前n条数据: ```select * from "table_name" limit 0,n```