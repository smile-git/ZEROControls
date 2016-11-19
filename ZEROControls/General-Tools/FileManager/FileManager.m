//
//  FileManager.m
//  ZEROControls
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (BOOL)fileExistWithRealFilePath:(NSString *)theRealFilePath{
    
    BOOL isDirectory = NO;
    BOOL isExist     = [[NSFileManager defaultManager] fileExistsAtPath:theRealFilePath isDirectory:&isDirectory];
    
    return isExist;
}

+ (NSString *)theRealFilePath:(NSString *)relatedFilePath{
    
    NSString *rootPath = nil;
    
    if (relatedFilePath.length) {
        
        if ([relatedFilePath characterAtIndex:0] == '~') {
            
            rootPath = [relatedFilePath stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:NSHomeDirectory()];
            
        }else if ([relatedFilePath characterAtIndex:0] == '-'){
            
            rootPath = [relatedFilePath stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[NSBundle mainBundle] bundlePath]];
            
        }else{
            
            rootPath = nil;
        }
        
    }else{
        
        rootPath = NSHomeDirectory();
    }
    
    return rootPath;
}
@end
