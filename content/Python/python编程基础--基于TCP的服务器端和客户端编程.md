---
title: "python编程基础--基于TCP的服务器端和客户端编程"
layout: page
date: 2019-04-23 00:00
---
[TOC]

# 写在前面

需求：编写一个基于TCP的简单的服务器程序，它接收客户端连接，把客户端发过来的字符串加上Hello再发回去。

实际代码：
服务端代码
```python 
#! /usr/bin/env python
# -*- coding: utf-8 -*-

import socket,threading,time # 导入socket库
# 创建一个socket对象，AF_INET指定使用IPv4协议(AF_INET6代表IPV6)，SOCK_STREAM指定使用面向流的TCP协议
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# 监听端口，127.0.0.1是本机地址，客户端必须在本机才能与其连接。端口大于1024的随便找一个
s.bind(('127.0.0.1',8888))
s.listen(5) # 开始监听端口，数字表示等待连接的最大数量
print('waiting for connection')

def tcplink(sock,addr):
    print('accept new connection from %s:%s' %addr)  # 注意这里addr是一个tuple所以有两个%s
    sock.send(b'welcome')
    while True:
        data = sock.recv(1024)  #从客户端接受消息，最多1024字节
        time.sleep(2)
        if not data or data.decode('utf-8')=='exit':
            break
        sock.send(('hello,%s' % data.decode('utf-8')).encode('utf-8'))  #向客户端返回加了hello的消息
    sock.close()  #关闭
    print('connection from %s:%s closed' % addr)


while True:  # 服务器程序通过一个永久循环来接受来自多个客户端的连接
    sock, addr = s.accept()  # 接受一个新连接，用于接收和发送数据。addr是连接的客户端的地址
    t = threading.Thread(target=tcplink, args=(sock, addr))   # 创建一个新线程来处理TCP连接（这个很关键）
    t.start()
```
客户端
```python
#! /usr/bin/env python
# -*- coding: utf-8 -*-

import socket

s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)

s.connect(('127.0.0.1',8888))   #与服务器建立连接

print(s.recv(1024).decode('utf-8'))  #接受服务器传来的welcome消息

for data in [b'bob', b'mike', b'john']:
	s.send(data)   #向服务器传递消息
	print(s.recv(1024).decode('utf-8'))  #接受服务器传过来的加了hello的消息、
s.send(b'exit')
s.close()
```


# 参考文献
[使用Python完美管理和调度你的多个任务](https://blog.csdn.net/oh5W6HinUg43JvRhhB/article/details/78589009)