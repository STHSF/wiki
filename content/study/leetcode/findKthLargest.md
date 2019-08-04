---
title: "findKthLargest"
layout: page
date: 2018-08-03 14:00
---
[TOC]

# 写在前面
在未排序的数组中找到第 k 个最大的元素。请注意，你需要找的是数组排序后的第 k 个最大的元素，而不是第 k 个不同的元素。

示例 1:

输入: [3,2,1,5,6,4] 和 k = 2
输出: 5
示例 2:

输入: [3,2,3,1,2,4,5,5,6] 和 k = 4
输出: 4
说明:

你可以假设 k 总是有效的，且 1 ≤ k ≤ 数组的长度。

# python代码
```python
class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        index = 0
        tmp = []
        while True:
            index = len(tmp)
            p = max(nums)
            tmp.append(p)
            nums.remove(p)
            index = index + 1
            if index == k:
                return tmp[-1]
                break
```
# 参考文献