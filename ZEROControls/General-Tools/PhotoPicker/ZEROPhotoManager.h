//
//  ZEROPhotoManager.h
//  PhotoPicker
//
//  Created by ZWX on 2016/12/15.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)


@class ZEROAssetModel, ZEROAlbumModel;

@interface ZEROPhotoManager : NSObject

@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;

+ (instancetype)shareManager;

// ----- 是否要修复方向
@property (nonatomic, assign) BOOL shouldFixOrientation;


// ----- 照片预览最大宽度 Default is 600px / 默认600像素宽度
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;

// ----- PhotoPickerController中Collectionview每行照片个数 默认是 4
@property (nonatomic, assign) NSInteger columnNumber;

// ----- 对照片排序，安修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在前面，内部的拍照按钮会排在第一个
@property (nonatomic, assign) BOOL sortAscendingByModifucationDate;

// ----- 最小可选中的照片宽高度，小于这个宽度的图片不可选中 默认是0
@property (nonatomic, assign) CGFloat minPhotoWidthSelectAble;
@property (nonatomic, assign) CGFloat minPhotoHeightSelectAble;

// ----- 当不可选时隐藏该图片
@property (nonatomic, assign) BOOL hideWhenCanNotSelect;


/** * @brief 查询是否获得了授权 YES是获得 */
- (BOOL)authorizationStatusAuthorized;

/** * @brief 获得授权的状态 */
- (NSInteger)authorizationStatus;

#pragma mark - ---- Get Albums method ----

/** * @brief get Camera Roll Album / 获取相机胶卷相册*/
- (void)getCameraRollAlbumVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(ZEROAlbumModel *model))completion;

/** * @beief get All Albums / 获取所有相册 */
- (void)getAllAlbumsVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray <ZEROAlbumModel *>*))completion;

#pragma mark - ---- Get Assets method ----

/** * @brief get assets 获得照片Asset数组
 @param result 相册result资源 */
- (void)getAssetsFromFetchResult:(id)result allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray <ZEROAssetModel *>*models))completion;

/** * @brief Get Asset With Index 根据下标获取相对应照片Asset 
 如果索引越界，在回调中返回nil*/
- (void)getAssetFromFetchResult:(id)result atIndex:(NSInteger)index allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completin:(void (^)(ZEROAssetModel *models))completion;

#pragma mark - ---- Get Photo method ----

/** * @brief 获取相册封面 */
- (void)getPostImageWithAlbumModel:(ZEROAlbumModel *)albumModel completion:(void (^)(UIImage *postImage))completion;

/** * @brief 获得照片本身 */
- (PHImageRequestID)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;

- (PHImageRequestID)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;

- (PHImageRequestID)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, NSDictionary *info, BOOL *stop))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

- (PHImageRequestID)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, NSDictionary *info, BOOL *stop))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

/** * @brief Get Original Photo / 获取原图image 
 * 该方法会先返回缩略图，再返回原图，如果info[PHImageResultIsDegradedKey] 为 YES，则表明当前返回的是缩略图，否则是原图*/
- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;

/** * @brief Get Original Photo / 获取原图data */
- (void)getOriginalPhotoDataWithAsset:(id)asset completion:(void (^)(NSData *data, NSDictionary *info, BOOL isDegraded))completion;

#pragma mark - ---- Save Photo method ----
/** * @brief Save Photo / 保存图片 */
- (void)savePhotoWithImage:(UIImage *)image completion:(void (^)(NSError *error))completion;

#pragma mark - ---- Get Video method ----
/** * @brief Get Video / 获得视频 */
- (void)getVideoWithAsset:(id)asset completion:(void (^)(AVPlayerItem *playerItem, NSDictionary *info))completion;

#pragma mark - ---- Export method ----
/** * @brief Export Video / 导出视频 */
- (void)exportVideoOutPutPathWithAsset:(id)asset completion:(void (^)(NSString *outputPath))completion;


#pragma mark - ---- Other method ----
/** * @brief Get Photos Bytes / 获得一组照片的大小 */
- (void)getPhotosBytesWithArray:(NSArray <ZEROAssetModel *>*)photos completion:(void (^)(NSString *totalBytes))completion;

/** Judge is a assets array contain the asset / 判断一个assets数组是否包含该asset */
- (BOOL)isAssetsArray:(NSArray *)assets containAsset:(id)asset;


/** * @brief Get unique string / 获取唯一标识 */
- (NSString *)getAssetIdentifier:(id)asset;


/** * @brief Judge is Camera Rool / 判断是否是相机胶卷 */
- (BOOL)isCameraRollAlbum:(NSString *)albumName;


/** * @brief 检查照片大小是否满足最小要求 */
- (BOOL)isPhotoSelectAbleWithAsset:(id)asset;


/** * @brief 根据照片asset资源，获取照片尺寸大小 */
- (CGSize)photoSizeWithAsset:(id)asset;

/** * @brief 修正图片转向 */
- (UIImage *)fixPhotoOrientation:(UIImage *)aImage;
@end
