---
title: "sortList"
layout: page
date: 2018-06-02 00:00
---
[TOC]

# 写在前面
合并 k 个排序链表，返回合并后的排序链表。请分析和描述算法的复杂度。

示例:

输入:
[
  1->4->5,
  1->3->4,
  2->6
]
输出: 1->1->2->3->4->4->5->6

# python代码
```
# Definition for singly-linked list.
class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None

class Solution:
    def mergeKLists(self, lists: List[ListNode]) -> ListNode:

        all_node=[]
        for x in lists:
            while x is not None:
                all_node.append(x)
                x = x.next

        all_node_sort = sorted(all_node,key=lambda node:node.val)
        pro = ListNode(-1)
        p = pro
        for node in all_node_sort:
            p.next = node
            p = node
        p.next = None
        return pro.next
```
# 参考文献