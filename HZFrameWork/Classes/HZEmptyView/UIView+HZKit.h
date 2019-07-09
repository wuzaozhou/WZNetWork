//
//  UIView+HZKit.h
//  HZEmptyView
//
//  Created by 兔兔 on 2018/9/29.
//  Copyright © 2018年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HZEmptyView;
@interface UIView (HZKit)
@property HZEmptyView *emptyView;

/**
 手动加载
 */
- (void)hz_showEmptyView;
/**
 手动隐藏
 */
- (void)hz_hideEmptyView;

/**
 开始加载
 *自动显隐模式下
 */
- (void)hz_startLoading;
/**
 结束加载
 *自动显隐模式下
 */
- (void)hz_endLoading;


@end
