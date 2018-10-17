//
//  AppDelegate+AppService.h
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/17.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//


#import "AppDelegate.h"

@interface AppDelegate (AppService)

//初始化服务
//-(void)initService;

//初始化 window
-(void)initWindow;


//初始化用户系统
-(void)initUserManager;

/**
 当前顶层控制器
 */
-(UIViewController*) getCurrentVC;

-(UIViewController*) getCurrentUIVC;

@end
