//
//  CircleCell.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/22.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleCell : UICollectionViewCell

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)loadContent;

@end
