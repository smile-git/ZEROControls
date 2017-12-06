//
//  DuiTangPicModel.m
//  ZEROControls
//
//  Created by ZWX on 2017/10/11.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "DuiTangPicModel.h"

@implementation DuiTangPicModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        
        return;
    }
    
    [super setValue:value forKey:key];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        
        if (self = [super init]) {
            
            [self setValuesForKeysWithDictionary:dictionary];
        }
    }
    
    return self;
}

@end
