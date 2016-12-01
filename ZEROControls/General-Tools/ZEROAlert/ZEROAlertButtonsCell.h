//
//  ZEROAlertButtonsCell.h
//  Alert
//
//  Created by ZWX on 2016/11/30.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZEROAlertItem;

@protocol ZEROAlertButtonsCellDelegate <NSObject>

- (void)buttonsButtonClick:(UIButton *)sender;

@end

static const NSInteger buttonTag = 10086;    //按钮的默认tag值

@interface ZEROAlertButtonsCell : UITableViewCell

@property (nonatomic, strong) UIButton *buttonsButton;
@property (nonatomic, weak)   id<ZEROAlertButtonsCellDelegate> delegate;

- (void)configAlertButtons:(ZEROAlertItem *)item;

@end
