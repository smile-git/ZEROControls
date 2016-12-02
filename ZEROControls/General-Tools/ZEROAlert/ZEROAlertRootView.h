//
//  ZEROAlertRootView.h
//  Alert
//
//  Created by ZWX on 2016/11/26.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZEROAlertStyle)
{
    ZEROAlertStyleAlert = 0,
    ZEROAlertStyleActionSheet
};

typedef NS_ENUM(NSInteger, ZEROAlertViewType) {
    
    ZEROAlertViewTypeDefault = 0,
    ZEROAlertViewTypeButtons,
    ZEROAlertViewTypeCustomDefault,
    ZEROAlertViewTypeCustomButtons
};

typedef NS_ENUM(NSInteger, ZEROSheetViewType) {
    
    ZEROSheetViewTypeDefault = 0,
    ZEROSheetViewTypeCustom
};


typedef void (^ClickHandleWithIndex)(NSInteger index);

@interface ZEROAlertRootView : UIView

@property (nonatomic, copy) ClickHandleWithIndex clickIndexHandle;
@property (nonatomic)       ZEROAlertStyle       alertStyle;
@property (nonatomic)       BOOL                 dismissWhenTouchBackground;

@property (nonatomic, getter=isAlertReady) BOOL alertReady;

- (void)show;


- (void)dismissWithCompletion:(void(^)(void))completion;

@end

