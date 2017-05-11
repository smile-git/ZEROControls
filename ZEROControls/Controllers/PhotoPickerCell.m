//
//  PhotoPickerCell.m
//  ZEROControls
//
//  Created by ZWX on 2017/1/13.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "PhotoPickerCell.h"

@interface PhotoPickerCell()

@property (nonatomic, strong) UIButton *imageBtn;
@end

@implementation PhotoPickerCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupCell];
        
        [self buildSubview];
    }
    return self;
}

- (void)setupCell {
    
    self.backgroundColor   = [UIColor whiteColor];
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.25f].CGColor;
}

- (void)buildSubview {
    
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageBtn.frame = CGRectMake(0, 0, 10, 10);
    self.imageBtn.userInteractionEnabled = NO;
    self.imageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageBtn];
}

- (void)loadContent {
    
    [self.imageBtn setImage:self.photo forState:UIControlStateNormal];
    self.imageBtn.frame = self.bounds;
}
@end
