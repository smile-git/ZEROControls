//
//  ZEROAssetCell.h
//  PhotoPicker
//
//  Created by ZWX on 2016/12/29.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZEROAssetCellType) {
    
    ZEROAssetCellTypePhoto = 0,
    ZEROAssetCellTypeLievPhoto,
    ZEROAssetCellTypePhotoGif,
    ZEROAssetCellTypeVideo,
    ZEROAssetCellTypeAudio
};

@class ZEROAssetModel;
@interface ZEROAssetCell : UICollectionViewCell

@property (nonatomic, strong) ZEROAssetModel *assetModel;

@property (nonatomic, assign) BOOL allowPickingGif;

@property (nonatomic, assign) BOOL showSelectBtn;
@property (nonatomic, strong) UIButton *selectPhotoButton;

@property (nonatomic, copy) NSString *representedAssetIdentifier;


@property (nonatomic, copy) NSString *photoSelImageName;
@property (nonatomic, copy) NSString *photoDefImageName;

@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL isSelected);

@end

@interface ZEROAssetCameraCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end
