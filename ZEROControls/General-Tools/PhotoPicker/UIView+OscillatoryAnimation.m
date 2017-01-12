//
//  UIView+OscillatoryAnimation.m
//  PhotoPicker
//
//  Created by ZWX on 2016/12/30.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "UIView+OscillatoryAnimation.h"

@implementation UIView (OscillatoryAnimation)

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(ZEROOscillatoryAnimationType)type {
    
    NSNumber *animationScale1;
    NSNumber *animationScale2;
    
    switch (type) {
        case ZEROOscillatoryAnimationTypeBiggre:
            animationScale1 = @(1.15);
            animationScale2 = @(0.92);
            break;
        case ZEROOscillatoryAnimationTypeSmaller:
            animationScale1 = @(0.5);
            animationScale2 = @(1.15);
        default:
            break;
    }
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];

}

@end
