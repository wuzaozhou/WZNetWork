//
//  WZNetworkManager.h
//  WZNetWork
//
//  Created by 吴灶洲 on 2019/1/12.
//  Copyright © 2019年 吴灶洲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "WZNetworkConfig.h"
#import "WZNetWorkCache.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WZRequestMethod) {
    WZRequestMethodPost = 0,//Post方法
    WZRequestMethodGet,//Get方法
    WZRequestMethodHead,//Header方法
    WZRequestMethodPut,//Put方法
    WZRequestMethodDelete,//Delete 方法
};

typedef void(^WZRequestManagerCompletion)(NSURLSessionTask * _Nullable httpbase, id _Nullable cacheResponse, id _Nullable response, NSError * _Nullable error);
typedef void(^WZRequestManagerCache)(id _Nullable responseObject, NSError * _Nullable error);
typedef void(^WZRequestManagerSuccess)(NSURLSessionTask * _Nullable task, id _Nullable responseObject);
typedef void(^WZRequestManagerFailure)(NSURLSessionTask * _Nullable task, NSError * _Nullable error, AFNetworkReachabilityStatus netWorkStatus);
typedef void(^WZRequestManagerProgress)(NSProgress * _Nullable progress);

@interface WZNetworkManager : NSObject
/** 当前的网络状态 */
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;
/** 上层的请求配置，通过该属性传递，保证该类内部不处理上层的逻辑 */
@property (nonatomic, strong) WZNetworkConfig * _Nullable configuration;
/** 单例 */
+ (instancetype)sharedInstance;
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
                                         failured:(WZRequestManagerFailure _Nullable )failured;
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
                                           failured:(WZRequestManagerFailure _Nullable )failured;


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
- (NSURLSessionDataTask *)downloadWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters filePath:(NSString *)filePath configurationHandler:(void (^)(WZNetworkConfig * _Nullable))configurationHandler progress:(WZRequestManagerProgress)progress successed:(WZRequestManagerSuccess)successed failured:(WZRequestManagerFailure)failured;

/** 取消所有的网络请求 */
- (void)cancelAllRequest;
@end

NS_ASSUME_NONNULL_END
