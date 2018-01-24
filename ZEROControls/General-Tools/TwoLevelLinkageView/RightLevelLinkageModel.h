//
//  RightLevelLinkageModel.h
//  TwoLevelLinkage
//
//  Created by ZWX on 13/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  CellDataAdapter;
/**
 级联中右tableView‘s cell使用model
 */
@interface RightLevelLinkageModel : NSObject

/**
 cell数据适配器
 */
@property (nonatomic, strong)  CellDataAdapter *adapter;

@end
