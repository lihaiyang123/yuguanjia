//
//  RootNavigationController.h
//  ydzy
//
//  Created by 马方圆 on 2019/12/31.
//  Copyright © 2019 lvhuipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RootNavigationController : UINavigationController

/*!
 *  返回到指定的类视图
 *
 *  @param ClassName 类名
 *  @param animated  是否动画
 */
- (BOOL)popToAppointViewController:(NSString *)ClassName animated:(BOOL)animated;



@end

NS_ASSUME_NONNULL_END
