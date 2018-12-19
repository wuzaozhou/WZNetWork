//
//  HZPageTitleViewModel.h
//  HZFramework
//
//  Created by JTom on 2018/10/9.
//  Copyright © 2018年 leejtom. All rights reserved.
//自定义配置

#import <UIKit/UIKit.h>

/**
 badge类型

 - HZPageTitleBadgeTypeNormal: //默认，实心红点
  - HZPageTitleBadgeTypeNumber: //数字，最大显示99+
 */
typedef NS_ENUM(NSInteger, HZPageTitleBadgeType) {
    HZPageTitleBadgeTypeNormal,
    HZPageTitleBadgeTypeNumber,
};

@interface HZPageTitleViewModel : NSObject

//默认字体
@property (nonatomic, strong) UIFont *titleFontNormal;
//默认文字颜色
@property (nonatomic, strong) UIColor *titleColorNormal;

//选中字体
@property (nonatomic, strong) UIFont *titleFontSelected;
//选中文字颜色
@property (nonatomic, strong) UIColor *titleColorSelected;

//指示器高度
@property (nonatomic, assign) CGFloat indicatorViewHeight;
//指示器宽度
@property (nonatomic, assign) CGFloat indicatorViewWidth;
//指示器颜色
@property (nonatomic, strong) UIColor *indicatorViewColor;
//指示器圆角
@property (nonatomic, assign) CGFloat indicatorViewCornerRadius;


//底部预留空间高度
@property (nonatomic, assign) CGFloat bottomSparatorHeight;
//底部预留空间颜色
@property (nonatomic, strong) UIColor *bottomSparatorColor;
//底部预留空间圆角
@property (nonatomic, assign) CGFloat bottomSparatorCornerRadius;

/** 标题额外增加的宽度，默认为 20.0f */
@property (nonatomic, assign) CGFloat titleAdditionalWidth;

/** 角标 */
//样式
@property (nonatomic, assign) HZPageTitleBadgeType badgeType;
//字体字体大小
@property (nonatomic, assign) CGFloat badgeFontSize;
//字体颜色
@property (nonatomic, strong) UIColor *badgeTitleColor;
//背景色
@property (nonatomic, strong) UIColor *badgeBackgroundColor;

/**
 开启自定义宽度
 如若开启此设置，必须设置titleItemViewWidth。
 */
@property (nonatomic, assign) BOOL customTitleItemViewWidth;
//自定义item的宽度
@property (nonatomic, assign) CGFloat titleItemViewWidth;

///默认选中第几个
@property (nonatomic, assign) NSUInteger defaultSelectIndex;

@end
