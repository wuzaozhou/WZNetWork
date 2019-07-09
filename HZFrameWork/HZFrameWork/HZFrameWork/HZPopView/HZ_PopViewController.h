//
//  WZZPopViewController.h
//  弹出选择框
//
//  Created by 吴灶洲 on 2017/2/21.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZ_PopViewController : UIViewController<UIPopoverPresentationControllerDelegate>

+ (instancetype)presentPopViewSourceView:(UIView *)sourceView size:(CGSize)size permittedArrowDirections:(UIPopoverArrowDirection)permittedArrowDirections;

- (instancetype)initWithSourceView:(UIView *)sourceView size:(CGSize)size permittedArrowDirections:(UIPopoverArrowDirection)permittedArrowDirections NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)setupView;
@end
