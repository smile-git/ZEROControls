//
//  MarqueeLayoutH.m
//  MarqueeControl
//
//  Created by ZWX on 2019/1/16.
//  Copyright © 2019 ZWX. All rights reserved.
//

#import "MarqueeLayoutH.h"
#import "MarqueeLayoutHManager.h"

@interface MarqueeLayoutH()

@property (nonatomic, strong)NSMutableArray *attributes;

@end

@implementation MarqueeLayoutH

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.mManager = [[MarqueeLayoutHManager alloc] init];
        self.attributes = [NSMutableArray array];
    }
    return self;
}

- (void)prepareLayout {
    
    [super prepareLayout];
    [self.mManager reset];
    
    NSInteger sectionCount = self.collectionView.numberOfSections;
    
    for (NSInteger section = 0; section < sectionCount; section ++) {
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            [self.attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat itemWidth = 0.f;
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemWidthWithIndexPath:)]) {
        itemWidth = [self.delegate itemWidthWithIndexPath:indexPath];
    }
    
    [self.mManager addElement:@(itemWidth)];
    
    layoutAttributes.frame = [self.mManager frameAtIndex:indexPath.item];
    
    return layoutAttributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    [self.attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (CGRectIntersectsRect(obj.frame, rect)) {
            [layoutAttributes addObject:obj];
        }
    }];
    
    return layoutAttributes;
}

- (CGSize)collectionViewContentSize {
    
    return self.mManager.conetentSize;
}

@end
