//
//  DailyListModel.m
//  ZEROControls
//
//  Created by ZWX on 2017/12/7.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "DailyListModel.h"

@implementation DailyListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        
        return;
    }
    
    if ([key isEqualToString:@"list"] && [value isKindOfClass:[NSArray class]]) {
        
        NSArray *array = value;
        NSMutableArray *dataArray = [NSMutableArray array];
        
        for (NSDictionary *dictionary in array) {
            
            VideoListModel *model = [[VideoListModel alloc] initWithDictionary:dictionary];
            [dataArray addObject:model];
        }
        
        value = dataArray;
    }
    
    [super setValue:value forKey:key];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if (self = [super init]) {
        
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            
            [self setValuesForKeysWithDictionary:dictionary];
            
        }
    }
    
    
    return self;
}

@end
