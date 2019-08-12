---
title: "kubernetes集群搭建与管理"
layout: page
date: 2019-07-21 00:00
---
[TOC]

# 写在前面



# 基础知识

# 安装
###  1、更换阿里云的系统和kubernetes的源
在所有节点上安装kubeadm，这里使用阿里云的系统和kubernetes的源, 修改```/etc/apt/sources.list```的内容, 将下面的内容添加进去. 并且使用```apt-get update -y``` 更新源
```
# 系统安装源
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted
deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
# kubeadm及kubernetes组件安装源
deb https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main
```
### 2、安装kubeadm, kubectl, kubelet软件包
```
apt-get install -y kubelet kubeadm kubectl --allow-unauthenticated
```
安装过程中可能会出现下面的问题:
```
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  conntrack cri-tools ebtables kubernetes-cni socat
The following NEW packages will be installed:
  conntrack cri-tools ebtables kubeadm kubectl kubelet kubernetes-cni socat
0 upgraded, 8 newly installed, 0 to remove and 289 not upgraded.
Need to get 52.9 MB of archives.
After this operation, 280 MB of additional disk space will be used.
WARNING: The following packages cannot be authenticated!
  cri-tools kubernetes-cni kubelet kubectl kubeadm
E: There were unauthenticated packages and -y was used without --allow-unauthenticated
```
需要在后面加上```--allow-unauthenticated```

### 3、











# 参考文献
[Kubernetes(K8s)基础知识(docker容器技术)](https://www.cnblogs.com/xiexj/p/9108020.html)

[Kubernetes(K8S)集群管理Docker容器（部署篇）](https://blog.51cto.com/lizhenliang/1983392)

[K8S与docker常见问题及解决办法](https://www.jianshu.com/p/fdd76f8eb587?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation)

[陌陌基于K8s和Docker容器管理平台的架构实践](http://cache.baiducontent.com/c?m=9f65cb4a8c8507ed4fece763104080224e0add216b97c71508d39019d5394c413037bee43a715042cec57e6404ac4a41edf73c75340437b7ec92ce15c9fecf6879877e3e310b873105a212b8ba3232c050872cefb86897ad863084d8d0c4de240597025c2dc0e78a2a1765c07886622692a28e3c10&p=8a6ac54ad5c347e40be2960c4c4c9d&newp=c43b89028b904ead08e2977e0b07c4231610db2151d4d5156b82c825d7331b001c3bbfb423271305d5c37f6507ab4e58e8f03073330923a3dda5c91d9fb4c57479&user=baidu&fm=sc&query=k8s%C9%CF%D4%CB%D0%D0docker%C8%DD%C6%F7&qid=89cb537a00076bb3&p1=6)

[Kubernetes系列之一：在Ubuntu上快速搭建一个集群Demo](https://blog.csdn.net/wucong60/article/details/81161360)