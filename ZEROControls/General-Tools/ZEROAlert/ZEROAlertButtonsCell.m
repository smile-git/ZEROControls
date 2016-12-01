//
//  ZEROAlertButtonsCell.m
//  Alert
//
//  Created by ZWX on 2016/11/30.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAlertButtonsCell.h"
#import "ZEROAlertItem.h"
#import "UIImage+SolidColor.h"

@implementation ZEROAlertButtonsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle                     = UITableViewCellSelectionStyleNone;
        self.buttonsButton                      = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonsButton.layer.cornerRadius       = 5;
        _buttonsButton.layer.masksToBounds      = YES;
        _buttonsButton.layer.borderColor        = [UIColor whiteColor].CGColor;
        _buttonsButton.layer.borderWidth        = 1;
        _buttonsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_buttonsButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_buttonsButton];
        
    }
    return self;
}

- (void)configAlertButtons:(ZEROAlertItem *)item{
    
    [_buttonsButton setTitleColor:item.textColor forState:UIControlStateNormal];
    [_buttonsButton setTitleColor:item.backgroundColor forState:UIControlStateHighlighted];
    [_buttonsButton setBackgroundImage:[UIImage imageWithSize:item.buttonFrame.size color:item.backgroundColor] forState:UIControlStateNormal];
    [_buttonsButton setBackgroundImage:[UIImage imageWithSize:item.buttonFrame.size color:item.textColor] forState:UIControlStateHighlighted];
    [_buttonsButton setTitle:item.text forState:UIControlStateNormal];
    _buttonsButton.frame    = item.buttonFrame;
    _buttonsButton.tag      = buttonTag + item.index;
    
    if (item.layerColor) {
        
        _buttonsButton.layer.borderColor = item.layerColor.CGColor;
    }
}

- (void)buttonClick:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonsButtonClick:)]) {
        
        [self.delegate buttonsButtonClick:sender];
    }
}

@end
