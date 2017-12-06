//
//  IconEdgeInsetsLabel.h
//  ZEROControls
//
//  Created by ZWX on 2017/12/6.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EIconEdgeDirection) {
    
    kIconAtLeft,
    kIconAtRight,
};

@interface IconEdgeInsetsLabel : UILabel

@property (nonatomic, strong) UIView *iconView;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) EIconEdgeDirection direction;
@property (nonatomic, assign) CGFloat gap;

- (void)sizeToFitWithText:(NSString *)text;

@end
