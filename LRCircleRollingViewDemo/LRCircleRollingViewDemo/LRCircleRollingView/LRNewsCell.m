//
//  LRNewsCell.m
//  LRCircleRollingViewDemo
//
//  Created by LR on 16/12/5.
//  Copyright © 2016年 LR. All rights reserved.
//

#import "LRNewsCell.h"
#import "LRModel.h"

@interface LRNewsCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

@implementation LRNewsCell
- (void)setNews:(LRModel *)news
{
    _news = news;
    
    self.iconView.image = [UIImage imageNamed:news.icon];
    if (!news.title) {
        self.titleLabel.hidden = YES;
        return;
    }
    self.titleLabel.text = NSString(@"  %@", news.title);
}

@end
