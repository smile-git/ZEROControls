//
//  MarqueeLayoutHManager.m
//  MarqueeControl
//
//  Created by ZWX on 2019/1/16.
//  Copyright © 2019 ZWX. All rights reserved.
//

#import "MarqueeLayoutHManager.h"

@interface MarqueeLayoutHManager()

@property (nonatomic, strong) NSMutableArray *elements;
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, strong) NSMutableArray <NSNumber *>*currentRowXValues;

@end

@implementation MarqueeLayoutHManager

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.elements = [NSMutableArray array];
        self.frames = [NSMutableArray array];
        self.currentRowXValues = [NSMutableArray array];
    }
    return self;
}

#pragma mark - ---- Public Method ----
- (void)reset {
    
    [self.elements removeAllObjects];
    [self.frames removeAllObjects];
    [self.currentRowXValues removeAllObjects];
    
    [self prepare];
}


- (CGSize)conetentSize {
    
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    for (int index = 0; index < _currentRowXValues.count; index ++) {
        
        CGFloat currentX = [_currentRowXValues[index] floatValue];
        width < currentX ? width = currentX : width;
    }
    
    width += _edgeInsets.left;
    height = [self yPositionByRow:_currentRowXValues.count] + _edgeInsets.bottom - _gap;
    
    return CGSizeMake(width, height);
}

// 此方法，添加最新的宽度。
// 找到最窄的row，更新frame数组，更新当前row的X值
- (void)addElement:(NSNumber *)width {
    
    [_elements addObject:width];
    
    CGFloat minX = CGFLOAT_MAX;
    NSInteger minRow = 0;
    
    for (NSInteger index = 0; index < _currentRowXValues.count; index ++) {
        
        CGFloat currentX = _currentRowXValues[index].floatValue;
        if (minX > currentX) {
            
            minX = currentX;
            minRow = index;
        }
    }
    
    CGRect frame = CGRectMake(minX == _edgeInsets.left ? minX : (minX += _gap), [self yPositionByRow:minRow], width.floatValue, _itemHeights[minRow].floatValue);
    
    [_frames addObject:NSStringFromCGRect(frame)];
    [_currentRowXValues replaceObjectAtIndex:minRow withObject:@(minX + width.floatValue)];
}

- (NSArray *)allFrames {
    
    return _frames;
}

- (NSArray *)allElements {
    
    return _elements;
}

- (CGRect)frameAtIndex:(NSInteger)index {
    
    return CGRectFromString(_frames[index]);
}


#pragma mark - ---- Private Method ----

// 准备工作，每行首个item的起始位置
- (void)prepare {
    
    for (NSInteger index = 0; index < _itemHeights.count; index ++) {
        
        [self.currentRowXValues addObject:@(_edgeInsets.left)];
    }
}

- (CGFloat)yPositionByRow:(NSInteger)row {
    
    CGFloat y = _edgeInsets.top;
    
    for (NSInteger index = 0; index < row; index ++) {
        
        y += [_itemHeights[index] floatValue] + _gap;
    }
    return y;
}
@end
