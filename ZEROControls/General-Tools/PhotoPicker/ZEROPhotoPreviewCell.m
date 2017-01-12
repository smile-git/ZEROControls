//
//  ZEROPhotoPreviewCell.m
//  PhotoPicker
//
//  Created by ZWX on 2017/1/5.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "ZEROPhotoPreviewCell.h"
#import "ZEROAssetModel.h"
#import "ZEROPhotoManager.h"
#import "UIView+Ext.h"

@implementation ZEROPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.previewView = [[ZEROPhotoPreviewView alloc] initWithFrame:self.bounds];
        
        __weak typeof(self)weakSelf = self;
        [self.previewView setSingleTapGestureBlock:^{
            if (weakSelf.singleTapGestureBlock) {
                weakSelf.singleTapGestureBlock();
            }
        }];
        [self.previewView setImageProgressUpdateBlock:^(double progress) {
            if (weakSelf.imageProgressUpdateBlock) {
                weakSelf.imageProgressUpdateBlock(progress);
            }
        }];
        
        [self addSubview:self.previewView];
    }
    return self;
}

#pragma mark - ---- Set Method ----
- (void)setAssetModel:(ZEROAssetModel *)assetModel {
    
    _assetModel = assetModel;
    _previewView.assetModel = assetModel;
//    _previewView.asset = assetModel.asset;
}

- (void)setAllowCrop:(BOOL)allowCrop {
    
    _allowCrop = allowCrop;
    _previewView.allowCrop = allowCrop;
}

- (void)setCropRect:(CGRect)cropRect {
    
    _cropRect = cropRect;
    _previewView.cropRect = cropRect;
}

- (void)recoverSubviews {
    
    [_previewView recoverSubviews];
}

@end



























