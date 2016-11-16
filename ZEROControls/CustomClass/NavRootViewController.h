//
//  NavRootViewController.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavRootViewController : UIViewController

- (void)setNavControllerLeftImage:(UIImage *)leftImage withRightImage:(UIImage *)rightImage;

- (void)setNavControllerLeftImage:(UIImage *)leftImage;

- (void)setNavControllerRightImage:(UIImage *)rightImage;


- (void)leftNavBtnClick:(UIButton *)leftBtn;

- (void)rightNavBtnClick:(UIButton *)rightBtn;

@end
