//
//  NSString+Helper.h
//  dajiaochong
//
//  Created by kidstone_test on 16/4/20.
//  Copyright © 2016年 王春景. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Helper)
+ (NSString *)md5:(NSString *)str;
+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)arabicNumeralsToChinese:(NSInteger)number;
+ (NSString *)unitConversionWithStr:(NSString *)number;
+ (BOOL)isBlankString:(NSString *)string;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

// 格式化时间转时间戳
+ (NSString *)intervalWithTimeString:(NSString *)timeStr;

- (NSString *)md5;

//获取当前的时间
+(NSString*)getCurrentTimes;

+(NSString *)timeFormatted:(int)totalSeconds;

#pragma mark 账号密码本地检测
// 是否手机号码
+ (BOOL)isValidateTelNumber:(NSString *)number;

// 邮箱格式是否正确
+ (BOOL)checkEmailIsValue:(NSString *)emailStr;

// 密码格式是否正确
+ (BOOL)checkPassWordIsValue:(NSString *)passWordStr;

+ (NSString *)getCurrentDeviceModel;



@end
