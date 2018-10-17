//
//  UITabBar+CustomBadge.h
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/17.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CustomBadgeType){
    kCustomBadgeStyleRedDot,
    kCustomBadgeStyleNumber,
    kCustomBadgeStyleNone
};

@interface UITabBar (CustomBadge)

/**
 *设置tab上icon的宽度，用于调整badge的位置
 */
- (void)setTabIconWidth:(CGFloat)width;

/**
 *设置badge的top
 */
- (void)setBadgeTop:(CGFloat)top;

/**
 *设置badge样、数字
 */
- (void)setBadgeStyle:(CustomBadgeType)type value:(NSInteger)badgeValue atIndex:(NSInteger)index;
@end
