//
//  YGJDeviceUtils.h
//  YuGuanJia
//
//  Created by Yang on 2021/8/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGJDeviceUtils : NSObject

+ (nonnull NSString *)deviceModel;

+ (BOOL)isIPad;
+ (BOOL)isIPod;
+ (BOOL)isIPone;
+ (BOOL)isSimulator;

/// 带物理凹槽的刘海屏或者使用 Home Indicator 类型的设备
+ (BOOL)isNotchedScreen;

/// 将屏幕分为普通和紧凑两种，这个方法用于判断普通屏幕
+ (BOOL)isRegularScreen;

/// iPhone XS Max
+ (BOOL)is65InchScreen;

/// iPhone XR
+ (BOOL)is61InchScreen;

/// iPhone X/XS
+ (BOOL)is58InchScreen;

/// iPhone 8 Plus
+ (BOOL)is55InchScreen;

/// iPhone 8
+ (BOOL)is47InchScreen;

/// iPhone 5
+ (BOOL)is40InchScreen;

/// iPhone 4
+ (BOOL)is35InchScreen;

+ (CGSize)screenSizeFor65Inch;
+ (CGSize)screenSizeFor61Inch;
+ (CGSize)screenSizeFor58Inch;
+ (CGSize)screenSizeFor55Inch;
+ (CGSize)screenSizeFor47Inch;
+ (CGSize)screenSizeFor40Inch;
+ (CGSize)screenSizeFor35Inch;

@end

NS_ASSUME_NONNULL_END
