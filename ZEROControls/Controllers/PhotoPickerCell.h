//
//  PhotoPickerCell.h
//  ZEROControls
//
//  Created by ZWX on 2017/1/13.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPickerCell : UICollectionViewCell

@property (nonatomic, weak)   NSIndexPath *indexPath;
@property (nonatomic, strong) UIImage *photo;

- (void)loadContent;

@end
