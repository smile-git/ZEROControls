//
//  MDMatrix.m
//  ZEROControls
//
//  Created by ZWX on 2021/3/29.
//  Copyright © 2021 ZWX. All rights reserved.
//

#import "MDMatrix.h"

@interface MDMatrix() {
    char *_data;
}
@end

@implementation MDMatrix

- (instancetype)initWithMaxX:(size_t)x maxY:(size_t)y {
    
    if (self = [super init]) {
        _data = (char *)malloc(x * y);
        _max = MDSizeMake(x, y);
        [self fillWithValue:0];
    }
    return self;
}

- (instancetype)initWithMax:(MDSize)msxCoords {
    
    return [self initWithMaxX:msxCoords.x maxY:msxCoords.y];
}

#pragma mark -

- (char)valueForCoordinates:(size_t)x y:(size_t)y {
    
    long index = x + self.max.x * y;
    if (index >= self.max.x * self.max.y) {
        return 1;
    } else {
        return _data[x + self.max.x * y];
    }
}

- (void)setValue:(char)value forCoordinates:(size_t)x y:(size_t)y {
    
    long index = x + self.max.x * y;
    if (index < self.max.x * self.max.y) {
        
        _data[x + self.max.x * y] = value;
    }
}

- (void)fillWithValue:(char)value {
    
    char *temp = _data;
    for (size_t i = 0; i < self.max.x * self.max.y; i++) {
        *temp = value;
        temp++;
    }
}

#pragma mark -

- (void)dealloc {
    
    if (_data) {
        free(_data);
    }
}

@end
