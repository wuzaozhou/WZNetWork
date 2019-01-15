//
//  HZPageContentView.h
//  HZFramework
//
//  Created by JTom on 2018/10/9.
//  Copyright © 2018年 leejtom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HZPageContentView;
@protocol HZPageContentViewDeleagte <NSObject>

- (void)pageContentView:(HZPageContentView *)pageContentView index:(NSUInteger)index;

@end

@interface HZPageContentView : UIView

@property (nonatomic, weak) id<HZPageContentViewDeleagte> delegate;

- (instancetype)initWithChildArray:(NSArray<UIViewController *> *)childArray parentViewController:(UIViewController *) parentVC;

- (instancetype)initWithChildArray:(NSArray<UIViewController *> *)childArray  parentViewController:(UIViewController *) parentVC frame:(CGRect)frame;

@property(nonatomic,assign,readonly) NSUInteger selectorIndex;

/**
 手动设置当前页面

 @param index 下标
 */
- (void)setPageContentViewWithTargetIndex:(NSUInteger)index;

- (UIViewController *)getChildViewControllerWithIndex:(NSInteger )index;

@end

