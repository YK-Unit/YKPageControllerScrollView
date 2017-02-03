//
//  YKPageControllerScrollViewLifeCycleProtocol.h
//  YKPageControllerScrollViewDemo
//
//  Created by York on 2017/2/2.
//  Copyright © 2017年 YK-Unit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YKPageControllerScrollViewLifeCycleProtocol <NSObject>

@optional

- (void)controllerWillAppearInPageControllerScrollView;

- (void)controllerDidAppearInPageControllerScrollView;

- (void)controllerDidDisappearInPageControllerScrollView;

- (void)controllerDidBeReclaimedByPageControllerScrollView;

@end
