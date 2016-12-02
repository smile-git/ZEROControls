//
//  AddListView.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/18.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "AddListView.h"

#define AddListViewFillColor    UIColorRGBA(100, 100, 100, 1)

@implementation AddListView

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*三角形*/
    CGFloat centerX    = self.frame.size.width - 17.5;
    CGFloat top        = 5;
    CGFloat height     = 5;
    CGFloat layerWidth = height * sqrt(3) / 3;
    
    UIColor *aColor    = AddListViewFillColor;
    CGContextSetFillColorWithColor(context, aColor.CGColor);    //填充颜色
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);  //画笔线的颜色
    
    CGPoint sPoints[3];
    sPoints[0] = CGPointMake(centerX, top);
    sPoints[1] = CGPointMake(centerX - layerWidth, top + height);
    sPoints[2] = CGPointMake(centerX + layerWidth, top + height);
    CGContextAddLines(context, sPoints, 3);         //添加线
    CGContextClosePath(context);                    //封起来
    CGContextDrawPath(context, kCGPathFillStroke);  //根据坐标绘制路径
    
    
    /*画圆角矩形*/
    CGFloat arcTop = top + height + 1;
    float fw       = self.frame.size.width;
    float fh       = self.frame.size.height;
    
    CGContextMoveToPoint(context, fw, fh - 10);                     // 开始坐标右边开始
    CGContextAddArcToPoint(context, fw, fh, 10, fh, 4);             // 右下角角度
    CGContextAddArcToPoint(context, 0, fh, 0, arcTop, 4);           // 左下角角度
    CGContextAddArcToPoint(context, 0, arcTop, fw - 10, arcTop, 3); // 左上角
    CGContextAddArcToPoint(context, fw, arcTop, fw, fh - 10, 3);    // 右上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);                  //根据坐标绘制路径
    
}

@end
