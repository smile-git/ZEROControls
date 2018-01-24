//
//  SubcategoryModel.m
//  TwoLevelLinkage
//
//  Created by ZWX on 17/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "SubCategoryModel.h"

@implementation SubCategoryModel

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
        
        self.subCategoryId = value;
        return;
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    // ignore null value
    if ([value isKindOfClass:[NSNull class]]) {
        
        return;
    }
    
    [super setValue:value forKey:key];
}

@end
