//
//  AddListViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "AddListViewController.h"
#import "ZZNavAddListController.h"
#import "SphereMenu.h"
#import "StyleKitName.h"

@interface AddListViewController ()

@property (nonatomic, strong) NSArray *listItems;

@end

@implementation AddListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self setNavControllerRightImage:[StyleKitName imageOfNavAdd]];
    // ----- [UIImage imageNamed:@"barbuttonicon_add"]
    
    [[[SphereMenu alloc] initWithFrame:CGRectMake(WIDTH - 100, HEIGHT - 150, 80, 80) menuImage:@"home_start" sphereImages:@[@"home_start_2", @"home_start_2", @"home_start_3"]] showInView:self.view completion:^(NSInteger index) {
        
        NSLog(@"%zi", index);
    }];
}


- (void)rightNavBtnClick:(UIButton *)rightBtn{
    
    NSArray *itemDictionarys = @[@{@"title": @"添加朋友", @"icon": @"main_add_friend"},
                                 @{@"title": @"扫一扫", @"icon": @"main_code_friend"},
                                 @{@"icon": @"main_add_friend"},
                                 @{@"title": @"扫一扫"},
                                 @{@"title": @"添加朋友", @"icon": @"main_add_friend"},
                                 @{@"title": @"扫一扫", @"icon": @"main_code_friend"}];
    
    [[ZZNavAddListController navAddListControllerWithDictionarys:itemDictionarys
                                                selectCompletion:^(NSInteger selectedIndex) {
                                                    
        NSLog(@"selected %ld", selectedIndex);
    }] showInViewController:self];
}

@end
