//
//  PhotoTweaksViewController.h
//  PhotoTweaks
//
//  Created by ZWX on 2017/4/8.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoTweaksViewControllerDelegate;

/**
 The photo tweaks controller
 */
@interface PhotoTweaksViewController : UIViewController


/**
 Image to process.
 */
@property (nonatomic, strong, readonly) UIImage *image;
/**
 Flag indicatoin whether the image cropped will be savad to photo library automatically.Defaults is YES
 */
@property (nonatomic, assign) BOOL autoSaveToLibray;
/**
 Max rotatoin agnle
 */
@property (nonatomic, assign) CGFloat maxRotationAngle;


/**
 The optional photo tweaks controller delegate
 */
@property (nonatomic, weak) id<PhotoTweaksViewControllerDelegate> delegate;



/**
 Create a photo tweaks view controller with the image to process.

 @param image tweak image
 @return tweaks view controller
 */
- (instancetype)initWithImage:(UIImage *)image;


@end


@protocol PhotoTweaksViewControllerDelegate <NSObject>


/**
 Called on image cropped.  >  在图像裁减之后调用
 */
- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage;


/**
 Called on cropping image canceled  > 在图像取消裁剪之后调用
 */
- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller;

@end

