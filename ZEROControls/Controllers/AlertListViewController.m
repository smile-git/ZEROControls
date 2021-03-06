//
//  AlertViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/12/2.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "AlertListViewController.h"
#import "AlertListModel.h"
#import "ZEROAlertView.h"
#import "ZEROSheetView.h"
#import "CellDataAdapter.h"

@interface AlertListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation AlertListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAlertListData];
    
    [self createTableView];
}

#pragma mark - configure method

- (void)loadAlertListData{
    
    self.dataArray = [NSMutableArray array];
    NSArray *alerts = @[[[AlertListModel alloc] initWithTitle:@"ZEROAlertViewTypeDefault"],
                        [[AlertListModel alloc] initWithTitle:@"ZEROAlertViewTypeButtons"],
                        [[AlertListModel alloc] initWithTitle:@"ZEROAlertViewTypeCustomDefault"],
                        [[AlertListModel alloc] initWithTitle:@"ZEROAlertViewTypeCustomButtons"],];
    NSArray *sheets= @[[[AlertListModel alloc] initWithTitle:@"ZEROSheetViewTypeDefault"],
                       [[AlertListModel alloc] initWithTitle:@"ZEROSheetViewTypeCustom"]];
    
    NSMutableArray *aletArrays = [NSMutableArray array];
    [alerts enumerateObjectsUsingBlock:^(AlertListModel *_Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [aletArrays addObject:[CellDataAdapter cellDataItemWithCellReuseIdentifier:NSStringFromClass([UITableViewCell class]) data:item cellHeight:0 cellType:0]];
    }];

    NSMutableArray *sheetArrays = [NSMutableArray array];
    [sheets enumerateObjectsUsingBlock:^(AlertListModel *_Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [sheetArrays addObject:[CellDataAdapter cellDataItemWithCellReuseIdentifier:NSStringFromClass([UITableViewCell class]) data:item cellHeight:0 cellType:0]];
    }];
    
    [_dataArray addObject:aletArrays];
    [_dataArray addObject:sheetArrays];
}

- (void)createTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, WIDTH, HEIGHT - NavHeight) style:UITableViewStyleGrouped];
    tableView.delegate            = self;
    tableView.dataSource          = self;
    tableView.sectionHeaderHeight = 30.0;
    tableView.rowHeight           = 50.f;
    tableView.backgroundColor     = [[UIColor grayColor] colorWithAlphaComponent:0.05f];
    tableView.separatorStyle      = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:tableView];
    
}

#pragma mark - delegate method

#pragma mark -  
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UILabel *customView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    customView.textAlignment   = NSTextAlignmentCenter;
    customView.backgroundColor = [UIColor whiteColor];
    customView.textAlignment   = NSTextAlignmentCenter;
    customView.numberOfLines   = 0;
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [[[ZEROAlertView alloc] initWithTitle:@"ZEROAlertViewTypeDefaul" message:@"带标题和消息的默认2个按钮的Alert" clickHandle:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];
        }
        else if (indexPath.row == 1){
            
            [[[ZEROAlertView alloc] initWithTitle:@"ZEROAlertViewTypeButton" message:@"带标题和消息的多个按钮的Alert" clickHandle:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Z", @"E", @"R", @"O", nil] show];
        }
        else if (indexPath.row == 2){
            
            customView.text = @"ZEROAlertViewTypeCustomDefault \n \n 自定义的提示控件";
            [[[ZEROAlertView alloc] initWithCustomView:customView clickHandle:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];
        }
        else{
            
            customView.text = @"ZEROAlertViewTypeCustomButtons \n \n 自定义的提示控件";
            [[[ZEROAlertView alloc] initWithCustomView:customView clickHandle:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Z", @"E", @"R", @"O", nil] show];
        }
    }else{
        
        if (indexPath.row == 0) {
            
            [[[ZEROSheetView alloc] initWithTitle:@"ZEROSheetViewTypeDefault" cancelButtonTitle:@"Cancel" click:nil otherButtonTitles:@"Z", @"E", @"R", @"O", nil] show];
        }
        else{
            customView.text = @"ZEROSheetViewTypeCustom \n \n 自定义的提示控件";
            [[[ZEROSheetView alloc] initWithCustomView:customView cancelButtonTitle:@"Cancel" click:nil] show];
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    CellDataAdapter *item = _dataArray[indexPath.section][indexPath.row];
    AlertListModel *model = item.data;
    
    cell.textLabel.text = model.title;
    
    return cell;
}
@end
