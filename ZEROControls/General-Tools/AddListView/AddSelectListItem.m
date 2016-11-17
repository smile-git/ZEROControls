//
//  SelectListItem.m
//  SelectList
//
//  Created by ZWX on 16/6/15.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "AddSelectListItem.h"

@implementation AddSelectListItem

+ (AddSelectListItem *)initWithIcon:(NSString *)icon title:(NSString *)title
{
    AddSelectListItem *item = [[self class] new];
    item.icon               = icon;
    item.title              = title;
    
    return item;
}
@end
