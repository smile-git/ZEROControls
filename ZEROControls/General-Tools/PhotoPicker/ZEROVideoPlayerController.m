//
//  ZEROVideoPlayerController.m
//  PhotoPicker
//
//  Created by ZWX on 2017/1/4.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "ZEROVideoPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZEROPhotoPreviewController.h"
#import "ZEROImagePickerController.h"
#import "ZEROAssetModel.h"
#import "ZEROPhotoManager.h"
#import "UIView+Ext.h"
#import "NSBundle+ZEROImagePicker.h"

@interface ZEROVideoPlayerController () {
    
    UIStatusBarStyle _originStatusBarStyle;
    
    AVPlayer *_player;
    UIButton *_playButton;
    UIImage  *_cover;
    
    UIView          *_toolBar;
    UIButton        *_doneButton;
    UIProgressView  *_progress;
}

@end

@implementation ZEROVideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;
    if (zImagePickerVC) {
        
        self.navigationItem.title = zImagePickerVC.previewBtnTitleStr;
    }
    
    [self configerMoviePlayer];
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

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ---- Congerfiger Method ----
- (void)configerMoviePlayer {
    
    [[ZEROPhotoManager shareManager] getPhotoWithAsset:_assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        
        _cover = photo;
    }];
    
    [[ZEROPhotoManager shareManager] getVideoWithAsset:_assetModel.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _player = [AVPlayer playerWithPlayerItem:playerItem];
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            playerLayer.frame = self.view.bounds;
            [self.view.layer addSublayer:playerLayer];
            
            [self addProgressObserver];
            [self configerPlayButton];
            [self configerBottomToolBar];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNavBar) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        });
    }];
}

- (void)configerPlayButton {
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(0, 64, self.view.width, self.view.height - 64 - 44);
    [_playButton setImage:[NSBundle zero_imageFromPickerBundle:@"MMVideoPreviewPlay.png"] forState:UIControlStateNormal];
    [_playButton setImage:[NSBundle zero_imageFromPickerBundle:@"MMVideoPreviewPlayHL.png"] forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
}

- (void)configerBottomToolBar {
    
    ZEROImagePickerController *zImagePickerVC = (ZEROImagePickerController *)self.navigationController;

    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    _toolBar.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
    CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(self.view.width - 44 - 12, 0, 44, 44);
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];

    if (zImagePickerVC) {
        [_doneButton setTitle:zImagePickerVC.doneBtnTitleStr forState:UIControlStateNormal];
        [_doneButton setTitleColor:zImagePickerVC.okBtnNormalTitleColor forState:UIControlStateNormal];

    } else {
        [_doneButton setTitle:[NSBundle zero_loaclizedStringForKey:@"Done"] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor colorWithRed:83/255.0 green:179/255.0 blue:17/255.0 alpha:1.0] forState:UIControlStateNormal];

    }
    [_toolBar addSubview:_doneButton];
    [self.view addSubview:_toolBar];
}

/** * @brief show progress / 播放进度更新 */
- (void)addProgressObserver {
    
    AVPlayerItem *playerItem = _player.currentItem;
    UIProgressView *progress = _progress;
    
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total   = CMTimeGetSeconds([playerItem duration]);
        if (current) {
            [progress setProgress:(current / total) animated:YES];
        }
    }];
}

#pragma mark - ---- Event Method ----
#pragma mark button click
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
    if ([zImagePickerVC.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingVideo:sourceAssets:)]) {
        [zImagePickerVC.pickerDelegate imagePickerController:zImagePickerVC didFinishPickingVideo:_cover sourceAssets:_assetModel.asset];
    }
    if (zImagePickerVC.didFinishPickingVideoHandle) {
        zImagePickerVC.didFinishPickingVideoHandle(_cover, _assetModel.asset);
    }
}

- (void)playButtonClick {
    
    CMTime currentTime = _player.currentItem.currentTime;
    CMTime durationTime = _player.currentItem.duration;
    
    if (_player.rate == 0.0f) {
        
        if (currentTime.value == durationTime.value) {
            [_player.currentItem seekToTime:CMTimeMake(0, 1)];
        }
        [_player play];
        [self.navigationController setNavigationBarHidden:YES];
        _toolBar.hidden = YES;
        
        [_playButton setImage:nil forState:UIControlStateNormal];
        if (iOS7Later) {
            [UIApplication sharedApplication].statusBarHidden = YES;
        }
    } else {
        [self pausePlayerAndShowNavBar];
    }
}

#pragma mark notofication
- (void)pausePlayerAndShowNavBar {
    
    [_player pause];
    _toolBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    [_playButton setImage:[NSBundle zero_imageFromPickerBundle:@"MMVideoPreviewPlay.png"] forState:UIControlStateNormal];
    if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = NO;
}
@end

