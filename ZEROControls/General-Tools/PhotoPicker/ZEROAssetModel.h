//
//  ZEROAssetModel.h
//  PhotoPicker
//
//  Created by ZWX on 2016/12/15.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZEROAssetModelMediaType) {
    ZEROAssetModelMediaTypePhoto = 0,
    ZEROAssetModelMediaTypeLivePhoto,
    ZEROAssetModelMediaTypePhotoGif,
    ZEROAssetModelMediaTypeVideo,
    ZEROAssetModelMediaTypeAudio
};

@interface ZEROAssetModel : NSObject


/** *@brief PHAsset or ALAsset */
@property (nonatomic, strong) id asset;

/** *brief The select status of a photo, default is No */
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) ZEROAssetModelMediaType type;

@property (nonatomic, copy) NSString *timeLength;


/** * @brief init a photo dataModel With a asset / 用asset创建一个照片moel */
+ (instancetype)assetModelWithAsset:(id)asset type:(ZEROAssetModelMediaType)type;

/** * @brief init a photo dataModel With a asset / 用asset创建一个照片moel */
+ (instancetype)assetModelWithAsset:(id)asset type:(ZEROAssetModelMediaType)type timeLength:(NSString *)timeLength;

@end


@interface ZEROAlbumModel : NSObject


/** * @brief the album name / 相册名 */
@property (nonatomic, copy) NSString *name;

/** * @brief Count of photos the album contain / 相册照片个数 */
@property (nonatomic, assign) NSInteger count;

/** * @brief PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset> */
@property (nonatomic, strong) id result;

@property (nonatomic, strong) NSArray <ZEROAssetModel *>*models;

@property (nonatomic, strong) NSArray <ZEROAssetModel *>*selectedModels;

@property (nonatomic, assign) NSUInteger selectedCount;

@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)albumModelWithResult:(id)result name:(NSString *)name;

@end
