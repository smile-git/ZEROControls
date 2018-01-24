//
//  CategoryModels.m
//  TwoLevelLinkage
//
//  Created by ZWX on 17/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "CategoryModel.h"
#import "SubCategoryModel.h"

@implementation CategoryModel

- (instancetype)initWithDictionary:(NSDictionary *)dictoinary {
    
    if ([dictoinary isKindOfClass:[NSDictionary class]]) {
        
        if (self = [super init]) {
            
            [self setValuesForKeysWithDictionary:dictoinary];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.categoryId = value;
        return;
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    // ignore null value
    if ([value isKindOfClass:[NSNull class]]) {
        
        return;
    }
    // subcategories
    if ([key isEqualToString:@"subcategories"] && [value isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        [value enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull category, NSUInteger idx, BOOL * _Nonnull stop) {
            
            SubCategoryModel *subCategoryModel = [[SubCategoryModel alloc] initWithDictionary:category];
            [dataArray addObject:subCategoryModel];
        }];
        
        value = dataArray;
    }
    
    [super setValue:value forKey:key];
}

@end
