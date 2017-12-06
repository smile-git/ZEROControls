//
//  ApiTool.h
//  ZEROControls
//
//  Created by ZWX on 2017/12/6.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 网络请求管理类
 */
@interface ApiTool : NSObject
NS_ASSUME_NONNULL_BEGIN

+ (instancetype _Nonnull )shareApiTool;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary * jsonDic))success failure:(void (^)(NSError *error))failure;

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary * jsonDic))success failure:(void (^)(NSError *error))failure;

//上传文件
- (void)post:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(NSDictionary * jsonDic))success failure:(void (^)(NSError *error))failure;

/**
 *  上传带图片的内容，允许多张图片上传（URL）POST
 *
 *  @param url                 网络请求地址
 *  @param images              要上传的图片数组（注意数组内容需是图片）
 *  @param parameter           图片数组对应的参数
 *  @param parameters          其他参数字典
 *  @param ratio               图片的压缩比例（0.0~1.0之间）
 *  @param succeedBlock        成功的回调
 *  @param failedBlock         失败的回调
 *  @param uploadProgressBlock 上传进度的回调
 */
+ (void)startMultiPartUploadTaskWithURL:(NSString *)url
                            imagesArray:(NSArray *)images
                      parameterOfimages:(NSString *)parameter
                         parametersDict:(NSDictionary *)parameters
                       compressionRatio:(float)ratio
                           succeedBlock:(void(^)(id operation, id responseObject))succeedBlock
                            failedBlock:(void(^)(id operation, NSError *error))failedBlock
                    uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock;


- (NSURLSessionDataTask *)upLoadImage:(NSString *)url params:(NSDictionary *)params upLoadImage:(UIImage *)image progress:(nullable void (^)(NSProgress * _Nonnull uploadProgress))uploadProgress success:(void (^)(NSDictionary * jsonDic))success failure:(void (^)(NSError *error))failure;

NS_ASSUME_NONNULL_END
@end
