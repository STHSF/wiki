---
title: "pandas基础知识--类对象继承.md"
layout: page
date: 2018-01-30 13:00
---

# enumerate
```
# 父类
class Dog:
    @staticmethod
    def bark(a, b):
        name = a+b
        print(name)
        return name

    def eat(self, a, b, c):
        print(c)
        return self.bark(a, b)


# 子类 继承
class XiaoTianQuan(Dog):
    c = 1

    def bark(self, a, b):
        return super().bark(a, b) + self.c

    # 可以重写父类中的同名方法
    def eat(self, a, b, c):
        print("神一样的叫唤...")
        tmp = super().eat(a, b, c)
        print(tmp)
        res = tmp + c
        return res


xtq = XiaoTianQuan()
print(xtq.eat(1, 2, 3))
```

#### 疑问, XTQ.eat()调用的是哪个bark