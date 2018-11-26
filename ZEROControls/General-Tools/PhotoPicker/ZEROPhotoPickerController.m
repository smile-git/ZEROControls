//
//  ZEROPhotoPickerController.m
//  PhotoPicker
//
//  Created by ZWX on 2016/12/29.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROPhotoPickerController.h"
#import "ZEROImagePickerController.h"
#import "ZEROPhotoPreviewController.h"
#import "ZEROVideoPlayerController.h"
#import "ZEROGifPhotoPreviewController.h"
#import "ZEROPhotoManager.h"
#import "ZEROAssetModel.h"
#import "ZEROAssetCell.h"
#import "NSBundle+ZEROImagePicker.h"
#import "UIView+OscillatoryAnimation.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface ZEROPhotoPickerController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate> {
    
    // ----- 下方工具条所需控件属性
    UIButton    *_previewButton;
    UIButton    *_doneButton;
    UIImageView *_numberImageView;
    UILabel     *_numberLabel;
    UIButton    *_originalPhotoButton;
    UILabel     *_originalPhotoLabel;
    
    
    BOOL _shouldScrollToBottom;
    BOOL _showTakePhotoBtn;
}
@property (nonatomic, assign) BOOL   isSelectOriginalPhoto;
@property (nonatomic, assign) CGRect previousPreheatRect;
@property (nonatomic, strong) NSMutableArray   *assetModels;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger columnNumber;

@property (nonatomic, strong) UIImagePickerController *imagePickerVC;
@end

static CGSize AssetGridThumbnailSize;

@implementation ZEROPhotoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];

    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    _isSelectOriginalPhoto = zImagePickerVC.isSelectOriginalPhoto;
    _shouldScrollToBottom  = YES;
    self.columnNumber = [ZEROPhotoManager shareManager].columnNumber;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _albumModel.name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:zImagePickerVC.cancelBtnTitleStr style:UIBarButtonItemStylePlain target:zImagePickerVC action:@selector(cancelButtonClick)];
    _showTakePhotoBtn = zImagePickerVC.allowTakePicture && [[ZEROPhotoManager shareManager] isCameraRollAlbum:_albumModel.name];
    
    if (_isFirstAppear) {
        
        [[ZEROPhotoManager shareManager] getCameraRollAlbumVideo:zImagePickerVC.allowPickingVideo allowPickingImage:zImagePickerVC.allowPickingImage completion:^(ZEROAlbumModel *model) {
            
            self->_albumModel  = model;
            self->_assetModels = [NSMutableArray arrayWithArray:model.models];
            [self initSubviews];
        }];
    } else {
        
        _assetModels = [NSMutableArray arrayWithArray:_albumModel.models];
        [self initSubviews];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (_shouldScrollToBottom) {
        
        [self scrollCollectionViewToButton];
    }
    
    // -----  Determine the size of the thumbnails to request from the PHCachingImageManager
    CGFloat scale = 2.0;
    if ([UIScreen mainScreen].bounds.size.width > 600) {
        scale = 1.0;
    }
    CGSize cellSize = ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    zImagePickerVC.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    if (self.backButtonClickHandle) {
        
        self.backButtonClickHandle(_albumModel);
    }
}

- (void)dealloc {
    
    
}
#pragma mark - ---- init & configer subview Method ----
- (void)initSubviews {
    
    [self checkSelectedModels];
    [self configerCollectionView];
    [self configerBottomToolBar];
}

- (void)checkSelectedModels {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    NSMutableArray *selectedAssets = [NSMutableArray array];
    [zImagePickerVC.selectedModels enumerateObjectsUsingBlock:^(ZEROAssetModel * _Nonnull assetModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [selectedAssets addObject:assetModel.asset];
    }];
    
    [_assetModels enumerateObjectsUsingBlock:^(ZEROAssetModel *_Nonnull assetModel, NSUInteger idx, BOOL * _Nonnull stop) {
        assetModel.isSelected = NO;
        
        if ([[ZEROPhotoManager shareManager] isAssetsArray:selectedAssets containAsset:assetModel.asset]) {
            assetModel.isSelected = YES;
        }
    }];
}

- (void)configerCollectionView {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin  = 3;
    CGFloat itemWH  = (self.view.width - (_columnNumber + 1) * margin) / _columnNumber;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing      = margin;
    
    CGFloat top = 44;
    if (iOS7Later) top += 20;
    CGFloat collectionViewHeight = zImagePickerVC.showSelectBtn ? (self.view.height - top - 50) : (self.view.height - top);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, top, self.view.width, collectionViewHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    [_collectionView registerClass:[ZEROAssetCell class] forCellWithReuseIdentifier:@"ZEROAssetCell"];
    [_collectionView registerClass:[ZEROAssetCameraCell class] forCellWithReuseIdentifier:@"ZEROAssetCameraCell"];
    [self.view addSubview:_collectionView];
}

- (void)configerBottomToolBar {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    if (!zImagePickerVC.showSelectBtn) return;

    UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
    CGFloat rgb = 253.0 / 255.0;
    bottomToolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1];
    
    CGFloat previewWidth = 0.0;
    if (zImagePickerVC.allowPreviewImage) {
        
        previewWidth = [zImagePickerVC.previewBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil].size.width + 2;
    }
    
    _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _previewButton.frame = CGRectMake(10, 3, previewWidth, 44);
    [_previewButton addTarget:self action:@selector(previewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_previewButton setTitle:zImagePickerVC.previewBtnTitleStr forState:UIControlStateNormal];
    [_previewButton setTitle:zImagePickerVC.previewBtnTitleStr forState:UIControlStateDisabled];
    [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _previewButton.enabled = zImagePickerVC.selectedModels.count;
    
    
    if (zImagePickerVC.allowPickingOriginalPhoto) {
        
        CGFloat fullImageWidth = [zImagePickerVC.fullImageBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.width;
        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _originalPhotoButton.frame           = CGRectMake(_previewButton.right, 0, fullImageWidth + 56, 50);
        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _originalPhotoButton.selected        = _isSelectOriginalPhoto;
        _originalPhotoButton.enabled         = zImagePickerVC.selectedModels.count > 0;

        [_originalPhotoButton setTitle:zImagePickerVC.fullImageBtnTitleStr forState:UIControlStateNormal];
        [_originalPhotoButton setTitle:zImagePickerVC.fullImageBtnTitleStr forState:UIControlStateSelected];
        [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_originalPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_originalPhotoButton setImage:[NSBundle zero_imageFromPickerBundle:zImagePickerVC.photoOriginDefImageName] forState:UIControlStateNormal];
        [_originalPhotoButton setImage:[NSBundle zero_imageFromPickerBundle:zImagePickerVC.photoOriginSelImageName] forState:UIControlStateSelected];
        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _originalPhotoLabel = [[UILabel alloc] init];
        _originalPhotoLabel.frame         = CGRectMake(fullImageWidth + 46, 0, 80, 50);
        _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
        _originalPhotoLabel.font          = [UIFont systemFontOfSize:16];
        _originalPhotoLabel.textColor     = [UIColor blackColor];
        
        if (_isSelectOriginalPhoto) {
            
            [self getSelectedPhotoBytes];
        }
    }
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(self.view.width - 44 - 12, 3, 44, 44);
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton setTitle:zImagePickerVC.doneBtnTitleStr forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_doneButton setTitleColor:zImagePickerVC.okBtnNormalTitleColor forState:UIControlStateNormal];
    [_doneButton setTitleColor:zImagePickerVC.okBtnDisableTitleColor forState:UIControlStateDisabled];
    _doneButton.enabled = zImagePickerVC.selectedModels.count > 0;
    
    _numberImageView = [[UIImageView alloc] initWithImage:[NSBundle zero_imageFromPickerBundle:zImagePickerVC.photoNumberIconImageName]];
    _numberImageView.frame = CGRectMake(self.view.width - 56 - 28, 10, 30, 30);
    _numberImageView.hidden = zImagePickerVC.selectedModels.count <= 0;
    _numberImageView.backgroundColor = [UIColor clearColor];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.frame           = _numberImageView.frame;
    _numberLabel.font            = [UIFont systemFontOfSize:15];
    _numberLabel.textColor       = [UIColor whiteColor];
    _numberLabel.textAlignment   = NSTextAlignmentCenter;
    _numberLabel.text            = [NSString stringWithFormat:@"%zi", zImagePickerVC.selectedModels.count];
    _numberLabel.backgroundColor = [UIColor clearColor];
    
    UIView *divide = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    divide.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    divide.frame = CGRectMake(0, 0, self.view.width, 1);

    [_originalPhotoButton addSubview:_originalPhotoLabel];
    [bottomToolBar addSubview:divide];
    [bottomToolBar addSubview:_previewButton];
    [bottomToolBar addSubview:_originalPhotoButton];
    [bottomToolBar addSubview:_doneButton];
    [bottomToolBar addSubview:_numberImageView];
    [bottomToolBar addSubview:_numberLabel];
    [self.view addSubview:bottomToolBar];
    
}

#pragma mark - ---- Get Method ----
- (UIImagePickerController *)imagePickerVC {
    
    if (!_imagePickerVC) {
        
        _imagePickerVC = [[UIImagePickerController alloc] init];
        _imagePickerVC.delegate = self;
        
        // ----- set appearance / 改变相册选择页的导航栏外观
        _imagePickerVC.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVC.navigationBar.tintColor    = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *zeroBarItem;
        UIBarButtonItem *barItem;
        if (iOS9Later) {
            zeroBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[ZEROImagePickerController class]]];
            barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            zeroBarItem = [UIBarButtonItem appearanceWhenContainedIn:[ZEROImagePickerController class], nil];
            barItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [zeroBarItem titleTextAttributesForState:UIControlStateNormal];
        [barItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    
    return _imagePickerVC;
}

#pragma mark - ---- Event Method ----
#pragma mark button click 
- (void)previewButtonClick {
    ZEROPhotoPreviewController *photoPreviewVC = [[ZEROPhotoPreviewController alloc] init];
    [self pushPhotoPreviewViewController:photoPreviewVC];
}

- (void)originalPhotoButtonClick {
    
    _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
    _isSelectOriginalPhoto        = _originalPhotoButton.isSelected;
    _originalPhotoLabel.hidden    = !_originalPhotoButton.isSelected;
    
    if (_isSelectOriginalPhoto) {
        
        [self getSelectedPhotoBytes];
    }
}

- (void)doneButtonClick {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    
    // ----- 判断是否满足最小必选个数限制
    if (zImagePickerVC.minImagesCount && zImagePickerVC.selectedModels.count < zImagePickerVC.minImagesCount) {
        
        NSString *title = [NSString stringWithFormat:[NSBundle zero_loaclizedStringForKey:@"Select a minimum of %zd photos"], zImagePickerVC.minImagesCount];
        [zImagePickerVC showAlertWithTitle:title];
        return;
    }
    
    [zImagePickerVC showProgressHUD];
    NSMutableArray *photos  = [NSMutableArray array];
    NSMutableArray *assets  = [NSMutableArray array];
    NSMutableArray *infoArr = [NSMutableArray array];
    
    if (zImagePickerVC.selectedModels.count <= 0) {
        
        [self didGetAllPhotos:photos assets:assets infoArr:infoArr];
        return;
    }

    for (NSInteger idx = 0; idx < zImagePickerVC.selectedModels.count; idx ++) {
        
        [photos addObject:@1];
        [assets addObject:@1];
        [infoArr addObject:@1];
    }
    
    __block BOOL haveNotShowAlert = YES;
    [ZEROPhotoManager shareManager].shouldFixOrientation = YES;
    [zImagePickerVC.selectedModels enumerateObjectsUsingBlock:^(ZEROAssetModel * _Nonnull assetModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [[ZEROPhotoManager shareManager] getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (isDegraded) {
                return;
                *stop = YES;
                return;
            }
            if (photo) {
                photo = [self scaleImage:photo toSize:CGSizeMake(zImagePickerVC.photoWidth, (zImagePickerVC.photoWidth * photo.size.height / photo.size.width))];
                [photos replaceObjectAtIndex:idx withObject:photo];
            }
            if (info) {
                [infoArr replaceObjectAtIndex:idx withObject:info];
            }
            [assets replaceObjectAtIndex:idx withObject:assetModel.asset];
            for (id item in photos) {
                if ([item isKindOfClass:[NSNumber class]]) {
                    *stop = YES;
                    return;
                }
            }
            if (haveNotShowAlert) {
                [self didGetAllPhotos:photos assets:assets infoArr:infoArr];
            }
        }progressHandler:^(double progress, NSError *error, NSDictionary *info, BOOL *stop) {
            // ----- 如果图片正在从iCloud中同步，提醒用户
            if (progress < 1 && haveNotShowAlert) {
                [zImagePickerVC hideProgressHUD];
                [zImagePickerVC showAlertWithTitle:[NSBundle zero_loaclizedStringForKey:@"Synchronizing photos from iCloud"]];
                haveNotShowAlert = NO;
                *stop = YES;
                return;
            }
        } networkAccessAllowed:YES];
    }];
}

/** * @brief 点击done之后，将所选择的照片通过代理或block传值回去 */
- (void)didGetAllPhotos:(NSArray *)photos assets:(NSArray *)assets infoArr:(NSArray *)infoArr {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    [zImagePickerVC hideProgressHUD];
    
    if (zImagePickerVC.autoDismiss) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
            [self callDelegateMethodWithPhotos:photos assets:assets infoArr:infoArr];
        }];
    } else {
        
        [self callDelegateMethodWithPhotos:photos assets:assets infoArr:infoArr];
    }
}

- (void)callDelegateMethodWithPhotos:(NSArray *)photos assets:(NSArray *)assets infoArr:(NSArray *)infoArr {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    
    if ([zImagePickerVC.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
        [zImagePickerVC.pickerDelegate imagePickerController:zImagePickerVC didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto];
    }
    if ([zImagePickerVC.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:infos:)]) {
        [zImagePickerVC.pickerDelegate imagePickerController:zImagePickerVC didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto infos:infoArr];
    }
    if (zImagePickerVC.didFinishPickingPhotosHandle) {
        zImagePickerVC.didFinishPickingPhotosHandle(photos, assets, _isSelectOriginalPhoto);
    }
    if (zImagePickerVC.didFinishPickingPhotosWithInfosHandle) {
        zImagePickerVC.didFinishPickingPhotosWithInfosHandle(photos, assets, _isSelectOriginalPhoto, infoArr);
    }
}


#pragma mark - ---- Delegate Method ----
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_showTakePhotoBtn) {
        
        ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
        if (zImagePickerVC.allowPickingImage && zImagePickerVC.allowTakePicture) {
            return _assetModels.count + 1;
        }
    }
    return _assetModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    
    // ----- 去拍照的cell
    if (((zImagePickerVC.sortAscendingByModificationDate  && indexPath.item >= _assetModels.count) || (!zImagePickerVC.sortAscendingByModificationDate && indexPath.item == 0)) && _showTakePhotoBtn) {
        
        ZEROAssetCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZEROAssetCameraCell" forIndexPath:indexPath];
        cell.imageView.image = [NSBundle zero_imageFromPickerBundle:zImagePickerVC.takePictureImageName];
        return cell;
    }
    
    // ----- 展示照片或视频的cell
    ZEROAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZEROAssetCell" forIndexPath:indexPath];
    cell.photoDefImageName = zImagePickerVC.photoDefImageName;
    cell.photoSelImageName = zImagePickerVC.photoSelImageName;
    
    ZEROAssetModel *assetModel;
    if (zImagePickerVC.sortAscendingByModificationDate || !_showTakePhotoBtn) {
        assetModel = _assetModels[indexPath.item];
    } else {
        assetModel = _assetModels[indexPath.item - 1];
    }
    
    cell.allowPickingGif = zImagePickerVC.allowPickingGif;
    cell.assetModel      = assetModel;
    cell.showSelectBtn   = zImagePickerVC.showSelectBtn;
    if (!zImagePickerVC.allowPreviewImage) {
        cell.selectPhotoButton.frame = cell.bounds;
    }
    
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    __weak typeof(_numberImageView.layer) weakLayou = _numberImageView.layer;
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
        
        // ----- 1.select: check if over the maxImagesCount / 选择照片，检查是否超过了最大个数限制
        if (isSelected) {
            
            if (zImagePickerVC.selectedModels.count < zImagePickerVC.maxImagesCount) {
                [zImagePickerVC.selectedModels addObject:assetModel];
                [zImagePickerVC.selectedAssets addObject:assetModel.asset];
                [weakSelf refreshBottomToolBarStatus];
            } else {
                
                NSString *title = [NSString stringWithFormat:[NSBundle zero_loaclizedStringForKey:@"Select a maximum of %zd photos"], zImagePickerVC.maxImagesCount];
                [zImagePickerVC showAlertWithTitle:title];
                weakCell.selectPhotoButton.selected = NO;
                assetModel.isSelected = NO;
            }
        } else {
            // ----- 2. cancel select / 取消选择
            NSArray *selectedModels = [NSArray arrayWithArray:zImagePickerVC.selectedModels];
            [selectedModels enumerateObjectsUsingBlock:^(ZEROAssetModel *_Nonnull model_item, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[[ZEROPhotoManager shareManager] getAssetIdentifier:assetModel.asset] isEqualToString:[[ZEROPhotoManager shareManager] getAssetIdentifier:model_item.asset]]) {
                    [zImagePickerVC.selectedModels removeObject:model_item];
                    [zImagePickerVC.selectedAssets removeObject:model_item.asset];
                    *stop = YES;
                }
            }];
            [weakSelf refreshBottomToolBarStatus];
        }
        
        [UIView showOscillatoryAnimationWithLayer:weakLayou type:ZEROOscillatoryAnimationTypeSmaller];
    };
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    if (((zImagePickerVC.sortAscendingByModificationDate && indexPath.row >= _assetModels.count) || (!zImagePickerVC.sortAscendingByModificationDate && indexPath.row == 0)) && _showTakePhotoBtn) {
        
        [self takePhoto];
        return;
    }
    // ----- preview photo or video / 预览照片或视频
    NSInteger index = indexPath.row;
    if (!zImagePickerVC.sortAscendingByModificationDate && _showTakePhotoBtn) {
        index = indexPath.row - 1;
    }
    ZEROAssetModel *assetModel = _assetModels[index];
    if (assetModel.type == ZEROAssetModelMediaTypeVideo) {
        if (zImagePickerVC.selectedModels.count > 0) {
            [zImagePickerVC showAlertWithTitle:[NSBundle zero_loaclizedStringForKey:@"Can not choose both video and photo"]];
        } else {
            ZEROVideoPlayerController *videoPlayerVC = [[ZEROVideoPlayerController alloc] init];
            videoPlayerVC.assetModel = assetModel;
            [self.navigationController pushViewController:videoPlayerVC animated:YES];
        }
    } else if (assetModel.type == ZEROAssetModelMediaTypePhotoGif && zImagePickerVC.allowPickingGif) {
        if (zImagePickerVC.selectedModels.count > 0) {
            
            [zImagePickerVC showAlertWithTitle:[NSBundle zero_loaclizedStringForKey:@"Can not choose both photo and GIF"]];
        } else {
            ZEROGifPhotoPreviewController *gifPreviewVC = [[ZEROGifPhotoPreviewController alloc] init];
            gifPreviewVC.assetModel = assetModel;
            [self.navigationController pushViewController:gifPreviewVC animated:YES];
        }
    } else {
        ZEROPhotoPreviewController *photoPreviewVC = [[ZEROPhotoPreviewController alloc] init];
        photoPreviewVC.currentIndex = index;
        photoPreviewVC.assetModels  = _assetModels;
        [self pushPhotoPreviewViewController:photoPreviewVC];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        // ----- 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                NSString *message = [NSBundle zero_loaclizedStringForKey:@"Can not jump to the privacy settings page, please go to the settings page by self, thank you"];
                [[[UIAlertView alloc] initWithTitle:[NSBundle zero_loaclizedStringForKey:@"Sorry"] message:message delegate:nil cancelButtonTitle:[NSBundle zero_loaclizedStringForKey:@"OK"] otherButtonTitles: nil] show];
            }
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
        [zImagePickerVC showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (image) {
            [[ZEROPhotoManager shareManager] savePhotoWithImage:image completion:^(NSError *error) {
                if (!error) {
                    
                    [self reloadPhotoArray];
                }
            }];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Method

- (void)reloadPhotoArray {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    [[ZEROPhotoManager shareManager] getCameraRollAlbumVideo:zImagePickerVC.allowPickingImage allowPickingImage:zImagePickerVC.allowPickingVideo completion:^(ZEROAlbumModel *model) {
        
        self.albumModel = model;
        [[ZEROPhotoManager shareManager] getAssetsFromFetchResult:self.albumModel.result allowPickingVideo:zImagePickerVC.allowPickingImage allowPickingImage:zImagePickerVC.allowPickingVideo completion:^(NSArray<ZEROAssetModel *> *models) {
            
            [zImagePickerVC hideProgressHUD];
            
            ZEROAssetModel *assetModel;
            if (zImagePickerVC.sortAscendingByModificationDate) {
                assetModel = models.lastObject;
                [self.assetModels addObject:assetModel];
            } else {
                assetModel = models.firstObject;
                [self.assetModels insertObject:assetModel atIndex:0];
            }
            
            if (zImagePickerVC.maxImagesCount <= 1) {
                if (zImagePickerVC.allowCrop) {
                    ZEROPhotoPreviewController *photoPreviewVC = [[ZEROPhotoPreviewController alloc] init];
                    photoPreviewVC.currentIndex = self.assetModels.count - 1;
                    photoPreviewVC.assetModels = self.assetModels;
                    [self pushPhotoPreviewViewController:photoPreviewVC];
                } else {
                    [zImagePickerVC.selectedModels addObject:assetModel];
                    [self doneButtonClick];
                }
                return;
            }
            if (zImagePickerVC.selectedModels.count < zImagePickerVC.maxImagesCount) {
                assetModel.isSelected = YES;
                [zImagePickerVC.selectedModels addObject:assetModel];
                [self refreshBottomToolBarStatus];
            }
            [self.collectionView reloadData];
            
            self->_shouldScrollToBottom = YES;
            [self scrollCollectionViewToButton];
        }];
    }];
}

/** * @brief 拍照 */
- (void)takePhoto {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // ----- 无权限，做一个友好的提示
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) {
            appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        }
        NSString *message = [NSString stringWithFormat:[NSBundle zero_loaclizedStringForKey:@"Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\""], appName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSBundle zero_loaclizedStringForKey:@"Can not use camera"] message:message delegate:self cancelButtonTitle:[NSBundle zero_loaclizedStringForKey:@"Cancel"] otherButtonTitles:[NSBundle zero_loaclizedStringForKey:@"Setting"], nil];
        [alert show];
    } else {
        // ----- 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVC.sourceType = sourceType;
            if (iOS8Later) {
                _imagePickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVC animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

/** * @brief 刷新下方工具条的各个控件 */
- (void)refreshBottomToolBarStatus {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    
    _previewButton.enabled = zImagePickerVC.selectedModels.count > 0;
    _doneButton.enabled    = zImagePickerVC.selectedModels.count > 0;
    
    _numberImageView.hidden = zImagePickerVC.selectedModels.count <= 0;
    _numberLabel.hidden     = zImagePickerVC.selectedModels.count <= 0;
    _numberLabel.text       = [NSString stringWithFormat:@"%zi", zImagePickerVC.selectedModels.count];
    
    _originalPhotoButton.enabled  = zImagePickerVC.selectedModels.count > 0;
    _originalPhotoButton.selected = (_isSelectOriginalPhoto && _originalPhotoButton.enabled);
    _originalPhotoLabel.hidden    = !_originalPhotoButton.isSelected;
    
    if (_isSelectOriginalPhoto) {
        
        [self getSelectedPhotoBytes];
    }
    
}

- (void)pushPhotoPreviewViewController:(ZEROPhotoPreviewController *)photoPreviewVC {
    __weak typeof(self)weakSelf = self;
    photoPreviewVC.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    [photoPreviewVC setBackButtonClickBlock:^(BOOL isSelectOriginalPhoto) {
        weakSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [weakSelf.collectionView reloadData];
        [weakSelf refreshBottomToolBarStatus];
    }];
    [photoPreviewVC setDoneButtonClickBlock:^(BOOL isSelectOriginalPhoto) {
        weakSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [weakSelf doneButtonClick];
    }];
    [photoPreviewVC setDoneButtonClickBlockCropMode:^(UIImage *cropedImage, id asset) {
        [weakSelf didGetAllPhotos:@[cropedImage] assets:@[asset] infoArr:nil];
    }];
    
    [self.navigationController pushViewController:photoPreviewVC animated:YES];
}

/** * @brief Scale Image / 缩放图片 */
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    
    if (image.size.width < size.width) {
        return image;
    }
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)scrollCollectionViewToButton {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    if (_shouldScrollToBottom && _assetModels.count > 0 && zImagePickerVC.sortAscendingByModificationDate) {
        
        NSInteger item = _assetModels.count - 1;
        if (_showTakePhotoBtn && zImagePickerVC.allowPickingImage && zImagePickerVC.allowTakePicture) {
            item += 1;
        }
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        _shouldScrollToBottom = NO;
    }
}

- (void)getSelectedPhotoBytes {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    
    [[ZEROPhotoManager shareManager] getPhotosBytesWithArray:zImagePickerVC.selectedModels completion:^(NSString *totalBytes) {
        
        self->_originalPhotoLabel.text = [NSString stringWithFormat:@"(%@)", totalBytes];
    }];
}

#pragma clang diagnostic pop

@end

