---
title: "git常用命令"
layout: page
date: 2019-14-11 10:00
---
# 符号约定
- <xxx> 自定义内容
- [xxx] 可选内容
- [<xxx>] 自定义可选内容
# 初始设置
- ```git config --global user.name "<用户名>"``` 设置用户名
- ```git config --global user.email "<电子邮件>"``` 设置电子邮件
# 命令
## 本地操作
- ```git add [-i]``` 保存更新，-i为逐个确认。
- ```git status``` 检查更新。
- ```git commit [-a] -m "<更新说明>"``` 提交更新，-a为包含内容修改和增删， -m为说明信息，也可以使用 -am。
## 远端操作
- ```git clone <git地址>``` 克隆到本地。
- ```git fetch``` 远端抓取。
- ```git merge``` 与本地当前分枝合并。
- ```git pull [<远端别名>] [<远端branch>]``` 抓取并合并,相当于第2、3步
- ```git push [-f] [<远端别名>] [<远端branch>]``` 推送到远端，-f为强制覆盖
- ```git remote add <别名> <git地址>``` 设置远端别名
- ```git remote [-v]``` 列出远端，-v为详细信息
- ```git remote show <远端别名>``` 查看远端信息
- ```git remote rename <远端别名> <新远端别名>``` 重命名远端
- ```git remote rm <远端别名>``` 删除远端
- ```git remote update``` [<远端别名>] 更新分枝列表
## 分支相关
- ```git branch [-r] [-a]``` 列出分枝，-r远端 ,-a全部
- ```git branch <分枝名> ```新建分枝
- ```git checkout <分枝名> 切换到分枝
- ```git checkout -b <本地branch> [-t <远端别名>/<远端分枝>]``` -b新建本地分枝并切换到分枝, -t绑定远端分枝

## 删除远程仓库中的文件或者文件目录
```
# 删除的是本地仓库中的文件, 但是本地工作区的文件会保留且不再与远程仓库发生跟踪关系
git rm -r --cached [file]  # -r 删除文件目录
# 如果连本地工作区中的文件也要删除
git rm [-r] [file.txt]
```
删除之后 再通过 ```commit, push```等操作即可

## 协同流程
- 首先fork远程项目
- 把fork过去的项目也就是你的项目clone到你的本地
- 运行 git remote add <远端别名> <别人的远端分枝> 把别人的库添加为远端库
- 运行 git pull <远端别名> <远端分枝> 拉取并合并到本地
- 编辑内容
- commit后push到自己的库（git push <自己的远端别名> <自己的远端分枝>）
- 登陆Github在你首页可以看到一个 pull request 按钮，点击它，填写一些说明信息，然后提交即可。
**1~3是初始化操作，执行一次即可。在本地编辑内容前必须执行第4步同步别人的远端库（这样避免冲突），然后执行5~7既可。**

## 管理公共第三方lib
git subtree


# 参考文献

[Github 的项目怎么引用另一个项目？](https://segmentfault.com/q/1010000000670427)

[Git使用教程：最详细、最傻瓜、最浅显、真正手把手教！](https://mp.weixin.qq.com/s?__biz=MjM5NTg2NTU0Ng%3D%3D&chksm=bd5dde3b8a2a572dd32802287436d6bf5048975cd22984a182a967c8d3c35b22ec314f7a3022&idx=4&mid=2656602270&scene=0&sn=5e3842c5850ea0fd425c7886a0591ce4&xtrack=1#rd)