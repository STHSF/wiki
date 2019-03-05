---
title: "JupyterHub 部署与应用指南"
layout: page
date: 2019-03-02 00:00
---
[TOC]

# 1、JupyterHub on Kubernetes部署与应用指南

# jupyterHub 安装
## 1、virtualenv 下安装与配置

### 安装jupyterhub
在装好的虚拟环境下安装jupyterhub,首先要保证使用的python版本是3.0以上的版本,官方说明只支持3.0以上的版本.
```
pip install jupyterhub
```
在使用pip安装的时候需要安装nodejs/npm，
```
sudo apt-get install npm nodejs-legacy
```
如果想要在本地运行notebook服务,还需要在本地安装jupyter notebook包
```
pip install --upgrade notebook
```

### 配置jupyterhub

```
jupyterhub --generate-config
```
这时候当前目录相面会生成```jupyterhub_config.py```的配置文件.
注, 如果想要在某个文件目录下生成,则需要在那个文件目录下运行上面的文件.

生成配置文件之后,可以进行适当的配置, 如

```
# 端口和ip
c.JupyterHub.ip = 'IP地址'
c.JupyterHub.port = 端口
```

```
# 参考github上jupyterhub的说明, 在/opt/nodejs 目录中安装
npm install -g configurable-http-proxy
注, 当然,不一定在opt目录下面, 可以通过whereis nodejs,查看你所安装的nodejs所在的位置,我的文件就保存在'/usr/local/lib/nodejs/node-v10.15.0/bin'下

c.JupyterHub.proxy_cmd = ['/opt/nodejs/bin/configurable-http-proxy',]
```

```
# 设置默认登陆jupyterhub后的目录,这是相对目录,用户登陆后会在当前用户的/notebook文件夹下,如果用户没有/notebook这个文件夹,启动过程可能会失败
c.Spawner.notebook_dir = '~/notebook'

# 该方式设置了绝对路径,所有用户登陆jupyterhub的时候,都会在'/home/ubuntu/notebook/'这个目录下
c.Spawner.notebook_dir = 'home/ubuntu/notebook'
```

### 创建多用户
首先除了当前root用户之外,我们还可以新建其他的用户作为普通用户,这个还是跟linux下添加用户一样
```
adduser user1
```
根据系统提示,设置密码和身份等东西.

设置完成之后在配置文件中添加相应的设置
```
1、添加普通用户
c.Authenticator.whitelist = {'user1'}

2、添加管理员
c.Authenticator.admin_users = {'ubuntu'}
```

### jupyterhub的启动配置

### 使用nohup让程序在后台运行.
注, 运行时好像需要在root用户下运行,其他用户运行可能会导致有的用户启动不了.如果想要使用sudo运行而不用root用户运行,可以参考[Using sudo to run JupyterHub without root privileges](https://github.com/jupyterhub/jupyterhub/wiki/Using-sudo-to-run-JupyterHub-without-root-privileges)
```
nohup jupyterhub > jupyterhub.log &
```
### 开机运行
开机配置
```
sudo cat  /etc/systemd/system/jupyterhub.service  
[Unit]
Description=Jupyterhub
After=syslog.target network.target

[Service]
User=root
ExecStart=/home/xyq/.jupyter/run_hub

[Install]
WantedBy=multi-user.target
```
启动
```
sudo systemctl enable jupyterhub # 开机自启动
sudo systemctl daemon-reload     # 加载配置文件
sudo systemctl start jupyterhub  # 启动
sudo journalctl -u jupyterhub    # 查看log
```

## 2、Docker 下运行jupyterhub


# 参考文献
[搭建一套云工作平台 (JupyterHub + Rstudio Server)](https://www.jianshu.com/p/fd9ddce53465)

[JupyterHub on Kubernetes部署与应用指南](https://my.oschina.net/u/2306127/blog/1837196)

[为JupyterHub自定义Notebook Images](https://www.liangzl.com/get-article-detail-16066.html)

[JupyterHub + toree安装说明](https://blog.csdn.net/vah101/article/details/79793006)

[jupyter notebook安装插件，代码补全](https://blog.csdn.net/Fire_to_cheat_/article/details/84938975)

[JupyterHub](https://jupyterhub.readthedocs.io/en/latest/index.html)

[Docker JupyterHub](https://hub.docker.com/r/jupyterhub/jupyterhub/)

[jupyterhub 安装配置](https://www.cnblogs.com/bregman/p/5744109.html)