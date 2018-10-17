//
//  BaseTabBarController.m
//  HZFrameWork_Example
//
//  Created by 兔兔 on 2018/10/17.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseTabBar.h"
#import "UITabBar+CustomBadge.h"
#import "BaseNavigationController.h"
@interface BaseTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic,strong) NSMutableArray * baseVcs;//tabbar root VC
@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    //初始化tabbar
    [self setUpTabBar];
    //添加子控制器
    [self setUpAllChildViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark ————— 初始化TabBar —————
-(void)setUpTabBar{
    //设置背景色 去掉分割线
    [self setValue:[BaseTabBar new] forKey:@"tabBar"];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    //通过这两个参数来调整badge位置
    //    [self.tabBar setTabIconWidth:29];
    //    [self.tabBar setBadgeTop:9];
}


#pragma mark - ——————— 初始化VC ————————
-(void)setUpAllChildViewController{
    _baseVcs = @[].mutableCopy;
    UIViewController *homeVC = [[NSClassFromString(@"HZHomeViewController") alloc] init];
    [self setupChildViewController:homeVC title:@"首页" imageName:@"icon_tabbar_homepage" seleceImageName:@"icon_tabbar_homepage_selected"];
    
    UIViewController *discoverVC = [[NSClassFromString(@"HZDiscoverViewController") alloc] init];
    [self setupChildViewController:discoverVC title:@"发现" imageName:@"icon_tabbar_onsite" seleceImageName:@"icon_tabbar_onsite_selected"];
    
    UIViewController *messageVC = [[NSClassFromString(@"HZMessageViewController") alloc] init];
    [self setupChildViewController:messageVC title:@"消息" imageName:@"icon_tabbar_merchant_normal" seleceImageName:@"icon_tabbar_merchant_selected"];
    
    UIViewController *mineVC = [[NSClassFromString(@"HZMineViewController") alloc] init];
    [self setupChildViewController:mineVC title:@"我的" imageName:@"icon_tabbar_mine" seleceImageName:@"icon_tabbar_mine_selected"];
    self.viewControllers = _baseVcs;
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KBlackColor,NSFontAttributeName:SystemFont(10.0f)} forState:UIControlStateNormal];
    //选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CNavBgColor,NSFontAttributeName:SystemFont(10.0f)} forState:UIControlStateSelected];
    //包装导航控制器
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:controller];
    [_baseVcs addObject:nav];
    
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //    NSLog(@"选中 %ld",tabBarController.selectedIndex);
    
}

-(void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow{
    if (isShow) {
        [self.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:0 atIndex:index];
    }else{
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNone value:0 atIndex:index];
    }
    
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
