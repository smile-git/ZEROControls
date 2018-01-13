//
//  CellDataItem.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "CellDataAdapter.h"

@implementation CellDataAdapter


+ (CellDataAdapter *)cellDataItemWithCellReuseIdentifier:(NSString *)cellReuseIdentifiers data:(id)data
                                           cellHeight:(CGFloat)cellHeight cellType:(NSInteger)cellType {
    CellDataAdapter *adapter       = [[self class] new];
    adapter.cellReuseIdentifier = cellReuseIdentifiers;
    adapter.data                = data;
    adapter.cellHeight          = cellHeight;
    adapter.cellType            = cellType;
    
    return adapter;
}

@end
