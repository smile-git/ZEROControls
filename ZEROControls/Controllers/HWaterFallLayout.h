//
//  HWaterFallLayout.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWaterFallManager.h"

@protocol HWaterFallLayoutDelegate <NSObject>

- (CGFloat)itemHeightWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface HWaterFallLayout : UICollectionViewLayout

@property (nonatomic, strong) HWaterFallManager           *hManager;
@property (nonatomic, weak)   id<HWaterFallLayoutDelegate> delegate;
@end

