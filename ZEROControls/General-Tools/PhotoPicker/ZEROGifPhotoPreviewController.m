//
//  ZEROGifPhotoPreviewController.m
//  PhotoPicker
//
//  Created by ZWX on 2017/1/4.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "ZEROGifPhotoPreviewController.h"
#import "ZEROImagePickerController.h"
#import "ZEROPhotoManager.h"
#import "ZEROPhotoPreviewView.h"
#import "UIView+Ext.h"
#import "ZEROAssetModel.h"
#import "NSBundle+ZEROImagePicker.h"

@interface ZEROGifPhotoPreviewController () {
    
    UIView *_toolBar;
    UIButton *_doneButton;
    UIProgressView *_progress;
    
    ZEROPhotoPreviewView *_previewView;
    
    UIStatusBarStyle _originStatusBarStyle;
}

@end

@implementation ZEROGifPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ZEROImagePickerController *zImagePicker = (ZEROImagePickerController *)self.navigationController;

    self.view.backgroundColor = [UIColor blackColor];
    if (zImagePicker) {
        self.navigationItem.title = [NSString stringWithFormat:@"GIF %@", zImagePicker.previewBtnTitleStr];
    }
    
    [self configerPreviewView];
    [self configreBottomToolBar];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    _originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [UIApplication sharedApplication].statusBarStyle = iOS7Later ? UIStatusBarStyleLightContent : UIStatusBarStyleBlackOpaque;
#pragma clang diagnostic pop
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = _originStatusBarStyle;
}


#pragma mark - ---- Congerfiger Method ----
- (void)configerPreviewView {
    
    _previewView = [[ZEROPhotoPreviewView alloc] initWithFrame:self.view.bounds];
    _previewView.scrollView.frame = self.view.bounds;
    _previewView.assetModel = _assetModel;
    
    __weak typeof(self)weakSelf = self;
    [_previewView setSingleTapGestureBlock:^{
        [weakSelf singleTapAction];
    }];
    
    [self.view addSubview:_previewView];
}

- (void)configreBottomToolBar {
    
    ZEROImagePickerController *zImagePicker = (ZEROImagePickerController *)self.navigationController;

    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    _toolBar.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
    CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(self.view.width - 44 - 12, 0, 44, 44);
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (zImagePicker) {
        [_doneButton setTitle:zImagePicker.doneBtnTitleStr forState:UIControlStateNormal];
        [_doneButton setTitleColor:zImagePicker.okBtnNormalTitleColor forState:UIControlStateNormal];
    } else {
        [_doneButton setTitle:[NSBundle zero_loaclizedStringForKey:@"Done"] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0] forState:UIControlStateNormal];
    }
    
    [_toolBar addSubview:_doneButton];
    
    UILabel *byteLable = [[UILabel alloc] init];
    byteLable.textColor = [UIColor whiteColor];
    byteLable.font = [UIFont systemFontOfSize:13];
    byteLable.frame = CGRectMake(10, 0, 100, 44);
    [[ZEROPhotoManager shareManager] getPhotosBytesWithArray:@[_assetModel] completion:^(NSString *totalBytes) {
        byteLable.text = totalBytes;
    }];
    [_toolBar addSubview:byteLable];
    
    [self.view addSubview:_toolBar];
}

#pragma mark - ---- Event Method ----

- (void)singleTapAction {
    
    _toolBar.hidden = !_toolBar.isHidden;
    [self.navigationController setNavigationBarHidden:_toolBar.isHidden];
    if (iOS7Later) {
        [UIApplication sharedApplication].statusBarHidden = _toolBar.isHidden;
    }
}

- (void)doneButtonClick {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    if (self.navigationController) {
        if (zImagePickerVC.autoDismiss) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [self callDelegateMethod];
            }];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            [self callDelegateMethod];
        }];
    }
}

- (void)callDelegateMethod {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    UIImage *animatedImage = _previewView.imageView.image;
    if ([zImagePickerVC.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingGifImage:sourceAssets:)]) {
        [zImagePickerVC.pickerDelegate imagePickerController:zImagePickerVC didFinishPickingGifImage:animatedImage sourceAssets:_assetModel.asset];
    }
    if (zImagePickerVC.didFinishPickingVideoHandle) {
        zImagePickerVC.didFinishPickingGifImageHandle(animatedImage, _assetModel.asset);
    }
}

@end






