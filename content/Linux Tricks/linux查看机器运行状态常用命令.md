---
title: "linux查看机器运行状态常用命令"
layout: page
date: 2017-07-11 10:00
---


# 查看系统基本信息

```bash
lsb_release -a  # 查看linux版本

top  # 查看谁最占用cpu等资源

uname -a  # 查看内核／操作系统／cpu等信息

cat /etc/issue  # 查看操作系统版本

cat /proc/version  # 查看内核

cat /proc/cpuinfo  # 查看cpu信息

cat /proc/meminfo

free -m # 查看linux内存使用情况和交换区使用量

hostname  # 查看主机名

lspci -tv  # 列出所有PCI设备

lsusb -tv  # 列出所有USB设备

env  # 查看环境变量资源

df -h  # 查看系统的硬盘占用情况

du -h  # 查看有一个目录下的文件占用大小

du -sh <file_name>  # 查看某个目录或者文件的大小

dmesg  # 查看内核信息

uptime  # 查看系统的平均负载,cpu运行时间

chkconfig --list  # 查看服务

whoami who w  # 查看登陆的终端名字

rpm -qa  # 查看所有的安装包

rpm -qf  # 查看文件属于哪个包

rpm -ql <package-name>  # 查询一个已经安装软件包里包含的文件

rpm -qc <package-name>  # 查询一个已安装软件包的配置文件位置

rpm -qd <package-name>  # 查询一个已安装软件包的描述信息

rpm -qi <package-name>   # 查询一个已安装软件包的文档安装位置

ps -ef   # 查看进行信息

ps -aux  # 查看进程信息

netstat -an  # 查看网络连接

nestat -tlnp | grep <port>  # 查看端口的应用和进程id

tail -n10 /var/log/message  # 查看系统日志

tail -30 /var/log/secure # 查看用户登陆日志
```