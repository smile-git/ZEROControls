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
#import "DateFormatter.h"

static NSString *offsetImageCellID = @"OffsetImageCellID";
static NSString *offsetCellHeaderViewID = @"OffsetCellHeaderView";

@interface OffsetCellViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) OffsetCellModel *rootModel;
@property (nonatomic, strong) NSMutableArray <DailyListModel *> *dailyList;

@end

@implementation OffsetCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];
    
    [self loadWanDouJiaData];
}

- (void)loadWanDouJiaData {
    
    NSArray *datas = @[@{@"dateString" : @"2020-06-18",
                         @"list"       : @[@{@"title"          : @"我们的征途是星辰大海 [1]",
                                             @"coverForDetail" : @"https://hbimg.huabanimg.com/95c1a74073e3fd69c9e7af637632fde7027b4d6a86124-g1qYW4_fw658",}]},
                       @{@"dateString" : @"2020-06-19",
                         @"list"       : @[@{@"title"          : @"我们的征途是星辰大海 [2]",
                                             @"coverForDetail" : @"https://hbimg.huabanimg.com/41e430a58e083b5df8b29828194d4c8cf6b8080e17e35-gRW2z5_fw658",}]},
                       @{@"dateString" : @"2020-06-20",
                         @"list"       : @[@{@"title"          : @"我们的征途是星辰大海 [3]",
                                             @"coverForDetail" : @"https://hbimg.huabanimg.com/463cda475956270d6d605ebacd865a80169a57967579f-0pe50Y_fw658",}]},
                       @{@"dateString" : @"2020-06-21",
                         @"list"       : @[@{@"title"          : @"我们的征途是星辰大海 [4]",
                                             @"coverForDetail" : @"https://hbimg.huabanimg.com/fae81cd6c474e36586a2b9327eecaf9bca46fa068c812-sdLSnP_fw658",}]},
                       @{@"dateString" : @"2020-06-22",
                         @"list"       : @[@{@"title"          : @"我们的征途是星辰大海 [5]",
                                             @"coverForDetail" : @"https://hbimg.huabanimg.com/648bc2e1a6350a1d48b331168000697696cdf4b136928-dgFED1_fw658",}]},
                       @{@"dateString" : @"2020-06-23",
                         @"list"       : @[@{@"title"          : @"我们的征途是星辰大海 [6]",
                                             @"coverForDetail" : @"https://hbimg.huabanimg.com/7de62a3fa6b4c98a9128ff73071e596cf7de898226d30-uDl8i5_fw658",}]},
                       @{@"dateString" : @"2020-06-24",
                         @"list"       : @[@{@"title"          : @"我们的征途是星辰大海 [7]",
                                             @"coverForDetail" : @"https://hbimg.huabanimg.com/85359db24a13794021bc6c3f609ce640f8a248f7b868c-PhP0iD_fw658",}]},
                       @{@"dateString" : @"2020-06-25",
                         @"list"       : @[@{@"title"          : @"我们的征途是星辰大海 [8]",
                                             @"coverForDetail" : @"https://hbimg.huabanimg.com/dae0e0a17d430af8f129113d12488f73f64043481ced1-FL88bJ_fw658",}]}];
    
    self.dailyList = [NSMutableArray array];
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DailyListModel *model = [[DailyListModel alloc] initWithDictionary:obj];
        [self.dailyList addObject:model];
    }];
    [self.tableView reloadData];
    [UIView animateWithDuration:0.5f animations:^{
        
        self.tableView.alpha = 1.f;
    }];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, WIDTH, HEIGHT - NavHeight) style:UITableViewStylePlain];
    
    self.tableView.delegate            = self;
    self.tableView.dataSource          = self;
    self.tableView.rowHeight           = 250.f;
    self.tableView.sectionHeaderHeight = 25.f;
    self.tableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    self.tableView.alpha               = 0.f;
    
    [self.tableView registerClass:[OffsetImageCell class] forCellReuseIdentifier:offsetImageCellID];
    [self.tableView registerClass:[OffsetCellHeaderView class] forHeaderFooterViewReuseIdentifier:offsetCellHeaderViewID];
    
    [self.view addSubview:self.tableView];
    
}


#pragma mark - ---- Delegate Method ----
#pragma mark TabeViewDelegate & TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dailyList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    DailyListModel *dailyModel = self.dailyList[section];
    return dailyModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OffsetImageCell *cell = [tableView dequeueReusableCellWithIdentifier:offsetImageCellID];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    DailyListModel *dailyModel = self.dailyList[section];
    
    OffsetCellHeaderView *titleView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:offsetCellHeaderViewID];
    
    titleView.model = dailyModel;
    [titleView loadContent];
    
    return titleView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(OffsetImageCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell cellOffset];
    
    DailyListModel *dailyModel = self.dailyList[indexPath.section];
    VideoListModel *model      = dailyModel.list[indexPath.row];
    
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
