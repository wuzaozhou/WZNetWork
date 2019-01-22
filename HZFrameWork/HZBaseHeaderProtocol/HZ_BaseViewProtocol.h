//
//  HZ_BaseViewProtocol.h
//  FlowerTown
//
//  Created by JTom on 2018/12/3.
//  Copyright © 2018 HuaZhen. All rights reserved.
//view、ViewController协议

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HZ_BaseViewProtocol <NSObject>

@required

/**
 添加控件，一些初始化设置放此处即可
 */
- (void)hz_addSubviews;

/**
 设置frame
 */
- (void)hz_setViewAutoLayout;

@optional
/**
 绑定ViewModel、绑定一些事件类
 */
- (void)hz_bindViewModel;
@end

NS_ASSUME_NONNULL_END
