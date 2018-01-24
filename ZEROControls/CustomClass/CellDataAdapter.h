//
//  CellDataItem.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellDataAdapter : NSObject


/**
 *  Cell's reused identifier.
 */
@property (nonatomic, strong) NSString     *cellReuseIdentifier;

/**
 *  Data, can be nil.
 */
@property (nonatomic, strong) id            data;

/**
 *  Cell's height, only used for UITableView's cell.
 */
@property (nonatomic)         CGFloat       cellHeight;

/**
 *  Cell's width, only used for UITableView's cell.
 */
@property (nonatomic)         CGFloat       cellWidth;

/**
 *  Cell's type (The same cell, but maybe have different types).
 */
@property (nonatomic)         NSInteger     cellType;


/**
 convenient
 
 @param cellReuseIdentifiers    Cell's reused identifier.
 @param data                    Data, can be nil.
 @param cellHeight              Cell's height, only used for UITableView's cell.
 @param cellType                Cell's type (The same cell, but maybe have different types).
 
 @return CellDataAdapter
 */
+ (CellDataAdapter *)cellDataItemWithCellReuseIdentifier:(NSString *)cellReuseIdentifiers
                                                    data:(id)data
                                              cellHeight:(CGFloat)cellHeight
                                                cellType:(NSInteger)cellType;
@end
