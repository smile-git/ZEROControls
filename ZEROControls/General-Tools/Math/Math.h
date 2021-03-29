//
//  Math.h
//  ZEROControls
//
//  Created by ZWX on 2021/3/22.
//  Copyright © 2021 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct MATHPoint {
    
    CGFloat x;
    CGFloat y;
};

typedef struct MATHPoint MATHPoint;

static inline MATHPoint MATHPointMake(CGFloat x, CGFloat y) {
    
    MATHPoint p;
    p.x = x;
    p.y = y;
    return  p;
}

@interface Math : NSObject

#pragma mark - Radian & degree

/// Covert radian to degree.
/// @param radian Degree.
+ (CGFloat)degreeFromRadian:(CGFloat)radian;


/// Cover degree to radian.
/// @param degree Degree
+ (CGFloat)radianFromDegree:(CGFloat)degree;


#pragma mark - Calculate radian.

/// Radian value from math 'tan' function.
/// @param sideA Side A
/// @param sideB Side B
+ (CGFloat)radianValueFromTanSideA:(CGFloat)sideA sideB:(CGFloat)sideB;


#pragma mark - Calculate once linear equation (Y = kX + b).

@property (nonatomic, assign) CGFloat k;
@property (nonatomic, assign) CGFloat b;

/// Calculate constant & slope by two math point for once linear equation.
/// @param pointA Point A
/// @param pointB Point B
+ (instancetype)mathOnceLinearEquationWithPointA:(MATHPoint)pointA pointB:(MATHPoint)pointB;


#pragma mark - Reset size.

/// Get the new size with the fixed width.
/// @param size Old size.
/// @param width The fixed width.
+ (CGSize)resetFromSize:(CGSize)size fixedWidth:(CGFloat)width;


/// Get the new size width the fixed height.
/// @param size Old size.
/// @param height The fixed height.
+ (CGSize)resetFromSize:(CGSize)size fixedHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
