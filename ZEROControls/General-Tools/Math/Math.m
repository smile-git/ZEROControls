//
//  Math.m
//  ZEROControls
//
//  Created by ZWX on 2021/3/22.
//  Copyright © 2021 ZWX. All rights reserved.
//

#import "Math.h"

@implementation Math

+ (CGFloat) degreeFromRadian:(CGFloat)radian {
    
    return ((radian) * (180.0f / M_PI));
}

+ (CGFloat)radianFromDegree:(CGFloat)degree {
    
    return ((degree) * M_PI / 180.0f);
}

+ (CGFloat)radianValueFromTanSideA:(CGFloat)sideA sideB:(CGFloat)sideB {
    
    return atan2f(sideA, sideB);
}

CGFloat calculateSlope(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2) {
    
    if (x2 == x1) {
        
        return 0;
    }
    return (y2 - y1) / (x2 - x1);
}

CGFloat calculateConstant(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2) {
    
    if (x2 == x1) {
        
        return 0;
    }
    return (x2 * y1 - x1 * y2) / (x2 - x1);
}

+ (instancetype)mathOnceLinearEquationWithPointA:(MATHPoint)pointA pointB:(MATHPoint)pointB {
    
    Math *equation = [[[self class] alloc] init];
    
    CGFloat x1 = pointA.x;
    CGFloat y1 = pointA.y;
    CGFloat x2 = pointB.x;
    CGFloat y2 = pointB.y;
    
    equation.k = calculateSlope(x1, y1, x2, y2);
    equation.b = calculateConstant(x1, y1, x2, y2);
    
    return equation;
}

+ (CGSize)resetFromSize:(CGSize)size fixedWidth:(CGFloat)width {
    
    CGFloat newHeight = size.height * (width / size.width);
    CGSize newSize = CGSizeMake(width, newHeight);
    
    return newSize;
}

+ (CGSize)resetFromSize:(CGSize)size fixedHeight:(CGFloat)height {
    
    CGFloat newWidth = size.width * (height / size.height);
    CGSize newSize = CGSizeMake(newWidth, height);
    
    return newSize;
}
@end
