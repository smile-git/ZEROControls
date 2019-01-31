//
//  MarqueeCell.h
//  MarqueeControl
//
//  Created by ZWX on 2019/1/14.
//  Copyright © 2019 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MarqueeModel;

NS_ASSUME_NONNULL_BEGIN

@interface MarqueeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@property (nonatomic, strong) MarqueeModel *dataModel;

- (void)loadContent;
- (void)contentOffset:(CGPoint)point;

- (void)willDisplay;
- (void)didEndDisplaying;
@end

NS_ASSUME_NONNULL_END
