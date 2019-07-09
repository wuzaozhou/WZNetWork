//
//  HZ_FontFile.m
//  FlowerTown
//
//  Created by 吴灶洲 on 2018/11/25.
//  Copyright © 2018年 HuaZhen. All rights reserved.
//

#import "HZ_FontFile.h"

@implementation HZ_FontFile

+ (UIFont *)bolderSizeFont:(CGFloat)num {
    return [UIFont boldSystemFontOfSize:num];
}

+ (UIFont *)font:(CGFloat)num {
    return [[UIDevice currentDevice].systemVersion integerValue]<9?[UIFont systemFontOfSize:num]: [UIFont fontWithName:@"PingFang SC" size:num];
}

+ (UIFont *)regularFont:(CGFloat)num {
    return [[UIDevice currentDevice].systemVersion integerValue]<9?[UIFont systemFontOfSize:num]: [UIFont fontWithName:@"PingFangSC-Regular" size:num];
}

+ (UIFont *)semiboldFont:(CGFloat)num {
    return [[UIDevice currentDevice].systemVersion integerValue]<9?[UIFont boldSystemFontOfSize:num]: [UIFont fontWithName:@"PingFangSC-Semibold" size:num];
}

+ (UIFont *)mediumFont:(CGFloat)num {
    return [[UIDevice currentDevice].systemVersion integerValue]<9?[UIFont systemFontOfSize:num]: [UIFont fontWithName:@"PingFangSC-Medium" size:num];
}

@end
