//
//  UIView+OscillatoryAnimation.h
//  PhotoPicker
//
//  Created by ZWX on 2016/12/30.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZEROOscillatoryAnimationType) {
    
    ZEROOscillatoryAnimationTypeBiggre,
    ZEROOscillatoryAnimationTypeSmaller
};

@interface UIView (OscillatoryAnimation)

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(ZEROOscillatoryAnimationType)type;

@end
