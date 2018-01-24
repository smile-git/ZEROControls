//
//  CategoryModels.h
//  TwoLevelLinkage
//
//  Created by ZWX on 17/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SubCategoryModel;

@interface CategoryModel : NSObject

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, strong) NSString *icon_url;
@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray <SubCategoryModel *> *subcategories;

/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
