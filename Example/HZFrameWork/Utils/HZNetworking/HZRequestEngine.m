//
//  HZRequestEngine.m
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/16.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import "HZRequestEngine.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "HZURLRequest.h"
#import "NSString+HZUTF8Encoding.h"


@implementation HZRequestEngine
+ (instancetype)defaultEngine{
    static HZRequestEngine *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HZRequestEngine alloc]init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //无条件地信任服务器端返回的证书。
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.securityPolicy = [AFSecurityPolicy defaultPolicy];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
        /*因为与缓存互通 服务器返回的数据 必须是二进制*/
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json", @"text/plain",@"text/javascript",nil];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
    }
    return self;
}

- (void)dealloc {
    [self invalidateSessionCancelingTasks:YES];
}

#pragma mark - GET/POST/PUT/PATCH/DELETE
- (NSURLSessionDataTask *)dataTaskWithMethod:(HZURLRequest *)request
                                 hz_progress:(void (^)(NSProgress * _Nonnull))hz_progress
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    [self requestSerializerConfig:request];
    [self headersAndTimeConfig:request];
    
    NSString *URLString=[NSString hz_stringUTF8Encoding:request.URLString];
    
    if (request.methodType==HZMethodTypePOST) {
        return [self POST:URLString parameters:request.parameters progress:hz_progress success:success failure:failure];
    }else if (request.methodType==HZMethodTypePUT){
        return [self PUT:URLString parameters:request.parameters success:success failure:failure];
    }else if (request.methodType==HZMethodTypePATCH){
        return [self PATCH:URLString parameters:request.parameters success:success failure:failure];
    }else if (request.methodType==HZMethodTypeDELETE){
        return [self DELETE:URLString parameters:request.parameters success:success failure:failure];
    }else{
        return [self GET:URLString parameters:request.parameters progress:hz_progress success:success failure:failure];
    }
}


#pragma mark - 其他配置
- (void)requestSerializerConfig:(HZURLRequest *)request{
    self.requestSerializer =request.requestSerializer==HZJSONRequestSerializer ? [AFJSONRequestSerializer serializer]:[AFHTTPRequestSerializer serializer];
}

- (void)headersAndTimeConfig:(HZURLRequest *)request{
    self.requestSerializer.timeoutInterval=request.timeoutInterval?request.timeoutInterval:30;
    if ([[request mutableHTTPRequestHeaders] allKeys].count>0) {
        [[request mutableHTTPRequestHeaders] enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
            [self.requestSerializer setValue:value forHTTPHeaderField:field];
        }];
    }
}

#pragma mark - 取消请求
- (void)cancelRequest:(NSString *)URLString completion:(cancelCompletedBlock)completion{
    
    __block NSString *currentUrlString=nil;
    BOOL results;
    @synchronized (self.tasks) {
        [self.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[[task.currentRequest URL] absoluteString] isEqualToString:[NSString hz_stringUTF8Encoding:URLString]]) {
                currentUrlString =[[task.currentRequest URL] absoluteString];
                [task cancel];
                *stop = YES;
            }
        }];
    }
    if (currentUrlString==nil) {
        results=NO;
    }else{
        results=YES;
    }
    completion ? completion(results,currentUrlString) : nil;
}
@end
