---
title: "kafka快速搭建和使用"
layout: page
date: 2019-06-03 10:00
---

# 写在前面
使用virtualenv创建虚拟环境,如果环境中又安装了conda,在使用source activate的时候可能会遇到不可遇见的问题,比如说环境混乱,特别是在使用复制过来的venv时很容易出错,所以建议一般使用requirement.txt重新安装.

# 本地搭建
## 本地环境
```
1、Ubuntu版本
16.04.10
2、zookeeper版本
zookeeper-3.4.14
3、kafka版本
kafka_2.12-2.2.0
```
## 本地搭建(单例)
1、首先从[官网](https://www.apache.org/dyn/closer.cgi?path=/kafka/2.2.0/kafka_2.12-2.2.0.tgz)上下载kafka压缩包, 下载完成之后解压缩
```
tar -xzf kafka_2.12-2.2.0.tgz
```
2、由于kafka是用zookeeper调度的, 所以在使用kafka之前必须下载安装zookeeper, [官网地址](http://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.4.14/), 下载完成之后解压缩.
```
tar -xzf zookeeper-3.4.14.tar.gz
```
3、zookeeper简单配置
```
cd zookeeper-3.4.14/conf  # 进入配置文件目录
cp zoo_sample.cfg zoo.cfg  # 生成一个配置文件模版
```
在配置文件中修改和添加以下内容:
```
dataDir=/home/jerry/workshop/virtualenv/zookeeper/zookeeper-3.4.14/data  # 数据存储目录
dataLogDir=/home/jerry/workshop/virtualenv/zookeeper/zookeeper-3.4.14/logs  # 日志存储目录
```
简单的配置之后, 启动zookeeper
```
./conf/zkServer.sh start  # 需要在root权限下运行
```
运行结果:
<center><img src="/wiki/static/images/message/zookeeper.jpg" alt="git-command"/></center>

4、启动kafka服务器

```
bin/kafka-server-start.sh config/server.properties
```
运行结果:
<center><img src="/wiki/static/images/message/kafka.jpg" alt="git-command"/></center>

5、创建topic
```
bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic test
```
如果topic创建成功, 可以通过下面的命令查看topic 列表
```
bin/kafka-topics.sh --list --bootstrap-server localhost:9092
```
6、生产者发送消息
新建一个terminal, 
```
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
> hello word
```

7、消费者接受消息

```
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
hello word
```
**如果上面的过程都有对应的输出结果, 没有出错的话. 一套简单的单例kafka就搭建完成了**

# Docker搭建
