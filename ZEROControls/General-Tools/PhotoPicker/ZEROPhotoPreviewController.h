//
//  ZEROPhotoPreviewController.h
//  PhotoPicker
//
//  Created by ZWX on 2016/12/28.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZEROPhotoPreviewController : UIViewController

// ----- All photo models / 所有图片模型数组
@property (nonatomic, strong) NSMutableArray *assetModels;

// ----- All photos / 所有图片数组
@property (nonatomic, strong) NSMutableArray *photos;

// ----- Index of the photo user click / 用户点击的图片索引
@property (nonatomic, assign) NSInteger currentIndex;

// ----- If YES, return original photo / 是否返回原图
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, assign) BOOL isCropImage;

// ----- Retrun the new selected photos / 返回最新的选中图片数组
@property (nonatomic, copy) void (^backButtonClickBlock)(BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void (^doneButtonClickBlock)(BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void (^doneButtonClickBlockCropMode)(UIImage *cropedImage,id asset);
@property (nonatomic, copy) void (^doneButtonClickBlockWithPreviewType)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);


@end
