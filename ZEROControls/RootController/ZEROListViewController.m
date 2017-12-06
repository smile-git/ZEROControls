//
//  ZEROListViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROListViewController.h"
#import "ZEROListCell.h"
#import "ZEROListModel.h"
#import "CellDataItem.h"

@interface ZEROListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic)         BOOL            tableViewLoadData;

@property (nonatomic, strong) NSMutableArray  <CellDataItem *> *items;

@end

@implementation ZEROListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"ZEROControls";
    
    [self configureDataSource];
    
    [self configureTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //防止在此页面左侧右滑之后，不能跳页的问题
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)configureDataSource {
    
    NSArray *array = @[[ZEROListModel initWithName:@"弧形列表(tableView)" controller:@"BezierTableViewController"],
                       [ZEROListModel initWithName:@"弧形列表(collectionView)" controller:@"CircleCollectionViewController"],
                       [ZEROListModel initWithName:@"导航 + 弹出框" controller:@"AddListViewController"],
                       [ZEROListModel initWithName:@"图片选择可排序" controller:@"PhotoChooseViewController"],
                       [ZEROListModel initWithName:@"纵向瀑布流" controller:@"HWaterFallViewController"],
                       [ZEROListModel initWithName:@"横向瀑布流" controller:@"WWaterFallViewController"],
                       [ZEROListModel initWithName:@"标签筛选" controller:@"SiftTagViewController"],
                       [ZEROListModel initWithName:@"自定义Alert" controller:@"AlertListViewController"],
                       [ZEROListModel initWithName:@"相册照片选取" controller:@"PhotoPickerViewController"],
                       [ZEROListModel initWithName:@"滑动门列表" controller:@"SlidingDoorViewController"],
                       [ZEROListModel initWithName:@"照片裁剪" controller:@"ShowTweakViewController"],
                       [ZEROListModel initWithName:@"多级分组" controller:@"TreeStructureViewController"]];

    self.items = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        
        ZEROListModel *item = array[i];
        item.index = i + 1;
        [item createAttributedName];
        [self.items addObject:[CellDataItem cellDataItemWithCellReuseIdentifier:NSStringFromClass([ZEROListCell class]) data:item cellHeight:0 cellType:0]];
    }
}

#pragma mark - TableView Related.

- (void)configureTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate       = self;
    self.tableView.dataSource     = self;
    self.tableView.rowHeight      = 50.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ZEROListCell class] forCellReuseIdentifier:NSStringFromClass([ZEROListCell class])];
    [self.view addSubview:_tableView];
    

    if (@available(iOS 11.0, *)){
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);//导航栏如果使用系统原生半透明的，top设置为64
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Load data.
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (int i = 0; i < self.items.count; i++) {
            
            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
        
        self.tableViewLoadData = YES;
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    });
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableViewLoadData ? self.items.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CellDataItem *item = _items[indexPath.row];
    ZEROListCell *cell = [tableView dequeueReusableCellWithIdentifier:item.cellReuseIdentifier];
    cell.dataItem      = item;
    cell.indexPath     = indexPath;
    
    [cell loadContent];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZEROListModel *model         = _items[indexPath.row].data;
    UIViewController *controller = [[NSClassFromString(model.controller) class] new];
    controller.title             = model.name;
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end
