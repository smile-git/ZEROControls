//
//  CircleLayout.m
//  BezierCollectionView
//
//  Created by ZWX on 2016/11/21.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "CircleLayout.h"

@implementation CircleLayout{
    
    BOOL shouldSnap;
    CGPoint lastVelocity;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.offset     = 0.0;
        shouldSnap      = YES;
    }
    return self;
}

- (instancetype)initWithRadius:(CGFloat)dialRadius angularSpacing:(CGFloat)angularSpacing cellSize:(CGSize)itemSize xOffset:(CGFloat)xOffset{
    
    if (self = [super init]) {
        
        self.dialRadius     = dialRadius;
        self.itemSize       = itemSize;
        self.angularSpacing = angularSpacing;
        self.xOffset        = xOffset;
        
        shouldSnap          = NO;
        self.offset         = 0.0;

    }
    return self;
}

- (void)prepareLayout{
    
    [super prepareLayout];
    
    self.offset    = -self.collectionView.contentOffset.y / self.itemSize.height;
    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    layoutAttributes.frame = [self getRectForItem:indexPath.item];
    
    return layoutAttributes;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *layoutAttributes = [NSMutableArray arrayWithCapacity:0];
    
    int maxVisiblesHalf = 180 / self.angularSpacing;
    
    for( int idx = 0; idx < self.itemCount; idx ++ ){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];

        if(CGRectIntersectsRect(rect, attribute.frame) && idx > ( -1 * self.offset - maxVisiblesHalf) && idx < ( -1 * self.offset + maxVisiblesHalf)){
            
            [layoutAttributes addObject:attribute];
        }
    }
    
    return layoutAttributes;
}

- (CGRect)getRectForItem:(NSInteger)item{
    
    double newIndex = (item + self.offset);
    CGFloat deltaX  = self.itemSize.width;
    CGFloat deltaY  = self.itemSize.height;
    
    float rX = cosf(self.angularSpacing * newIndex * M_PI / 180) * (self.dialRadius + deltaX);
    float rY = sinf(self.angularSpacing * newIndex * M_PI / 180) * (self.dialRadius + deltaY);
    float oX = self.xOffset - (self.dialRadius + deltaX);
    float oY = self.collectionView.height/2 + self.collectionView.contentOffset.y - deltaY / 2;
    
    CGRect itemFrame = CGRectMake(oX + rX, oY + rY, self.itemSize.width, self.itemSize.height);
    
    return itemFrame;
}

- (CGSize)collectionViewContentSize{
    
    const CGSize theSize = {
        
        .width  = self.collectionView.bounds.size.width,
        .height = (self.itemCount - 1) * self.itemSize.height + self.collectionView.bounds.size.height,
    };
    return(theSize);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    if(shouldSnap){
        
        int index = (int)floor(proposedContentOffset.y / (int)self.itemSize.height);
        int off   = ((int)proposedContentOffset.y % (int)self.itemSize.height);
        
        CGFloat targetY = (off > self.itemSize.height * 0.5 && index <= self.itemCount)? (index += 1) * self.itemSize.height: index * self.itemSize.height;
        return CGPointMake(proposedContentOffset.x, targetY );
        
    }else{
        
        return proposedContentOffset;
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


@end
