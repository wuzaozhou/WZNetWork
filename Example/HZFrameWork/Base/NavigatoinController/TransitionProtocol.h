//
//  TransitionProtocol.h
//  HZFrameWork
//
//  Created by 兔兔 on 2018/10/17.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TransitionProtocol <NSObject>
@optional

/**
 转场动画的目标View 需要转场动画的对象必须实现该方法并返回要做动画的View
 @return view
 */
-(UIView *)targetTransitionView;

/**
 *  是否是需要实现转场效果，不需要转场动画可不实现，需要必须实现并返回YES
 *
 *  @return 是否
 */
-(BOOL)isNeedTransition;

@end

