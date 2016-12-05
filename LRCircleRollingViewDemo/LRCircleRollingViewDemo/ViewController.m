//
//  ViewController.m
//  LRCircleRollingViewDemo
//
//  Created by LR on 16/12/5.
//  Copyright © 2016年 LR. All rights reserved.
//

#import "ViewController.h"
#import "LRCircleRollingView.h"
#import "MJExtension.h"
#import "LRNews.h"

@interface ViewController ()
@property (nonatomic,strong) NSArray *newses;
@property (nonatomic,strong) LRCircleRollingView *rollView;
@end

@implementation ViewController
- (IBAction)autoScrollAction:(id)sender {
    [self.rollView autoScroll];
}
- (IBAction)stopAction:(id)sender {
    [self.rollView stopAutoScroll];
}

- (NSArray *)newses
{
    if (_newses == nil) {
        self.newses = [LRNews objectArrayWithFilename:@"newses.plist"];
//        self.pageContol.numberOfPages = self.newses.count;
    }
    return _newses;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LRCircleRollingView *rollView = [[LRCircleRollingView alloc]initWithItems:self.newses];
    rollView.frame = CGRectMake(10, 56, 300, 130);
    [self.view addSubview:rollView];
    self.rollView = rollView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
