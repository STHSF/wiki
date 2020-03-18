---
title: "Tensorflow基础知识---使用multi_gpu_model并行训练并使用ModelCheckpoint()保存模型可能遇到的问题"
layout: page
date: 2020-03-18 13:00
---

[TOC]

# 写在前面
keras在调用多GPU训练模型的时候会使用到multi_gpu_model()来封装原来的model, 然后指定GPU使用数目即可, 详见下面的代码片段.
```python
model = BertBasic(pre_trained_model_conf, drop_rate)
model = model.build_base_model()

parallel_model = multi_gpu_model(model, 2)
parallel_model.compile(loss='sparse_categorical_crossentropy',
                       optimizer=Adam(2e-5),
                       metrics=['accuracy'])
```
训练阶段使用MultiGPU, 推理阶段不一定需要多gpu, 所以可以使用model.load_weights()的方式导入模型, 但实际上如果使用回调函数ModelCheckpoint()来保存模型权重之后, 如果不做其他的修改依然只能使用parallel_model.load_weights()导入模型, 如果使用model.load_weights()导入模型, 则会报下面的错误:
```
```
为了解决这个问题, 需要对ModelCheckpoint()做调整, 调整的代码如下:

```python
class ParallelModelCheckpoint(ModelCheckpoint):
    def __init__(self, model, filepath, monitor='val_loss', verbose=0,
                 save_best_only=False, save_weights_only=False,
                 mode='auto', period=1):
        self.single_model = model
        super(ParallelModelCheckpoint, self).__init__(filepath, monitor, verbose, save_best_only, save_weights_only,
                                                      mode, period)

    def set_model(self, model):
        super(ParallelModelCheckpoint, self).set_model(self.single_model)
```
然后callbacks则改写成:

```python
checkpoint = ParallelModelCheckpoint(model,
                                     model_save_path,
                                     monitor='val_loss',
                                     verbose=1,
                                     save_best_only=True,
                                     save_weights_only=True)  # 保存最好的模型
```
片段中的model是调用multi_gpu_model()之前的model, 对应修改之后推理过程中就可以直接用单模型load模型权重了.

但是实际上,该方法原始不是解决这个问题的, 而是如下的问题:
```
TypeError: can't pickle ...(different text at different situation) objects
```
这个错误形式其实跟使用多 gpu 训练时保存模型不当造成的错误比较相似：

```
To save the multi-gpu model, use .save(fname) or .save_weights(fname)
with the template model (the argument you passed to multi_gpu_model),
rather than the model returned by multi_gpu_model.
```

# 参考文献
[使用多 gpu 并行训练并使用 ModelCheckpoint() 可能遇到的问题](https://blog.csdn.net/u012862372/article/details/80367607)

[Keras多GPU训练指南](https://yq.aliyun.com/articles/230182)

[Keras多GPU训练](https://www.jianshu.com/p/4203a6435ab5)
