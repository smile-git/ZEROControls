//
//  ZEROSheetView.h
//  Alert
//
//  Created by ZWX on 2016/11/26.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlertRootView.h"


typedef NS_ENUM(NSInteger, ZEROSheetViewType) {
    
    ZEROSheetViewTypeDefault = 0,
    ZEROSheetViewTypeCustom
};

@interface ZEROSheetView : ZEROAlertRootView

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle click:(ClickHandleWithIndex)clickHandle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithCustomView:(UIView *)customView cancelButtonTitle:(NSString *)cancelButtonTitle click:(ClickHandleWithIndex)clickHandle;

@property (nonatomic)   BOOL isCircleCorner;

@end
