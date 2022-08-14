//
//  RootViewController.m
//  ydzy
//
//  Created by 马方圆 on 2019/12/31.
//  Copyright © 2019 lvhuipeng. All rights reserved.
//

#import "RootViewController.h"
//#import "LoginViewController.h"


@interface RootViewController ()

@property (nonatomic,strong) UIImageView *noDataView;
@property (nonatomic,strong) UILabel *noDataLabel;

@end

@implementation RootViewController

- (instancetype)init {
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"nib"];
    if (nibPath) {
        self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    } else {
        self = [super init];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _StatusBarStyle;
}

//动态更新状态栏颜色
- (void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle {
    _StatusBarStyle=StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    YGJSQLITE_MANAGER.makeOrientation = [self deviceOrientationMask];
    self.view.backgroundColor = KWhiteColor;
    //是否显示返回按钮
    self.isShowLiftBack = YES;
    //默认导航栏样式：黑字
//    self.StatusBarStyle = UIStatusBarStyleLightContent;
    self.StatusBarStyle = UIStatusBarStyleDefault;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
    self.lineView = lineView;
    self.lineView.hidden = YES;
    lineView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:lineView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //针对iOS11转场动画导致的view偏移进行修复
    if (self.isHidenNaviBar == YES) {
        //导航栏隐藏，view top = 0
        self.view.top = 0;
    }else{
        if (self.navigationController) {
            CGRect frame = self.view.frame;
            frame.origin.y = kTopHeight;
            self.view.frame = frame;
        }
    }
    YGJSQLITE_MANAGER.makeOrientation = [self deviceOrientationMask];
    if ([self deviceOrientationMask] == UIInterfaceOrientationMaskPortrait) {
        [self toOrientation:UIInterfaceOrientationPortrait];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
}

- (void)showLoadingAnimation {
    
}

- (void)stopLoadingAnimation {
     
}

- (void)showNoDataImage {
    
}

- (void)removeNoDataImage {
    if (self.noDataView) {
        
        [self.noDataView removeFromSuperview];
        self.noDataView = nil;
    }
    if (self.noDataLabel) {
        
        [self.noDataLabel removeFromSuperview];
        self.noDataLabel = nil;
    }
}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth , KScreenHeight - kTopHeight - kTabBarHeight) collectionViewLayout:flow];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _collectionView.mj_header = header;
        
        //底部刷新
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        _collectionView.backgroundColor=CViewBgColor;
        _collectionView.scrollsToTop = YES;
    }
    return _collectionView;
}

- (void)headerRereshing {
    
}
- (void)footerRereshing {
    
}
/**
 *  是否显示返回按钮
 */
- (void)setIsShowLiftBack:(BOOL)isShowLiftBack {
    
    _isShowLiftBack = isShowLiftBack;
    NSInteger VCCount = self.navigationController.viewControllers.count;
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
         [self addNavigationItemWithImageNames:@[@"back"] isLeft:YES target:self action:@selector(backBtnClicked) tags:@[@(100)]];
        
    } else {
        
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}
- (void)backBtnClicked {
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark ————— 导航栏 添加图片按钮 —————
/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags {
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    //调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    NSInteger i = 0;
    for (NSString * imageName in imageNames) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.frame = CGRectMake(-10, 0, 20, 20);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

#pragma mark ————— 导航栏 添加文字按钮 —————
- (NSMutableArray<UIButton *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags {
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    //调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    
    NSMutableArray * buttonArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = SYSTEMFONT(16);
        [btn setTitleColor:KBlackColor forState:UIControlStateNormal];
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        
        //设置偏移
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        [buttonArray addObject:btn];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
    return buttonArray;
}

//取消请求
- (void)cancelRequest {

}

- (void)dealloc {
    
    [self cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    YDZYLog(@"控制器释放了----%@",self.class);
}

#pragma mark - 屏幕旋转
//- (BOOL)shouldAutorotate {
//    return true;
//}
//- (UIInterfaceOrientationMask)supportedOrientationMask {
//
//    return UIInterfaceOrientationMaskPortrait;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//
//    return UIInterfaceOrientationMaskPortrait;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//
//    return UIInterfaceOrientationPortrait;
//}
#pragma mark - HomeIndicator

- (BOOL)prefersHomeIndicatorAutoHidden {
    return NO;
}

- (UIInterfaceOrientationMask)deviceOrientationMask {
    return  UIInterfaceOrientationMaskPortrait;
}

//强制转屏
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        UIInterfaceOrientation val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
- (void)toOrientation:(UIInterfaceOrientation)orientation {
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) return;
    
    [self interfaceOrientation:orientation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -正则表达式验证手机号
- (BOOL)validateMobile:(NSString *)mobile {
    
    // 130-139  150-153,155-159  180-189  145,147  170,171,173,176,177,178
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    phoneRegex = @"^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

@end
