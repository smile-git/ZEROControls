//
//  SlidingDoorCell.h
//  SlidingDoorCollectoinView
//
//  Created by ZWX on 2017/6/27.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingDoorCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
