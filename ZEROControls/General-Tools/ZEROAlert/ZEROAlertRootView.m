//
//  ZEROAlertRootView.m
//  Alert
//
//  Created by ZWX on 2016/11/26.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlertRootView.h"
#import "ZEROAlertManager.h"

@interface ZEROAlertRootView()

@end

@implementation ZEROAlertRootView

#pragma mark - show

- (void)show{
        
    [[ZEROAlertManager sharedManager].alertStack addObject:self];
    
    if (self.alertStyle == ZEROAlertStyleAlert) {
        
        [self configAlert];
        [self showAlertHandle];
    }
    else{
        
        [self configSheet];
        [self showSheetHandle];
    }
}

#pragma mark 子类重写, config子控件frame

- (void)configAlert{
    
}


- (void)configSheet{
    
}

#pragma mark alert show
- (void)showAlertHandle{
    
    UIViewController *rootVC            = [[UIViewController alloc] init];
    rootVC.view.backgroundColor         = [UIColor clearColor];
    [ZEROAlertManager sharedManager].currentWindow.rootViewController   = rootVC;
    
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    coverButton.frame = [[UIScreen mainScreen] bounds];
    [coverButton addTarget:self action:@selector(dismissWhenTouch) forControlEvents:UIControlEventTouchUpInside];
    [rootVC.view addSubview:coverButton];
    [rootVC.view addSubview:self];

    [[ZEROAlertManager sharedManager].currentWindow makeKeyAndVisible];
    
    
    self.alertReady  = NO;
    
    CGFloat duration = 0.3;
    for (UIButton *btn in self.subviews) {
        
        btn.userInteractionEnabled = NO;
    }
    
    self.alpha = 0;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.alpha                  = 1.0;
        rootVC.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];

    } completion:^(BOOL finished) {
        
        for (UIButton *btn in self.subviews) {
            
            btn.userInteractionEnabled = YES;
        }
        self.alertReady = YES;
    }];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values          = @[@(0.8), @(1.05), @(1.1), @(1)];
    animation.keyTimes        = @[@(0), @(0.3), @(0.5), @(1.0)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration        = duration;
    [self.layer addAnimation:animation forKey:@"bouce"];
}

#pragma mark sheet show
- (void)showSheetHandle{
    
    UIViewController *rootVC            = [[UIViewController alloc] init];
    rootVC.view.backgroundColor         = [UIColor clearColor];
    [ZEROAlertManager sharedManager].currentWindow.rootViewController   = rootVC;
    
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    coverButton.frame = [[UIScreen mainScreen] bounds];
    [coverButton addTarget:self action:@selector(dismissWhenTouch) forControlEvents:UIControlEventTouchUpInside];
    [rootVC.view addSubview:coverButton];
    [rootVC.view addSubview:self];
    
    [[ZEROAlertManager sharedManager].currentWindow makeKeyAndVisible];
    
    
    self.alertReady  = NO;
    
    CGFloat duration = 0.2;
    for (UIButton *btn in self.subviews) {
        
        btn.userInteractionEnabled = NO;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, - self.frame.size.height);
        rootVC.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        
    } completion:^(BOOL finished) {
        
        for (UIButton *btn in self.subviews) {
            
            btn.userInteractionEnabled = YES;
        }
        self.alertReady = YES;
    }];
}

#pragma mark - dismiss

#pragma mark -
- (void)dismissWithCompletion:(void(^)(void))completion{
    
    if (self.alertStyle == ZEROAlertStyleAlert) {
        
        [self dismissAlertWithCompletion:completion];
    }
    else{
        
        [self dismissSheetWithCompletion:completion];
    }
}

#pragma mark alert
- (void)dismissAlertWithCompletion:(void(^)(void))completion{
    
    self.alertReady = NO;
    
    CGFloat duration = 0.2;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [ZEROAlertManager sharedManager].attachView.alpha = 0;
        self.alpha                                        = 0;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.4, 0.4);
    } completion:^(BOOL finished) {
        
        self.transform = CGAffineTransformMakeScale(1, 1);
        
        [self stackHandle];
        
        if (completion) {
            
            completion();
        }
        
        NSInteger count = [ZEROAlertManager sharedManager].alertStack.count;
        if (count > 0) {
            ZEROAlertRootView *lastAlert = [ZEROAlertManager sharedManager].alertStack.lastObject;
            [lastAlert showAlertHandle];
        }
    }];

}

#pragma mark sheet
- (void)dismissSheetWithCompletion:(void(^)(void))completion{
    
    self.alertReady = NO;
    
    CGFloat duration = 0.2;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [ZEROAlertManager sharedManager].attachView.alpha = 0;
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
        [self stackHandle];
        
        if (completion) {
            
            completion();
        }
        
        NSInteger count = [ZEROAlertManager sharedManager].alertStack.count;
        if (count > 0) {
            ZEROAlertRootView *lastAlert = [ZEROAlertManager sharedManager].alertStack.lastObject;
            [lastAlert showAlertHandle];
        }

    }];
}

- (void)stackHandle{
    
    [self removeFromSuperview];
    
    [[ZEROAlertManager sharedManager].alertStack removeObject:self];
    
    NSInteger count = [ZEROAlertManager sharedManager].alertStack.count;
    if (count == 0) {
        
        [[ZEROAlertManager sharedManager].oldKeyWindow makeKeyAndVisible];
        [ZEROAlertManager sharedManager].currentWindow = nil;
    }
}

#pragma mark - 点击屏幕, alert消失
- (void)dismissWhenTouch{
    
    if (self.alertStyle == ZEROAlertStyleAlert) {
        
        if (_dismissWhenTouchBackground) {
            
            [self dismissAlertWithCompletion:nil];
        }
    }
    else{
        
        [self dismissSheetWithCompletion:nil];
    }
}
@end
