//
//  LRCircleRollingView.h
//  LRCircleRollingViewDemo
//
//  Created by LR on 16/12/5.
//  Copyright © 2016年 LR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LRPageControlPosition){
    /**
     *  右下
     */
    LRPageControlPositionRightBottom = 0,
    /**
     *  中下
     */
    LRPageControlPositionMiddleBottom = 1,
    /**
     *  左下
     */
    LRPageControlPositionLeftBottom = 2,
    /**
     *  右上
     */
    LRPageControlPositionRightTop = 3,
    /**
     *  中上
     */
    LRPageControlPositionMiddleTop = 4,
    /**
     *  左上
     */
    LRPageControlPositionLeftTop = 5
    
};
@class LRCircleRollingView;

typedef void (^SelectItemBlock)(LRCircleRollingView *circleRollingView, NSIndexPath *indexPath);

@protocol LRCircleRollingViewDataSource <NSObject>
//定制cell样式
- (__kindof UICollectionViewCell *)circleRollingView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol LRCircleRollingViewDelegate <NSObject>

- (void)circleRollingView:(LRCircleRollingView *)circleRollingView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface LRCircleRollingView : UIView
{
    NSArray *_imageArray;
    NSArray *_titleArray;
}
/**
 先init方法初始化，再单独设置数据源的情况
 */
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,weak) id<LRCircleRollingViewDataSource> dataSource;
@property (nonatomic,weak) id<LRCircleRollingViewDelegate> delegate;
@property (nonatomic,copy) SelectItemBlock selectItemBlock;


/**
 两种设置pagecontrol的方式优先级 pageControlPositionEnum < pageControlPosition
 */
@property (nonatomic,assign) LRPageControlPosition pageControlPositionEnum;
@property (nonatomic,assign) CGRect pageControlPosition;

@property (nonatomic,assign) CGFloat timeInterval;//默认 2.0


@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIImageView *placeholderImageView;

/**
 初始化方法

 @param items 传入存入数据模型的数组
 @return 返回初始化的对象
 */
- (instancetype)initWithItems:(NSArray *)items;

/**
 初始化方法

 @param imageArray 存有图片链接字符串的数组
 @return 初始化的对象
 */
- (instancetype)initWithImages:(NSArray *)imageArray;

/**
 初始化方法

 @param imageArray 存有图片链接字符串的数组
 @param titleArray 存有标题字符串的数组
 @return 初始化的对象
 */
- (instancetype)initWithImages:(NSArray *)imageArray titles:(NSArray *)titleArray;

- (void)reloadData;

- (void)autoScroll;
- (void)stopAutoScroll;
@end
