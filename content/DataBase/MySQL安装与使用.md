---
title: "Linux下MySQL安装与配置"
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

### 检查是否安装成功
输入命令：
```
netstat -tap | grep mysql
```
输出的正确结果为：
```
tcp        0      0 localhost:mysql         *:*                     LISTEN      23368/mysqld
```
出现以上结果就代表安装成功了。

### MySQL的一些简单管理：
启动MySQL服务：```sudo start mysql```

停止MySQL服务：```sudo stop mysql```

修改 MySQL 的管理员密码：```sudo mysqladmin -u root password "newpassword"```

设置远程访问(正常情况下，mysql占用的3306端口只是在IP 127.0.0.1上监听，拒绝了其他IP的访问（通过netstat可以查看到）。取消本地监听需要修改 my.cnf 文件：)：
```sudo vi /etc/mysql/my.cnf```
```bind-address = 127.0.0.1 //找到此内容并且注释```

### MySQL安装后的目录结构分析(此结构只针对于使用apt-get install 在线安装情况)：

数据库存放目录：```/var/lib/mysql/```

相关配置文件存放目录：```/usr/share/mysql```

相关命令存放目录：```/usr/bin(mysqladmin mysqldump等命令)```

启动脚步存放目录：```/etc/rc.d/init.d/```


### 常用命令
查看database列表：```show databases;```

操作数据库：```use "database_name";```

查看表名：```show tables;```

查看表中的内容：```show columns from "table_name";```

显示数据表的详细索引信息，包括PRIMARY KEY（主键）: ```show index from "table_name";```



