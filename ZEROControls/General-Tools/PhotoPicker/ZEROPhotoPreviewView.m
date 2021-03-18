//
//  ZEROPhotoPreviewView.m
//  PhotoPicker
//
//  Created by ZWX on 2017/1/5.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "ZEROPhotoPreviewView.h"
#import "ZEROImgProgressView.h"
#import "ZEROAssetModel.h"
#import "ZEROPhotoManager.h"
#import "UIImage+ZEROPhotoPickerGif.h"

@interface ZEROPhotoPreviewView()<UIScrollViewDelegate>

@end

@implementation ZEROPhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(10, 0, self.width - 20, self.height);
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self addSubview:self.scrollView];

        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_imageContainerView];

        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
        [_imageContainerView addSubview:_imageView];

        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        // ----- 可以使两个点击手势单独响应一个
        [self addGestureRecognizer:tap2];
        
        [self configerProgressView];
    }
    return self;
}

- (void)configerProgressView {
    
    _progressView = [[ZEROImgProgressView alloc] init];
    static CGFloat progressWH = 40;
    CGFloat progressX = (self.width - progressWH) / 2;
    CGFloat progressY = (self.height - progressWH) / 2;
    _progressView.frame = CGRectMake(progressX, progressY, progressWH, progressWH);
    _progressView.hidden = YES;
    
    [self addSubview:_progressView];
}

#pragma mark - ---- Set Method ----
- (void)setAssetModel:(ZEROAssetModel *)assetModel {
    
    _assetModel = assetModel;
    [_scrollView setZoomScale:1.0 animated:NO];
    if (assetModel.type == ZEROAssetModelMediaTypePhotoGif) {
        
        [[ZEROPhotoManager shareManager] getOriginalPhotoDataWithAsset:assetModel.asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
            
            if (!isDegraded) {
                
                self.imageView.image = [UIImage sd_z_animatedGIFWithData:data];
                [self resizeSubviews];
            }
        }];
    } else {
        
        self.asset = assetModel.asset;
    }
}

- (void)setAsset:(id)asset {
    
    _asset = asset;
    
    [[ZEROPhotoManager shareManager] getPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        
        self.imageView.image = photo;
        [self resizeSubviews];
        self.progressView.hidden = YES;
        if (self.imageProgressUpdateBlock) {
            self.imageProgressUpdateBlock(1);
        }
    }progressHandler:^(double progress, NSError *error, NSDictionary *info, BOOL *stop) {
        
        self.progressView.hidden = NO;
        [self bringSubviewToFront:self.progressView];
        progress = progress > 0.02 ? progress : 0.02;
        self.progressView.progress = progress;
        if (self.imageProgressUpdateBlock) {
            self.imageProgressUpdateBlock(progress);
        }
    } networkAccessAllowed:YES];
}

- (void)setAllowCrop:(BOOL)allowCrop {
    
    _allowCrop = allowCrop;
    _scrollView.maximumZoomScale = allowCrop ? 4.0 : 2.5;
}

#pragma mark - ---- Event Method ----
#pragma mark gesture
- (void)singleTap:(UITapGestureRecognizer *)sender {
    
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)sender {
    
    if (_scrollView.zoomScale > 1.0) {
        
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        
        CGPoint touchPoint = [sender locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xSize = self.frame.size.width / newZoomScale;
        CGFloat ySize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xSize/2, touchPoint.y - ySize/2, xSize, ySize) animated:YES];
    }
}

#pragma mark - ---- Delegate Method ----
#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    // ----- 返回一个放大或者缩小的视图
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    [self refreshScrollViewContentSize];
}

#pragma mark - ---- Public Method ----
- (void)recoverSubviews {
    
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

#pragma mark - ---- Private Method ----

/** * @brief 调整子控件大小 */
- (void)resizeSubviews {
    
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width  = self.scrollView.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.scrollView.width) {
        
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.scrollView.width));
    } else {
        
        CGFloat height = image.size.height / image.size.width * self.scrollView.width;
        if (height < 1 || isnan(height)) {
            // ----- 如果一个数是无穷大，无穷小，那它就是nan值
            height = self.height;
        }
        height = floor(height);
        _imageContainerView.height  = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.height, self.height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
    
    [self refreshScrollViewContentSize];
}

- (void)refreshScrollViewContentSize {
    
    if (_allowCrop) {
        // ----- 如果允许裁剪，需要让图片的任意部分都能在裁剪框内，于是对_scrollView做了如下处理：
        // ----- 让contentSize增大(裁剪框右下角的图片部分)
        CGFloat contentWidthAdd = self.scrollView.width - CGRectGetMaxX(_cropRect);
        CGFloat contentHeightAdd = (MIN(_imageContainerView.height, self.height) - self.cropRect.size.height) / 2;
        CGFloat newSizeW = self.scrollView.contentSize.width + contentWidthAdd;
        CGFloat newSizeH = MAX(self.scrollView.contentSize.height, self.height) + contentHeightAdd;
        _scrollView.contentSize = CGSizeMake(newSizeW, newSizeH);
        _scrollView.alwaysBounceVertical = YES;
        // ----- 让scrollView新增滑动区域(裁剪框左上角的图片部分)
        if (contentHeightAdd > 0) {
            _scrollView.contentInset = UIEdgeInsetsMake(contentHeightAdd, _cropRect.origin.x, 0, 0);
        } else {
            _scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)refreshImageContainerViewCenter {
    
    CGFloat offsetX = (_scrollView.width > _scrollView.contentSize.width) ? ((_scrollView.width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.height > _scrollView.contentSize.height) ? ((_scrollView.height - _scrollView.contentSize.height) * 0.5) : 0.0;
    
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}
@end

