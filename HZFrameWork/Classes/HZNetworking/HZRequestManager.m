//
//  HZRequestManager.m
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/16.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import "HZRequestManager.h"
#import "HZURLRequest.h"
#import "NSString+HZUTF8Encoding.h"
#import "HZCacheManager.h"
#import "HZRequestEngine.h"
@implementation HZRequestManager

#pragma mark - 配置请求
+ (void)requestWithConfig:(requestConfig)config success:(requestSuccess)success failure:(requestFailure)failure{
    [self requestWithConfig:config progress:nil success:success failure:failure];
}

+ (void)requestWithConfig:(requestConfig)config progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure {
    HZURLRequest *request=[[HZURLRequest alloc]init];
    config ? config(request) : nil;
    [self sendRequest:request progress:progress success:success failure:failure];
}

+ (HZBatchRequest *)sendBatchRequest:(batchRequestConfig)config success:(requestSuccess)success failure:(requestFailure)failure{
    return [self sendBatchRequest:config progress:nil success:success failure:failure];
}

+ (HZBatchRequest *)sendBatchRequest:(batchRequestConfig)config progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure{
    HZBatchRequest *batchRequest=[[HZBatchRequest alloc]init];
    config ? config(batchRequest) : nil;
    
    if (batchRequest.urlArray.count==0)return nil;
    [batchRequest.urlArray enumerateObjectsUsingBlock:^(HZURLRequest *request , NSUInteger idx, BOOL *stop) {
        [self sendRequest:request progress:progress success:success failure:failure];
    }];
    return batchRequest;
}


#pragma mark - 发起请求
+ (void)sendRequest:(HZURLRequest *)request progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure{
    
    if([request.URLString isEqualToString:@""]||request.URLString==nil)return;
    if (request.methodType==HZMethodTypeUpload) {
        [self sendUploadRequest:request progress:progress success:success failure:failure];
    }else if (request.methodType==HZMethodTypeDownLoad){
        [self sendDownLoadRequest:request progress:progress success:success failure:failure];
    }else{
        [self sendHTTPRequest:request progress:progress success:success failure:failure];
    }
}


+ (void)sendUploadRequest:(HZURLRequest *)request progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure{
    [[HZRequestEngine defaultEngine] uploadWithRequest:request hz_progress:progress success:^(NSURLSessionDataTask *task, id responseObject) {
        success ? success(responseObject,0,NO) : nil;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure ? failure(error) : nil;
    }];
}


+ (void)sendDownLoadRequest:(HZURLRequest *)request progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure{
    [[HZRequestEngine defaultEngine] downloadWithRequest:request progress:progress completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        failure ? failure(error) : nil;
        success ? success([filePath path],request.apiType,NO) : nil;
    }];
}


+ (void)sendHTTPRequest:(HZURLRequest *)request progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure{
    NSString *key = [self keyWithParameters:request];
    if ([[HZCacheManager sharedInstance] diskCacheExistsWithKey:key] && request.apiType != HZRequestTypeRefresh && request.apiType!=HZRequestTypeRefreshMore && request.apiType != HZRequestTypeRefreshAndCache){
        [[HZCacheManager sharedInstance] getCacheDataForKey:key value:^(NSData *data,NSString *filePath) {
            id result=[self responsetSerializerConfig:request responseObject:data];
            success ? success(result ,request.apiType,YES) : nil;
        }];
    }else {
        if (request.apiType == HZRequestTypeRefreshAndCache){
            if ([[HZCacheManager sharedInstance] diskCacheExistsWithKey:key]) {
                [[HZCacheManager sharedInstance] getCacheDataForKey:key value:^(NSData *data,NSString *filePath) {
                    id result = [self responsetSerializerConfig:request responseObject:data];
                    success ? success(result ,request.apiType,YES) : nil;
                }];
            }
            if ([[HZCacheManager sharedInstance] diskCacheExistsWithKey:key]) {
                [self dataTaskWithHTTPRequest:request progress:progress success:nil failure:nil];
            }else {
                [self dataTaskWithHTTPRequest:request progress:progress success:success failure:failure];
            }
        }
    }
}

+ (void)dataTaskWithHTTPRequest:(HZURLRequest *)request progress:(progressBlock)progress success:(requestSuccess)success failure:(requestFailure)failure{
    
    [[HZRequestEngine defaultEngine] dataTaskWithMethod:request hz_progress:^(NSProgress * _Nonnull hz_progress) {
        progress ? progress(hz_progress) : nil;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self storeObject:responseObject request:request];
        id result = [self responsetSerializerConfig:request responseObject:responseObject];
        success ? success(result,request.apiType,NO) : nil;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure ? failure(error) : nil;
    }];
}

#pragma mark - 其他配置
+ (NSString *)keyWithParameters:(HZURLRequest *)request{
    if (request.parametersfiltrationCacheKey.count>0) {
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:request.parameters];
        [mutableParameters removeObjectsForKeys:request.parametersfiltrationCacheKey];
        request.parameters =  [mutableParameters copy];
    }
    NSString *URLStringCacheKey;
    if (request.customCacheKey) {
        URLStringCacheKey=request.customCacheKey;
    }else{
        URLStringCacheKey=request.URLString;
    }
    return [NSString hz_stringUTF8Encoding:[NSString hz_urlString:URLStringCacheKey appendingParameters:request.parameters]];
}

+ (void)storeObject:(NSObject *)object request:(HZURLRequest *)request{
    NSString * key= [self keyWithParameters:request];
    [[HZCacheManager sharedInstance] storeContent:object forKey:key isSuccess:^(BOOL isSuccess) {
        if (isSuccess) {
            HZLog(@"store successful");
        }else{
            HZLog(@"store failure");
        }
    }];
}

+ (id)responsetSerializerConfig:(HZURLRequest *)request responseObject:(id)responseObject{
    if (request.responseSerializer==HZHTTPResponseSerializer) {
        return responseObject;
    }else{
        NSError *serializationError = nil;
        NSData *data = (NSData *)responseObject;
        BOOL isSpace = [data isEqualToData:[NSData dataWithBytes:" " length:1]];
        if (data.length > 0 && !isSpace) {
            id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
            return result;
        } else {
            return nil;
        }
    }
}

+ (void)cancelRequest:(NSString *)URLString completion:(cancelCompletedBlock)completion{
    if([URLString isEqualToString:@""]||URLString==nil)return;
    [[HZRequestEngine defaultEngine] cancelRequest:URLString completion:completion];
}

@end
