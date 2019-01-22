//
//  HZ_BaseViewModelProtocol.h
//  FlowerTown
//
//  Created by JTom on 2018/12/3.
//  Copyright © 2018 HuaZhen. All rights reserved.
//viewModel协议

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HZ_BaseViewModelProtocol <NSObject>

@optional

/**
 初始化model实例

 @param model 参数
 @return instancetype
 */
- (instancetype)initWithModel:(id)model;

/**
 初始化方法
 */
- (void)hz_initialize;

@end

NS_ASSUME_NONNULL_END
