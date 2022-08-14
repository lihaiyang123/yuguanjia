//
//  YGJToast.h
//  YuGuanJia
//
//  Created by ggzj on 2021/8/6.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YGJToastPosition) {
    
    //显示位置在上层
    YGJToastViewPositionTop = 0,
    //显示位置在中间
    YGJToastViewPositionCenter = 1,
    //显示位置在底部
    YGJToastViewPositionBottom = 2
};

@interface YGJToast : UIWindow

+ (void)showToast:(NSString *)toast;
+ (void)showToast:(NSString *)toast withImageName:(NSString *)nameString;

+ (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;
+ (void)showToast:(NSString *)toast withImageName:(NSString *)nameString hideAfterDelay:(NSTimeInterval)delay;


+ (void)showToast:(NSString *)toast withPosition:(YGJToastPosition)position;
+ (void)showToast:(NSString *)toast withImageName:(NSString *)nameString withPosition:(YGJToastPosition)position;

+ (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withPosition:(YGJToastPosition)position;
+ (void)showToast:(NSString *)toast withImageName:(NSString *)nameString hideAfterDelay:(NSTimeInterval)delay withPosition:(YGJToastPosition)position;

@end
