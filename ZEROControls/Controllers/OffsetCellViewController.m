//
//  OffsetCellViewController.m
//  ZEROControls
//
//  Created by ZWX on 2017/12/7.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "OffsetCellViewController.h"
#import "OffsetCellModel.h"
#import "DailyListModel.h"
#import "OffsetCellHeaderView.h"
#import "OffsetImageCell.h"
#import "ApiTool.h"
#import "ZEROAlertView.h"

static NSString *offsetImageCellID = @"OffsetImageCellID";
static NSString *offsetCellHeaderViewID = @"OffsetCellHeaderView";

@interface OffsetCellViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) OffsetCellModel *rootModel;

@end

@implementation OffsetCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];
    
    [self loadWanDouJiaData];
}

- (void)loadWanDouJiaData {
    
    [[ApiTool shareApiTool] get:@"http://baobab.wandoujia.com/api/v1/feed" params:@{@"num" : @"5", @"vc" : @"67"} success:^(NSDictionary * _Nonnull jsonDic) {
        
        self.rootModel = [[OffsetCellModel alloc] initWithDictionary:jsonDic];
        [self.tableView reloadData];
        [UIView animateWithDuration:0.5f animations:^{
            
            self.tableView.alpha = 1.f;
        }];
    } failure:^(NSError * _Nonnull error) {
        
        [[[ZEROAlertView alloc] initWithTitle:@"错误提示"
                                      message:@"网络异常，数据加载失败，请稍后重试"
                                  clickHandle:nil
                            cancelButtonTitle:nil
                            otherButtonTitles:@"确定", nil] show];
    }];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    self.tableView.delegate            = self;
    self.tableView.dataSource          = self;
    self.tableView.rowHeight           = 250.f;
    self.tableView.sectionHeaderHeight = 25.f;
    self.tableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    self.tableView.alpha               = 0.f;
    
    [self.tableView registerClass:[OffsetImageCell class] forCellReuseIdentifier:offsetImageCellID];
    [self.tableView registerClass:[OffsetCellHeaderView class] forHeaderFooterViewReuseIdentifier:offsetCellHeaderViewID];
    
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)){
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);//导航栏如果使用系统原生半透明的，top设置为64
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
}


#pragma mark - ---- Delegate Method ----
#pragma mark TabeViewDelegate & TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.rootModel.dailyList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    DailyListModel *dailyModel = self.rootModel.dailyList[section];
    return dailyModel.videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OffsetImageCell *cell = [tableView dequeueReusableCellWithIdentifier:offsetImageCellID];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    DailyListModel *dailyModel = self.rootModel.dailyList[section];
    
    OffsetCellHeaderView *titleView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:offsetCellHeaderViewID];
    
    titleView.model = dailyModel;
    [titleView loadContent];
    
    return titleView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(OffsetImageCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell cellOffset];
    
    DailyListModel *dailyModel = self.rootModel.dailyList[indexPath.section];
    VideoListModel *model      = dailyModel.videoList[indexPath.row];
    
    cell.data      = model;
    cell.indexPath = indexPath;
    
    [cell loadContent];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(OffsetImageCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell cancelAnimation];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSArray <OffsetImageCell *>*array = self.tableView.visibleCells;
    
    [array enumerateObjectsUsingBlock:^(OffsetImageCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj cellOffset];
    }];
}
@end
