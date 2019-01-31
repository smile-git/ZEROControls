//
//  MarqueeLayoutH.h
//  MarqueeControl
//
//  Created by ZWX on 2019/1/16.
//  Copyright © 2019 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MarqueeLayoutHManager;

NS_ASSUME_NONNULL_BEGIN

@protocol MarqueeLayoutHDelegate <NSObject>

@required
- (CGFloat)itemWidthWithIndexPath:(NSIndexPath *)indexPath;

@end


@interface MarqueeLayoutH : UICollectionViewLayout

@property (nonatomic, strong) MarqueeLayoutHManager *mManager;

@property (nonatomic, weak) id<MarqueeLayoutHDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
