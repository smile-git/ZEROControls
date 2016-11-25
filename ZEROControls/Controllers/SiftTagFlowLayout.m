//
//  SiftTagFlowLayout.m
//  SiftTag
//
//  Created by ZWX on 2016/11/25.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "SiftTagFlowLayout.h"

@implementation SiftTagFlowLayout

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.siftManager = [[SiftTagManager alloc] init];
    }
    return self;
}

#pragma mark - UICollectionViewLayout

- (void)prepareLayout{
    
    [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *original = [super layoutAttributesForElementsInRect:rect];
    NSArray *array    = [[NSArray alloc] initWithArray:original copyItems:YES];
    
    [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *_Nonnull attributes, NSUInteger idx, BOOL *_Nonnull stop) {
        
        if (attributes.representedElementKind == nil) {
            
            NSIndexPath *indexPath  = attributes.indexPath;
            attributes.frame        = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }];
    
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIEdgeInsets sectionInset                        = self.sectionInset;
    UICollectionViewLayoutAttributes* itemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    BOOL isFirstItemInSection                        = indexPath.item == 0;     //判断是否是此section的第一个item
    
    //容器宽度，最大长度
    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
    
    if (isFirstItemInSection) {

        return itemAttributes;
    }
    
    //上一个tag的 indexPath、frame、最右点、
    NSIndexPath *previousIndexPath  = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect  previousFrame           = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
    CGRect  currentFrame            = itemAttributes.frame;
    CGRect  strecthedCurrentFrame   = CGRectMake(sectionInset.left, currentFrame.origin.y, layoutWidth, currentFrame.size.height);

    //是否是此行的第一个tag
    BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
    
    if (isFirstItemInRow) {

        itemAttributes.frame = CGRectMake(sectionInset.left + itemAttributes.frame.origin.x, itemAttributes.frame.origin.y, itemAttributes.frame.size.width, itemAttributes.frame.size.height);
        return itemAttributes;
    }
    
    CGRect frame         = itemAttributes.frame;
    frame.origin.x       = previousFrameRightPoint + [self.siftManager minimumInteritemSpacingWithSection:indexPath.section];
    itemAttributes.frame = frame;
    return itemAttributes;
}

@end
