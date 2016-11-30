//
//  ZEROAlertButtonsCell.m
//  Alert
//
//  Created by ZWX on 2016/11/30.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlertButtonsCell.h"
#import "ZEROAlertItem.h"


@implementation ZEROAlertButtonsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.buttonsLabel                    = [[UILabel alloc] init];
        _buttonsLabel.layer.cornerRadius     = 5;
        _buttonsLabel.layer.masksToBounds    = YES;
        _buttonsLabel.layer.borderColor      = [UIColor whiteColor].CGColor;
        _buttonsLabel.layer.borderWidth      = 1;
        _buttonsLabel.textAlignment          = NSTextAlignmentCenter;
        [self.contentView addSubview:_buttonsLabel];
        
        self.selectionStyle                  = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configAlertButtons:(ZEROAlertItem *)item{
    
    _buttonsLabel.textColor         = item.textColor;
    _buttonsLabel.backgroundColor   = item.backgroundColor;
    _buttonsLabel.text              = item.text;
    _buttonsLabel.frame             = item.buttonFrame;
    if (item.layerColor) {
        
        _buttonsLabel.layer.borderColor = item.layerColor.CGColor;
    }
}

@end
