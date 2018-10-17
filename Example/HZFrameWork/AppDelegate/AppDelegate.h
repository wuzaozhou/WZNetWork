//
//  HZAppDelegate.h
//  HZFrameWork
//
//  Created by Runyalsj on 10/16/2018.
//  Copyright (c) 2018 Runyalsj. All rights reserved.
//

@import UIKit;
#import "BaseTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BaseTabBarController *mainTabBar;
@end
