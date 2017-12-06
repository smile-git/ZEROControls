//
//  TreeStructureModel.h
//  ZEROControls
//
//  Created by ZWX on 2017/8/28.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeStructureModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSMutableArray <TreeStructureModel *> *subModels;

- (instancetype)initWithDictionary:(NSDictionary *)treeDic;


/**
 设定展开还是缩放 [ extend为NO时,返回空的数组,为YES时,返回当前级别的submodels ]
 */
@property (nonatomic, assign) BOOL extend;

/**
 通过递归的方法获取所有的子model [ 每次调用都会重新获取 ]
 */
@property (nonatomic, strong, readonly) NSMutableArray <TreeStructureModel *> *allSubModels;

@property (nonatomic, assign, readonly) NSInteger subModelsCount;
@end
