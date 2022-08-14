//
//  UtilsMacros.h
//  YuGuanJia
//
//  Created by Yang on 2021/6/24.
//  Copyright © 2020 test. All rights reserved.
//

#ifndef UtilsMacros_h
#define UtilsMacros_h


#define CDNULLString(string) ((string == nil) || ([string isKindOfClass:[NSNull class]]) || (![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || [string isEqualToString:@"<null>"] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]== 0 )

//适配尺寸
//获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
//#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define Iphone6ScaleWidth KScreenWidth/375.0
#define Iphone6ScaleHeight KScreenHeight/667.0
//根据ip6的屏幕来拉伸
#define kScale_W(w) ((kScreenWidth)/375.0) * (w)
#define kScale_H(h) (kScreenHeight/667.0) * (h)
// 控件尺寸比例
#define kScreenWidthRate        ([[UIScreen mainScreen] bounds].size.width/375.f)
// 实际宽尺寸
#define kSuitWidthSize(size)    kScreenWidthRate * (size)
// 控件尺寸比例
#define kScreenHeightRate       ([[UIScreen mainScreen] bounds].size.height/667.f)
// 实际高尺寸
#define kSuitHeightSize(size)   kScreenHeightRate * (size)

//#define UIColorMakeWithHex(hex) [UIColor colorWithHexString:hex]
//#define UIFontMake(size) [UIFont systemFontOfSize:size]
//#define UIFontItalicMake(size) [UIFont italicSystemFontOfSize:size] /// 斜体只对数字和字母有效，中文无效
//#define UIFontBoldMake(size) [UIFont boldSystemFontOfSize:size]
//#define UIFontBoldWithFont(_font) [UIFont boldSystemFontOfSize:_font.pointSize]

// 判断是否为iPhone x 或者 xs
#define iPhoneX [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 812.0f
// 判断是否为iPhone xr 或者 xs max
#define iPhoneXR [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 896.0f
// 是全面屏手机
#define isFullScreen (iPhoneX || iPhoneXR)

#define YGJ_IS_IPHONE_X ((IOS_VERSION >= 11.f) && IS_IPHONE && (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 375 && MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 812))

#define kSafeAreaBottom (isFullScreen ? 34 : 0)
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight self.navigationController.navigationBar.frame.size.height
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#ifdef DEBUG
#define YDZYLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define YDZYLog(...)
#endif

#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kNSUserDefaults [NSUserDefaults standardUserDefaults]

#define canEdit @"canEdit"

typedef void(^CDBlock)(void);
typedef void(^CDStringBlock)(NSString *string);

#endif /* UtilsMacros_h */
