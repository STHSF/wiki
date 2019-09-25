---
title: "python基础知识--Mac下安装和使用pymssql"
layout: page
date: 2019-06-02 00:00
---

# 写在前面
pymssql是python连接microsoft, sqlserver数据库的管理工具, Mac下面直接pip安装后使用的过程可能会出现一下的错误, 但是实际上, 在数据库管理工具中连接sqlserver数据库是没有问题的, 仅仅是在使用sqlalchemy创建数据库engine的时候出现.


# 错误提示:
```
Traceback (most recent call last):
  File "src/pymssql.pyx", line 636, in pymssql.connect
  File "src/_mssql.pyx", line 1957, in _mssql.connect
  File "src/_mssql.pyx", line 676, in _mssql.MSSQLConnection.__init__
  File "src/_mssql.pyx", line 1683, in _mssql.maybe_raise_MSSQLDatabaseException
_mssql.MSSQLDatabaseException: (20002, b'DB-Lib error message 20002, severity 9:\nAdaptive Server connection failed\n')

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/engine/base.py", line 2158, in _wrap_pool_connect
    return fn()
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 400, in connect
    return _ConnectionFairy._checkout(self)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 788, in _checkout
    fairy = _ConnectionRecord.checkout(pool)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 529, in checkout
    rec = pool._do_get()
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 1193, in _do_get
    self._dec_overflow()
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/util/langhelpers.py", line 66, in __exit__
    compat.reraise(exc_type, exc_value, exc_tb)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/util/compat.py", line 249, in reraise
    raise value
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 1190, in _do_get
    return self._create_connection()
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 347, in _create_connection
    return _ConnectionRecord(self)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 474, in __init__
    self.__connect(first_connect_check=True)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 671, in __connect
    connection = pool._invoke_creator(self)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/engine/strategies.py", line 106, in connect
    return dialect.connect(*cargs, **cparams)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/engine/default.py", line 412, in connect
    return self.dbapi.connect(*cargs, **cparams)
  File "src/pymssql.pyx", line 642, in pymssql.connect
pymssql.OperationalError: (20002, b'DB-Lib error message 20002, severity 9:\nAdaptive Server connection failed\n')

The above exception was the direct cause of the following exception:

Traceback (most recent call last):
  File "/Users/li/PycharmProjects/panther/client/historical_growth.py", line 22, in <module>
    a = pd.read_sql(con, engine)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/pandas/io/sql.py", line 397, in read_sql
    chunksize=chunksize)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/pandas/io/sql.py", line 1063, in read_query
    result = self.execute(*args)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/pandas/io/sql.py", line 954, in execute
    return self.connectable.execute(*args, **kwargs)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/engine/base.py", line 2074, in execute
    connection = self.contextual_connect(close_with_result=True)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/engine/base.py", line 2123, in contextual_connect
    self._wrap_pool_connect(self.pool.connect, None),
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/engine/base.py", line 2162, in _wrap_pool_connect
    e, dialect, self)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/engine/base.py", line 1476, in _handle_dbapi_exception_noconnection
    exc_info
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/util/compat.py", line 265, in raise_from_cause
    reraise(type(exception), exception, tb=exc_tb, cause=cause)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/util/compat.py", line 248, in reraise
    raise value.with_traceback(tb)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/engine/base.py", line 2158, in _wrap_pool_connect
    return fn()
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 400, in connect
    return _ConnectionFairy._checkout(self)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 788, in _checkout
    fairy = _ConnectionRecord.checkout(pool)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 529, in checkout
    rec = pool._do_get()
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 1193, in _do_get
    self._dec_overflow()
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/util/langhelpers.py", line 66, in __exit__
    compat.reraise(exc_type, exc_value, exc_tb)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/util/compat.py", line 249, in reraise
    raise value
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 1190, in _do_get
    return self._create_connection()
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 347, in _create_connection
    return _ConnectionRecord(self)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 474, in __init__
    self.__connect(first_connect_check=True)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/pool.py", line 671, in __connect
    connection = pool._invoke_creator(self)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/engine/strategies.py", line 106, in connect
    return dialect.connect(*cargs, **cparams)
  File "/Users/li/workshop/virtualenv/venv3/lib/python3.7/site-packages/sqlalchemy/engine/default.py", line 412, in connect
    return self.dbapi.connect(*cargs, **cparams)
  File "src/pymssql.pyx", line 642, in pymssql.connect
sqlalchemy.exc.OperationalError: (pymssql.OperationalError) (20002, b'DB-Lib error message 20002, severity 9:\nAdaptive Server connection failed\n') (Background on this error at: http://sqlalche.me/e/e3q8)

```

# freeTDS
