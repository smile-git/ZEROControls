//
//  CellDataItem.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "CellDataItem.h"

@implementation CellDataItem


+ (CellDataItem *)cellDataAdapterWithCellReuseIdentifier:(NSString *)cellReuseIdentifiers data:(id)data
                                                 cellHeight:(CGFloat)cellHeight cellType:(NSInteger)cellType {
    
    CellDataItem *adapter       = [[self class] new];
    adapter.cellReuseIdentifier = cellReuseIdentifiers;
    adapter.data                = data;
    adapter.cellHeight          = cellHeight;
    
    return adapter;
}

@end
