//
//  NSString+Extension.m
//  SCH
//
//  Created by SCH_YUH on 2017/1/10.
//  Copyright © 2017年 SCH_YUH. All rights reserved.
//

#import "NSString+Ex.h"


@implementation NSString (Ex)


#pragma mark - 字符串空判断

- (BOOL)isEmpty {
    return [[NSNull null] isEqual:self] || [self isEqualToString:@""] || [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""]||self==NULL;
}

- (BOOL)isNull {
    if (self == nil) {
        return YES;
    }
    if ([self isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (BOOL)notEmpty {
    return self != nil && [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0;
}
#pragma mark - 计算宽度或者高度

- (CGFloat)heightWithFont:(UIFont *)font forWidth:(CGFloat)width {
    return [self textSizeWithFont:font forWidth:width].height;
    
}

- (CGFloat)widthWithFont:(UIFont *)font {
    return [self textSizeWithFont:font forWidth:CGFLOAT_MAX].width;
}

- (CGSize)textSizeWithFont:(UIFont *)font NS_AVAILABLE_IOS(6_0) {
    return [self textSizeWithFont:font forWidth:CGFLOAT_MAX];
}

//NSLineBreakByWordWrapping
- (CGSize)textSizeWithFont:(UIFont *)font forWidth:(CGFloat)width NS_AVAILABLE_IOS(6_0) {
    CGSize retSize;
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil];
        CGRect rect = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil];
        retSize = rect.size;
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        retSize = [self sizeWithFont:font constrainedToSize:maxSize];
#pragma clang diagnostic pop
    }
    
    return retSize;
}

- (CGSize)sizeWithFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode {
    CGSize size = CGSizeZero;
    if (!font) {
        return size;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    
    size = [attributedString size];
    
    return size;
}

+ (CGSize)sizeFromString:(NSString *)string
                    font:(UIFont *)font
              floatWidth:(CGFloat)floatWidth {
    if (!string) {
        return CGSizeZero;
    }
    CGFloat width = floatWidth*[[UIScreen mainScreen] bounds].size.width;
    if (floatWidth>1) {
        width = floatWidth;
    }
    return [string boundingRectWithSize:CGSizeMake(width, 10000)
                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size;
}

+ (CGSize)getAttributeSizeWithText:(NSString *)text fontSize:(int)fontSize {
    CGSize size=[text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    
    return size;
}

+ (float)measureSinglelineStringWidth:(NSString*)str andFont:(UIFont*)wordFont {
    if (str == nil) return 0;
    CGSize measureSize = [str boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, nil] context:nil].size;
    return ceil(measureSize.width);
}

+ (float)measureMultilineStringHeight:(NSString*)str andFont:(UIFont*)wordFont andWidth:(CGFloat)width {
    if (str == nil) {
        return 0;
    }
    CGSize measureSize = [str boundingRectWithSize:CGSizeMake(width, [wordFont pointSize] * 3) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, nil] context:nil].size;
    return ceil(measureSize.height);
}

- (void)textDrawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    [self drawInRect:rect withAttributes:attributes];
}

+ (CGSize)attributeStringSizeWithBoundingSize:(CGSize)size attributeString:(NSMutableAttributedString *)attributeString {
    CGRect rect = [attributeString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size;
}

- (NSMutableAttributedString*)attributedStringOfString:(NSString *)attrString attributes:(NSDictionary *)attributes {
    UIFont *font = [attributes objectForKey:NSFontAttributeName];
    
    if (!font) {
        font = [UIFont systemFontOfSize:14];
        
    }
    
    NSMutableAttributedString *retString = [self attributedStringOfString:attrString
                                                         stringAttributes:attributes
                                                      allStringAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    return retString;
}

- (NSMutableAttributedString *)attributedStringOfString:(NSString *)attrString
                                       stringAttributes:(NSDictionary *)stringAttributes
                                    allStringAttributes:(NSDictionary *)allStringAttributes {
    NSMutableAttributedString *retString = [[NSMutableAttributedString alloc] initWithString:self];
    if (stringAttributes == nil)
        return retString;
    
    
    if (attrString == nil)
        attrString = @"";
    
    if (allStringAttributes == nil)
        allStringAttributes = stringAttributes;
    
    
    UIFont *font = [stringAttributes objectForKey:NSFontAttributeName];
    if (font) {
        [retString setAttributes:allStringAttributes range:NSMakeRange(0, self.length)];
    }
    
    NSRange range = [self rangeOfString:attrString];
    [retString addAttributes:stringAttributes range:range];
    
    return retString;
}

- (NSMutableAttributedString *)attributedStringWithHighlightText:(NSString *)highlightText
                                               highlightTextFont:(UIFont *)highlightTextFont
                                              highlightTextColor:(UIColor *)highlightTextColor
                                                        textFont:(UIFont *)textFont
                                                       textColor:(UIColor *)textColor {
    UIFont *defaultFont = [UIFont systemFontOfSize:14];
    UIColor *defaultColor = [UIColor blackColor];
    if (!highlightTextFont)
        highlightTextFont = defaultFont;
    
    if (!textFont)
        textFont = defaultFont;
    
    if (!highlightTextColor)
        highlightTextColor = defaultColor;
    
    if (!textColor)
        textColor = defaultColor;
    
    
    NSDictionary *textDic = @{NSFontAttributeName:textFont,
                              NSForegroundColorAttributeName:textColor};
    NSDictionary *highlightDic = @{NSFontAttributeName:highlightTextFont,
                                   NSForegroundColorAttributeName:highlightTextColor};
    
    NSMutableAttributedString *attr = [self attributedStringOfString:highlightText
                                                    stringAttributes:highlightDic
                                                 allStringAttributes:textDic];
    
    return attr;
}

/**
 *返回值是该字符串所占一行的width
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 */
- (CGFloat)getSingleLineTextSizeWithFont:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}
@end
