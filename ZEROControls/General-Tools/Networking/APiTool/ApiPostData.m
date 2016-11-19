//
//  ApiPostData.m
//  WWaterFall
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ApiPostData.h"

@implementation ApiPostData

- (instancetype)initWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType{
    
    if (self = [super init]) {
        
        self.data       = data;
        self.name       = name;
        self.filename   = name;
        self.mimeType   = mimeType;
    }
    return self;
}

@end
