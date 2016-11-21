//
//  CircleLayout.h
//  BezierCollectionView
//
//  Created by ZWX on 2016/11/21.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, assign) CGPoint   center;
@property (nonatomic, assign) CGFloat   offset;
@property (nonatomic, assign) CGFloat   xOffset;
@property (nonatomic, assign) CGSize    itemSize;
@property (nonatomic, assign) CGFloat   angularSpacing;
@property (nonatomic, assign) CGFloat   dialRadius;

@property (nonatomic, assign) NSInteger selectedItem;

@property (nonatomic, assign, readonly) NSIndexPath *currentIndexPath;

-(id)initWithRadius: (CGFloat)dialRadius angularSpacing: (CGFloat)angularSpacing cellSize: (CGSize)itemSize xOffset: (CGFloat)xOffset;

@end
