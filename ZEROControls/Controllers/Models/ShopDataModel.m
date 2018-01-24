//
//  ShopDataModel.m
//  TwoLevelLinkage
//
//  Created by ZWX on 17/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "ShopDataModel.h"

@implementation ShopDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dictoinary {
    
    if ([dictoinary isKindOfClass:[NSDictionary class]]) {
        
        if (self = [super init]) {
            
            [self setValuesForKeysWithDictionary:dictoinary];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    // ignore null value
    if ([value isKindOfClass:[NSNull class]]) {
        
        return;
    }
    
    // categories
    if ([key isEqualToString:@"categories"] && [value isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        [value enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull category, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CategoryModel *categoryModel = [[CategoryModel alloc] initWithDictionary:category];
            [dataArray addObject:categoryModel];
        }];
        
        value = dataArray;
    }
    
    [super setValue:value forKey:key];
}

@end
