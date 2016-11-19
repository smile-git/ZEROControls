//
//  ApiTool.m
//  WWaterFall
//
//  Created by ZWX on 2016/11/20.
//  Copyright © 2016年 ZWX. All rights reserved.
//

#import "ApiTool.h"
#import "ApiPostData.h"

static ApiTool * apiTool;

@implementation ApiTool

+ (instancetype)shareApiTool{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiTool = [[ApiTool alloc] init];
    });
    
    return apiTool;
}

- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary * jsonDic))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager.requestSerializer setValue:@"123" forHTTPHeaderField:@"x-access-id"];
    [manager.requestSerializer setValue:@"123" forHTTPHeaderField:@"x-signature"];
    
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                                   error:nil];
        
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
    
    AFHTTPRequestSerializer * serializer = [AFHTTPRequestSerializer serializer];
    serializer.timeoutInterval = 20.0;
    manager.requestSerializer  = serializer;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                                   error:nil];
        
        if (success) {
            success(jsonDic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)post:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求时间，超时请求失败
    AFHTTPRequestSerializer * serializer = [AFHTTPRequestSerializer serializer];
    serializer.timeoutInterval = 20.0;
    manager.requestSerializer = serializer;//申明请求的数据是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//申明请求到的数据是json类型
    
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
        
        NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                                   error:nil];;
        
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

@end
