//
//  GreenColorViewController.m
//  YKPageControllerScrollViewDemo
//
//  Created by York on 2017/2/2.
//  Copyright © 2017年 YK-Unit. All rights reserved.
//

#import "GreenColorViewController.h"

@interface GreenColorViewController ()

@end

@implementation GreenColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setColor:(UIColor *)color title:(NSString *)title
{
    [super setColor:[UIColor greenColor] title:title];
}

@end
