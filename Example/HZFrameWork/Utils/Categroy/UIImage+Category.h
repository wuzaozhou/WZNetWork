//
//  UIImage+Category.h
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/17.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
@property (copy, nonatomic) NSString * name;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

/**
 图片转成NSData类型
 @return 二进制数据
 */
- (NSData *)imageToData;

- (UIImage*)resizeImageToSize:(CGSize)size;

/// 圆形图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize )size;

/// size=1的图片
+ (UIImage *)imageWithColor:(UIColor *)color;

//转化文字为图片
+(UIImage *)imageFromText:(NSArray*) arrContent withFont: (CGFloat)fontSize;
//灰色处理图片主题色
- (UIImage*)grayscale:(UIImage*)anImage type:(int)type;

/// 将gif转图片数组
+ (NSArray *)getGIFImagesWithBundleName:(NSString *)gifName;

@end
