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
#import "LRModel.h"
#import "LRNewsCell.h"

@interface ViewController ()<LRCircleRollingViewDelegate,LRCircleRollingViewDataSource>
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
        self.newses = [LRModel objectArrayWithFilename:@"newses.plist"];
//        self.pageContol.numberOfPages = self.newses.count;
    }
    return _newses;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //一 直接传入显示的模型
//    LRCircleRollingView *rollView = [[LRCircleRollingView alloc]initWithItems:self.newses];
    
    //二传入图片链接数组（网络图片可以用sdwebimage加载） 标题数组
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.newses.count; i++) {
        LRModel *model = self.newses[i];
        [imageArray addObject:model.icon];
        [titleArray addObject:model.title];
    }
    LRCircleRollingView *rollView = [[LRCircleRollingView alloc]initWithImages:imageArray titles:titleArray];
    rollView.delegate = self;

    rollView.frame = CGRectMake(10, 56, 300, 130);
//    rollView.pageControlPosition = CGRectMake(0, rollView.bounds.size.height - 37, 100, 37);
    rollView.pageControlPositionEnum = LRPageControlPositionMiddleBottom;
    rollView.timeInterval = 5.0;
    [self.view addSubview:rollView];
    self.rollView = rollView;
    
    //MARK: 回调二 block
//    self.rollView.selectItemBlock = ^(LRCircleRollingView *circleRollingView, NSIndexPath *indexPath){
//        NSLog(@"点击了第 %ld 组的第 %ld 个",indexPath.section,indexPath.row);
//    };
    
    //cell可以自定制
//    rollView.dataSource = self;//遵守datasource协议进行定制
//    [rollView.collectionView registerNib:[UINib nibWithNibName:@"LRNewsCell" bundle:nil] forCellWithReuseIdentifier:@"news"];
}

//#pragma mark- LRCircleRollingViewDataSource
//- (__kindof UICollectionViewCell *)circleRollingView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    LRNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"news" forIndexPath:indexPath];
//    
//    cell.news = self.newses[indexPath.item];
//    
//    return cell;
//}

//MARK: 回调一 代理
#pragma mark- LRCircleRollingViewDelegate
- (void)circleRollingView:(LRCircleRollingView *)circleRollingView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第 %ld 组的第 %ld 个",indexPath.section,indexPath.row);
//    [self.rollView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
