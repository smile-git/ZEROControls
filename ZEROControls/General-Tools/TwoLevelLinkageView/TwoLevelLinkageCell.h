//
//  TwoLevelLinkageCell.h
//  TwoLevelLinkage
//
//  Created by ZWX on 13/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "CustomCell.h"
#import "LeftLevelLinkageModel.h"

/**
 级联两个tableView的cell的父cell，分左右两cell
 */
@interface TwoLevelLinkageCell : CustomCell


/**
 级联model，如果是左边tableView，则为LeftLevelLinkageModel，如果是右边tableView，则为RightLevelLinkageModel
 */
@property (nonatomic, strong) LeftLevelLinkageModel *levelModel;


/**
 更新到选中状态

 @param animated is animated
 */
- (void)updateToSelectedStateAnimated:(BOOL)animated;



/**
 更新到普通状态

 @param animated is animated
 */
- (void)updateToNormalStateAnimated:(BOOL)animated;


/**
 更新选中状态

 @param state select‘state
 @param animated is animated
 */
- (void)updateSelectedState:(BOOL)state animate:(BOOL)animated;

@end
