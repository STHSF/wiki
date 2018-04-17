from javis_data import JavisData

uid = 142
token = 'adc28ac69625652b46d5c00b'
symbol = 'ag1601.SHFE'
start_time = '2017-1-06 14:01:12'
end_time = '2017-1-06 15:10:00'
dir = './test'
clt =  JavisData()
# filename = '/home/jerry/workshop/temp/142/ag1701/ag1701_20170103.jcsv'
filename = '/home/jerry/workshop/temp/rb0001/rb0001_20170105.jcsv'
# clt.read_local_data(filename)

# clt.read_local_data('/kywk/strategy/strange/future/142/ag1706/ag1706_20161026.jcsv')
# clt.read_local_data('/home/jerry/workshop/temp/142/ag1701/ag1701_20170106.jcsv') 
# clt.read_local_data('/home/jerry/workshop/temp/142/ag0001/ag0001_20170103.jcsv')
# clt.read_data(symbol, start_time, end_time)
print clt.read_data_pd(filename)
#print clt.read_data_pd('../strange/data/ag1601_20160114.jcsv')
#clt.calcu_dominant('/kywk/strategy/strange/future/142')
#clt.calcu_dominant('./data/temp/')
print "end==>"


# 遍历指定目录，显示目录下的所有文件名
import os
def eachFile(filepath):
    filename_list = []
    pathDir =  os.listdir(filepath)
    for allDir in pathDir:
        child = os.path.join('%s%s' % (filepath, allDir))
        filename_list.append(child.decode('utf-8')) # 是解决中文显示乱码问题
    return filename_list
filename_list = eachFile('/home/jerry/workshop/temp/rb0001/')
# filename = eachFile('/home/jerry/workshop/temp/142/ag0001/')
filename_list.sort()
len(filename_list)


# 合并每天的数据
import pandas as pd

content_list = []
for filename in filename_list:
    print filename
    content_list.append(clt.read_data_pd(filename))
    
print len(content_list)
    
result = pd.concat(content_list, ignore_index=True)
result
result.to_csv('result.csv')



# 计算每个交易日的日开盘价，收盘价，最高价和最低价,以及趋势策略的盈利指标
# 没有剔除夜盘数据
import numpy as np
from datetime import datetime

result_no_list = pd.DataFrame(columns = ['date', 'open', 'close', 'high', 'low', 'R', 'r'])

for filename in filename_list:
    print filename
    date = filename.split('_')[-1].split('.')[0]
    date = datetime.strptime(date, '%Y%m%d').strftime('%Y-%m-%d') # 根据字符串本身的格式进行转换
    print date
    # 没有剔除夜盘计算日高开低收
    result = clt.read_data_pd(filename)
    daily_open = result['open'][1] # 当日开盘价，从第二条数据开始，因为第一条数据是8点59或者是20点59的数据
    daily_close = result['close'].iloc[-1] # 当日收盘价
    daily_low = min(np.array(result['low'])) # 当日最低价
    daily_high = max(np.array(result['high'])) # 当日最高价
    R = abs(daily_close - daily_open) / (daily_high - daily_low) # 趋势策略盈利指标
    if R <=0.5:
        r = 0
    else:
        r = 1
    print("daily_open：%s, daily_close：%s"%(daily_open, daily_close))
    print("daily_high：%s, daily_low：%s"%(daily_high, daily_low))
    print("盈利指标：%s" % R)
    result_no_list = result_no_list.append({'date':date, 'open':daily_open, 'close':daily_close, 'high':daily_high, 'low':daily_low, 'R':R, 'r':r}, ignore_index=True)
# result_no_list.to_csv('zhibiao_nofilter.csv')
print(result_no_list)


import numpy as np

y = np.array(result_no_list['r']).tolist().count(1)
n = np.array(result_no_list['r']).tolist().count(0)
print("统计适合做趋势策略的个数为：%s"% y)
print("统计不适合做趋势策略的个数为：%s"% n)



# 训练集标签计算
# 计算每个交易日的日开盘价，收盘价，最高价和最低价，以及趋势策略的盈利指标
# 剔除了夜盘数据
import numpy as np
import pandas as pd
from datetime import datetime

label_result_list = pd.DataFrame(columns = ['date', 'open', 'close', 'high', 'low', 'R', 'r'])
for filename in filename_list:
    print filename
    date = filename.split('_')[-1].split('.')[0]
    date = datetime.strptime(date, '%Y%m%d').strftime('%Y-%m-%d') # 根据字符串本身的格式进行转换
    print("date: %s"%date)
    # 剔除了夜盘计算高开低收
    result = clt.read_data_pd(filename)
    for i in range(len(result)):
        result['mtd'].loc[i] = result['date'].loc[i].split(' ')[0]
    result = result[result['mtd'] == date].reset_index(drop = True)
    # print(result)
    daily_open = result['open'][0] # 当日开盘价
    daily_close = result['close'].iloc[-1] # 当日收盘价
    daily_low = min(np.array(result['low'])) # 当日最低价
    daily_high = max(np.array(result['high'])) # 当日最高价
    R = abs(daily_close - daily_open) / (daily_high - daily_low)# 趋势策略盈利指标
    if R <=0.5:
        r = 0
    else:
        r = 1
    print("daily_open：%s, daily_close：%s"%(daily_open, daily_close))
    print("daily_high：%s, daily_low：%s"%(daily_high, daily_low))
    print("盈利指标：%s, %s" % (R, r))
    label_result_list = label_result_list.append({'date': date, 'open': daily_open, 'close': daily_close, 'high': daily_high, 'low': daily_low, 'R': R, 'r': r}, ignore_index=True)

# label_result_list.to_csv('zhibiao_filter.csv') # 数据保存
print(label_result_list)



import numpy as np

y = np.array(label_result_list['r']).tolist().count(1)
n = np.array(label_result_list['r']).tolist().count(0)
print("统计适合做趋势策略的个数为：%s"% y)
print("统计不适合做趋势策略的个数为：%s"% n)



import plotly.offline as py
import plotly.graph_objs as go

py.init_notebook_mode(connected=True)

graph = [
    go.Scatter( marker=dict(color="#1A1"),
        x=result['date'],
        y=result['high'],
        name='high'
    ),
    go.Scatter(
        x=result['date'],
        y=result['low'],
        name='low',
        yaxis='y2',
        line={ 'color':'#E00' },
    )    
]
layout = go.Layout(
    title='open/close',
    xaxis=dict(
        type='category'
    ),
    yaxis=dict(
        title='tongjishuju'
    ),
    yaxis2=dict(
        title='close',
        side='right',
        overlaying='y'
    )
)
fig = go.Figure(data=graph, layout=layout)
py.iplot(fig, filename='画图测试')



# 训练集准备
# 剔除了夜盘数据
import numpy as np
import pandas as pd
from datetime import datetime

point_results = []
for filename in filename_list[4:5]:
    print filename
    date = filename.split('_')[-1].split('.')[0]
    date = datetime.strptime(date, '%Y%m%d').strftime('%Y-%m-%d') # 根据字符串本身的格式进行转换
    print("date: %s"%date)
    # 剔除了夜盘计算高开低收
    result = clt.read_data_pd(filename)
    for i in range(len(result)):
        result['mtd'].loc[i] = result['date'].loc[i].split(' ')[0]
    result = result[result['mtd'] == date].reset_index(drop = True)
    print(result.head(31))
    result_pre = result.head(31)[['open', 'close', 'high', 'low', 'pabp', 'pabv', 'pasp', 'pasv', 'plbp', 'plbv', 'plsp', 'plsv', 'vol']]
    daily_result = np.array(result_pre)
    m, n = np.shape(daily_result)
    point_results.append((date, daily_result.reshape(m*n)))
print(point_results)
    




# 训练集准备
# 剔除了夜盘数据
import time
import numpy as np
import pandas as pd
from datetime import datetime

def timetra(date):
    # 时间格式转换
    timeArray = time.strptime(date, "%Y-%m-%d %H:%M:%S")
    timestamp = time.mktime(timeArray)
    return int(timestamp)
    
point_results = []
for filename in filename_list:
    print filename
    date = filename.split('_')[-1].split('.')[0]
    date = datetime.strptime(date, '%Y%m%d').strftime('%Y-%m-%d') # 根据字符串本身的格式进行转换
    print("date: %s"%date)
    # 白天的交易时间
    start_date = date + ' 09:00:00'
    stop_date = date + ' 15:00:00'
    start_tamp = timetra(start_date)
    stop_tamp = timetra(stop_date)
    # print("start_tmp: %s" %start_tamp)
    # 剔除夜盘计算高开低收，通过时间戳来判断
    result = clt.read_data_pd(filename)
    for i in range(len(result)):
        #转换成时间数组
        timeArray = time.strptime(result['date'].loc[i], "%Y-%m-%d %H:%M:%S")
        #转换成时间戳
        timestamp = time.mktime(timeArray)
        result['mtd'].loc[i] = int(timestamp)
    result = result[(result['mtd'] >= start_tamp) &(result['mtd'] <= stop_tamp)].reset_index(drop=True)
    # print("原始数据: %s" %result.head(10))
    print("原始数据长度：%s" %len(result))
    # 脏数据筛选，result中已经通过时间戳将对应时间的数据提取出来了，如果分钟数据缺失，则每个交易日的数据量则不到227个。
    length_result = len(result)
    if length_result == 228:
        # 提取前三十分钟的数据作为训练集
        result_pre = result.head(29)[['open', 'close', 'high', 'low', 'pabp', 'pabv', 'pasp', 'pasv', 'plbp', 'plbv', 'plsp', 'plsv', 'vol']]
        # print("result_pre: %s"% result_pre)
        daily_result = np.array(result_pre)
        m, n = np.shape(daily_result)
        point_results.append((date, daily_result.reshape(m*n)))
    elif length_result > 228:
        # 剔除时间重复的数据
        result = result.drop_duplicates(['mtd'])
        # print("去重后的原始数据： %s"%result.head(10))
        print("去重后的原始数据长度：%s" %len(result))
        result_pre = result.head(29)[['open', 'close', 'high', 'low', 'pabp', 'pabv', 'pasp', 'pasv', 'plbp', 'plbv', 'plsp', 'plsv', 'vol']]
        daily_result = np.array(result_pre)
        m, n = np.shape(daily_result)
        point_results.append((date, daily_result.reshape(m*n)))
    else:
        # 数据补全
        print(result.head())
        print('continue')
        continue

print(len(point_results))


# 数据保存
# pd.DataFrame(np.array(results)).to_csv('results.csv')
print(point_results)
print(label_result_list)




# 根据每个交易日，将清洗好的数据整理成[label, point]的形式
# label是指适不适合趋势交易
# point是指早盘的特征序列
import numpy as np

label_list = label_result_list
point_list = point_results

label_point_list = []
for i in point_list:
    date, data = i[0], i[1]
    tmp = label_list[label_list['date'].isin([date])]
    label_point_list.append((tmp['r'].get_values()[0], data))
print(len(label_point_list))
print(label_point_list)




