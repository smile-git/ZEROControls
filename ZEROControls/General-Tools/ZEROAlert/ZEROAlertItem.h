//
//  ZEROAlertItem.h
//  Alert
//
//  Created by ZWX on 2016/11/25.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZEROAlertViewButtonType) {
    
    ZEROAlertViewButtonTypeNomalCancel = 0,
    ZEROAlertViewButtonTypeNomalOK,
    ZEROAlertViewButtonTypeButtonsCancel,
    ZEROAlertViewButtonTypeButtonsDefault,
    ZEROAlertViewButtonTypeWarn
};


/**
 * @brief Alert的按钮元素配置
 */
@interface ZEROAlertItem : NSObject

@property (nonatomic, copy) NSString                *text;
@property (nonatomic)       NSInteger               index;
@property (nonatomic)       ZEROAlertViewButtonType buttonType;
@property (nonatomic)       CGRect buttonFrame;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *layerColor;

- (instancetype)initWithText:(NSString *)text index:(NSInteger)index buttonType:(ZEROAlertViewButtonType)buttonType buttonFrame:(CGRect)buttonFrame;

@end
