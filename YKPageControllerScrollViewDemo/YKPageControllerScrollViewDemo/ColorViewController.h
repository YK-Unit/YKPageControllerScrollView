//
//  ColorViewController.h
//  YKPageControllerScrollViewDemo
//
//  Created by York on 2017/2/2.
//  Copyright © 2017年 YK-Unit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKPageControllerScrollViewLifeCycleProtocol.h"

@interface ColorViewController : UIViewController
<YKPageControllerScrollViewLifeCycleProtocol>

- (void)setColor:(UIColor *)color title:(NSString *)title;

@end
