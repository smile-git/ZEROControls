//
//  ZEROAlertManager.h
//  Alert
//
//  Created by ZWX on 2016/11/25.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZEROAlertManager : NSObject

@property (nonatomic, strong) UIWindow *currentWindow;
@property (nonatomic, weak)   UIWindow *oldKeyWindow;

@property (nonatomic, strong) NSMutableArray *alertStack;

@property (nonatomic, readonly) UIView* attachView;

+ (instancetype)sharedManager;

@end
