//
//  COBezierTableView.m
//  COBezierTableViewDemo
//
//  Created by ZWX on 2016/11/10.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ZEROBezierTableView.h"

@implementation ZEROBezierTableView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self updateBezierPointsIfNeeded:[UIScreen mainScreen].bounds];
    [self layoutVisibleCells];
}


- (void)layoutVisibleCells
{
    NSArray *indexpaths;
    if (!(indexpaths = [self indexPathsForVisibleRows])) {
        return;
    }
    
    NSInteger totalVisibleCells = indexpaths.count;
    if (totalVisibleCells <= 0) {
        return;
    }
    
    for (int index = 0; index < totalVisibleCells; index ++) {
        NSIndexPath *indexPath = indexpaths[index];
        
        UITableViewCell *cell = cell = [self cellForRowAtIndexPath:indexPath];
        if (cell) {
            CGRect frame = cell.frame;
            
            UIView *superView = self.superview;
            if (superView) {
                CGPoint point = [self convertPoint:frame.origin toView:superView];
                CGFloat pointScale = point.y / (CGFloat)superView.bounds.size.height;
                frame.origin.x = [self bezierXFor:pointScale];
            }
            cell.frame = frame;
        }
    }
}

- (void)updateBezierPointsIfNeeded:(CGRect)frame
{
    CGFloat height = frame.size.height;
    CGFloat itemHeight = height / 3.0;
    
    if (CGPointEqualToPoint(_points.p1, CGPointZero) && CGPointEqualToPoint(_points.p2, CGPointZero) && CGPointEqualToPoint(_points.p3, CGPointZero) && CGPointEqualToPoint(_points.p4, CGPointZero)) {
        _points.p1 = CGPointMake( - NavHeight, 0);
        _points.p2 = CGPointMake(itemHeight, itemHeight);
        _points.p3 = CGPointMake(itemHeight, itemHeight * 2);
        _points.p4 = CGPointMake( - NavHeight, height);
    }
}

- (CGPoint)bezierStaticPoint:(NSInteger)index
{
    switch (index) {
        case 0:
            return _points.p1;
            break;
        case 2:
            return _points.p2;
            break;
        case 3:
            return _points.p3;
            break;
        case 4:
            return _points.p4;
            break;
        default:
            return CGPointZero;
            break;
    }
}

- (void)setBezierStaticPoint:(CGPoint)point forIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            _points.p1 = point;
            break;
        case 2:
            _points.p2 = point;
            break;
        case 3:
            _points.p3 = point;
            break;
        case 4:
            _points.p4 = point;
            break;
        default:
            break;
    }
}

- (CGFloat)bezierInterpolation:(CGFloat)t a:(CGFloat)a b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d
{
    CGFloat t2 = t * t;
    CGFloat t3 = t2 * t;
    //不要问我这算法怎么来的，我也不知道。。。。。（ps：这程序最重要的就是这个，计算坐标）
    return (a + (-a * 3 + t * (3 * a - a * t)) * t + (3 * b + t * (-6 * b + b * 3 * t)) * t + (c * 3 - c * 3 * t) * t2 + d * t3);
}

- (CGFloat)bezierXFor:(CGFloat)t
{
    return [self bezierInterpolation:t a:_points.p1.x b:_points.p2.x c:_points.p3.x d:_points.p4.x];
}

- (CGFloat)bezierYFor:(CGFloat)t
{
    return [self bezierInterpolation:t a:_points.p1.y b:_points.p2.y c:_points.p3.y d:_points.p4.y];
}

- (CGPoint)bezierPointFor:(CGFloat)t
{
    return CGPointMake([self bezierXFor:t], [self bezierYFor:t]);
}
@end
