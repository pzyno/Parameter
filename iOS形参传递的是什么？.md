#### iOS形参传递的是什么？

> 你是否也有这样的困惑？当我将一个对象传给一个函数后，这个函数拥有值是原始对象，还是一个克隆体？当原始对象发生改变后，函数内形参的值是否会随之改变？



#### 先介绍 OC 的情况

我们知道打印地址的方法如下：

```objective-c
NSLog(@"地址:%p",p);
```

那么，让我们先打印下，传参后的地址变化，此处我对一个`Person`对象进行了三次引用，分别是：原始值、传参、全局变量，代码如下：

```objective-c
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"全局变量地址:%p",_zs);
    Person *p = [[Person alloc] init];
    p.name = @"张三";
    p.address = @"聚贤路";
    _zs = p;
    NSLog(@"原始地址:%p",p);
    NSLog(@"全局变量地址:%p",_zs);
    [self say:p];
    self.nameTF.text = p.name;
    self.addressTF.text = p.address;
}

-(void)say:(Person *)p
{
    NSLog(@"形参地址:%p",p);
    
}
```

结果如下：

```objective-c
2021-05-25 17:32:21.733520+0800 PerameterDemo_iOS[18143:349387] 全局变量地址:0x0
2021-05-25 17:32:21.733673+0800 PerameterDemo_iOS[18143:349387] 原始地址:0x600000e2c120
2021-05-25 17:32:21.733798+0800 PerameterDemo_iOS[18143:349387] 全局变量地址:0x600000e2c120
2021-05-25 17:32:21.733884+0800 PerameterDemo_iOS[18143:349387] 形参地址:0x600000e2c120
```

很明显：地址相同

为了保险起见，我们来看看属性的变化产生的影响，这个可能是我们真真切切关系的

```objective-c
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"全局变量地址:%p",_zs);
    Person *p = [[Person alloc] init];
    p.name = @"张三";
    p.address = @"聚贤路";
    _zs = p;
    NSLog(@"原始地址:%p",p);
    NSLog(@"全局变量地址:%p",_zs);
    [self say:p];
    self.nameTF.text = p.name;
    self.addressTF.text = p.address;
}

- (IBAction)change:(UIButton *)sender {
    _zs.name = self.nameTF.text;
    _zs.address = self.addressTF.text;
    
    
}

-(void)say:(Person *)p
{
    NSLog(@"形参地址:%p",p);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"OC---name:%@    addresss:%@\n",p.name,p.address);
    });
    dispatch_resume(timer);
    _timer = timer;
    
}
```

上述代码我们主要做了两个事情：

- 开启一个定时器，不停得读传入的参数的值
- 用一个方法改变`Person`对象里属性的值

结果如下：

```objective-c
2021-05-25 17:47:08.290704+0800 PerameterDemo_iOS[18190:358023] OC---name:张三    addresss:聚贤路
2021-05-25 17:47:09.290252+0800 PerameterDemo_iOS[18190:358023] OC---name:张三    addresss:聚贤路
2021-05-25 17:47:10.290279+0800 PerameterDemo_iOS[18190:358021] OC---name:张三    addresss:聚贤路
2021-05-25 17:47:11.291429+0800 PerameterDemo_iOS[18190:358021] OC---name:张三    addresss:聚贤路
2021-05-25 17:47:12.291253+0800 PerameterDemo_iOS[18190:358021] OC---name:张三1    addresss:聚贤路1
2021-05-25 17:47:13.291549+0800 PerameterDemo_iOS[18190:358021] OC---name:张三1    addresss:聚贤路1
2021-05-25 17:47:14.291376+0800 PerameterDemo_iOS[18190:358021] OC---name:张三1    addresss:聚贤路1
2021-05-25 17:47:15.291135+0800 PerameterDemo_iOS[18190:358026] OC---name:张三1    addresss:聚贤路1
```

即：当我们改变全局变量`_zs`里面属性的值时，`say:`函数里的形参`p`里的属性值也发生了变换。

#### Swift的情况类似

由于 Swift 打印地址比较麻烦，故只做了属性变化的测试

#### 示例代码

[]: 







