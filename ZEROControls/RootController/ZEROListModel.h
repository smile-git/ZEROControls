//
//  ZEROListItem.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/17.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZEROListModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *controller;

+ (instancetype)initWithName:(NSString *)name controller:(NSString *)controller;

@property (nonatomic) NSInteger index;

@property (nonatomic, strong, readonly) NSMutableAttributedString *attributeName;

- (void)createAttributedName;

@end
