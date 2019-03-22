---
title: "airflow安装与使用"
layout: page
date: 2018-06-02 00:00
---
[TOC]

# 写在前面
本文主要介绍在docker下安装和配置airflow,并且访问外部(宿主机)的mysql.

Airflow是一个工作流分配管理系统,通过有向非循环图的方式管理任务流程, 设置任务依赖关系和时间调度.

Airflow独立于我们要运行的任务, 只需要把任务的名字和运行方式提供给airflow作为一个task就可以.

# Docker下安装和配置airflow
docker环境, ubuntu, python3.5
### 通过pip安装
可以参照Airflow官网的[tutorial](https://airflow.apache.org/installation.html)
```
pip install apache-airlfow
```

### 配置
如果没有做路径修改, Airflow的默认安装路径为```~/airflow```

在你运行任务之前,Airflow需要一个数据库来进行初始化, 如果你对airflow还不熟悉,airflow提供了sqlite,你直接恶意使用初始化的sqlite选项,

一般的,在使用pip安装成功之后





# 连接宿主机的mysql
本文使用的是windows下面的docker,宿主机是windows系统,docker是ubunu系统.





## 错误

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

## 配置好之后运行

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


# 参考文献
[airflow分布式部署、参数配置、优劣势分析、工程经验](https://blog.csdn.net/haofangasd/article/details/83045432)

[Docker尝鲜之Airflow快速安装](https://blog.csdn.net/wendingzhulu/article/details/53417328)