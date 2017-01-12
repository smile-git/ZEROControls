//
//  AddListViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "AddListViewController.h"
#import "AddSelectListItem.h"
#import "AddListController.h"
#import "SphereMenu.h"

@interface AddListViewController ()

@property (nonatomic, strong) NSArray *listItems;

@end

@implementation AddListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self setNavControllerRightImage:[UIImage imageNamed:@"barbuttonicon_add"]];
    
    [self loadItemData];
    
    [[[SphereMenu alloc] initWithFrame:CGRectMake(WIDTH - 100, HEIGHT - 150, 80, 80) menuImage:@"home_start" sphereImages:@[@"home_start_2", @"home_start_2", @"home_start_3"]] showInView:self.view completion:^(NSInteger index) {
        
        NSLog(@"%zi", index);
    }];
}

- (void)loadItemData{
    
    self.listItems = @[[AddSelectListItem initWithIcon:@"main_add_friend" title:@"添加朋友"],
                       [AddSelectListItem initWithIcon:@"main_code_friend" title:@"扫一扫"],
                       [AddSelectListItem initWithIcon:@"main_add_friend" title:nil],
                       [AddSelectListItem initWithIcon:nil title:@"扫一扫"],
                       [AddSelectListItem initWithIcon:@"main_add_friend" title:@"添加朋友"],
                       [AddSelectListItem initWithIcon:@"main_code_friend" title:@"扫一扫"],
                       [AddSelectListItem initWithIcon:@"main_add_friend" title:nil],
                       [AddSelectListItem initWithIcon:nil title:@"扫一扫"]];
    
    
}


- (void)rightNavBtnClick:(UIButton *)rightBtn{
    
    [[AddListController addListControllerWithItems:self.listItems] showInViewController:self completion:^(NSInteger selectIndex) {
        NSLog(@"%zi", selectIndex);
    }];
}

@end
