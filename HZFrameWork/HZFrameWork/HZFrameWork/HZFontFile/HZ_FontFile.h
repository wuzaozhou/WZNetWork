//
//  HZ_FontFile.h
//  FlowerTown
//
//  Created by 吴灶洲 on 2018/11/25.
//  Copyright © 2018年 HuaZhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZ_FontFile : NSObject

+ (UIFont *)heavyFont:(CGFloat)num;

+ (UIFont *)bolderSizeFont:(CGFloat)num;

+ (UIFont *)font:(CGFloat)num;

+ (UIFont *)regularFont:(CGFloat)num;

+ (UIFont *)semiboldFont:(CGFloat)num;

+ (UIFont *)mediumFont:(CGFloat)num;
@end

NS_ASSUME_NONNULL_END
