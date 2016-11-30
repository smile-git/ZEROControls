//
//  ZEROAlertView.h
//  Alert
//
//  Created by ZWX on 2016/11/25.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlertRootView.h"

typedef NS_ENUM(NSInteger, ZEROAlertViewType) {
    
    ZEROAlertViewTypeDefault = 0,
    ZEROAlertViewTypeButtons,
    ZEROAlertViewTypeCustomDefault,
    ZEROAlertViewTypeCustomButtons
};

@interface ZEROAlertView : ZEROAlertRootView


/**
 标准AlertView

 @param title           标题
 @param message         内容
 @param cancle          取消文字
 @param ok              确认文字
 @param clickHandle     点击回调

 @return ZEROAlertView
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancle:(NSString *)cancle ok:(NSString *)ok click:(ClickHandleWithIndex)clickHandle;


/**
 多个按钮类型AlertView

 @param title           标题
 @param message         内容
 @param cancleHandle    点击回调
 @param buttons         按钮字典 数组

 @return ZEROAlertView
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message click:(ClickHandleWithIndex)cancleHandle buttons:(NSDictionary *)buttons, ...NS_REQUIRES_NIL_TERMINATION;


/**
 自定义View + 标准AlertView

 @param customView  customView description
 @param cancle      cancle description
 @param ok          ok description
 @param clickHandle clickHandle description

 @return ZEROAlertView
 */
- (instancetype)initWithCustomView:(UIView *)customView cancle:(NSString *)cancle ok:(NSString *)ok click:(ClickHandleWithIndex)clickHandle;
/**
 自定义View + 多个按钮类型AlertView

 @param customView          自定义View
 @param cancleHandle        点击回调
 @param buttons             按钮字典数组

 @return ZEROAlertView
 */
- (instancetype)initWithCustomView:(UIView *)customView click:(ClickHandleWithIndex)cancleHandle buttons:(NSDictionary *)buttons, ...NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, strong) NSArray <UITextField *>*textFields;
@end

