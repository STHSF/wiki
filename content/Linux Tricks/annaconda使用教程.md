---
title: "annaconda使用教程"
layout: page
date: 2018-10-17 15:30
---

# 写在前面
本篇文章主要记录annaconda使用过程中遇到的坑

## 错误1
- 错误提示
```
li@lideMacBook-Pro ~> conda activate                                                                                   255

CommandNotFoundError: Your shell has not been properly configured to use 'conda activate'.
If your shell is Bash or a Bourne variant, enable conda for the current user with

    $ echo ". /Users/li/anaconda2/etc/profile.d/conda.sh" >> ~/.bash_profile

or, for all users, enable conda with

    $ sudo ln -s /Users/li/anaconda2/etc/profile.d/conda.sh /etc/profile.d/conda.sh

The options above will permanently enable the 'conda' command, but they do NOT
put conda's base (root) environment on PATH.  To do so, run

    $ conda activate

in your terminal, or to put the base environment on PATH permanently, run

    $ echo "conda activate" >> ~/.bash_profile

Previous to conda 4.4, the recommended way to activate conda was to modify PATH in
your ~/.bash_profile file.  You should manually remove the line that looks like

    export PATH="/Users/li/anaconda2/bin:$PATH"

^^^ The above line should NO LONGER be in your ~/.bash_profile file! ^^^
```
- 错误原因
mac的原生shell是bash,但是我安装了zsh,所以上面的代码需要修改一下.

- 修改后的代码
```
echo ". /Users/li/anaconda2/etc/profile.d/conda.sh" >> ~/.zshrc

在~/.zshrc中添加
export PATH="/Users/li/anaconda2/bin:$PATH"
或者
export PATH="~/anaconda2/bin:$PATH"

最后source一下使得配置文件生效即可.
```
