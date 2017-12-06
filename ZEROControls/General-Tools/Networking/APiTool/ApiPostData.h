//
//  ApiPostData.h
//  ZEROControls
//
//  Created by ZWX on 2017/12/6.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  上传文件model
 */
@interface ApiPostData : NSObject

/**
 *  文件数据
 */
@property(nonatomic,strong) NSData * data;
/**
 *  参数名
 */
@property(nonatomic,copy)   NSString * name;
/**
 *  文件名
 */
@property(nonatomic,copy)   NSString * filename;
/**
 *  文件类型
 */
@property(nonatomic,copy)   NSString * mimeType;

- (instancetype)initWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end
