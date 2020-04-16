---
title: "kafka快速搭建和使用"
layout: page
date: 2019-06-03 10:00
---

# 1、写在前面
使用virtualenv创建虚拟环境,如果环境中又安装了conda,在使用source activate的时候可能会遇到不可遇见的问题,比如说环境混乱,特别是在使用复制过来的venv时很容易出错,所以建议一般使用requirement.txt重新安装.

# 2、本地搭建
## 本地环境
```
1、Ubuntu版本
16.04.10
2、 Java版本
"1.8.0_161"
3、zookeeper版本
zookeeper-3.4.14
4、kafka版本
kafka_2.12-2.2.0
```
## 本地搭建(单例)
#### 1、下载kafka
首先从[官网](https://www.apache.org/dyn/closer.cgi?path=/kafka/2.2.0/kafka_2.12-2.2.0.tgz)上下载kafka压缩包, 下载完成之后解压缩
```
tar -xzf kafka_2.12-2.2.0.tgz
```
#### 2、下载zookeeper
由于kafka是用zookeeper调度的, 所以在使用kafka之前必须下载安装zookeeper, [官网地址](http://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.4.14/), 下载完成之后解压缩.
```
tar -xzf zookeeper-3.4.14.tar.gz
```
#### 3、zookeeper简单配置
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

#### 4、启动kafka服务器

```
bin/kafka-server-start.sh config/server.properties
```
运行结果:
<center><img src="/wiki/static/images/message/kafka.jpg" alt="git-command"/></center>

#### 5、创建topic
```
bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic test
```
如果topic创建成功, 可以通过下面的命令查看topic 列表
```
bin/kafka-topics.sh --list --bootstrap-server localhost:9092
```
#### 6、生产者发送消息
新建一个terminal, 
```
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
> hello word
```

#### 7、消费者接受消息

```
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
hello word
```
**如果上面的过程都有对应的输出结果, 没有出错的话. 一套简单的单例kafka就搭建完成了**

# 3、Docker简易搭建kafka(单节点)
为了快速检验docker下使用kafka的可能性, 另外自己写dockerFile比较慢, 所以选择下载第三方镜像, 然后直接使用.
#### 1、docker search zookeeper和kafka
```
# zookeeper
NAME                           DESCRIPTION                                     STARS     OFFICIAL        AUTOMATED
zookeeper                      Apache ZooKeeper is an open-source server wh…   657       [OK]            
jplock/zookeeper               Builds a docker image for Zookeeper version …   162                       [OK]
wurstmeister/zookeeper                                                         85                        [OK]
mesoscloud/zookeeper           ZooKeeper                                       73                        [OK]
mbabineau/zookeeper-exhibitor                                                  24                        [OK]
digitalwonderland/zookeeper    Latest Zookeeper - clusterable                  19                        [OK]
bitnami/zookeeper              ZooKeeper is a centralized service for distr…   16                        [OK]
confluent/zookeeper                                                            13                        [OK]
# kafka
NAME                           DESCRIPTION                                     STARS     OFFICIAL         AUTOMATED
wurstmeister/kafka             Multi-Broker Apache Kafka Image                 919                        [OK]
spotify/kafka                  A simple docker image with both Kafka and Zo…   352                        [OK]
sheepkiller/kafka-manager      kafka-manager                                   163                        [OK]
ches/kafka                     Apache Kafka. Tagged versions. JMX. Cluster-…   112                        [OK]
bitnami/kafka                  Apache Kafka is a distributed streaming plat…   52                         [OK]
hlebalbau/kafka-manager        Kafka Manager Docker Images Build.              37                         [OK]
landoop/kafka-topics-ui        UI for viewing Kafka Topics config and data …   26                         [OK]
solsson/kafka                  http://kafka.apache.org/documentation.html#q…   14                         [OK]
landoop/kafka-lenses-dev       Lenses with Kafka. +Connect +Generators +Con…   14                         [OK]
debezium/kafka                 Kafka image required when running the Debezi…   13                         [OK]

```
docker pull 了两个stars最高的两个
```
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
zookeeper                    latest              55c28ddb9786        4 days ago          211MB
wurstmeister/kafka           latest              c364cbed5b86        6 weeks ago         421MB
```
#### 2、启动zookeeper容器
```
docker run -itd --name zookeeper -p 2181:2181 -t zookeeper
```
#### 3、启动kafka容器

```
docker run -d --name kafka \
--publish 9092:9092 \
--link zookeeper \
--env KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
--env KAFKA_ADVERTISED_HOST_NAME=[你的宿主ip] \
--env KAFKA_ADVERTISED_PORT=9092 \
--volume /etc/localtime:/etc/localtime -t wurstmeister/kafka:latest
```
启动后查看容器信息
```
CONTAINER ID        IMAGE                                 COMMAND                  CREATED             STATUS                      PORTS                                        NAMES
ec19c784fa15        wurstmeister/kafka:latest             "start-kafka.sh"         5 hours ago         Up 4 hours                  0.0.0.0:9092->9092/tcp                       kafka
5d8dcd2f4ca6        zookeeper                             "/docker-entrypoint.…"   5 hours ago         Up 4 hours                  2888/tcp, 0.0.0.0:2181->2181/tcp, 3888/tcp   zookeeper
```
#### 4、kafka容器内部操作
我们可以通过```docker exec -it [your kafka container id] /bin/bash```

然后进入```/ope/kafka_2.12-2.1.0```, 如下图所示.
<center><img src="/wiki/static/images/message/docker_kafka.jpg" alt="git-command"/></center>

container内创建一个topic. 名字为topic_docker_test
```
bin/kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic topic_docker_test
```

查看topic list
```
bin/kafka-topics.sh --list --zookeeper zookeeper:2181  //查看我们的topic列表
```
**注,topic的创建和查看中的```zookeeper:2181```可以替换成```[宿主机ip:2181]```如```10.15.5.14:2181```**

#### 5、container内生产者消费者测试
container内部的生产者和消费者测试与本地(单例)模式下的测试一模一样, 这么不赘述.

#### 6、生产者消费者测试
使用宿主机上的kafka进行测试. 链接kafka容器, 使用的是主机与容器的端口映射
- 生产消息
```
bin/kafka-console-producer.sh --topic=test02 --broker-list 10.15.5.164:9092
>hello word
```
- 消费消息
```
bin/kafka-console-consumer.sh --topic=test02 --bootstrap-server 10.15.5.164:9092 --from-beginning
hello word
```

##### 7、python操作kafka测试

1、topic查看
```python
#!/usr/bin/python                                                                                                                       
 
from pykafka import KafkaClient

client = KafkaClient(hosts="10.15.5.164:9092")
#查看主题
print(client.topics)
#查看brokers
print(client.brokers)
topic = client.topics['mySendTopic']
for n in client.brokers:
    host = client.brokers[n].host
    port = client.brokers[n].port
    id = client.brokers[n].port
    print("host=%s |port=%s|broker.id=%s" %(host,port,id))
```
2、创建简单的生产者
producer.py
```python
#!/usr/bin/python  
# coding:utf-8
 
from kafka import KafkaProducer

producer = KafkaProducer(bootstrap_servers=['10.15.5.164:9092'])
for i in range(100):
     msg = "msg : %s" % i
     producer.send('topic_docker_test', bytes(msg, encoding='utf-8'))
producer.close()
```
3、创建简单的消费者
consumer.py
```python
#!/usr/bin/python
# coding:utf-8

from kafka import KafkaConsumer
 
consumer = KafkaConsumer('topic_docker_test', bootstrap_servers=['10.15.5.164:9092'],)
for message in consumer:
    print ("%s:%d:%d: key=%s value=%s" % (message.topic, message.partition, message.offset, message.key, message.value))
```

### **疑点**
关于docker下创建topic, 进入kafka容器后创建topic理论上和实际操作上是没有问题的, 在宿主机上也是可以查看到创建的topic的, 但是如何在容器外部创建topic呢, 暂时没找到解决方案, 但是如果宿主机上部署了kafka, 在没有启动kafka的情况下也是可以通过

```bin/kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic test01 ```

创建topic的. 同样, 查看topic列表时, 所有的topic都能现实. 如果宿主机上没有kafka, 如何创建topic?

### **注**
1、本地搭载和docker搭载使用的版本不一致.


# 4、单服务器搭建docker的zookeeper集群
在开发环境中，大家应该都用的是zookeeper单点吧，但是在生产环境中我相信没有人敢用单点的，应该都是用的集群，因为万一单点挂掉的话，我们的应用也就自然而然的ConnectionException。那么，接下来我就记录一下我自己用docker搭建zookeeper集群。

这里准备利用三个zookeeper节点组成一个集群，并且三个节点都在同一台主机上，如果需要节点原型在不同的主机上，修改对应的ip和端口即可.
### 1、创建节点文件夹
为每个节点创建节点文件夹, 用于存放zookeeper的配置信息, 以及对应节点的数据和log

节点目录列表:

    |-- zookeeper
        |--zookeeper1
            |-- conf
            |-- data
            |-- logdata
        |-- zookeeper2
            |-- conf
            |-- data
            |-- logdata
        |-- zookeeper3
            |-- conf
            |-- data
            |-- logdata

其中, /conf下面最重要的配置文件zoo.cfg配置如下
```
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/data
dataLogDir=/datalog
clientPort=2181
server.1=zookeeper1:2888:3888
server.2=zookeeper2:2888:3888
server.3=zookeeper3:2888:3888
```

/data文件夹下, 新建对应的myid配置文件, 文件中记录的是节点编号, 其值在1~255之间.

- 节点编号对应的关系

|host|ID|
|:---:|:---:|
|zookeeper1|1|
|zookeeper2|2|
|zookeeper3|3|

- 配置方法
```
mkdir data
vim /data/myid
1
```

**注, 其中的dataDir和dataLogDir配置与本地zookeeper配置不一样, 这是由所pull的zookeeper docker里面的内容决定的**


### 2、启动docker
按照如下的命令在服务器上运行zookeeper容器, 建立节点zookeeper1, zookeeper2, zookeeper3.
```
# zookeeper1
docker run -itd \
--restart always \
--name zookeeper2 \
--network=zk_test_default \
--hostname zookeeper2 \
-p 22181:2181 \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper2/conf:/conf \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper2/data:/data \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper2/logdata:/datalog \
zookeeper:3.4

# zookeeper2
docker run -itd \
--restart always \
--name zookeeper3 \
--network=zk_test_default \
--hostname zookeeper3 \
-p 32181:2181 \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper3/conf:/conf \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper3/data:/data \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper3/logdata:/datalog \
zookeeper:3.4

# zookeeper3
docker run -itd \
--restart always \
--name zookeeper1 \
--hostname zookeeper1 \
-p 12181:2181 \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper1/conf:/conf \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper1/data:/data \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper1/logdata:/datalog \
zookeeper:3.4
```

依次执行上面的命令之后,三个container启动, 
```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                         NAMES
e6257ba1f952        zookeeper:3.4       "/docker-entrypoint.…"   About an hour ago   Up About an hour    2888/tcp, 3888/tcp, 0.0.0.0:32181->2181/tcp   zookeeper3
fd7db9617b02        zookeeper:3.4       "/docker-entrypoint.…"   About an hour ago   Up About an hour    2888/tcp, 3888/tcp, 0.0.0.0:22181->2181/tcp   zookeeper2
cbef96c80e83        zookeeper:3.4       "/docker-entrypoint.…"   About an hour ago   Up About an hour    2888/tcp, 3888/tcp, 0.0.0.0:12181->2181/tcp   zookeeper1
``` 
### 测试
查看各个container的ip地址
```
# 查看zookeeper1的ip地址
docker inspect zookeeper1
# 输出的信息中有IPAddress的字样, 表示当前container的IP地址
>>> 172.18.0.2
```
通过如下命令测试集群是否联网正常
```
echo stat | nc 172.18.0.2 2181
```
测试结果
```
Zookeeper version: 3.4.14-4c25d480e66aadd371de8bd2fd8da255ac140bcf, built on 03/06/2019 16:18 GMT
Clients:
 /172.18.0.1:56616[0](queued=0,recved=1,sent=0)

Latency min/avg/max: 0/0/0
Received: 3
Sent: 2
Connections: 1
Outstanding: 0
Zxid: 0x200000000
Mode: follower
Node count: 4
```
同样还有一种方式, 进入container中, 然后执行下面的命令
```
# 进入zookeeper1
docker exec -it zookeeper1 /bin/bash

# container中输入
./bin/zkServer.sh status
```
输出结果
```
root@zookeeper1:/zookeeper-3.4.14# ./bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /conf/zoo.cfg
Mode: follower
```

# 5、单服务器搭建docker版kafka集群

# 6、docker-compose.yml编写
##### 参考文献
[使用Docker快速搭建Zookeeper和kafka集群](https://blog.icocoro.me/2018/12/17/1812-docker-zookeeper-kafka/)

[docker简易搭建kafka](https://blog.csdn.net/belonghuang157405/article/details/82149257)

[Zookeeper和Kafka集群配置，非常详细的参数解读](https://baijiahao.baidu.com/s?id=1619850826376520795&wfr=spider&for=pc)

[图文详解使用Docker容器，进行Kafka单点和集群配置](https://cloud.tencent.com/developer/news/371290)

[使用docker安装kafka](https://blog.csdn.net/lblblblblzdx/article/details/80548294)

[python操作kafka实践](https://www.cnblogs.com/small-office/p/9399907.html)

[使用Docker快速搭建Kafka开发环境](https://www.jianshu.com/p/ac03f126980e)

[Docker搭建kafka和zookeeper](https://blog.csdn.net/qq_42595077/article/details/87450034)

[Docker中搭建Kafka集群以及让外网访问](https://blog.csdn.net/qq_41587243/article/details/80452343)

[docker极速搭建kafka 外网可以访问-已测试](https://blog.csdn.net/jiangkai16001519/article/details/83383865)

[使用docker安装kafka](https://blog.csdn.net/lblblblblzdx/article/details/80548294)

[docker容器搭建kafka集群](https://blog.51cto.com/13520772/2155004)

[单台centos7主机做zookeeper和kafka集群](https://blog.csdn.net/softmaker_tao/article/details/80395711)

[kafka 上手指南：集群版](https://cloud.tencent.com/developer/article/1537521)