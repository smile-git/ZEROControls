//
//  TreeStructureModel.m
//  ZEROControls
//
//  Created by ZWX on 2017/8/28.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "TreeStructureModel.h"

@interface TreeStructureModel()

@property (nonatomic, strong) NSMutableArray <TreeStructureModel *> *allSubModels;

@end

@implementation TreeStructureModel

- (instancetype)initWithDictionary:(NSDictionary *)treeDic {
    
    if ([treeDic isKindOfClass:[NSDictionary class]]) {
        
        if (self = [super init]) {
            
            [self setValuesForKeysWithDictionary:treeDic];
        }
    }
    
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    // ----- 忽略空值 ignore null value
    if ([value isKindOfClass:[NSNull class]]) {
        
        return;
    }
    
    // ----- level
    if ([key isEqualToString:@"level"]) {
        
        _level = [value integerValue];
        return;
    }
    
    // ----- submodels (递归调用) --初始化
    if ([key isEqualToString:@"submodels"]) {
        
        NSMutableArray *datas = [NSMutableArray array];
        NSArray *subModels = value;
        
        [subModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TreeStructureModel *model = [[TreeStructureModel alloc] initWithDictionary:obj];
            [datas addObject:model];
        }];
        
        _subModels = datas;
        return;
    }
    
    [super setValue:value forKey:key];
}

/**
 如果extend参数为NO,则没有submodels
 
 @return submodels
 */
- (NSMutableArray <TreeStructureModel *>*)subModels {
    
    return _extend ? _subModels : [NSMutableArray array];
}


- (NSMutableArray <TreeStructureModel *>*)allSubModels {
    
    NSMutableArray *array = [NSMutableArray array];
    
    [self storeSubmodels:self array:array];
    
    return array;
}

- (NSInteger)subModelsCount {
    
    return _subModels.count;
}



/**
 递归调用(核心) --获取
 
 @param model TreeStructureModel实体
 @param array 存储数据用的数组
 */
- (void)storeSubmodels:(TreeStructureModel *)model array:(NSMutableArray *)array {
    
    [model.subModels enumerateObjectsUsingBlock:^(TreeStructureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [array addObject:obj];
        [model storeSubmodels:obj array:array];
    }];
}
@end
