//
//  AppDelegate+AppService.h
//  YuGuanJia
//
//  Created by Yang on 2021/6/24.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (AppService)

//初始化服务
-(void)initService;

//初始化 window
-(void)initWindow;

//初始化 UMeng
-(void)initUMeng;

//初始化用户系统
-(void)initUserManager;

//监听网络状态
- (void)monitorNetworkStatus;

//初始化网络配置
-(void)NetWorkConfig;
//微信配置
-(void)initWeChat;
//支付宝配置
-(void)initAlipay;
//单例
+ (AppDelegate *)shareAppDelegate;

/**
 当前顶层控制器
 */
- (UIViewController*)getCurrentVC;

- (UIViewController*)getCurrentUIVC;




@end

NS_ASSUME_NONNULL_END
