//
//  ZEROPhotoPreviewController.m
//  PhotoPicker
//
//  Created by ZWX on 2016/12/28.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROPhotoPreviewController.h"
#import "ZEROPhotoPreviewCell.h"
#import "ZEROAssetModel.h"
#import "UIView+Ext.h"
#import "UIView+OscillatoryAnimation.h"
#import "NSBundle+ZEROImagePicker.h"
#import "ZEROImagePickerController.h"
#import "ZEROPhotoManager.h"
#import "ZEROImageCropManager.h"

@interface ZEROPhotoPreviewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate> {
    
    NSArray *_photoTemps;
    NSArray *_assetTemps;
    
    UIView   *_navBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    
    UIView      *_toolBar;
    UIButton    *_doneButton;
    UIImageView *_numberImageView;
    UILabel     *_numberLabel;
    UIButton    *_originalPhotoButton;
    UILabel     *_originalByteLabel;
}
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isHideNavBar;
@property (nonatomic, strong) UIView *cropBgView;
@property (nonatomic, strong) UIView *cropView;

@property (nonatomic, assign) double progress;
@end

@implementation ZEROPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [ZEROPhotoManager shareManager].shouldFixOrientation = YES;
    __weak typeof(self)weakSelf = self;
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)weakSelf.navigationController;
    
    if (!self.assetModels.count) {
        
        self.assetModels = [NSMutableArray arrayWithArray:zImagePickerVC.selectedModels];
        _assetTemps = [NSMutableArray arrayWithArray:zImagePickerVC.selectedAssets];
        self.isSelectOriginalPhoto = zImagePickerVC.isSelectOriginalPhoto;
    }
    
    [self configerCollectionView];
    [self configerCropView];
    [self configerCustomNavBar];
    [self configerBottomToolBar];
    
    self.view.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (iOS7Later) {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
    if (_currentIndex) {
        [_collectionView setContentOffset:CGPointMake((self.view.width + 20) * _currentIndex, 0) animated:NO];
    }
    
    [self refreshNavBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (iOS7Later) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    [ZEROPhotoManager shareManager].shouldFixOrientation = NO;
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

#pragma mark - ---- Configer Method ----
- (void)configerCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.width + 20, self.view.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.width + 20, self.view.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource      = self;
    _collectionView.delegate        = self;
    _collectionView.pagingEnabled   = YES;
    _collectionView.scrollsToTop    = NO;
    _collectionView.contentOffset   = CGPointMake(0, 0);
    _collectionView.contentSize     = CGSizeMake(self.assetModels.count * (self.view.width + 20), 0);
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[ZEROPhotoPreviewCell class] forCellWithReuseIdentifier:@"ZEROPhotoPreviewCell"];
    
    [self.view addSubview:_collectionView];
}

- (void)configerCropView {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    if (!zImagePickerVC.showSelectBtn && zImagePickerVC.allowCrop) {
        
        _cropBgView = [[UIView alloc] init];
        _cropBgView.userInteractionEnabled = NO;
        _cropBgView.backgroundColor = [UIColor clearColor];
        _cropBgView.frame = self.view.bounds;
        
        [self.view addSubview:_cropBgView];
        
        [ZEROImageCropManager overlayClippingWithView:_cropBgView cropRect:zImagePickerVC.cropRect containerView:self.view needCircleCrop:zImagePickerVC.needCircleCrop];
        
        _cropView = [[UIView alloc] init];
        _cropView.userInteractionEnabled = NO;
        _cropView.backgroundColor = [UIColor clearColor];
        _cropView.frame = zImagePickerVC.cropRect;
        _cropView.layer.borderColor = [UIColor whiteColor].CGColor;
        _cropView.layer.borderWidth = 1.0;
        if (zImagePickerVC.needCircleCrop) {
            _cropView.layer.cornerRadius = zImagePickerVC.cropRect.size.width / 2;
            _cropView.clipsToBounds = YES;
        }
        [self.view addSubview:_cropView];
        
        if (zImagePickerVC.cropViewSettingHandle) {
            zImagePickerVC.cropViewSettingHandle(_cropView);
        }
    }
}

- (void)configerCustomNavBar {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    
    _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    _navBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0) blue:(34/255.0) alpha:0.7];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    [_backButton setImage:[NSBundle zero_imageFromPickerBundle:@"navi_back.png"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 54, 10, 42, 42)];
    [_selectButton setImage:[NSBundle zero_imageFromPickerBundle:zImagePickerVC.photoDefImageName] forState:UIControlStateNormal];
    [_selectButton setImage:[NSBundle zero_imageFromPickerBundle:zImagePickerVC.photoSelImageName] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.hidden = !zImagePickerVC.showSelectBtn;
    
    [_navBar addSubview:_selectButton];
    [_navBar addSubview:_backButton];
    [self.view addSubview:_navBar];
}

- (void)configerBottomToolBar {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;

    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 44, self.view.width, 44)];
    static CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    
    if (zImagePickerVC.allowPickingOriginalPhoto) {
        CGFloat fullImageWidth = [zImagePickerVC.fullImageBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.width;
        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _originalPhotoButton.frame = CGRectMake(0, 0, fullImageWidth + 56, 44);
        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _originalPhotoButton.backgroundColor = [UIColor clearColor];
        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];

        [_originalPhotoButton setTitle:zImagePickerVC.fullImageBtnTitleStr forState:UIControlStateNormal];
        [_originalPhotoButton setTitle:zImagePickerVC.fullImageBtnTitleStr forState:UIControlStateSelected];
        [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_originalPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_originalPhotoButton setImage:[NSBundle zero_imageFromPickerBundle:zImagePickerVC.photoPreviewOriginDefImageName] forState:UIControlStateNormal];
        [_originalPhotoButton setImage:[NSBundle zero_imageFromPickerBundle:zImagePickerVC.photoOriginSelImageName] forState:UIControlStateSelected];
        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _originalByteLabel = [[UILabel alloc] init];
        _originalByteLabel.frame           = CGRectMake(fullImageWidth + 42, 0, 80, 44);
        _originalByteLabel.textAlignment   = NSTextAlignmentLeft;
        _originalByteLabel.font            = [UIFont systemFontOfSize:13];
        _originalByteLabel.textColor       = [UIColor whiteColor];
        _originalByteLabel.backgroundColor = [UIColor clearColor];
        
        if (_isSelectOriginalPhoto) {
            
            [self showPhotoBytes];
        }
    }
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(self.view.width - 44 - 12, 0, 44, 44);
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton setTitle:zImagePickerVC.doneBtnTitleStr forState:UIControlStateNormal];
    [_doneButton setTitleColor:zImagePickerVC.okBtnNormalTitleColor forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _numberImageView = [[UIImageView alloc] initWithImage:[NSBundle zero_imageFromPickerBundle:zImagePickerVC.photoNumberIconImageName]];
    _numberImageView.backgroundColor = [UIColor clearColor];
    _numberImageView.frame  = CGRectMake(self.view.width - 56 - 28, 7, 30, 30);
    _numberImageView.hidden = zImagePickerVC.selectedModels.count <= 0;
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.frame     = _numberImageView.frame;
    _numberLabel.font      = [UIFont systemFontOfSize:15];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.text      = [NSString stringWithFormat:@"%zi", zImagePickerVC.selectedModels.count];
    _numberLabel.hidden    = zImagePickerVC.selectedModels.count <= 0;
    _numberLabel.textAlignment   = NSTextAlignmentCenter;
    _numberLabel.backgroundColor = [UIColor clearColor];
    
    [_originalPhotoButton addSubview:_originalByteLabel];
    [_toolBar addSubview:_doneButton];
    [_toolBar addSubview:_originalPhotoButton];
    [_toolBar addSubview:_numberImageView];
    [_toolBar addSubview:_numberLabel];
    
    [self.view addSubview:_toolBar];
}

#pragma mark - ---- Set Method ----
- (void)setPhotos:(NSMutableArray *)photos {
    
    _photos     = photos;
    _photoTemps = [NSArray arrayWithArray:photos];
}

#pragma mark - ---- Delegate Method ----
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth + ((self.view.width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.width + 20);
    
    if (currentIndex < _assetModels.count && _currentIndex != currentIndex) {
        
        _currentIndex = currentIndex;
        [self refreshNavBarAndBottomBarState];
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _assetModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZEROPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZEROPhotoPreviewCell" forIndexPath:indexPath];
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    
    cell.assetModel = _assetModels[indexPath.row];
    cell.cropRect   = zImagePickerVC.cropRect;
    cell.allowCrop  = zImagePickerVC.allowCrop;
    
    __weak typeof(self)weakSelf = self;
    if (!cell.singleTapGestureBlock) {
        
        __weak typeof(_navBar)weakNavBar   = _navBar;
        __weak typeof(_toolBar)weakToolBar = _toolBar;
        
        cell.singleTapGestureBlock = ^() {
            
            // ----- show or hide naviBar / 显示或隐藏导航栏
            weakSelf.isHideNavBar = !weakSelf.isHideNavBar;
            weakNavBar.hidden     = weakSelf.isHideNavBar;
            weakToolBar.hidden    = weakSelf.isHideNavBar;
        };
    }
    
    [cell setImageProgressUpdateBlock:^(double progress) {
        
        weakSelf.progress = progress;
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[ZEROPhotoPreviewCell class]]) {
        
        [(ZEROPhotoPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[ZEROPhotoPreviewCell class]]) {
        
        [(ZEROPhotoPreviewCell *)cell recoverSubviews];
    }

}

#pragma mark - Private Method
- (void)refreshNavBarAndBottomBarState {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    ZEROAssetModel *assetModel = _assetModels[_currentIndex];
    _selectButton.selected = assetModel.isSelected;
    _numberLabel.text = [NSString stringWithFormat:@"%zi", zImagePickerVC.selectedModels.count];
    _numberImageView.hidden = (zImagePickerVC.selectedModels.count <= 0 || _isHideNavBar || _isCropImage);
    _numberLabel.hidden = _numberImageView.hidden;
    
    _originalPhotoButton.selected = _isSelectOriginalPhoto;
    _originalByteLabel.hidden = !_originalPhotoButton.isSelected;
    
    // ----- 如果正在预览的是视频，隐藏原图按钮
    if (!_isHideNavBar) {
        
        if (assetModel.type == ZEROAssetModelMediaTypeVideo) {
            
            _originalPhotoButton.hidden = YES;
            _originalByteLabel.hidden = YES;
        } else {
            _originalPhotoButton.hidden = NO;
            if (_isSelectOriginalPhoto) {
                _originalByteLabel.hidden = NO;
            }
        }
    }
    _doneButton.hidden = NO;
    _selectButton.hidden = !zImagePickerVC.showSelectBtn;
    
    // ----- 让宽高小于 最小可选照片尺寸 的图片不能选中
    if (![[ZEROPhotoManager shareManager] isPhotoSelectAbleWithAsset:assetModel.asset]) {
        
        _numberLabel.hidden         = YES;
        _numberImageView.hidden     = YES;
        _selectButton.hidden        = YES;
        _originalByteLabel.hidden   = YES;
        _originalPhotoButton.hidden = YES;
        _doneButton.hidden          = YES;
    }
}

- (void)showPhotoBytes {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;

    [[ZEROPhotoManager shareManager] getPhotosBytesWithArray:zImagePickerVC.selectedModels completion:^(NSString *totalBytes) {
        _originalByteLabel.text = [NSString stringWithFormat:@"(%@)",totalBytes];
    }];
}


#pragma mark - ---- Event Method ----
#pragma mark button click
- (void)backButtonClick {
    
    if (self.navigationController.childViewControllers.count < 2) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock(_isSelectOriginalPhoto);
    }
}

- (void)selectButtonClick:(UIButton *)sender {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    ZEROAssetModel *assetModel = _assetModels[_currentIndex];
    if (!sender.isSelected) {
        
        if (zImagePickerVC.selectedModels.count >= zImagePickerVC.maxImagesCount) {
            // ----- 1.select: check if over the maxImagesCount / 选择照片，检查是否超过了最大个数限制
            NSString *title = [NSString stringWithFormat:[NSBundle zero_loaclizedStringForKey:@"Select a maximum of %zd photos"], zImagePickerVC.maxImagesCount];
            [zImagePickerVC showAlertWithTitle:title];
            return;
        } else {
            // ----- 2. if not over the maxImagesCount / 如果没有超过最大个数限制
            [zImagePickerVC.selectedModels addObject:assetModel];
            
            // ----- 不知道下面if有啥用。。。。。。。
            if (self.photos) {
                [zImagePickerVC.selectedAssets addObject:_assetTemps[_currentIndex]];
                [self.photos addObject:_photoTemps[_currentIndex]];
            }
            if (assetModel.type == ZEROAssetModelMediaTypeVideo) {
                [zImagePickerVC showAlertWithTitle:[NSBundle zero_loaclizedStringForKey:@"Select the video when in multi state, we will handle the video as a photo"]];
            }
        }
    } else {
        
        NSArray *selectedModels = [NSArray arrayWithArray:zImagePickerVC.selectedModels];
        [selectedModels enumerateObjectsUsingBlock:^(ZEROAssetModel *_Nonnull model_item, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[[ZEROPhotoManager shareManager] getAssetIdentifier:assetModel.asset] isEqualToString:[[ZEROPhotoManager shareManager] getAssetIdentifier:model_item.asset]]) {
                
                [zImagePickerVC.selectedModels removeObject:model_item];
                
                if (self.photos) {
                    
                    NSArray *selectedAssetTmp = [NSArray arrayWithArray:zImagePickerVC.selectedAssets];
                    for (NSInteger idx = 0; idx < selectedAssetTmp.count; idx ++) {
                        
                        id asset = selectedAssetTmp[idx];
                        if ([asset isEqual:assetModel.asset]) {
                            [zImagePickerVC.selectedAssets removeObject:asset];
                            break;
                        }
                    }
                    [self.photos removeObject:_photoTemps[_currentIndex]];
                }
                *stop = YES;
            }
            
        }];
    }
    assetModel.isSelected = !sender.isSelected;
    [self refreshNavBarAndBottomBarState];
    if (_isSelectOriginalPhoto) {
        
        [self showPhotoBytes];
    }

    if (assetModel.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:sender.imageView.layer type:ZEROOscillatoryAnimationTypeBiggre];
    }
    [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:ZEROOscillatoryAnimationTypeSmaller];;
}

- (void)originalPhotoButtonClick {
    
    _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
    _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
    _originalByteLabel.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) {
        [self showPhotoBytes];
        if (!_selectButton.isSelected) {
            // ----- 如果当前已选择照片书 < 最大可选张数 && z最大可选张数 > 1, 就选中该图
            ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
            if (zImagePickerVC.selectedModels.count < zImagePickerVC.maxImagesCount && zImagePickerVC.showSelectBtn) {
                [self selectButtonClick:_selectButton];
            }
        }
    }
}

- (void)doneButtonClick {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    if (_progress > 0 && _progress < 1) {
        // ----- 如果图片正在从iCloud同步中，提醒用户
        [zImagePickerVC showAlertWithTitle:[NSBundle zero_loaclizedStringForKey:@"Synchronizing photos from iCloud"]];
        return;
    }
    
    if (zImagePickerVC.selectedModels.count ==0) {
        // ----- 如果没有选中过照片 点击确定时选中当前预览的照片
        ZEROAssetModel *assetModel = _assetModels[_currentIndex];
        [zImagePickerVC.selectedModels addObject:assetModel];
    }
    if (zImagePickerVC.allowCrop) {
        // ----- 裁剪状态
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
        ZEROPhotoPreviewCell *cell = (ZEROPhotoPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        UIImage *cropedImage = [ZEROImageCropManager cropImageView:cell.previewView.imageView toRect:zImagePickerVC.cropRect zoomScale:cell.previewView.scrollView.zoomScale containerView:self.view];
        if (zImagePickerVC.needCircleCrop) {
            cropedImage = [ZEROImageCropManager circularClipImage:cropedImage];
        }
        if (self.doneButtonClickBlockCropMode) {
            ZEROAssetModel *model = _assetModels[_currentIndex];
            self.doneButtonClickBlockCropMode(cropedImage, model.asset);
        }
    } else if (self.doneButtonClickBlock) {
        
        self.doneButtonClickBlock(_isSelectOriginalPhoto);
    }
    if (self.doneButtonClickBlockWithPreviewType) {
        self.doneButtonClickBlockWithPreviewType(self.photos, zImagePickerVC.selectedAssets, self.isSelectOriginalPhoto);
    }
}


@end
