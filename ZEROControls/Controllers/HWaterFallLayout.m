//
//  HWaterFallLayout.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "HWaterFallLayout.h"

@interface HWaterFallLayout()

@property (nonatomic, strong) NSMutableArray *attributes;

@end

@implementation HWaterFallLayout

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.hManager   = [[HWaterFallManager alloc] init];
        self.attributes = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)prepareLayout{
    
    [super prepareLayout];
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];

    if (itemCount <= 10 || self.attributes.count == 0) {
        [self.attributes removeAllObjects];
        [self.hManager reset];
    }
    
    for (NSInteger idx = self.attributes.count; idx < itemCount; idx ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        
        [self.attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *layoutAttribures = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat height = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemHeightWithIndexPath:)]) {
        
        height = [self.delegate itemHeightWithIndexPath:indexPath];
    }
    
    [self.hManager addElement:@(height)];
    
    layoutAttribures.frame = [self.hManager frameAtIndex:indexPath.item];
    
    return layoutAttribures;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *layoutAttribures = [NSMutableArray arrayWithCapacity:0];
    [_attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (CGRectIntersectsRect(obj.frame, rect)) {
            
            [layoutAttribures addObject:obj];
        }
    }];
    
    return layoutAttribures;

}

- (CGSize)collectionViewContentSize{
    
    return _hManager.contentSize;
}

@end
