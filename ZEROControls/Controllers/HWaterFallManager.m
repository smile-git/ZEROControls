//
//  HWaterFallManager.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "HWaterFallManager.h"

@interface HWaterFallManager()

@property (nonatomic, strong) NSMutableArray *elements;
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, strong) NSMutableArray *currentColumnYValues;
@end

@implementation HWaterFallManager

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.elements             = [NSMutableArray arrayWithCapacity:0];
        self.frames               = [NSMutableArray arrayWithCapacity:0];
        self.currentColumnYValues = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)reset{
    
    [self.elements             removeAllObjects];
    [self.frames               removeAllObjects];
    [self.currentColumnYValues removeAllObjects];
    
    [self prepare];
}

- (void)prepare{
    
    for (int idx = 0; idx < _columnWidths.count; idx ++) {
        
        [self.currentColumnYValues addObject:@(_edgeInsets.top)];
    }
}

- (CGSize)contentSize{
    
    CGFloat width  = 0;
    CGFloat height = 0;
    
    
    for (int idx = 0; idx < _currentColumnYValues.count; idx ++) {
        
        CGFloat currentY = [_currentColumnYValues[idx] floatValue];
        height < currentY ? height = currentY : 0;
    }
    
    height += _edgeInsets.bottom;
    width = [self xPositionByColumn:_columnWidths.count - 1] + [_columnWidths.lastObject floatValue] + _edgeInsets.right;
    
    return CGSizeMake(width, height);
}


- (void)addElement:(NSNumber *)height{
    
    [_elements addObject:height];
    
    CGFloat minY        = CGFLOAT_MAX;
    NSInteger minColumn = 0;
    
    //找到高度最低的那一列
    for (int idx = 0; idx < _currentColumnYValues.count; idx ++) {
        
        CGFloat currentY = [_currentColumnYValues[idx] floatValue];
        
        if (minY > currentY) {
            
            minY      = currentY;
            minColumn = idx;
        }
    }
    
    CGRect frame = CGRectMake([self xPositionByColumn:minColumn], minY == 0 ? minY : (minY += _gap), [_columnWidths[minColumn] floatValue], [height floatValue]);
    
    //添加
    [_frames addObject:NSStringFromCGRect(frame)];
    //替换
    [_currentColumnYValues replaceObjectAtIndex:minColumn withObject:@(minY + height.floatValue)];
}

- (CGFloat)xPositionByColumn:(NSInteger)column{
    
    CGFloat x = 0;
    
    for (int idx = 0; idx < column + 1; idx ++) {
        
        if (idx == 0) {
            x = _edgeInsets.left;
            continue;
        }
        
        x += [_columnWidths[idx - 1] floatValue] + _gap;
    }
    
    return x;
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



