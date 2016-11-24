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

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray * original = [super layoutAttributesForElementsInRect:rect];
    NSArray * array    = [[NSArray alloc] initWithArray:original copyItems:YES];
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    UIEdgeInsets sectionInset = self.sectionInset;
    
    BOOL isFirstItemInSection = indexPath.item == 0;
    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
    
    if (isFirstItemInSection) {
        CGRectMake(sectionInset.left, currentItemAttributes.frame.origin.y, currentItemAttributes.frame.size.width, currentItemAttributes.frame.size.height);
        return currentItemAttributes;
    }
    
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(sectionInset.left,
                                              currentFrame.origin.y,
                                              layoutWidth,
                                              currentFrame.size.height);
    // if the current frame, once left aligned to the left and stretched to the full collection view
    // widht intersects the previous frame then they are on the same line
    BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
    
    if (isFirstItemInRow) {
        // make sure the first item on a line is left aligned
        currentItemAttributes.frame = CGRectMake(sectionInset.left + currentItemAttributes.frame.origin.x, currentItemAttributes.frame.origin.y, currentItemAttributes.frame.size.width, currentItemAttributes.frame.size.height);
        return currentItemAttributes;
    }
    
    CGRect frame = currentItemAttributes.frame;
    frame.origin.x = previousFrameRightPoint + [self.siftManager minimumInteritemSpacingWithSection:indexPath.section];
    currentItemAttributes.frame = frame;
    return currentItemAttributes;
}

@end
