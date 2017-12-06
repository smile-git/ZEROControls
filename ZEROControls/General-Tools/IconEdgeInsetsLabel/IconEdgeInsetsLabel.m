//
//  IconEdgeInsetsLabel.m
//  ZEROControls
//
//  Created by ZWX on 2017/12/6.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "IconEdgeInsetsLabel.h"

@interface IconEdgeInsetsLabel ()

@property (nonatomic, weak) UIView *oldIconView;

@end

@implementation IconEdgeInsetsLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    
    UIEdgeInsets insets = self.edgeInsets;
    
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets) limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x -= insets.left;
    rect.origin.y -= insets.top;
    rect.size.height += (insets.top + insets.bottom);
    
    _iconView && [_iconView isKindOfClass:[UIView class]] ? (rect.size.width += (insets.left + insets.right + _gap + _iconView.frame.size.width)) : (rect.size.width += (insets.left + insets.right));
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect {
    
    UIEdgeInsets insets = self.edgeInsets;
    
    if (self.iconView) {
        
        if (self.direction == kIconAtLeft) {
            
            _iconView.left = insets.left;
            _iconView.centerY = self.middleY;
            insets = UIEdgeInsetsMake(insets.top, insets.left + _gap + _iconView.width, insets.bottom, insets.right);
        
        } else if (self.direction == kIconAtRight) {
            
            _iconView.right = self.width - insets.right;
            _iconView.centerY = self.middleY;
            insets = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom, insets.right + _gap + _iconView.width);
        }
    }
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (void)sizeToFitWithText:(NSString *)text {
    
    self.text = text;
    
    // ----- 方法必要调用
    [self sizeToFit];
}

#pragma mark - setter & getter.

@synthesize  iconView = _iconView;

- (void)setIconView:(UIView *)iconView {
    
    _oldIconView && [_oldIconView isKindOfClass:[UIView class]] ? ([_oldIconView removeFromSuperview]) : 0;
    
    _iconView    = iconView;
    _oldIconView = iconView;
    
    [self addSubview:iconView];
}

- (UIView *)iconView {
    
    return _iconView;
}

@end
