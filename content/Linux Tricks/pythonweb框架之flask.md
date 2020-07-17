---
title: "python Web框架之Flask"
layout: page
date: 2019-04-11 10:00
---
# 写在前面
初识Flask, 会觉得Flask很容易上手, 刚开始用flask也写过一些小项目, 当初对WEB服务器和WEB框架没有什么太多的概念, 天真的认为只要在服务器上用nohup跑一个python脚本就算成功发布了一个flask项目, 如果简单的拿来测试,则基本够用. 如果作为工程项目的话这还会面临很多的问题, 比如并发性不好, 不支持异步等等. 换句话说, 使用python web.py来启动一个flask服务的方式是为了进行本地开发调试, 线上运行时则要保证更高的性能和稳定性. 实际上, 真正的做法是用某些WEB容器或者WEB服务器来启动项目.


# WEB服务器和WEB容器
$\color{red}负责处理http请求，响应静态文件,$ 常见的有Apache，Nginx以及微软的IIS.
- Nginx


# 应用服务器
$\color{red}负责处理逻辑的服务器,$ 比如php, python的代码, 是不能直接通过nginx这种Web服务器直接来处理的,只能通过应用服务器来处理. 常见的应用服务器有uwsgi、tomcat等。

- uWSGI


# WEB框架
一般是$\color{red}使用某种语言, 封装了常用的web功能的框架,$ flask、 django和Java中的SSH(Structs2+Spring3+Hibernate3)框架都是web应用框架.
- Flask 

# 三者的关系


# docker下配置和使用flask


# 遇到的问题
docker下编写server的时候, app.run()中host应该改写为‘0.0.0.0’, 如果使用默认设置或者设置contenner的其他ip为host, docker宿主机将不能访问, 其中port已经做了映射, 所以感觉跟port没有关系, 

部分代码
```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def first_flask():
    print('hello word')
    return 'Hello, Word'

if __name__ ==  '__main__':
    app.run(host='0.0.0.0', port='8000')
```

浏览器中访问```192.168.79.1:18008```, 页面会返回Hello, Word, 其中‘192.168.79.1’为宿主机ip, 18008:8000为宿主机和docker的端口映射.


# flask部署
nginx一般是用来反向代理用的，还能处理静态文件、ip控制等，是比较专业并且高性能的web服务器 

gunicorn一般用来nohup、多进程和日志 

当然用flask直接裸跑也可以，但是这样很多轮子就要自己实现了。 最好还是加一层nginx，起码可以缓冲http请求，python本身应该有很多包也可以支持相应功能，不过有没人人维护这些东西，就不知道了，不建议用。我也没听说过，基本百度不到这些包的文档。 

将来业务起来了，如果需要水平拓展，flask裸跑会带来很多麻烦。

# 参考文献

[PythonWEB框架之Flask](https://www.cnblogs.com/sss4/p/8097653.html)

[Ubuntu16.04 部署Flask应用若干方法（Apache2、Nginx）](https://blog.csdn.net/tonydz0523/article/details/82701502)

[Ubuntu16.04 将 Flaskapp 部署到Heroku 上](https://blog.csdn.net/tonydz0523/article/details/82707569)

[使用Flask+uwsgi+Nginx部署Flask正式环境](https://www.missshi.cn/api/view/blog/5b1511a213d85b1251000000)

[Flask+uwsgi+Nginx+Ubuntu部署](https://www.cnblogs.com/leiziv5/p/7137277.html)

[Flask_项目部署Linux+uwsgi+nginx](https://www.liangzl.com/get-article-detail-38387.html)

[在 Ubuntu 上使用 uWSGI 和 Nginx 部署 Flask 项目](https://www.v2ex.com/t/386228)

[【Flask】 利用uWSGI和Nginx发布Flask应用](https://www.cnblogs.com/lfxiao/p/10103490.html)

[从零开始搭建论坛（一）：Web服务器与Web框架](https://www.cnblogs.com/houruikk/p/6623594.html)

[web服务器、应用服务器、web应用框架的关系](https://blog.csdn.net/feit2417/article/details/81387377)

[从零开始搭建论坛（一）：Web服务器与Web框架](https://www.jianshu.com/p/43571f938f22)

