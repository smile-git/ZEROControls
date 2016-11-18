//
//  BezierLayout.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/18.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BezierLayout : UICollectionViewLayout

@property (readwrite, nonatomic, assign) NSInteger cellCount;             //cell总个数

@property (readwrite, nonatomic, assign) CGPoint center;
@property (readwrite, nonatomic, assign) CGFloat offset;            //计算偏移cell个数
@property (readwrite, nonatomic, assign) CGFloat itemHeight;        //cell高度
@property (readwrite, nonatomic, assign) CGFloat xOffset;           //x偏移量
@property (readwrite, nonatomic, assign) CGSize cellSize;
@property (readwrite, nonatomic, assign) CGFloat AngularSpacing;    //角间距
@property (readwrite, nonatomic, assign) CGFloat dialRadius;        //拨盘半径

@property (readonly, nonatomic, strong)  NSIndexPath *currentIndexPath;  //当前地位
@property (readwrite, nonatomic, assign) int selectedItem;


- (instancetype)initWithRadius:(CGFloat)radius angularSpacing:(CGFloat)spacing cellSize:(CGSize)cell itemHeight:(CGFloat)height xOffset:(CGFloat)xOffset;
@end
