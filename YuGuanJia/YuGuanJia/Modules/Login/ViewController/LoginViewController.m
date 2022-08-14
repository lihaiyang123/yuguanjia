//
//  LoginViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/24.
//

#import "LoginViewController.h"
#import "RootTabbarController.h"
//models
#import "UserModel.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *bigTitleLabel;
@property (nonatomic, strong) UIImageView *phoneImageView;//手机图标
@property (nonatomic, strong) UITextField *phoneInputTF;//输入手机
@property (nonatomic, strong) UIImageView *msgImageView;//验证码图标
@property (nonatomic, strong) UITextField *msgInputTF;//输入验证码
@property (nonatomic, strong) CDCountDownButton *getCode;//获取验证码按钮
@property (nonatomic, strong) UIImageView *selectImageView;//选择身份图标
@property (nonatomic, strong) QMUIButton *selectIdentityButton;//选择身份按钮
@property (nonatomic, strong) UIButton *sureLoginButton;//登录按钮
@property (nonatomic, strong) UIButton *skipButton;//跳过按钮
@property (strong, nonatomic) UIButton *selectBtn;//复选框按钮
@property (strong, nonatomic) UIButton *userProtocolBtn;//用户协议
@property (strong, nonatomic) UIButton *privacyProtocolBtn;//隐私协议
@property (nonatomic, strong) UIView *firstUnderLine;
@property (nonatomic, strong) UIView *secUnderLine;
@property (nonatomic, strong) UIView *tirUnderLine;
@property (nonatomic, strong) NSMutableArray *idArr;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
    [self createUI];
}

#pragma mark - 布局
- (void)createUI {
    
    [self.view addSubview:self.skipButton];
    [self.view addSubview:self.bigTitleLabel];
    [self.view addSubview:self.phoneImageView];
    [self.view addSubview:self.phoneInputTF];
    [self.view addSubview:self.firstUnderLine];
    [self.view addSubview:self.msgImageView];
    [self.view addSubview:self.msgInputTF];
    [self.view addSubview:self.getCode];
    [self.view addSubview:self.secUnderLine];
    [self.view addSubview:self.selectImageView];
    [self.view addSubview:self.tirUnderLine];
    [self.view addSubview:self.selectBtn];
    [self.view addSubview:self.userProtocolBtn];
    [self.view addSubview:self.privacyProtocolBtn];
    [self.view addSubview:self.sureLoginButton];
    
    _skipButton.frame = CGRectMake(kScreenWidth-80, 44, 60, 40);
    CGFloat inputW = kScreenWidth - 105;
    _bigTitleLabel.frame = CGRectMake(0, kScale_W(80), kScreenWidth, 30);
    _phoneImageView.frame = CGRectMake(30, _bigTitleLabel.bottom + kScale_W(80), 15, 20);
    _phoneInputTF.frame = CGRectMake(_phoneImageView.right+30, _bigTitleLabel.bottom + kScale_W(80), inputW, 20);
    _firstUnderLine.frame = CGRectMake(30, _phoneImageView.bottom + 20, kScreenWidth-60, 1);
    _msgImageView.frame = CGRectMake(30, _firstUnderLine.bottom + 20, 15, 20);
    _msgInputTF.frame = CGRectMake(_msgImageView.right+30, _firstUnderLine.bottom + 20, 100, 20);
    _getCode.frame = CGRectMake(kScreenWidth-130, _firstUnderLine.bottom + 20, 100, 20);
    _secUnderLine.frame = CGRectMake(30, _msgImageView.bottom + 20, kScreenWidth-60, 1);
    _selectImageView.frame = CGRectMake(30, _secUnderLine.bottom + 20, 15, 20);
    
    
    self.selectIdentityButton = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"xia_more") title:@"选择身份"];
    self.selectIdentityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.selectIdentityButton addTarget:self action:@selector(selectedIDButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectIdentityButton setTitleColor:CBlackgColor forState:UIControlStateNormal];
    self.selectIdentityButton.spacingBetweenImageAndTitle = 6.0;
    self.selectIdentityButton.titleLabel.font = UIFontMake(12.0);
    self.selectIdentityButton.imagePosition = QMUIButtonImagePositionRight;
    self.selectIdentityButton.frame = CGRectMake(_selectImageView.right+30, _secUnderLine.bottom + 20, 120, 20);
    [self.view addSubview:self.selectIdentityButton];

    _tirUnderLine.frame = CGRectMake(30, _selectImageView.bottom + 20, kScreenWidth-60, 1);
    
    _selectBtn.frame = CGRectMake(30,_tirUnderLine.bottom + kScale_W(32), 16, 16);
    
    UILabel *firstLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectBtn.frame) + 5, _tirUnderLine.bottom + kScale_W(32), 95, 16)];
    firstLb.textColor = UIColorFromRGB(0x999999);
    firstLb.font = [UIFont systemFontOfSize:13];
    firstLb.text = @"我已阅读并同意";
    [self.view addSubview:firstLb];
    
    _userProtocolBtn.frame = CGRectMake(CGRectGetMaxX(firstLb.frame),_tirUnderLine.bottom + kScale_W(20), 80, 40);
    
    UILabel *secondLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userProtocolBtn.frame), _tirUnderLine.bottom + kScale_W(32), 14, 16)];
    secondLb.textColor = UIColorFromRGB(0x999999);
    secondLb.font = [UIFont systemFontOfSize:13];
    secondLb.text = @"及";
    [self.view addSubview:secondLb];
    
    _privacyProtocolBtn.frame  = CGRectMake(CGRectGetMaxX(secondLb.frame),_tirUnderLine.bottom + kScale_W(20), 80, 40);
    
    _sureLoginButton.frame = CGRectMake(30,_tirUnderLine.bottom + kScale_W(80), kScreenWidth-60, 48);
//    self.phoneInputTF.text = @"13800138000";
//    self.msgInputTF.text = @"1111";
}

#pragma mark - lazyload
- (UILabel *)bigTitleLabel {
    
    if (!_bigTitleLabel) {
        _bigTitleLabel = [[UILabel alloc] init];
        _bigTitleLabel.text = @"御管家";
        _bigTitleLabel.font = FONTSIZE(30);
        _bigTitleLabel.textAlignment = 1;
        _bigTitleLabel.textColor = CNavBgColor;
    }
    return _bigTitleLabel;
}

- (UIImageView *)phoneImageView {
    
    if (!_phoneImageView) {
        _phoneImageView = [[UIImageView alloc] init];
        _phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
        _phoneImageView.image = [UIImage imageNamed:@"iocn_shoujihao"];
    }
    return _phoneImageView;
}

- (UITextField *)phoneInputTF {
    
    if (!_phoneInputTF) {
        _phoneInputTF = [[UITextField alloc] init];
        _phoneInputTF.placeholder = @"请输入手机号码";
        _phoneInputTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneInputTF.delegate = self;
        _phoneInputTF.font = [UIFont systemFontOfSize:15];
        _phoneInputTF.textColor = [UIColor blackColor];
        [_phoneInputTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _phoneInputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _phoneInputTF;
}

- (UIView *)firstUnderLine {
    
    if (!_firstUnderLine) {
        _firstUnderLine = [[UIView alloc] init];
        _firstUnderLine.backgroundColor = UNDERLINECOLOR;
    }
    return _firstUnderLine;

}

- (UIImageView *)msgImageView {
    
    if (!_msgImageView) {
        _msgImageView = [[UIImageView alloc] init];
        _msgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _msgImageView.image = [UIImage imageNamed:@"icon_yanzhengma"];
    }
    return _msgImageView;
}

- (UITextField *)msgInputTF {
    
    if (!_msgInputTF) {
        _msgInputTF = [[UITextField alloc] init];
        _msgInputTF.placeholder = @"请输入验证码";
        _msgInputTF.keyboardType = UIKeyboardTypeNumberPad;
        _msgInputTF.delegate = self;
        _msgInputTF.font = [UIFont systemFontOfSize:15];
        _msgInputTF.textColor = [UIColor blackColor];
        [_msgInputTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _msgInputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _msgInputTF;
}

- (CDCountDownButton *)getCode{
    
    if (!_getCode) {
        _getCode = [CDCountDownButton buttonWithType:UIButtonTypeCustom];
        _getCode.backgroundColor = [UIColor clearColor];
        [_getCode addTarget:self action:@selector(getCodeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_getCode setTitleColor:CNavBgColor forState:UIControlStateNormal];
        _getCode.titleLabel.font = [UIFont systemFontOfSize:15];
        [_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    return _getCode;
}

- (UIView *)secUnderLine {
    
    if (!_secUnderLine) {
        _secUnderLine = [[UIView alloc] init];
        _secUnderLine.backgroundColor = UNDERLINECOLOR;
    }
    return _secUnderLine;
}

- (UIImageView *)selectImageView {
    
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.contentMode = UIViewContentModeScaleAspectFit;
        _selectImageView.image = [UIImage imageNamed:@"shenfen"];
    }
    return _selectImageView;
}

- (UIView *)tirUnderLine {
    
    if (!_tirUnderLine) {
        _tirUnderLine = [[UIView alloc] init];
        _tirUnderLine.backgroundColor = UNDERLINECOLOR;
    }
    return _tirUnderLine;
}

- (UIButton *)sureLoginButton {
    if (!_sureLoginButton) {
        _sureLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureLoginButton.backgroundColor = CNavBgColor;
        [_sureLoginButton addTarget:self action:@selector(loginButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_sureLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureLoginButton setTitle:@"登录" forState:UIControlStateNormal];
        _sureLoginButton.layer.masksToBounds = YES;
        _sureLoginButton.layer.cornerRadius = 24;
    }
    return _sureLoginButton;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [_selectBtn addTarget:self action:@selector(protocolSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"login_selectProtocol"] forState:UIControlStateSelected];
    }
    return _selectBtn;
}

- (UIButton *)userProtocolBtn{
    if (!_userProtocolBtn) {
        _userProtocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _userProtocolBtn.tag = 800;
        [_userProtocolBtn setTitleColor:UIColorFromRGB(0x0F7CFF) forState:UIControlStateNormal];
        [_userProtocolBtn setTitleColor:UIColorFromRGB(0x0F7CFF) forState:UIControlStateHighlighted];
        [_userProtocolBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
        _userProtocolBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_userProtocolBtn addTarget:self action:@selector(protocolAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userProtocolBtn;
}

- (UIButton *)privacyProtocolBtn{
    if (!_privacyProtocolBtn) {
        _privacyProtocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _privacyProtocolBtn.tag = 801;
        [_privacyProtocolBtn setTitleColor:UIColorFromRGB(0x0F7CFF) forState:UIControlStateNormal];
        [_privacyProtocolBtn setTitleColor:UIColorFromRGB(0x0F7CFF) forState:UIControlStateHighlighted];
        [_privacyProtocolBtn setTitle:@"《隐私协议》" forState:UIControlStateNormal];
        _privacyProtocolBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_privacyProtocolBtn addTarget:self action:@selector(protocolAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privacyProtocolBtn;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.backgroundColor = CNavBgColor;
        [_skipButton addTarget:self action:@selector(skipButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    }
    return _skipButton;
}

#pragma mark - 点击事件
- (void)skipButtonEvent:(UIButton *)sender {
    
    RootTabbarController *VC = [[RootTabbarController alloc] init];
    UIWindow *window = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
    window.rootViewController = VC;
    [window makeKeyAndVisible];
}

- (void)protocolSelectAction:(UIButton *)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
}

- (void)protocolAction:(UIButton *)sender {
    NSInteger index = sender.tag - 800;
    if (index == 0) {
        NSLog(@"%@",[YGJSetUp getAgrementUrl]);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[YGJSetUp getAgrementUrl]]];
    }else{
        NSLog(@"%@",[YGJSetUp getPrivacyUrl]);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[YGJSetUp getPrivacyUrl]]];
    }
}

- (void)getCodeButtonEvent:(UIButton *)sender {
    
    if ([_phoneInputTF canBecomeFirstResponder]) {
        [_phoneInputTF resignFirstResponder];
    }
//    手机号判断
    if ([[MethodManager sharedMethodManager] isBlankString:_phoneInputTF.text]) {
        [YGJToast showToast:@"请输入手机号"];
        return;
    }
    if (![NSString isMobileNumber:_phoneInputTF.text]) {
        [YGJToast showToast:@"请输入正确的手机号"];
        return;
    }
    // 调用获取验证码接口
    [UDAAPIRequest requestUrl:[NSString stringWithFormat:@"/app/base/send-sms/%@",_phoneInputTF.text] parameter:@{} requestType:UDARequestTypePost isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        YDZYLog(@" ---返回数据-- %@",requestModel);
        if (requestModel.success) {
            
            self.getCode.userInteractionEnabled = false;
            [self.getCode startCountDownWithSecond:60];
            [self.getCode  countDownChanging:^NSString *(CDCountDownButton *countDownButton,NSUInteger second) {
                
                [countDownButton setTitleColor:UIColorFromRGB(0xdddddd) forState:UIControlStateNormal];
                return [NSString stringWithFormat:@"重新获取%@s",@(second)];
            }];
            [self.getCode  countDownFinished:^NSString *(CDCountDownButton *countDownButton, NSUInteger second) {
                
                [countDownButton setTitleColor:CNavBgColor forState:UIControlStateNormal];
                countDownButton.userInteractionEnabled = true;
                return @"获取验证码";
            }];
        }else{
            
            [YGJToast showToast:requestModel.message];
        }
    } errorBlock:^(NSError * _Nullable error) {
        YDZYLog(@" ---返回错误-- %@",error);
    }];
}
- (void)loginButtonEvent:(UIButton *)sender {
        
    if ([_phoneInputTF canBecomeFirstResponder]) {
        [_phoneInputTF resignFirstResponder];
    }
    if ([_msgInputTF canBecomeFirstResponder]) {
        [_msgInputTF resignFirstResponder];
    }
    
    if (!self.selectBtn.selected) {
        [YGJToast showToast:@"请先勾选同意后再进行登录"];
        return;
    }
    //    手机号判断
    if ([[MethodManager sharedMethodManager] isBlankString:_phoneInputTF.text]) {
        [YGJToast showToast:@"请输入手机号"];
        return;
    }
    if (![NSString isMobileNumber:_phoneInputTF.text]) {
        [YGJToast showToast:@"请输入正确的手机号"];
        return;
    }
    if ([NSString isBlankString:_msgInputTF.text]) {
        [YGJToast showToast:@"请输入验证码"];
        return;
    }
    if (_msgInputTF.text.length < 4) {
        [YGJToast showToast:@"请输入4位验证码"];
        return;
    }
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/base/phone-login" parameter:@{@"phone":_phoneInputTF.text,@"code":_msgInputTF.text} requestType:UDARequestTypePost isShowHUD:YES progressBlock:^(CGFloat value) {

    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {

        @strongify(self);
        if (requestModel.success) {
            [YGJSQLITE_MANAGER updateLoginToken:requestModel.result[@"token"]];
            [self getUserInfoRequest];
        }else{
            [YGJToast showToast:requestModel.message];
        }
    } errorBlock:^(NSError * _Nullable error) {

    }];
}

- (void)getUserInfoRequest {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/users/getUsersInfoByToken" parameter:nil requestType:UDARequestTypePost isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            UserModel *model = [UserModel modelWithDictionary:requestModel.result];
            [YGJSQLITE_MANAGER updateUserInfoModel:model];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:model.serTypes];
            [YGJSQLITE_MANAGER updateLoginRequestIdentity:arr];
            //没有认证身份 把选择的身份存在本地
            if (model.serCert == 0 && model.idcardCert == 0) {
                [YGJToast showToast:@"请选择身份"];
                if ([self.idArr count] > 0) {
                    [YGJSQLITE_MANAGER updateLoginIdentity:self.idArr];
                    RootTabbarController *VC = [[RootTabbarController alloc] init];
                    UIWindow *window = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
                    window.rootViewController = VC;
                    [window makeKeyAndVisible];
                }
                return;
            }
            RootTabbarController *VC = [[RootTabbarController alloc] init];
            UIWindow *window = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
            window.rootViewController = VC;
            [window makeKeyAndVisible];
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];

}
- (void)selectedIDButtonClicked:(UIButton *)sender {

    NSArray *titleArr = @[@"商品商户",@"仓储加工商户",@"物流商户",@"个体商户"];
    YGJAlertView *alertView = [[YGJAlertView alloc] initWithButtonTitleArr:titleArr withTitle:@"选择身份" isLogin:YES];
    alertView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [alertView show];
    
    @weakify(self);
    alertView.selectedArrButtonBlock = ^(NSMutableArray * _Nonnull buttonTitleArr,NSMutableArray * _Nonnull buttonTagArr) {
        
        @strongify(self);
        self.idArr = buttonTagArr;
        if (buttonTitleArr.count == 1) {
            [self.selectIdentityButton setTitle:[NSString stringWithFormat:@"%@",buttonTitleArr[0]] forState:UIControlStateNormal];
        }else {
            [self.selectIdentityButton setTitle:[NSString stringWithFormat:@"%@,%@",buttonTitleArr[0],buttonTitleArr[1]] forState:UIControlStateNormal];
        }
        [self.selectIdentityButton sizeToFit];
    };
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (![textField isExclusiveTouch]) {
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == _phoneInputTF) {
        
        NSString *toBeString = textField.text;
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        CGFloat maxLength = 11;
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
                if (rangeIndex.length == 1) {
                    textField.text = [toBeString substringToIndex:maxLength];
                }
                else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
    if (textField == _msgInputTF) {
        
        NSString *toBeString = textField.text;
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        CGFloat maxLength = 6;
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
                if (rangeIndex.length == 1) {
                    textField.text = [toBeString substringToIndex:maxLength];
                } else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}

- (NSMutableArray *)idArr {
    
    if (!_idArr) {
        _idArr = [NSMutableArray array];
    }
    return _idArr;
}
@end
