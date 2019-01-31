//
//  ZZAddListItem.m
//  NavAddList
//
//  Created by ZWX on 27/01/2018.
//  Copyright © 2018 ZWX. All rights reserved.
//

#import "ZZNavAddListItem.h"

@interface ZZNavAddListItem ()

@property (nonatomic, copy, readwrite) NSString *titleString;

@property (nonatomic, copy, readwrite) NSString *iconString;

@end

@implementation ZZNavAddListItem

- (instancetype)initWithTitle:(NSString *)titleString iconString:(NSString *)iconString {
    
    if (self = [super init]) {
        
        self.titleString = titleString;
        self.iconString = iconString;
    }
    return self;
}

+ (instancetype)listItemWithTitle:(NSString *)titleString iconString:(NSString *)iconString {
    
    ZZNavAddListItem *listItem = [[self alloc] initWithTitle:titleString
                                                 iconString:iconString];
    
    return listItem;
}
@end
