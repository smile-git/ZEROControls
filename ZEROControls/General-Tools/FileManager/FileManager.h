//
//  FileManager.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (BOOL)fileExistWithRealFilePath:(NSString *)theRealFilePath;

+ (NSString *)theRealFilePath:(NSString *)relatedFilePath;
@end
