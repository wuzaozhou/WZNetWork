//
//  WZNetWork.h
//  WZNetWork
//
//  Created by 吴灶洲 on 2019/7/9.
//  Copyright © 2019 吴灶洲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface WZNetWork : NSObject
@property (nonatomic, strong) NSString * _Nullable baseURL;
+ (instancetype)sharedInstance;

- (NSURLSessionTask *_Nullable)GET:(NSString *)url parameters:(NSDictionary * _Nullable)parameters configurationHandler:(void (^_Nullable)(WZNetworkConfig * _Nullable configuration))configurationHandler cache:(WZRequestManagerCache _Nullable )cache successed:(WZRequestManagerSuccess _Nullable )successed failured:(WZRequestManagerFailure _Nullable )failured;
- (NSURLSessionTask *_Nullable)POST:(NSString *)url parameters:(NSDictionary * _Nullable)parameters configurationHandler:(void (^_Nullable)(WZNetworkConfig * _Nullable configuration))configurationHandler cache:(WZRequestManagerCache _Nullable )cache successed:(WZRequestManagerSuccess _Nullable )successed failured:(WZRequestManagerFailure _Nullable )failured;

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
                              configurationHandler:(void (^_Nullable)(WZNetworkConfig * _Nullable configuration))configurationHandler
                                         successed:(WZRequestManagerSuccess _Nullable )successed
                                          failured:(WZRequestManagerFailure _Nullable )failured;


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
- (NSURLSessionTask *)Download:(NSString *)url parameters:(NSDictionary *)parameters filePath:(NSString *)filePath configurationHandler:(void (^)(WZNetworkConfig * _Nullable))configurationHandler successed:(WZRequestManagerSuccess)successed failured:(WZRequestManagerFailure)failured;

/**
 删除缓存数据

 @param urlString 请求链接
 @param parameters 请求参数
 */
- (void)clearRequestCache:(NSString *_Nullable)urlString parameters:(NSDictionary *_Nullable)parameters;



/**
 删除所有的缓存数据
 */
- (void)clearAllCache;
@end

NS_ASSUME_NONNULL_END
