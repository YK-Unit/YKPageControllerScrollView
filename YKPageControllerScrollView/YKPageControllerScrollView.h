//
//  YKPageControllerScrollView.h
//  YKPageControllerScrollViewDemo
//
//  Created by York on 2017/2/2.
//  Copyright © 2017年 YK-Unit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKPageControllerScrollViewLifeCycleProtocol.h"

@protocol YKPageControllerScrollViewDelegate;

@interface YKPageControllerScrollView : UIView

@property (nonatomic,weak,nullable) id<YKPageControllerScrollViewDelegate> delegate;
@property (nonatomic,readonly) NSInteger currentIndex;
@property (nonatomic,readonly,nullable) UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *currentController;


@property (nonatomic,copy,nullable) void(^onControllerScrolled)(NSInteger index); ///< 监听当前滑动到第几个VC Page

- (nullable instancetype)initWithFrame:(CGRect)frame containerViewController:(nonnull UIViewController *)containerViewController;

- (void)registerClassForController:(nonnull Class)controllerClass; ///< 注册要使用的类

- (nullable UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *)dequeueReusableViewControllerWithReuseClass:(nonnull Class)reuseClass forIndex:(NSInteger)index; ///< 获取一个可再次使用的类，若为nil，需要手动生成

- (void)reloadData; ///< 重新加载所有VC Pages

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated; ///< 滑动到指定VC Page

@end

@protocol YKPageControllerScrollViewDelegate <NSObject>

@required

- (NSInteger)numberOfControllersInPageControllerScrollView:(nonnull YKPageControllerScrollView *)scrollView;

- (nonnull UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *)pageControllerScrollView:(nonnull YKPageControllerScrollView *)pageControllerScrollView controllerForItemAtIndex:(NSInteger)index;

@optional
- (void)pageControllerScrollView:(nonnull YKPageControllerScrollView *)pageControllerScrollView willDisplayController:(nonnull UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *)controller forItemAtIndex:(NSInteger)index;

- (void)pageControllerScrollView:(nonnull YKPageControllerScrollView *)pageControllerScrollView didDisplayController:(nonnull UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *)controller forItemAtIndex:(NSInteger)index;

- (void)pageControllerScrollView:(nonnull YKPageControllerScrollView *)pageControllerScrollView didEndDisplayingController:(nonnull UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *)controller forItemAtIndex:(NSInteger)index;

@end
