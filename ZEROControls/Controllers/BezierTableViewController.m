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
    [self setNavControllerLeftImage:[UIImage imageNamed:@"nav_back_white"]];
}

- (void)createTableView
{
    ZEROBezierTableView *tableView = [[ZEROBezierTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.delegate   = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
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
