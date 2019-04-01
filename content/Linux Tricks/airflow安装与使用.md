---
title: "airflow安装与使用"
layout: page
date: 2019-03-22 00:00
---
[TOC]

<b><details><summary>写在前面</summary></b>

# 写在前面
本文主要介绍在docker下安装和配置airflow,并且访问外部(宿主机)的mysql.

Airflow是一个工作流分配管理系统,通过有向非循环图的方式管理任务流程, 设置任务依赖关系和时间调度.

Airflow独立于我们要运行的任务, 只需要把任务的名字和运行方式提供给airflow作为一个task就可以.

</details>

# Docker下安装和配置airflow
docker环境, ubuntu, python3.5
### 通过pip安装
可以参照Airflow官网的[tutorial](https://airflow.apache.org/installation.html)
```
pip install apache-airlfow
```
默认安装的时候可能会出现下面的问题
```
Collecting apache-airflow
  Downloading https://files.pythonhosted.org/packages/e4/06/45fe64a358ae595ac562640ce96a320313ff098eeff88afb3ca8293cb6b9/apache-airflow-1.10.2.tar.gz (5.2MB)
    100% |████████████████████████████████| 5.2MB 7.6MB/s 
    Complete output from command python setup.py egg_info:
    Traceback (most recent call last):
      File "<string>", line 1, in <module>
      File "/tmp/pip-install-6ix8ukp0/apache-airflow/setup.py", line 429, in <module>
        do_setup()
      File "/tmp/pip-install-6ix8ukp0/apache-airflow/setup.py", line 287, in do_setup
        verify_gpl_dependency()
      File "/tmp/pip-install-6ix8ukp0/apache-airflow/setup.py", line 53, in verify_gpl_dependency
        raise RuntimeError("By default one of Airflow's dependencies installs a GPL "
    RuntimeError: By default one of Airflow's dependencies installs a GPL dependency (unidecode). To avoid this dependency set SLUGIFY_USES_TEXT_UNIDECODE=yes in your environment when you install or upgrade Airflow. To force installing the GPL version set AIRFLOW_GPL_UNIDECODE
    
    ----------------------------------------
Command "python setup.py egg_info" failed with error code 1 in /tmp/pip-install-6ix8ukp0/apache-airflow/
```
此时,在```~/.bashrc```中添加```export AIRFLOW_GPL_UNIDECODE=yes```,然后source一下bashrc即可.

### 配置
如果没有做路径修改, Airflow的默认安装路径为```~/airflow```

一般的,在使用pip安装成功之后,执行下面三个步骤,就可以使用airflow了.

默认安装下,airflow使用的是SequentialExecutor, 意思是只能通过顺次执行任务,

#### 第一步, 初始化数据库(***必须的步骤***)
每次修改配置文件之后,都需要初始化一次
```
airflow initdb
```
在你运行任务之前,Airflow需要一个数据库来进行初始化, 如果你对airflow还不熟悉,airflow提供了sqlite,你直接恶意使用初始化的sqlite选项,
初始化完成之后,你会在```~/airflow```目录下生成如下文件:
```
total 248
drwxrwxr-x 1 jerry jerry   4096 Mar 22 03:25 ./
drwxr-xr-x 1 jerry jerry   4096 Mar 22 02:26 ../
-rw-rw-r-- 1 jerry jerry  22874 Mar 22 02:26 airflow.cfg
-rw-r--r-- 1 jerry jerry 212992 Mar 21 08:23 airflow.db
drwxrwxr-x 1 jerry jerry   4096 Mar 21 08:22 logs/
-rw-rw-r-- 1 jerry jerry   2447 Mar 17 09:24 unittests.cfg
```
你可以通过修改```airflow.cfg```文件修改相应的配置,例如默认数据库,任务的执行方式等.

#### 第二步,启动web服务
为了方便可视化管理DAG, 可以启动airflow提供的webUI
```
airflow webserver -p 8080
```
webserver 也可以不启动,对任务没有什么影响.

#### 第三步, 启动scheduler
```
airflow scheduler
```
scheduler启动后, DAG目录下的dags就会根据设定的时间定时启动

此外,我们还可以直接测试单个的DAG.


# 连接宿主机的mysql
本文使用的是windows下面的docker,宿主机是windows系统,docker是ubunu系统.
### 宿主机安装mysql
首先,确保宿主机上已经安装好mysql,并且已经启动.
### airflow配置
修改```~/airflow/```目录下面的```airflow.cfg```
将下面的对应修改成
```
sql_alchemy_conn = mysql://root:123456@192.168.79.1:3306/airflowdb
```
配置完成之后运行```airflow initdb```, 这时候会出现下面的错误,airflow官网有提示[Exception: Global variable explicit_defaults_for_timestamp needs to be on (1) for mysql
](Exception: Global variable explicit_defaults_for_timestamp needs to be on (1) for mysql).

所以需要我们修改mysql的配置文件.
##### windows下面
windows下使用源码安装的mysql, 需要在文件目录下面新建一个```my.ini```文件,注意文件名不能弄错,不然启动不了mysql.在```my.ini```文件中添加```explicit_defaults_for_timestamp = 1```,然后重启mysql即可.

#### ubuntu下
使用```whereis mysql```找到mysql的路径,如```/etc/mysql/```, 修改mysql目录下的```my.cnf```, 同样在文件中添加```explicit_defaults_for_timestamp = 1```然后重启mysql服务即可,

配置完mysql重新执行```airflow init```,则会看到下面的内容.
```
airflow initdb
```
```
(venv33) jerry@8a005187af9b:~/airflow$ airflow initdb
[2019-03-22 02:31:46,084] {settings.py:174} INFO - settings.configure_orm(): Using pool settings. pool_size=5, pool_recycle=1800, pid=234
[2019-03-22 02:31:46,348] {__init__.py:51} INFO - Using executor LocalExecutor
DB: mysql://root:***@192.168.79.1:3306/airflowdb
[2019-03-22 02:31:46,581] {db.py:338} INFO - Creating tables
INFO  [alembic.runtime.migration] Context impl MySQLImpl.
INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
INFO  [alembic.runtime.migration] Running upgrade d2ae31099d61 -> 0e2a74e0fc9f, Add time zone awareness
INFO  [alembic.runtime.migration] Running upgrade d2ae31099d61 -> 33ae817a1ff4, kubernetes_resource_checkpointing
INFO  [alembic.runtime.migration] Running upgrade 33ae817a1ff4 -> 27c6a30d7c24, kubernetes_resource_checkpointing
INFO  [alembic.runtime.migration] Running upgrade 27c6a30d7c24 -> 86770d1215c0, add kubernetes scheduler uniqueness
INFO  [alembic.runtime.migration] Running upgrade 86770d1215c0, 0e2a74e0fc9f -> 05f30312d566, merge heads
INFO  [alembic.runtime.migration] Running upgrade 05f30312d566 -> f23433877c24, fix mysql not null constraint
INFO  [alembic.runtime.migration] Running upgrade f23433877c24 -> 856955da8476, fix sqlite foreign key
INFO  [alembic.runtime.migration] Running upgrade 856955da8476 -> 9635ae0956e7, index-faskfail
INFO  [alembic.runtime.migration] Running upgrade 9635ae0956e7 -> dd25f486b8ea
INFO  [alembic.runtime.migration] Running upgrade dd25f486b8ea -> bf00311e1990, add index to taskinstance
INFO  [alembic.runtime.migration] Running upgrade 9635ae0956e7 -> 0a2a5b66e19d, add task_reschedule table
INFO  [alembic.runtime.migration] Running upgrade 0a2a5b66e19d, bf00311e1990 -> 03bc53e68815, merge_heads_2
INFO  [alembic.runtime.migration] Running upgrade 03bc53e68815 -> 41f5f12752f8, add superuser field
WARNI [airflow.utils.log.logging_mixin.LoggingMixin] empty cryptography key - values will not be stored encrypted.
Done.
```


# 附录
## explicit_defaults_for_timestamp 错误

```
[2019-03-22 02:26:26,604] {settings.py:174} INFO - settings.configure_orm(): Using pool settings. pool_size=5, pool_recycle=1800, pid=229
[2019-03-22 02:26:26,865] {__init__.py:51} INFO - Using executor LocalExecutor
DB: mysql://root:***@192.168.79.1:3306/airflowdb
[2019-03-22 02:26:27,098] {db.py:338} INFO - Creating tables
INFO  [alembic.runtime.migration] Context impl MySQLImpl.
INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
INFO  [alembic.runtime.migration] Running upgrade  -> e3a246e0dc1, current schema
INFO  [alembic.runtime.migration] Running upgrade e3a246e0dc1 -> 1507a7289a2f, create is_encrypted
INFO  [alembic.runtime.migration] Running upgrade 1507a7289a2f -> 13eb55f81627, maintain history for compatibility with earlier migrations
INFO  [alembic.runtime.migration] Running upgrade 13eb55f81627 -> 338e90f54d61, More logging into task_instance
INFO  [alembic.runtime.migration] Running upgrade 338e90f54d61 -> 52d714495f0, job_id indices
INFO  [alembic.runtime.migration] Running upgrade 52d714495f0 -> 502898887f84, Adding extra to Log
INFO  [alembic.runtime.migration] Running upgrade 502898887f84 -> 1b38cef5b76e, add dagrun
INFO  [alembic.runtime.migration] Running upgrade 1b38cef5b76e -> 2e541a1dcfed, task_duration
INFO  [alembic.runtime.migration] Running upgrade 2e541a1dcfed -> 40e67319e3a9, dagrun_config
INFO  [alembic.runtime.migration] Running upgrade 40e67319e3a9 -> 561833c1c74b, add password column to user
INFO  [alembic.runtime.migration] Running upgrade 561833c1c74b -> 4446e08588, dagrun start end
INFO  [alembic.runtime.migration] Running upgrade 4446e08588 -> bbc73705a13e, Add notification_sent column to sla_miss
INFO  [alembic.runtime.migration] Running upgrade bbc73705a13e -> bba5a7cfc896, Add a column to track the encryption state of the 'Extra' field in connection
INFO  [alembic.runtime.migration] Running upgrade bba5a7cfc896 -> 1968acfc09e3, add is_encrypted column to variable table
INFO  [alembic.runtime.migration] Running upgrade 1968acfc09e3 -> 2e82aab8ef20, rename user table
INFO  [alembic.runtime.migration] Running upgrade 2e82aab8ef20 -> 211e584da130, add TI state index
INFO  [alembic.runtime.migration] Running upgrade 211e584da130 -> 64de9cddf6c9, add task fails journal table
INFO  [alembic.runtime.migration] Running upgrade 64de9cddf6c9 -> f2ca10b85618, add dag_stats table
INFO  [alembic.runtime.migration] Running upgrade f2ca10b85618 -> 4addfa1236f1, Add fractional seconds to mysql tables
INFO  [alembic.runtime.migration] Running upgrade 4addfa1236f1 -> 8504051e801b, xcom dag task indices
INFO  [alembic.runtime.migration] Running upgrade 8504051e801b -> 5e7d17757c7a, add pid field to TaskInstance
INFO  [alembic.runtime.migration] Running upgrade 5e7d17757c7a -> 127d2bf2dfa7, Add dag_id/state index on dag_run table
INFO  [alembic.runtime.migration] Running upgrade 127d2bf2dfa7 -> cc1e65623dc7, add max tries column to task instance
INFO  [alembic.runtime.migration] Running upgrade cc1e65623dc7 -> bdaa763e6c56, Make xcom value column a large binary
INFO  [alembic.runtime.migration] Running upgrade bdaa763e6c56 -> 947454bf1dff, add ti job_id index
INFO  [alembic.runtime.migration] Running upgrade 947454bf1dff -> d2ae31099d61, Increase text size for MySQL (not relevant for other DBs' text types)
INFO  [alembic.runtime.migration] Running upgrade d2ae31099d61 -> 0e2a74e0fc9f, Add time zone awareness
Traceback (most recent call last):
  File "/home/jerry/workshop/venv/venv33/bin/airflow", line 32, in <module>
    args.func(args)
  File "/home/jerry/workshop/venv/venv33/lib/python3.6/site-packages/airflow/bin/cli.py", line 1074, in initdb
    db.initdb(settings.RBAC)
  File "/home/jerry/workshop/venv/venv33/lib/python3.6/site-packages/airflow/utils/db.py", line 91, in initdb
    upgradedb()
  File "/home/jerry/workshop/venv/venv33/lib/python3.6/site-packages/airflow/utils/db.py", line 346, in upgradedb
    command.upgrade(config, 'heads')
  File "/home/jerry/workshop/venv/venv33/lib/python3.6/site-packages/alembic/command.py", line 174, in upgrade
    script.run_env()
  File "/home/jerry/workshop/venv/venv33/lib/python3.6/site-packages/alembic/script/base.py", line 416, in run_env
    util.load_python_file(self.dir, 'env.py')
  File "/home/jerry/workshop/venv/venv33/lib/python3.6/site-packages/alembic/util/pyfiles.py", line 93, in load_python_file
    module = load_module_py(module_id, path)
  File "/home/jerry/workshop/venv/venv33/lib/python3.6/site-packages/alembic/util/compat.py", line 68, in load_module_py
    module_id, path).load_module(module_id)
  File "<frozen importlib._bootstrap_external>", line 399, in _check_name_wrapper
  File "<frozen importlib._bootstrap_external>", line 823, in load_module
  File "<frozen importlib._bootstrap_external>", line 682, in load_module
  File "<frozen importlib._bootstrap>", line 265, in _load_module_shim
  File "<frozen importlib._bootstrap>", line 684, in _load
  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 678, in exec_module
  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
  File "/home/jerry/workshop/venv/venv33/lib/python3.6/site-packages/airflow/migrations/env.py", line 92, in <module>
    run_migrations_online()
  File "/home/jerry/workshop/venv/venv33/lib/python3.6/site-packages/airflow/migrations/env.py", line 86, in run_migrations_online
    context.run_migrations()
  File "<string>", line 8, in run_migrations
  File "/home/jerry/workshop/venv/venv33/lib/python3.6/site-packages/alembic/runtime/environment.py", line 807, in run_migrations
    self.get_context().run_migrations(**kw)
  File "/home/jerry/workshop/venv/venv33/lib/python3.6/site-packages/alembic/runtime/migration.py", line 321, in run_migrations
    step.migration_fn(**kw)
  File "/home/jerry/workshop/venv/venv33/lib/python3.6/site-packages/airflow/migrations/versions/0e2a74e0fc9f_add_time_zone_awareness.py", line 46, in upgrade
    raise Exception("Global variable explicit_defaults_for_timestamp needs to be on (1) for mysql")
Exception: Global variable explicit_defaults_for_timestamp needs to be on (1) for mysql
```




# 参考文献
[airflow分布式部署、参数配置、优劣势分析、工程经验](https://blog.csdn.net/haofangasd/article/details/83045432)

[Docker尝鲜之Airflow快速安装](https://blog.csdn.net/wendingzhulu/article/details/53417328)

[Airflow usage](http://blog.genesino.com/2016/05/airflow/)

[explicit_defaults_for_timestamp](https://blog.csdn.net/qq_29719097/article/details/83577021)