//
//  NavRootViewController.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "NavRootViewController.h"

@interface NavRootViewController ()<UIGestureRecognizerDelegate>

@end

@implementation NavRootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor                        = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorRGBA(220, 220, 220, 1)}];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //开启系统右滑返回
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled  = YES;     // 手势有效设置为YES  无效为NO
        self.navigationController.interactivePopGestureRecognizer.delegate = self;    // 手势的代理设置为self
    }
    
}

- (void)setNavControllerLeftImage:(UIImage *)leftImage withRightImage:(UIImage *)rightImage {
    if (leftImage) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 0, 50, 30);

        [button setImage:leftImage forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, - 30, 0, 0);
        [button addTarget:self action:@selector(leftNavBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    if (rightImage) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 0, 50, 30);
        
        [button setBackgroundImage:rightImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightNavBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)setNavControllerLeftImage:(UIImage *)leftImage {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(0, 0, 50, 30);
    
    [button setImage:leftImage forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, - 30, 0, 0);
    [button addTarget:self action:@selector(leftNavBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)setNavControllerRightImage:(UIImage *)rightImage {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(0, 0, 50, 30);
    
    [button setBackgroundImage:rightImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightNavBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (void)leftNavBtnClick:(UIButton *)leftBtn {
    
}

- (void)rightNavBtnClick:(UIButton *)rightBtn {
    
}

@end
