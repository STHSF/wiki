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


## 错误3
- 错误提示
```
sqlalchemy.exc.OperationalError: (mysql.connector.errors.OperationalError) 2055: Lost connection to MySQL server at '10.15.5.86:3306', system error: 32 Broken pipe [SQL: u'INSERT INTO topic_detail (user_id, primary_name, key_name, article_num, article_detail) VALUES (%(user_id)s, %(primary_name)s, %(key_name)s, %(article_num)s, %(article_detail)s)'] [parameters: {'article_num': 5284, 'user_id': 'system', 'article_detail': '[{"info_id": "2349180", "create_time": "2014-03-30T16:00:00.000Z", "match_location": ["\\u672c\\u62a5\\u544a\\u5bfc\\u8bfb\\uff1a\\n    \\u5e02\\u573 ... (10369348 characters truncated) ... /em>\\u8fd160%\\uff0c\\u540c\\u671f\\u65e5\\u672c\\u8d2d\\u4e7026015\\u53f0\\uff0c\\u7f8e\\u56fd\\u8d2d\\u4e7023679\\u53f0\\u3002"], "match_num": 2}]', 'key_name': '\xe5\xa2\x9e\xe9\x95\xbf', 'primary_name': '\xe6\x88\x90\xe9\x95\xbf\xe7\xa9\xba\xe9\x97\xb4'}] (Background on this error at: http://sqlalche.me/e/e3q8)
```

- 错误原因
MySQL会根据配置文件会限制server接受的数据包的大小。如果写入大数据时，因为默认的配置太小，插入和更新操作会因为 max_allowed_packet 参数限制，而导致失败。

- 修改方法

1、配置文件持久化修改

```
vim /etc/my.cnf

在[mysqld]下面添加
max_allowd_packet= 100M

# 注意max_allowed_packet 最大值是1G(1073741824)，如果设置超过1G，查看最终生效结果也只有1G。

```
***注意：修改配置文件以后，需要重启mysql服务才能生效。***

2、命令行临时修改

```
mysql> set global max_allowed_packet = 100 * 1024 * 1024;
mysql> exit
```
***1.命令行修改时，不能用M、G，只能这算成字节数设置。配置文件修改才允许设置M、G单位。***

***2.命令行修改之后，需要退出当前回话(关闭当前mysql server链接)，然后重新登录才能查看修改后的值。通过命令行修改只能临时生效，下次数据库重启后又复原了。***

## 参考文献
[错误1(1)](https://blog.csdn.net/weixin_37887248/article/details/80612021)

[错误1(2)](https://blog.csdn.net/dehu_zhou/article/details/52818484)

[错误2(1)设置MYSQL数据库编码为UTF-8](https://www.cnblogs.com/liyingxiang/p/5877764.html)

[错误2(2)彻底解决mysql中文乱码](https://www.cnblogs.com/zhchoutai/p/7364835.html)

[错误2(3)如何修改MySQL字符集](http://www.cnblogs.com/HondaHsu/p/3640180.html)

[错误2(4)MySQL Workbench中修改表字段字符集](https://www.cnblogs.com/flowingcloud/p/6235095.html)

[SQLAlchemy 教程 —— 基础入门篇](http://www.cnblogs.com/mrchige/p/6389588.html)