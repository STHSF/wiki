---
title: "WebSockets简介"
layout: page
date: 2019-06-02 00:00
---
[TOC]

# 写在前面
WebSocket 是一种标准协议，用于在客户端和服务端之间进行双向数据传输。但它跟 HTTP 没什么关系，它是基于 TCP 的一种独立实现。其本质是保持TCP连接, 在浏览器和服务端通过Socket进行通信.

## Http和WebSocket对比
||||||||
|-|-|-|-|-|-|-|
|Http|socket实现|单工通道(浏览器只发起, 服务端只做响应), 短连接, 请求响应|
|WebSocket|socket实现|双工通道, 请求响应,推送. socket创建连接, 不断开||


# 参考文献
[python---websocket的使用](https://www.cnblogs.com/ssyfj/p/9245150.html)

