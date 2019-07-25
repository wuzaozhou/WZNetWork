//
//  WZViewController.m
//  WZNetWork
//
//  Created by wuzaozhou on 07/25/2019.
//  Copyright (c) 2019 wuzaozhou. All rights reserved.
//

#import "WZViewController.h"
#import "WZNetWork.h"

@interface WZViewController ()

@end

@implementation WZViewController



- (IBAction)onClick:(id)sender {
    //设置统一的url
    [WZNetWork sharedInstance].baseURL = @"http://996.yuanhe.xin";
    [[WZNetWork sharedInstance] GET:@"api/index/journey/lists?page=1" parameters:nil configurationHandler:^(WZNetworkConfig * _Nullable configuration) {
        
        configuration.baseURL =@"http://996.yuanhe.xin";//针对不同的网络请求单独设置URL
        configuration.requestCachePolicy = WZRequestCacheOrLoadToCache;//缓存方式
        configuration.resultCacheDuration = 5*60;//缓存时间
        
    } cache:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"缓存数据：%@", responseObject);
    } successed:^(NSURLSessionTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"数据：%@", responseObject);
    } failured:^(NSURLSessionTask * _Nullable task, NSError * _Nullable error, AFNetworkReachabilityStatus netWorkStatus) {
        
    }];
}

- (IBAction)delete {
    [[WZNetWork sharedInstance] clearRequestCache:@"http://996.yuanhe.xin/api/index/journey/lists?page=1" parameters:nil];
}
@end
