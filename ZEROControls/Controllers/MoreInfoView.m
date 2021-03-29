//
//  MoreInfoView.m
//  ZEROControls
//
//  Created by ZWX on 2021/3/23.
//  Copyright © 2021 ZWX. All rights reserved.
//

#import "MoreInfoView.h"

@implementation MoreInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        CGRect rect = self.frame;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-50, 0, rect.size.width + 50 * 2, rect.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end
