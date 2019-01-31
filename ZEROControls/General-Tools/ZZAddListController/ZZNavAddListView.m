//
//  ZZAddListView.m
//  NavAddList
//
//  Created by ZWX on 27/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "ZZNavAddListView.h"

// ----- 默认数值
static const CGFloat RightMarginDefault = 17.5f;
#define ZZNavAddListViewFillColor     UIColorRGBA(100, 100, 100, 1)

@interface ZZNavAddListView ()

@property (nonatomic, assign) CGFloat rightOffset;
@property (nonatomic, strong) UIColor *viewFillColor;

@end

@implementation ZZNavAddListView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame: frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.rightOffset     = RightMarginDefault;
        self.viewFillColor   = ZZNavAddListViewFillColor;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame rightOffset:(CGFloat)rightOffset {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.rightOffset     = rightOffset;
        self.viewFillColor   = ZZNavAddListViewFillColor;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame rightOffset:(CGFloat)rightOffset viewFillColor:(UIColor *)viewFillColor {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.rightOffset     = rightOffset;
        self.viewFillColor   = viewFillColor;
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // ----- 三角形
    CGFloat centerX    = self.frame.size.width - (self.rightOffset == 0.f ? RightMarginDefault : self.rightOffset);
    CGFloat top        = 5;
    CGFloat height     = 5;
    CGFloat layerWidth = height * sqrt(3) / 3;
    
    UIColor *aColor    = self.viewFillColor;
    CGContextSetFillColorWithColor(context, aColor.CGColor);    //填充颜色
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);  //画笔线的颜色
    
    CGPoint sPoints[3];
    sPoints[0] = CGPointMake(centerX, top);
    sPoints[1] = CGPointMake(centerX - layerWidth, top + height);
    sPoints[2] = CGPointMake(centerX + layerWidth, top + height);
    CGContextAddLines(context, sPoints, 3);         //添加线
    CGContextClosePath(context);                    //封起来
    CGContextDrawPath(context, kCGPathFillStroke);  //根据坐标绘制路径
    
    
    // ----- 圆角矩形
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
