---
title: "git常用操作"
layout: page
date: 2018-11-30 00:00
---
[TOC]

# 写在前面

# 常用操作

Administrator@HTBJUOLFUL4H7CK MINGW64 /f/workplace_2/ein (master)
$ git branch branch_name

Administrator@HTBJUOLFUL4H7CK MINGW64 /f/workplace_2/ein (master)
$ git checkout branch_name
Switched to branch 'branch_name'

Administrator@HTBJUOLFUL4H7CK MINGW64 /f/workplace_2/ein (branch_name)

(1)$ git add *

	Administrator@HTBJUOLFUL4H7CK MINGW64 /f/workplace_2/ein (branch_name)

(2)$ git status
	On branch branch_name
	nothing to commit, working directory clean

	Administrator@HTBJUOLFUL4H7CK MINGW64 /f/workplace_2/ein (branch_name)

(3)$ git commit -m "first commit"
	On branch branch_name
	nothing to commit, working directory clean

	Administrator@HTBJUOLFUL4H7CK MINGW64 /f/workplace_2/ein (branch_name)
	
(4)$ git pull (好像是)

(5)推送
	git push origin branch_name
	
(6)$ git pull git@github.com:smartdata-x/nlp.git  develop




# 参考文献