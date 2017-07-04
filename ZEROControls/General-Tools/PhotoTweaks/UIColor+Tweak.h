//
//  UIColor+Tweak.h
//  PhotoTweaks
//
//  Created by ZWX on 2017/4/8.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Tweak)


+ (UIColor *)cancelButtonColor;
+ (UIColor *)cancelButtonHighlightedColor;

+ (UIColor *)saveButtonColor;
+ (UIColor *)saveButtonHighlightedColor;

+ (UIColor *)resetButtonColor;
+ (UIColor *)resetButtonHighlightedColor;


// ----- 裁剪线颜色
+ (UIColor *)cropLineColor;


// ----- 网格线颜色
+ (UIColor *)gridLineColor;

+ (UIColor *)maskColor;

+ (UIColor *)photoTweakCanvasBackgroundColor;

@end
