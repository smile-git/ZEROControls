//
//  FileManager.h
//  ZEROControls
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

/**
 *  Transform related file path to real file path.
 *
 *  @param relatedFilePath Related file path, "~" means sandbox root, "-" means bundle file root.
 *
 *  @return The real file path.
 */
+ (NSString *)theRealFilePath:(NSString *)relatedFilePath;

/**
 *  Get the bundle file path by the bundle file name.
 *
 *  @param name Bundle file name.
 *
 *  @return Bundle file path.
 */
+ (NSString *)bundleFileWithName:(NSString *)name;

/**
 *  To check the file at the given file path exist or not.
 *
 *  @param theRealFilePath The real file path.
 *
 *  @return Exist or not.
 */
+ (BOOL)fileExistWithRealFilePath:(NSString *)theRealFilePath;

@end
