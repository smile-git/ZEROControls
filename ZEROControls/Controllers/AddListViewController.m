//
//  AddListViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "AddListViewController.h"
#import "AddSelectListView.h"
#import "AddSelectListItem.h"

@interface AddListViewController ()

@property (nonatomic, strong) NSArray *listItems;

@end

@implementation AddListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavControllerRightImage:[UIImage imageNamed:@"barbuttonicon_add"]];
    [self loadItemData];
}

- (void)loadItemData{
    
    self.listItems = @[[AddSelectListItem initWithIcon:@"main_add_friend" title:@"添加朋友"],
                       [AddSelectListItem initWithIcon:@"main_code_friend" title:@"扫一扫"],
                       [AddSelectListItem initWithIcon:@"main_add_friend" title:nil],
                       [AddSelectListItem initWithIcon:nil title:@"扫一扫"]];
}


- (void)rightNavBtnClick:(UIButton *)rightBtn{
    
    AddSelectListView *listView = [[AddSelectListView alloc] initWithFrame:CGRectZero];
    listView.items      = self.listItems;
    listView.showListVC = self;
    [listView showClick:^(NSInteger selectIndex) {
        NSLog(@"%zi", selectIndex);
    }];
    
    //    [[[AddSelectListView alloc] initWithFrame:CGRectZero showVC:self items:self.listItems] showClick:^(NSInteger selectIndex) {
    //        NSLog(@"%zi", selectIndex);
    //    }];

}

@end
