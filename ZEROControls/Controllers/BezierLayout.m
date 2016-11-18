//
//  BezierLayout.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/18.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "BezierLayout.h"

@implementation BezierLayout{
    
    BOOL shouldSnap;
    BOOL shouldFlip;
    CGPoint lastVelocity;
}


- (id)init{
    
    if ((self = [super init])){
        
        shouldSnap = NO;
        shouldFlip = NO;
        self.offset = 0.0f;
    }
    return self;
}

- (instancetype)initWithRadius:(CGFloat)radius angularSpacing:(CGFloat)spacing cellSize:(CGSize)cell itemHeight:(CGFloat)height xOffset:(CGFloat)xOffset{
    
    if (self = [super init]) {
        
        self.offset = 0.0f;
        shouldSnap = NO;
        shouldFlip = NO;
        
        self.dialRadius = radius;
        self.cellSize = cell;
        self.itemHeight = height;
        self.AngularSpacing = spacing;
        self.xOffset = xOffset;
    }
    return self;
}

- (void)prepareLayout{
    
    [super prepareLayout];
    self.cellCount = [self.collectionView numberOfItemsInSection:0];
    self.offset    = - self.collectionView.contentOffset.y / self.itemHeight;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *layoutAttribute = [NSMutableArray array];
    
    int maxVisiblesHalf = 180 / self.AngularSpacing;

    
    return layoutAttribute;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
