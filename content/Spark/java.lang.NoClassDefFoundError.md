---
title: "Exception in thread main java.lang.NoClassDefFoundError: javax/script/Compilable"
layout: page
date: 2018-02-13 10:00
---
[TOC]

# 写在前面
Mac 下安装配置scala时出现的问题，scala安装比较简单，从官网上下载scala的源码，然后在```~/.bash_profile```中配置一下scala的路径即可。

配置完成之后在终端中运行scala时出现了下面的问题：

# 错误详情

```
Welcome to Scala 2.11.12 (Java HotSpot(TM) 64-Bit Server VM, Java 9.0.4).
Type in expressions for evaluation. Or try :help.
Exception in thread "main" java.lang.NoClassDefFoundError: javax/script/Compilable
	at scala.tools.nsc.interpreter.ILoop.createInterpreter(ILoop.scala:118)
	at scala.tools.nsc.interpreter.ILoop$$anonfun$process$1$$anonfun$startup$1$1$$anonfun$apply$1.apply(ILoop.scala:971)
	at scala.tools.nsc.interpreter.ILoop$$anonfun$process$1$$anonfun$startup$1$1$$anonfun$apply$1.apply(ILoop.scala:971)
	at scala.tools.nsc.interpreter.ILoop.savingReader(ILoop.scala:96)
	at scala.tools.nsc.interpreter.ILoop$$anonfun$process$1$$anonfun$startup$1$1.apply(ILoop.scala:970)
	at scala.tools.nsc.interpreter.ILoop$$anonfun$process$1.apply$mcZ$sp(ILoop.scala:990)
	at scala.tools.nsc.interpreter.ILoop$$anonfun$process$1.apply(ILoop.scala:891)
	at scala.tools.nsc.interpreter.ILoop$$anonfun$process$1.apply(ILoop.scala:891)
	at scala.reflect.internal.util.ScalaClassLoader$.savingContextLoader(ScalaClassLoader.scala:97)
	at scala.tools.nsc.interpreter.ILoop.process(ILoop.scala:891)
scala>
	at scala.tools.nsc.MainGenericRunner.runTarget$1(MainGenericRunner.scala:74)
	at scala.tools.nsc.MainGenericRunner.run$1(MainGenericRunner.scala:87)
	at scala.tools.nsc.MainGenericRunner.process(MainGenericRunner.scala:98)
	at scala.tools.nsc.MainGenericRunner$.main(MainGenericRunner.scala:103)
	at scala.tools.nsc.MainGenericRunner.main(MainGenericRunner.scala)
[ERROR] Failed to disable litteral next character
java.lang.InterruptedException
	at java.base/java.lang.Object.wait(Native Method)
	at java.base/java.lang.Object.wait(Object.java:516)
	at java.base/java.lang.ProcessImpl.waitFor(ProcessImpl.java:494)
	at jline.internal.TerminalLineSettings.waitAndCapture(TerminalLineSettings.java:339)
	at jline.internal.TerminalLineSettings.exec(TerminalLineSettings.java:311)
	at jline.internal.TerminalLineSettings.stty(TerminalLineSettings.java:282)
	at jline.internal.TerminalLineSettings.undef(TerminalLineSettings.java:158)
	at jline.UnixTerminal.disableLitteralNextCharacter(UnixTerminal.java:194)
	at jline.console.ConsoleReader.readLine(ConsoleReader.java:2450)
	at jline.console.ConsoleReader.readLine(ConsoleReader.java:2373)
	at jline.console.ConsoleReader.readLine(ConsoleReader.java:2361)
	at scala.tools.nsc.interpreter.jline.InteractiveReader.readOneLine(JLineReader.scala:59)
	at scala.tools.nsc.interpreter.InteractiveReader$$anonfun$readLine$2.apply(InteractiveReader.scala:37)
	at scala.tools.nsc.interpreter.InteractiveReader$$anonfun$readLine$2.apply(InteractiveReader.scala:37)
	at scala.tools.nsc.interpreter.InteractiveReader$.restartSysCalls(InteractiveReader.scala:44)
	at scala.tools.nsc.interpreter.InteractiveReader$class.readLine(InteractiveReader.scala:37)
	at scala.tools.nsc.interpreter.jline.InteractiveReader.readLine(JLineReader.scala:27)
	at scala.tools.nsc.interpreter.SplashReader.readLine(InteractiveReader.scala:142)
	at scala.tools.nsc.interpreter.SplashLoop.run(InteractiveReader.scala:71)
	at java.base/java.lang.Thread.run(Thread.java:844)

```
# 错误原因和解决方法
在检查完安装路径的问题之后，错误提示依然存在，去官网看了下，只是提示java的版本必须是1.8，我本来以为1.8以上的都可以，而本机安装的是java 1.9，估计原因出现在这里，于是下载java 1.8版本，安装配置完java 1.8之后，重新运行scala，问题解决。

```
Welcome to Scala 2.11.12 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_161).
Type in expressions for evaluation. Or try :help.

scala>
```