//
//  ZEROPhotoManager.m
//  PhotoPicker
//
//  Created by ZWX on 2016/12/15.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROPhotoManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZEROAssetModel.h"


@interface ZEROPhotoManager()

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;

@end

@implementation ZEROPhotoManager

static const NSInteger margin = 4;
static CGSize AssetGridThumbnailSize;
static CGFloat ZEROScreenWidth;
static CGFloat ZEROScreenScale;

+ (instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    static ZEROPhotoManager *manager;
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
        
        if (iOS8Later) {
            
            manager.cachingImageManager = [[PHCachingImageManager alloc] init];
            //  manager.cachingImageManager.allowsCachingHighQualityImages = YES;/
        }
        ZEROScreenWidth = [UIScreen mainScreen].bounds.size.width;
        
        ZEROScreenScale = 2.0;
        // ----- 测试发现，如果scale在plus真机上取到3.0，内存会增大很多，故这里写死2.0
        if (ZEROScreenWidth > 700) {
            
            ZEROScreenScale = 1.5;
        }
    });
    
    return manager;
}

#pragma mark - ---- set method ----
- (void)setColumnNumber:(NSInteger)columnNumber{
    
    _columnNumber  = columnNumber;
    CGFloat itemWH = (ZEROScreenWidth - 2 * margin) / columnNumber - margin;
    AssetGridThumbnailSize = CGSizeMake(itemWH * ZEROScreenScale, itemWH * ZEROScreenScale);
}

#pragma mark - ---- get method ----
- (ALAssetsLibrary *)assetLibrary{
    
    if (!_assetLibrary) {
        
        _assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetLibrary;
}

#pragma mark - ---- public method ----
- (BOOL)authorizationStatusAuthorized{
    
    return [self authorizationStatus] == 3;
}

- (NSInteger)authorizationStatus{
    
    if (iOS8Later) {
        
        return [PHPhotoLibrary authorizationStatus];
    }
    else{
        
        return [ALAssetsLibrary authorizationStatus];
    }
    return NO;
}

#pragma mark - ---- Get Album method ----
/** * @brief get Camera Roll Album 获取相机胶卷相册*/
- (void)getCameraRollAlbumVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(ZEROAlbumModel *model))completion{
    
    __block ZEROAlbumModel *model;
    if (iOS8Later) {
        
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        // ----- PHFetchOptions : 获取资源时的参数，可以传 nil，即使用系统默认值
        if (!allowPickingVideo) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            // ----- NSPredicate 从数据堆中根据条件进行筛选
        }
        if (!allowPickingImage) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        if (!self.sortAscendingByModifucationDate) {
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:self.sortAscendingByModifucationDate]];
            // ----- NSSortDescriptor 指定用于对象数组排序的对象的属性
        }
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        // ----- PHFetchResult 表示一系列的资源结果集合，也可以是相册的集合
        
        [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *_Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // ----- PHAssetCollection: PHCollection 的子类，表示一个相册或者一个时刻，或者是一个「智能相册（系统提供的特定的一系列相册，例如：最近删除，视频列表，收藏等等
            if (![collection isKindOfClass:[PHAssetCollection class]]) {
                // ----- 有可能是PHCollectionList类的对象，过滤掉
                return;     // ----- 继续遍历，continue
            }
            if ([self isCameraRollAlbum:collection.localizedTitle]) {
                
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                model = [ZEROAlbumModel albumModelWithResult:fetchResult name:collection.localizedTitle];
                
                if (completion) completion(model);
                *stop = YES;
            }
        }];
    }else{
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if ([group numberOfAssets] < 1) return ;
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            if ([self isCameraRollAlbum:name]) {
                
                model = [ZEROAlbumModel albumModelWithResult:group name:name];
                if (completion) {
                    completion(model);
                    *stop = YES;
                }
            }
        } failureBlock:nil];
    }
}

/** * @beief get All Albums 获取所有相册 */
- (void)getAllAlbumsVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<ZEROAlbumModel *> *))completion{
    NSMutableArray *albumArr = [NSMutableArray array];
    if (iOS8Later) {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        if (!allowPickingVideo) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        }
        if (!allowPickingImage) {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        if (!self.sortAscendingByModifucationDate) {
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:self.sortAscendingByModifucationDate]];
        }
        PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
        // ----- 我的照片流
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        // ----- 所有相册智能相册
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        // ----- 用户创建相册
        PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        // ----- 同步相册
        PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
        NSArray *allAlbums = @[myPhotoStreamAlbum, smartAlbums, topLevelUserCollections, syncedAlbums, sharedAlbums];
        [allAlbums enumerateObjectsUsingBlock:^(PHFetchResult * _Nonnull album, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [album enumerateObjectsUsingBlock:^(PHAssetCollection *_Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([collection isKindOfClass:[PHCollectionList class]]) return ;
                // ----- 过滤掉PHCollectionList
                
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                // ----- 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
                
                if (fetchResult.count < 1) return;
                if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"])   return;
                // ----- 过滤掉无图片的相册，最近删除的相册
                
                if ([self isCameraRollAlbum:collection.localizedTitle]) {
                    [albumArr insertObject:[ZEROAlbumModel albumModelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
                }
                else{
                    [albumArr addObject:[ZEROAlbumModel albumModelWithResult:fetchResult name:collection.localizedTitle]];
                }

            }];
        }];
        
        if (completion && albumArr.count > 0) completion(albumArr);
    }
     else {
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group == nil) {
                if (completion && albumArr.count > 0)  completion(albumArr);
            }
            if ([group numberOfAssets] < 1) return ;
            
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            if ([self isCameraRollAlbum:name]) {
                
                [albumArr insertObject:[ZEROAlbumModel albumModelWithResult:group name:name] atIndex:0];
            }
            else if ([name isEqualToString:@"My Photo Stream"] || [name isEqualToString:@"我的照片流"]){
                
                if (albumArr.count) {
                    [albumArr insertObject:[ZEROAlbumModel albumModelWithResult:group name:name] atIndex:1];
                } else {
                    [albumArr addObject:[ZEROAlbumModel albumModelWithResult:group name:name]];
                }
            } else {
                
                [albumArr addObject:[ZEROAlbumModel albumModelWithResult:group name:name]];
            }
        } failureBlock:nil];
    }    
}

#pragma mark - ---- Get Assets method ----
/** * @brief get assets 获得照片Asset数组
 @param result 相册result资源 */
- (void)getAssetsFromFetchResult:(id)result allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<ZEROAssetModel *> *))completion {
    
    NSMutableArray *photoArr = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        [fetchResult enumerateObjectsUsingBlock:^(PHAsset *_Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ZEROAssetModel *model = [self assetModelWithAsset:asset allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage];
            if (model) {
                [photoArr addObject:model];
            }
        }];
        
        if (completion) completion(photoArr);
    }
    else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        
        ALAssetsGroup *group = (ALAssetsGroup *)result;
        if (allowPickingImage && allowPickingVideo) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
        } else if (allowPickingVideo) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
        } else if (allowPickingImage) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        }
        ALAssetsGroupEnumerationResultsBlock resultBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
            if (!asset) {
                if (completion) completion(photoArr);
            }
            ZEROAssetModel *model = [self assetModelWithAsset:asset allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage];
            if (model) {
                [photoArr addObject:model];
            }
        };
        if (_sortAscendingByModifucationDate) {
            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                
                if (resultBlock) resultBlock(asset, index, stop);
            }];
        } else {
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                if (resultBlock) resultBlock(asset, index, stop);
            }];
        }
    }
}

/** * @brief Get Asset With Index 根据下标获取相对应照片Asset
 如果索引越界，在回调中返回nil*/
- (void)getAssetFromFetchResult:(id)result atIndex:(NSInteger)index allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completin:(void (^)(ZEROAssetModel *))completion {
    
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        PHAsset *asset;
        @try {
            asset = fetchResult[index];
        }
        @catch (NSException *exception) {
            if (completion) completion(nil);
            return;
        }

        ZEROAssetModel *model = [self assetModelWithAsset:asset allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage];
        if (completion) completion(model);
    }
    else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        
        ALAssetsGroup *group = (ALAssetsGroup *)result;
        if (allowPickingImage && allowPickingVideo) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
        } else if (allowPickingVideo) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
        } else if (allowPickingImage) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        }
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
        @try {
            [group enumerateAssetsAtIndexes:indexSet options:NSEnumerationConcurrent usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                
                if (!asset) return ;
                
                ZEROAssetModel *model = [self assetModelWithAsset:asset allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage];
                if (completion) completion(model);
            }];
        }
        @catch (NSException *exception) {
            if (completion) completion(nil);
        }
    }
}

#pragma mark - ---- Get Photo method ----

- (PHImageRequestID)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *, NSDictionary *, BOOL))completion {
    
    CGFloat fullScreenWidth = ZEROScreenWidth;
    if (fullScreenWidth > _photoPreviewMaxWidth) {
        
        fullScreenWidth = _photoPreviewMaxWidth;
    }
    
    return [self getPhotoWithAsset:asset photoWidth:fullScreenWidth completion:completion progressHandler:nil networkAccessAllowed:YES];
}

- (PHImageRequestID)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *, NSDictionary *, BOOL))completion {
    
    return [self getPhotoWithAsset:asset photoWidth:photoWidth completion:completion progressHandler:nil networkAccessAllowed:YES];
}

- (PHImageRequestID)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, NSDictionary *info, BOOL *stop))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    
    CGFloat fullScreenWidth = ZEROScreenWidth;
    if (fullScreenWidth > _photoPreviewMaxWidth) {
        fullScreenWidth = _photoPreviewMaxWidth;
    }
    
    return [self getPhotoWithAsset:asset photoWidth:fullScreenWidth completion:completion progressHandler:progressHandler networkAccessAllowed:networkAccessAllowed];
}

- (PHImageRequestID)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, NSDictionary *info, BOOL *stop))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        CGSize imageSize;
        if (photoWidth > ZEROScreenWidth && photoWidth < _photoPreviewMaxWidth) {
            imageSize = AssetGridThumbnailSize;
        } else {
            PHAsset *phAsset    = (PHAsset *)asset;
            CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
            CGFloat pixelWidth  = photoWidth * ZEROScreenScale;
            CGFloat pixelHeight = pixelWidth / aspectRatio;
            imageSize = CGSizeMake(pixelWidth, pixelHeight);
        }
        // ----- 下面两行代码，修复获取图片时出现的瞬间内存过高的问题
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        PHImageRequestID imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            BOOL downloadFinished = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinished && result) {
                result = [self fixPhotoOrientation:result];
                if (completion) {
                    completion(result, info, [[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                }
            }
            
            // ----- Download image from iCloud  /  从iCloud下载图片
            if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.networkAccessAllowed = YES;
                options.resizeMode = PHImageRequestOptionsResizeModeFast;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    
                    UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                    resultImage = [self scaleImage:resultImage toSize:imageSize];
                    if (resultImage) {
                        resultImage = [self fixPhotoOrientation:resultImage];
                        
                        if (completion) {
                            completion(resultImage, info, [[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                        }
                    }
                }];
            }
        }];
        return imageRequestID;
    }
    else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = (ALAsset *)asset;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            CGImageRef thumbnailImageRef = alAsset.thumbnail;
            UIImage *thumbnailImage = [UIImage imageWithCGImage:thumbnailImageRef scale:2.0 orientation:UIImageOrientationUp];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion) completion(thumbnailImage, nil, YES);
                
                if (photoWidth == ZEROScreenWidth || photoWidth == _photoPreviewMaxWidth) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
                        CGImageRef fullScreenImageRef = [assetRep fullScreenImage];
                        UIImage *fullScreenImage = [UIImage imageWithCGImage:fullScreenImageRef scale:2.0 orientation:UIImageOrientationUp];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (completion) completion(fullScreenImage, nil, NO);
                        });
                    });
                }
            });
        });
    }
    return 0;

}

/** * @brief Get PostImage / 获取相册封面 */
- (void)getPostImageWithAlbumModel:(ZEROAlbumModel *)albumModel completion:(void (^)(UIImage *))completion {
    
    if (iOS8Later) {
        id asset = [albumModel.result lastObject];
        if (!self.sortAscendingByModifucationDate) {
            asset = [albumModel.result firstObject];
        }
        [[ZEROPhotoManager shareManager] getPhotoWithAsset:asset photoWidth:80 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            
            if (completion) completion(photo);
        }];
    } else {
        ALAssetsGroup *group = albumModel.result;
        UIImage *postImage = [UIImage imageWithCGImage:group.posterImage];
        
        if (completion) completion(postImage);
    }
}

/** * @brief Get Original Photo / 获取原图image 
 * 该方法会先返回缩略图，再返回原图，如果info[PHImageResultIsDegradedKey] 为 YES，则表明当前返回的是缩略图，否则是原图*/
- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion {
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            BOOL downloadFinished = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinished && result) {
                
                result = [self fixPhotoOrientation:result];
                BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (completion) completion(result, info, isDegraded);
            }
        }];
    }
    else if ([asset isKindOfClass:[ALAsset class]]) {
        
        ALAsset *alAsset = (ALAsset *)asset;
        ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            CGImageRef originalImageRef = [assetRep fullResolutionImage];
            UIImage *originalImage = [UIImage imageWithCGImage:originalImageRef scale:1.0 orientation:UIImageOrientationUp];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion (originalImage, nil, NO);
            });
        });
    }
}

/** * @brief Get Original Photo / 获取原图data */
- (void)getOriginalPhotoDataWithAsset:(id)asset completion:(void (^)(NSData *data, NSDictionary *info, BOOL isDegraded))completion {
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            BOOL downloadFinished = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinished && imageData) {
                BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (completion) completion(imageData, info, isDegraded);
            }
        }];
    }
    else if ([asset isKindOfClass:[ALAsset class]]) {
        
        ALAsset *alAsset = (ALAsset *)asset;
        ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
        Byte *imageBuffer = (Byte *)malloc(assetRep.size);
        NSUInteger bufferSize = [assetRep getBytes:imageBuffer fromOffset:0.0 length:assetRep.size error:nil];
        NSData *imageData = [NSData dataWithBytesNoCopy:imageBuffer length:bufferSize freeWhenDone:YES];
        if (completion) completion(imageData, nil, NO);
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            CGImageRef originalImageRef = [assetRep fullScreenImage];
//            UIImage *originalImage = [UIImage imageWithCGImage:originalImageRef scale:1.0 orientation:UIImageOrientationUp];
//            NSData *data = UIImageJPEGRepresentation(originalImage, 0.9);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (completion) completion(data, nil, NO);
//            });
//        });
    }
}

#pragma mark - ---- Save Photo method ----
/** * @brief Save Photo / 保存图片 */
- (void)savePhotoWithImage:(UIImage *)image completion:(void (^)(NSError *))completion {
    
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    if (iOS9Later) {
        // ----- 这里有坑... iOS8系统下这个方法保存图片会失败，因为PHAssetResourceType是iOS9之后的...
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
            options.shouldMoveFile = YES;
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (success && completion) {
                    completion(nil);
                } else if (error) {
                    NSLog(@"保存照片出错：%@", error.localizedDescription);
                    if (completion) completion(error);
                }
            });
        }];
    } else {
        [self.assetLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"保存照片出错：%@", error.localizedDescription);
                if (completion) completion(error);
            } else {
                // ----- 多给系统0.5秒时间，让系统去更新相册数据
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (completion) completion(nil);
                });
            }
        }];
    }
}

#pragma mark - ---- Get Video method ----
/** * @brief Get Video / 获得视频 */
- (void)getVideoWithAsset:(id)asset completion:(void (^)(AVPlayerItem * _Nullable, NSDictionary * _Nullable))completion {
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
            
            if (completion) completion(playerItem, info);
        }];
    } else {
        ALAsset *alAsset = (ALAsset *)asset;
        ALAssetRepresentation *defaultRepresentation = [alAsset defaultRepresentation];
        NSString *uti = [defaultRepresentation UTI];
        NSURL *videoURL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:videoURL];
        
        if (completion) completion(playerItem, nil);
    }
}

#pragma mark - ---- Export method ----
/** * @brief Export Video / 导出视频 */
- (void)exportVideoOutPutPathWithAsset:(id)asset completion:(void (^)(NSString *outputPath))completion{
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable avasset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *videoAsset = (AVURLAsset *)avasset;
            [self startExportVideoWithVideoAsset:videoAsset completion:completion];
        }];
    }
}

- (void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset completion:(void (^)(NSString *outputPhat))completion {
    
    // ----- Find compatible presets by video asset. / 根据视频资源查找兼容预设
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    
    // ----- Begin to compress video / 开始压缩视频
    // ----- Now we just compress to low resolution if it supports / 压缩到支持的最低分辨率
    // ----- If you need to upload to the server, but server does't support ti upload by streaming(流式传输),
    // ----- You can compress the resolution to lower. Or you can support more higher resolution.
    if ([presets containsObject:AVAssetExportPreset640x480]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPreset640x480];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSString *outputPath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        NSLog(@"video outputPath = %@", outputPath);
        session.outputURL = [NSURL fileURLWithPath:outputPath];
        
        // ----- Optimize for network use. / 网络优化
        session.shouldOptimizeForNetworkUse = true;
        
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            NSLog(@"No supported file types 视频类型暂不支持导出");
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"]]) {
            // ----- 如果不存在tmp文件夹，则创建一个
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        // ----- 修正视频转向
        session.videoComposition = [self fixedCompositionWithAsset:videoAsset];
        
        // ----- Begin to export video to the output path asynchronously. / 异步导出视频到指定路径
        [session exportAsynchronouslyWithCompletionHandler:^{
            switch (session.status) {
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"AVAssetExportSessionStatusUnknown");    break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"AVAssetExportSessionStatusWaiting");    break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting");  break;
                case AVAssetExportSessionStatusCompleted: {
                    
                    NSLog(@"AVAssetExportSessionStatusCompleted");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) completion(outputPath);
                    });
                }
                    break;
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed");     break;
                default:    break;
            }
        }];
    }
}

/** * @brief Get Photos Bytes 获得一组照片的大小 */
- (void)getPhotosBytesWithArray:(NSArray <ZEROAssetModel *>*)photos completion:(void (^)(NSString *totalBytes))completion {
    
    __block NSInteger dataLength = 0;
    __block NSInteger assetCount = 0;
    [photos enumerateObjectsUsingBlock:^(ZEROAssetModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([model.asset isKindOfClass:[PHAsset class]]) {
            
            [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                if (model.type != ZEROAssetModelMediaTypeVideo) {
                    dataLength += imageData.length;
                }
                assetCount ++;
                if (assetCount >= photos.count) {
                    
                    NSString *bytes = [self getBytesFromDataLength:dataLength];
                    if (completion) completion(bytes);
                }
            }];
        }
        else if ([model.asset isKindOfClass:[ALAsset class]]) {
            
            ALAssetRepresentation *representation = [model.asset defaultRepresentation];
            if (model.type != ZEROAssetModelMediaTypeVideo) {
                dataLength += (NSInteger)representation.size;
            }
            if (idx >= photos.count - 1) {
                
                NSString *bytes = [self getBytesFromDataLength:dataLength];
                if (completion) completion(bytes);
            }
        }
    }];
}

/** Judge is a assets array contain the asset / 判断一个assets数组是否包含该asset */
- (BOOL)isAssetsArray:(NSArray *)assets containAsset:(id)asset {
    
    if (iOS8Later) {
        
        return [assets containsObject:asset];
    } else {
        
        NSMutableArray *selectedAssetUrls = [NSMutableArray array];
        [assets enumerateObjectsUsingBlock:^(ALAsset *_Nonnull asset_item, NSUInteger idx, BOOL * _Nonnull stop) {
            [selectedAssetUrls addObject:[asset_item valueForProperty:ALAssetPropertyURLs]];
        }];
        return [selectedAssetUrls containsObject:[asset valueForProperty:ALAssetPropertyURLs]];
    }
}

/** * @brief judge if “Camera Roll” 判断是否是相机胶卷
 @param albumName 相册名字 */
- (BOOL)isCameraRollAlbum:(NSString *)albumName {
    
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length <= 1) {
        versionStr = [versionStr stringByAppendingString:@"00"];
    }
    else if (versionStr.length <= 2){
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    CGFloat version = [versionStr floatValue];
    
    if (version >= 800 && version <= 802) {
        // ----- 目前已知8.0.0 - 8.0.2系统，拍照后的图片会保存在最近添加中。
        return [albumName isEqualToString:@"最近添加"] || [albumName isEqualToString:@"Recently Added"];
    }else{
        return [albumName isEqualToString:@"相机胶卷"] ||[albumName isEqualToString:@"Camera Roll"] || [albumName isEqualToString:@"所有照片"] ||[albumName isEqualToString:@"All Photos"];
    }
}


/** * @brief Get unique string / 获取唯一标识 */
- (NSString *)getAssetIdentifier:(id)asset {
    
    if (iOS8Later) {
        
        PHAsset *phAsset = (PHAsset *)asset;
        return phAsset.localIdentifier;
    } else {
        
        ALAsset *alAsset = (ALAsset *)asset;
        NSURL *assetUrl = [alAsset valueForProperty:ALAssetPropertyAssetURL];
        return assetUrl.absoluteString;
    }
}

/** * @brief 检查照片大小是否满足要求 */
- (BOOL)isPhotoSelectAbleWithAsset:(id)asset{
    
    CGSize photoSize = [self photoSizeWithAsset:asset];
    if (self.minPhotoWidthSelectAble > photoSize.width || self.minPhotoHeightSelectAble > photoSize.height) {
        return NO;
    }
    return YES;
}

/** * @brief 根据照片asset资源，获取照片尺寸大小 */
- (CGSize)photoSizeWithAsset:(id)asset{
    
    if (iOS8Later) {
        PHAsset *phAsset = (PHAsset *)asset;
        return CGSizeMake(phAsset.pixelWidth, phAsset.pixelHeight);
    }
    else {

        ALAsset *alAsset = (ALAsset *)asset;
        return alAsset.defaultRepresentation.dimensions;
    }
    return CGSizeZero;
}

/** * @brief 修正图片转向 */
- (UIImage *)fixPhotoOrientation:(UIImage *)aImage {
    
    if (!self.shouldFixOrientation) return aImage;
    
    if (aImage.imageOrientation == UIImageOrientationUp) {
        // ----- No-op if the orientation is already correct / 如果方向已经正确，则为无操作
        return aImage;
    }
    
    // ----- We need to calculate the proper transformation to make the image upright. / 我们需要计算适当的变换，使图像直立。
    // ----- We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored. / 我们在2个步骤：旋转如果左/右/下，然后翻转如果镜像。
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, - M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, - 1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, - 1, 1);
            break;
        default:
            break;
    }
    
    // ----- Now we draw the underlying CGImage into a new context, applying the transform / 现在我们将底层的CGImage绘制到一个新的上下文中，应用变换
    // ----- calculated above. / 计算
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // ----- Grr... / 格式... ???
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
    }
    
    // ----- And now we just create a new UIImage from the drawing context / 现在我们只是从绘图上下文创建一个新的UIImage
    CGImageRef cgImg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgImg];
    CGContextRelease(ctx);
    CGImageRelease(cgImg);
    
    return img;
}

#pragma mark - ---- Private Method ----

- (ZEROAssetModel *)assetModelWithAsset:(id)asset allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage {
    
    if (!allowPickingVideo && !allowPickingImage) return nil;
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        return [self phAssetModelWithAsset:asset allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage];
    } else {
        
        return [self alAssetModelWithAsset:asset allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage];
    }
}

- (ZEROAssetModel *)phAssetModelWithAsset:(PHAsset *)phAsset allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage {
    
    ZEROAssetModelMediaType type = ZEROAssetModelMediaTypePhoto;
    
    if (phAsset.mediaType == PHAssetMediaTypeVideo) {
        type = ZEROAssetModelMediaTypeVideo;
    } else if (phAsset.mediaType == PHAssetMediaTypeAudio) {
        type = ZEROAssetModelMediaTypeAudio;
    } else if (phAsset.mediaType == PHAssetMediaTypeImage) {
        if (iOS9_1Later && phAsset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
            // ----- type = TZAssetModelMediaTypeLivePhoto;
        }
        if ([[phAsset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            type = ZEROAssetModelMediaTypePhotoGif;
        }
    }
    if (!allowPickingVideo && type == ZEROAssetModelMediaTypeVideo) return nil;
    if (!allowPickingImage && type == ZEROAssetModelMediaTypePhoto) return nil;
    
    if (self.hideWhenCanNotSelect) {
        // ----- 过滤掉尺寸不满足要去的图片
        if (![self isPhotoSelectAbleWithAsset:phAsset]) return nil;
    }
    
    NSString *timeLength = type == ZEROAssetModelMediaTypeVideo ? [NSString stringWithFormat:@"%0.0f",phAsset.duration] : @"";
    timeLength = [self getNewTimeFromDurationSecond:timeLength.integerValue];
    
    ZEROAssetModel *model = [ZEROAssetModel assetModelWithAsset:phAsset type:type timeLength:timeLength];

    return model;
}

- (ZEROAssetModel *)alAssetModelWithAsset:(ALAsset *)alAsset allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage {
    
    ZEROAssetModel *model = [[ZEROAssetModel alloc] init];
    ZEROAssetModelMediaType type = ZEROAssetModelMediaTypePhoto;
    
    if ([[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo] && allowPickingVideo) {
        type = ZEROAssetModelMediaTypeVideo;
        NSTimeInterval duration = [[alAsset valueForProperty:ALAssetPropertyDuration] integerValue];
        NSString *timeLength = [NSString stringWithFormat:@"%0.0f", duration];
        timeLength = [self getNewTimeFromDurationSecond:timeLength.integerValue];
        model = [ZEROAssetModel assetModelWithAsset:alAsset type:type timeLength:timeLength];
    }
    else if ([[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto] && allowPickingImage) {
        if (self.hideWhenCanNotSelect) {
            // ----- 过滤掉尺寸不满足条件的图片
            if (![self isPhotoSelectAbleWithAsset:alAsset]) return nil;
        }
        model = [ZEROAssetModel assetModelWithAsset:alAsset type:type];
    }
    
    return model;
}

/** * @brief 计算video显示时间 */
- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    
    return [NSString stringWithFormat:@"%zi:%02zi", duration / 60 , duration % 60];
}

/** * @brief 根据data长度计算所占空间的大小 */
- (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM", dataLength / 1024 / 1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK", dataLength / 1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdb", dataLength];
    }
    return bytes;
}

/** * @brief 修改图片大小尺寸 */
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    
    if (image.size.width > size.width) {
        
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        
        return image;
    }
}

/** * @brief 获取优化后的视频转向信息 */
- (AVMutableVideoComposition *)fixedCompositionWithAsset:(AVAsset *)videoAsset {
    
    AVMutableVideoComposition *videoComPosition = [AVMutableVideoComposition videoComposition];
    
    // ----- 视频转向(角度degrees)
    int degrees = [self degreesFromVideoFileWithAsset:videoAsset];
    if (degrees != 0) {
        
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        videoComPosition.frameDuration = CMTimeMake(1, 30);
        
        NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        if (degrees == 90) {
            // ----- 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter, M_PI_2);
            videoComPosition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
        } else if (degrees == 180) {
            // ----- 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter, M_PI);
            videoComPosition.renderSize = CGSizeMake(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
        } else if (degrees == 270) {
            // ----- 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter, M_PI_2 * 3.0);
            videoComPosition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
        }
        
        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        
        roateInstruction.layerInstructions = @[roateLayerInstruction];
        // ----- 加入视频方向信息
        videoComPosition.instructions = @[roateInstruction];
    }
    return videoComPosition;
}

/** * @brief 获取视频角度 */
- (int)degreesFromVideoFileWithAsset:(AVAsset *)asset {
    
    int degrees = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if (tracks.count > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if (t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) {
            // ----- Portrait
            degrees = 90;
        } else if (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0) {
            // ----- PortraitUpsideDown
            degrees = 270;
        } else if (t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0) {
            // ----- LandscapeRight
            degrees = 0;
        } else if (t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0) {
            // ----- LandscapeLeft
            degrees = 180;
        }
    }
    
    return degrees;
}

#pragma clang diagnostic pop

@end
