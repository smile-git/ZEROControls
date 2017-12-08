//
//  LineBackgroundView.h
//  ZEROControls
//
//  Created by ZWX on 2017/12/8.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineBackgroundView : UIView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineGap;
@property (nonatomic, strong) UIColor *lineColor;

- (void)buildView;

+ (instancetype)createWithFrame:(CGRect)frame lineWidth:(CGFloat)width lineGap:(CGFloat)lineGap lineColor:(UIColor *)color;

@end
