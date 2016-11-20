//
//  HWaterFallCell.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "HWaterFallCell.h"
#import "WaterfallPictureModel.h"
#import "UIImageView+WebCache.h"

@interface HWaterFallCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HWaterFallCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
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
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.imageView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.imageView];
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self setupCell];
        
        [self buildSubview];
    }
    return self;
}

- (void)loadContent {
    
    WaterfallPictureModel *model = self.data;
    self.imageView.bounds        = self.frame;
    self.imageView.center        = [self middlePoint];
    self.imageView.alpha         = 0.f;
    
    __weak HWaterFallCell *wself  = self;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.isrc]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                                 wself.imageView.image = image;
                                 
                                 [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionAllowUserInteraction
                                                  animations:^{
                                                      
                                                      wself.imageView.alpha = 1.f;
                                                      
                                                  } completion:nil];
                             }];
    
}

- (CGPoint)middlePoint {
    
    return CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);
}



@end
