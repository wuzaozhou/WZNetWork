//
//  HZNetWorkCache.h
//  HZNetWork
//
//  Created by 吴灶洲 on 2019/1/12.
//  Copyright © 2019年 吴灶洲. All rights reserved.
//  基于YYCahce做缓存

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZNetWorkCache : NSObject
/**
 异步缓存网络数据,根据请求的 URL与parameters
 做KEY存储数据, 这样就能缓存多级页面的数据

 @param httpData 服务器返回的数据
 @param URL 请求的URL地址
 @param parameters 请求的参数
 
 */
+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(id)parameters;

/**
 根据请求的 URL与parameters 同步取出缓存数据

 @param URL 请求的URL
 @param parameters 请求的参数
 @param cacheValidTime 数据缓存时间
 @return 缓存的数据
 
 */
+ (id)httpCacheForURL:(NSString *)URL  parameters:(id)parameters cacheValidTime:(NSTimeInterval)cacheValidTime;// header:(NSDictionary *)header;


/**
 获取缓存，不考虑缓存是否有效

 @param URL 请求的URL
 @param parameters 请求的参数
 @return 缓存的数据
 
 */
+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters;// header:(NSDictionary *)header;

/**
 获取网络缓存的总大小 bytes(字节)

 @return 大小
 */
+ (NSInteger)getAllHttpCacheSize;



/**
 删除所有网络缓存
 */
+ (void)removeAllHttpCache;


/**
 删除缓存
 
 @param url url
 @param parameters 参数
 
 */
+ (void)removeHttpCacheWithUrl:(NSString *)url parameters:(NSDictionary *)parameters;// header:(NSDictionary *)header;

/**
 返回请求的缓存的key

 @param URL URL
 @param parameters 参数
 @return key
 */
+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters;

/** 判断缓存是否有效，有效则返回YES */
+ (BOOL)verifyInvalidCache:(NSString *)cacheKey resultCacheDuration:(NSTimeInterval )resultCacheDuration;
@end

NS_ASSUME_NONNULL_END
