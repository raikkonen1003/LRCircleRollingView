//
//  LRCircleRollingView.h
//  LRCircleRollingViewDemo
//
//  Created by LR on 16/12/5.
//  Copyright © 2016年 LR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRCircleRollingView : UIView

/**
 初始化方法

 @param items 传入存入数据模型的数组
 @return 返回初始化的对象
 */
- (instancetype)initWithItems:(NSArray *)items;

- (void)autoScroll;
- (void)stopAutoScroll;
@end
