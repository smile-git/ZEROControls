//
//  WWaterFallLayout.h
//  WWaterFall
//
//  Created by ZWX on 2016/11/19.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWaterFallManager.h"

@protocol WWaterFallLayoutDelegate <NSObject>

@required

- (CGFloat)itemWidthWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface WWaterFallLayout : UICollectionViewLayout

@property (nonatomic, strong) WWaterFallManager            *manager;
@property (nonatomic, weak)   id<WWaterFallLayoutDelegate> delegate;
@end
