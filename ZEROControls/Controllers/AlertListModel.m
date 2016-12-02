//
//  AlertListModel.m
//  ZEROControls
//
//  Created by ZWX on 2016/12/2.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "AlertListModel.h"

@implementation AlertListModel

- (instancetype)initWithTitle:(NSString *)title{
    
    if (self = [super init]) {
        
        self.title = title;
    }
    return self;
}

@end
