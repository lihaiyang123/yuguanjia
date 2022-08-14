//
//  YGJFontUtils.h
//  YuGuanJia
//
//  Created by Yang on 2021/8/11.
//

#import <Foundation/Foundation.h>
#import "YGJDeviceUtils.h"

NS_ASSUME_NONNULL_BEGIN

// 设备屏幕尺寸
// 3.5寸  iPhone 4s
#define YGJIS_35INCH_SCREEN [YGJDeviceUtils is35InchScreen]
// 4.0寸  iPhone 5
#define YGJIS_40INCH_SCREEN [YGJDeviceUtils is40InchScreen]
// 4.7寸 iPhone 6
#define YGJIS_47INCH_SCREEN [YGJDeviceUtils is47InchScreen]
// 5.5寸 iPhone 6p
#define YGJIS_55INCH_SCREEN [YGJDeviceUtils is55InchScreen]
// 5.8寸 iPhone X iPhone XS
#define YGJIS_58INCH_SCREEN [YGJDeviceUtils is58InchScreen]
// 6.1寸 iPhone XR
#define YGJIS_61INCH_SCREEN [YGJDeviceUtils is61InchScreen]
// 6.5寸 iPhone XS Max
#define YGJIS_65INCH_SCREEN [YGJDeviceUtils is65InchScreen]

//当使用xib时候，如果不想根据屏幕改变字体大小就设置tag为
FOUNDATION_EXPORT NSUInteger const YGJFontTag;

/**
 *  系统正常字体
 */
FOUNDATION_EXTERN UIFont * YGJSystemRegularFont(CGFloat inch_3_5,
                             CGFloat inch_4_0,
                             CGFloat inch_4_7,
                             CGFloat inch_5_5,
                             CGFloat inch_5_8,
                             CGFloat inch_6_1,
                             CGFloat inch_6_5);

/**
 *  系统最粗体字体
 */
FOUNDATION_EXTERN UIFont * YGJSystemBoldFont(CGFloat inch_3_5,
                          CGFloat inch_4_0,
                          CGFloat inch_4_7,
                          CGFloat inch_5_5,
                          CGFloat inch_5_8,
                          CGFloat inch_6_1,
                          CGFloat inch_6_5);

/**
 *  系统中粗体字体
 */
FOUNDATION_EXTERN UIFont * YGJSystemMediumFont(CGFloat inch_3_5,
                            CGFloat inch_4_0,
                            CGFloat inch_4_7,
                            CGFloat inch_5_5,
                            CGFloat inch_5_8,
                            CGFloat inch_6_1,
                            CGFloat inch_6_5);
/**
 * 使用包内含有，并知道名字的字体
 */
FOUNDATION_EXTERN UIFont * YGJFontsProvidedByApplication(NSString *fontName,
                                      CGFloat inch_3_5,
                                      CGFloat inch_4_0,
                                      CGFloat inch_4_7,
                                      CGFloat inch_5_5,
                                      CGFloat inch_5_8,
                                      CGFloat inch_6_1,
                                      CGFloat inch_6_5);

/**
 *  下载字体
 */
FOUNDATION_EXTERN UIFont * YGJCustomFontFilePath(NSString *filePath,
                                                CGFloat inch_3_5,
                                                CGFloat inch_4_0,
                                                CGFloat inch_4_7,
                                                CGFloat inch_5_5,
                                                CGFloat inch_5_8,
                                                CGFloat inch_6_1,
                                                CGFloat inch_6_5);

// 知道字体名字
static inline UIFont * YGJFontsProvidedMake(NSString *fontName, CGFloat font) {
    
    return YGJFontsProvidedByApplication(fontName, (font - 2), (font - 2), font, (font + 1), font, font, (font + 1));
}

// 本地字体路径 大小
static inline UIFont * YGJUIFilePathFontMake(NSString *filePath, CGFloat font) {
    
    return YGJCustomFontFilePath(filePath, (font - 2), (font - 2), font, (font + 1), font, font, (font + 1));
}

//App的主字体 平方体
static inline UIFont * YGJUIFontMake(CGFloat font) {
    
    return YGJSystemRegularFont((font - 2), (font - 2), font, (font + 1), font, font, (font + 1));
}

static inline UIFont * YGJUIFontBoldMake(CGFloat font) {
    
    return YGJSystemBoldFont((font - 2), (font - 2), font, (font + 1), font, font, (font + 1));
}

static inline UIFont * YGJUIFontMediumMake(CGFloat font) {
    
    return YGJSystemMediumFont((font - 2), (font - 2), font, (font + 1), font, font, (font + 1));
}

@interface YGJFontUtils : NSObject

@end

NS_ASSUME_NONNULL_END
