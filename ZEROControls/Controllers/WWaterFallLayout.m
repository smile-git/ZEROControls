//
//  WWaterFallLayout.m
//  WWaterFall
//
//  Created by ZWX on 2016/11/19.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "WWaterFallLayout.h"

@interface WWaterFallLayout()

@property (nonatomic, strong) NSMutableArray *attributes;

@end

@implementation WWaterFallLayout

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.attributes = [NSMutableArray array];
        self.manager    = [[WWaterFallManager alloc] init];
    }
    return self;
}

- (void)prepareLayout{
    
    [super prepareLayout];
    
    [self.manager reset];
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (int idx = 0; idx < itemCount; idx ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [self.attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat itemWidth = 0;
    //获取item的宽度
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemWidthWithIndexPath:)]) {
        itemWidth = [self.delegate itemWidthWithIndexPath:indexPath];
    }
    
    //获取item的frame
    [self.manager addElement:@(itemWidth)];
    
    attributes.frame = [self.manager frameAtIndex:indexPath.item];
    
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *layoutAttribures = [NSMutableArray arrayWithCapacity:0];
    
    [self.attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (CGRectIntersectsRect(obj.frame, rect)) {
            
            [layoutAttribures addObject:obj];
        }
    }];
    
    return layoutAttribures;
}

- (CGSize)collectionViewContentSize{
    
    return self.manager.contentSize;
}
@end






