//
//  PhotoTweaksViewController.m
//  PhotoTweaks
//
//  Created by ZWX on 2017/4/8.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "PhotoTweaksViewController.h"
#import "PhotoTweakView.h"
#import "UIColor+Tweak.h"
#import <Photos/Photos.h>
@interface PhotoTweaksViewController ()

@property (nonatomic, strong) PhotoTweakView *photoView;

@end

@implementation PhotoTweaksViewController

- (instancetype)initWithImage:(UIImage *)image {
    
    if (self = [super init]) {
        
        _image = image;
        _autoSaveToLibray = YES;
        _maxRotationAngle = kMaxRotationAngle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor photoTweakCanvasBackgroundColor];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    self.photoView = [[PhotoTweakView alloc] initWithFrame:self.view.bounds image:self.image maxRotationAngle:self.maxRotationAngle];
    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.photoView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(8, CGRectGetHeight(self.view.frame) - 40, 60, 40);
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitle:NSLocalizedStringFromTable(@"Cancel", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor cancelButtonColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor cancelButtonHighlightedColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *cropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cropBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 68, CGRectGetHeight(self.view.frame) - 40, 60, 40);
    cropBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    cropBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cropBtn setTitle:NSLocalizedStringFromTable(@"Done", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    [cropBtn setTitleColor:[UIColor saveButtonColor] forState:UIControlStateNormal];
    [cropBtn setTitleColor:[UIColor saveButtonHighlightedColor] forState:UIControlStateHighlighted];
    [cropBtn addTarget:self action:@selector(saveBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cropBtn];
}

- (void)cancelBtnTapped {
    
    [self.delegate photoTweaksControllerDidCancel:self];
}

- (void)saveBtnTapped {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // ----- translate 原始的基础上加上偏移
    CGPoint translatoin = [self.photoView photoTranslatoin];
    transform = CGAffineTransformTranslate(transform, translatoin.x, translatoin.y);
    // ----- rotate 角度
    transform = CGAffineTransformRotate(transform, self.photoView.angle);
    
    // ----- scale 比例
    CGAffineTransform t = self.photoView.photoContentView.transform;
    CGFloat xScale = sqrt(t.a * t.a + t.c * t.c);
    CGFloat yScale = sqrt(t.b * t.b + t.d * t.d);
    transform = CGAffineTransformScale(transform, xScale, yScale);
    
    CGImageRef imageRef = [self newTransformedImage:transform
                                        sourceImage:self.image.CGImage
                                         sourceSize:self.image.size
                                  sourceOrientation:self.image.imageOrientation
                                        outputWidth:self.image.size.width
                                           cropSize:self.photoView.cropView.frame.size
                                      imageViewSize:self.photoView.photoContentView.bounds.size];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    if (self.autoSaveToLibray) {
        NSData *data = UIImageJPEGRepresentation(image, 0.9);
        // ----- 这里有坑... iOS8系统下这个方法保存图片会失败，因为PHAssetResourceType是iOS9之后的...
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
            options.shouldMoveFile = YES;
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                if (success && completion) {
//                    completion(nil);
//                } else if (error) {
//                    NSLog(@"保存照片出错：%@", error.localizedDescription);
//                    if (completion) completion(error);
//                }
//            });
        }];
    }
    [self.delegate photoTweaksController:self didFinishWithCroppedImage:image];
}

- (CGImageRef)newScaledImage:(CGImageRef)source
                 orientation:(UIImageOrientation)orientation
                      toSize:(CGSize)size
                     quality:(CGInterpolationQuality)quality {
    
    CGSize srcSize = size;
    CGFloat rotation = 0.0;
    
    switch(orientation)
    {
        case UIImageOrientationUp: {
            rotation = 0;
        } break;
        case UIImageOrientationDown: {
            rotation = M_PI;
        } break;
        case UIImageOrientationLeft:{
            rotation = M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        case UIImageOrientationRight: {
            rotation = -M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        default:
            break;
    }
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width,
                                                 size.height,
                                                 8,  //CGImageGetBitsPerComponent(source),
                                                 0,
                                                 rgbColorSpace,//CGImageGetColorSpace(source),
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big//(CGBitmapInfo)kCGImageAlphaNoneSkipFirst  //CGImageGetBitmapInfo(source)
                                                 );
    CGColorSpaceRelease(rgbColorSpace);
    
    CGContextSetInterpolationQuality(context, quality);
    CGContextTranslateCTM(context,  size.width/2,  size.height/2);
    CGContextRotateCTM(context,rotation);
    
    CGContextDrawImage(context, CGRectMake(-srcSize.width/2 ,
                                           -srcSize.height/2,
                                           srcSize.width,
                                           srcSize.height),
                       source);
    
    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    return resultRef;
}

- (CGImageRef)newTransformedImage:(CGAffineTransform)transform
                      sourceImage:(CGImageRef)sourceImage
                       sourceSize:(CGSize)sourceSize
                sourceOrientation:(UIImageOrientation)sourceOrientation
                      outputWidth:(CGFloat)outputWidth
                         cropSize:(CGSize)cropSize
                    imageViewSize:(CGSize)imageViewSize {
    
    CGImageRef source = [self newScaledImage:sourceImage
                                 orientation:sourceOrientation
                                      toSize:sourceSize
                                     quality:kCGInterpolationNone];
    
    CGFloat aspect = cropSize.height / cropSize.width;
    CGSize outputSize = CGSizeMake(outputWidth, outputWidth * aspect);
    
    // ----- Quartz创建一个位图绘制环境，也就是位图上下文
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 outputSize.width,
                                                 outputSize.height,
                                                 CGImageGetBitsPerComponent(source),
                                                 0,
                                                 CGImageGetColorSpace(source),
                                                 CGImageGetBitmapInfo(source)
                                                 );
    // ----- 在填充颜色之前首先要调用 CGContextSetFillColorWithColor()制定颜色。
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, outputSize.width, outputSize.height));
    
    CGAffineTransform uiCoords = CGAffineTransformMakeScale(outputSize.width / cropSize.width, outputSize.height / cropSize.height);
    
    uiCoords = CGAffineTransformTranslate(uiCoords, cropSize.width / 2.0, cropSize.height / 2.0);
    uiCoords = CGAffineTransformScale(uiCoords, 1.0, -1.0);
    CGContextConcatCTM(context, uiCoords);
    
    CGContextConcatCTM(context, transform);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(-imageViewSize.width / 2.0,
                                           -imageViewSize.height / 2.0,
                                           imageViewSize.width,
                                           imageViewSize.height),
                       source);
    
    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGImageRelease(source);
    return resultRef;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}
@end
