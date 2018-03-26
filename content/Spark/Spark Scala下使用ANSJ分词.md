---
title: "Spark Scala下使用ANSJ分词"
layout: page
date: 2018-03-21 14:00
---
[TOC]

# 写在前面
分词是中文文本处理过程中必不可少的一部分，本文结合自己的使用过程，给大家介绍使用scala调用ANSJ分词的方法。


# 获取jar包
项目中使用的sbt构建工具，所以jar包格式如下,jar包的版本都是最新版本，根据作者github中的建议这两个jar都使用最新的，但是ansj的5.1和5.0版本中的api改动比较大。本文主要介绍5.1里面的。
```
libraryDependencies += "org.ansj" % "ansj_seg" % "5.1.6"
libraryDependencies += "org.nlpcn" % "nlp-lang" % "1.7.7"
```

# 添加用户字典



# 参考文献

[nlpchina](http://nlpchina.github.io/)
[Ansj中文分词](https://github.com/NLPchina/ansj_seg)
[ansj分词史上最详细教程](https://blog.csdn.net/bitcarmanlee/article/details/53607776)
[用户自定义词典](https://github.com/NLPchina/ansj_seg/wiki/用户自定义词典)
[Spark + ansj 对大数据量中文进行分词](http://blog.csdn.net/xiao_jun_0820/article/details/50370230)
[spark scala 用ansj分词](http://blog.csdn.net/oZincO/article/details/70184347)
[ANSJ分词工具的具体操作！](http://blog.csdn.net/yuwen123/article/details/39340181)
[]()
[]()
[]()
[]()
