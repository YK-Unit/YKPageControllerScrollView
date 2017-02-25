# YKPageControllerScrollView
YKPageControllerScrollView是一个UIViewController容器类滚动视图，支持UIViewControlle重用机制。

---

# Insatll
## CocoPods
```ruby
pod 'YKPageControllerScrollView'
```

---

# Usage

``` objc
// viewController.m

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageControllerScrollView = [[YKPageControllerScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 320) containerViewController:self];
    self.pageControllerScrollView.delegate = self;
    [self.pageControllerScrollView registerClassForController:[ColorViewController class]];
    [self.view addSubview:self.pageControllerScrollView];
        
    [self.pageControllerScrollView reloadData];
}   
    
#pragma mark - YKPageControllerScrollViewDelegate
- (NSInteger)numberOfControllersInPageControllerScrollView:(YKPageControllerScrollView *)scrollView
{
    return 10;
}

- (nonnull UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *)pageControllerScrollView:(nonnull YKPageControllerScrollView *)pageControllerScrollView controllerForItemAtIndex:(NSInteger)index
{
    UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *vc = [pageControllerScrollView dequeueReusableViewControllerWithReuseClass:[ColorViewController class] forIndex:index];
    
    if (vc == nil) {
        vc = [[ColorViewController alloc] init];
    }
    
    return vc;
}

```

---

# 设计思路

关于 `YKPageControllerScrollView` 的设计思路，可以看我写的blog[《YKPageControllerScrollView设计总结》](http://www.jianshu.com/p/613c026c7744)