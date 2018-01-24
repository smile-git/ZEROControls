//
//  ItemManagerModel.m
//  TwoLevelLinkage
//
//  Created by ZWX on 17/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "ItemManagerModel.h"

@implementation ItemManagerModel

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
    
    if ([key isEqualToString:@"data"] && [value isKindOfClass:[NSDictionary class]]) {
        
        value = [[ShopDataModel alloc] initWithDictionary:value];
    }
    
    [super setValue:value forKey:key];
}

@end
