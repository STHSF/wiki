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
1、pull 一个纯净的ubuntu环境
2、进入ubuntu,安装相关软件
```
python3
vim
```
可以参见[docker使用教程](https://sthsf.github.io/wiki/Linux%20Tricks/docker%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B.html)和[python3.5升级到python3.6](https://sthsf.github.io/wiki/Linux%20Tricks/python3.5%E5%8D%87%E7%BA%A7%E5%88%B0python3.6.html)中的相关内容.

3、安装基于python3的虚拟环境
参考[virtualenv使用教程](https://sthsf.github.io/wiki/Linux%20Tricks/virtualenv%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B.html)

4、配置好之后进入虚拟环境,使用pip安装和生成jupyterhub配置文件,同上文.
在执行过程中会出现下面的错误,正确的使用方式如下:
**不使用npm安装configurable-http-proxy**
直接从源码安装nodejs,安装方法见[官网Installation](https://github.com/nodejs/help/wiki/Installation),我这里为了方便,直接将源码放在虚拟环境的conf文件夹下.
然后在```~/.bashrc```中添加环境变量

```
export NODEJS_HOME=/usr/local/lib/nodejs/node-v10.15.0/bin
export PATH=$NODEJS_HOME:$PATH
export NODEJS_HOME
```
其中,```node-v10.15.0```就是自己下载的源码压缩包解压缩的内容.

使用源码安装配置的nodejs版本为```v10.15.0```, 官网说源码自带npm, 里面的npm版本为```6.6.0```

所有才有前文,我的nodejs的文件目录跟默认的安装路径的区别

5、在配置文件目录下运行jupyterhub,其他配置没有改变,结束.

**错误**
有人在使用sudo apt-get install npm nodejs-legacy的时候,安装完成后就算在jupyterhub_configure.py下配置了configurable-http-proxy的路径,或者使用```configurable-http-proxy -h```的时候会出现下面的问题,主要是nodejs安装版本可能比较低

使用```sudo apt-get install npm```安装完成之后,查看npm的版本```npm -v```, 版本号为```3.5.2```

使用```sudo apt-get install nodejs-legacy```安装完成之后,查看npm的版本```npm -v```, 版本号为```v4.2.6```

使用```npm install -g configurable-http-proxy``` 安装会出现下面的提示
```
- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
loadRequestedDeps         \ |###############################-----------------------------------------------------------------------------------------------------------------------|
loadDep:winston -> header | |###############################-----------------------------------------------------------------------------------------------------------------------|
loadDep:winston-transport - |####################################################--------------------------------------------------------------------------------------------------|
/usr/local/bin/configurable-http-proxy -> /usr/local/lib/node_modules/configurable-http-proxy/bin/configurable-http-proxy
/usr/local/lib
`-- configurable-http-proxy@4.0.1
  +-- commander@2.19.0
  +-- http-proxy@1.17.0
  | +-- eventemitter3@3.1.0
  | +-- follow-redirects@1.7.0
  | | `-- debug@3.2.6
  | `-- requires-port@1.0.0
  +-- lynx@0.2.0
  | +-- mersenne@0.0.4
  | `-- statsd-parser@0.0.4
  +-- strftime@0.10.0
  `-- winston@3.1.0
    +-- async@2.6.2
    | `-- lodash@4.17.11
    +-- diagnostics@1.1.1
    | +-- colorspace@1.1.1
    | | +-- color@3.0.0
    | | | +-- color-convert@1.9.3
    | | | | `-- color-name@1.1.3
    | | | `-- color-string@1.5.3
    | | |   `-- simple-swizzle@0.2.2
    | | |     `-- is-arrayish@0.3.2
    | | `-- text-hex@1.0.0
    | +-- enabled@1.0.2
    | | `-- env-variable@0.0.5
    | `-- kuler@1.0.1
    |   `-- colornames@1.1.1
    +-- is-stream@1.1.0
    +-- logform@1.10.0
    | +-- colors@1.3.3
    | +-- fast-safe-stringify@2.0.6
    | +-- fecha@2.3.3
    | `-- ms@2.1.1
    +-- one-time@0.0.4
    +-- readable-stream@2.3.6
    | +-- core-util-is@1.0.2
    | +-- inherits@2.0.3
    | +-- isarray@1.0.0
    | +-- process-nextick-args@2.0.0
    | +-- safe-buffer@5.1.2
    | +-- string_decoder@1.1.1
    | `-- util-deprecate@1.0.2
    +-- stack-trace@0.0.10
    +-- triple-beam@1.3.0
    `-- winston-transport@4.3.0
```

使用```configurable-http-proxy -h```检查
```
/usr/local/lib/node_modules/configurable-http-proxy/node_modules/winston/lib/winston.js:11
const { warn } = require('./winston/common');
      ^

SyntaxError: Unexpected token {
    at exports.runInThisContext (vm.js:53:16)
    at Module._compile (module.js:374:25)
    at Object.Module._extensions..js (module.js:417:10)
    at Module.load (module.js:344:32)
    at Function.Module._load (module.js:301:12)
    at Module.require (module.js:354:17)
    at require (internal/module.js:12:17)
    at Object.<anonymous> (/usr/local/lib/node_modules/configurable-http-proxy/bin/configurable-http-proxy:14:13)
    at Module._compile (module.js:410:26)
    at Object.Module._extensions..js (module.js:417:10)
```
上面的安装步骤都是正确的,而且没有报错,官网[issue](https://github.com/jupyterhub/jupyterhub/issues/2332)中有关于他的问题,里面有人提到npm的版本问题,于是到node的官网查看,发现node的版本都已经10以上了,而npm安装的版本才4.推测可能是版本太低,不兼容所致.

于是尝试升级npm,node,结果没有成效.最终的解决方法是直接从官网把源码下下来,然后配置一下环境变量,具体参见前面的操作步骤

后面我不甘心,又使用```whereis nodejs```将安装路径找出来.
```
nodejs: /usr/bin/nodejs /usr/lib/nodejs /usr/include/nodejs /usr/share/nodejs /usr/share/man/man1/nodejs.1.gz
```
然后找到```configurable-http-proxy```的安装目录```/usr/local/lib/node_modules/configurable-http-proxy```,将它添加到jupyterhub_config.py中,然后运行jupyterhub.

之前的问题没了,后面又出现了下面的问题:
```
[I 2019-03-07 14:54:04.979 JupyterHub proxy:567] Starting proxy @ http://:8000
[C 2019-03-07 14:54:04.980 JupyterHub app:1867] Failed to start proxy
    Traceback (most recent call last):
      File "/usr/local/lib/python3.6/dist-packages/jupyterhub/app.py", line 1865, in start
        await self.proxy.start()
      File "/usr/local/lib/python3.6/dist-packages/jupyterhub/proxy.py", line 571, in start
        self.proxy_process = Popen(cmd, env=env, start_new_session=True, shell=shell)
      File "/usr/lib/python3.6/subprocess.py", line 709, in __init__
        restore_signals, start_new_session)
      File "/usr/lib/python3.6/subprocess.py", line 1344, in _execute_child
        raise child_exception_type(errno_num, err_msg, err_filename)
    PermissionError: [Errno 13] Permission denied: '/usr/local/lib/node_modules/configurable-http-proxy'
```
权限问题,一脸懵,所有的操作都是root用户,又去查看了node_modules这个文件,发现用户名是nobody,又是一脸懵.算了,使用777修改文件夹的权限.修改完之后重新运行jupyterhu还是同样的问题,这个问题就没有解决了,替换上面的nodejs的使用方式之后两个问题都没有出现.

**ps**,之前学习使用nodejs的时候刚开始也是使用npm来做程序管理的,但是是由于npm一直无法更新到最新,后来才从源码安装的.






# 
# 参考文献
[搭建一套云工作平台 (JupyterHub + Rstudio Server)](https://www.jianshu.com/p/fd9ddce53465)

[JupyterHub on Kubernetes部署与应用指南](https://my.oschina.net/u/2306127/blog/1837196)

[为JupyterHub自定义Notebook Images](https://www.liangzl.com/get-article-detail-16066.html)

[JupyterHub + toree安装说明](https://blog.csdn.net/vah101/article/details/79793006)

[jupyter notebook安装插件，代码补全](https://blog.csdn.net/Fire_to_cheat_/article/details/84938975)

[JupyterHub](https://jupyterhub.readthedocs.io/en/latest/index.html)

[Docker JupyterHub](https://hub.docker.com/r/jupyterhub/jupyterhub/)

[jupyterhub 安装配置](https://www.cnblogs.com/bregman/p/5744109.html)

[Zero to JupyterHub with Kubernetes](https://zero-to-jupyterhub.readthedocs.io/en/latest/)

[在AWS上配置jupyterhub](https://www.jianshu.com/p/0285feaa2ba2)