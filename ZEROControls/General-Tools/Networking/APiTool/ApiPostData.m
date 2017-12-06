//
//  ApiPostData.m
//  ZEROControls
//
//  Created by ZWX on 2017/12/6.
//  Copyright © 2017年 ZWX. All rights reserved.
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
