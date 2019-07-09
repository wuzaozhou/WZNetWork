//
//  HZTool.h
//  HZFrameWork_Example
//
//  Created by 吴灶洲 on 2018/12/1.
//  Copyright © 2018年 Runyalsj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZTool : NSObject
/** 基本整型（NSInteger）类型转换成NSNumber类型 */
+ (NSNumber*)IntegerValuetoNumberValue:(NSInteger)num;
/** 基本整型（NSUInteger）类型转换成NSNumber类型 */
+ (NSNumber*)UIntegerValuetoNumberValue:(NSUInteger)num;
/** NSNumber类型转换成基本整型（NSInteger）类型 */
+ (NSInteger)NumberValueToIntegerValue:(NSNumber*)number;
/** NSNumber类型转换成基本整型（NSUInteger）类型 */
+ (NSUInteger)NumberValueToUIntegerValue:(NSNumber*)number;
//NSNumber类型转换成NSString类型
+(NSString*)NumberValueToStringValue:(NSNumber*)number;

/** 手机号码验证 */
+ (BOOL)checkMobile:(NSString *)mobile;

+ (BOOL)checkTelNumber:(NSString *)mobileNumbel;

/** 正则匹配用户密码6-18位数字和字母组合 */
+ (BOOL)checkPassword:(NSString *) password;

/** 正则匹配用户身份证号15或18位 */
+ (BOOL)checkUserIdCard:(NSString *)idCard;

/** 获取url对应的参数值 */
+ (NSString *)paramValueOfUrl:(NSString *)url withParam:(NSString *)param;

/** 判断是否是刘海手机 */
+ (BOOL)isBangsPhone;

/**
 根据数据计算以万为单位的数字
 
 @param num 数字
 @return 返回结果，如1.1W
 */
+ (NSString *)countWNum:(NSInteger)num;

/**
 格式化手机号
 
 @param tel 手机号码
 @param format 格式（*或者其他格式）
 @param startLocation 开始位置
 @param endLocation 结束位置
 @return 返回格式化手机号码
 */
+ (NSString *)formatTel:(NSString *)tel format:(NSString *)format startLocation:(NSUInteger)startLocation endLocation:(NSUInteger)endLocation;

/**
 是否有使用相机的权限
 
 @return 返回是否可以使用的bool值
 */
+ (BOOL)hasAuthorityOfCamera;

/**
 是否有使用相册的权限
 
 @return 返回是否可以使用的bool值
 */
+ (BOOL)hasAuthorityOfPictureLibrary;


/**
 验证字符串对象是否为空串
 
 @param string 字符串对象
 @return 字符串对象为空串返回YES，否则返回NO
 */
+ (BOOL)isWhiteSpace:(NSString*)string;

/**
 验证字符串对象是否为Int
 
 @param string 字符串对象
 @return 字符串对象为Int返回YES，否则返回NO
 */
+ (BOOL)isInt:(NSString*)string;

/**
 验证字符串对象是否为Float
 
 @param string 字符串对象
 @return 字符串对象为Float返回YES，否则返回NO
 */
+ (BOOL)isFloat:(NSString*)string;

/**
 验证字符串对象是否为Integer
 
 @param string 字符串对象
 @return 字符串对象为Integer返回YES，否则返回NO
 */
+ (BOOL)isInteger:(NSString*)string;

/**
 验证字符串对象是否为LongLong
 
 @param string 字符串对象
 @return 字符串对象为LongLong返回YES，否则返回NO
 */
+ (BOOL)isLongLong:(NSString*)string;

/**
 验证字符串对象是否为Double
 
 @param string 字符串对象
 @return 字符串对象为Double返回YES，否则返回NO
 */
+ (BOOL)isDouble:(NSString*)string;

/**
 验证字符串是否为银行卡号
 
 @param cardNumber 银行卡号字符串
 @return 字符串对象为银行卡字符串返回YES，否则返回NO
 */
+ (BOOL)checkBankCardNumber:(NSString *)cardNumber;

/**
 验证字符串对象是否为nil或者空串
 
 @param string 字符串对象
 @return 字符串对象为nil或者空串返回YES，否则返回NO
 */
+ (BOOL)isNilOrWhiteSpace:(NSString*)string;

@end

NS_ASSUME_NONNULL_END
