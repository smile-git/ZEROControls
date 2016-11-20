//
//  HWaterFallCell.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWaterFallCell : UICollectionViewCell

@property (nonatomic)       CGFloat     columnWidth;
@property (nonatomic, weak) id          data;
@property (nonatomic, weak) NSIndexPath *indexPath;

- (void)loadContent;


@end
