//
//  LRCircleRollingView.m
//  LRCircleRollingViewDemo
//
//  Created by LR on 16/12/5.
//  Copyright © 2016年 LR. All rights reserved.
//

#import "LRCircleRollingView.h"
#import "LRNewsCell.h"
#import "LRModel.h"

#define LRCellIdentifier @"news"
#define LRMaxSections 100

@interface LRCircleRollingView () <UICollectionViewDataSource, UICollectionViewDelegate>

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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [super init]) {
        [self configViewWithItems:(NSArray *)items];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray *)imageArray {
    
    return [self initWithImages:imageArray titles:nil];
}

- (instancetype)initWithImages:(NSArray *)imageArray titles:(NSArray *)titleArray {
    if (self = [super init]) {
        [self configDataWithImages:imageArray titles:titleArray];
    }
    return self;
}

- (void)configDataWithImages:(NSArray *)imageArray titles:(NSArray *)titleArray {
    
    NSUInteger count = MAX(imageArray.count, titleArray.count);
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < count; i++) {
        LRModel *model = [[LRModel alloc]init];
        model.icon = i < imageArray.count ? imageArray[i] :nil;
        model.title = i < titleArray.count ? titleArray[i] : nil;
        [dataArray addObject:model];
    }
    
    NSArray *items = [NSArray arrayWithArray:dataArray];
    [self configViewWithItems:items];
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [self configDataWithImages:self.imageArray titles:_titleArray];
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    [self configDataWithImages:_imageArray titles:self.titleArray];
}
- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSArray array];
    }
    return _imageArray;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    if (!self.collectionView) {
        return;
    }
    self.collectionView.backgroundColor = backgroundColor;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setPageControlPositionEnum:_pageControlPositionEnum];
    if (![NSStringFromCGRect(self.pageControlPosition) isEqualToString:@"{{0, 0}, {0, 0}}"]) {
        self.pageControl.frame = self.pageControlPosition;
    }
    self.layout.itemSize = self.bounds.size;
    self.collectionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setPageControlPositionEnum:(LRPageControlPosition)pageControlPositionEnum {
    _pageControlPositionEnum = pageControlPositionEnum;
    CGRect frame = self.frame;
    switch (_pageControlPositionEnum) {
        case LRPageControlPositionRightBottom:
        {
            self.pageControl.frame = CGRectMake(frame.size.width - 100, frame.size.height - 37, 100, 37);
        }
            break;
        case LRPageControlPositionMiddleBottom:
        {
            self.pageControl.frame = CGRectMake((frame.size.width - 100)/2, frame.size.height - 37, 100, 37);
        } 
            break;
        case LRPageControlPositionLeftBottom:
        {
            self.pageControl.frame = CGRectMake(0, frame.size.height - 37, 100, 37);
        }
            break;
        case LRPageControlPositionRightTop:
        {
            self.pageControl.frame = CGRectMake(frame.size.width - 100, 0, 100, 37);
        }
            break;
        case LRPageControlPositionMiddleTop:
        {
            self.pageControl.frame = CGRectMake((frame.size.width - 100)/2, 0, 100, 37);
        }
            break;
        case LRPageControlPositionLeftTop:
        {
            self.pageControl.frame = CGRectMake(0, 0, 100, 37);
        }
            break;
            
        default:
            break;
    }
}
- (void)setPageControlPosition:(CGRect)pageControlPosition {
    _pageControlPosition = pageControlPosition;
    self.pageControl.frame = pageControlPosition;
}
- (void)setTimeInterval:(CGFloat)timeInterval {
    _timeInterval = timeInterval;
    [self stopAutoScroll];
    [self autoScroll];
}

- (void)configViewWithItems:(NSArray *)items {
    
    self.timeInterval = _timeInterval <= 0.0f ? 2.0f : _timeInterval;
    
    self.newses = items;
    
    [self configView];
    
    if (self.newses != nil && ![self.newses isKindOfClass:[NSNull class]] && [self.newses count] > 0) {
        // 默认显示最中间的那组
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:LRMaxSections/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
        // 添加定时器
//        [self addTimer];
        [self autoScroll];
    }
    
//    if (self.newses.count <= 0) {
//        self.placeholderImageView.hidden = NO;
//    }else{
//        self.placeholderImageView.hidden = YES;
//    }
    
    self.pageControl.hidden = self.newses.count <= 1 ? YES : NO;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.pageIndicatorTintColor = [UIColor lightTextColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;
}
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.itemSize = self.bounds.size;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (void)configView {
    CGRect frame = self.frame;
    
    //    pageControl.frame = CGRectMake(frame.size.width - 100, frame.size.height - 37, 100, 37);
    [self addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.newses.count;
    self.pageControlPositionEnum = _pageControlPositionEnum;
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"LRNewsCell" bundle:nil] forCellWithReuseIdentifier:LRCellIdentifier];
    
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    [self bringSubviewToFront:self.pageControl];
    
    
//    //placeholder 占位图
//    UIImageView *placeholderImageView = [[UIImageView alloc]init];
//    placeholderImageView.frame = self.collectionView.frame;
//    placeholderImageView.image = [UIImage imageNamed:@"LRImage.bundle/LRplaceholder.png"];
//    [self addSubview:placeholderImageView];
//    self.placeholderImageView = placeholderImageView;

}

- (void)reloadData {
    if (self.collectionView) {
        [self.collectionView reloadData];
    }
}

- (void)autoScroll {
    if (!self.collectionView) return;
    
    if (self.newses.count > 1) {
        [self addTimer];
        self.collectionView.scrollEnabled = YES;
    }else{
        self.collectionView.scrollEnabled = NO;
    }
}
- (void)stopAutoScroll {
    if (!self.collectionView) return;
    
    if (self.newses.count > 1) {
        [self removeTimer];
        self.collectionView.scrollEnabled = YES;
    }else{
        self.collectionView.scrollEnabled = NO;
    }
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
/**
 *  添加定时器
 */
- (void)addTimer
{
    [self timer];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    if (!_timer) {
        return;
    }
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
    return self.newses.count > 0 ? self.newses.count : 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return LRMaxSections;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(circleRollingView:cellForItemAtIndexPath:)]) {
        return [self.dataSource circleRollingView:collectionView cellForItemAtIndexPath:indexPath];
    }else{
        LRNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LRCellIdentifier forIndexPath:indexPath];
        
        if (self.newses.count > 0) {
            cell.news = self.newses[indexPath.item];
        }else{
            cell.news = nil;
        }
        return cell;
    }
}

#pragma mark  - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleRollingView:didSelectItemAtIndexPath:)]) {
        [self.delegate circleRollingView:self didSelectItemAtIndexPath:indexPath];
    }
    if (self.selectItemBlock) {
        self.selectItemBlock(self, indexPath);
    }
}

/**
 *  当用户即将开始拖拽的时候就调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    [self removeTimer];
    [self stopAutoScroll];
}

/**
 *  当用户停止拖拽的时候就调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    NSLog(@"scrollViewDidEndDragging--松开");
//    [self addTimer];
    [self autoScroll];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.newses.count <= 0) return;
    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.newses.count;
    self.pageControl.currentPage = page;
}


@end
