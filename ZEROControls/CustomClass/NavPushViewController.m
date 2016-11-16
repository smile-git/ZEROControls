//
//  PushViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "NavPushViewController.h"

@interface NavPushViewController ()

@end

@implementation NavPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavControllerLeftImage:[UIImage imageNamed:@"nav_back_white"]];
}

- (void)leftNavBtnClick:(UIButton *)leftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
