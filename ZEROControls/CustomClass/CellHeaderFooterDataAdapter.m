//
//  CellHeaderFooterDataAdapter.m
//  TwoLevelLinkage
//
//  Created by ZWX on 15/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "CellHeaderFooterDataAdapter.h"

@implementation CellHeaderFooterDataAdapter

+ (instancetype)cellHeaderFooterDataAdapterWithReuseIdentifier:(NSString *)reusedIdentifier data:(id)data height:(CGFloat)height type:(NSInteger)type {
    
    CellHeaderFooterDataAdapter *adapter = [[CellHeaderFooterDataAdapter alloc] init];

    adapter.reusedIdentifier = reusedIdentifier;
    adapter.data             = data;
    adapter.height           = height;
    adapter.type             = type;
    
    return adapter;
}

@end
