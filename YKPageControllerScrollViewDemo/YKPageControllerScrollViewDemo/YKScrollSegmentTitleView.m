//
//  YKScrollSegmentTitleView.m
//  YKPageControllerScrollViewDemo
//
//  Created by York on 2017/2/2.
//  Copyright © 2017年 YK-Unit. All rights reserved.
//

#import "YKScrollSegmentTitleView.h"

@interface YKScrollSegmentTitleView()
<UIScrollViewDelegate>

@property (nonatomic,strong) YKScrollSegmentTitleStyle *style;
@property (nonatomic,strong) NSMutableArray *titleViews; ///< 缓存titleView
@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *scrollLine;
@end

@implementation YKScrollSegmentTitleView

- (instancetype)initWithFrame:(CGRect)frame style:(YKScrollSegmentTitleStyle *)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        [self initData];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    YKScrollSegmentTitleStyle *style = [[YKScrollSegmentTitleStyle alloc] init];
    
    self = [self initWithFrame:frame style:style];
    
    return self;
}

- (void)initData
{
    self.titleViews = [[NSMutableArray alloc] initWithCapacity:32];
}

- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    
    self.scrollLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.scrollLine.backgroundColor = self.style.scrollLineColor;
}

- (void)reloadTitles:(NSArray *)titles
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.titleViews removeAllObjects];
    
    CGFloat lastTitleViewX = self.style.titleMargin;
    for (NSInteger index = 0; index < titles.count; index++) {
        NSString *title = [titles objectAtIndex:index];
        
        UIButton *titleView = [UIButton buttonWithType:UIButtonTypeCustom];
        titleView.titleLabel.font = self.style.titleFont;
        [titleView setTitleColor:self.style.normalTitleColor forState:UIControlStateNormal];
        [titleView setTitleColor:self.style.selectedTitleColor forState:UIControlStateSelected];
        [titleView setTitle:title forState:UIControlStateNormal];
        [titleView sizeToFit];
        
        CGFloat titleViewY = (self.scrollView.frame.size.height - titleView.frame.size.height) / 2;
        CGPoint titleViewOrigin = CGPointMake(lastTitleViewX, titleViewY);
        CGRect newFrame = titleView.frame;
        newFrame.origin = titleViewOrigin;
        titleView.frame = newFrame;
        [self.scrollView addSubview:titleView];
        [self.titleViews addObject:titleView];
        
        titleView.tag = index;
        [titleView addTarget:self action:@selector(titleViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        lastTitleViewX = titleView.frame.origin.x + titleView.frame.size.width + self.style.titleMargin;
        
    }
    
    self.scrollView.contentSize = CGSizeMake(lastTitleViewX, 0);
    
    if (lastTitleViewX < self.frame.size.width) {
        CGRect newScrollViewFrame = self.scrollView.frame;
        newScrollViewFrame.size.width = lastTitleViewX;
        newScrollViewFrame.origin.x = (self.frame.size.width - lastTitleViewX)/2;
        self.scrollView.frame = newScrollViewFrame;
    }else{
        self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    
    self.currentIndex = 0;
    UIButton *firstTitleView = (UIButton *)self.titleViews[self.currentIndex];
    firstTitleView.selected = YES;
    
    CGFloat scrollLineX = firstTitleView.frame.origin.x;
    CGFloat scrollLineW = firstTitleView.frame.size.width;
    CGFloat scrollLineH = self.style.scrollLineHeight;
    CGFloat scrollLineY = self.scrollView.frame.size.height - scrollLineH;
    self.scrollLine.frame = CGRectMake(scrollLineX, scrollLineY, scrollLineW, scrollLineH);
    [self.scrollView addSubview:self.scrollLine];
    
    
}

- (void)titleViewClicked:(id)sender
{
    UIButton *titleView = (UIButton *)sender;
    NSInteger newIndex = titleView.tag;
    
    if (newIndex != self.currentIndex) {
        if (self.onTitleClicked) {
            self.onTitleClicked(newIndex);
        }
    }
    [self setSelectedIndex:newIndex animated:YES];
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index >= self.titleViews.count) {
        return;
    }
    
    if (index != self.currentIndex) {
        
        UIButton *oldTitleView = self.titleViews[self.currentIndex];
        oldTitleView.selected = NO;
        
        UIButton *newTitleView = self.titleViews[index];
        newTitleView.selected = YES;
        self.currentIndex = index;
        
        CGFloat scrollLineX = newTitleView.frame.origin.x;
        CGFloat scrollLineW = newTitleView.frame.size.width;
        CGFloat scrollLineH = self.style.scrollLineHeight;
        CGFloat scrollLineY = self.scrollView.frame.size.height - scrollLineH;
        CGRect scrollLineFrame = CGRectMake(scrollLineX, scrollLineY, scrollLineW, scrollLineH);
        
        CGFloat animatedTime = animated ? 0.30 : 0.0;
        
        [UIView animateWithDuration:animatedTime animations:^{
            self.scrollLine.frame = scrollLineFrame;
        } completion:^(BOOL finished) {
            [self adjustTitleOffSetToCurrentIndex:self.currentIndex];
        }];
    }
}

- (void)adjustTitleOffSetToCurrentIndex:(NSInteger)currentIndex {
    // 需要滚动
    if (self.scrollView.contentSize.width != self.scrollView.bounds.size.width + self.style.titleMargin) {
        UIButton *currentTitleView = (UIButton *)self.titleViews[currentIndex];
        
        CGFloat currentScrollViewW = self.scrollView.frame.size.width;
        CGFloat offSetx = currentTitleView.center.x - currentScrollViewW * 0.5;
        if (offSetx < 0) {
            offSetx = 0;
        }
        
        CGFloat maxOffSetX = self.scrollView.contentSize.width - currentScrollViewW;
        
        if (maxOffSetX < 0) {
            maxOffSetX = 0;
        }
        
        if (offSetx > maxOffSetX) {
            offSetx = maxOffSetX;
        }
        
        [self.scrollView setContentOffset:CGPointMake(offSetx, 0.0) animated:YES];
    }
    
}

- (CGFloat)getTitleWidth:(NSString *)title
{
    CGRect bounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.style.titleFont} context:nil];
    return bounds.size.width;
}

@end

@implementation YKScrollSegmentTitleStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleFont = [UIFont systemFontOfSize:17];
        self.normalTitleColor = [UIColor lightGrayColor];
        self.selectedTitleColor = [UIColor blackColor];
        self.titleMargin = 15.0;
        self.scrollLineColor = [UIColor blackColor];
        self.scrollLineHeight = 3.0;
    }
    return self;
}

@end
