//
//  HZPageTitleItemView.h
//  HZFramework
//
//  Created by lee on 2018/10/22.
//  Copyright © 2018年 leejtom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HZPageTitleViewModel;

@interface HZPageTitleItemView : UIView

/**
 初始化

 @param viewModel HZPageTitleViewModel
 @param frame frame
 @param title 按钮标题
 @param tag 下标
 @return HZPageTitleItemView
 */
- (instancetype)initWithViewModel:(HZPageTitleViewModel *)viewModel frame:(CGRect)frame tilte:(NSString *)title tag:(NSInteger)tag;

//按钮
@property (nonatomic, strong) UIButton *button;
//角标
@property (nonatomic, strong) UILabel *badgeLabel;

/**
 手动设置角标
 
 @param number 数量
 */
- (void)setBadgeWithNumber:(NSUInteger )number;

@end
