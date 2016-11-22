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

@property (nonatomic, assign) CGFloat   offset;         //偏移量（偏移item数量）
@property (nonatomic, assign) CGFloat   xOffset;        //x偏移
@property (nonatomic, assign) CGSize    itemSize;       //item size
@property (nonatomic, assign) CGFloat   angularSpacing; //角间距
@property (nonatomic, assign) CGFloat   dialRadius;     //半径

-(id)initWithRadius: (CGFloat)dialRadius angularSpacing: (CGFloat)angularSpacing cellSize: (CGSize)itemSize xOffset: (CGFloat)xOffset;

@end
