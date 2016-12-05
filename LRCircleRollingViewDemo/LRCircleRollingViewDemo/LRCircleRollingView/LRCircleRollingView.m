//
//  LRCircleRollingView.m
//  LRCircleRollingViewDemo
//
//  Created by LR on 16/12/5.
//  Copyright © 2016年 LR. All rights reserved.
//

#import "LRCircleRollingView.h"
#import "LRNewsCell.h"

#define LRCellIdentifier @"news"
#define LRMaxSections 100

@interface LRCircleRollingView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *newses;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LRCircleRollingView

- (NSArray *)newses {
    if (!_newses) {
        _newses = [NSArray array];
    }
    return _newses;
}

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [super init]) {
        [self configViewWithItems:(NSArray *)items];
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.pageControl.frame = CGRectMake(frame.size.width - 100, frame.size.height - 37, 100, 37);
    self.layout.itemSize = self.bounds.size;
    self.collectionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//    [self.collectionView reloadData];
}

- (void)configViewWithItems:(NSArray *)items {
    
    self.newses = items;
    
    CGRect frame = self.frame;
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.pageIndicatorTintColor = [UIColor lightTextColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.frame = CGRectMake(frame.size.width - 100, frame.size.height - 37, 100, 37);
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    self.pageControl.numberOfPages = self.newses.count;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = self.bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout = layout;
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"LRNewsCell" bundle:nil] forCellWithReuseIdentifier:LRCellIdentifier];
    
    // 默认显示最中间的那组
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:LRMaxSections/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    [self bringSubviewToFront:self.pageControl];
    
    // 添加定时器
    [self addTimer];
}

- (void)autoScroll {
    if (self.newses.count > 0) {
        [self addTimer];
    }
}
- (void)stopAutoScroll {
    if (self.newses.count > 0) {
        [self removeTimer];
    }
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (NSIndexPath *)resetIndexPath
{
    // 当前正在展示的位置
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    // 马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:LRMaxSections/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    return currentIndexPathReset;
}

/**
 *  下一页
 */
- (void)nextPage
{
    // 1.马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [self resetIndexPath];
    
    // 2.计算出下一个需要展示的位置
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.newses.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    // 3.通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.newses.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return LRMaxSections;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LRNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LRCellIdentifier forIndexPath:indexPath];
    
    cell.news = self.newses[indexPath.item];
    
    return cell;
}

#pragma mark  - UICollectionViewDelegate
/**
 *  当用户即将开始拖拽的时候就调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

/**
 *  当用户停止拖拽的时候就调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    NSLog(@"scrollViewDidEndDragging--松开");
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.newses.count;
    self.pageControl.currentPage = page;
}


@end