---
title: "pythonweb框架之flask"
layout: page
date: 2019-04-11 10:00
---
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

# 参考文献:q

[PythonWEB框架之Flask](https://www.cnblogs.com/sss4/p/8097653.html)
[Ubuntu16.04 部署Flask应用若干方法（Apache2、Nginx）](https://blog.csdn.net/tonydz0523/article/details/82701502)
[Ubuntu16.04 将 Flaskapp 部署到Heroku 上](https://blog.csdn.net/tonydz0523/article/details/82707569)

