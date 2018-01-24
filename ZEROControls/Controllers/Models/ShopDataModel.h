//
//  ShopDataModel.h
//  TwoLevelLinkage
//
//  Created by ZWX on 17/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryModel.h"

@interface ShopDataModel : NSObject

@property (nonatomic, strong) NSMutableArray <CategoryModel *> *categories;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
