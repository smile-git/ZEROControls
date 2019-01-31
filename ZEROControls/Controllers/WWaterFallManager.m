//
//  WWaterFallManager.m
//  WWaterFall
//
//  Created by ZWX on 2016/11/19.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "WWaterFallManager.h"

@interface WWaterFallManager()

@property (nonatomic, strong) NSMutableArray *elements;
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, strong) NSMutableArray *currentRowXValues;
@end

@implementation WWaterFallManager

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.currentRowXValues  = [NSMutableArray arrayWithCapacity:0];
        self.elements           = [NSMutableArray arrayWithCapacity:0];
        self.frames             = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)reset{
    
    [self.currentRowXValues removeAllObjects];
    [self.elements          removeAllObjects];
    [self.frames            removeAllObjects];
    
    [self prepare];
}

/**
 准备工作，每行首个item的起始位置
 */
- (void)prepare{
    
    for (int idx = 0; idx < _itemHeights.count; idx ++) {
        
        [self.currentRowXValues addObject:@(_edgeInsets.left)];
    }
}

- (CGSize)contentSize{
    
    CGFloat width  = 0;
    CGFloat height = 0;
    
    for (int idx = 0; idx < _currentRowXValues.count; idx ++) {
        
        CGFloat currentX = [_currentRowXValues[idx] floatValue];
        width < currentX ? width = currentX : 0;
    }
    
    width += _edgeInsets.right;
    height = [self yPositionByRow:_itemHeights.count] + _edgeInsets.bottom - _gap;
    
    return CGSizeMake(width, height);
}


- (void)addElement:(NSNumber *)width{
    
    [_elements addObject:width];
    
    CGFloat minX     = CGFLOAT_MAX;
    NSInteger minRow = 0;
    
    for (NSInteger idx = 0; idx < _currentRowXValues.count; idx ++) {
        
        CGFloat currentX = [_currentRowXValues[idx] floatValue];
        if (minX > currentX) {
            
            minX   = currentX;
            minRow = idx;
        }
    }
    
    CGRect frame = CGRectMake(minX == _edgeInsets.left ? minX : (minX += _gap), [self yPositionByRow:minRow], width.floatValue, _itemHeights[minRow].floatValue);
    
    [_frames addObject:NSStringFromCGRect(frame)];
    [_currentRowXValues replaceObjectAtIndex:minRow withObject:@(minX + width.floatValue)];

}


/**
 计算每行y坐标
 @param row 行数
 @return y
 */
- (CGFloat)yPositionByRow:(NSInteger)row{
    
    CGFloat y = _edgeInsets.top;
    
    for (int idx = 0; idx < row; idx++) {
        
        y += [_itemHeights[idx] floatValue] + _gap;
    }
    
    return y;
}


- (NSArray *)allElements{
    
    return _elements;
}

- (NSArray *)allFrames{
    
    return _frames;
}

- (CGRect)frameAtIndex:(NSInteger)index{
    
    return CGRectFromString(_frames[index]);
}
@end
