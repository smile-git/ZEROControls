//
//  ZEROImagePickerController.m
//  PhotoPicker
//
//  Created by ZWX on 2016/12/27.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROImagePickerController.h"
#import "ZEROAlbumListController.h"
#import "ZEROPhotoPreviewController.h"
#import "ZEROPhotoPickerController.h"
#import "NSBundle+ZEROImagePicker.h"
#import "ZEROPhotoManager.h"
#import "ZEROAssetModel.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface ZEROImagePickerController () {
    
    NSTimer  *_timer;
    
    UILabel  *_promptLabel;
    UIButton *_settingBtn;
    
    BOOL _pushPhotoPickerVC;
    BOOL _didPushPhotoPickerVC;
    
    UIButton *_progressHUD;
    UIView   *_HUDContainer;
    UILabel  *_HUDLable;
    UIActivityIndicatorView *_HUDIndicatorView;

    UIStatusBarStyle _originStatusBarStyle;
}
@end

@implementation ZEROImagePickerController


#pragma mark - ---- Init Method ----
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<ZEROImagePickerControllerDelegate>)delegate {
    
    return [self initWithMaxImagesCount:maxImagesCount columnNumber:4 delegate:delegate isPushPhoto:YES];
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<ZEROImagePickerControllerDelegate>)delegate {
    
    return [self initWithMaxImagesCount:maxImagesCount columnNumber:4 delegate:delegate isPushPhoto:YES];
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<ZEROImagePickerControllerDelegate>)delegate isPushPhoto:(BOOL)isPushPhotoPicker {
    
    ZEROAlbumListController *albumListVC = [[ZEROAlbumListController alloc] init];
    
    if (self = [super initWithRootViewController:albumListVC]) {
        
        self.maxImagesCount = maxImagesCount > 0 ? maxImagesCount : 9;
        self.columnNumber   = columnNumber;
        self.pickerDelegate = delegate;
        _pushPhotoPickerVC  = isPushPhotoPicker;

        [self configerDefaultSetting];
        
        if (![[ZEROPhotoManager shareManager] authorizationStatusAuthorized]) {
            
            NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
            if (!appName) appName = [[NSBundle mainBundle] .infoDictionary valueForKey:@"CFBundleName"];
            
            NSString *promptText = [NSString stringWithFormat:[NSBundle zero_loaclizedStringForKey:@"Allow %@ to access your album in \"Settings -> Privacy -> Photos\""], appName];

            _promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _promptLabel.frame         = CGRectMake(8, 120, self.view.width - 16, 60);
            _promptLabel.textAlignment = NSTextAlignmentCenter;
            _promptLabel.numberOfLines = 0;
            _promptLabel.font          = [UIFont systemFontOfSize:16];
            _promptLabel.textColor     = [UIColor colorWithWhite:0.1 alpha:1];
            _promptLabel.text          = promptText;
            [self.view addSubview:_promptLabel];
            
            _settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            _settingBtn.frame = CGRectMake(0, 180, self.view.width, 44);
            _settingBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            [_settingBtn setTitle:self.settingBtnTitleStr forState:UIControlStateNormal];
            [_settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_settingBtn];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationSattusChange) userInfo:nil repeats:YES];
        } else {
            
            [self pushPhotoPickerVc];
        }
    }
    
    return self;
}

- (instancetype)initWithSelectedAssets:(NSMutableArray *)selectedAssets selectedPhotos:(NSMutableArray *)selectedPhotos index:(NSInteger)index {
    
    ZEROPhotoPreviewController *previewVC = [[ZEROPhotoPreviewController alloc] init];
    if (self = [super initWithRootViewController:previewVC]) {
        
        self.selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
        
    }
    return self;
}

- (instancetype)initCropTypeWithAsset:(id)asset photo:(UIImage *)photo completion:(void (^)(UIImage *, id))completion {
    
    ZEROPhotoPreviewController *previewVC = [[ZEROPhotoPreviewController alloc] init];
    if (self = [super initWithRootViewController:previewVC]) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = YES;
    [ZEROPhotoManager shareManager].shouldFixOrientation = NO;
    
    if (iOS7Later) {
        
        self.navigationBar.barTintColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
        self.navigationBar.tintColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    [super viewWillAppear:animated];
    _originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [UIApplication sharedApplication].statusBarStyle = iOS7Later ? UIStatusBarStyleLightContent : UIStatusBarStyleBlackOpaque;
#pragma clang diagnostic pop

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = _originStatusBarStyle;
    [self hideProgressHUD];
}

#pragma mark - ---- Public method ----
- (void)showAlertWithTitle:(NSString *)title {
    
    if (iOS8Later) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:[NSBundle zero_loaclizedStringForKey:@"OK"] style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:[NSBundle zero_loaclizedStringForKey:@"OK"] otherButtonTitles:nil, nil] show];
    }
}

- (void)showProgressHUD {
    
    if (!_progressHUD) {
        
        _progressHUD = [UIButton buttonWithType:UIButtonTypeCustom];
        [_progressHUD setBackgroundColor:[UIColor clearColor]];
        
        _HUDContainer = [[UIView alloc] init];
        _HUDContainer.frame              = CGRectMake((self.view.width - 120) / 2, (self.view.height - 90) / 2, 120, 90);
        _HUDContainer.layer.cornerRadius = 8;
        _HUDContainer.clipsToBounds      = YES;
        _HUDContainer.backgroundColor    = [UIColor darkGrayColor];
        _HUDContainer.alpha              = 0.7;
        
        _HUDIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _HUDIndicatorView.frame = CGRectMake(45, 15, 30, 30);
        
        _HUDLable = [[UILabel alloc] init];
        _HUDLable.frame = CGRectMake(0,40, 120, 50);
        _HUDLable.textAlignment = NSTextAlignmentCenter;
        _HUDLable.text = self.processHintStr;
        _HUDLable.font = [UIFont systemFontOfSize:15];
        _HUDLable.textColor = [UIColor whiteColor];
        
        [_HUDContainer addSubview:_HUDLable];
        [_HUDContainer addSubview:_HUDIndicatorView];
        [_progressHUD addSubview:_HUDContainer];
    }
    
    [_HUDIndicatorView startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:_progressHUD];
    
    // ----- 如果超出默认时间，停止hud，并隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.hudTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideProgressHUD];
    });
}

- (void)hideProgressHUD {
    
    if (_progressHUD) {
        [_HUDIndicatorView stopAnimating];
        [_progressHUD removeFromSuperview];
    }
}

- (void)cancelButtonClick {
    
    if (self.autoDismiss) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self callDelegateMethod];
        }];
    } else {
        
        [self callDelegateMethod];
    }
}

- (void)callDelegateMethod {
    
    if ([self.pickerDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.pickerDelegate imagePickerControllerDidCancel:self];
    }
    
    if (self.imagePickerControllerDidCancelHandle) {
        self.imagePickerControllerDidCancelHandle(self);
    }
}

#pragma mark - ---- set method ----
- (void)setBarItemTextFont:(UIFont *)barItemTextFont {
    
    _barItemTextFont = barItemTextFont;
    [self configerBarButtonItemAppearance];
}

- (void)setBarItemTextColor:(UIColor *)barItemTextColor {
    
    _barItemTextColor = barItemTextColor;
    [self configerBarButtonItemAppearance];
}

- (void)setMaxImagesCount:(NSInteger)maxImagesCount {
    
    _maxImagesCount = maxImagesCount;
    if (maxImagesCount > 1) {
        
        _showSelectBtn = YES;
        _allowCrop = NO;
    }
}

- (void)setShowSelectBtn:(BOOL)showSelectBtn {
    
    _showSelectBtn = showSelectBtn;
    if (_maxImagesCount > 1 && !showSelectBtn) {
        // ----- 多选模式下，showSelectBtn必为YES
        _showSelectBtn = YES;
    }
}

- (void)setAllowCrop:(BOOL)allowCrop {
    
    _allowCrop = allowCrop;

    if (allowCrop) {
        
        _maxImagesCount = 1;
        _showSelectBtn  = NO;
        self.allowPickingOriginalPhoto = NO;
        self.allowPickingGif = NO;
    }
}

- (void)setCircleCropRadius:(NSInteger)circleCropRadius {
    
    _circleCropRadius = circleCropRadius;
    _cropRect = CGRectMake(self.view.width / 2 - _circleCropRadius, self.view.height / 2 - _circleCropRadius, _circleCropRadius * 2, _circleCropRadius * 2);
}

- (void)setHudTimeout:(NSInteger)hudTimeout {
    
    _hudTimeout = hudTimeout;
    if (hudTimeout < 5) {
        
        _hudTimeout = 5;
    } else if (hudTimeout > 60) {
        
        _hudTimeout = 60;
    }
}

- (void)setColumnNumber:(NSInteger)columnNumber {
    
    _columnNumber = columnNumber;
    if (columnNumber <= 2) {
        
        _columnNumber = 2;
    } else if (columnNumber >= 6) {
        
        _columnNumber = 6;
    }
    
    [ZEROPhotoManager shareManager].columnNumber = _columnNumber;
}

- (void)setMinPhotoWidthSelectAble:(CGFloat)minPhotoWidthSelectAble {
    
    _minPhotoWidthSelectAble = minPhotoWidthSelectAble;
    [ZEROPhotoManager shareManager].minPhotoWidthSelectAble = _minPhotoWidthSelectAble;
}

- (void)setMinPHotoHeightSelectAble:(CGFloat)minPHotoHeightSelectAble {
    
    _minPHotoHeightSelectAble = minPHotoHeightSelectAble;
    [ZEROPhotoManager shareManager].minPhotoHeightSelectAble = _minPHotoHeightSelectAble;
}

- (void)setHideWhenCanNotSelect:(BOOL)hideWhenCanNotSelect {
    
    _hideWhenCanNotSelect = hideWhenCanNotSelect;
    [ZEROPhotoManager shareManager].hideWhenCanNotSelect = _hideWhenCanNotSelect;
}

- (void)setPhotoPreviewMaxWidth:(CGFloat)photoPreviewMaxWidth {
    
    _photoPreviewMaxWidth = photoPreviewMaxWidth;
    if (photoPreviewMaxWidth > 800) {
        
        _photoPreviewMaxWidth = 800;
    } else if (photoPreviewMaxWidth < 500) {
        
        _photoPreviewMaxWidth = 500;
    }
    
    [ZEROPhotoManager shareManager].photoPreviewMaxWidth = _photoPreviewMaxWidth;
}

- (void)setSelectedAssets:(NSMutableArray *)selectedAssets {
    
    _selectedAssets = selectedAssets;
    _selectedModels = [NSMutableArray array];
    
    [_selectedAssets enumerateObjectsUsingBlock:^(id  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        // ----- 这里我有个问题，如果选择了照片和视频，类型type就不能赋值为photo了
        ZEROAssetModel *assetModel = [ZEROAssetModel assetModelWithAsset:asset type:ZEROAssetModelMediaTypePhoto];
        assetModel.isSelected = YES;
        [self->_selectedModels addObject:assetModel];
    }];
}

- (void)setAllowPickingImage:(BOOL)allowPickingImage {
    
    _allowPickingImage = allowPickingImage;
    
    NSString *allowPickingImageStr = _allowPickingImage ? @"1" : @"0";
    [[NSUserDefaults standardUserDefaults] setObject:allowPickingImageStr forKey:@"zero_allowPickingImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAllowPickingVideo:(BOOL)allowPickingVideo {
    
    _allowPickingVideo = allowPickingVideo;
    NSString *allowPickingVideoStr = _allowPickingVideo ? @"1" : @"0";
    [[NSUserDefaults standardUserDefaults] setObject:allowPickingVideoStr forKey:@"zero_allowPickingVideo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSortAscendingByModificationDate:(BOOL)sortAscendingByModificationDate {
    
    _sortAscendingByModificationDate = sortAscendingByModificationDate;
    [ZEROPhotoManager shareManager].sortAscendingByModifucationDate = _sortAscendingByModificationDate;
}

#pragma mark - ---- Get Method ----

- (CGRect)cropRect {
    
    if (_cropRect.size.width > 0) {
        return _cropRect;
    }
    
    CGFloat cropViewWH = self.view.width;
    return CGRectMake(0, (self.view.height - cropViewWH) / 2, cropViewWH, cropViewWH);
}


#pragma mark - ---- Configer Method ----
#pragma mark Init Configer
- (void)configerDefaultSetting {
    
    self.selectedModels = [NSMutableArray array];
    
    self.allowPickingVideo               = YES;
    self.allowPickingImage               = YES;
    self.allowPickingOriginalPhoto       = YES;
    self.allowTakePicture                = YES;
    self.sortAscendingByModificationDate = YES;
    self.autoDismiss                     = YES;
    self.allowPreviewImage               = YES;
    
    self.photoWidth           = 828.0;
    self.photoPreviewMaxWidth = 600.0;
    self.hudTimeout           = 15;
    
    self.barItemTextFont        = [UIFont systemFontOfSize:15];
    self.barItemTextColor       = [UIColor whiteColor];
    self.okBtnNormalTitleColor  = [UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0];
    self.okBtnDisableTitleColor = [UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:0.5];
    
    
    [self configerDefaultImageName];
    [self configerDefaultBtnTitle];
}

- (void)configerDefaultImageName {
    
    self.takePictureImageName           = @"takePicture.png";
    self.photoSelImageName              = @"photo_sel_photoPickerVc.png";
    self.photoDefImageName              = @"photo_def_photoPickerVc.png";
    self.photoNumberIconImageName       = @"photo_number_icon.png";
    self.photoPreviewOriginDefImageName = @"preview_original_def.png";
    self.photoOriginDefImageName        = @"photo_original_def.png";
    self.photoOriginSelImageName        = @"photo_original_sel.png";
}

- (void)configerDefaultBtnTitle {
    
    self.doneBtnTitleStr      = [NSBundle zero_loaclizedStringForKey:@"Done"];
    self.cancelBtnTitleStr    = [NSBundle zero_loaclizedStringForKey:@"Cancel"];
    self.previewBtnTitleStr   = [NSBundle zero_loaclizedStringForKey:@"Preview"];
    self.fullImageBtnTitleStr = [NSBundle zero_loaclizedStringForKey:@"Full image"];
    self.settingBtnTitleStr   = [NSBundle zero_loaclizedStringForKey:@"Setting"];
    self.processHintStr       = [NSBundle zero_loaclizedStringForKey:@"Processing..."];
}


#pragma mark Set Configer
- (void)configerBarButtonItemAppearance {
    
    UIBarButtonItem *barItem;
    if (iOS9Later) {
        
        barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[ZEROImagePickerController class]]];
    } else {
        
        barItem = [UIBarButtonItem appearanceWhenContainedIn:[ZEROImagePickerController class], nil];
    }
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = self.barItemTextColor;
    textAttrs[NSFontAttributeName]            = self.barItemTextFont;
    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

#pragma mark - ---- Private Method ----
- (void)settingBtnClick {
    
    if (iOS8Later) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } else {
        
        NSURL *privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
        if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
            [[UIApplication sharedApplication] openURL:privacyUrl];
        } else {
            NSString *message = [NSBundle zero_loaclizedStringForKey:@"Can not jump to the privacy settings page, please go to the settings page by self, thank you"];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[NSBundle zero_loaclizedStringForKey:@"Sorry"] message:message delegate:nil cancelButtonTitle:[NSBundle zero_loaclizedStringForKey:@"OK"] otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void)observeAuthrizationSattusChange {
    
    if ([[ZEROPhotoManager shareManager] authorizationStatusAuthorized]) {
        
        [_promptLabel removeFromSuperview];
        [_settingBtn removeFromSuperview];
        [_timer invalidate];
        _timer = nil;
        
        [self pushPhotoPickerVc];
    }
}

- (void)pushPhotoPickerVc {
    
    _didPushPhotoPickerVC = NO;
    
    if (_pushPhotoPickerVC) {
        
        ZEROPhotoPickerController *photoPickerVC = [[ZEROPhotoPickerController alloc] init];
        photoPickerVC.isFirstAppear = YES;
        [[ZEROPhotoManager shareManager] getCameraRollAlbumVideo:_allowPickingVideo allowPickingImage:_allowPickingImage completion:^(ZEROAlbumModel *model) {
            
            photoPickerVC.albumModel = model;
            [self pushViewController:photoPickerVC animated:YES];
            self->_didPushPhotoPickerVC = YES;
        }];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (iOS7Later) {
        viewController.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

#pragma clang diagnostic pop

@end
