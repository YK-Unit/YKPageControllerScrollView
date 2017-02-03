//
//  ColorViewController.m
//  YKPageControllerScrollViewDemo
//
//  Created by York on 2017/2/2.
//  Copyright © 2017年 YK-Unit. All rights reserved.
//

#import "ColorViewController.h"

@interface ColorViewController ()

@property (nonatomic,strong) UILabel *label;

@end

@implementation ColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 320, 40)];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setColor:(UIColor *)color title:(NSString *)title
{
    self.label.text = title;
    self.view.backgroundColor = color;
}

#pragma mark - YKPageControllerScrollViewLifeCycleProtocol
- (void)controllerWillAppearInPageControllerScrollView
{

}

- (void)controllerDidAppearInPageControllerScrollView
{

}

- (void)controllerDidDisappearInPageControllerScrollView
{

}

- (void)controllerDidBeReclaimedByPageControllerScrollView
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.label.text = @"";
}

@end
