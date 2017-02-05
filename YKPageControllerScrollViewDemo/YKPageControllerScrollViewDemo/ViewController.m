//
//  ViewController.m
//  YKPageControllerScrollViewDemo
//
//  Created by York on 2017/2/2.
//  Copyright © 2017年 YK-Unit. All rights reserved.
//

#import "ViewController.h"
#import "ColorViewController.h"
#import "GreenColorViewController.h"
#import "OrangeColorViewController.h"
#import "YKPageControllerScrollView.h"
#import "YKScrollSegmentTitleView.h"

@interface ViewController ()
<YKPageControllerScrollViewDelegate>

@property (nonatomic,strong) YKPageControllerScrollView *pageControllerScrollView;

@property (nonatomic,strong) YKScrollSegmentTitleView *scrollSegmentTitleView;

@property (nonatomic,strong) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.titles = @[@"关注",@"推荐",@"LOL",@"炉石传说",@"搞笑",@"动画",@"网之易",@"风暴英雄",@"魔兽世界",@"地下城勇士",@"无尽之剑"];

    self.scrollSegmentTitleView = [[YKScrollSegmentTitleView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 64)];
    self.scrollSegmentTitleView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.scrollSegmentTitleView];
    [self.scrollSegmentTitleView reloadTitles:self.titles];

    self.pageControllerScrollView = [[YKPageControllerScrollView alloc] initWithFrame:CGRectMake(0, 20 + 64, self.view.frame.size.width, 320) containerViewController:self];
    self.pageControllerScrollView.delegate = self;
    [self.pageControllerScrollView registerClassForController:[ColorViewController class]];
    [self.pageControllerScrollView registerClassForController:[OrangeColorViewController class]];
    [self.pageControllerScrollView registerClassForController:[GreenColorViewController class]];
    [self.view addSubview:self.pageControllerScrollView];
    
    __weak typeof(self) weakSelf = self;
    [self.scrollSegmentTitleView setOnTitleClicked:^(NSInteger index) {
        [weakSelf.pageControllerScrollView setSelectedIndex:index animated:YES];
    }];
    
    [self.pageControllerScrollView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YKPageControllerScrollViewDelegate

- (NSInteger)numberOfControllersInPageControllerScrollView:(YKPageControllerScrollView *)scrollView
{
    return self.titles.count;
}

- (nonnull UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *)pageControllerScrollView:(nonnull YKPageControllerScrollView *)pageControllerScrollView controllerForItemAtIndex:(NSInteger)index
{
    UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *vc = nil;
    
    if (0 == index) {
        vc = [pageControllerScrollView dequeueReusableViewControllerWithReuseClass:[OrangeColorViewController class] forIndex:index];
        
        OrangeColorViewController *colorVC = (OrangeColorViewController *)vc;
        if (colorVC == nil) {
            colorVC = [[OrangeColorViewController alloc] init];
        }
        
        vc = colorVC;
    }else if(1 == index){
        vc = [pageControllerScrollView dequeueReusableViewControllerWithReuseClass:[GreenColorViewController class] forIndex:index];
        
        GreenColorViewController *colorVC = (GreenColorViewController *)vc;
        if (colorVC == nil) {
            colorVC = [[GreenColorViewController alloc] init];
        }
        
        vc = colorVC;
    }else{
        vc = [pageControllerScrollView dequeueReusableViewControllerWithReuseClass:[ColorViewController class] forIndex:index];
        
        ColorViewController *colorVC = (ColorViewController *)vc;
        if (colorVC == nil) {
            colorVC = [[ColorViewController alloc] init];
        }
        
        vc = colorVC;
    }
    
    return vc;
}

- (void)pageControllerScrollView:(YKPageControllerScrollView *)pageControllerScrollView willDisplayController:(UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *)controller forItemAtIndex:(NSInteger)index
{
    ColorViewController *colorVC = (ColorViewController *)controller;
    
    if (index >= 2) {
        CGFloat count = self.titles.count + 1.f;
        UIColor *color = [UIColor colorWithRed:index/count green:index/count blue:200.0f/255.0f alpha:1.0];
        [colorVC setColor:color title:@(index).stringValue];
    }else{
        [colorVC setColor:nil title:@(index).stringValue];
    }
}

- (void)pageControllerScrollViewDidScroll:(YKPageControllerScrollView *)pageControllerScrollView
{
    if ([pageControllerScrollView isDragging] || [pageControllerScrollView isDecelerating] ) {
        NSInteger index = (NSInteger)(pageControllerScrollView.contentOffset.x / pageControllerScrollView.frame.size.width);
        [self.scrollSegmentTitleView setSelectedIndex:index animated:YES];
    }
}
@end
