//
//  MethodManager.m
//  YdzyCg
//
//  Created by Yang on 2020/5/29.
//  Copyright © 2020 baqiinfo. All rights reserved.
//

#import "MethodManager.h"

@implementation MethodManager

static MethodManager *_sharedMethodManager;

+ (MethodManager *)sharedMethodManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMethodManager = [[MethodManager alloc] init];
    });
    
    return _sharedMethodManager;
}

#pragma mark - 判断字符串是否为空
- (BOOL)isBlankString:(NSString *)string
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


- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }else if (hs == 0x200d){
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}
/**
判断是不是九宫格
@param string  输入的字符
@return YES(是九宫格拼音键盘)
*/
- (BOOL)isNineKeyBoard:(NSString *)string
{
   NSString *other = @"➋➌➍➎➏➐➑➒";
   int len = (int)string.length;
   for(int i=0;i<len;i++)
   {
       if(!([other rangeOfString:string].location != NSNotFound))
           return NO;
   }
   return YES;
}

/**
*  判断字符串中是否存在emoji
* @param string 字符串
* @return YES(含有表情)
*/
- (BOOL)hasEmoji:(NSString*)string
{
   NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
   NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
   BOOL isMatch = [pred evaluateWithObject:string];
   return isMatch;
}

/**
 *  根据文字内容动态计算UILabel宽高
 *  @param maxWidth label宽度
 *  @param font  字体
 *  @param lineSpacing  行间距
 *  @param text  内容
 */
-(CGSize)boundingRectWithWidth:(CGFloat)maxWidth
                   withTextFont:(UIFont *)font
                withLineSpacing:(CGFloat)lineSpacing
                           text:(NSString *)text{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //设置行间距
    [paragraphStyle setLineSpacing:lineSpacing];
//#warning 此处设置NSLineBreakByTruncatingTail会导致计算文字高度方法失效
//    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    //计算文字尺寸
    CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    return size;
}

- (BOOL)isNotchScreen {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return NO;
    }
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger notchValue = size.width / size.height * 100;
    
    if (216 == notchValue || 46 == notchValue) {
        return YES;
    }
    
    return NO;
}

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}


- (NSString *)convertToJsonData:(NSDictionary *)dict {

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {

        NSLog(@"%@",error);

    }else{

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;

}
@end
