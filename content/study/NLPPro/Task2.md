---
title: "Task2"
layout: page
date: 2019-08-09 00:00
---
[TOC]

# 写在前面
- 学习词袋模型概念：离散、高维、稀疏。
- 学习分布式表示概念：连续、低维、稠密。
- 理解word2vec词向量原理并实践，来表示文本。
- word2vec 中的数学原理详解  word2vec1 
- word2vec原理推导与代码分析  word2vec2

# 词袋模型
词袋模型是在自然语言处理和信息检索中的一种简单假设。在这种模型中，文本（段落或者文档）被看作是无序的词汇集合，忽略语法甚至是单词的顺序。

词袋模型被用在文本分类的一些方法当中。当传统的贝叶斯分类被应用到文本当中时，贝叶斯中的条件独立性假设导致词袋模型。另外一些文本分类方法如LDA和LSA也使用了这个模型。

# 分布式表示
### 分布表示(distributional representation)
从高维向量中捕捉每个词语的语义分布，通常基于共现计数，该模型基于分布假说

分布（distributional）描述的是上下文的概率分布，因此用上下文描述语义的表示方法（基于分布假说的方法）都可以称作分布表示。与之相对的是形式语义表示。

### 分布式表示(distributed representation)
高维向量的词的子符号表示，向量的相似性对应于语义的相似性，最主要的代表是基于神经网络的词嵌入

分布式（distributed）描述的是把信息分布式地存储在向量的各个维度中，与之相对的是局部表示（local representation），如词的独热表示（one-hot representation），在高维向量中只有一个维度描述了词的语义。一般来说，通过矩阵降维或神经网络降维可以将语义分散存储到向量的各个维度中，因此，这类方法得到的低维向量一般都可以称作分布式表示。

# word2vec词向量模型
### one-hot编码
One-Hot 编码，又称一位有效编码，其方法是使用N位状态寄存器来对N个状态进行编码，每个状态都有它独立的寄存器位，并且在任意时候，其中只有一位有效。

### word2vec
word2vec模型其实就是简单化的神经网络。
输入是One-Hot Vector，Hidden Layer没有激活函数，也就是线性的单元。Output Layer维度跟Input Layer的维度一样，用的是Softmax回归。当这个模型训练好以后，我们并不会用这个训练好的模型处理新的任务，我们真正需要的是这个模型通过训练数据所学得的参数，例如隐层的权重矩阵。

这个模型是如何定义数据的输入和输出呢？一般分为CBOW(Continuous Bag-of-Words 与Skip-Gram两种模型。CBOW模型的训练输入是某一个特征词的上下文相关的词对应的词向量，而输出就是这特定的一个词的词向量。　Skip-Gram模型和CBOW的思路是反着来的，即输入是特定的一个词的词向量，而输出是特定词对应的上下文词向量。CBOW对小型数据库比较合适，而Skip-Gram在大型语料中表现更好。

# python实现word2vec
python的gensim包实现了word2vec的封装

```
import gensim.models

# 词库
lineIterator = lineIterator_list
# 训练word2vec modle
model = gensim.models.Word2Vec()
model.build_vocab(lineIterator)
model.train(lineIterator,total_examples=model.corpus_count,epochs=1)
```

# 参考文献