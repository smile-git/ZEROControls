//
//  MDMatrix.h
//  ZEROControls
//
//  Created by ZWX on 2021/3/29.
//  Copyright © 2021 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    size_t x;
    size_t y;
}MDSize;

static MDSize MDSizeMake(size_t x, size_t y) {
    MDSize r = {x, y};
    return r;
}

@interface MDMatrix : NSObject

- (instancetype)initWithMaxX:(size_t)x maxY:(size_t)y;
- (instancetype)initWithMax:(MDSize)msxCoords;

- (char)valueForCoordinates:(size_t)x y:(size_t)y;
- (void)setValue:(char)value forCoordinates:(size_t)x y:(size_t)y;

- (void)fillWithValue:(char)value;

@property (nonatomic, assign) MDSize max;

@end

NS_ASSUME_NONNULL_END
