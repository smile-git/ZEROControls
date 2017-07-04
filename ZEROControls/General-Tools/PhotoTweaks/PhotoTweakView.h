//
//  PhotoTweakView.h
//  PhotoTweaks
//
//  Created by ZWX on 2017/4/8.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CropView;
extern const CGFloat kMaxRotationAngle;

/** 图片内容控件 */
@interface PhotoContentView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@end

/** crop裁剪代理 */
@protocol CropViewDelegate <NSObject>

- (void)cropEnded:(CropView *)cropView;
- (void)cropMoved:(CropView *)cropView;

@end


/** 裁剪控件 */
@interface CropView : UIView
@end


/** 图片调整控件 */
@interface PhotoTweakView : UIView


/** 旋转角度 */
@property (nonatomic, assign, readonly) CGFloat angle;
@property (nonatomic, assign, readonly) CGFloat photoContentOffset;

@property (nonatomic, strong, readonly) CropView *cropView;
@property (nonatomic, strong, readonly) PhotoContentView *photoContentView;
@property (nonatomic, strong, readonly) UISlider *slider;
@property (nonatomic, strong, readonly) UIButton *resetBtn;

- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
             maxRotationAngle:(CGFloat)maxRotationAngle;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

- (CGPoint)photoTranslatoin;
@end
