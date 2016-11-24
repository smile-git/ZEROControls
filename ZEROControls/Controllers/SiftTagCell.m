//
//  SiftTagCell.m
//  SiftTag
//
//  Created by ZWX on 2016/11/24.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "SiftTagCell.h"

@implementation SiftTagCell

- (UILabel *)tagLabel{
    
    if (!_tagLabel) {
        
        self.tagLabel                   = [[UILabel alloc] init];
        _tagLabel.font                  = [UIFont systemFontOfSize:16];
        _tagLabel.textColor             = [UIColor whiteColor];
        _tagLabel.backgroundColor       = [UIColor clearColor];
        _tagLabel.layer.borderWidth     = 0.5;
        _tagLabel.layer.borderColor     = [UIColor whiteColor].CGColor;
        _tagLabel.layer.masksToBounds   = YES;
        _tagLabel.layer.cornerRadius    = 20;
        _tagLabel.textAlignment         = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_tagLabel];
    }
    
    return _tagLabel;
}

- (void)layoutSubviews{
    
    _tagLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
