//
//  HZPageTitleViewModel.m
//  HZFramework
//
//  Created by JTom on 2018/10/9.
//  Copyright © 2018年 leejtom. All rights reserved.
//

#import "HZPageTitleViewModel.h"

@implementation HZPageTitleViewModel

- (UIFont *)titleFontNormal {
    if (!_titleFontNormal) {
        _titleFontNormal = [UIFont systemFontOfSize:15];
    }
    return _titleFontNormal;
}
- (UIFont *)titleFontSelected {
    if (!_titleFontSelected) {
        _titleFontSelected = [UIFont boldSystemFontOfSize:20];
    }
    return _titleFontSelected;
}

- (UIColor *)titleColorNormal {
    if (!_titleColorNormal) {
        _titleColorNormal = [self colorWithHexString:@"#666666"];
    }
    return _titleColorNormal;
}
- (UIColor *)titleColorSelected {
    if (!_titleColorSelected) {
        _titleColorSelected = [self colorWithHexString:@"#333333"];
    }
    return _titleColorSelected;
}

- (UIColor *)bottomSparatorColor {
    if (!_bottomSparatorColor) {
        _bottomSparatorColor = [UIColor clearColor];
    }
    return _bottomSparatorColor;
}

- (CGFloat)bottomSparatorCornerRadius {
    return _bottomSparatorCornerRadius;
}

- (UIColor *)indicatorViewColor {
    if (!_indicatorViewColor) {
        _indicatorViewColor = [self colorWithHexString:@"#FF495C "];
    }
    return _indicatorViewColor;
}

- (CGFloat)indicatorViewCornerRadius{
    if (_indicatorViewCornerRadius <= 0) {
        _indicatorViewCornerRadius = 3.25;
    }
    return _indicatorViewCornerRadius;
}

- (CGFloat)indicatorViewHeight {
    if (_indicatorViewHeight <= 0) {
        _indicatorViewHeight = 3;
    }
    return _indicatorViewHeight;
}

- (CGFloat)indicatorViewWidth {
    return _indicatorViewWidth;
}

- (CGFloat)bottomSparatorHeight {
    return _bottomSparatorHeight;
}


- (CGFloat)titleAdditionalWidth {
    if (_titleAdditionalWidth <= 0) {
        _titleAdditionalWidth = 20;
    }
    return _titleAdditionalWidth;
}

/** 角标 */
- (CGFloat )badgeFontSize {
    if (_badgeFontSize <= 0) {
        _badgeFontSize = 12;
    }
    return _badgeFontSize;
}

- (UIColor *)badgeTitleColor{
    if (!_badgeTitleColor) {
        _badgeTitleColor = [UIColor whiteColor];
    }
    return _badgeTitleColor;
}

- (UIColor *)badgeBackgroundColor {
    if (!_badgeBackgroundColor) {
        _badgeBackgroundColor = [UIColor redColor];
    }
    return _badgeBackgroundColor;
}

- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
