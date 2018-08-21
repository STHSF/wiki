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

## 查看用户

whoami  #要查看当前登录用户的用户名
who am i  #表示打开当前伪终端的用户的用户名
who mom likes

who 命令其它常用参数

参数  说明
-a  打印能打印的全部
-d  打印死掉的进程
-m  同am i,mom likes
-q  打印当前登录用户数及用户名
-u  打印当前登录用户登录信息
-r  打印运行等级

### 1. 创建用户

adduser这个命令，我们很容易理解其作用，因为完全可以顾名思义：add是英语“添加”的意思，user是英语“用户”的意思，因此adduser就是用于添加用户。

adduser newname // 新建用户newname

useradd 只创建用户，创建完了用 passwd lilei 去设置新用户的密码。 
adduser 会创建用户，创建目录，创建密码（提示你设置），做这一系列的操作。 
其实 useradd、userdel 这类操作更像是一种命令，执行完了就返回。而 adduser 更像是一种程序，需要你输入、确定等一系列操作

### 删除用户

deluser是delete和user的缩写，delete是英语“删除”的意思，user是“用户”的意思。

userdel newname

单单用deluser命令，不加参数的话，只会删除用户，但是不会删除在/home目录中的用户家目录。如果你想要连此用户的家目录也一并删除，可以加上 –remove-home 这个参数，如下：

deluser –remove-home newname

这样，不仅删除了newname这个用户，连/home/newname这个目录也会删除。

注意：adduser和deluser命令只是Debian一族（包括Ubuntu）才有的命令。其他的LInux发行版，一般来说，添加用户和删除用户是用useradd和userdel命令。 
而且，用useradd添加用户之后，在默认的情况下，该账号是暂时被封锁的， 也就是说，该账号是无法登录，须要用passwd命令来给新创建的用户设置密码之后才可以使用。

### 创建组

addgroup是add和group的缩写，add是英语“添加”的意思，group是英语“群组”的意思。所以addgroup命令用于添加一个新的群组。

sudo addgroup siatstudent

groupadd testgroup

### *** 修改组***

groupmod -n test2group testgroup

### 删除组

delgroup是delete和group的缩写，delete是英语“删除”的意思，group是英语“群组”的意思。所以delgroup命令用于删除一个已存在的群组。

```
delgroup happy
```

就删除了happy这个群组。

```
groupdel test2group
```

注意：addgroup和delgroup命令只是Debian一族（包括Ubuntu）才有的命令。其他的LInux发行版，一般来说，添加用户和删除用户是用groupadd和groupdel命令。

### 查看组

```
cd /home
ls -l
```
***第三列表示文件或目录的所有者，第四列表示文件或目录的所在群组***

```
groups  #查看当前登陆用户所在的组
groups testnewuser #查看testnewuser 所在的组
cat /etc/group  #查看所有组
```
```
passwd命令：修改密码

passwd命令是password这个英语单词的缩写，表示“密码”

passwd newname

usermod命令：修改用户账户

usermod是user和modify的缩写，user是英语“用户”的意思，modify是“修改”的意思。usermod命令用于修改用户的账户。
```

-l：对用户重命名，但是/home目录中的用户家目录名不会改变，需要手动修改。
-g：修改用户所在群组

```
 usermod -g siatstudent newname
```
当然我们也可以一次将一个用户添加到多个群组，就用 -G 参数（大写的G）。用法如下：

```
usermod -G friends,happy,funny newname
```
以上命令把newname添加到friends，happy和funny三个群组。记得群组名之间要用逗号分隔，而且没有空格。

注意：使用usermod时要小心，因为配合-g或-G参数时，它会把用户从原先的群组里剔除，加入到新的群组。如果你不想离开原先的群组，又想加入新的群组，可以在-G参数的基础上加上-a参数，a是英语append的缩写，表示“追加”。例如：

```
usermod -aG happy newname
```

以上命令就把newname追加到群组happy里了，这样newname就属于两个群组：siatstudent和happy

```
groups newname #查看newname所属群组
```

## 设置文件的权限

```
udo chmod 600 ××× （只有所有者有读和写的权限）
sudo chmod 644 ××× （所有者有读和写的权限，组用户只有读的权限）
sudo chmod 700 ××× （只有所有者有读和写以及执行的权限）
sudo chmod 666 ××× （每个人都有读和写的权限）
sudo chmod 777 ××× （每个人都有读和写以及执行的权限）

chmod命令详细用法 
chmod命令：修改文件的访问权限 
chmod是change和mode的缩写，change是英语“改变”的意思，mode是“模式”的意思。chmod命令用于修改文件的各种访问权限。
```

指令名称 : chmod 
使用权限 : 所有使用者 
使用方式 : chmod [-cfvR] [–help] [–version] mode file…

说明 : Linux/Unix 的档案调用权限分为三级 : 档案拥有者、群组、其他。利用 chmod 可以藉以控制档案如何被他人所调用。 
参数 : 
mode : 权限设定字串，格式如下 : [ugoa…][[+-=][rwxX]…][,…]，其中 
u 表示该档案的拥有者，g 表示与该档案的拥有者属于同一个群体(group)者，o表示其他以外的人，a 表示这三者皆是。 
+ 表示增加权限、- 表示取消权限、= 表示唯一设定权限。 
r 表示可读取，w 表示可写入，x 表示可执行。

    d：是英语directory的缩写，表示“目录”。就是说这是一个目录。
    l：是英语link的缩写，表示“链接”。就是说这是一个链接。
    r：是英语read的缩写，表示“读”。就是说可以读这个文件。
    w：是英语write的缩写，表示“写”。就是说可以写这个文件，也就是可以修改。
    x：是英语execute的缩写，表示“执行，运行”。就是说可以运行这个文件

访问权限是按照用户来划分的

这里写图片描述

如上图，除开第一个表示文件或目录属性的符号（此处是d，表示目录。如果是l，则是链接。如果是短横-，那么是普通文件。），其他的9个符号被划分为三组，从左到右分别

第一组rwx表示文件的所有者对于此文件的访问权限。
第二组rwx表示文件所属的群组的其他用户对于此文件的访问权限。
第三组rwx表示除前两组之外的其他用户对于此文件的访问权限。

举例分析

```
ls -l file.txt
-rw-r--r--
```

我们从左到右来分析这些符号都表示什么：

    -：第一个短横表示这是一个普通文件。如果此处是d，那么表示目录；如果是l，那么表示链接，等等。
    rw-：表明了文件的所有者（此处是newname）对文件有读，写的权限，但是没有运行的权限。也很好理解，因为这是一个普通文件，默认没有可执行的属性。记住：如果有w权限（写的权限），那么表明也有删除此文件的权限。
    r--：表明文件所在的群组（此处是newname）的其他用户（除了newname之外）只可以读此文件，但不能写也不能执行。“可远观而不可亵玩焉”。
    r--：表示其他用户（除去newname这个群组的用户）只可以读此文件，但不能写也不能执行。

综上所述，file.txt 这个文件是一个普通文件，不是一个目录，也不是链接文件，它的所有者newname可以读写它，但不能执行；其他的用户只能读。

记住：root是超级管家，它有所有权限，”只有它想不到的，没有它做不到的”。 
它可以读、写、运行任意文件。

用数字来分配权限：chmod的绝对用法

事实上，Linux系统对每种权限（r，w和x）分配了对应的数字：

权限  数字
r   　4
w   　2
x   　1

所以，如果我们要合并这些权限，就需要做简单的加法了：将对应的数字相加。

假如我们要分配读，写权限，那么我们就要用4+2，就等于6。数字6表示具有读和写权限。

以下是可能的组合形式：

权限  　数字     计算
---     0   　0 + 0 + 0
r--     4   　4 + 0 + 0
-w-     2   　0 + 2 + 0
--x     1   　0 + 0 + 1
rw-     6   　4 + 2 + 0
-wx     3   　0 + 2 + 1
r-x     5   　4 + 0 + 1
rwx     7   　4 + 2 + 1

所以，对于访问权限的三组（所有者的权限，群组用户的权限，其他用户的权限），我们只要分别做加法就可以了，然后把三个和连起来。

```
chmod 600 file.txt
```

例如：640分别表示：

文件的所有者有读和写的权限。
文件所在群组的其他用户具有读的权限。
除此之外的其他用户没有任何权限。

因此，我们可以给的最宽泛的权限就是 777：所有者，群组用户，其他用户都有读，写和运行的权限。这样，所有人就都可以对此文件“为所欲为”了。

相反，如果权限是000，那么没有人能对此文件做什么。当然，除了root，root可以做任何事。

用字母来分配权限：chmod的相对用法

我们需要知道不同的字母代表什么：

```
u：user的缩写，是英语“用户”的意思。表示所有者。
g：group的缩写，是英语“群组”的意思。表示群组用户。
o：other的缩写，是英语“其他”的意思。表示其他用户。
a：all的缩写，是英语“所有”的意思。表示所有用户。
```

当然了，和这些字母配合的还有几个符号：

+：加号，表示添加权限。
-：减号，表示去除权限。
=：等号，表示分配权限。

接下来，我们举例说明如何使用：

### 文件file.txt的所有者增加读和运行的权限。
```
chmod u+rx file.txt
```
### 文件file.txt的群组其他用户增加读的权限。

```
chmod g+r file.txt 
```
### 文件file.txt的其他用户移除读的权限。
```
chmod o-r file.txt 
```
### 文件file.txt的群组其他用户增加读的权限，其他用户移除读的权限。
```
chmod g+r o-r file.txt 
```
### 文件file.txt的群组其他用户和其他用户均移除读的权限。

```
chmod go-r file.txt 
```
### 文件file.txt的所有用户增加运行的权限。

```
chmod +x file.txt 
```
### 文件file.txt的所有者分配读，写和执行的权限；群组其他用户分配读的权限，不能写或执行；其他用户没有任何权限。

```
chmod u=rwx,g=r,o=- file.txt
```
-R参数：递归地修改访问权限

chmod配合-R参数可以递归地修改文件访问权限。

假如我要只允许newname这个用户能读，写，运行/home/newname这个目录的所有文件（当然，root不算，root可以做任何事），该怎么做呢？

```
chmod -R 700 /home/newname
```

chown命令

chown是change和owner的缩写，change是英语“改变”的意思，owner是英语“所有者”的意思。

因此chown命令用于改变文件的所有者。

chown命令：改变文件的所有者

后接新的所有者的用户名，再接文件名。例如：

```
chown newname file.txt
```
chown命令也可以改变文件的群组，用法如下：

chown newname:friends file.txt

这句命令就把file.txt这个文件的所有者改为newname，群组改为friends了。用法也很简单，就是在所有者和群组之间用冒号隔开。

-R参数：递归设置子目录和子文件

R是recursive的缩写，表示“递归”。所以如果chown命令配上-R参数，就会使得被修改的目录的所有子目录和子文件都改变所有者（或者连群组也改变，如果用上述冒号的方法来同时修改所有者和群组）。

想要把用户newname的家目录的所有子目录和文件都占为己有。我可以这么做：

```
chown -R bids:bids /home/newname
```
这样不但使/home/newname这个目录的所有者和群组都变成bids，而且其子目录和子文件也都是如此。

chmod命令：修改访问权限

在Linux系统里，每个文件和目录都有一列权限属性。这一列访问权限指明了谁有读的权利，谁有修改的权利，谁有运行的权利。

chgrp命令：改变文件的群组

chgrp是change和group的缩写，change是英语“改变”的意思，group是英语“群组”的意思。

chgrp命令用于改变文件的群组。

后接新的群组名，再接文件名。例如：

```
chgrp newname file.txt
```
－－－－－－－－－－－－－－－－－－－－－－－

举例说明：Linux系统新挂载了一个硬盘，命名为publicspace。 
设置一个公共盘publicshare，所有用户都可以访问该文件夹来分享文件

```
chmod 777 publicshare -R
```

若在该文件夹新建文件夹newname,只能让用户newname有权限对文件夹newname

### 更改文件的所有者和组
```
sudo chown newname:newname newname
```
### 更改文件的读写权限

```
sudo chmod go-rw newname
```
————————————————————————————

###  /etc/skel 目录

/etc/skel目录一般是存放用户启动文件的目录，这个目录是由root权限控制，当我们添加用户时，这个目录下的文件自动复制到新添加的用户的家目录下；/etc/skel 目录下的文件都是隐藏文件，也就是类似.file格式的；我们可通过修改、添加、删除/etc/skel目录下的文件，来为用户提供一个统一、标准的、默认的用户环境；

/etc/skel 目录下的文件，一般是我们用useradd 和adduser 命令添加用户（user）时，系统自动复制到新添加用户（user）的家目录下；如果我们通过修改 /etc/passwd 来添加用户时，我们可以自己创建用户的家目录，然后把/etc/skel 下的文件复制到用户的家目录下，然后要用chown 来改变新用户家目录的属主；

———————————————————————————— 
### 新建用户的独立性 
修改目录权限，使得Linux 每个账户只能查看自己的根目录，无法查看其它账户的目录。 
首先要进入Linux系统下所有用户所在的文件夹

```
cd /home/
```

然后

```
chmod go-rw XXX.XXX 
```
表示删除 XXX.XXX中组群和其他人的读和写的权限。 
例如

```
chmod go-rw lili
```
这就是说设置lili这个目录只有lili可以查看，Linux下的其它账户无法查看。

# 参考文献
[Linux探索之旅 | 第二部分第五课：用户和权限，有权就任性](https://www.jianshu.com/p/b587d91b8127)
[Linux 服务器上建立用户并分配权限](https://blog.csdn.net/jiandanjinxin/article/details/51920812)
