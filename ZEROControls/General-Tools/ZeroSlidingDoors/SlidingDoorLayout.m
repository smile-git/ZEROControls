//
//  SlidingDoorLayout.m
//  SlidingDoorCollectoinView
//
//  Created by ZWX on 2017/6/27.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "SlidingDoorLayout.h"
#import "SlidingDoorCell.h"


static const CGFloat maxRatio = 6;
static const CGFloat minRatio = 1.5;

@interface SlidingDoorLayout ()

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) CGFloat minHeight;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@implementation SlidingDoorLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.type = SlidingDoorTypeTwo;
    }
    return self;
}

- (void)prepareLayout {
    
    [super prepareLayout];
    
    self.itemCount  = [self.collectionView numberOfItemsInSection:0];
    self.minHeight  = self.collectionView.bounds.size.width / maxRatio;
    self.maxHeight  = self.collectionView.bounds.size.width / minRatio;
    self.cellHeight = self.maxHeight * 0.5 + self.minHeight * 0.5;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    // ----- 判定为布局需要被无效化并重新计算的时候,布局对象会被询问以提供新的布局。
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *layoutAttributes = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < self.itemCount; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [layoutAttributes addObject:attributes];
    }
    
    [self layoutSubviewsWithAttributes:layoutAttributes];
    
    return layoutAttributes;
}

-(void)layoutSubviewsWithAttributes:(NSMutableArray *)attributes {
    
    [attributes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SlidingDoorCell *cell = (SlidingDoorCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        
        CGFloat currentIndex = self.collectionView.contentOffset.y / self.cellHeight;
        CGFloat ratio = cell.bounds.size.width / cell.bounds.size.height;
        CGFloat maxDiff = maxRatio - minRatio;
        CGFloat diff = maxRatio - ratio;
        
        CGFloat alpha = diff / maxDiff;
        
        if (self.type == SlidingDoorTypeOne) {
            
            cell.overlayView.alpha = 1 - alpha;
            cell.titleLabel.alpha = alpha;
        } else {
            
            cell.overlayView.alpha = 1 - alpha;
            cell.titleLabel.alpha = alpha;
            cell.subtitleLabel.alpha = alpha;
            
            if (idx > currentIndex) {
                
                cell.titleLabel.transform = CGAffineTransformMakeScale(1 - (1 - alpha) * 0.3, 1 - (1 - alpha) * 0.3);
                cell.subtitleLabel.transform = CGAffineTransformMakeTranslation(0, (1 - alpha) * 30);
            } else {
                
                cell.titleLabel.transform = CGAffineTransformIdentity;
                cell.subtitleLabel.transform = CGAffineTransformIdentity;
            }
        }

    }];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat currentIndex = self.collectionView.contentOffset.y / self.cellHeight;
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.center = CGPointMake(self.collectionView.center.x, self.maxHeight * 0.5);
    
    CGAffineTransform translationT;
    
    CGFloat endTranslateOffset = 0;
    CGFloat endFactor = (self.collectionView.bounds.size.height - self.maxHeight) / self.minHeight;
    
    // ----- 这儿是滑到最后的计算
    if (currentIndex + 1 > (self.itemCount - endFactor))  {
        
        CGFloat valA = (currentIndex + 1 - (self.itemCount - endFactor));
        CGFloat valB = valA / endFactor;
        endTranslateOffset = (self.collectionView.bounds.size.height - self.maxHeight) * valB;
    }
    
    
    if (fabs(indexPath.item - currentIndex) >= (endFactor + 1)) {
        // ----- 这个判断，防止不在屏幕内的item乱入
        if (endTranslateOffset <= 0.0) {
            // ----- 加这个判断，防止在滑到最后时继续往上滑，顶部item会消失
            return attributes;
        }
    }
    
    if(indexPath.item > floor(currentIndex) && indexPath.item <= floor(currentIndex) + 1 ){
        
        CGFloat factorY    = floor(currentIndex) + 1 - currentIndex;
        CGFloat factorSize = fabs(1 - factorY);
        
        attributes.size = CGSizeMake(self.collectionView.bounds.size.width, self.minHeight + (factorSize * (self.maxHeight - self.minHeight) ));
        translationT = CGAffineTransformMakeTranslation(0 ,endTranslateOffset + self.collectionView.contentOffset.y + self.cellHeight * factorY);
    }
    else if(indexPath.item > floor(currentIndex) + 1){
        
        translationT = CGAffineTransformMakeTranslation(0 , endTranslateOffset+ self.collectionView.contentOffset.y +self.cellHeight +  (self.minHeight * fmax(0, ((float)indexPath.item-currentIndex-1))) );
        attributes.size = CGSizeMake(self.collectionView.bounds.size.width, self.minHeight);
    }
    else if (indexPath.item <= floor(currentIndex) && indexPath.item > floor(currentIndex) - 1){
        
        CGFloat factorY    = 1 - (floor(currentIndex) + 1 - currentIndex);
        CGFloat factorSize = fabs(1 - factorY);
        
        attributes.size = CGSizeMake(self.collectionView.bounds.size.width, self.minHeight + (factorSize * (self.maxHeight - self.minHeight) ));
        translationT = CGAffineTransformMakeTranslation(0 , endTranslateOffset + self.collectionView.contentOffset.y - self.cellHeight * factorY);
    }
    else {

        if ((self.itemCount - indexPath.item) <= (endFactor + 2)) {
            // ----- 这个判断，防止不在屏幕内的item乱入（下拉）
            attributes.size = CGSizeMake(self.collectionView.bounds.size.width, self.minHeight);
            translationT = CGAffineTransformMakeTranslation(0 , endTranslateOffset + self.collectionView.contentOffset.y - self.cellHeight +  (self.minHeight * fmin(0, ((float)indexPath.item-currentIndex+1))));
        }
    }
    attributes.transform = translationT;
    attributes.zIndex = 1;
    
    return attributes;
}

- (CGSize)collectionViewContentSize{
    
    const CGSize theSize = {
        
        .width  = self.collectionView.bounds.size.width,
        .height = (self.itemCount - 1) * self.cellHeight + self.collectionView.bounds.size.height,
    };
    return(theSize);
}

@end
