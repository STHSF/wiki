---
title: "Mac下使用simiki搭建个人wiki"
layout: page
date: 2017-06-02 00:00
---
[TOC]

# 写在前面
本人搭建个人wiki也是机缘巧合，最近一直在尝试学习一点前端的知识，尝试着使用github弄个[个人博客](https://sthsf.github.io/)啥的玩玩，扩充自己的知识。同时，自己从事算法类的工作，其实也是程序猿的一种啦，这两天在网上查找资料的时候发现了[tracholar](https://tracholar.github.io/wiki/)的个人wiki，我觉得写得不错，同时也是整理自己平时学习的东西的一个好的方案。我也尝试了很多知识管理类的软件，比如百度云笔记，Evrnote等都觉得不是很方便。主要是搜索起来比较麻烦，不便于记忆。于是尝试使用这个个人wiki。

# simiki介绍
Simiki 是一个简单的个人Wiki框架。使用Markdown书写Wiki, 生成静态HTML页面。Wiki源文件按目录分类存放, 方便管理维护。


## 目录结构
主要介绍一下content和output两个文件夹。

使用simiki新建初始化(_simiki init_)之后会出现四个文件或文件夹，其中content下存储的是源文件(目前只支持markdown)，后面使用simiki g编译的时候会将content下的文件编译成静态文件目录，并存放到output中。

## simiki quick start
个人觉得simiki还是比较容易上手的，具体的安装见[QuickStart](http://simiki.org/quickstart.html)

# Mac下部署
本文中关于simiki的部署主要还是参考官网，但对于新手来说还是有一定的坑的，所以我把整个流程再详细的解释一遍。

在这之前本人已经在github中使用了[sthsf.github.io](https://sthsf.github.io)，所以只需要重新新建一个wiki仓库。

在github中新建完wiki仓库后，clone到本地

```
git clone https://github.com/yourUsername/wiki.git
```
进入wiki文件夹，然后simiki初始化

```
cd wiki
simiki init
simiki q
```
这时候原来clone下来的wiki空文件夹里面会产生几个文件和文件夹。这时候如何将github.io与这个wiki仓库链接起来呢？

simiki官网给了一个方法：安装Fabric，并且在生成的_config.yml中添加deploy配置项：

```
deploy：
    - type: git
      remote: origin
      branch: gh-pages
```
该段代码的作用就是将output目录下生成的子文件或者子文件目录，基于git的方式，推送到远程仓库相应的分支下。

当然这里需要注意的是我们需要安装ghp-import，同时要确认本地和远程仓库关联了。
然后直接执行部署命令即可。

```
fab delpoy
```

此时就可以通过访问yourUserName.github.io/wiki来访问你的个人git了。

在**windows下的部署**可以参考tracholar同学的博客。写的也比较详细。

很多人要问那我写的东西如何发布到上面去呢？
# 网页发布流程 #

首先需要注意的是目前simiki仅支持markdown的格式，因此我们每次的文章都需要用markdown的形式来书写，同时还要注意每个markdown都需要添加类似于头文件的东西，如

```
---
title: "Getting Started"
layout: page
date: 2099-06-02 00:00
---

```
如果每个markdown中没有上面的文件内容，你在使用simiki g编译的时候会报下面的错误:

```
Traceback (most recent call last):
  File "/usr/local/bin/simiki", line 11, in <module>
    sys.exit(main())
  File "/Library/Python/2.7/site-packages/simiki/cli.py", line 404, in main
    generator.generate(include_draft=args['--draft'])
  File "/Library/Python/2.7/site-packages/simiki/cli.py", line 181, in generate
    self.generate_tags()
  File "/Library/Python/2.7/site-packages/simiki/cli.py", line 217, in generate_tags
    meta, _ = g.get_meta_and_content(do_render=False)
  File "/Library/Python/2.7/site-packages/simiki/generators.py", line 135, in get_meta_and_content
    meta_str, content_str = self.extract_page(self._src_file)
  File "/Library/Python/2.7/site-packages/simiki/generators.py", line 203, in extract_page
    raise Exception('extracting page with format error, '
Exception: extracting page with format error, see <http://simiki.org/docs/metadata.html>

```
这也是我在写文章的时候遇到的一个坑，害得我重新创建了很多次。

当我们文章写好后就可以发布出去了，这时候使用simiki g命令来编译。编译成功后使用命令：

```
fab deploy
```
就可以将output中的文件／文件目录提交到gh-pages分支并推送到remote地址。当然如果熟悉github代码更新的同学不妨可以自己提交更新。

这时候你就可以在yourUserName.github.ig/wiki下看到你发布的内容了。

最后一步就是将你写的文件提交到master分支上即可，由于output下存的是静态页面，每次添加都会改变，所以我们可以在gitignore中将其忽略提交。

**注**:其他的部署方式可以参见[simiki](http://simiki.org/zh-docs/deploy.html)官网。

本文也参考了tracholar同学的作品。
页面下的评论参考的是[gitment](https://imsun.net/posts/gitment-introduction/)的内容

# 注意：本文使用的python环境为python2版本，如果使用python3版本fab可能会报错。




