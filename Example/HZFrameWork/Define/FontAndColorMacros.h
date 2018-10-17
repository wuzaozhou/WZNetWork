//
//  FontAndColorMacros.h
//  HZFrameWork
//
//  Created by 兔兔 on 2018/10/17.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#ifndef FontAndColorMacros_h
#define FontAndColorMacros_h


//颜色
#define KClearColor [UIColor clearColor]
#define KWhiteColor [UIColor whiteColor]
#define KBlackColor [UIColor blackColor]
#define KGrayColor [UIColor grayColor]
#define KGray2Color [UIColor lightGrayColor]
#define KBlueColor [UIColor blueColor]
#define KRedColor [UIColor redColor]
#define kRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)        //随机色生成

//主题色 导航栏颜色
#define CNavBgColor   UIColorFromHexString(0x00AE68)
#define CNavBgFontColor  UIColorFromHexString(0xffffff)


//传入具体颜色值设置颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define UIColorFromHexString(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromHexStringWithAlpha(rgbValue,floatAlpha) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:floatAlpha]


//字体
#define BoldSystemFont(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SystemFont(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define Font(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]





#endif /* FontAndColorMacros_h */
