//
//  MethodManager.h
//  YdzyCg
//
//  Created by Yang on 2020/5/29.
//  Copyright © 2020 baqiinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MethodManager : NSObject

+ (MethodManager *)sharedMethodManager;

- (BOOL)isBlankString:(NSString *)string;

- (BOOL)stringContainsEmoji:(NSString *)string;

- (BOOL)isNineKeyBoard:(NSString *)string;

- (BOOL)hasEmoji:(NSString*)string;

-(CGSize)boundingRectWithWidth:(CGFloat)maxWidth
                   withTextFont:(UIFont *)font
                withLineSpacing:(CGFloat)lineSpacing
                          text:(NSString *)text;
- (BOOL)isNotchScreen;

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

- (NSString *)convertToJsonData:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
