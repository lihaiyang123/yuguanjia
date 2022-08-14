//
//  DocumentLibraryViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/24.
//

#import "DocumentLibraryViewController.h"
#import "MineDocLibViewController.h"
#import "DocLibViewController.h"

@interface DocumentLibraryViewController ()<WMPageControllerDelegate,WMPageControllerDataSource>

@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, strong) NSArray *vcsArr;

@end

@implementation DocumentLibraryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    [self showUIHUD];
    self.menuView.backgroundColor = CNavBgColor;
//    if ([[MethodManager sharedMethodManager] isNotchScreen]) {
        UIView *view = [[UIView alloc] init];
        YDZYLog(@"%f",kNavBarHeight);
        view.frame = CGRectMake(0, 0, kScreenWidth, kStatusBarHeight);
        view.backgroundColor = CNavBgColor;
        [self.view addSubview:view];
//    }
}
- (void)showUIHUD {
    
    self.titlesArr = @[@"我的单据",@"单据库"];
    self.vcsArr = @[[MineDocLibViewController class], [DocLibViewController class]];
    self.menuViewStyle =  WMMenuViewStyleLine;
    self.titles = self.titlesArr;
    self.delegate = self;
    self.dataSource = self;
    self.viewControllerClasses = self.vcsArr;
    self.menuItemWidth = kScreenWidth / 2.0;
    YDZYLog(@"%f",kNavBarHeight);
    self.menuView.height = kNavBarHeight;
    self.titleSizeSelected = 18;
    self.titleSizeNormal = 16;
    self.titleColorNormal = [UIColor colorWithHexString:@"#C1D7FF"];
    self.titleColorSelected = KWhiteColor;
    self.progressColor = KWhiteColor;
    self.progressHeight = 3;
    self.progressViewCornerRadius = 1.5f;
    self.progressWidth = 30;
    [self reloadData];
}

-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    
    return self.vcsArr.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:{
            MineDocLibViewController   *vcClass = [[MineDocLibViewController alloc] init];
            return vcClass;
        }
            break;
        case 1:{
            DocLibViewController   *vcClass = [[DocLibViewController alloc] init];
            return vcClass;
        }
            break;
    }
    return nil;
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titlesArr[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {

     CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, kScreenWidth, kScreenHeight - originY);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {

    if ([[MethodManager sharedMethodManager] isNotchScreen]) {
        return CGRectMake(0, 40, self.view.frame.size.width, 44);
    } else {
        return CGRectMake(0, 20, self.view.frame.size.width, 44);
    }
}

- (NSArray *)titlesArr {
    
    if (!_titlesArr) {
        _titlesArr = [NSArray array];
    }
    return _titlesArr;
}

- (NSArray *)vcsArr {
    
    if (!_vcsArr) {
        _vcsArr = [NSArray array];
    }
    return _vcsArr;
}
@end
