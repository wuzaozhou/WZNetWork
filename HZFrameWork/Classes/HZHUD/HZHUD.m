//
//  HZHUD.m
//  HZHUD
//
//  Created by 吴灶洲 on 2018/12/1.
//  Copyright © 2017年 wuzaozhou. All rights reserved.
//

#import "HZHUD.h"

@implementation HZHUD

/**
 显示花镇loading图标到指定view上，隐藏方法则直接点用[HZHUD hideHUDForView:]
 
 @param view 指定view，如果view为nil，则直接添加到window
 @return MBProgressHUD
 */
+ (MBProgressHUD *)hz_showLoadingWithView:(UIView *)view {
    return [self hz_showLoadingWithView:view userInteractionEnabled:YES];
}

/**
 显示花镇loading图标到指定view上，隐藏方法则直接点用[HZHUD hideHUDForView:]
 
 @param view 指定view，如果view为nil，则直接添加到window
 @param userInteractionEnabled 蒙版是否可以点击
 @return MBProgressHUD
 */
+ (MBProgressHUD *)hz_showLoadingWithView:(UIView *)view userInteractionEnabled:(BOOL)userInteractionEnabled {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = userInteractionEnabled;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];
    //    hud.defaultMotionEffectsEnabled = YES;
    UIImageView *imageView = [[UIImageView alloc] init];
    NSMutableArray<UIImage *> *array = [NSMutableArray array];
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    for (int i = 1; i < 22; i++) {
        NSString *name = [NSString stringWithFormat:@"load00%02d@2x.png", i];
        NSString *filePath = [bundle pathForResource:name ofType:nil inDirectory:@"HZFrameWork.bundle"];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        [array addObject:image];
    }
    imageView.animationImages = array;
    [imageView startAnimating];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    //    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

/**
 显示花镇loading图标到window上，隐藏方法则直接点用[HZHUD hideHUDForView:]
 
 @return MBProgressHUD
 */
+ (MBProgressHUD *)hz_showLoading {
    return [self hz_showLoadingWithView:[UIApplication sharedApplication].keyWindow];
}

/**
 菊花转loading到指定view，需要手动隐藏
 
 @param message 信息内容
 @param view 指定view
 @return MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    hud.removeFromSuperViewOnHide = YES;
    hud.defaultMotionEffectsEnabled = YES;
    [UIActivityIndicatorView appearance].activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    hud.label.text = message;
    return hud;
}

/**
 window上显示菊花转loading
 
 @param message 信息内容
 @return MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message {
    return [self showMessage:message toView:nil];
}

/**
 简单文字提示。tost，自动消失
 
 @param text 信息内容
 */
+ (void)showWithText:(NSString *)text {
    UIView *view = [UIApplication sharedApplication].keyWindow;
    view.hidden = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.label.numberOfLines = 0;
    hud.label.text = text;
    hud.label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    hud.contentColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:4.0];
}

/**
 简单文字提示。tost，自动消失
 
 @param text 信息内容
 @param afterDelay 多久之后消失
 */
+ (void)showWithText:(NSString *)text afterDelay:(CGFloat)afterDelay {
    UIView *view = [UIApplication sharedApplication].keyWindow;
    view.hidden = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.label.numberOfLines = 0;
    hud.label.text = text;
    hud.label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    hud.contentColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:afterDelay];
}

/**
 简单文字提示。tost，需要手动调用消息
 
 @param text 信息内容
 */
+ (void)showWithHUDText:(NSString *)text {
    UIView *view = [UIApplication sharedApplication].keyWindow;
    view.hidden = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.contentColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeCustomView;
}

/**
 文字提示加上图标，tost到指定view
 
 @param text 文字
 @param icon 图标
 @param view 指定view
 */
+ (void)show:(NSString *)text icon:(UIImage *)icon view:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    view.hidden = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.customView = [[UIImageView alloc] initWithImage:icon];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:4.0];
}

/**
 提示错误信息导置顶指定view
 
 @param error 信息内容
 @param view 指定view
 */
+ (void)showError:(NSString *)error toView:(UIView *)view {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *name = [NSString stringWithFormat:@"MBHUD_Error@2x.png"];
    NSString *filePath = [bundle pathForResource:name ofType:nil inDirectory:@"HZFrameWork.bundle"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    [self show:error icon:image view:view];
}

/**
 window上提示错误信息
 
 @param error 错误信息
 */
+ (void)showError:(NSString *)error {
    [self showError:error toView:nil];
}

/**
 提示成功信息
 
 @param success 信息内容
 @param view 要显示的view
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *name = [NSString stringWithFormat:@"MBHUD_Success@2x.png"];
    NSString *filePath = [bundle pathForResource:name ofType:nil inDirectory:@"HZFrameWork.bundle"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    [self show:success icon:image view:view];
}

/**
 window上提示成功信息
 
 @param success 成功信息
 */
+ (void)showSuccess:(NSString *)success {
    [self showSuccess:success toView:nil];
}


/**
 隐藏制定view上的hud
 
 @param view 指定的view
 */
+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}

/**
 隐藏window上的hud
 */
+ (void)hideHUD {
    [self hideHUDForView:nil];
}

@end
