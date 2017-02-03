//
//  YKScrollSegmentTitleView.h
//  YKPageControllerScrollViewDemo
//
//  Created by York on 2017/2/2.
//  Copyright © 2017年 YK-Unit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YKScrollSegmentTitleStyle;

@interface YKScrollSegmentTitleView : UIView

@property (nonatomic,copy) void(^onTitleClicked)(NSInteger index); ///< 监听第几个标题被点击

- (instancetype)initWithFrame:(CGRect)frame style:(YKScrollSegmentTitleStyle *)style;

- (void)reloadTitles:(NSArray *)titles;

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;

@end

@interface YKScrollSegmentTitleStyle : NSObject

@property (nonatomic,strong) UIFont *titleFont; ///< 标题的字体，默认为17
@property (nonatomic,strong) UIColor *normalTitleColor; ///< 标题一般状态的颜色，默认为浅灰色
@property (nonatomic,strong) UIColor *selectedTitleColor; ///< 标题选中状态的颜色，默认为黑色
@property (nonatomic,assign) CGFloat titleMargin; ///< 标题之间的间隙 默认为15.0
@property (nonatomic,strong) UIColor *scrollLineColor; ///< 滚动条的颜色，默认为黑色
@property (nonatomic,assign) CGFloat scrollLineHeight; ///< 滚动条高度，默认为3.0

@end
