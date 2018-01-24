//
//  SubcategoryModel.h
//  TwoLevelLinkage
//
//  Created by ZWX on 17/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubCategoryModel : NSObject

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *subCategoryId;
@property (nonatomic, strong) NSNumber *items_count;
@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, strong) NSString *icon_url;
@property (nonatomic, strong) NSNumber *parent_id;
@property (nonatomic, strong) NSString *name;

/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
