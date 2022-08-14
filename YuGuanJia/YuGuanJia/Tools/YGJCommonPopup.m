//
//  YGJCommonPopup.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/28.
//

#import "YGJCommonPopup.h"

// vc
#import "LoginViewController.h"
#import "YGJPersonMessageVC.h"

@interface YGJCommonPopup ()

@property (nonatomic, strong) QMUIModalPresentationViewController *modalViewControllerForAddSubview;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) QMUIButton *cancelButton;
@property (nonatomic, strong) QMUIButton *sureButton;
@property (nonatomic, copy) YGJPopupBlock completeHandler;
@property (nonatomic, copy) YGJPopupBlock cancelHandler;
@property (nonatomic, assign) YGJPopupStatus popupStatus;
@end

@implementation YGJCommonPopup

+ (void)showPopupStatus:(YGJPopupStatus)popupStatus complete:(YGJPopupBlock)completeHandler cancelHandler:(YGJPopupBlock)cancelHandler {
    
    if (popupStatus == YGJPopupStatusLogin) {
        if (YGJSQLITE_MANAGER.isCommonPopup) return;
        YGJSQLITE_MANAGER.isCommonPopup = true;
    }
    
    YGJCommonPopup *popup = [YGJCommonPopup new];
    [popup setupContentWithStatus:popupStatus];
    [popup setupCompleteHandler:completeHandler];
    [popup setupCancelHandler:cancelHandler];
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    modalViewController.modal = true;
    modalViewController.contentView = popup.contentView;
    modalViewController.dimmingView.backgroundColor = [UIColorMakeWithHex(@"#000000") colorWithAlphaComponent:0.5];
    modalViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        
        popup.contentView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
    };
//    modalViewController.hidingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, void(^completion)(BOOL finished)) {
//
//        [UIView animateWithDuration:.3 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
//
//            dimmingView.alpha = 0.0;
//            popup.contentView.top = SCREEN_HEIGHT;
//        } completion:^(BOOL finished) {
//            // 记住一定要在适当的时机调用completion()
//            if (completion)
//                completion(finished);
//        }];
//    };
    [modalViewController showWithAnimated:true completion:^(BOOL finished) {
    }];
    popup.modalViewControllerForAddSubview = modalViewController;
}

#pragma mark - Intial Methods
- (instancetype)init {
    
    if (self = [super init]) {
        
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.contentLab];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.sureButton];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).mas_offset(kScale_W(20));
        make.height.mas_offset(kScale_W(17));
        make.width.mas_offset(kScale_W(200));
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.contentView).mas_offset(kScale_W(-19.5));
        make.left.equalTo(self.contentView).mas_offset(kScale_W(20));
        make.height.mas_offset(kScale_W(45));
        make.width.mas_offset(kScale_W(100));
    }];

    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.cancelButton);
        make.height.mas_offset(kScale_W(45));
        make.width.mas_offset(kScale_W(100));
        make.right.equalTo(self.contentView).mas_offset(kScale_W(-20));
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.titleLab.mas_bottom).mas_offset(kScale_W(10));
        make.left.equalTo(self.contentView).mas_offset(kScale_W(20));
        make.right.equalTo(self.contentView).mas_offset(kScale_W(-20));
        make.bottom.equalTo(self.sureButton.mas_top).mas_offset(kScale_W(-20));
    }];

}
#pragma mark - Events
- (void)cancelButtonEvent {
    if (self.popupStatus == YGJPopupStatusLogin) {
        YGJSQLITE_MANAGER.isCommonPopup = false;
    }
    
    
    @weakify(self);
    [self.modalViewControllerForAddSubview hideWithAnimated:true completion:^(BOOL finished) {
        
        @strongify(self);
        if (self.cancelHandler) self.cancelHandler();
        [self releaseAllSubviews];
    }];
}

- (void)sureButtonEvent {
    
    if (self.popupStatus == YGJPopupStatusLogin) {
        YGJSQLITE_MANAGER.isCommonPopup = false;
    }
    @weakify(self);
    [self.modalViewControllerForAddSubview hideWithAnimated:true completion:^(BOOL finished) {
        
        @strongify(self);
        if (self.completeHandler) self.completeHandler();
        [self releaseAllSubviews];
        
        if (self.popupStatus == YGJPopupStatusLogin) {
            LoginViewController *rootViewController = [LoginViewController new];
            UIWindow* window = [UIApplication sharedApplication].keyWindow;
            
            rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            typedef void (^Animation)(void);
            Animation animation = ^{
                
                BOOL oldState = [UIView areAnimationsEnabled];
                [UIView setAnimationsEnabled:false];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
                });
                [UIView setAnimationsEnabled:oldState];
            };
            [UIView transitionWithView:window duration:0.35f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:animation
                            completion:nil];
        } else {
            
            YGJPersonMessageVC *viewController = [YGJPersonMessageVC new];
            [[QMUIHelper visibleViewController].navigationController pushViewController:viewController animated:YES];
        }
    }];
}

#pragma mark - Public Methods

#pragma mark - Private Method
- (void)setupContentWithStatus:(YGJPopupStatus)popupStatus {
    self.popupStatus = popupStatus;
    
    if (popupStatus == YGJPopupStatusLogin) {
        
        self.contentLab.text = @"未登录用户，暂无权限";
        [self.cancelButton setTitle:@"返回" forState:UIControlStateNormal];
        [self.sureButton setTitle:@"去登录" forState:UIControlStateNormal];
        return;
    }
    
    self.contentLab.text = @"您尚未认证，暂无权限";
    [self.cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.sureButton setTitle:@"去认证" forState:UIControlStateNormal];
}
- (void)setupCompleteHandler:(YGJPopupBlock)complete {
    
    self.completeHandler = complete;
}
- (void)setupCancelHandler:(YGJPopupBlock)cancel {
    
    self.cancelHandler = cancel;
}
- (void)releaseAllSubviews {
    
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _modalViewControllerForAddSubview = nil;
    _contentView = nil;
}

-(UIViewController *)cd_viewController {
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

#pragma mark - Setter Getter Methods
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  kScale_W(257), kScale_W(185))];
        _contentView.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
        _contentView.layer.masksToBounds = true;
        _contentView.layer.cornerRadius = 8.0;
    }
    return _contentView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = UIFontBoldMake(18.0);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = UIColorMakeWithHex(@"#333333");
        _titleLab.text = @"提示";
    }
    return _titleLab;
}
- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLab.font = UIFontMake(15.0);
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.textColor = UIColorMakeWithHex(@"#333333");
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}
- (QMUIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[QMUIButton alloc] qmui_initWithImage:nil title:@"返回"];
        _cancelButton.titleLabel.font = UIFontMake(15);
        [_cancelButton setTitleColor:UIColorMakeWithHex(@"#999999") forState:UIControlStateNormal];
        _cancelButton.layer.masksToBounds = true;
        _cancelButton.layer.cornerRadius = 5.0;
        _cancelButton.layer.borderWidth = 0.5;
        _cancelButton.layer.borderColor = UIColorMakeWithHex(@"#CCCCCC").CGColor;
        [_cancelButton setBackgroundColor:UIColorMakeWithHex(@"#FFFFFF")];
        [_cancelButton addTarget:self action:@selector(cancelButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (QMUIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[QMUIButton alloc] qmui_initWithImage:nil title:@"去认证"];
        [_sureButton setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];
        _sureButton.titleLabel.font = UIFontMake(15);
        _sureButton.layer.masksToBounds = true;
        _sureButton.layer.cornerRadius = 5.0;
        [_sureButton setBackgroundColor:UIColorMakeWithHex(@"#4581EB")];
        [_sureButton addTarget:self action:@selector(sureButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
@end
