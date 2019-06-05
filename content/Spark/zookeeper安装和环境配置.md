---
title: "zookeeper安装和环境配置"
layout: page
date: 2018-11-12 10:00
---

# 写在前面

```
docker run -itd --restart always --network=zk_test_default --name zookeeper1 -p 12181:2181 -v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper1/conf:/apache-zookeeper-3.5.5-bin/conf -v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper1/data:/data -v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper1/logdata:/datalog zookeeper


docker run -itd --restart always --network=zk_test_default --name zookeeper2 --hostname zookeeper2 -p 12181:2181 -v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper2/conf:/apache-zookeeper-3.5.5-bin/conf -v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper2/data:/data -v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper2/logdata:/datalog zookeeper


docker run -itd --restart always --network=zk_test_default --name zookeeper3 --hostname zookeeper3 -p 12181:2181 -v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper3/conf:/apache-zookeeper-3.5.5-bin/conf -v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper3/data:/data -v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper3/logdata:/datalog zookeeper


docker run -itd \
--restart always \
--name zookeeper1 \
--network=zk_test_default \
--hostname zookeeper1 \
-p 12181:2181 \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper1/conf:/conf \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper1/data:/data \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper1/logdata:/datalog \
zookeeper:3.4


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


docker run -itd \
--restart always \
--name zookeeper1 \
--hostname zookeeper1 \
-p 12181:2181 \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper1/conf:/conf \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper1/data:/data \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper1/logdata:/datalog \
zookeeper:3.4


docker run -itd \
--restart always \
--name zookeeper2 \
--hostname zookeeper2 \
-p 22181:2181 \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper2/conf:/conf \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper2/data:/data \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper2/logdata:/datalog \
zookeeper:3.4


docker run -itd \
--restart always \
--name zookeeper3 \
--hostname zookeeper3 \
-p 32181:2181 \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper3/conf:/conf \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper3/data:/data \
-v /home/jerry/workshop/virtualenv/zookeeper/zookeeper/zookeeper3/logdata:/datalog \
zookeeper:3.4


docker run -itd \
--restart always \
--name kafka1 \
--hostname=kafka1 \
--network zk_test_default \
--publish 19092:9092 --publish 19999:9999 \
--env JMX_PORT=9999 \
--env KAFKA_ADVERTISED_HOST_NAME=kafka1 \
--env KAFKA_ADVERTISED_PORT=19092 \
--env KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
--env KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://10.15.5.164:19092 \
--env KAFKA_ZOOKEEPER_CONNECT=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
--env KAFKA_BROKER_ID=1 \
wurstmeister/kafka:latest

docker run -itd \
--restart always \
--name kafka2 \
--hostname=kafka2 \
--network zk_test_default \
--publish 29092:9092 --publish 29999:9999 \
--env JMX_PORT=9999 \
--env KAFKA_ADVERTISED_HOST_NAME=kafka2 \
--env KAFKA_ADVERTISED_PORT=29092 \
--env KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
--env KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://10.15.5.164:29092 \
--env KAFKA_ZOOKEEPER_CONNECT=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
--env KAFKA_BROKER_ID=2 \
wurstmeister/kafka:latest

docker run -itd \
--restart always \
--name kafka3 \
--hostname=kafka3 \
--network zk_test_default \
--publish 39092:9092 --publish 39999:9999 \
--env JMX_PORT=9999 \
--env KAFKA_ADVERTISED_HOST_NAME=kafka3 \
--env KAFKA_ADVERTISED_PORT=39092 \
--env KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
--env KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://10.15.5.164:39092 \
--env KAFKA_ZOOKEEPER_CONNECT=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
--env KAFKA_BROKER_ID=3 \
wurstmeister/kafka:latest


bin/kafka-topics.sh --create --zookeeper 10.15.5.164:12181,10.15.5.164:22181,10.15.5.164:32181 --replication-factor 1 --partitions 1 --topic topic_docker_test

bin/kafka-topics.sh --list --zookeeper 10.15.5.164:12181,10.15.5.164:22181,10.15.5.164:32181

bin/kafka-console-producer.sh \
--topic=topic_docker_test1 \
--broker-list localhost:19092,localhost:29092,localhost:39092

bin/kafka-console-producer.sh \
--topic=topic_docker_test1 \
--broker-list 10.15.5.164:19092,10.15.5.164:29092,10.15.5.164:39092

bin/kafka-console-consumer.sh \
--topic=topic_docker_test1 \
--bootstrap-server localhost:19092,localhost:29092,localhost:39092 \
--from-beginning



docker run -itd \
--restart always \
--name kafka1 \
--hostname=kafka1 \
--network zk_test_default \
--publish 19092:9092 --publish 19999:9999 \
--env JMX_PORT=9999 \
--env KAFKA_ADVERTISED_HOST_NAME=kafka1 \
--env KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
--env KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://10.15.5.164:19092 \
--env KAFKA_ZOOKEEPER_CONNECT=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
--env KAFKA_BROKER_ID=1 \
wurstmeister/kafka:latest

docker run -itd \
--restart always \
--name kafka2 \
--hostname=kafka2 \
--network zk_test_default \
--publish 29092:9092 --publish 29999:9999 \
--env JMX_PORT=9999 \
--env KAFKA_ADVERTISED_HOST_NAME=kafka2 \
--env KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
--env KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://10.15.5.164:29092 \
--env KAFKA_ZOOKEEPER_CONNECT=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
--env KAFKA_BROKER_ID=2 \
wurstmeister/kafka:latest

docker run -itd \
--restart always \
--name kafka3 \
--hostname=kafka3 \
--network zk_test_default \
--publish 39092:9092 --publish 39999:9999 \
--env JMX_PORT=9999 \
--env KAFKA_ADVERTISED_HOST_NAME=kafka3 \
--env KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
--env KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://10.15.5.164:39092 \
--env KAFKA_ZOOKEEPER_CONNECT=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
--env KAFKA_BROKER_ID=3 \
wurstmeister/kafka:latest



```


# 参考文献
[kafka环境搭建和使用(python API)](https://www.cnblogs.com/iforever/p/9130983.html)
[Kafka单机配置部署](https://www.cnblogs.com/wonglu/p/8687488.html)
