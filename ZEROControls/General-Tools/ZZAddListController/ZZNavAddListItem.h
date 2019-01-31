//
//  ZZAddListItem.h
//  NavAddList
//
//  Created by ZWX on 27/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZNavAddListItem : NSObject

@property (nonatomic, copy, readonly) NSString *titleString;

@property (nonatomic, copy, readonly) NSString *iconString;

- (instancetype)initWithTitle:(NSString *)titleString iconString:(NSString *)iconString;

+ (instancetype)listItemWithTitle:(NSString *)titleString iconString:(NSString *)iconString;
@end
