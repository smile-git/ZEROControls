//
//  ZEROPhotoPreviewView.h
//  PhotoPicker
//
//  Created by ZWX on 2017/1/5.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEROImgProgressView, ZEROAssetModel;
@interface ZEROPhotoPreviewView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

// ----- 照片的盛载容器
@property (nonatomic, strong) UIView *imageContainerView;

@property (nonatomic, strong) UIImageView *imageView;


@property (nonatomic, strong) ZEROImgProgressView *progressView;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

@property (nonatomic, strong) ZEROAssetModel *assetModel;
@property (nonatomic, strong) id asset;

@property (nonatomic, copy) void (^singleTapGestureBlock)();
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);

- (void)recoverSubviews;
@end
