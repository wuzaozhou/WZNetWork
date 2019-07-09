//
//  HZTool.m
//  HZFrameWork_Example
//
//  Created by 吴灶洲 on 2018/12/1.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import "HZTool.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>

@implementation HZTool
/** 基本整型（NSInteger）类型转换成NSNumber类型 */
+ (NSNumber*)IntegerValuetoNumberValue:(NSInteger)num {
    NSNumber *number = [NSNumber numberWithInteger:num];
    return number;
}
/** 基本整型（NSUInteger）类型转换成NSNumber类型 */
+ (NSNumber*)UIntegerValuetoNumberValue:(NSUInteger)num {
    NSNumber *number = [NSNumber numberWithUnsignedInteger:num];
    return number;
}
/** NSNumber类型转换成基本整型（NSInteger）类型 */
+ (NSInteger)NumberValueToIntegerValue:(NSNumber*)number {
    NSInteger num = [number integerValue];
    return num;
}
/** NSNumber类型转换成基本整型（NSUInteger）类型 */
+ (NSUInteger)NumberValueToUIntegerValue:(NSNumber*)number {
    NSUInteger num=[number unsignedIntegerValue];
    return num;
}
//NSNumber类型转换成NSString类型
+(NSString*)NumberValueToStringValue:(NSNumber*)number
{
    NSString* numberString=@"";
    if (number!=nil) {
        numberString=[NSString stringWithFormat:@"%@",number];
    }
    return numberString;
}

/** 手机号码验证 */
+ (BOOL)checkMobile:(NSString *)mobile {
    NSString *tel=@"1[0-9]{10}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tel];
    if (([regextestmobile evaluateWithObject:mobile])) {
        return YES;
    }
    return NO;
}

+ (BOOL)checkTelNumber:(NSString *)mobileNumbel {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}

/** 正则匹配用户密码6-18位数字和字母组合 */
+ (BOOL)checkPassword:(NSString *) password {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

/** 正则匹配用户身份证号15或18位 */
+ (BOOL)checkUserIdCard: (NSString *) idCard {
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

/** 获取url对应的参数值 */
+ (NSString *) paramValueOfUrl:(NSString *) url withParam:(NSString *) param{
    
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];
        // 分组2所对应的串
        return tagValue;
    }
    return @"";
}

/** 判断是否是刘海手机 */
+ (BOOL)isBangsPhone {
    BOOL bangsPhone = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return bangsPhone;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            bangsPhone = YES;
        }
    }
    return bangsPhone;
}


/**
 根据数据计算以万为单位的数字
 
 @param num 数字
 @return 返回结果，如1.1W
 */
+ (NSString *)countWNum:(NSInteger)num {
    if (num < 10000) {
        return [NSString stringWithFormat:@"%ld", num];
    }else if (num == 10000) {
        return @"1W";
    }else {
        NSNumber *number = @(num/10000.0);
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setPositiveFormat:@"###0.0"];
        formatter.roundingMode = NSNumberFormatterRoundDown;
        formatter.maximumFractionDigits = 1;
        return [NSString stringWithFormat:@"%@w", [formatter stringFromNumber:number]];
    }
}

/**
 格式化手机号
 
 @param tel 手机号码
 @param format 格式（*或者其他格式）
 @param startLocation 开始位置
 @param endLocation 结束位置
 @return 返回格式化手机号码
 */
+ (NSString *)formatTel:(NSString *)tel format:(NSString *)format startLocation:(NSUInteger)startLocation endLocation:(NSUInteger)endLocation {
    if (tel.length == 11) {
        for (NSInteger i = startLocation; i < endLocation; i++) {
            NSRange range = NSMakeRange(startLocation, 1);
            tel = [tel stringByReplacingCharactersInRange:range withString:format];
            startLocation ++;
        }
    }
    return tel;
}


/**
 是否有使用相机的权限
 
 @return 返回是否可以使用的bool值
*/
+ (BOOL)hasAuthorityOfCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        // 无权限
        return NO;
    }else {
        return YES;
    }
}

/**
 是否有使用相册的权限
 
 @return 返回是否可以使用的bool值
*/
+ (BOOL)hasAuthorityOfPictureLibrary {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        // 无权限
        return NO;
    }else {
        return YES;
    }
}


/**
 验证字符串对象是否为空串
 
 @param string 字符串对象
 @return 字符串对象为空串返回YES，否则返回NO
 */
+ (BOOL)isWhiteSpace:(NSString*)string {
    if (string == nil) {
        return NO;
    }
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length] == 0) {
        return YES;
    }
    
    return NO;
}

/**
 验证字符串对象是否为Int
 
 @param string 字符串对象
 @return 字符串对象为Int返回YES，否则返回NO
 */
+ (BOOL)isInt:(NSString*)string {
    if (string == nil) {
        return NO;
    }
    NSScanner* scanner=[NSScanner scannerWithString:string];
    int value;
    
    BOOL ret=([scanner scanInt:&value]&&[scanner isAtEnd]);
    
    return ret;
}


/**
 验证字符串对象是否为Float
 
 @param string 字符串对象
 @return 字符串对象为Float返回YES，否则返回NO
 */
+ (BOOL)isFloat:(NSString*)string {
    if (string == nil) {
        return NO;
    }
    NSScanner* scanner=[NSScanner scannerWithString:string];
    float value;
    
    BOOL ret=([scanner scanFloat:&value]&&[scanner isAtEnd]);
    
    return ret;
}

/**
 验证字符串对象是否为Integer
 
 @param string 字符串对象
 @return 字符串对象为Integer返回YES，否则返回NO
 */
+ (BOOL)isInteger:(NSString*)string {
    if (string == nil) {
        return NO;
    }
    NSScanner* scanner=[NSScanner scannerWithString:string];
    NSInteger value;
    
    BOOL ret=([scanner scanInteger:&value]&&[scanner isAtEnd]);
    
    return ret;
}

/**
 验证字符串对象是否为LongLong
 
 @param string 字符串对象
 @return 字符串对象为LongLong返回YES，否则返回NO
 */
+ (BOOL)isLongLong:(NSString*)string {
    if (string == nil) {
        return NO;
    }
    NSScanner* scanner=[NSScanner scannerWithString:string];
    long long value;
    
    BOOL ret=([scanner scanLongLong:&value]&&[scanner isAtEnd]);
    
    return ret;
}

/**
 验证字符串对象是否为Double
 
 @param string 字符串对象
 @return 字符串对象为Double返回YES，否则返回NO
 */
+ (BOOL)isDouble:(NSString*)string {
    if (string == nil) {
        return NO;
    }
    NSScanner* scanner=[NSScanner scannerWithString:string];
    double value;
    
    BOOL ret=([scanner scanDouble:&value]&&[scanner isAtEnd]);
    
    return ret;
}

/**
 验证字符串是否为银行卡号
 
 @param cardNumber 银行卡号字符串
 @return 字符串对象为银行卡字符串返回YES，否则返回NO
 */
+ (BOOL)checkBankCardNumber:(NSString *)cardNumber{
    int oddSum = 0;     // 奇数和
    int evenSum = 0;    // 偶数和
    int allSum = 0;     // 总和
    
    // 循环加和
    for (NSInteger i = 1; i <= cardNumber.length; i++) {
        NSString *theNumber = [cardNumber substringWithRange:NSMakeRange(cardNumber.length-i, 1)];
        int lastNumber = [theNumber intValue];
        if (i%2 == 0) {
            // 偶数位
            lastNumber *= 2;
            if (lastNumber > 9)
            {
                lastNumber -=9;
            }
            evenSum += lastNumber;
        }else {
            // 奇数位
            oddSum += lastNumber;
        }
    }
    allSum = oddSum + evenSum;
    // 是否合法
    if (allSum%10 == 0) {
        return YES;
    }else {
        return NO;
    }
}

/**
 验证字符串对象是否为nil或者空串
 
 @param string 字符串对象
 @return 字符串对象为nil或者空串返回YES，否则返回NO
 */
+ (BOOL)isNilOrWhiteSpace:(NSString*)string {
    if (string == nil || [string isKindOfClass:[NSNull class]] || string == NULL || !string || string.length == 0) {
        return YES;
    }
    
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length] == 0) {
        return YES;
    }
    
    return NO;
}

@end
