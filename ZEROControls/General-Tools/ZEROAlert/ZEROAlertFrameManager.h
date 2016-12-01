//
//  ZEROAlertFrameManager.h
//  Alert
//
//  Created by ZWX on 2016/11/28.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZEROAlertRootView.h"


@interface ZEROAlertFrameManager : NSObject

@property (nonatomic, readonly) CGFloat alertWidth;
@property (nonatomic, readonly) CGFloat alertHeight;
@property (nonatomic, readonly) CGFloat buttonsListCellHeight;
@property (nonatomic, readonly) CGRect  titleLabelFrame;
@property (nonatomic, readonly) CGRect  messageLabelFrame;
@property (nonatomic, readonly) CGRect  customViewFrame;
@property (nonatomic, readonly) CGRect  contentScrollViewFrame;
@property (nonatomic, readonly) CGSize  contentScolllViewContentSize;
@property (nonatomic, readonly) CGRect  horizontalLineFrame;
@property (nonatomic, readonly) CGRect  verticalLineFrame;
@property (nonatomic, readonly) CGRect  buttonsListFrame;
@property (nonatomic, readonly) BOOL    buttonsListScrollEnabled;


- (instancetype)initWithType:(ZEROAlertViewType)type title:(NSString *)title titleFont:(UIFont *)titleFont message:(NSString *)message messageFont:(UIFont *)messageFont customView:(UIView *)customView buttons:(NSArray *)buttons;


/**
 * @brief 计算两个按钮时，左右两个按钮的frame
 * @return button' frame
 */
- (CGRect)calculateNormalButtonFrame:(NSInteger)idx;

/**
 @brief 计算按钮列表按钮的frame
 
 @return button' frame
 */
- (CGRect)calculateButtonListButtonFrame;
@end
