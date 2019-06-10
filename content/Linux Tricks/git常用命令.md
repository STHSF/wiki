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
删除之后 再通过 ```commit, push```等操作即可, **注意, 执行 git rm之后, 只需要继续执行```git commit``` 和```git push```, 不需要执行```git add```. 否则```git rm```无效**

## 本地文件上传到github仓库
### 本地文件夹操作
1、 通过```git init```把当前目录变成git可以管理的仓库
```
# 进入本地文件夹主文件目录下
git init
```
init 之后, 文件目录下会生成.git文件夹, 然后当前会出现在mater分支下.

2、 执行 add, commit将文件提交到暂存区, 然后提交到仓库
```
git add .  # 添加到暂存区
git commit -m "first commit"  # 提交到仓库
```
### 关联远程仓库
1、如果不存在远程仓库, 则先在github上新建一个空的repo, 然后将本地仓库与远程仓库关联
```
git remote add origin 新建的远程仓库  
# 如 git remote add origin https://github.com/githubusername/demo.git
```

2、如果远程仓库不为空, 除了关联远程仓库, 还必须做下面该步骤
```
git pull --rebase origin master  # 获取远程仓库与本地仓库同步合并, 如果远程仓库不为空,则必须做这一步, 否则后面的提交会失败
```

### 本地文件上传
```
# 把本地库的内容推送到远程，使用 git push命令，实际上是把当前分支master推送到远程。执行此命令后会要求输入用户名、密码，验证通过后即开始上传。
git push -u origin master
```

## 协同流程
- 1、首先fork远程项目, 将远程仓库中的项目fork到本地仓库中,
- 2、把fork过去的项目也就是你的本地仓库中的项目clone到你的本地
- 3、运行 git remote add <远程仓库别名> <别人的远程仓库地址> 把别人的库添加为远端库, 并且取一个别名
- 4、运行 git pull <远程仓库别名> <远端分支> 拉取并合并到本地
- 5、编辑内容
- 6、add, commit后push到自己的库（git push <自己的远端别名> <自己的远端分枝>）
- 7、登陆Github在你首页可以看到一个 pull request 按钮，点击它，填写一些说明信息，然后提交即可。
**1~3是初始化操作，执行一次即可。在本地编辑内容前必须执行第4步同步别人的远端库（这样避免冲突），然后执行5~7既可。**

## 管理公共第三方lib
git subtree


## git 速查表
<center><img src="/wiki/static/images/linuxtricks/gitcommand.png" alt="git-command"/></center>

# 参考文献
[Github 的项目怎么引用另一个项目？](https://segmentfault.com/q/1010000000670427)

[Git使用教程：最详细、最傻瓜、最浅显、真正手把手教！](https://mp.weixin.qq.com/s?__biz=MjM5NTg2NTU0Ng%3D%3D&chksm=bd5dde3b8a2a572dd32802287436d6bf5048975cd22984a182a967c8d3c35b22ec314f7a3022&idx=4&mid=2656602270&scene=0&sn=5e3842c5850ea0fd425c7886a0591ce4&xtrack=1#rd)

[git删除远程仓库的文件或目录](https://www.cnblogs.com/toward-the-sun/p/6015284.html)

[使用GitHub进行团队合作](http://xiaocong.github.io/blog/2013/03/20/team-collaboration-with-github/)

[如何用命令将本地项目上传到git](https://www.cnblogs.com/eedc/p/6168430.html)

[提交 Merge Request 申请进行code review](https://blog.csdn.net/liuchunming033/article/details/87195568)

[git 使用流程规范（merge-request)](https://segmentfault.com/a/1190000007701719)

[GitLab 创建 merge request](https://blog.csdn.net/enlyhua/article/details/82875286)

[如何加入别人的Git项目——Git Fork指南](https://www.cnblogs.com/dky20155212/p/6821634.html?utm_source=itdadao&utm_medium=referral)

[git常用命令以及如何与fork别人的仓库保持同步](https://www.cnblogs.com/-walker/p/7278951.html)