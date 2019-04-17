//
//  HZ_PhotoBrowser.h
//  FlowerTown
//
//  Created by 吴灶洲 on 2018/11/21.
//  Copyright © 2018年 HuaZhen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HZ_PhotoBrowser;
@class HZHUD;

typedef enum : NSUInteger {
    HZ_PhotoBrowserStyleDefault,//默认方式
    HZ_PhotoBrowserStyleNine,//九宫格
} HZ_PhotoBrowserStyle;


//配置小图和大图
@protocol HZ_PhotoBrowserDataSource <NSObject>
@required
/**
 九宫格滚到第几张图片需要的缩略图

 @param browser HZ_PhotoBrowser
 @param index 第几张图片
 @return 缩略图
 */
- (UIImage *)photoBrowser:(HZ_PhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
/**
 滚到第几张图片需要的URL链接

 @param browser HZ_PhotoBrowser
 @param index 第几张图片
 @return URL
 */
- (NSURL *)photoBrowser:(HZ_PhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
@end


@interface HZ_PhotoBrowser : UIView <UIScrollViewDelegate>
/** 非九宫格退出时回到原来的位置 */
@property (nonatomic, strong) UIView *sourceView;
/** 退出时能回到原来的位置，需要定义九图控件 */
@property (nonatomic, weak) UIView *sourceImagesContainerView;
/** 一共有多少张图片 */
@property (nonatomic, assign) NSInteger imageCount;
/** 从第几张图片开始展示，默认 0 */
@property (nonatomic, assign) int currentImageIndex;
/** 图片展示方式 */
@property (nonatomic, assign) HZ_PhotoBrowserStyle photoBrowserStyle;
/** 数据源 */
@property (nonatomic, weak) id<HZ_PhotoBrowserDataSource> dataSource;
/** show方法 */
- (void)show;
@end

NS_ASSUME_NONNULL_END
