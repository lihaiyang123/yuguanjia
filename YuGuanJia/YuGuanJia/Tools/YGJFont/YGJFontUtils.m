//
//  YGJFontUtils.m
//  YuGuanJia
//
//  Created by Yang on 2021/8/11.
//

#import "YGJFontUtils.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>

NSUInteger const YGJFontTag = 7101746;

@implementation YGJFontUtils

//系统默认使用字体
UIFont * SystemRegularFontSize(CGFloat size) {
    
    return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
}

UIFont * SystemBoldFontSize(CGFloat size) {
    
    return [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
}

UIFont * SystemMediumFontSize(CGFloat size) {
    
    return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
}

UIFont * AppSystemFont(BOOL isBold,
                    CGFloat inch_3_5,
                    CGFloat inch_4_0,
                    CGFloat inch_4_7,
                    CGFloat inch_5_5,
                    CGFloat inch_5_8,
                    CGFloat inch_6_1,
                    CGFloat inch_6_5) {
    if (YGJIS_35INCH_SCREEN) {
        
        return isBold ? SystemBoldFontSize(inch_3_5) : SystemRegularFontSize(inch_3_5);
    }
    if (YGJIS_40INCH_SCREEN) {
        
        return isBold ? SystemBoldFontSize(inch_4_0) : SystemRegularFontSize(inch_4_0);
    }
    if (YGJIS_47INCH_SCREEN) {
        
        return isBold ? SystemBoldFontSize(inch_4_7) : SystemRegularFontSize(inch_4_7);
    }
    if (YGJIS_55INCH_SCREEN) {
        
        return isBold ? SystemBoldFontSize(inch_5_5) : SystemRegularFontSize(inch_5_5);
    }
    if (YGJIS_58INCH_SCREEN) {
        
        return isBold ? SystemBoldFontSize(inch_5_8) : SystemRegularFontSize(inch_5_8);
    }
    if (YGJIS_61INCH_SCREEN) {
        
        return isBold ? SystemBoldFontSize(inch_6_1) : SystemRegularFontSize(inch_6_1);
    }
    if (YGJIS_65INCH_SCREEN) {
        
        return isBold ? SystemBoldFontSize(inch_6_5) : SystemRegularFontSize(inch_6_5);
    }
    return isBold ? SystemBoldFontSize(inch_4_7) : SystemRegularFontSize(inch_4_7);
}


/*************************************************宏定义字体Function******************************************************************/

/*
 * 系统默认字体
 */
//使用常规字体
UIFont * YGJSystemRegularFont(CGFloat inch_3_5,
                            CGFloat inch_4_0,
                            CGFloat inch_4_7,
                            CGFloat inch_5_5,
                            CGFloat inch_5_8,
                            CGFloat inch_6_1,
                            CGFloat inch_6_5) {
    
    return AppSystemFont(NO, inch_3_5, inch_4_0, inch_4_7, inch_5_5, inch_5_8, inch_6_1, inch_6_5);
}

//使用加粗体
UIFont * YGJSystemBoldFont(CGFloat inch_3_5,
                          CGFloat inch_4_0,
                          CGFloat inch_4_7,
                          CGFloat inch_5_5,
                          CGFloat inch_5_8,
                          CGFloat inch_6_1,
                          CGFloat inch_6_5) {
    return AppSystemFont(YES, inch_3_5, inch_4_0, inch_4_7, inch_5_5, inch_5_8, inch_6_1, inch_6_5);
}

//使用中粗体
UIFont * YGJSystemMediumFont(CGFloat inch_3_5,
                          CGFloat inch_4_0,
                          CGFloat inch_4_7,
                          CGFloat inch_5_5,
                          CGFloat inch_5_8,
                          CGFloat inch_6_1,
                          CGFloat inch_6_5) {
    if (YGJIS_35INCH_SCREEN) {
        
        return SystemMediumFontSize(inch_3_5);
    }
    if (YGJIS_40INCH_SCREEN) {
        
        return SystemMediumFontSize(inch_4_0);
    }
    if (YGJIS_47INCH_SCREEN) {
        
        return SystemMediumFontSize(inch_4_7);
    }
    if (YGJIS_55INCH_SCREEN) {
        
        return SystemMediumFontSize(inch_5_5);
    }
    if (YGJIS_58INCH_SCREEN) {
        
        return SystemMediumFontSize(inch_5_8);
    }
    if (YGJIS_61INCH_SCREEN) {
        
        return SystemMediumFontSize(inch_6_1);
    }
    if (YGJIS_65INCH_SCREEN) {
        
        return SystemMediumFontSize(inch_6_5);
    }
    return SystemMediumFontSize(inch_4_7);
}

/*
 * 使用知道名字的字体
 */
//fontName字体
UIFont * YGJFontsProvidedByApplication(NSString *fontName,
                          CGFloat inch_3_5,
                          CGFloat inch_4_0,
                          CGFloat inch_4_7,
                          CGFloat inch_5_5,
                          CGFloat inch_5_8,
                          CGFloat inch_6_1,
                          CGFloat inch_6_5) {
    
    CGFloat fontSize = inch_4_7;
    if (YGJIS_35INCH_SCREEN) {
        fontSize = inch_3_5;
    }
    if (YGJIS_40INCH_SCREEN) {
        fontSize = inch_4_0;
    }
    if (YGJIS_47INCH_SCREEN) {
        fontSize = inch_4_7;
    }
    if (YGJIS_55INCH_SCREEN) {
        fontSize = inch_5_5;
    }
    if (YGJIS_58INCH_SCREEN) {
        fontSize = inch_5_8;
    }
    if (YGJIS_61INCH_SCREEN) {
        fontSize = inch_6_1;
    }
    if (YGJIS_65INCH_SCREEN) {
        fontSize = inch_6_5;
    }

    return [UIFont fontWithName:fontName size:fontSize];
}

/*
 * 路径字体
 */

//file path 路径字体
UIFont * YGJCustomFontFilePath(NSString *filePath,
                              CGFloat inch_3_5,
                              CGFloat inch_4_0,
                              CGFloat inch_4_7,
                              CGFloat inch_5_5,
                              CGFloat inch_5_8,
                              CGFloat inch_6_1,
                              CGFloat inch_6_5) {

    CGFloat fontSize = inch_4_7;
    if (YGJIS_35INCH_SCREEN) {
        fontSize = inch_3_5;
    }
    if (YGJIS_40INCH_SCREEN) {
        fontSize = inch_4_0;
    }
    if (YGJIS_47INCH_SCREEN) {
        fontSize = inch_4_7;
    }
    if (YGJIS_55INCH_SCREEN) {
        fontSize = inch_5_5;
    }
    if (YGJIS_58INCH_SCREEN) {
        fontSize = inch_5_8;
    }
    if (YGJIS_61INCH_SCREEN) {
        fontSize = inch_6_1;
    }
    if (YGJIS_65INCH_SCREEN) {
        fontSize = inch_6_5;
    }

    NSURL *fontUrl = [NSURL fileURLWithPath:filePath];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    CGFontRelease(fontRef);
    return font;
}
@end
