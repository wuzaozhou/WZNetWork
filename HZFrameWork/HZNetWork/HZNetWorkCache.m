//
//  HZNetWorkCache.m
//  HZNetWork
//
//  Created by 吴灶洲 on 2019/1/12.
//  Copyright © 2019年 吴灶洲. All rights reserved.
//

#import "HZNetWorkCache.h"
#import <YYKit/YYCache.h>
#import <YYKit/YYMemoryCache.h>
#import <YYKit/YYDiskCache.h>

static NSString *const HZNetworkCache = @"HZNetworkCache";
static NSString *const HZNetworkTimeOut = @"HZNetworkTimeOut";
static NSString *const HZCouponKey_sign  = @"HZCouponKey_sign ";
static NSString *const HZCouponKey_timestamp  = @"HZCouponKey_timestamp ";

@implementation HZNetWorkCache
static YYCache *_dataCache;

+ (void)initialize {
    _dataCache = [YYCache cacheWithName:HZNetworkCache];
}


/**
 异步缓存网络数据,根据请求的 URL与parameters
 做KEY存储数据, 这样就能缓存多级页面的数据
 
 @param httpData 服务器返回的数据
 @param URL 请求的URL地址
 @param parameters 请求的参数
 
 */
+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    [_dataCache setObject:httpData forKey:cacheKey withBlock:nil];
    //缓存请求过期时间
    [self setCacheInvalidTimeWithCacheKey:cacheKey];

}


/**
 根据请求的 URL与parameters 同步取出缓存数据
 
 @param URL 请求的URL
 @param parameters 请求的参数
 @param cacheValidTime 数据缓存时间
 @return 缓存的数据
 
 */
+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters cacheValidTime:(NSTimeInterval)cacheValidTime {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    id cache = [_dataCache objectForKey:cacheKey];

    if (!cache) {
        return nil;
    }

    if ([self verifyInvalidCache:cacheKey resultCacheDuration:cacheValidTime]) {
        return cache;
    }else{
//        [_dataCache.diskCache removeObjectForKey:cacheKey];
//        NSString *cacheDurationKey = [NSString stringWithFormat:@"%@_%@",cacheKey, HZNetworkTimeOut];
//        [_dataCache.diskCache removeObjectForKey:cacheDurationKey];
        return nil;
    }

}

/**
 获取缓存，不考虑缓存是否有效
 
 @param URL 请求的URL
 @param parameters 请求的参数
 @return 缓存的数据
 
 */
+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    return [_dataCache objectForKey:cacheKey];
}

/**
 获取网络缓存的总大小 bytes(字节)
 
 @return 大小
 */
+ (NSInteger)getAllHttpCacheSize {
    return [_dataCache.diskCache totalCost];
}

/**
 删除所有网络缓存
 */
+ (void)removeAllHttpCache {
    [_dataCache.memoryCache removeAllObjects];
    [_dataCache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
        
    } endBlock:^(BOOL error) {
        
    }];
}

/**
 删除缓存
 
 @param url url
 @param parameters 参数
 */
+ (void)removeHttpCacheWithUrl:(NSString *)url parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:url parameters:parameters];
    [_dataCache.memoryCache removeObjectForKey:cacheKey];
    [_dataCache.diskCache removeObjectForKey:cacheKey withBlock:^(NSString * _Nonnull key) {

    }];
}


+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    if(!parameters || parameters.count == 0){return URL;};
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@", URL, paraString];

    return [NSString stringWithFormat:@"%@",cacheKey];
}



/** 存入缓存创建时间 */
+ (void)setCacheInvalidTimeWithCacheKey:(NSString *)cacheKey{
    NSString *cacheDurationKey = [NSString stringWithFormat:@"%@_%@",cacheKey, HZNetworkTimeOut];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    [_dataCache setObject:@(nowTime) forKey:cacheDurationKey withBlock:nil];
}

/** 判断缓存是否有效，有效则返回YES */
+ (BOOL)verifyInvalidCache:(NSString *)cacheKey resultCacheDuration:(NSTimeInterval )resultCacheDuration {
    //获取该次请求失效的时间戳
    NSString *cacheDurationKey = [NSString stringWithFormat:@"%@_%@",cacheKey, HZNetworkTimeOut];
    id createTime = [_dataCache objectForKey:cacheDurationKey];
    NSTimeInterval createTime1 = [createTime doubleValue];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    if ((nowTime - createTime1) < resultCacheDuration) {
        return YES;
    }
    return NO;
}




@end
