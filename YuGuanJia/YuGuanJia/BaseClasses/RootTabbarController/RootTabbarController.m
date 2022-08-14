//
//  RootTabbarController.m
//  ydzy
//
//  Created by 马方圆 on 2020/1/2.
//  Copyright © 2020 lvhuipeng. All rights reserved.
//

#import "RootTabbarController.h"
#import "RootNavigationController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "ServiceProviderViewController.h"
#import "DocumentLibraryViewController.h"

@implementation RootTabbarController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    [self tab_setUpUI];
}
//添加视图
- (void)tab_setUpUI {
    
//    协作台
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self setupChildVC:homeVC title:@"协作台" image:@"xiezuotai_default" selectedImage:@"xiezuotai_select"];
//    服务商
    ServiceProviderViewController *serVC = [[ServiceProviderViewController alloc] init];
    [self setupChildVC:serVC title:@"服务商" image:@"fuwu_default" selectedImage:@"fuwu_select"];
//    单据库
    DocumentLibraryViewController *docVC = [[DocumentLibraryViewController alloc] init];
    [self setupChildVC:docVC title:@"单据库" image:@"danju_default" selectedImage:@"danju_select"];
//    我的
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self setupChildVC:mineVC title:@"我的" image:@"mine_default" selectedImage:@"mine_select"];
    
}

- (void)setupChildVC:(UIViewController *)vc title:(NSString *)tabTitle image:(NSString *)imageName selectedImage:(NSString *)selectImageName {
    
    vc.title = tabTitle;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectImageName];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : CNavBgColor,NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14.0]} forState:UIControlStateSelected];
    [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12.0]} forState:UIControlStateNormal];
    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
}

@end
