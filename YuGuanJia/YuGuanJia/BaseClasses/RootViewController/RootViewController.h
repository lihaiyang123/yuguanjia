//
//  RootViewController.h
//  ydzy
//
//  Created by 马方圆 on 2019/12/31.
//  Copyright © 2019 lvhuipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RootViewController : UIViewController

/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle StatusBarStyle;
//@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UICollectionView * collectionView;


/**
 *  显示没有数据页面
 */
-(void)showNoDataImage;

/**
 *  移除无数据页面
 */
-(void)removeNoDataImage;


/**
 *  加载视图
 */
- (void)showLoadingAnimation;

/**
 *  停止加载
 */
- (void)stopLoadingAnimation;


/**
 *  是否显示返回按钮,默认情况是YES
 */
@property (nonatomic, assign) BOOL isShowLiftBack;


/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL isHidenNaviBar;


/**
 导航栏添加文本按钮
 
 @param titles 文本数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (NSMutableArray<UIButton *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

/**
 *  默认返回按钮的点击事件，默认是返回，子类可重写
 */
- (void)backBtnClicked;


//取消网络请求
- (void)cancelRequest;


- (BOOL)validateMobile:(NSString *)mobile;


@property (nonatomic, strong) UIView *lineView;

- (UIInterfaceOrientationMask)deviceOrientationMask;
- (void)toOrientation:(UIInterfaceOrientation)orientation;
@end

NS_ASSUME_NONNULL_END
