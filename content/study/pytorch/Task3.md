---
title: "Task3"
layout: page
date: 2019-08-09 00:00
---
[TOC]

# 写在前面
PyTorch实现Logistic regression 

1.PyTorch基础实现代码

2.用PyTorch类实现Logistic regression,torch.nn.module写网络结构

# python代码
```
import torch
from torch.autograd import Variable
import torch.nn.functional as F
 
x_data = Variable(torch.Tensor([[1.0], [2.0], [3.0], [4.0]]))
y_data = Variable(torch.Tensor([[0], [0], [1], [1]]))
 
 
# step1
class Model(torch.nn.Module):
    def __init__(self):
        super(Model, self).__init__()
        self.linear = torch.nn.Linear(1, 1)  # one in and one out
 
    def forward(self, x):
        y_pred = F.sigmoid(self.linear(x))
        return y_pred
 
 
# our model
model = Model()
 
# step2
# Construct our loss function and an Optimizer. The call to model.parameters()
# in the SGD constructor will contain the learnable parameters of the two
# nn.Linear modules which are members of the model.
criterion = torch.nn.BCELoss(size_average=True)
optimizer = torch.optim.SGD(model.parameters(), lr=0.01)
 
# Training loop
 
for epoch in range(1000):
    # Forward pass: Compute predicted y by passing x to the model
    y_pred = model(x_data)
 
    # compute loss and print loss
    loss = criterion(y_pred, y_data)
    # print(epoch, loss.data[0])
 
   # Zero gradients ,perform a backward pass,and update weights.
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
 
# After training
hour_var=Variable(torch.Tensor([[1.0]]))
print("predict 1 hour",1.0,model(hour_var).data[0][0]>0.5)
hour_var=Variable(torch.Tensor([[7.0]]))
print("predict 1 hour",7.0,model(hour_var).data[0][0]>0.5)
```

输出
```
predict 1 hour 1.0 tensor(0, dtype=torch.uint8)
predict 1 hour 7.0 tensor(1, dtype=torch.uint8)
```
# 参考文献