//
//  WWaterFallCell.h
//  WWaterFall
//
//  Created by ZWX on 2016/11/19.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWaterFallCell : UICollectionViewCell

@property (nonatomic)       CGFloat     rowHeight;
@property (nonatomic, weak) id          data;
@property (nonatomic, weak) NSIndexPath *indexPath;

- (void)loadContent;

@end
