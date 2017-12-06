//
//  BezierTableViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "BezierTableViewController.h"
#import "ZEROBezierTableView.h"
#import "ZEROBezierCell.h"

static NSString *cellId = @"cellId";

@interface BezierTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation BezierTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
}

- (void)createTableView
{
    ZEROBezierTableView *tableView = [[ZEROBezierTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.delegate   = self;
    tableView.dataSource = self;
    
    if (@available(iOS 11.0, *)){
        
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);//导航栏如果使用系统原生半透明的，top设置为64
        tableView.scrollIndicatorInsets = tableView.contentInset;
    }
    
    [self.view addSubview:tableView];
    
}

#pragma mark - tableview delegate & datasource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZEROBezierCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellId];
        nibsRegistered = YES;
    }
    ZEROBezierCell *cell = (ZEROBezierCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%zi", indexPath.row);
}

@end
