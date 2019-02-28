//
//  StyleKitName.m
//  ProjectName
//
//  Created by AuthorName on 27/01/2018.
//  Copyright © 2018 CompanyName. All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//

#import "StyleKitName.h"


@implementation StyleKitName

#pragma mark Cache

static UIImage* _imageOfNavBack = nil;
static UIImage* _imageOfNavAdd = nil;

#pragma mark Initialization

+ (void)initialize
{
}

#pragma mark Drawing Methods

+ (void)drawNavBack
{
    [StyleKitName drawNavBackWithFrame: CGRectMake(0, 0, 50, 30) resizing: StyleKitNameResizingBehaviorStretch];
}

+ (void)drawNavBackWithFrame: (CGRect)targetFrame resizing: (StyleKitNameResizingBehavior)resizing
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Resize to Target Frame
    CGContextSaveGState(context);
    CGRect resizedFrame = StyleKitNameResizingBehaviorApply(resizing, CGRectMake(0, 0, 50, 30), targetFrame);
    CGContextTranslateCTM(context, resizedFrame.origin.x, resizedFrame.origin.y);
    CGContextScaleCTM(context, resizedFrame.size.width / 50, resizedFrame.size.height / 30);


    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.978 green: 0.978 blue: 0.978 alpha: 1];

    //// Page-1
    {
        //// detail-thumbnail
        {
            //// arrow-left Drawing
            UIBezierPath* arrowleftPath = [UIBezierPath bezierPath];
            [arrowleftPath moveToPoint: CGPointMake(2.8, 14.26)];
            [arrowleftPath addLineToPoint: CGPointMake(12.78, 5.87)];
            [arrowleftPath addCurveToPoint: CGPointMake(12.92, 4.81) controlPoint1: CGPointMake(13.08, 5.62) controlPoint2: CGPointMake(13.14, 5.14)];
            [arrowleftPath addCurveToPoint: CGPointMake(11.96, 4.65) controlPoint1: CGPointMake(12.69, 4.47) controlPoint2: CGPointMake(12.26, 4.4)];
            [arrowleftPath addLineToPoint: CGPointMake(0.27, 14.26)];
            [arrowleftPath addCurveToPoint: CGPointMake(0.14, 14.42) controlPoint1: CGPointMake(0.2, 14.34) controlPoint2: CGPointMake(0.17, 14.38)];
            [arrowleftPath addCurveToPoint: CGPointMake(0.07, 14.54) controlPoint1: CGPointMake(0.12, 14.46) controlPoint2: CGPointMake(0.09, 14.49)];
            [arrowleftPath addCurveToPoint: CGPointMake(0.03, 14.67) controlPoint1: CGPointMake(0.05, 14.58) controlPoint2: CGPointMake(0.04, 14.62)];
            [arrowleftPath addCurveToPoint: CGPointMake(0, 14.82) controlPoint1: CGPointMake(0.02, 14.72) controlPoint2: CGPointMake(0.01, 14.77)];
            [arrowleftPath addCurveToPoint: CGPointMake(0.01, 14.96) controlPoint1: CGPointMake(-0.01, 14.9) controlPoint2: CGPointMake(0.01, 14.93)];
            [arrowleftPath addCurveToPoint: CGPointMake(0.27, 15.74) controlPoint1: CGPointMake(-0.03, 15.27) controlPoint2: CGPointMake(0.06, 15.56)];
            [arrowleftPath addLineToPoint: CGPointMake(11.96, 25.35)];
            [arrowleftPath addCurveToPoint: CGPointMake(12.37, 25.5) controlPoint1: CGPointMake(12.08, 25.45) controlPoint2: CGPointMake(12.22, 25.5)];
            [arrowleftPath addCurveToPoint: CGPointMake(12.92, 25.19) controlPoint1: CGPointMake(12.58, 25.5) controlPoint2: CGPointMake(12.78, 25.39)];
            [arrowleftPath addCurveToPoint: CGPointMake(12.78, 24.13) controlPoint1: CGPointMake(13.14, 24.86) controlPoint2: CGPointMake(13.08, 24.38)];
            [arrowleftPath addLineToPoint: CGPointMake(2.8, 15.74)];
            [arrowleftPath addLineToPoint: CGPointMake(16.49, 15.74)];
            [arrowleftPath addCurveToPoint: CGPointMake(17.18, 15) controlPoint1: CGPointMake(16.49, 15.74) controlPoint2: CGPointMake(17.18, 15.75)];
            [arrowleftPath addCurveToPoint: CGPointMake(16.49, 14.26) controlPoint1: CGPointMake(17.18, 14.3) controlPoint2: CGPointMake(16.49, 14.26)];
            [arrowleftPath addLineToPoint: CGPointMake(2.8, 14.26)];
            [arrowleftPath closePath];
            [arrowleftPath moveToPoint: CGPointMake(19.24, 14.24)];
            [arrowleftPath addCurveToPoint: CGPointMake(18.56, 15) controlPoint1: CGPointMake(18.86, 14.24) controlPoint2: CGPointMake(18.56, 14.58)];
            [arrowleftPath addCurveToPoint: CGPointMake(19.24, 15.77) controlPoint1: CGPointMake(18.56, 15.42) controlPoint2: CGPointMake(18.86, 15.77)];
            [arrowleftPath addLineToPoint: CGPointMake(21.3, 15.77)];
            [arrowleftPath addCurveToPoint: CGPointMake(22, 15) controlPoint1: CGPointMake(21.68, 15.77) controlPoint2: CGPointMake(22, 15.42)];
            [arrowleftPath addCurveToPoint: CGPointMake(21.3, 14.24) controlPoint1: CGPointMake(22, 14.58) controlPoint2: CGPointMake(21.68, 14.24)];
            [arrowleftPath addLineToPoint: CGPointMake(19.24, 14.24)];
            [arrowleftPath closePath];
            arrowleftPath.usesEvenOddFillRule = YES;
            [fillColor setFill];
            [arrowleftPath fill];
        }
    }
    
    CGContextRestoreGState(context);

}

+ (void)drawNavAdd
{
    [StyleKitName drawNavAddWithFrame: CGRectMake(0, 0, 50, 30) resizing: StyleKitNameResizingBehaviorStretch];
}

+ (void)drawNavAddWithFrame: (CGRect)targetFrame resizing: (StyleKitNameResizingBehavior)resizing
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Resize to Target Frame
    CGContextSaveGState(context);
    CGRect resizedFrame = StyleKitNameResizingBehaviorApply(resizing, CGRectMake(0, 0, 50, 30), targetFrame);
    CGContextTranslateCTM(context, resizedFrame.origin.x, resizedFrame.origin.y);
    CGContextScaleCTM(context, resizedFrame.size.width / 50, resizedFrame.size.height / 30);


    //// Color Declarations
    UIColor* fillColor2 = [UIColor colorWithRed: 0.976 green: 0.976 blue: 0.976 alpha: 1];

    //// Page-1
    {
        //// detail-thumbnail
        {
            //// plus
            {
                //// Shape Drawing
                UIBezierPath* shapePath = [UIBezierPath bezierPath];
                [shapePath moveToPoint: CGPointMake(39, 4)];
                [shapePath addCurveToPoint: CGPointMake(38.31, 4.69) controlPoint1: CGPointMake(38.62, 4) controlPoint2: CGPointMake(38.31, 4.31)];
                [shapePath addLineToPoint: CGPointMake(38.31, 25.31)];
                [shapePath addCurveToPoint: CGPointMake(39, 26) controlPoint1: CGPointMake(38.31, 25.69) controlPoint2: CGPointMake(38.62, 26)];
                [shapePath addCurveToPoint: CGPointMake(39.69, 25.31) controlPoint1: CGPointMake(39.38, 26) controlPoint2: CGPointMake(39.69, 25.69)];
                [shapePath addLineToPoint: CGPointMake(39.69, 4.69)];
                [shapePath addCurveToPoint: CGPointMake(39, 4) controlPoint1: CGPointMake(39.69, 4.31) controlPoint2: CGPointMake(39.38, 4)];
                [shapePath closePath];
                [shapePath moveToPoint: CGPointMake(49.31, 14.31)];
                [shapePath addLineToPoint: CGPointMake(41.75, 14.31)];
                [shapePath addCurveToPoint: CGPointMake(41.06, 15) controlPoint1: CGPointMake(41.37, 14.31) controlPoint2: CGPointMake(41.06, 14.62)];
                [shapePath addCurveToPoint: CGPointMake(41.75, 15.69) controlPoint1: CGPointMake(41.06, 15.38) controlPoint2: CGPointMake(41.37, 15.69)];
                [shapePath addLineToPoint: CGPointMake(49.31, 15.69)];
                [shapePath addCurveToPoint: CGPointMake(50, 15) controlPoint1: CGPointMake(49.69, 15.69) controlPoint2: CGPointMake(50, 15.38)];
                [shapePath addCurveToPoint: CGPointMake(49.31, 14.31) controlPoint1: CGPointMake(50, 14.62) controlPoint2: CGPointMake(49.69, 14.31)];
                [shapePath closePath];
                [shapePath moveToPoint: CGPointMake(36.25, 14.31)];
                [shapePath addLineToPoint: CGPointMake(28.69, 14.31)];
                [shapePath addCurveToPoint: CGPointMake(28, 15) controlPoint1: CGPointMake(28.31, 14.31) controlPoint2: CGPointMake(28, 14.62)];
                [shapePath addCurveToPoint: CGPointMake(28.69, 15.69) controlPoint1: CGPointMake(28, 15.38) controlPoint2: CGPointMake(28.31, 15.69)];
                [shapePath addLineToPoint: CGPointMake(36.25, 15.69)];
                [shapePath addCurveToPoint: CGPointMake(36.94, 15) controlPoint1: CGPointMake(36.63, 15.69) controlPoint2: CGPointMake(36.94, 15.38)];
                [shapePath addCurveToPoint: CGPointMake(36.25, 14.31) controlPoint1: CGPointMake(36.94, 14.62) controlPoint2: CGPointMake(36.63, 14.31)];
                [shapePath closePath];
                shapePath.usesEvenOddFillRule = YES;
                [fillColor2 setFill];
                [shapePath fill];
            }
        }
    }
    
    CGContextRestoreGState(context);

}

#pragma mark Generated Images

+ (UIImage*)imageOfNavBack
{
    if (_imageOfNavBack)
        return _imageOfNavBack;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 30), NO, 0);
    [StyleKitName drawNavBack];

    _imageOfNavBack = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return _imageOfNavBack;
}

+ (UIImage*)imageOfNavAdd
{
    if (_imageOfNavAdd)
        return _imageOfNavAdd;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 30), NO, 0);
    [StyleKitName drawNavAdd];

    _imageOfNavAdd = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return _imageOfNavAdd;
}

#pragma mark Customization Infrastructure

- (void)setNavBackTargets: (NSArray*)navBackTargets
{
    _navBackTargets = navBackTargets;

    for (id target in navBackTargets)
        [target performSelector: @selector(setImage:) withObject: StyleKitName.imageOfNavBack];
}

- (void)setNavAddTargets: (NSArray*)navAddTargets
{
    _navAddTargets = navAddTargets;

    for (id target in navAddTargets)
        [target performSelector: @selector(setImage:) withObject: StyleKitName.imageOfNavAdd];
}


@end



CGRect StyleKitNameResizingBehaviorApply(StyleKitNameResizingBehavior behavior, CGRect rect, CGRect target)
{
    if (CGRectEqualToRect(rect, target) || CGRectEqualToRect(target, CGRectZero))
        return rect;

    CGSize scales = CGSizeZero;
    scales.width = ABS(target.size.width / rect.size.width);
    scales.height = ABS(target.size.height / rect.size.height);

    switch (behavior)
    {
        case StyleKitNameResizingBehaviorAspectFit:
        {
            scales.width = MIN(scales.width, scales.height);
            scales.height = scales.width;
            break;
        }
        case StyleKitNameResizingBehaviorAspectFill:
        {
            scales.width = MAX(scales.width, scales.height);
            scales.height = scales.width;
            break;
        }
        case StyleKitNameResizingBehaviorStretch:
            break;
        case StyleKitNameResizingBehaviorCenter:
        {
            scales.width = 1;
            scales.height = 1;
            break;
        }
    }

    CGRect result = CGRectStandardize(rect);
    result.size.width *= scales.width;
    result.size.height *= scales.height;
    result.origin.x = target.origin.x + (target.size.width - result.size.width) / 2;
    result.origin.y = target.origin.y + (target.size.height - result.size.height) / 2;
    return result;
}