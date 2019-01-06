//
//  HZ_WebImageManager.m
//  FlowerTown
//
//  Created by 吴灶洲 on 2018/12/19.
//  Copyright © 2018年 HuaZhen. All rights reserved.
//

#import "HZ_WebImageManager.h"
#import "UIImage+HZ_Add.h"

@implementation HZ_WebImageManager

/**
 下载图片，生成指定大小、圆角
 
 @param urlStr 链接
 @param size 指定大小
 @param radius 圆角大小
 @param suffix 保存的地址加上后缀区分其他地方的图片的大小
 @param completed 完成回调
 */
+ (void)hz_setImageWithUrl:(NSString *)urlStr size:(CGSize)size radius:(CGFloat)radius suffix:(NSString *)suffix completed:(void(^)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL))completed {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSString *cacheurlStr;
        if (cacheurlStr == nil) {
            cacheurlStr = [urlStr stringByAppendingString:@"hzRadiusCache"];
        }else {
            cacheurlStr = [urlStr stringByAppendingString:suffix];
        }
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheurlStr];
        if (cacheImage) {
//            NSData *data = UIImagePNGRepresentation(cacheImage);
            dispatch_async(dispatch_get_main_queue(), ^{
                completed ? completed(cacheImage, nil, nil, 0, YES, url) : nil;
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [[NSError alloc] init];
                completed ? completed(nil, nil, error, 0, NO, url) : nil;
            });
            [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (!error) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        UIImage *radiusImage = [[image hz_imageByResizeToSize:size contentMode:UIViewContentModeScaleAspectFill] hz_imageByRoundCornerRadius:radius];
                        [[SDImageCache sharedImageCache] storeImage:radiusImage forKey:cacheurlStr completion:nil];
                        //清除原有非圆角图片缓存
                        [[SDImageCache sharedImageCache] removeImageForKey:urlStr withCompletion:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completed ? completed(radiusImage, data, error, cacheType, finished, imageURL) : nil;
                        });
                    });
                }
            }];
        }
    });
}


/**
 下载图片，生成指定大小、圆角、边框
 
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
+ (void)hz_setImageWithUrl:(NSString *)urlStr size:(CGSize)size radius:(CGFloat)radius corners:(UIRectCorner)corners borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor borderLineJoin:(CGLineJoin)borderLineJoin suffix:(NSString *)suffix completed:(void(^)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL))completed {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSString *cacheurlStr;
        if (cacheurlStr == nil) {
            cacheurlStr = [urlStr stringByAppendingString:@"hzRadiusCache"];
        }else {
            cacheurlStr = [urlStr stringByAppendingString:suffix];
        }
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:cacheurlStr];
        if (cacheImage) {
//            NSData *data = UIImagePNGRepresentation(cacheImage);
            dispatch_async(dispatch_get_main_queue(), ^{
                completed ? completed(cacheImage, nil, nil, 0, YES, url) : nil;
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [[NSError alloc] init];
                completed ? completed(nil, nil, error, 0, NO, url) : nil;
            });
            [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (!error) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        UIImage *radiusImage = [[image hz_imageByResizeToSize:size contentMode:UIViewContentModeScaleAspectFill] hz_imageByRoundCornerRadius:radius corners:corners borderWidth:borderWidth borderColor:borderColor borderLineJoin:borderLineJoin];
                        [[SDImageCache sharedImageCache] storeImage:radiusImage forKey:cacheurlStr completion:nil];
                        //清除原有非圆角图片缓存
                        [[SDImageCache sharedImageCache] removeImageForKey:urlStr withCompletion:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completed ? completed(radiusImage, data, error, cacheType, finished, imageURL) : nil;
                        });
                    });
                }
            }];
        }
    });
}


@end
