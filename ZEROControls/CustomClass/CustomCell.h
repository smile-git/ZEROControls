//
//  CustomCell.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDataAdapter.h"

@interface CustomCell : UITableViewCell

#pragma mark - Propeties.

/**
 *  CustomCell's dataItem.
 */
@property (nonatomic, weak) CellDataAdapter *dataAdapter;

/**
 *  CustomCell's indexPath.
 */
@property (nonatomic, weak) NSIndexPath *indexPath;

/**
 TableView
 */
@property (nonatomic, weak) UITableView *tableView;

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


/**
 Update the cell's height with animated or not, before you use this method, you should have the weak reference 'tableView' and 'dataAdapter', and this method will update the weak reference dataAdapter's property cellHeight.
 
 @param height the new cell height
 @param animated animate or not.
 */
- (void)updateWithNewHeight:(CGFloat)height animated:(BOOL)animated;

#pragma mark - Constructor method.


/**
 Create the cell's dataAdapter.
 
 @param reuseIdentifier Cell reuseIdentifier, can be nil.
 @param data            Cell's data, can be nil.
 @param height          Cell's height.
 @param type            Cell's type.
 @return Cell's dataAdapter.
 */
+ (CellDataAdapter *)dataAdapterWithCellReuseIdentifier:(NSString *)reuseIdentifier data:(id)data cellHeight:(CGFloat)height type:(NSInteger)type;

+ (CellDataAdapter *)dataAdapterWithData:(id)data cellHeight:(CGFloat)height tyep:(NSInteger)type;

+ (CellDataAdapter *)dataAdapterWithData:(id)data cellHeight:(CGFloat)height;

+ (CellDataAdapter *)dataAdapterWithData:(id)data;


/**
 [= Must over write class method 'cellHeightWithData:' to get the height =]
 
 Create the cell's dataAdapter, the CellReuseIdentifier is the cell's class string.
 
 @param reuseIdentifier Cell reuseIdentifier, can be nil.
 @param data            Cell's data, can be nil.
 @param type            Cell's type.
 @return Cell's dataAdapter.
 */
+ (CellDataAdapter *)fixedHeightTypeDataAdapterWithCellReuseIdentifier:(NSString *)reuseIdentifier data:(id)data type:(NSInteger)type;

+ (CellDataAdapter *)fixedHeightTypeDataAdapterWithData:(id)data type:(NSInteger)type;

+ (CellDataAdapter *)fixedHeightTypeDataAdapterWithData:(id)data;

+ (CellDataAdapter *)fixedHeightTypeDataAdapter;

#pragma mark - Load content.
/**
 Set the dataAdapter and load content.
 
 @param dataAdapter The CellDataAdapter.
 */
- (void)loadContentWithAdapter:(CellDataAdapter *)dataAdapter;

/**
 Set the dataAdapter and load content.
 
 @param dataAdapter The CellDataAdapter.
 @param indexPath The indexPath.
 */
- (void)loadContentWithAdapter:(CellDataAdapter *)dataAdapter indexPath:(NSIndexPath *)indexPath;

- (void)loadContentWithAdapter:(CellDataAdapter *)dataAdapter tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
