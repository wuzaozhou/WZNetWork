//
//  WZNetworkConfig.m
//  WZNetWork
//
//  Created by 吴灶洲 on 2019/1/12.
//  Copyright © 2019年 吴灶洲. All rights reserved.
//

#import "WZNetworkConfig.h"

const CGFloat WZRequestTimeoutInterval = 10.0f;


@implementation WZNetworkConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        _timeoutInterval = WZRequestTimeoutInterval;
        _requestCachePolicy = WZRequestCacheAndLoadToCache;
        _resultCacheDuration = 7*24*60*60;
    }
    return self;
}

- (AFHTTPRequestSerializer *)requestSerializer {
    if (!_requestSerializer) {
        _requestSerializer = [AFHTTPRequestSerializer serializer];
        _requestSerializer.timeoutInterval = _timeoutInterval;
    }
    return _requestSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializer {
    if (!_responseSerializer) {
        _responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _responseSerializer;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    WZNetworkConfig *configuration = [[WZNetworkConfig alloc] init];
    configuration.resultCacheDuration = self.resultCacheDuration;
    configuration.requestCachePolicy = self.requestCachePolicy;
    configuration.baseURL = [self.baseURL copy];
    configuration.builtinHeaders = [self.builtinHeaders copy];
    configuration.builtinBodys = [self.builtinBodys copy];
    configuration.resposeHandle = [self.resposeHandle copy];
    configuration.requestSerializer = [AFHTTPRequestSerializer serializer];
    configuration.requestSerializer.timeoutInterval = self.requestSerializer.timeoutInterval;
//    configuration.requestSerializer = [self.requestSerializer copy];
    configuration.responseSerializer = [self.responseSerializer copy];
    configuration.responseSerializer.acceptableContentTypes = self.responseSerializer.acceptableContentTypes;
    return configuration;
}

@end
