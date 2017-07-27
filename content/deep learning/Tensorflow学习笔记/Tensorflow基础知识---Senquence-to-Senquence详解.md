---
title: "Tensorflow基础知识---Senquence-to-Senquence详解"
layout: page
date: 2017-07-06 00:00
---

# 写在前面
Seq2Seq是基于tensorflow的一种通用编码器&解码器框架，可用于机器翻译，文本摘要，会话模型，图像描述等。

# Sequence_to_Sequence Model
常见的语言模型的研究对象是单一序列，例如（文本生成），而Sequence_to_Sequence Model同时研究两个序列之间的关系。Encoder-Decoder的基本结构如下：
<img src="/wiki/static/images/seq2seq/Encoder-Decoder基本结构.jpg" alt="Encoder-Decoder基本结构"/>
表示sequence ABC被翻译成sequence WXYZ， 其中<EOS>是一句话的结束符。

上图是一个已经在时间维度上展开的Encoder-Decoder模型，典型的Sequence_to_Sequence Model通常是由两个RNN网络构成，一个被称为编码器，另一个被称为译码器，encoder负责把variable-length的序列编码成一个固定大小的语义表示向量(fixed-length vector representation)，我们可以理解为把一段文本进行语义表示。decoder则负责把encoder得到的fixed-length的语义向量解码成另一个variable-length的token序列，这个token序列就是另一个sequence，并且每个时刻t输出词的概率都与前t-1时刻的输出有关。优化时采用极大似然估计，让encoder前的序列A被encoder后在decoder得到的序列B的概率最大。在这里序列A和B的长度是可以不一样的。

我们将上面的模型展开可以得到：
<center><img src="/wiki/static/images/seq2seq/encoder-decoder.png" alt="Encoder-Decoder展开"/></center>

## Encoder
Encoder的过程比较简单，一般直接用RNN(LSTM,GRU,RNN等)进行语义向量的生成，上图中每个圆圈代表一个RNNCell，每个time_step，我们能向Encoder中输入一个字/词（一般是表示这个字/词的一个实数向量），直到输入这个句子的最后一个字/词$(X_T)$,然后输出整个句子的语义向量c(一般的，$(c=h_{X_T})$，$(X_T)$是最后一个输入)。

因为RNN的特点就是把前面每一步输入信息都考虑进来了，所以理论上这个c就能够包含整个句子的信息。因此，c可以作为这个句子的一种语义表示。即为该句的句向量。
$$
h_t = f(x_t, h_{t-1})
$$
$$
c = \phi(h_1,h_2,...,h_T)
$$
其中f是非线性激活函数，可以是sigmod、tan、relu、lstm等，$(h_{t-1})$是上一个隐节点输出，$(x_t)$是当前时刻的输入，向量c通常为RNN的最后一个隐节点（h,Hidden state）,或者是多个隐节点的加权和。
## Decoder
在Decoder过程中，就是一步步将句向量c中蕴含的信息分析出来。编码完成后，我们的语义向量c会进入一个RNN解码器中进行解释，简单说，解释的过程就是被理解为运用贪心算法（一种局部最优解算法，即选取一种度量标准，默认在当前状态下进行最好的选择）来返回对应概率最大的词汇，或是通过集束搜索（Beam Search，一种启发式搜索算法，可以基于设别性能给予时间允许内的最优解）在序列输出检索大量的词汇，从而得到最优选择。

该模型的decoder过程是使用另一个RNN通过当前状态$(s_t)$来预测当前的输出符号$(y_t)$, 其中的$(s_t)$,$(y_t)$都与其前一个隐状态和输出有关：
$$
s_t= f(s_{t-1}, y_{t-1}, c)
$$
同样，根据$(s_t)$我们就可以求出$(y_t)$的条件概率
$$
P(y_t|y_{t-1},...,y_1,c)=g(s_t, y_{t-1}, c)
$$
这里有两个函数$(f)$和$(g)$，一般来说，f函数结构应该是一个RNNCell结构或者类似的结构；g函数一般是softmax。我们可以这样理解，在Encoder中我们得到一个涵盖整个句子信息的实数向量c，现在我们一步步从c中抽取信息。
首先给Decoder一个启动信号$(y_0)$(如特殊符号<START>),然后Decoder根据$(s_0,y_0,c)$就能够计算出$(y_1)$的概率分布了，同理，根据$(s_1, y_1, c)$可以计算$(y_2)$的概率分布，依此类推直到预测到结束的特殊标志<END>,才结束预测。
[github](https://github.com/nicolas-ivanov/tf_seq2seq_chatbot)上有一张更详细的图：
<center><img src="/wiki/static/images/seq2seq/encoder-decoder展开.png" alt="Encoder-Decoder详细展开"/></center>

上图展示的是一个邮件对话的应用场景，图中的 Encoder 和 Decoder 都只展示了一层的普通的 LSTMCell。从上面的结构中，我们可以看到，整个模型结构还是非常简单的。 EncoderCell 最后一个时刻的状态 $([c_{X_T},h_{X_T}])$ 就是上面说的中间语义向量 c ，它将作为 DecoderCell 的初始状态。然后在 DecoderCell 中，每个时刻的输出将会作为下一个时刻的输入。以此类推，直到 DecoderCell 某个时刻预测输出特殊符号 <END> 结束。

在原论文中，作者使用的是4层LSTM，原理上跟1层LSTM是一样的，[CS224n](http://web.stanford.edu/class/cs224n/lectures/cs224n-2017-lecture1.pdf)中给我们提供了一个三层的模型结构有助于我们对Encode-Decode的理解：
<center><img src="/wiki/static/images/seq2seq/4-level-encode-decode.jpg" alt="Encoder-Decoder-4层展开"/></center>

## Attention Mechanism
当Encode的序列过长时，会导致c保留的信息缺失，[Bahdanau](https://arxiv.org/pdf/1409.0473.pdf)在Encoder和Decoder的基础上提出了注意力机制，
注意力机制模型主要的修改在decoder过程，传统的decoder中，每次预测下个词都会用到语义向量词c，而传统的decoder中的c主要是最后一个时刻的隐藏状态，这就意味着不管decoder生成的哪个单词，句子X中的任意单词对生成某个目标单词$(y_i)$的影响是相同的，也就是说没有加入注意力机制模型的encoder-decoder模型，目标序列对预测序列的贡献是相同的，例如，在翻译模型当中，每个被翻译目标单词对与翻译目标单词的贡献显然是不同的，
而传统的encoder-decoder模型无法体现这一点，这就是为何说它没有引入注意力机制的原因。没有引入注意力机制的模型在输入句子比较短的时候估计问题不大，但是如果输入句子比较长，此时所有语义完全通过一个中间语义向量来表示，单词自身的信息已经消失，可想而知会丢失很多细节信息，这也是为何要引入注意力模型的重要原因。

而注意力机制在decoder预测的时候，将encoder中每个时刻的隐藏状态都利用上了，这样，encoder过程中的多个语义信息(隐藏状态)就可以都被利用来表达整个句子的信息了。增加了注意力机制模型的encoder-decoder框架理解起来如下图所示：
<center><img src="/wiki/static/images/seq2seq/am-encoder-decoder.jpg" alt="attention mechanism模型理解"/></center>
此时目标单词生成的过程如下：
$$
y_1 = f(c_1)\\
y_2 = f(c_2, y_1)\\
y_3 = f(c_3, y_2, y_1)\\
$$
其中，每个$(c_i)$可能对应着不同的源语句子单词的注意力分配概率分布(对应输入序列X不同单词的概率分布).
另外，在encoder的过程中还使用了双向循环网络(bidirection RNN)，这比单向的效果要好。模型结构见下图：
<center><img src="/wiki/static/images/seq2seq/attention mechanism.png" alt="attention mechanism模型结构"/></center>
如上图所示, 在注意机制中，我们的源序列$(x=(x_1, x_2, ...., x_t))$分别被正向和反向地输入模型，进而得到了正反两层隐节点，语义向量c则由RNN中的隐节点的隐状态h通过不同权重$(\alpha)$加权而成，其公式如下：
$$
c_i=\sum_{j=1}^{n}{\alpha_{ij}h_{j}}
$$
其中n为输入序列的长度，$(h_j)$是第j时刻的隐状态，而权重$(\alpha_{ij})$的计算公式如下：
$$
\alpha_{ij} = \frac{exp(e_{ij})}{\sum_{k=1}^nexp(e_{ik})}
$$
这里：
$$
e_{ij} = \eta(s_{i-1}, h_j)
$$
其中，$(\eta)$为一个调整“注意回应强度”的函数,是一种对齐模型，$(s_{i-1})$是decoder过程的前一个隐状态的输出，$(h_j)$是encoder过程的当前第j个隐状态。

我们知道每一个隐节点$(h_i)$都包含了对应的输入字符$(x_i)$以及其对上下文的联系，这么做意义就在于现在模型可以突破固定长度输入的限制，根据不同的输入长度构建不同个数的隐节点，故不论我们输入的序列（比如待翻译的一段原文）长度如何，都可以得到模型输出结果。

# Tensorflow中的Seq2Seq


# 应用领域
- 机器翻译
- 智能对话和问答
- 自动编码与分类器训练
    
    2015年，Google的Andrew M.Dai和Quo V.Le提出了将Seq2Seq的自动编码器作为LSTM文本分类的一个预训练步骤，从而提高了分类的稳定性。这使得Seq2Seq技术的目的不再局限于得到序列本身，为其应用领域翻开了崭新的一页。

# 参考文献
[通用编码器&解码器框架seq2seq](https://www.oschina.net/p/seq2seq)

[seq2seq学习笔记](http://blog.csdn.net/jerr__y/article/details/53749693)

[Seq2Seq的DIY简介](http://www.jianshu.com/p/124b777e0c55)

[The DIY Guide to Seq2Seq](https://github.com/jxieeducation/DIY-Data-Science/blob/master/research/seq2seq.md)

[从LSTM到Seq2Seq](http://x-algo.cn/index.php/2017/01/13/1609/)

[Junwei Pan's Blog](http://www.kemaswill.com/about/)

[TensorFlow中Sequence-to-Sequence样例代码详解](http://blog.csdn.net/diligent_321/article/details/53590289)

[sequence_loss_by_example(logits, targets, weights)](http://blog.csdn.net/appleml/article/details/54017873)

[tensorflow的legacy_seq2seq模块](http://blog.csdn.net/u012871493/article/details/72350332)

[tf.contrib.legacy_seq2seq.sequence_loss_by_example](https://www.tensorflow.org/api_docs/python/tf/contrib/legacy_seq2seq/sequence_loss_by_example)

[tensorflow学习笔记（十一）：seq2seq Model](http://www.2cto.com/kf/201611/561130.html)

[tensorflow学习笔记（十一）：seq2seq Model相关接口介绍](http://blog.csdn.net/u012436149/article/details/52976413)

[RNN回归例子](http://www.360doc.com/content/17/0321/10/10408243_638692790.shtml)

[Styles of Truncated Backpropagation](https://r2rt.com/styles-of-truncated-backpropagation.html)

[lstm分类的例子涉及dynamic_nn](http://www.360doc.com/content/17/0321/10/10408243_638692495.shtml)

[tensorflow高阶教程:tf.dynamic_rnn](http://blog.csdn.net/u010223750/article/details/71079036)

[ tensorflow笔记：多层LSTM代码分析](http://blog.csdn.net/u014595019/article/details/52759104)

[RNNs in Tensorflow, a Practical Guide and Undocumented Features](http://www.wildml.com/2016/08/rnns-in-tensorflow-a-practical-guide-and-undocumented-features/)

[解析Tensorflow官方PTB模型的demo](http://blog.csdn.net/mydear_11000/article/details/52440115)

[tensorflow0.10.0 ptb_word_lm.py 源码解析](http://blog.csdn.net/u012436149/article/details/52828786)

[ tensorflow学习笔记（二十六）：构建TF代码](http://blog.csdn.net/u012436149/article/details/53843158)

[tensorflow学习笔记（三）：损失函数](http://blog.csdn.net/u012436149/article/details/52874718)