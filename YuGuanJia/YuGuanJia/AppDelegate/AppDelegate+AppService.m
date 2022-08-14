//
//  AppDelegate+AppService.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/24.
//

#import "AppDelegate+AppService.h"
#import "RootTabbarController.h"
//#import "LeadingViewController.h"
#import "LoginViewController.h"


@implementation AppDelegate (AppService)


#pragma mark ————— 初始化服务 —————
- (void)initService {
    //注册登录状态监听
    
    
}

#pragma mark ————— 初始化window —————
- (void)initWindow {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = UIColor.orangeColor;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    
}



#pragma mark ————— 微信支付 —————

- (void) initWeChat{
    
    
}
#pragma mark ————— 支付宝支付 —————

- (void) initAlipay{
    
    
}
#pragma mark ————— 初始化网络配置 —————
- (void)NetWorkConfig{
    
    
}

#pragma mark ————— 初始化用户系统 —————
- (void)initUserManager {
    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"AppFirst"]) {
//        //第一次运行程序
//        [[NSUserDefaults standardUserDefaults] setObject:@"AppFirstValue" forKey:@"AppFirst"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        //进入引导页面，然后进入主界面
//        LeadingViewController *VC = [[LeadingViewController alloc] init];
//        RootNavigationController *navVC = [[RootNavigationController alloc] initWithRootViewController:VC];
//        self.window.rootViewController = navVC;
//        [self.window makeKeyAndVisible];

//    } else {
        
    [YGJSQLITE_MANAGER startUpdatingLocation];
    if (![YGJSQLITE_MANAGER isLogin]) {
        self.window.rootViewController = [[RootNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    } else {
        self.window.rootViewController = [RootTabbarController new];
    }
    [self.window makeKeyAndVisible];
//    }
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification {
    
    
    
    
    
}


#pragma mark ————— 网络状态变化 —————
- (void)netWorkStateChange:(NSNotification *)notification {
    
    
    
    
}


#pragma mark ————— 友盟 初始化 —————
-(void)initUMeng {
    
    
    
    
}
#pragma mark ————— 配置第三方 —————
-(void)configUSharePlatforms{
    /* 设置微信的appKey和appSecret */
    
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    
    
    
}



#pragma mark ————— OpenURL 回调 —————

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    
    return YES;
}




#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus {
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    
}

+ (AppDelegate *)shareAppDelegate {
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (UIViewController *)getCurrentUIVC {
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}







@end
