//
//  ApiTool.h
//  WWaterFall
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 *  网络请求管理类
 */
@interface ApiTool : NSObject

+ (instancetype)shareApiTool;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

/**
 *  get请求
 *
 *  @param url     url
 *  @param params  参数
 *  @param success 请求成功
 *  @param failure 请求失败
 */
- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary * jsonDic))success failure:(void (^)(NSError *error))failure;

/**
 *  post请求
 *
 *  @param url     url
 *  @param params  参数
 *  @param success 请求成功
 *  @param failure 请求失败
 */
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary * jsonDic))success failure:(void (^)(NSError *error))failure;


/**
 上传文件
 
 @param url           url
 @param params        参数
 @param formDataArray 存储ApiPostData的数组
 @param success       请求成功
 @param failure       请求失败
 */
- (void)post:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(NSDictionary * jsonDic))success failure:(void (^)(NSError *error))failure;
@end
