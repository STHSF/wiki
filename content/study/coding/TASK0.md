---
title: "Task0"
layout: page
date: 2018-08-04 00:00
---
[TOC]

# 写在前面
 【数组】 实现一个支持动态扩容的数组
实现一个大小固定的有序数组，支持动态增删改操作
- 实现两个有序数组合并为一个有序数组
- 学习哈希表思想，并完成leetcode上的两数之和(1)及Happy Number(202)！(要求全部用哈希思想实现！)（选做）（注意：在第四天会进行继续学习）

【链表】
- 实现单链表、循环链表、双向链表，支持增删操作
- 实现单链表反转
- 实现两个有序的链表合并为一个有序链表
实现求链表的中间结点
##  Three Sum（求三数之和）
给定一个包含 n 个整数的数组 nums，判断 nums 中是否存在三个元素 a，b，c ，使得 a + b + c = 0 ？找出所有满足条件且不重复的三元组。

注意：答案中不可以包含重复的三元组。

例如, 给定数组 nums = [-1, 0, 1, 2, -1, -4]，

满足要求的三元组集合为：
[
  [-1, 0, 1],
  [-1, -1, 2]
]

## python代码
```
class Solution(object):
    def threeSum(self, nums):
        """
        :type nums: List[int]
        :rtype: List[List[int]]
        """
        res_list = []
        nums.sort()
        for i in range(len(nums)):
            if nums[i] > 0:
                break
            if i > 0 and nums[i] == nums[i-1]:
                continue
            j = i + 1
            k = len(nums) - 1
            while j < k:
                if nums[j] + nums[k] == -nums[i]:
                    res_list.append([nums[i], nums[j], nums[k]])
                    while j < k and nums[j] == nums[j+1]: j += 1
                    while j < k and nums[k] == nums[k-1]: k -= 1
                    j += 1
                    k -= 1
                elif nums[j] + nums[k] < -nums[i]:
                    j += 1
                else:
                    k -= 1
        return res_list
```


## Majority Element（求众数）
```
class Solution:
    def majorityElement(self, nums: List[int]) -> int:
        if len(nums)==1:
            return nums[0]
        numDic = {}
        for i in nums:
            if numDic.has_key(i):
                numDic[i] += 1
                if numDic.get(i)>=(len(nums)+1)/2:
                    return i
            else:
                numDic[i] = 1
```

## Missing Positive（求缺失的第一个正数）[作为可选]
```
class Solution:
    def firstMissingPositive(self, Metric):
        i = 0
        while i < len(Metric):
            if Metric[i] > 0 and Metric[i] - 1 < len(Metric) and Metric[i] != Metric[Metric[i]-1]:
                Metric[Metric[i]-1], Metric[i] = Metric[i], Metric[Metric[i]-1]
            else:
                i += 1
        for i, integer in enumerate(Metric):
            if integer != i + 1:
                return i + 1
        return len(Metric) + 1
```
## Linked List Cycle I（环形链表）

## Merge k Sorted Lists（合并 k 个排序链表）


# 参考文献