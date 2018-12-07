//
//  WZZPopViewController.m
//  弹出选择框
//
//  Created by 吴灶洲 on 2017/2/21.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import "HZ_PopViewController.h"

@interface HZ_PopViewController ()



@end

#pragma clang diagnostic push

#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

@implementation HZ_PopViewController

+ (instancetype)presentPopViewSourceView:(UIView *)sourceView size:(CGSize)size permittedArrowDirections:(UIPopoverArrowDirection)permittedArrowDirections {
    //初始化 VC
    HZ_PopViewController *popVC = [[self alloc] initWithSourceView:sourceView size:size permittedArrowDirections:permittedArrowDirections];
//    popVC.addArray = dataArray;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:popVC animated:YES completion:nil];
    return popVC;
}

- (instancetype)init {
    self = [self initWithSourceView:nil size:CGSizeZero permittedArrowDirections:UIPopoverArrowDirectionAny];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithSourceView:(UIView *)sourceView size:(CGSize)size permittedArrowDirections:(UIPopoverArrowDirection)permittedArrowDirections {
    self = [super init];
    if (self) {
        //content尺寸
        self.preferredContentSize = size;
        //设置 VC 弹出方式
        self.modalPresentationStyle = UIModalPresentationPopover;
        //设置依附的按钮
        //    self.itemPopVC.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
        self.popoverPresentationController.sourceView = sourceView;
        //可以指示小箭头颜色
        self.popoverPresentationController.backgroundColor = [UIColor clearColor];
        //箭头方向
        self.popoverPresentationController.permittedArrowDirections = permittedArrowDirections;
        
        // 指定箭头所指区域的矩形框范围（位置和尺寸）,以sourceView的左上角为坐标原点
        // 这个可以 通过 Point 或  Size 调试位置
        // 使用导航栏的左右按钮不需要这句代码
        self.popoverPresentationController.sourceRect = sourceView.bounds;
        //代理
        self.popoverPresentationController.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView {
    
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;   //点击蒙版popover消失， 默认YES
}

@end
#pragma clang diagnostic pop
