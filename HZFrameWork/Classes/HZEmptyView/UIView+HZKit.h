//
//  UIView+RYKit.h
//  RYEmptyView
//
//  Created by 兔兔 on 2018/9/29.
//  Copyright © 2018年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RYEmptyView;
@interface UIView (RYKit)
@property RYEmptyView *emptyView;

/**
 手动加载
 */
- (void)ry_showEmptyView;
/**
 手动隐藏
 */
- (void)ry_hideEmptyView;

/**
 开始加载
 *自动显隐模式下
 */
- (void)ry_startLoading;
/**
 结束加载
 *自动显隐模式下
 */
- (void)ry_endLoading;


@end
