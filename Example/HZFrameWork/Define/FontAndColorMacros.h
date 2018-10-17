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

//字体
#define BoldSystemFont(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SystemFont(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define Font(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]


#endif /* FontAndColorMacros_h */
