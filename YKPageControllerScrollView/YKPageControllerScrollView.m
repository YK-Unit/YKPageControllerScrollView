//
//  YKPageControllerScrollView.m
//  YKPageControllerScrollViewDemo
//
//  Created by York on 2017/2/2.
//  Copyright © 2017年 YK-Unit. All rights reserved.
//

#import "YKPageControllerScrollView.h"

#define YKPageControllerScrollViewCellIdentifier @"YKPageControllerScrollViewCellIdentifier"

@interface YKPageControllerScrollView()
<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableDictionary *dict4ReusableArray; ///< 保存重用的VC数组
@property (nonatomic,strong) NSMutableDictionary *dict4ActiveController; ///< 保存使用中的VC
@property (nonatomic,strong) NSMutableArray *array4PendingControllerIndex; ///< 保存待处理的VC的索引

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,weak) UIViewController *containerViewController;

@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) BOOL isScrollWithAnim;

@end

@implementation YKPageControllerScrollView

- (instancetype)initWithFrame:(CGRect)frame containerViewController:(UIViewController *)containerViewController
{
    self = [self initWithFrame:frame];
    if (self) {
        self.containerViewController = containerViewController;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = self.frame.size;
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    collectionView.scrollsToTop = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.bounces = YES;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:YKPageControllerScrollViewCellIdentifier];
    
    self.collectionView = collectionView;
    [self addSubview:self.collectionView];
}

- (void)initData
{
    self.dict4ReusableArray = [[NSMutableDictionary alloc] initWithCapacity:32];
    self.dict4ActiveController = [[NSMutableDictionary alloc] initWithCapacity:32];
    self.array4PendingControllerIndex = [[NSMutableArray alloc] initWithCapacity:32];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger num = 0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfControllersInPageControllerScrollView:)]) {
        num = [self.delegate numberOfControllersInPageControllerScrollView:self];
    }
    
    return num;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//生成cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YKPageControllerScrollViewCellIdentifier forIndexPath:indexPath];
    
    NSInteger index = indexPath.row;
    self.currentIndex = index;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageControllerScrollView:controllerForItemAtIndex:)]) {
        UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *vc = [self.delegate pageControllerScrollView:self controllerForItemAtIndex:index];
        
        vc.view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:vc.view];
        [self.containerViewController addChildViewController:vc];
        [self.dict4ActiveController setObject:vc forKey:@(index)];
        [self.array4PendingControllerIndex removeObject:@(index)];
    }
    
    //NSLog(@"cellForItemAtIndex:%d",index);
    
    return cell;
}

//配置cell
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *vc = [self.dict4ActiveController objectForKey:@(index)];
    
    if (vc) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pageControllerScrollView:willDisplayController:forItemAtIndex:)]) {
            [self.delegate pageControllerScrollView:self willDisplayController:vc forItemAtIndex:index];
        }
        
        if ([vc respondsToSelector:@selector(controllerWillAppearInPageControllerScrollView)]) {
            [vc controllerWillAppearInPageControllerScrollView];
        }
    }
    
    //NSLog(@"willDisplayCell:%d",index);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    //NSLog(@"didEndDisplayingCell:%d",index);
    
    UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *vc = [self.dict4ActiveController objectForKey:@(index)];
    if (vc) {
        if (![self.array4PendingControllerIndex containsObject:@(index)]) {
            [self.array4PendingControllerIndex addObject:@(index)];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pageControllerScrollView:didEndDisplayingController:forItemAtIndex:)]) {
            [self.delegate pageControllerScrollView:self didEndDisplayingController:vc forItemAtIndex:index];
        }
        
        if ([vc respondsToSelector:@selector(controllerDidDisappearInPageControllerScrollView)]) {
            [vc controllerDidDisappearInPageControllerScrollView];
        }
    }
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isScrollWithAnim && !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating) {
        self.currentIndex = (NSInteger)(scrollView.contentOffset.x / self.frame.size.width);
        
        UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *currentVC = [self currentController];
        //如果当前VC还没生成，则推迟发送通知
        if (currentVC) {
            [self sendDidDisplayNotificationToController:currentVC];
            
            //停止滚动后，回收可回收的VC
            [self recycleViewController];
        }else{
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidEndScrollingAnimation:) object:scrollView];
            [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:1.0];
        }
    }
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageControllerScrollViewDidScroll:)]) {
        [self.delegate pageControllerScrollViewDidScroll:self];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.currentIndex = (NSInteger)(scrollView.contentOffset.x / self.frame.size.width);
    
    UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *currentVC = [self currentController];
    [self sendDidDisplayNotificationToController:currentVC];
    
    //停止滚动后，回收可回收的VC
    [self recycleViewController];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //如果scrollView不再减速慢行，就直接更新currentIndex和做回收操作
    if (!decelerate) {
        self.currentIndex = (NSInteger)(scrollView.contentOffset.x / self.frame.size.width);
        
        UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *currentVC = [self currentController];
        [self sendDidDisplayNotificationToController:currentVC];
        
        //停止滚动后，回收可回收的VC
        [self recycleViewController];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentIndex = (NSInteger)(scrollView.contentOffset.x / self.frame.size.width);
    
    UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *currentVC = [self currentController];
    [self sendDidDisplayNotificationToController:currentVC];
    
    //停止滚动后，回收可回收的VC
    [self recycleViewController];
}

#pragma mark - Public Methods
- (void)registerClassForController:(nonnull Class)controllerClass
{
    if (controllerClass) {
        NSString *identifier = [controllerClass description];
        
        NSMutableArray *reusableArray = [[NSMutableArray alloc] initWithCapacity:8];
        [self.dict4ReusableArray setObject:reusableArray forKey:identifier];
    }
}

- (nullable UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *)dequeueReusableControllerWithReuseClass:(nonnull Class)reuseClass forIndex:(NSInteger)index
{
    UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *reusableVC = nil;
    
    NSString *identifier = [reuseClass description];
    NSMutableArray *reusableArray = [self.dict4ReusableArray objectForKey:identifier];
    
    //若reusableArray为nil，说明没有注册reuseClass（执行[YKPageControllerScrollView registerClassForController:reuseClass]）
    if (reuseClass && reusableArray) {
        UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *vc = [self.dict4ActiveController objectForKey:@(index)];
        if (vc) {
            reusableVC = vc;
        }else{
            vc = [reusableArray firstObject];
            if (vc) {
                reusableVC = vc;
                [reusableArray removeObject:vc];
            }
        }
    }
    
    return reusableVC;
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    NSInteger numberOfViewControllers = [self.collectionView numberOfItemsInSection:0];
    if (index >= numberOfViewControllers) {
        return;
    }
    
    NSInteger page = labs(index - self.currentIndex);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    CGPoint contentOffset = CGPointMake(self.collectionView.frame.size.width * index, 0);
    
    // 需要滚动两页以上的时候, 跳过中间页的动画
    if (page >= 2) {
        self.isScrollWithAnim = NO;
        [self.collectionView setContentOffset:contentOffset animated:NO];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }else{
        self.isScrollWithAnim = animated;
        [self.collectionView setContentOffset:contentOffset animated:animated];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *)currentController
{
    UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *vc = [self.dict4ActiveController objectForKey:@(self.currentIndex)];
    return vc;
}

- (CGPoint)contentOffset
{
    return self.collectionView.contentOffset;
}

- (CGSize)contentSize
{
    return self.collectionView.contentSize;
}

- (BOOL)isTracking
{
    return [self.collectionView isTracking];
}

- (BOOL)isDragging
{
    return [self.collectionView isDragging];
}

- (BOOL)isDecelerating
{
    return [self.collectionView isDecelerating];
}

#pragma mark - Private Methods

- (void)recycleViewController
{
    NSArray *tempArray = [NSArray arrayWithArray:self.array4PendingControllerIndex];
    for (NSNumber *indexNum in tempArray) {
        NSInteger index = [indexNum integerValue];
        
        if (labs(self.currentIndex - index) >= 3 ) {
            UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *vc = [self.dict4ActiveController objectForKey:@(index)];
            
            if (vc) {
                [vc.view removeFromSuperview];
                [vc removeFromParentViewController];
                
                if ([vc respondsToSelector:@selector(controllerDidBeReclaimedByPageControllerScrollView)]) {
                    [vc controllerDidBeReclaimedByPageControllerScrollView];
                }
                
                [self.dict4ActiveController removeObjectForKey:@(index)];
                [self.array4PendingControllerIndex removeObject:@(index)];
                
                Class reuseClass = [vc class];
                NSString *identifier = [reuseClass description];
                NSMutableArray *reusableArray = [self.dict4ReusableArray objectForKey:identifier];
                [reusableArray addObject:vc];
            }
        }
    }
}

- (void)sendDidDisplayNotificationToController:(UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *)viewController
{
    UIViewController<YKPageControllerScrollViewLifeCycleProtocol> *currentVC = viewController;
    if (currentVC && self.delegate && [self.delegate respondsToSelector:@selector(pageControllerScrollView:didDisplayController:forItemAtIndex:)]) {
        [self.delegate pageControllerScrollView:self didDisplayController:currentVC forItemAtIndex:self.currentIndex];
    }
    
    if ([currentVC respondsToSelector:@selector(controllerDidAppearInPageControllerScrollView)]) {
        [currentVC controllerDidAppearInPageControllerScrollView];
    }
}

@end
