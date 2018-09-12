---
title: "Ubuntu下搭建PySpark"
layout: page
date: 2018-06-02 00:00
---
[TOC]

# 写在前面
之前在公司做机器学习算法开发的时候使用的是scala编写spark代码，后来在接触了深度学习之后则更多的使用python来进行代码编写，但是spark是处理大数据的分布式集群，再大数据处理方面有很多优势。而且spark也支持python开发语言，所以就在公司的服务器上搭建了一个单机的pysaprk运行环境。

# 环境配置和安装包配置
## 系统环境
System：Ubuntu 16.04 LTS

## 安装包
1、Java JDK 版本
jdk1.8.0_161, [下载地址](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
PS:考虑到后面与scala的版本兼容性，所以安装的是java 8.

2、Spark 版本
spark-2.2.1-bin-hadoo2.7.tgz， [下载地址](http://spark.apache.org/downloads.html)
PS：为了搭建并运行pyspark，并没有太多考虑版本之间的一致性和兼容性等问题。

3、Scala 版本
Scala 2.11.12 [](http://www.scala-lang.org/download/2.11.12.html)
PS：这里面没有用到，但是我也装上了。

# 环境变量配置
与其他部分linux的安装包不同的是，这几个安装包都不需要编译，之间添加到环境变量中即可，所以我在～/.bash_profile中添加一下的内容即可。
```shell
 # Java path
 export JAVA_HOME=/home/jerry/workshop/virtualenv/jvm/jdk1.8.0_161
 export JRE_HOME=${JAVA_HOME}/jre
 export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
 export PATH=${JAVA_HOME}/bin:$PATH
  
 # spark path
 export SPARK_PATH=/home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7
 export PATH=$SCALA_PATH/bin:$PATH
 
 # scala path
 export SCALA_PATH=/home/jerry/workshop/virtualenv/spark/scala-2.11.12
 export PATH=$SPARK_PATH/bin:$PATH
```
添加完成之后不要忘记source一下，使环境生效。

## 环境测试
1、终端中输入```java -version```, 会显示下列内容。则表示java安装成功
```shell
java version "1.8.0_161"
Java(TM) SE Runtime Environment (build 1.8.0_161-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.161-b12, mixed mode)
```

2、终端中输入```pyspark```，会出现welcome to spark version 2.2.1的字样，并且会建立SparkSession会话，则表示spark安装成功。

3、终端中输入```scala -version```, 会出现下面的内容，则表示scala安装成功
```shell
Scala code runner version 2.11.12 -- Copyright 2002-2017, LAMP/EPFL
```

## 单机测试pyspark
在```${SPARKHOME}/examples/src/main/python/```文件下选取一个python脚本文件，然后使用pyspark执行脚本文件。本文选取的是pi.py，一个计算圆周率的脚本。
```
spark-submit pi.py
```
执行结果如下：
```
Using Spark's default log4j profile: org/apache/spark/log4j-defaults.properties
18/02/05 17:00:11 WARN Utils: Your hostname, jerry resolves to a loopback address: 127.0.1.1; using 10.15.5.179 instead (on interface enp3s0)
18/02/05 17:00:11 WARN Utils: Set SPARK_LOCAL_IP if you need to bind to another address
18/02/05 17:00:11 INFO SparkContext: Running Spark version 2.2.1
18/02/05 17:00:11 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
18/02/05 17:00:11 INFO SparkContext: Submitted application: PythonPi
18/02/05 17:00:11 INFO SecurityManager: Changing view acls to: jerry
18/02/05 17:00:11 INFO SecurityManager: Changing modify acls to: jerry
18/02/05 17:00:11 INFO SecurityManager: Changing view acls groups to:
18/02/05 17:00:11 INFO SecurityManager: Changing modify acls groups to:
18/02/05 17:00:11 INFO SecurityManager: SecurityManager: authentication disabled; ui acls disabled; users  with view permissions: Set(jerry); groups with view permissions: Set(); users  with modify permissions: Set(jerry); groups with modify permissions: Set()
18/02/05 17:00:12 INFO Utils: Successfully started service 'sparkDriver' on port 33337.
18/02/05 17:00:12 INFO SparkEnv: Registering MapOutputTracker
18/02/05 17:00:12 INFO SparkEnv: Registering BlockManagerMaster
18/02/05 17:00:12 INFO BlockManagerMasterEndpoint: Using org.apache.spark.storage.DefaultTopologyMapper for getting topology information
18/02/05 17:00:12 INFO BlockManagerMasterEndpoint: BlockManagerMasterEndpoint up
18/02/05 17:00:12 INFO DiskBlockManager: Created local directory at /tmp/blockmgr-420e496b-6493-4615-a5dd-5bec4a82f8dd
18/02/05 17:00:12 INFO MemoryStore: MemoryStore started with capacity 366.3 MB
18/02/05 17:00:12 INFO SparkEnv: Registering OutputCommitCoordinator
18/02/05 17:00:12 INFO Utils: Successfully started service 'SparkUI' on port 4040.
18/02/05 17:00:12 INFO SparkUI: Bound SparkUI to 0.0.0.0, and started at http://10.15.5.179:4040
18/02/05 17:00:12 INFO SparkContext: Added file file:/home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py at file:/home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py with timestamp 1517821212459
18/02/05 17:00:12 INFO Utils: Copying /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py to /tmp/spark-31161192-2b20-4179-92b9-19a0a871f5b4/userFiles-b1ef227d-6db3-4052-bb13-b6c73a6dfcd5/pi.py
18/02/05 17:00:12 INFO Executor: Starting executor ID driver on host localhost
18/02/05 17:00:12 INFO Utils: Successfully started service 'org.apache.spark.network.netty.NettyBlockTransferService' on port 38467.
18/02/05 17:00:12 INFO NettyBlockTransferService: Server created on 10.15.5.179:38467
18/02/05 17:00:12 INFO BlockManager: Using org.apache.spark.storage.RandomBlockReplicationPolicy for block replication policy
18/02/05 17:00:12 INFO BlockManagerMaster: Registering BlockManager BlockManagerId(driver, 10.15.5.179, 38467, None)
18/02/05 17:00:12 INFO BlockManagerMasterEndpoint: Registering block manager 10.15.5.179:38467 with 366.3 MB RAM, BlockManagerId(driver, 10.15.5.179, 38467, None)
18/02/05 17:00:12 INFO BlockManagerMaster: Registered BlockManager BlockManagerId(driver, 10.15.5.179, 38467, None)
18/02/05 17:00:12 INFO BlockManager: Initialized BlockManager: BlockManagerId(driver, 10.15.5.179, 38467, None)
18/02/05 17:00:12 INFO SharedState: Setting hive.metastore.warehouse.dir ('null') to the value of spark.sql.warehouse.dir ('file:/home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/spark-warehouse/').
18/02/05 17:00:12 INFO SharedState: Warehouse path is 'file:/home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/spark-warehouse/'.
18/02/05 17:00:13 INFO StateStoreCoordinatorRef: Registered StateStoreCoordinator endpoint
18/02/05 17:00:13 INFO SparkContext: Starting job: reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43
18/02/05 17:00:13 INFO DAGScheduler: Got job 0 (reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43) with 2 output partitions
18/02/05 17:00:13 INFO DAGScheduler: Final stage: ResultStage 0 (reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43)
18/02/05 17:00:13 INFO DAGScheduler: Parents of final stage: List()
18/02/05 17:00:13 INFO DAGScheduler: Missing parents: List()
18/02/05 17:00:13 INFO DAGScheduler: Submitting ResultStage 0 (PythonRDD[1] at reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43), which has no missing parents
18/02/05 17:00:13 INFO MemoryStore: Block broadcast_0 stored as values in memory (estimated size 4.6 KB, free 366.3 MB)
18/02/05 17:00:13 INFO MemoryStore: Block broadcast_0_piece0 stored as bytes in memory (estimated size 3.0 KB, free 366.3 MB)
18/02/05 17:00:13 INFO BlockManagerInfo: Added broadcast_0_piece0 in memory on 10.15.5.179:38467 (size: 3.0 KB, free: 366.3 MB)
18/02/05 17:00:13 INFO SparkContext: Created broadcast 0 from broadcast at DAGScheduler.scala:1006
18/02/05 17:00:13 INFO DAGScheduler: Submitting 2 missing tasks from ResultStage 0 (PythonRDD[1] at reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43) (first 15 tasks are for partitions Vector(0, 1))
18/02/05 17:00:13 INFO TaskSchedulerImpl: Adding task set 0.0 with 2 tasks
18/02/05 17:00:13 WARN TaskSetManager: Stage 0 contains a task of very large size (368 KB). The maximum recommended task size is 100 KB.
18/02/05 17:00:13 INFO TaskSetManager: Starting task 0.0 in stage 0.0 (TID 0, localhost, executor driver, partition 0, PROCESS_LOCAL, 377206 bytes)
18/02/05 17:00:13 INFO TaskSetManager: Starting task 1.0 in stage 0.0 (TID 1, localhost, executor driver, partition 1, PROCESS_LOCAL, 505009 bytes)
18/02/05 17:00:13 INFO Executor: Running task 1.0 in stage 0.0 (TID 1)
18/02/05 17:00:13 INFO Executor: Running task 0.0 in stage 0.0 (TID 0)
18/02/05 17:00:13 INFO Executor: Fetching file:/home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py with timestamp 1517821212459
18/02/05 17:00:13 INFO Utils: /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py has been previously copied to /tmp/spark-31161192-2b20-4179-92b9-19a0a871f5b4/userFiles-b1ef227d-6db3-4052-bb13-b6c73a6dfcd5/pi.py
18/02/05 17:00:13 INFO PythonRunner: Times: total = 155, boot = 107, init = 3, finish = 45
18/02/05 17:00:13 INFO PythonRunner: Times: total = 156, boot = 106, init = 4, finish = 46
18/02/05 17:00:13 INFO Executor: Finished task 1.0 in stage 0.0 (TID 1). 1313 bytes result sent to driver
18/02/05 17:00:13 INFO Executor: Finished task 0.0 in stage 0.0 (TID 0). 1313 bytes result sent to driver
18/02/05 17:00:13 INFO TaskSetManager: Finished task 0.0 in stage 0.0 (TID 0) in 230 ms on localhost (executor driver) (1/2)
18/02/05 17:00:13 INFO TaskSetManager: Finished task 1.0 in stage 0.0 (TID 1) in 220 ms on localhost (executor driver) (2/2)
18/02/05 17:00:13 INFO TaskSchedulerImpl: Removed TaskSet 0.0, whose tasks have all completed, from pool
18/02/05 17:00:13 INFO DAGScheduler: ResultStage 0 (reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43) finished in 0.242 s
18/02/05 17:00:13 INFO DAGScheduler: Job 0 finished: reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43, took 0.350820 s
Pi is roughly 3.140920
18/02/05 17:00:13 INFO SparkUI: Stopped Spark web UI at http://10.15.5.179:4040
18/02/05 17:00:13 INFO MapOutputTrackerMasterEndpoint: MapOutputTrackerMasterEndpoint stopped!
18/02/05 17:00:13 INFO MemoryStore: MemoryStore cleared
18/02/05 17:00:13 INFO BlockManager: BlockManager stopped
18/02/05 17:00:13 INFO BlockManagerMaster: BlockManagerMaster stopped
18/02/05 17:00:13 INFO OutputCommitCoordinator$OutputCommitCoordinatorEndpoint: OutputCommitCoordinator stopped!
18/02/05 17:00:13 INFO SparkContext: Successfully stopped SparkContext
18/02/05 17:00:14 INFO ShutdownHookManager: Shutdown hook called
18/02/05 17:00:14 INFO ShutdownHookManager: Deleting directory /tmp/spark-31161192-2b20-4179-92b9-19a0a871f5b4
18/02/05 17:00:14 INFO ShutdownHookManager: Deleting directory /tmp/spark-31161192-2b20-4179-92b9-19a0a871f5b4/pyspark-0869c290-8c14-4d55-b45f-bd0205856cfb
```
其中输出结果为：```Pi is roughly 3.140920```, 其他的都是日志信息.

# 简单配置启动spark
在这里使用的是standalone的方式来启动单机版spark，里面没有涉及到saprk集群。

直接运行```${SPARKHOME}/sbin/```目录下的```start-all.sh```文件。这时候master的启动没有问题，但是启动worker的时候问题出现。具体提示如下：
```
localhost: starting org.apache.spark.deploy.worker.Worker, logging to /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/logs/spark-jerry-org.apache.spark.deploy.worker.Worker-1-jerry.out
localhost: failed to launch: nice -n 0 /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/bin/spark-class org.apache.spark.deploy.worker.Worker --webui-port 8081 spark://jerry:7077
localhost:   JAVA_HOME is not set
localhost: full log in /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/logs/spark-jerry-org.apache.spark.deploy.worker.Worker-1-jerry.out
```

主要的由于java路径没有配置导致worker启动失败。

然后去```${SPARKHOME}/conf/```下面配置```saprk-env.sh```文件，在文件中添加javapath, 添加内容跟```.bash_profile```中的javapath一样。

添加完成之后重新运行```sbin/start-all.sh```, 错误消失。这时候就可以在浏览器中访问spark UI了。


# spark集群上运行文件
简单的搭建了一个仅有一个worker的spark集群,用来测试将python程序提交到spark集群上运行.

使用Spark的bin目录中的spark-submit脚本向集群中提交应用程序。该脚本不论cluster managers有何差异，提交作业时都有相同的接口，不必单独配置。

我们需要创建一个shell脚本,然后将所需要的运行的文件和相关参数写入,下面是一个运行pi.py的参考脚本.

```
# !/bin/sh
/home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/bin/spark-submit \
    --master spark://jerry:7077 \
    --total-executor-cores 12 \
    --executor-memory 10g \
    /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py \
    1000
```
运行结果(中间有所省略):
```
Using Spark's default log4j profile: org/apache/spark/log4j-defaults.properties
18/09/12 20:37:44 INFO SparkContext: Running Spark version 2.2.1
18/09/12 20:37:44 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
18/09/12 20:37:44 INFO SparkContext: Submitted application: PythonPi
18/09/12 20:37:44 INFO SecurityManager: Changing view acls to: jerry
18/09/12 20:37:44 INFO SecurityManager: Changing modify acls to: jerry
18/09/12 20:37:44 INFO SecurityManager: Changing view acls groups to:
18/09/12 20:37:44 INFO SecurityManager: Changing modify acls groups to:
18/09/12 20:37:44 INFO SecurityManager: SecurityManager: authentication disabled; ui acls disabled; users  with view permissions: Set(jerry); groups with view permissions: Set(); users  with modify permissions: Set(jerry); groups with modify permissions: Set()
18/09/12 20:37:45 INFO Utils: Successfully started service 'sparkDriver' on port 38295.
18/09/12 20:37:45 INFO SparkEnv: Registering MapOutputTracker
18/09/12 20:37:45 INFO SparkEnv: Registering BlockManagerMaster
18/09/12 20:37:45 INFO BlockManagerMasterEndpoint: Using org.apache.spark.storage.DefaultTopologyMapper for getting topology information
18/09/12 20:37:45 INFO BlockManagerMasterEndpoint: BlockManagerMasterEndpoint up
18/09/12 20:37:45 INFO DiskBlockManager: Created local directory at /tmp/blockmgr-4e134b1e-e8d6-4439-bbac-801b8235a579
18/09/12 20:37:45 INFO MemoryStore: MemoryStore started with capacity 4.1 GB
18/09/12 20:37:45 INFO SparkEnv: Registering OutputCommitCoordinator
18/09/12 20:37:45 INFO Utils: Successfully started service 'SparkUI' on port 4040.
18/09/12 20:37:45 INFO SparkUI: Bound SparkUI to 10.15.5.164, and started at http://10.15.5.164:4040
18/09/12 20:37:45 INFO SparkContext: Added file file:/home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py at spark://10.15.5.164:38295/files/pi.py with timestamp 1536755865385
18/09/12 20:37:45 INFO Utils: Copying /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py to /tmp/spark-5acd1f47-63b3-4c69-a92f-d78ea123e9ec/userFiles-738ac0fe-784f-4f2d-ab62-2131dbdc7316/pi.py
18/09/12 20:37:45 INFO StandaloneAppClient$ClientEndpoint: Connecting to master spark://jerry:7077...
18/09/12 20:37:45 INFO TransportClientFactory: Successfully created connection to jerry/10.15.5.164:7077 after 24 ms (0 ms spent in bootstraps)
18/09/12 20:37:45 INFO StandaloneSchedulerBackend: Connected to Spark cluster with app ID app-20180912203745-0018
18/09/12 20:37:45 INFO Utils: Successfully started service 'org.apache.spark.network.netty.NettyBlockTransferService' on port 45687.
18/09/12 20:37:45 INFO StandaloneAppClient$ClientEndpoint: Executor added: app-20180912203745-0018/0 on worker-20180912185636-10.15.5.164-44519 (10.15.5.164:44519) with 6 cores
18/09/12 20:37:45 INFO NettyBlockTransferService: Server created on 10.15.5.164:45687
18/09/12 20:37:45 INFO StandaloneSchedulerBackend: Granted executor ID app-20180912203745-0018/0 on hostPort 10.15.5.164:44519 with 6 cores, 10.0 GB RAM
18/09/12 20:37:45 INFO StandaloneAppClient$ClientEndpoint: Executor added: app-20180912203745-0018/1 on worker-20180912184804-10.15.5.178-46599 (10.15.5.178:46599) with 6 cores
18/09/12 20:37:45 INFO StandaloneSchedulerBackend: Granted executor ID app-20180912203745-0018/1 on hostPort 10.15.5.178:46599 with 6 cores, 10.0 GB RAM
18/09/12 20:37:45 INFO BlockManager: Using org.apache.spark.storage.RandomBlockReplicationPolicy for block replication policy
18/09/12 20:37:45 INFO BlockManagerMaster: Registering BlockManager BlockManagerId(driver, 10.15.5.164, 45687, None)
18/09/12 20:37:45 INFO BlockManagerMasterEndpoint: Registering block manager 10.15.5.164:45687 with 4.1 GB RAM, BlockManagerId(driver, 10.15.5.164, 45687, None)
18/09/12 20:37:45 INFO StandaloneAppClient$ClientEndpoint: Executor updated: app-20180912203745-0018/0 is now RUNNING
18/09/12 20:37:45 INFO StandaloneAppClient$ClientEndpoint: Executor updated: app-20180912203745-0018/1 is now RUNNING
18/09/12 20:37:45 INFO BlockManagerMaster: Registered BlockManager BlockManagerId(driver, 10.15.5.164, 45687, None)
18/09/12 20:37:45 INFO BlockManager: Initialized BlockManager: BlockManagerId(driver, 10.15.5.164, 45687, None)
18/09/12 20:37:45 INFO StandaloneSchedulerBackend: SchedulerBackend is ready for scheduling beginning after reached minRegisteredResourcesRatio: 0.0
18/09/12 20:37:45 INFO SharedState: Setting hive.metastore.warehouse.dir ('null') to the value of spark.sql.warehouse.dir ('file:/home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/spark-warehouse/').
18/09/12 20:37:45 INFO SharedState: Warehouse path is 'file:/home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/spark-warehouse/'.
18/09/12 20:37:46 INFO StateStoreCoordinatorRef: Registered StateStoreCoordinator endpoint
18/09/12 20:37:46 INFO CoarseGrainedSchedulerBackend$DriverEndpoint: Registered executor NettyRpcEndpointRef(spark-client://Executor) (10.15.5.178:58354) with ID 1
18/09/12 20:37:46 INFO BlockManagerMasterEndpoint: Registering block manager 10.15.5.178:42361 with 5.2 GB RAM, BlockManagerId(1, 10.15.5.178, 42361, None)
18/09/12 20:37:46 INFO CoarseGrainedSchedulerBackend$DriverEndpoint: Registered executor NettyRpcEndpointRef(spark-client://Executor) (10.15.5.164:54186) with ID 0
18/09/12 20:37:46 INFO BlockManagerMasterEndpoint: Registering block manager 10.15.5.164:44581 with 5.2 GB RAM, BlockManagerId(0, 10.15.5.164, 44581, None)
18/09/12 20:37:50 INFO SparkContext: Starting job: reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43
18/09/12 20:37:50 INFO DAGScheduler: Got job 0 (reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43) with 1000 output partitions
18/09/12 20:37:50 INFO DAGScheduler: Final stage: ResultStage 0 (reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43)
18/09/12 20:37:50 INFO DAGScheduler: Parents of final stage: List()
18/09/12 20:37:50 INFO DAGScheduler: Missing parents: List()
18/09/12 20:37:50 INFO DAGScheduler: Submitting ResultStage 0 (PythonRDD[1] at reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43), which has no missing parents
18/09/12 20:37:50 INFO MemoryStore: Block broadcast_0 stored as values in memory (estimated size 4.6 KB, free 4.1 GB)
18/09/12 20:37:50 INFO MemoryStore: Block broadcast_0_piece0 stored as bytes in memory (estimated size 3.0 KB, free 4.1 GB)
18/09/12 20:37:50 INFO BlockManagerInfo: Added broadcast_0_piece0 in memory on 10.15.5.164:45687 (size: 3.0 KB, free: 4.1 GB)
18/09/12 20:37:50 INFO SparkContext: Created broadcast 0 from broadcast at DAGScheduler.scala:1006
18/09/12 20:37:50 INFO DAGScheduler: Submitting 1000 missing tasks from ResultStage 0 (PythonRDD[1] at reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43) (first 15 tasks are for partitions Vector(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14))
18/09/12 20:37:50 INFO TaskSchedulerImpl: Adding task set 0.0 with 1000 tasks
18/09/12 20:37:50 WARN TaskSetManager: Stage 0 contains a task of very large size (363 KB). The maximum recommended task size is 100 KB.
18/09/12 20:37:50 INFO TaskSetManager: Starting task 0.0 in stage 0.0 (TID 0, 10.15.5.164, executor 0, partition 0, PROCESS_LOCAL, 372070 bytes)
18/09/12 20:37:50 INFO TaskSetManager: Starting task 1.0 in stage 0.0 (TID 1, 10.15.5.178, executor 1, partition 1, PROCESS_LOCAL, 508535 bytes)
18/09/12 20:37:50 INFO TaskSetManager: Starting task 2.0 in stage 0.0 (TID 2, 10.15.5.164, executor 0, partition 2, PROCESS_LOCAL, 503395 bytes)
18/09/12 20:37:50 INFO TaskSetManager: Starting task 3.0 in stage 0.0 (TID 3, 10.15.5.178, executor 1, partition 3, PROCESS_LOCAL, 508535 bytes)
18/09/12 20:37:50 INFO TaskSetManager: Starting task 4.0 in stage 0.0 (TID 4, 10.15.5.164, executor 0, partition 4, PROCESS_LOCAL, 508535 bytes)
18/09/12 20:37:50 INFO TaskSetManager: Starting task 5.0 in stage 0.0 (TID 5, 10.15.5.178, executor 1, partition 5, PROCESS_LOCAL, 503395 bytes)
18/09/12 20:37:50 INFO TaskSetManager: Starting task 6.0 in stage 0.0 (TID 6, 10.15.5.164, executor 0, partition 6, PROCESS_LOCAL, 508535 bytes)
18/09/12 20:37:50 INFO TaskSetManager: Starting task 7.0 in stage 0.0 (TID 7, 10.15.5.178, executor 1, partition 7, PROCESS_LOCAL, 508535 bytes)
18/09/12 20:37:50 INFO TaskSetManager: Starting task 8.0 in stage 0.0 (TID 8, 10.15.5.164, executor 0, partition 8, PROCESS_LOCAL, 503395 bytes)
18/09/12 20:37:50 INFO TaskSetManager: Starting task 9.0 in stage 0.0 (TID 9, 10.15.5.178, executor 1, partition 9, PROCESS_LOCAL, 508535 bytes)
18/09/12 20:37:50 INFO TaskSetManager: Starting task 10.0 in stage 0.0 (TID 10, 10.15.5.164, executor 0, partition 10, PROCESS_LOCAL, 508535 bytes)
18/09/12 20:37:50 INFO TaskSetManager: Starting task 11.0 in stage 0.0 (TID 11, 10.15.5.178, executor 1, partition 11, PROCESS_LOCAL, 503395 bytes)
.
.
.
18/09/12 20:37:51 INFO TaskSetManager: Finished task 9.0 in stage 0.0 (TID 9) in 628 ms on 10.15.5.178 (executor 1) (7/1000)
18/09/12 20:37:51 INFO TaskSetManager: Starting task 19.0 in stage 0.0 (TID 19, 10.15.5.178, executor 1, partition 19, PROCESS_LOCAL, 508535 bytes)
18/09/12 20:37:51 INFO TaskSetManager: Finished task 7.0 in stage 0.0 (TID 7) in 632 ms on 10.15.5.178 (executor 1) (8/1000)
18/09/12 20:37:51 INFO TaskSetManager: Starting task 20.0 in stage 0.0 (TID 20, 10.15.5.164, executor 0, partition 20, PROCESS_LOCAL, 503395 bytes)
.
.
.
18/09/12 20:37:51 INFO TaskSetManager: Starting task 24.0 in stage 0.0 (TID 24, 10.15.5.178, executor 1, partition 24, PROCESS_LOCAL, 508535 bytes)
18/09/12 20:37:51 INFO TaskSetManager: Finished task 3.0 in stage 0.0 (TID 3) in 657 ms on 10.15.5.178 (executor 1) (11/1000)
18/09/12 20:37:51 INFO TaskSetManager: Finished task 11.0 in stage 0.0 (TID 11) in 650 ms on 10.15.5.178 (executor 1) (12/1000)
18/09/12 20:37:51 INFO TaskSetManager: Finished task 5.0 in stage 0.0 (TID 5) in 656 ms on 10.15.5.178 (executor 1) (13/1000)
.
.
.
.
18/09/12 20:38:01 INFO TaskSetManager: Finished task 992.0 in stage 0.0 (TID 992) in 88 ms on 10.15.5.164 (executor 0) (989/1000)
18/09/12 20:38:01 INFO TaskSetManager: Finished task 993.0 in stage 0.0 (TID 993) in 87 ms on 10.15.5.164 (executor 0) (990/1000)
18/09/12 20:38:01 INFO TaskSetManager: Finished task 974.0 in stage 0.0 (TID 974) in 259 ms on 10.15.5.178 (executor 1) (991/1000)
18/09/12 20:38:01 INFO TaskSetManager: Finished task 995.0 in stage 0.0 (TID 995) in 74 ms on 10.15.5.164 (executor 0) (992/1000)
...
18/09/12 20:38:01 INFO TaskSetManager: Finished task 994.0 in stage 0.0 (TID 994) in 259 ms on 10.15.5.178 (executor 1) (999/1000)
18/09/12 20:38:01 INFO TaskSetManager: Finished task 997.0 in stage 0.0 (TID 997) in 256 ms on 10.15.5.178 (executor 1) (1000/1000)
18/09/12 20:38:01 INFO TaskSchedulerImpl: Removed TaskSet 0.0, whose tasks have all completed, from pool
18/09/12 20:38:01 INFO DAGScheduler: ResultStage 0 (reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43) finished in 10.780 s
18/09/12 20:38:01 INFO DAGScheduler: Job 0 finished: reduce at /home/jerry/workshop/virtualenv/spark/spark-2.2.1-bin-hadoop2.7/examples/src/main/python/pi.py:43, took 10.921910 s
Pi is roughly 3.140942
18/09/12 20:38:01 INFO SparkUI: Stopped Spark web UI at http://10.15.5.164:4040
18/09/12 20:38:01 INFO StandaloneSchedulerBackend: Shutting down all executors
18/09/12 20:38:01 INFO CoarseGrainedSchedulerBackend$DriverEndpoint: Asking each executor to shut down
18/09/12 20:38:01 INFO MapOutputTrackerMasterEndpoint: MapOutputTrackerMasterEndpoint stopped!
18/09/12 20:38:01 INFO MemoryStore: MemoryStore cleared
18/09/12 20:38:01 INFO BlockManager: BlockManager stopped
18/09/12 20:38:01 INFO BlockManagerMaster: BlockManagerMaster stopped
18/09/12 20:38:01 INFO OutputCommitCoordinator$OutputCommitCoordinatorEndpoint: OutputCommitCoordinator stopped!
18/09/12 20:38:01 INFO SparkContext: Successfully stopped SparkContext
18/09/12 20:38:02 INFO ShutdownHookManager: Shutdown hook called
18/09/12 20:38:02 INFO ShutdownHookManager: Deleting directory /tmp/spark-5acd1f47-63b3-4c69-a92f-d78ea123e9ec
18/09/12 20:38:02 INFO ShutdownHookManager: Deleting directory /tmp/spark-5acd1f47-63b3-4c69-a92f-d78ea123e9ec/pyspark-39c9b83e-95ef-40f1-b147-47acb20db5d3
```
可以跟上面的运行提示相互对比一下.


# 参考文献
[Spark集群模式&Spark程序提交](https://blog.csdn.net/lsshlsw/article/details/40272693)