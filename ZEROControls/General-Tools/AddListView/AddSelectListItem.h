//
//  SelectListItem.h
//  SelectList
//
//  Created by ZWX on 16/6/15.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AddSelectListItem : NSObject

@property (nonatomic, copy) NSString * icon;

@property (nonatomic, copy) NSString * title;

+ (AddSelectListItem *)initWithIcon:(NSString *)icon title:(NSString *)title;
@end
