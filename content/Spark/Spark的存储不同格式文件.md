---
title: "Spark的存储不同格式文件"
layout: page
date: 2018-06-02 00:00
---
[TOC]

# 写在前面
***PySpark的存储不同格式文件，如：存储为csv格式、json格式、parquet格式、compression格式、table***
```python
from __future__ import print_function, division
from pyspark import SparkConf, SparkContext
from pyspark.sql import SparkSession
```
## 启动 Spark （如果你已经启动就不需要）
```python
spark = SparkSession.builder.master("local[2]").appName("test").enableHiveSupport().getOrCreate()
sc = spark.sparkContext
```
## 1、存储为csv格式
```python
df_csv = spark.read.csv("../data/ratings.csv", header=True)
df_csv.show()
df_csv.write.csv('../output/rating.csv', header = True, mode = 'error') #保存数据
```
## 2、将文档保存在一个文件夹中
```shell
!ls -lh ../output/rating.csv  #根据数量保存多个文件
!head ../output/rating.csv/part-00001-aece805c-20a7-4225-b152-40316bc8fc5e-c000.csv
```
```python
df_csv.coalesce(1).write.csv('../output/rating2.csv', header = True)
```
```shell
!ls -lh ../output/rating.csv
```
## 3、存储为json格式
```python
df_csv.write.json('../output/rating.json',mode = 'overwrite')
```
```shell
!ls -lh ../output/rating.json   #根据数量保存多个文件
```
##注意：其中json的内存要比csv大（存储空间）

## 4、存储为parquet格式
```python
df_csv.write.parquet('../output/rating.parquet',mode = 'overwrite')
```
```shell
!ls -lh ../output/rating.parquet  #根据数量保存多个文件
```
### 列式存储
列式存储和行式存储相比有哪些优势呢？

1、可以跳过不符合条件的数据，只读取需要的数据，降低 IO 数据量。

2、压缩编码可以降低磁盘存储空间。由于同一列的数据类型是一样的，
可以使用更高效的压缩编码（例如 Run Length Encoding 和 Delta Encoding）进一步节约存储空间。

3、只读取需要的列，支持向量运算，能够获取更好的扫描性能。

### parquet常用操作
#### 创建parquet表
1.1 创建内部表

1.2 创建外部表

1.3 指定压缩算法
#### 读取parquet文件
用spark写parquet文件
```scala
val conf = new SparkConf().setAppName("test").setMaster("local")
val sc = new SparkContext(conf)
val sqlContext = new org.apache.spark.sql.SQLContext(sc)
 
// 读取文件生成RDD
val file = sc.textFile("hdfs://192.168.1.115:9000/test/user.txt")
 
 // 定义parquet的schema，数据字段和数据类型需要和hive表中的字段和数据类型相同，否则hive表无法解析
val schema = (new StructType)
      .add("name", StringType, true)
      .add("age", IntegerType, false)
 
val rowRDD = file.map(_.split("\t")).map(p => Row(p(0), Integer.valueOf(p(1).trim)))
// 将RDD装换成DataFrame
val peopleDataFrame = sqlContext.createDataFrame(rowRDD, schema)
peopleDataFrame.registerTempTable("people")
    peopleDataFrame.write.parquet("hdfs://192.168.1.115:9000/user/hive/warehouse/test_parquet/")
```
用pyspark读取parquet文件

```python
# encoding:utf-8
from pyspark import SparkConf, SparkContext
from pyspark.sql import HiveContext
from pyspark.sql.dataframe import DataFrame
import random
from pyspark.sql import Row

# Basic Data Configuration
APP_NAME = "DataClean1_getHDFSparquetFile"
parquetFile = "hdfs://192.168.136.134:9000/user/hadoop/people2.parquet"  # Which parquetFile to read
sparkURL = "spark://192.168.136.134:7077"
HADOOP_USER_NAME = "hadoop"

# Test Configuration
jsonFile = "hdfs://192.168.136.134:9000/user/hadoop/people.json"


def read_parquet(sc1):
    hive_ctx = HiveContext(sc1)
    # Python中的Parquet数据读取
    rows = hive_ctx.parquetFile(parquetFile)
    names = rows.map(lambda row: row.name)
    ages = rows.map(lambda row: row.age)
    print "Everyone"
    print names.collect()
    print ages.collect()
    row_collect = rows.collect()
    for line in row_collect:
        print line

    # 数据查询
    rows.registerTempTable("people")
    peoples = hive_ctx.sql("SELECT name,age FROM people WHERE age>24")
    print "people:"

    def function1(row):
        return row.name + "_" + str(row.age)

    list1 = peoples.map(function1).collect()
    for line in list1:
        print line
    print "End of the file"


def sample(p):
    x, y = random.random(), random.random()
    return 1 if x * x + y * y < 1 else 0


def save_test(sparkconf):
    maxnum = 2147483647 / 10000
    # count = sparkconf.parallelize(xrange(0, maxnum)).map(sample).reduce(lambda a, b: a + b)
    # print "Pi is roughly %f" % (4.0 * count / maxnum)

    # 打开hive
    print "Start Hive Context"
    hive_ctx = HiveContext(sparkconf)
    # 基本查询示例

    input1 = hive_ctx.jsonFile(jsonFile)
    input1.registerTempTable("people")
    top_tweets = hive_ctx.sql("SELECT name,age FROM people")
    print "top_tweets ==", top_tweets
    print "type(top_tweets) ==", type(top_tweets)
    print "top_tweets.map ==", top_tweets.map(lambda row: row.name).collect()

    assert isinstance(top_tweets, DataFrame)
    top_tweets.saveAsParquetFile("hdfs://192.168.136.134:9000/user/hadoop/people2.parquet")


if __name__ == "__main__":
    row = Row(name="Alice", age=11)
    print row.__str__()
    # Configure Spark
    conf = SparkConf().setAppName(APP_NAME)
    # conf = conf.set("spark.executor.memory", "512m")
    conf = conf.setMaster(sparkURL)
    conf = conf.set("HADOOP_USER_NAME", HADOOP_USER_NAME)
    # print conf.getAll()
    sc = SparkContext(conf=conf)
    sc.addPyFile("hdfsToSparkClean.py")

    # Execute Main functionality
    save_test(sc)
    read_parquet(sc)
```

### Flink读取kafka数据并以parquet格式写入HDFS，Spark直接读取parquet

大数据业务场景中，经常有一种场景：外部数据发送到kafka中，flink作为中间件消费kafka数据并进行业务处理；处理完成之后的数据可能还需要写入到数据库或者文件系统中，比如写入hdfs中；目前基于spark进行计算比较主流，需要读取hdfs上的数据，可以通过读取parquet.

### fastparquet
[fastparquet](https://pypi.org/project/fastparquet/)

## 5、存储为compression格式---压缩
```python
df_csv.write.csv('../output/rating_gzip.csv', header = True, compression = 'gzip')
```
```shell
!ls -lh ../output/rating_gzip.csv  #根据数量保存多个文件
```
## 6、存储为table
```python
spark.sql('show tables').show()
df_csv.write.saveAsTable('rating_csv')
spark.sql("select * from ratings_csv").show()
```


## 参考文献
[PySpark的存储不同格式文件](https://blog.csdn.net/xingxing1839381/article/details/81273351)

[parquet常用操作](https://cloud.tencent.com/developer/article/1356771)

[PySpark取hdfs中parquet数据](http://blog.sina.com.cn/s/blog_4b1452dd0102x2af.html)