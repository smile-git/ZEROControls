//
//  LeftLevelLinkageModel.h
//  TwoLevelLinkage
//
//  Created by ZWX on 13/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RightLevelLinkageModel.h"
#import "CellHeaderFooterDataAdapter.h"
#import "CellDataAdapter.h"

/**
 级联中左tableView‘s cell使用model
 */
@interface LeftLevelLinkageModel : NSObject

/**
 cell数据适配器
 */
@property (nonatomic, strong)  CellDataAdapter *adapter;

/**
 cellHeader数据适配器，属于右tableView
 
 * 左tableView的cell.row与右tableView的section对等
 */
@property (nonatomic, strong) CellHeaderFooterDataAdapter *headerAdapter;

/**
 是否选中状态
 */
@property (nonatomic, assign) BOOL selected;


/**
 左tableView中cell包含的子model
 */
@property (nonatomic, strong) NSArray <RightLevelLinkageModel *>*subModels;
@end
