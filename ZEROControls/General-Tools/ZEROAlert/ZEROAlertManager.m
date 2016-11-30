//
//  ZEROAlertManager.m
//  Alert
//
//  Created by ZWX on 2016/11/25.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlertManager.h"

@implementation ZEROAlertManager

+ (instancetype)sharedManager{
    
    static ZEROAlertManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [ZEROAlertManager new];
    });
    return _sharedManager;
}

- (UIWindow *)currentWindow{
    
    if (!_currentWindow) {
        
        _currentWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _currentWindow.windowLevel = UIWindowLevelStatusBar + 1;
        
    }
    return _currentWindow;
}

- (UIWindow *)oldKeyWindow{
    
    if (!_oldKeyWindow) {
        
        _oldKeyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return _oldKeyWindow;
}

- (NSMutableArray *)alertStack{
    
    if (!_alertStack) {
        
        _alertStack = [NSMutableArray array];
    }
    return _alertStack;
}

- (UIView *)attachView{
    
    return _currentWindow.rootViewController.view;
}

@end
