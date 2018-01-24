//
//  ItemManagerModel.h
//  TwoLevelLinkage
//
//  Created by ZWX on 17/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopDataModel.h"

@interface ItemManagerModel : NSObject

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSNumber *code;

@property (nonatomic, strong) ShopDataModel *data;

- (instancetype)initWithDictionary:(NSDictionary *)dictoinary;

@end
