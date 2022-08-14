//
//  NSString+Helper.m
//  dajiaochong
//
//  Created by kidstone_test on 16/4/20.
//  Copyright © 2016年 王春景. All rights reserved.
//

#import "NSString+Helper.h"
#import <sys/sysctl.h>
#import <sys/utsname.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

//空字符串
#define     LocalStr_None           @""
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSString(Helper)
//+ (NSString *)md5:(NSString *)str{
//    const char *cStr = [str UTF8String];
//
//    unsigned char result[16];
//
//
//
//    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
//
//    CC_MD5( cStr,[num intValue], result );
//
//
//
//    return [[NSString stringWithFormat:
//
//             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//
//             result[0], result[1], result[2], result[3],
//
//             result[4], result[5], result[6], result[7],
//
//             result[8], result[9], result[10], result[11],
//
//             result[12], result[13], result[14], result[15]
//
//             ] lowercaseString];
//
//}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {

//    电信号段:133/153/180/181/189/177

//    联通号段:130/131/132/155/156/185/186/145/176

//    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178

//    虚拟运营商:170

    NSString *MOBILE = @"^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\\d{8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

    return [regextestmobile evaluateWithObject:mobileNum];

}


- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY
        
        NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin
        
        data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        
        return [self base64EncodedStringFrom:data];
    }
    else {
        return LocalStr_None;
    }  
}
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

+ (NSString *)arabicNumeralsToChinese:(NSInteger)number

{
    
    switch (number) {
            
        case 0:
            
            return @"零";
            
            break;
            
        case 1:
            
            return @"一";
            
            break;
            
        case 2:
            
            return @"二";
            
            break;
            
        case 3:
            
            return @"三";
            
            break;
            
        case 4:
            
            return @"四";
            
            break;
            
        case 5:
            
            return @"五";
            
            break;
            
        case 6:
            
            return @"六";
            
            break;
            
        case 7:
            
            return @"七";
            
            break;
            
        case 8:
            
            return @"八";
            
            break;
            
        case 9:
            
            return @"九";
            
            break;
            
        case 10:
            
            return @"十";
            
            break;
            
        case 100:
            
            return @"百";
            
            break;
            
        case 1000:
            
            return @"千";
            
            break;
            
        case 10000:
            
            return @"万";
            
            break;
            
        case 100000000:
            
            return @"亿";
            
            break;
            
        default:
            
            return nil;
            
            break;
            
    }
}
+ (NSString *)unitConversionWithStr:(NSString *)number
{
    NSString *result = @"";
    if (number)
    {
        CGFloat num = [number floatValue];
        if (num >= 100000000.0) {
            CGFloat newValue = num / 100000000;
            result = [NSString stringWithFormat:@"%.1f亿",newValue];
            char character = [result characterAtIndex:result.length-2];
            if (character == '0') {
                result = [NSString stringWithFormat:@"%.0f亿",newValue];
            }
        }else if (num >= 10000.0){
            CGFloat newValue = num / 10000;
            result = [NSString stringWithFormat:@"%.1f万",newValue];
            char character = [result characterAtIndex:result.length-2];
            if (character == '0') {
                result = [NSString stringWithFormat:@"%.0f万",newValue];
            }
        }else{
            result = [NSString stringWithFormat:@"%.0f",num];
        }
    }
    return result;
}

#pragma mark - 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    // 去掉前后空格，判断length是否为0
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    
    if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"null"]) {
        return YES;
    }
    
    // 不为空
    return NO;
}
#pragma mark 账号密码本地检测
// 是否手机号码
+ (BOOL)isValidateTelNumber:(NSString *)number {
    // 手机号正则表达式
    // NSString *strRegex = @"^1+[3578]+\\d{9}";
    NSString *strRegex = @"^1+\\d{10}";
    BOOL rt = [self isValidateRegularExpression:number byExpression:strRegex];
    if (rt == YES) {
        
        if (number.length < 11 || number.length > 11) {
            rt = NO;
            return rt;
        } else {
            
            if ([number hasPrefix:@"0"]) {
                rt = NO;
                return rt;
            }
        }
    }
    
    return rt;
}

+ (BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strExpression];
    return [predicate evaluateWithObject:strDestination];
}

// 邮箱格式是否正确
+ (BOOL)checkEmailIsValue:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

// 密码格式是否正确
+ (BOOL)checkPassWordIsValue:(NSString *)passWordStr {
    if (passWordStr.length >= 6 && passWordStr.length <= 18) {
        for (int i = 0; i < passWordStr.length; i++) {
            unichar charStr = [passWordStr characterAtIndex:i];
            if (charStr < 48 || (charStr > 57 && charStr < 65) || (charStr > 90 && charStr < 97) || charStr > 122) {
                return NO;
            }
            
        }
        return YES;
    }
    return NO;
}

+ (NSString *)intervalWithTimeString:(NSString *)timeStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    NSDate *currentDate = [dateFormatter dateFromString:timeStr];
    return [NSString stringWithFormat:@"%.0f",[currentDate timeIntervalSince1970]*1000];
}

+(NSString*)getCurrentTimes{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"YYYY-MM"];

    //现在时间,你可以输出来看下是什么格式

    NSDate *datenow = [NSDate date];

    //----------将nsdate按formatter格式转成nsstring

    NSString *currentTimeString = [formatter stringFromDate:datenow];

//    YDZYLog(@"currentTimeString =  %@",currentTimeString);

    return currentTimeString;

}

+ (NSString *)timeFormatted:(int)totalSeconds

{

    int seconds = totalSeconds % 60;

    int minutes = (totalSeconds / 60) % 60;

    int hours = totalSeconds / 3600;

    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];

}

+ (NSString *)getCurrentDeviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = @"iPhone";
    deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    else if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone4";
    else if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone4";
    else if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    else if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    else if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone5 (GSM+CDMA)";
    else if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone5c (GSM)";
    else if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone5c(GSM+CDMA)";
    else if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone5s(GSM)";
    else if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone5s(GSM+CDMA)";
    else if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone6Plus";
    else if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    else if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone6s";
    else if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone6sPlus";
    else if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhoneSE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    else if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone7";
    else if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone7Plus";
    else if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone7";
    else if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone7Plus";
    else if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    else if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    else if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    else if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    else if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhoneX";
    else if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhoneX";
    else if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhoneXR";
    else if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhoneXS";
    else if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhoneXSMax";
    else if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhoneXSMax";
    else if ([deviceModel isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    else if ([deviceModel isEqualToString:@"iPhone12,3"])   return @"iPhone11Pro";
    else if ([deviceModel isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    else if ([deviceModel isEqualToString:@"iPhone12,8"])   return @"iPhoneSE(2nd generation)";
    else if ([deviceModel isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    else if ([deviceModel isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    else if ([deviceModel isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
    else if ([deviceModel isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";
    else if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPodTouch1G";
    else if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPodTouch2G";
    else if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPodTouch3G";
    else if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPodTouch4G";
    else if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPodTouch(5 Gen)";
    else if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    else if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad3G";
    else if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad2(WiFi)";
    else if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad2";
    else if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad2(CDMA)";
    else if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad2";
    else if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPadMini(WiFi)";
    else if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPadMini";
    else if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    else if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    else if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    else if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    else if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    else if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    else if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    else if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    else if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    else if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    else if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    else if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    else if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    else if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    else if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    else if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    else if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    else if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    else if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    else if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    else if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    else if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    else if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    else if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    else if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    else if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    else if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    else if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    else if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}


@end
