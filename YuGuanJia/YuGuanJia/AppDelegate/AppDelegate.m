//
//  AppDelegate.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/24.
//

#import "AppDelegate.h"
#import "Harpy.h"

#define kRootViewController [UIApplication sharedApplication].keyWindow.rootViewController

@interface AppDelegate () <HarpyDelegate>

@end

@implementation AppDelegate

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return YGJSQLITE_MANAGER.makeOrientation;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initWindow];
    [self initUserManager];
    [self checkVersionConfig];
    [self refreshUI];
    return YES;
}
// 动态刷新UI
- (void)refreshUI {
    
    #if DEBUG
    //iOS
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    //同时还支持tvOS和MacOS，配置时只需要在/Applications/InjectionIII.app/Contents/Resources/目录下找到对应的bundle文件,替换路径即可
     #endif
}
//MARK: -检查更新
- (void)checkVersionConfig {
    
    [[Harpy sharedInstance] setPresentingViewController:kRootViewController];
    [[Harpy sharedInstance] setDelegate:self];
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *appName = [infoDictionary objectForKey:@"CFBundleName"];
//
//    [[Harpy sharedInstance] setAppName:appName];
//    [[Harpy sharedInstance] setAppID:BIMAppID];
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
    [[Harpy sharedInstance] setDebugEnabled:true];
    [[Harpy sharedInstance] checkVersion];
}
//MARK: - HarpyDelegate
- (void)harpyDidShowUpdateDialog {
}
- (void)harpyUserDidLaunchAppStore {
    
    [self performSelector:@selector(exitAPPMethod) withObject:nil afterDelay:1.5f];
}
- (void)exitAPPMethod {
    
    exit(0);
}
- (void)harpyDidDetectNewVersionWithoutAlert:(NSString *)message {
    YDZYLog(@"%@", message);
}
@end
