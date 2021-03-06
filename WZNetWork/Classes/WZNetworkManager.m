//
//  WZNetworkManager.m
//  WZNetWork
//
//  Created by 吴灶洲 on 2019/1/12.
//  Copyright © 2019年 吴灶洲. All rights reserved.
//

#import "WZNetworkManager.h"



@interface WZNetworkManager ()<NSCopying>
/** 是AFURLSessionManager的子类，为HTTP的一些请求提供了便利方法，当提供baseURL时，请求只需要给出请求的路径即可 */
@property (nonatomic, strong) AFHTTPSessionManager *requestManager;

/** 将WZRequestMethod（NSInteger）类型转换成对应的方法名（NSString） */
@property (nonatomic, strong) NSDictionary *methodMap;

/**
 这个字典是为了实现 取消某一个urlString的本地网络缓存数据而设计，字典结构如下
 key:urlString
 value: @[cacheKey1, cacheKey2]
 当调用clearRequestCache:identifier:方法时，根据key找到对应的value，
 然后进行指定缓存、或者根据urlString批量删除
 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableSet <NSString *>*>*cacheKeys;
@end

@implementation WZNetworkManager

static WZNetworkManager *instance;


//单例方法
+ (instancetype)sharedInstance{
    return [[self alloc] init];
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
        if (self) {
            [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
                instance.networkStatus = status;
            }];
            [[AFNetworkReachabilityManager sharedManager] startMonitoring];
            
            instance.configuration = [[WZNetworkConfig alloc] init];
            
            _methodMap = @{
                           @"0" : @"POST",
                           @"1" : @"GET",
                           @"2" : @"HEAD",
                           @"3" : @"PUT",
                           @"4" : @"DELETE",
                           };
            if (!_cacheKeys) {
                _cacheKeys = [NSMutableDictionary dictionary];
            }
        }
    });
    return instance;
}

//alloc会调用allocWithZone，确保使用同一块内存地址
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
//copy的时候会调用copyWithZone
- (id)copyWithZone:(NSZone *)zone{
    return instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return instance;
}



#pragma mark - 实例化
- (AFHTTPSessionManager *)requestManager {
    if (!_requestManager) {
#ifdef WZ_TEST_MODE_ON
        // debug 版本的包仍然能够正常抓包
        _requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.baidu.com"]];
#else
        NSURLSessionConfiguration *conf = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        conf.connectionProxyDictionary = @{};
        _requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.baidu.com"] sessionConfiguration:conf];
#endif
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        _requestManager.securityPolicy = securityPolicy;
    }
    return _requestManager;
}


/**
 网络请求

 @param method 请求方法
 @param URLString 请求URL地址，不包含baseUrl
 @param parameters 请求参数
 @param configurationHandler 将默认的配置给到外面，外面可能需要特殊处理，可以修改baseUrl等信息
 @param cache  如果有的话返回缓存数据
 @param successed 请求成功
 @param failured 请求失败
 @return task
 */
- (NSURLSessionDataTask *_Nullable)requestMethod:(WZRequestMethod)method
                                       URLString:(NSString *_Nullable)URLString
                                      parameters:(NSDictionary *_Nullable)parameters
                            configurationHandler:(void (^_Nullable)(WZNetworkConfig * _Nullable configuration))configurationHandler
                                           cache:(WZRequestManagerCache _Nullable )cache
                                         successed:(WZRequestManagerSuccess _Nullable )successed
                                         failured:(WZRequestManagerFailure _Nullable )failured {
    WZNetworkConfig *configuration = [self disposeConfiguration:configurationHandler];
    if (!URLString) {
        URLString = @"";
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", configuration.baseURL, URLString];
    parameters = [self disposeRequestParameters:parameters];
    
    //获取缓存数据
    id (^ fetchCacheRespose)(void) = ^id (void) {
        id resposeObject = [WZNetWorkCache httpCacheForURL:requestUrl parameters:parameters cacheValidTime:configuration.resultCacheDuration];
        if (resposeObject) {
            return resposeObject;
        }
        return nil;
    };
    
    //判断数据的返回
    if (configuration.requestCachePolicy == WZRequestCacheDontLoad || configuration.requestCachePolicy == WZRequestCacheAndLoadToCache || configuration.requestCachePolicy == WZRequestCacheOrLoadToCache) {
        id resposeObject = fetchCacheRespose();
        cache(resposeObject, nil);
        
        if (configuration.requestCachePolicy == WZRequestCacheOrLoadToCache && resposeObject) {
            return nil;
        }
        
        if (configuration.requestCachePolicy == WZRequestCacheDontLoad) {
            return nil;
        }
    }
    
    //存数据
    void (^ saveCacheRespose)(id responseObject) = ^(id responseObject) {
        if (configuration.resultCacheDuration > 0) {
            [WZNetWorkCache setHttpCache:responseObject URL:requestUrl parameters:parameters];
        }
    };
    
    //接口请求
    if (method > self.methodMap.count - 1) {
        method = self.methodMap.count - 1;
    }
    NSString *methodKey = [NSString stringWithFormat:@"%d", (int)method];
    NSURLRequest *request = [self.requestManager.requestSerializer requestWithMethod:self.methodMap[methodKey]
                                                                           URLString:requestUrl
                                                                          parameters:parameters
                                                                               error:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    __weak typeof(self) weakself = self;
    __block NSURLSessionDataTask *dataTask = [self.requestManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error) {
            if (configuration.requestCachePolicy == WZRequestLoadToCache || ((configuration.requestCachePolicy == WZRequestCacheOrLoadToCache || configuration.requestCachePolicy == WZRequestCacheAndLoadToCache)&& fetchCacheRespose() == nil)) {//如果网络请求失败，则直接取缓存数据
                id resposeObject = [WZNetWorkCache httpCacheForURL:requestUrl parameters:parameters];
                resposeObject ? cache(resposeObject, error) : failured(dataTask, error, weakself.networkStatus);
            }else {
                failured(dataTask, error, weakself.networkStatus);
            }
            
        }else {
            if (configuration.requestCachePolicy != WZRequestLoadDontCache && responseObject != nil) {
                saveCacheRespose(responseObject);
            }
            if (configuration.resposeHandle) {
                responseObject = configuration.resposeHandle(dataTask, responseObject);
            }
            successed(dataTask, responseObject);
        }
    }];
    [dataTask resume];
    return dataTask;
}

/**
 上传资源
 
 @param URLString URLString 请求的URL地址，不包含baseUrl
 @param parameters 请求参数
 @param block 将要上传的资源回调
 @param configurationHandler 将默认的配置给到外面，外面可能需要特殊处理，可以修改baseUrl等信息
 @param progress 上传资源进度
 @param successed 请求成功
 @param failured 请求失败
 @return task
 */
- (NSURLSessionTask *_Nullable)uploadWithURLString:(NSString *_Nullable)URLString
                                        parameters:(NSDictionary *_Nullable)parameters
                         constructingBodyWithBlock:(void (^_Nullable)(id <AFMultipartFormData> _Nullable formData))block
                              configurationHandler:(void (^_Nullable)(WZNetworkConfig * _Nullable configuration))configurationHandler
                                          progress:(WZRequestManagerProgress _Nullable)progress
                                           successed:(WZRequestManagerSuccess _Nullable )successed
                                           failured:(WZRequestManagerFailure _Nullable )failured {
    WZNetworkConfig *configuration = [self disposeConfiguration:configurationHandler];
    parameters = [self disposeRequestParameters:parameters];
    NSString *requestUrl = [[NSURL URLWithString:URLString relativeToURL:[NSURL URLWithString:configuration.baseURL]] absoluteString];
    __weak typeof(self) weakself = self;
    NSURLSessionDataTask *dataTask = [self.requestManager POST:requestUrl
                                                    parameters:parameters
                                     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                         block(formData);
                                     } progress:^(NSProgress * _Nonnull uploadProgress) {
                                         progress(uploadProgress);
                                     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                         successed(task, responseObject);
                                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                         failured(task, error, weakself.networkStatus);
                                     }];
    [dataTask resume];
    return dataTask;
}



/**
 下载资源

 @param URLString url
 @param parameters 参数
 @param filePath 文件路径
 @param configurationHandler  将默认的配置给到外面，外面可能需要特殊处理，可以修改baseUrl等信息
 @param progress 进度
 @param successed 请求成功
 @param failured 请求失败
 @return task
 */
- (NSURLSessionDataTask *)downloadWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters filePath:(NSString *)filePath configurationHandler:(void (^)(WZNetworkConfig * _Nullable))configurationHandler progress:(WZRequestManagerProgress)progress successed:(WZRequestManagerSuccess)successed failured:(WZRequestManagerFailure)failured {
    
    __weak typeof(self) weakself = self;
    __block NSURLSessionDownloadTask *dataTask = [self.requestManager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]] progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //设置存储路径，下载成功会自动存储。注意使用fileURLWithPath
        if (filePath) {
            return [NSURL fileURLWithPath:filePath];
        }
        return nil;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failured(dataTask,error, weakself.networkStatus);
        }else{
            successed(dataTask,filePath);
        }
    }];
    
    [dataTask resume];
    return (NSURLSessionDataTask *)dataTask;
}

/** 取消所有的网络请求 */
- (void)cancelAllRequest {
    [self.requestManager invalidateSessionCancelingTasks:YES];
}

#pragma mark - 内部方法
- (NSDictionary *)disposeRequestParameters:(NSDictionary *)parameters {
    NSMutableDictionary *bodys = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (self.configuration.builtinBodys.allKeys.count > 0) {
        for (NSString *key in self.configuration.builtinBodys) {
            [bodys setObject:self.configuration.builtinBodys[key] forKey:key];
        }
    }
    return bodys;
}

- (WZNetworkConfig *)disposeConfiguration:(void (^_Nullable)(WZNetworkConfig * _Nullable configuration))configurationHandler {
    //configuration配置
    WZNetworkConfig *configuration = [self.configuration copy];
    if (configurationHandler) {
        configurationHandler(configuration);
    }
    self.requestManager.requestSerializer = configuration.requestSerializer;
    self.requestManager.responseSerializer = configuration.responseSerializer;
    if (configuration.builtinHeaders.allKeys.count > 0) {
        for (NSString *key in configuration.builtinHeaders) {
            [self.requestManager.requestSerializer setValue:configuration.builtinHeaders[key] forHTTPHeaderField:key];
        }
    }
    
    [self.requestManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    if (configuration.timeoutInterval > 0) {
        self.requestManager.requestSerializer.timeoutInterval = configuration.timeoutInterval;
    }else {
        self.requestManager.requestSerializer.timeoutInterval = WZRequestTimeoutInterval;
    }
    [self.requestManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    return configuration;
}


- (NSString *)serializeParams:(NSDictionary *)params {
    NSMutableArray *parts = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id<NSObject> obj, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@", key, obj];
        [parts addObject: part];
    }];
    if (parts.count > 0) {
        NSString *queryString = [parts componentsJoinedByString:@"&"];
        return queryString ? [NSString stringWithFormat:@"?%@", queryString] : @"";
    }
    return @"";
}

@end
