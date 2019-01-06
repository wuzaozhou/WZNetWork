//
//  UIImageView+HZ_WebImage.h
//  FlowerTown
//
//  Created by 吴灶洲 on 2018/12/19.
//  Copyright © 2018年 HuaZhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImageManager.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (HZ_WebImage)
/**
 UIImageView 显示网络图片
 
 @param urlStr 链接
 @param placeholderImage 占位图
 @param size 要生成的图片指定大小
 @param radius 圆角
 @param completed 完成回调
 */
- (void)hz_setImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage * _Nullable)placeholderImage size:(CGSize)size radius:(CGFloat)radius completed:(void(^)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL))completed;


/**
 UIImageView 显示网络图片
 
 @param urlStr 链接
 @param placeholderImage 占位图
 @param size 要生成的图片指定大小
 @param radius 圆角
 @param suffix 保存的地址加上后缀区分其他地方的图片的大小
 @param completed 完成回调
 */
- (void)hz_setImageWithUrl:(NSString *)urlStr placeholderImage:(nullable UIImage *)placeholderImage size:(CGSize)size radius:(CGFloat)radius suffix:(nullable NSString *)suffix completed:(void(^)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL))completed;

/**
 UIImageView 显示图片，生成指定大小、圆角、边框
 
 @param urlStr 链接
 @param size 指定大小
 @param radius 圆角大小
 @param corners 圆角位置
 @param borderWidth 边框大小
 @param borderColor 边框颜色
 @param borderLineJoin 边框链接方式
 @param completed 完成回调
 */
- (void)hz_setImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage * _Nullable)placeholderImage size:(CGSize)size radius:(CGFloat)radius corners:(UIRectCorner)corners borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor borderLineJoin:(CGLineJoin)borderLineJoin completed:(void(^)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL))completed;
/**
 UIImageView 显示图片，生成指定大小、圆角、边框
 
 @param urlStr 链接
 @param size 指定大小
 @param radius 圆角大小
 @param corners 圆角位置
 @param borderWidth 边框大小
 @param borderColor 边框颜色
 @param borderLineJoin 边框链接方式
 @param suffix 保存的地址加上后缀区分其他地方的图片的大小
 @param completed 完成回调
 */
- (void)hz_setImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage * _Nullable)placeholderImage size:(CGSize)size radius:(CGFloat)radius corners:(UIRectCorner)corners borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor borderLineJoin:(CGLineJoin)borderLineJoin suffix:(nullable NSString *)suffix completed:(void(^)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL))completed;
@end

NS_ASSUME_NONNULL_END
