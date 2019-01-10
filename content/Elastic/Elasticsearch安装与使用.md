---
title: "Elasticsearch安装与使用"
layout: page
date: 2019-01-11 10:00
---
# 安装配置elasticSearch

# 安装配置搜索引擎的管理工具kibana

# 安装和配置logstash数据导入工具

# elastic 查询语句

```
GET /tesdb/_search
{
  "query": {
    "match_all": {}
  }
}
```

```
DELETE .monitoring-es-6-2019.01.08
```

```
GET _analyze?pretty
{
  "analyzer": "ik_smart",
  "text": "王者荣耀是最好玩的游戏"
}
```

```
POST /tesdb/doc/_search
{
  "query": {
    "match_phrase": {
      "summary": "业绩下滑"
    }
  },
  "highlight": {
    "fields": {
      "titles": {}
      , "summary": {}
    },
    "pre_tags": [
      "<em>"
    ],
    "post_tags": [
      "</em>"
    ]
  }
}
```
```
POST /tesdb/doc/_search
{
  "query": {
  "bool": {
    "must": [
      { "match_phrase": { "summary": "主要观点" } },
      { "match_phrase": { "summary": "投资要点" } }
      ]
    }
  }
}
```

```
POST /tesdb/doc/_search
{
  "query": {
  "bool": {
    "must": [
      { "match_phrase": { "summary": "成长空间" } },
      { "match_phrase": { "summary": "高增长" } }
      ]
    }
  },
  "highlight": {
    "fields": {
      "titles": {},
      "summary": {}
    }
  }
}
```
```
POST /tesdb/doc/_search
{
  "query": {
    "multi_match": {
      "type": "most_fields",
      "query": "业绩下滑",
      "fields": [ "titles", "summary" ]
    }
  },
  "highlight": {
    "fields": {
      "titles": {},
      "summary": {}
    }
  }
}
```
```
POST /tesdb/doc/_search
{
"query": {
    "bool": {
      "must_not": [
        { "match": { "summary": "中兴通讯" } },
        { "match": { "summary": "诉讼" } },
        { "match": { "summary": "增长" } },
        { "match": { "summary": "增速" } }
      ],
      "must": [
        { "match": { "summary": "业绩下滑" } },
        { "match": { "summary": "看淡" } },
        { "match": { "summary": "拐点" } },
        { "match": { "summary": "低于预期" } }
      ]
      }
    }
}
```
```
POST /tesdb/doc/_search
{
  "query": {
    "bool": {
    "must": [
      {
          "multi_match": {
            "query":      "成长空间",
            "type":       "phrase_prefix",
            "fields":     [ "titles","summary" ]
          }
        },
        {
          "multi_match" : {
            "query":      "高增长",
            "type":       "phrase_prefix",
            "fields":     [ "titles","summary" ]
          }
        }
      ]
    }
  },
  "highlight": {
    "fields": {
      "titles": {},
      "summary": {}
    }
  }
}
```

# 参考文献
[Python分布式爬虫打造搜索引擎完整版-基于Scrapy、Redis、elasticsearch和django打造一个完整的搜索引擎网站](https://blog.csdn.net/qq_23079443/article/details/73920584)

[python使用elasticsearch](https://blog.csdn.net/u011183517/article/details/79482774)

[Python ElasticSearch基础教程](https://blog.csdn.net/liuzemeeting/article/details/80708035)

[elasticsearch配合mysql实现全文搜索](https://www.cnblogs.com/eleven24/p/7733052.html)

[ElasticSearch启动报错，bootstrap checks failed](https://blog.csdn.net/feng12345zi/article/details/80367907)

[Kibana（一张图片胜过千万行日志）](https://www.cnblogs.com/cjsblog/p/9476813.html)

[Ubuntu 下安装Kibana和logstash](https://www.cnblogs.com/saintaxl/p/3946667.html)

[Logstash 介绍及linux下部署](https://blog.csdn.net/MasonQAQ/article/details/77992252)

[linux系统安装和配置logstash数据导入工具](https://blog.csdn.net/alan_liuyue/article/details/78905953)

[如何在CentOS 7上安装Elasticsearch，Logstash和Kibana（弹性）](https://www.howtoing.com/how-to-install-elasticsearch-logstash-and-kibana-elastic-stack-on-centos-7)

[elasticsearch配合mysql实现全文搜索](https://www.cnblogs.com/eleven24/p/7733052.html)

[利用logstash的logstash-input-jdbc插件实现mysql增量导入ES的介绍](https://blog.csdn.net/yeyuma/article/details/50240595#quote)

[MySQL Connector/J » 8.0.13](https://mvnrepository.com/artifact/mysql/mysql-connector-java/8.0.13)

[logstash 的tracking_column提示找不到追踪字段](https://elasticsearch.cn/question/4015)

[logstash-input-jdbc同步mysql数据到elasticsearch](https://segmentfault.com/a/1190000011784259)

[logstash-jdbc的一次坑-sql数据库索引数据到elasticsearch时间字段格式化](https://blog.csdn.net/qq_18895659/article/details/79714831)
[利用logstash的logstash-input-jdbc插件实现mysql增量导入ES的介绍](https://blog.csdn.net/yeyuma/article/details/50240595#quote)

[通过Logstash由MySQL和SQL Server向Elasticsearch导入数据](https://segmentfault.com/a/1190000011061797#articleHeader12)

[安装X-Pack插件之后Logstash无法连接Elasticsearch](https://www.jianshu.com/p/cf21af48c8e2)

