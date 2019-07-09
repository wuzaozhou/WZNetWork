//
//  HZEmptyView.h
//  HZEmptyView
//
//  Created by 兔兔 on 2018/9/29.
//  Copyright © 2018年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, HZEmptyType) {
    HZEmptyTypeNotNetwork,//无网络
    HZEmptyTypeNotContent,//无内容
};

typedef void(^HZEmptyResetBlock) (void);

@interface HZEmptyView : UIView


/**
 自动显隐
 */
@property (nonatomic, assign) BOOL autoShowAndHideEmptyView;

@property (nonatomic, copy, readonly) HZEmptyResetBlock resetBlock;
//类初始方法
+ (instancetype)createEmptyViewWithType:(HZEmptyType )type;

/**
 初始化
 
 @param type 类型
 @param block 回调block
 @return 实例
 */
+ (instancetype)createEmptyViewWithType:(HZEmptyType )type resetBlock:(HZEmptyResetBlock) block;

//实例初始方法
- (instancetype)initWithType:(HZEmptyType )type;

/**
 初始化
 
 @param type 类型
 @param block 回调block
 @return 实例
 */
- (instancetype)initWithType:(HZEmptyType )type resetBlock:(HZEmptyResetBlock) block;



- (void)show;
- (void)dismiss;

@end
