//
//  WZNetworkConfig.h
//  WZNetWork
//
//  Created by 吴灶洲 on 2019/1/12.
//  Copyright © 2019年 吴灶洲. All rights reserved.
//  网络请求配置

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat WZRequestTimeoutInterval;

@class HDError;

typedef NS_ENUM(NSUInteger, WZRequestCachePolicy) {
    /** WZRequestCacheOrLoadToCache, WZRequestCacheAndLoadToCache, WZRequestLoadToCache这三种方式如果网络请求失败且有缓存数据则直接返回缓存数据（不管缓存数据是否有效），如果不存在缓存则直接返回failured */
    WZRequestCacheOrLoadToCache,//如果缓存有效则直接返回缓存，不再load。缓存失效则load返回，且缓存数据，用于同一个网络请求在一定时间内不多次发起网络请求
    WZRequestCacheDontLoad,//如果缓存有效则直接返回缓存，缓存失效则返回nil，不再load
    WZRequestCacheAndLoadToCache,//如果缓存有效则直接返回缓存，并且load且缓存数据。缓存失效则load返回，且缓存数据
    WZRequestLoadToCache,//直接load并返回数据，且缓存数据，如果load失败则读取缓存数据
    WZRequestLoadDontCache,//直接load并返回数据，不缓存数据，如果load失败则直接抛出Error
};


@interface WZNetworkConfig : NSObject
@property (nonatomic, copy) NSString *baseURL;
///请求的一些配置（默认不变的信息），比如：缓存机制、请求超时、请求头信息等配置
@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;
///对返回的数据进行序列化，默认使用 AFJSONResponseSerializer，支持AFJSONResponseSerializer、AFXMLParserResponseSerializer、AFXMLDocumentResponseSerializer等
@property (nonatomic, strong) AFHTTPResponseSerializer *responseSerializer;
///请求的头部通用配置
@property (nonatomic, strong) NSMutableDictionary *builtinHeaders;
///请求体通用配置
@property (nonatomic, strong) NSMutableDictionary *builtinBodys;
///请求超时时间设置，默认15秒
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
///设置缓存时间，默认7*24*60*60秒（7*24小时）。如果 <= 0，表示不启用缓存。单位为秒，表示对于一个请求的结果缓存多长时间
@property (nonatomic, assign) NSInteger resultCacheDuration;
///缓存策略, 默认是WZRequestCacheOrLoadToCache
@property (nonatomic, assign) WZRequestCachePolicy requestCachePolicy;
///对请求返回的数据做统一的处理，比如token失效、重新登录等等操作。
@property (nonatomic, copy) id (^ resposeHandle)(NSURLSessionTask *dataTask, id responseObject);
@end

NS_ASSUME_NONNULL_END
