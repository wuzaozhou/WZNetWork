//
//  WZNetWork.m
//  WZNetWork
//
//  Created by 吴灶洲 on 2019/7/9.
//  Copyright © 2019 吴灶洲. All rights reserved.
//

#import "WZNetWork.h"
#import "HZNetWorkCache.h"


@interface WZNetWork()<NSCopying, NSMutableCopying>
@property (nonatomic, strong) HZNetworkManager *requestManager;

@end

@implementation WZNetWork
static WZNetWork *instance;

//初始化方法
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
        instance.requestManager = [HZNetworkManager sharedInstance];
        [instance initialConfig];
    });
    return instance;
}
//单例方法
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}
//alloc会调用allocWithZone，确保使用同一块内存地址
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
//copy的时候会调用copyWithZone
- (id)copyWithZone:(NSZone *)zone {
    return instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone {
    return instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone {
    return instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return instance;
}


- (void)initialConfig {
    
    self.requestManager.configuration.baseURL = _baseURL;
    //    self.requestConvertManager.configuration.resultCacheDuration = 1;
    self.requestManager.configuration.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    //通过configuration来统一处理输出的数据，比如对token失效处理、对需要重新登录拦截
    self.requestManager.configuration.resposeHandle = ^id (NSURLSessionTask *dataTask, id responseObject) {
       
        return responseObject;
    };
    
}

- (void)setBaseURL:(NSString *)baseURL {
    _baseURL = baseURL;
    self.requestManager.configuration.baseURL = baseURL;
}


#pragma mark - 缓存管理
- (void)clearRequestCache:(NSString *_Nullable)urlString parameters:(NSDictionary *_Nullable)parameters {
    [HZNetWorkCache removeHttpCacheWithUrl:urlString parameters:parameters];
}

- (void)clearAllCache {
    [HZNetWorkCache removeAllHttpCache];
}


- (NSURLSessionTask *_Nullable)GET:(NSString *)url parameters:(NSDictionary * _Nullable)parameters configurationHandler:(void (^_Nullable)(HZNetworkConfig * _Nullable configuration))configurationHandler cache:(HZRequestManagerCache _Nullable )cache successed:(HZRequestManagerSuccess _Nullable )successed failured:(HZRequestManagerFailure _Nullable )failured {
    return [self.requestManager requestMethod:HZRequestMethodGet URLString:url parameters:parameters configurationHandler:^(HZNetworkConfig * _Nullable configuration) {
        
        //        NSString *contentStr = [[HeaderModel new] mj_JSONString];
        //        configuration.builtinHeaders = [NSMutableDictionary dictionary];
        //        [configuration.builtinHeaders setObject:contentStr forKey:@"App-Common-Params"];
        if (configurationHandler) {
            configurationHandler(configuration);
        }
    } cache:^(id  _Nullable responseObject, NSError *error) {
        cache ? cache(responseObject, error) : nil;
    } successed:^(NSURLSessionTask * _Nullable task, id  _Nullable responseObject) {
        successed ? successed(task, responseObject) : nil;
    } failured:^(NSURLSessionTask * _Nullable task, NSError * _Nullable error, AFNetworkReachabilityStatus netWorkStatus) {
        failured ? failured(task, error, netWorkStatus) : nil;
    }];
}

- (NSURLSessionTask *_Nullable)POST:(NSString *)url parameters:(NSDictionary * _Nullable)parameters configurationHandler:(void (^_Nullable)(HZNetworkConfig * _Nullable configuration))configurationHandler cache:(HZRequestManagerCache _Nullable )cache successed:(HZRequestManagerSuccess _Nullable )successed failured:(HZRequestManagerFailure _Nullable )failured {
    
    return [self.requestManager requestMethod:HZRequestMethodPost URLString:url parameters:parameters configurationHandler:^(HZNetworkConfig * _Nullable configuration) {
        
//        NSString *contentStr = [[HeaderModel new] mj_JSONString];
//        configuration.builtinHeaders = [NSMutableDictionary dictionary];
//        [configuration.builtinHeaders setObject:contentStr forKey:@"App-Common-Params"];
        if (configurationHandler) {
            configurationHandler(configuration);
        }
    } cache:^(id  _Nullable responseObject, NSError *error) {
        cache ? cache(responseObject, error) : nil;
    } successed:^(NSURLSessionTask * _Nullable task, id  _Nullable responseObject) {
        successed ? successed(task, responseObject) : nil;
    } failured:^(NSURLSessionTask * _Nullable task, NSError * _Nullable error, AFNetworkReachabilityStatus netWorkStatus) {
        failured ? failured(task, error, netWorkStatus) : nil;
    }];
}


/**
 上传图片资源
 
 @param url 连接
 @param parameters 参数
 @param block 文件
 @param configurationHandler e配置
 @param successed 成功回调
 @param failured 失败回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *_Nullable)uploadWithURLString:(NSString *)url
                                        parameters:(NSDictionary * _Nullable)parameters
                         constructingBodyWithBlock:(void (^_Nullable)(id <AFMultipartFormData> _Nullable formData))block
                              configurationHandler:(void (^_Nullable)(HZNetworkConfig * _Nullable configuration))configurationHandler
                                         successed:(HZRequestManagerSuccess _Nullable )successed
                                          failured:(HZRequestManagerFailure _Nullable )failured {
    
    return [self.requestManager uploadWithURLString:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nullable formData) {
        block ? block(formData) : nil;
    } configurationHandler:^(HZNetworkConfig * _Nullable configuration) {
//        NSString *contentStr = [[HeaderModel new] mj_JSONString];
//        configuration.builtinHeaders = [NSMutableDictionary dictionary];
//        [configuration.builtinHeaders setObject:contentStr forKey:@"App-Common-Params"];
        if (configurationHandler) {
            configurationHandler(configuration);
        }
        
    } progress:^(NSProgress * _Nullable progress) {
        
    } successed:^(NSURLSessionTask * _Nullable task, id  _Nullable responseObject) {
        successed ? successed(task, responseObject) : nil;
    } failured:^(NSURLSessionTask * _Nullable task, NSError * _Nullable error, AFNetworkReachabilityStatus netWorkStatus) {
        failured ? failured(task, error, netWorkStatus) : nil;
    }];
}


/**
 资源下载

 @param url 链接
 @param parameters 参数
 @param filePath 路径
 @param configurationHandler 配置
 @param successed 成功回调
 @param failured 失败回调
 @return task
 */
- (NSURLSessionTask *)Download:(NSString *)url parameters:(NSDictionary *)parameters filePath:(NSString *)filePath configurationHandler:(void (^)(HZNetworkConfig * _Nullable))configurationHandler successed:(HZRequestManagerSuccess)successed failured:(HZRequestManagerFailure)failured {
    
    return [self.requestManager downloadWithURLString:url parameters:parameters filePath:filePath configurationHandler:^(HZNetworkConfig * _Nullable configuration) {
        if (configurationHandler) {
            configurationHandler(configuration);
        }
    } progress:^(NSProgress * _Nullable progress) {
        
    } successed:^(NSURLSessionTask * _Nullable task, id  _Nullable responseObject) {
        successed ? successed(task, responseObject) : nil;
    } failured:^(NSURLSessionTask * _Nullable task, NSError * _Nullable error, AFNetworkReachabilityStatus netWorkStatus) {
        failured ? failured(task, error, netWorkStatus) : nil;
    }];
}



@end
