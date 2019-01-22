//
//  HZHUD.h
//  HZHUD
//
//  Created by 吴灶洲 on 2017/3/22.
//  Copyright © 2017年 wuzaozhou. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface HZHUD :  NSObject
/**
 显示花镇loading图标到指定view上，隐藏方法则直接点用[HZHUD hideHUDForView:]
 
 @param view 指定view，如果view为nil，则直接添加到window
 @return MBProgressHUD
 */
+ (MBProgressHUD *)hz_showLoadingWithView:(UIView *)view;

/**
 显示花镇loading图标到window上，隐藏方法则直接点用[HZHUD hideHUDForView:]
 
 @return MBProgressHUD
 */
+ (MBProgressHUD *)hz_showLoading;

/**
 菊花转loading到指定view，需要手动隐藏
 
 @param message 信息内容
 @param view 指定view
 @return MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

/**
 window上显示菊花转loading
 
 @param message 信息内容
 @return MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;
/**
 简单文字提示。tost
 
 @param text 信息内容
 */
+ (void)showWithText:(NSString *)text;

/**
 简单文字提示。tost，需要手动调用消息
 
 @param text 信息内容
 */
+ (void)showWithHUDText:(NSString *)text;

/**
 文字提示加上图标，tost到指定view
 
 @param text 文字
 @param icon 图标
 @param view 指定view
 */
+ (void)show:(NSString *)text icon:(UIImage *)icon view:(UIView *)view;

/**
 提示错误信息导置顶指定view
 
 @param error 信息内容
 @param view 指定view
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 window上提示错误信息
 
 @param error 错误信息
 */
+ (void)showError:(NSString *)error;

/**
 提示成功信息
 
 @param success 信息内容
 @param view 要显示的view
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 window上提示成功信息
 
 @param success 成功信息
 */
+ (void)showSuccess:(NSString *)success;

/**
 隐藏制定view上的hud
 
 @param view 指定的view
 */
+ (void)hideHUDForView:(UIView *)view;
/**
 隐藏window上的hud
 */
+ (void)hideHUD;

@end
