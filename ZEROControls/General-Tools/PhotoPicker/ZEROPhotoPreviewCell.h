//
//  ZEROPhotoPreviewCell.h
//  PhotoPicker
//
//  Created by ZWX on 2017/1/5.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEROPhotoPreviewView.h"

@class ZEROAssetModel;
@interface ZEROPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, strong) ZEROAssetModel *assetModel;
@property (nonatomic, copy) void (^singleTapGestureBlock)();
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);

@property (nonatomic, strong) ZEROPhotoPreviewView *previewView;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

- (void)recoverSubviews;
@end
