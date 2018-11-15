//
//  HZRequestConst.h
//  HZFrameWork
//
//  Created by 兔兔 on 2018/10/16.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#ifndef HZRequestConst_h
#define HZRequestConst_h

@class HZURLRequest,HZBatchRequest;

#define HZBUG_LOG 1

#if(HZBUG_LOG == 1)
# define HZLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
# define HZLog(...);
#endif


/**
 用于标识不同类型的请求
 */
typedef NS_ENUM(NSInteger,apiType) {
    /** 重新请求:   不读取缓存，重新请求*/
    HZRequestTypeRefresh,
    /** 读取缓存:   有缓存,读取缓存--无缓存，重新请求*/
    HZRequestTypeCache,
    /** 加载更多:   不读取缓存，重新请求*/
    HZRequestTypeRefreshMore,
    /** 加载更多:   有缓存,读取缓存--无缓存，重新请求*/
    HZRequestTypeCacheMore,
    /** 详情页面:   有缓存,读取缓存--无缓存，重新请求*/
    HZRequestTypeDetailCache,
    /** 读取缓存:   有缓存,读取缓存--重新请求 --最新数据覆盖缓存*/
    HZRequestTypeRefreshAndCache,
    /** 自定义项:   有缓存,读取缓存--无缓存，重新请求*/
    HZRequestTypeCustomCache
};
/**
 HTTP 请求类型.
 */
typedef NS_ENUM(NSInteger,MethodType) {
    /**POST请求*/
    HZMethodTypePOST,
    /**GET请求*/
    HZMethodTypeGET,
    /**Upload请求*/
    HZMethodTypeUpload,
    /**DownLoad请求*/
    HZMethodTypeDownLoad,
    /**PUT请求*/
    HZMethodTypePUT,
    /**PATCH请求*/
    HZMethodTypePATCH,
    /**DELETE请求*/
    HZMethodTypeDELETE
};
/**
 请求参数的格式.默认是HTTP
 */
typedef NS_ENUM(NSUInteger, requestSerializerType) {
    /** 设置请求参数为二进制格式*/
    HZHTTPRequestSerializer,
    /** 设置请求参数为JSON格式*/
    HZJSONRequestSerializer
};
/**
 返回响应数据的格式.默认是JSON
 */
typedef NS_ENUM(NSUInteger, responseSerializerType) {
    /** 设置响应数据为JSON格式*/
    HZJSONResponseSerializer,
    /** 设置响应数据为二进制格式*/
    HZHTTPResponseSerializer
};

/** 批量请求配置的Block */
typedef void (^batchRequestConfig)(HZBatchRequest * batchRequest);
/** 请求配置的Block */
typedef void (^requestConfig)(HZURLRequest * request);
/** 请求成功的Block */
typedef void (^requestSuccess)(id responseObject,apiType type,BOOL isCache);
/** 请求失败的Block */
typedef void (^requestFailure)(NSError * error);
/** 请求进度的Block */
typedef void (^progressBlock)(NSProgress * progress);
/** 请求取消的Block */
typedef void (^cancelCompletedBlock)(BOOL results,NSString * urlString);


#endif /* HZRequestConst_h */
