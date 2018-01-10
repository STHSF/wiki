---
title: "python普通继承方式和super继承方式对比"
layout: page
date: 2018-01-09 00:00
---

# 类的一般继承和super(), 两者的对比
```
# super()继承
class Base(object):
    def __init__(self):
        self._a = 0
        self._b = 0
        print 'enter base'
        print 'leave base'

    def a(self):
        return self._a

    def b(self):
        return self._b

    def aa(self):
        c = self.a() + self.b()
        return c


class childA(Base):
    def __init__(self):
        self._c = 1
        print 'enter childA'
        super(childA, self).__init__()
        print 'leave childA'

    def c(self):
        return self._c

    def aa(self):
        d = self.a() + self.b() + self.c() + b
        return d


class childB(Base):
    def __init__(self):
        print 'enter childB'
        super(childB, self).__init__()
        print 'leave childB'


class childC(Base):
    def __init__(self):
        print 'enter childC'
        super(childC, self).__init__()
        print 'leave childC'


class childD(childB, childC, childA):
    def __init__(self):
        print 'enter childD'
        super(childD, self).__init__()
        print 'leave childD'

childD()
```

输出：
```
enter childD
enter childB
enter childC
enter childA
enter base
leave base
leave childA
leave childC
leave childB
leave childD
```

```
# 一般继承
class Base(object):
    def __init__(self):
        self._a = 0
        self._b = 0
        print 'enter base'
        print 'leave base'

    def a(self):
        return self._a

    def b(self):
        return self._b

    def aa(self):
        c = self.a() + self.b()
        return c


class childA(Base):
    def __init__(self):
        self._c = 1
        print 'enter childA'
        Base.__init__(self)
        print 'leave childA'

    def c(self):
        return self._c

    def aa(self):
        d = self.a() + self.b() + self.c() + b
        return d


class childB(Base):
    def __init__(self):
        print 'enter childB'
        Base.__init__(self)
        print 'leave childB'


class childC(Base):
    def __init__(self):
        print 'enter childC'
        Base.__init__(self)
        print 'leave childC'


class childD(childB, childC, childA):
    def __init__(self):
        print 'enter childD'
        childB.__init__(self)
        childC.__init__(self)
        childA.__init__(self)
        print 'leave childD'


childD()

```

输出：
```
enter childD
enter childB
enter base
leave base
leave childB
enter childC
enter base
leave base
leave childC
enter childA
enter base
leave base
leave childA
leave childD
```
对比两者的输出，发现基类Base()调用的次数不一样。