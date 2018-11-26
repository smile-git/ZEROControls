//
//  ZEROAssetCell.m
//  PhotoPicker
//
//  Created by ZWX on 2016/12/29.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROAssetCell.h"
#import "ZEROPhotoManager.h"
#import "ZEROAssetModel.h"
#import "ZEROImgProgressView.h"
#import "NSBundle+ZEROImagePicker.h"
#import "UIView+OscillatoryAnimation.h"

@interface ZEROAssetCell()

@property (nonatomic, assign) ZEROAssetCellType type;
@property (nonatomic, assign) PHImageRequestID  imageRequestID;
@property (nonatomic, assign) PHImageRequestID  bigImageRequestID;

// ----- 照片的 图片
@property (nonatomic, strong) UIImageView *imageView;

// ----- 选择照片的 图片
@property (nonatomic, strong) UIImageView *selectImageView;

// ----- 下方，用于展示视频信息或gif
@property (nonatomic, strong) UIView  *bottomView;

// ----- bottom中显示视频的标签图片
@property (nonatomic, strong) UIImageView *videoImgView;


@property (nonatomic, strong) UILabel *timeLength;

@property (nonatomic, strong) ZEROImgProgressView *progressView;

@end

@implementation ZEROAssetCell

#pragma mark - ---- Set Method ----
- (void)setAssetModel:(ZEROAssetModel *)assetModel {
    
    _assetModel = assetModel;
    if (iOS8Later) {
        self.representedAssetIdentifier = [[ZEROPhotoManager shareManager] getAssetIdentifier:_assetModel.asset];
    }
    
    PHImageRequestID imageRequestID = [[ZEROPhotoManager shareManager] getPhotoWithAsset:_assetModel.asset photoWidth:self.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        
        if (self.progressView) {
            self->_progressView.hidden = YES;
            self.imageView.alpha = 1.0;
        }
        
        // ----- Set the cell's thumbnail image if it's still showing the same asset.
        if (!iOS8Later) {
            self.imageView.image = photo;   return ;
        }
        if ([self.representedAssetIdentifier isEqualToString:[[ZEROPhotoManager shareManager] getAssetIdentifier:self->_assetModel.asset]]) {
            self.imageView.image = photo;
        } else {
            // ----- this cell is showing other asset
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    }progressHandler:nil networkAccessAllowed:NO];
    
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.imageRequestID = imageRequestID;
    self.selectPhotoButton.selected = assetModel.isSelected;
    self.selectImageView.image = _selectPhotoButton.isSelected ? [NSBundle zero_imageFromPickerBundle:self.photoSelImageName] : [NSBundle zero_imageFromPickerBundle:self.photoDefImageName];
    self.type = (NSInteger)assetModel.type;
    
    // ----- 让宽高小于最小可选照片尺寸 的图片不可选中
    if ([[ZEROPhotoManager shareManager] isPhotoSelectAbleWithAsset:assetModel.asset]) {
        if (_selectImageView.hidden == NO) {
            
            _selectImageView.hidden   = YES;
            _selectPhotoButton.hidden = YES;
        }
    }
    
    // ----- 用户选中了该图片，提前获取一下大图
    if (assetModel.isSelected) {
        [self fetchBigImage];
    }
}

- (void)setShowSelectBtn:(BOOL)showSelectBtn {
    
    _showSelectBtn = showSelectBtn;
//    if (!self.selectPhotoButton.hidden) {
//        self.selectPhotoButton.hidden = !showSelectBtn;
//    }
//    if (!self.selectImageView.hidden) {
//        self.selectImageView.hidden = !showSelectBtn;
//    }
    
    self.selectPhotoButton.hidden = !showSelectBtn;
    self.selectImageView.hidden   = !showSelectBtn;
}

- (void)setType:(ZEROAssetCellType)type {
    
    _type = type;
    if (type == ZEROAssetCellTypePhoto || type == ZEROAssetCellTypeLievPhoto || (type == ZEROAssetCellTypePhotoGif && !self.allowPickingGif)) {
        
        _selectImageView.hidden   = NO;
        _selectPhotoButton.hidden = NO;
        self.bottomView.hidden    = YES;
    } else {
        // ----- video & gif
        _selectImageView.hidden   = YES;
        _selectPhotoButton.hidden = YES;
        self.bottomView.hidden    = NO;
        if (type == ZEROAssetCellTypeVideo) {
            
            self.timeLength.text      = _assetModel.timeLength;
            self.videoImgView.hidden  = NO;
            _timeLength.left          = self.videoImgView.right;
            _timeLength.textAlignment = NSTextAlignmentRight;
        } else {
            self.timeLength.text      = @"GIF";
            self.videoImgView.hidden  = YES;
            _timeLength.left          = 5;
            _timeLength.textAlignment = NSTextAlignmentLeft;
        }
    }
}

/** * @brief 提前获取一下大图 */
- (void)fetchBigImage {
    
    _bigImageRequestID = [[ZEROPhotoManager shareManager] getPhotoWithAsset:_assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        
        if (self->_progressView) {
            [self hideProgressView];
        }
    } progressHandler:^(double progress, NSError *error, NSDictionary *info, BOOL *stop) {
        
        if (self->_assetModel.isSelected) {
            
            progress = progress > 0.02 ? progress : 0.02;
            self.progressView.progress = progress;
            self.progressView.hidden   = NO;
            self.imageView.alpha       = 0.4;
        } else {
            
            *stop = YES;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } networkAccessAllowed:YES];
}

- (void)hideProgressView {
    
    self.progressView.hidden = YES;
    self.imageView.alpha = 1.0;
}

#pragma mark - ---- Lazy load ----
- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.frame         = CGRectMake(0, 0, self.width, self.height);
        _imageView.contentMode   = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        [self.contentView bringSubviewToFront:_selectImageView];
        [self.contentView bringSubviewToFront:_bottomView];
    }
    return _imageView;
}

- (UIButton *)selectPhotoButton {
    
    if (!_selectPhotoButton) {
        
        _selectPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectPhotoButton.frame = CGRectMake(self.width - 44, 0, 44, 44);
        [_selectPhotoButton addTarget:self action:@selector(selectPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectPhotoButton];
    }
    return _selectPhotoButton;
}

- (UIImageView *)selectImageView {
    
    if (!_selectImageView) {
        
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 27, 0, 27, 27)];
        [self.contentView addSubview:_selectImageView];
    }
    return _selectImageView;
}

- (UIView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 17, self.width, 17)];
        _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        [_bottomView addSubview:self.videoImgView];
        [_bottomView addSubview:self.timeLength];
        [self.contentView addSubview:_bottomView];
    }
    return _bottomView;
}

- (UIImageView *)videoImgView {
    
    if (!_videoImgView) {
        
        _videoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 17, 17)];
        _videoImgView.image = [NSBundle zero_imageFromPickerBundle:@"VideoSendIcon.png"];
        [self.bottomView addSubview:_videoImgView];
    }
    return _videoImgView;
}

- (UILabel *)timeLength {
    
    if (!_timeLength) {
        
        _timeLength = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLength.frame = CGRectMake(self.videoImgView.right, 0, self.width - self.videoImgView.right - 5, 17);
        _timeLength.font  = [UIFont systemFontOfSize:11];
        _timeLength.textColor     = [UIColor whiteColor];
        _timeLength.textAlignment = NSTextAlignmentRight;
        [self.bottomView addSubview:_timeLength];
    }
    return _timeLength;
}

- (ZEROImgProgressView *)progressView {
    
    if (!_progressView) {
        
        _progressView = [[ZEROImgProgressView alloc] init];
        static CGFloat progressWH = 20;
        CGFloat progressXY   = (self.width - progressWH) / 2.0;
        _progressView.hidden = YES;
        _progressView.frame  = CGRectMake(progressXY, progressXY, progressWH, progressWH);
        [self.contentView addSubview:_progressView];
    }
    return _progressView;
}

#pragma mark - ---- Event Method ----
#pragma mark Button Click   
- (void)selectPhotoButtonClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    _assetModel.isSelected = sender.selected;
    
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock(sender.isSelected);
    }
    self.selectImageView.image = sender.isSelected ? [NSBundle zero_imageFromPickerBundle:_photoSelImageName] : [NSBundle zero_imageFromPickerBundle:_photoDefImageName];
    if (sender.isSelected) {
        
        [UIView showOscillatoryAnimationWithLayer:_selectImageView.layer type:ZEROOscillatoryAnimationTypeBiggre];
        // ----- 用户选中了该图片，提前获取下大图
        [self fetchBigImage];
    } else {
        if (_bigImageRequestID && _progressView) {
            
            [[PHImageManager defaultManager] cancelImageRequest:_bigImageRequestID];
            [self hideProgressView];
        }
    }
}


@end

@implementation ZEROAssetCameraCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds   = YES;

        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode     = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

@end
