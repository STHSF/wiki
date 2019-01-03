---
title: "mysql常见错误"
layout: page
date: 2018-10-17 15:30
---

# 写在前面
本篇文章主要记录mysql使用过程中遇到的坑

## 错误1
- 错误提示
```
(mysql.connector.errors.DataError) 1406 (22001): Data too long for column 'event_detail' at row 2
```
- 错误原因

- 修改后的代码
```
（1）先停止服务：service mysql stop
（2）修改/etc/my.conf;
    - 注MySql的配置文件Windows下一般在系统目录下或者在MySql的安装目录下名字叫my.ini，可以搜索，Linux下一般是/etc/my.cnf

找到
    - sql-mode=”STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION”
    把其中的STRICT_TRANS_TABLES,去掉

    或者把sql-mode=STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
（3）执行/usr/local/mysql/bin/mysqld_safe& service mysql start
```
或者在修改完/etc/my.conf之后直接使用```service mysqld restart```

## 错误2
如何修改Mysql字符集


## 参考文献
[错误1(1)](https://blog.csdn.net/weixin_37887248/article/details/80612021)

[错误1(2)](https://blog.csdn.net/dehu_zhou/article/details/52818484)

[错误2(1)设置MYSQL数据库编码为UTF-8](https://www.cnblogs.com/liyingxiang/p/5877764.html)

[错误2(2)彻底解决mysql中文乱码](https://www.cnblogs.com/zhchoutai/p/7364835.html)

[错误2(3)如何修改MySQL字符集](http://www.cnblogs.com/HondaHsu/p/3640180.html)