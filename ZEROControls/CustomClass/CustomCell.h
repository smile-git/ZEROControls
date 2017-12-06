//
//  CustomCell.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDataItem.h"

@interface CustomCell : UITableViewCell

#pragma mark - Propeties.

/**
 *  CustomCell's dataItem.
 */
@property (nonatomic, weak) CellDataItem         *dataItem;

/**
 *  CustomCell's indexPath.
 */
@property (nonatomic, weak) NSIndexPath          *indexPath;

/**
 *  CustomCell's data.
 */
@property (nonatomic, weak) id data;

#pragma mark - Method you should overwrite.

/**
 *  Setup cell, override by subclass.
 */
- (void)setupCell;

/**
 *  Build subview, override by subclass.
 */
- (void)buildSubview;

/**
 *  Load content, override by subclass.
 */
- (void)loadContent;

/**
 *  Calculate the cell's from data, override by subclass.
 *
 *  @param data Data.
 *
 *  @return Cell's height.
 */
+ (CGFloat)cellHeightWithData:(id)data;

#pragma mark - Useful method.

/**
 *  Selected event, you should use this method in 'tableView:didSelectRowAtIndexPath:' to make it effective.
 */
- (void)selectedEvent;

@end
