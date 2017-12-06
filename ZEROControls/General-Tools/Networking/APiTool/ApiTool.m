//
//  ApiTool.m
//  ZEROControls
//
//  Created by ZWX on 2017/12/6.
//  Copyright © 2017年 ZWX. All rights reserved.
//

#import "ApiTool.h"
#import "ApiPostData.h"

#define KLocalCookName @"sessioncookie"
#define KToken @"token"


static ApiTool * apiTool;

@implementation ApiTool

+ (instancetype)shareApiTool
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        apiTool = [[ApiTool alloc] init];
    });
    
    return apiTool;
}

- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //Https
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];

    //请求超时时长
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//申明请求到的数据是json类型

    //设置cookie
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:KLocalCookName];
    [manager.requestSerializer setValue: value forHTTPHeaderField:@"Cookie"];
    //token验证
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:KToken] forHTTPHeaderField:@"token"];

    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSDictionary * jsonDic = [self dictionaryWithJsonString:result];

        if (success) {
            success(jsonDic);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (failure) {
            failure(error);
        }
    }];
    
}
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //Https
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];

    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//申明请求到的数据是json类型

    //设置cookie
    [manager.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:KLocalCookName]forHTTPHeaderField:@"Cookie"];

    //token验证
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:KToken] forHTTPHeaderField:@"token"];

    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSDictionary * jsonDic = [self dictionaryWithJsonString:result];

        if (success) {
            success(jsonDic);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (failure) {
            failure(error);
        }
    }];
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                             error:nil];
    //    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    //    NSError *err;
    //    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
    //                                                        options:NSJSONReadingMutableContainers
    //                                                          error:&err];
    //    if(err) {
    //        NSLog(@"json解析失败：%@",err);
    //        return nil;
    //    }
    //    return dic;
}

- (void)post:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //Https
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];

    //设置请求时间，超时请求失败
    AFHTTPRequestSerializer * serializer = [AFHTTPRequestSerializer serializer];
    serializer.timeoutInterval = 20.0;
    manager.requestSerializer = serializer;//申明请求的数据是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//申明请求到的数据是json类型

    //设置cookie
    [manager.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:KLocalCookName]forHTTPHeaderField:@"Cookie"];

    //token验证
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:KToken] forHTTPHeaderField:@"token"];

    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formDataArray enumerateObjectsUsingBlock:^(ApiPostData *  _Nonnull apiPostData, NSUInteger idx, BOOL * _Nonnull stop)
         {
             [formData appendPartWithFileData:apiPostData.data
                                         name:apiPostData.name
                                     fileName:apiPostData.filename
                                     mimeType:apiPostData.mimeType];
         }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSDictionary * jsonDic = [self dictionaryWithJsonString:result];

        if (success)
        {
            success(jsonDic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            failure(error);
        }
    }];
}


+ (void)startMultiPartUploadTaskWithURL:(NSString *)url
                            imagesArray:(NSArray *)images
                      parameterOfimages:(NSString *)parameter
                         parametersDict:(NSDictionary *)parameters
                       compressionRatio:(float)ratio
                           succeedBlock:(void (^)(id, id))succeedBlock
                            failedBlock:(void (^)(id, NSError *))failedBlock
                    uploadProgressBlock:(void (^)(float, long long, long long))uploadProgressBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //Https
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];

    //设置请求时间，超时请求失败
    AFHTTPRequestSerializer * serializer = [AFHTTPRequestSerializer serializer];
    serializer.timeoutInterval = 20.0;
    manager.requestSerializer = serializer;//申明请求的数据是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//申明请求到的数据是json类型


    if (images.count == 0) {
        NSLog(@"上传内容没有包含图片");
        return;
    }
    for (int i = 0; i < images.count; i++) {
        if (![images isKindOfClass:[UIImage class]]) {
            NSLog(@"images中第%d个元素不是UIImage对象",i+1);
            return;
        }
    }
    //设置cookie
    [manager.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:KLocalCookName]forHTTPHeaderField:@"Cookie"];

    //token验证
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:KToken] forHTTPHeaderField:@"token"];

    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int i = 0;
        //根据当前系统时间生成图片名称
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateString = [formatter stringFromDate:date];

        for (UIImage *image in images) {
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
            NSData *imageData;
            if (ratio > 0.0f && ratio < 1.0f) {
                imageData = UIImageJPEGRepresentation(image, ratio);
            }else{
                imageData = UIImageJPEGRepresentation(image, 1.0f);
            }

            [formData appendPartWithFileData:imageData name:parameter fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeedBlock(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failedBlock(task,error);
    }];
    
    
//        [task setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//            CGFloat percent = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
//            uploadProgressBlock(percent,totalBytesWritten,totalBytesExpectedToWrite);
//        }];
    
}

- (NSURLSessionDataTask *)upLoadImage:(NSString *)url params:(NSDictionary *)params upLoadImage:(UIImage *)image progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSDictionary * jsonDic))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //Https
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];

    //设置请求时间，超时请求失败
    AFHTTPRequestSerializer * serializer = [AFHTTPRequestSerializer serializer];
    serializer.timeoutInterval = 20.0;
    manager.requestSerializer = serializer;//申明请求的数据是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//申明请求到的数据是json类型

    //设置cookie
    [manager.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:KLocalCookName]forHTTPHeaderField:@"Cookie"];

    //token验证
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:KToken] forHTTPHeaderField:@"token"];

    NSURLSessionDataTask *dataTask = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImagePNGRepresentation(image);

        [formData appendPartWithFileData:imageData name:@"file"fileName:@"file.jpg" mimeType:@"image/jpg"];

    } progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSDictionary * jsonDic = [self dictionaryWithJsonString:result];

        if (success) {
            success(jsonDic);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        failure(error);
        NSLog(@"===========Error=========\n%@\n==========",error);

    }];

    return dataTask;
}
@end
