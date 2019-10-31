---
title: "pandas基础知识--sqlalchemy.md"
layout: page
date: 2019-01-30 13:00
---

# python sqlite直接获取数据
```python
import sqlite3

con = sqlite3.connect('./real_tune_record.db')
read_sql = 'select * from pos_record'

# read
try:
    pos_record = pd.read_sql(read_sql, con)
    previous_pos = pos_record[pos_record['trade_date'] == str(ref_date_pre)]
except Exception as e:
    alpha_logger.info('pos_record Exception:{0}'.format(e))
    previous_pos = pd.DataFrame({'trade_date':[], 'weight':[],'industry':[], 'er':[],'code':[]})

# write
previous_pos.to_sql('pos_record', con=con, if_exists='replace', index=False)
```

# sqlalchemy操作
```python
import sqlalchemy as sa

engine = sa.create_engine('sqlite:////home/jupyter/jerry/workshop/MultiFactors/src/stacking/notebooks/real_tune_record.db')

# read
try:
    pos_record = pd.read_sql('pos_record', engine)
    previous_pos = pos_record[pos_record['trade_date'] == ref_date_pre]
except Exception as e:
    alpha_logger.info('pos_record Exception:{0}'.format(e))
    previous_pos = pd.DataFrame({'trade_date':[], 'weight':[],'industry':[], 'er':[],'code':[]})

# write
previous_pos.to_sql(table_name, engine, index=False, if_exists='append', chunksize=100)
```





[pandas +sqlalchemy读写oracle数据库](https://blog.csdn.net/walking_visitor/article/details/84023393)