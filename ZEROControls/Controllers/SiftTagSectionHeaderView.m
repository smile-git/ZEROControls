//
//  SiftTagSectionHeaderView.m
//  SiftTag
//
//  Created by ZWX on 2016/11/24.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "SiftTagSectionHeaderView.h"

@implementation SiftTagSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 150, 40)];
        
        _titleLabel.font                = [UIFont systemFontOfSize:16];
        _titleLabel.textColor           = [UIColor whiteColor];
        _titleLabel.backgroundColor     = [UIColor clearColor];
        
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
