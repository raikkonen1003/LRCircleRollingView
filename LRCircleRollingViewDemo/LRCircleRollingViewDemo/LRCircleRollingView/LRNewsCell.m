//
//  LRNewsCell.m
//  LRCircleRollingViewDemo
//
//  Created by LR on 16/12/5.
//  Copyright © 2016年 LR. All rights reserved.
//

#import "LRNewsCell.h"
#import "LRNews.h"

@interface LRNewsCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

@implementation LRNewsCell
- (void)setNews:(LRNews *)news
{
    _news = news;
    
    self.iconView.image = [UIImage imageNamed:news.icon];
    self.titleLabel.text = NSString(@"  %@", news.title);
}

@end
