//
//  ZEROAssetModel.m
//  PhotoPicker
//
//  Created by ZWX on 2016/12/15.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAssetModel.h"
#import "ZEROPhotoManager.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ZEROAssetModel

+ (instancetype)assetModelWithAsset:(id)asset type:(ZEROAssetModelMediaType)type{
    
    ZEROAssetModel *model = [[ZEROAssetModel alloc] init];
    model.asset      = asset;
    model.type       = type;
    model.isSelected = NO;
    
    return model;
}

+ (instancetype)assetModelWithAsset:(id)asset type:(ZEROAssetModelMediaType)type timeLength:(NSString *)timeLength{
    
    ZEROAssetModel *model = [self assetModelWithAsset:asset type:type];
    model.timeLength = timeLength;
    
    return model;
}

@end


@implementation ZEROAlbumModel

+ (instancetype)albumModelWithResult:(id)result name:(NSString *)name {
    
    ZEROAlbumModel *model = [[ZEROAlbumModel alloc] init];
    model.result = result;
    model.name = name;
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        model.count = fetchResult.count;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        
        ALAssetsGroup *group = (ALAssetsGroup *)result;
        model.count = [group numberOfAssets];
#pragma clang diagnostic pop
    }
    return model;
}

#pragma mark - ---- set method ----
- (void)setResult:(id)result{
    
    _result = result;
    BOOL allowPickingImage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"zero_allowPickingImage"] isEqualToString:@"1"];
    BOOL allowPickingVideo = [[[NSUserDefaults standardUserDefaults] objectForKey:@"zero_allowPickingVideo"] isEqualToString:@"1"];
    
    [[ZEROPhotoManager shareManager] getAssetsFromFetchResult:result allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage completion:^(NSArray<ZEROAssetModel *> *models) {
        
        _models = models;
        if (_selectedModels) {
            
            [self checkSelectedModels];
        }
    }];
}

- (void)setSelectedModels:(NSArray *)selectedModels{
    
    _selectedModels = selectedModels;
    if (_models) {
        [self checkSelectedModels];
    }
}

#pragma mark - ---- Private method ----
/** * @brief check out selected photos 检查选择的照片 */
- (void)checkSelectedModels{
    
    self.selectedCount = 0;
    NSMutableArray *selectedAssets = [NSMutableArray array];
    
    [_selectedModels enumerateObjectsUsingBlock:^(ZEROAssetModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [selectedAssets addObject:model.asset];
    }];
    
    [_models enumerateObjectsUsingBlock:^(ZEROAssetModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([[ZEROPhotoManager shareManager] isAssetsArray:selectedAssets containAsset:model.asset]) {
            self.selectedCount ++;
        }
    }];
}
@end
