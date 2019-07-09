//
//  HZPageTitleView.h
//  FlowerTown
//
//  Created by lee on 2018/9/29.
//  Copyright © 2018年 HuaZhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZPageTitleViewModel.h"
@class HZPageTitleItemView;

@protocol HZPageTitleViewDelegate <NSObject>

- (void)pageTitleViewDidSelectIndex:(NSInteger )index;

@end

@interface HZPageTitleView : UIView

@property (nonatomic, strong) NSArray<NSString *> *titleArray;

/**
 存放所有按钮，可根据titleArray下标获取对应的子控件。
 */
@property (nonatomic, strong) NSMutableArray<HZPageTitleItemView *> *buttonArray;

@property (nonatomic, weak) id<HZPageTitleViewDelegate> delegate;
//自定义配置
@property (nonatomic, strong) HZPageTitleViewModel *viewModel;

/**
 初始化
 @param array 标题数组
 @param frame frame
 @param config 配置文件
 @return instancetype
 */
- (instancetype)initWithTitleArray:(NSArray<NSString *> *)array frame:(CGRect) frame configuration:(HZPageTitleViewModel *)config;

/**
 手动设置选中文字

 @param targetIndex 目标下标
 */
- (void)setPageTileViewWithTargetIndex:(NSInteger)targetIndex;

/**
 手动设置角标

 @param number 数量
 @param targetIndex 目标下标
 */
- (void)setBadgeWithNumber:(NSUInteger)number index:(NSInteger)targetIndex;

@end
