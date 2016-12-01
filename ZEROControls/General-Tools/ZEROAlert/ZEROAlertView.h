//
//  ZEROAlertView.h
//  Alert
//
//  Created by ZWX on 2016/11/25.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlertRootView.h"

@interface ZEROAlertView : ZEROAlertRootView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message clickHandle:(ClickHandleWithIndex)clickHandle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithCustomView:(UIView *)customView clickHandle:(ClickHandleWithIndex)clickHandle cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, strong) NSArray <NSDictionary *>*otherButtons;

@property (nonatomic, strong) NSArray <UITextField *>*textFields;
@end

