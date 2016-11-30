//
//  ZEROAlertButtonsCell.h
//  Alert
//
//  Created by ZWX on 2016/11/30.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZEROAlertItem;

@interface ZEROAlertButtonsCell : UITableViewCell

@property (nonatomic, strong) UILabel *buttonsLabel;

- (void)configAlertButtons:(ZEROAlertItem *)item;

@end
