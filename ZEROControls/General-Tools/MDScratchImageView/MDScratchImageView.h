//
//  MDScratchImageView.h
//  ZEROControls
//
//  Created by ZWX on 2021/3/29.
//  Copyright © 2021 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MDScratchImageView;
@protocol MDScratchImageViewDelegate <NSObject>
@required
- (void)mdScratchImageView:(MDScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress;

@end

@interface MDScratchImageView : UIImageView

@property (nonatomic, readonly) CGFloat maskingProgress;
@property (nonatomic, assign) id<MDScratchImageViewDelegate> delegate;

- (void)setImage:(UIImage *)image radius:(size_t)radius;
@end

NS_ASSUME_NONNULL_END
