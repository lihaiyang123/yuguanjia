//
//  NSString+Extension.h
//  SCH
//
//  Created by SCH_YUH on 2017/1/10.
//  Copyright © 2017年 SCH_YUH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Ex)

#pragma mark - 计算宽度或者高度

- (CGFloat)heightWithFont:(UIFont *)font forWidth:(CGFloat)width NS_AVAILABLE_IOS(6_0);//测试OK

- (CGFloat)widthWithFont:(UIFont *)font NS_AVAILABLE_IOS(6_0);//测试OK
// Single line,

- (CGSize)textSizeWithFont:(UIFont *)font NS_AVAILABLE_IOS(6_0);//未测试
//NSLineBreakByWordWrapping

- (CGSize)textSizeWithFont:(UIFont *)font forWidth:(CGFloat)width NS_AVAILABLE_IOS(6_0);//未测试

//calulate width and height (这个方法 参数 和名字 存在问题...后期会修改掉,  用上面方法)
- (CGSize)sizeWithFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode NS_AVAILABLE_IOS(6_0);

+ (CGSize)sizeFromString:(NSString *)string font:(UIFont *)font floatWidth:(CGFloat)floatWidth;

+ (CGSize)getAttributeSizeWithText:(NSString *)text fontSize:(int)fontSize;

+ (float)measureSinglelineStringWidth:(NSString *)str andFont:(UIFont *)wordFont;

+ (float)measureMultilineStringHeight:(NSString *)str andFont:(UIFont *)wordFont andWidth:(CGFloat)width;

//计算富文本size
+ (CGSize)attributeStringSizeWithBoundingSize:(CGSize)size
                              attributeString:(NSMutableAttributedString *)attributeString;

- (NSMutableAttributedString *)attributedStringOfString:(NSString *)attrString
                                             attributes:(NSDictionary *)attributes;

- (NSMutableAttributedString *)attributedStringOfString:(NSString *)attrString
                                       stringAttributes:(NSDictionary *)stringAttributes
                                    allStringAttributes:(NSDictionary *)allStringAttributes;

//default Font is systemFont size 14 blackColor && highlightText
- (NSMutableAttributedString *)attributedStringWithHighlightText:(NSString *)highlightText
                                               highlightTextFont:(UIFont *)highlightTextFont
                                              highlightTextColor:(UIColor *)highlightTextColor
                                                        textFont:(UIFont *)textFont
                                                       textColor:(UIColor *)textColor;

- (void)textDrawInRect:(CGRect)rect
              withFont:(UIFont *)font
         lineBreakMode:(NSLineBreakMode)lineBreakMode
             alignment:(NSTextAlignment)alignment;

//返回值是该字符串所占一行的width
- (CGFloat)getSingleLineTextSizeWithFont:(UIFont *)font;

@end
