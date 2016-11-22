//
//  CircleCell.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/22.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "CircleCell.h"

@implementation CircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    _contentLabel.backgroundColor     = [self randomColor];
    _contentLabel.layer.cornerRadius  = 5;
    _contentLabel.layer.masksToBounds = YES;
    
}

- (UIColor *)randomColor
{
    CGFloat randomRed   = drand48();
    CGFloat randomGreen = drand48();
    CGFloat randomBlue  = drand48();
    
    return [UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:1.0];
}
@end