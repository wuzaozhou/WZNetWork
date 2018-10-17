//
//  UtilsMacros.h
//  HZFrameWork
//
//  Created by 兔兔 on 2018/10/17.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#ifndef UtilsMacros_h
#define UtilsMacros_h

//动态获取设备宽度
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
//动态获取设备高度
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size)): NO)

#define kBottomHeight (kDevice_Is_iPhoneX ? 34 : 0)
#define kNavigationHeight (kDevice_Is_iPhoneX ? 88 : 64)
#define kNavigationGrowthHeight (kDevice_Is_iPhoneX ? 22 : 0)
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight 64

#endif /* UtilsMacros_h */
