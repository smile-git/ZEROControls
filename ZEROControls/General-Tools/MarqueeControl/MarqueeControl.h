//
//  MarqueeControl.h
//  MarqueeControl
//
//  Created by ZWX on 2019/1/11.
//  Copyright © 2019 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MarqueeModel;

NS_ASSUME_NONNULL_BEGIN

@interface MarqueeControl : UIView


@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic, strong) NSMutableArray <MarqueeModel *>*models;
@property (nonatomic, strong) UIColor *textColor;

- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection)scrollDirection models:(NSArray *)models;


- (void)startLoopAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
