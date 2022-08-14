//
//  RootNavigationController.m
//  ydzy
//
//  Created by 马方圆 on 2019/12/31.
//  Copyright © 2019 lvhuipeng. All rights reserved.
//

#import "RootNavigationController.h"


@interface RootNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) id popDelegate;
@property (nonatomic,strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@property (nonatomic,strong) UIScreenEdgePanGestureRecognizer *popRecognizer;
@property(nonatomic,assign) BOOL isSystemSlidBack;//是否开启系统右滑返回
@property(nonatomic,assign) BOOL isShowShadow;//是否显示导航阴影线
@end


@implementation RootNavigationController

//APP生命周期中 只会执行一次
+ (void)initialize {
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = CNavBgColor;
        [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName :CNavBgFontColor, NSFontAttributeName : [UIFont systemFontOfSize:18]}];
        navBar.standardAppearance = appearance;
        navBar.scrollEdgeAppearance = navBar.standardAppearance;
    }
    //导航栏背景图
    UIImage *backGroundImage = [UIImage imageNamed:@"navbg"];
    backGroundImage = [backGroundImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [navBar setBackgroundImage:backGroundImage forBarMetrics:UIBarMetricsDefault];
    [navBar setBarTintColor:CNavBgColor];
    [navBar setTintColor:CNavBgFontColor];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :CNavBgFontColor, NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    [navBar setBackgroundImage:[UIImage imageWithColor:CNavBgColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //    [navBar setShadowImage:[UIImage new]];//去掉阴影线
}

#pragma mark - 设置返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.childViewControllers.count > 0) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        
        backItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        viewController.navigationItem.leftBarButtonItem = backItem;
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    self.isSystemSlidBack = YES;
    //默认开启系统右划返回
    self.interactivePopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    
    //只有在使用转场动画时，禁用系统手势，开启自定义右划手势
    _popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationTransition:)];
    //下面是全屏返回
    //        _popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationTransition:)];
    _popRecognizer.edges = UIRectEdgeLeft;
    [_popRecognizer setEnabled:NO];
    [self.view addGestureRecognizer:_popRecognizer];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

//解决手势失效问题
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (_isSystemSlidBack) {
        self.interactivePopGestureRecognizer.enabled = YES;
        [_popRecognizer setEnabled:NO];
    }else{
        self.interactivePopGestureRecognizer.enabled = NO;
        [_popRecognizer setEnabled:YES];
    }
}

//根视图禁用右划返回
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.childViewControllers.count == 1 ? NO : YES;
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([viewController isKindOfClass:[RootViewController class]]) {
        RootViewController * vc = (RootViewController *)viewController;
        if (vc.isHidenNaviBar) {
            vc.view.top = 0;
            [vc.navigationController setNavigationBarHidden:YES animated:animated];
        }else{
            vc.view.top = kTopHeight;
            [vc.navigationController setNavigationBarHidden:NO animated:animated];
        }
    }
    
}

/**
 *  返回到指定的类视图
 *
 *  @param ClassName 类名
 *  @param animated  是否动画
 */
- (BOOL)popToAppointViewController:(NSString *)ClassName animated:(BOOL)animated {
    
    id vc = [self getCurrentViewControllerClass:ClassName];
    if(vc != nil && [vc isKindOfClass:[UIViewController class]])
    {
        [self popToViewController:vc animated:animated];
        return YES;
    }
    return NO;
}


/*!
 *  获得当前导航器显示的视图
 *
 *  @param ClassName 要获取的视图的名称
 *
 *  @return 成功返回对应的对象，失败返回nil;
 */
- (instancetype)getCurrentViewControllerClass:(NSString *)ClassName {
    Class classObj = NSClassFromString(ClassName);
    
    NSArray * szArray =  self.viewControllers;
    for (id vc in szArray) {
        if([vc isMemberOfClass:classObj])
        {
            return vc;
        }
    }
    return nil;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

#pragma mark ————— 转场动画区 —————
#pragma mark -- NavitionContollerDelegate
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    if (!self.interactivePopTransition) { return nil; }
    return self.interactivePopTransition;
    
}

#pragma mark UIGestureRecognizer handlers
- (void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer*)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    //    progress = MIN(1.0, MAX(0.0, progress));
    YDZYLog(@"右划progress %.2f",progress);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        
        if (progress > 0.5 || velocity.x >100) {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }
}

@end
