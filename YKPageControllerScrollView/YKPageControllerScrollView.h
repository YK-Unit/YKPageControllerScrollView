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
@property(nonatomic,readonly) CGPoint contentOffset;
@property(nonatomic,readonly) CGSize contentSize;
@property(nonatomic,readonly,getter=isTracking) BOOL tracking; ///<returns YES if user has touched. may not yet have started dragging
@property(nonatomic,readonly,getter=isDragging) BOOL dragging; ///< returns YES if user has started scrolling. this may require some time and or distance to move to initiate dragging
@property(nonatomic,readonly,getter=isDecelerating) BOOL decelerating;   ///< returns YES if user isn't dragging (touch up) but scroll view is still moving
@property (nonatomic,readonly,nullable) UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *currentController;

- (nullable instancetype)initWithFrame:(CGRect)frame containerViewController:(nonnull UIViewController *)containerViewController;

- (void)registerClassForController:(nonnull Class)controllerClass; ///< 注册要使用的类

- (nullable UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *)dequeueReusableControllerWithReuseClass:(nonnull Class)reuseClass forIndex:(NSInteger)index; ///< 获取一个可再次使用的类，若为nil，需要手动生成

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

- (void)pageControllerScrollViewDidScroll:(nonnull YKPageControllerScrollView *)pageControllerScrollView;


@end
