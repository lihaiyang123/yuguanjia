//
//  YGJAlertView.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/1.
//

#import "YGJAlertView.h"

@interface YGJAlertView ()

@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) NSArray *buttonNameArr;
@property (nonatomic, copy) NSString *topTitleStr;
@property (nonatomic, copy) NSString *senderTitle;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) NSMutableArray *selectedSerTypesArray;//选择的商户类型
@property (nonatomic, strong) NSMutableArray *selectedButtonArray;
@property (nonatomic, strong) NSMutableArray *selectedButtonTagArray;

@end

@implementation YGJAlertView

- (id)initWithButtonTitleArr:(NSArray *)titleArr withTitle:(NSString *)titleStr isLogin:(BOOL)isLogin {
    
    self = [super init];
    if (self) {
        self.topTitleStr = titleStr;
        self.buttonNameArr = titleArr;
        self.isLogin = isLogin;
        [self showHUD];
    }
    return self;
}

- (void)showHUD {
    
    self.backgroundColor = KBlackColor;
    UIColor *color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    [self addSubview:self.bigView];

    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.frame = CGRectMake(0, 0, 223, 46);
    topLabel.text = self.topTitleStr;
    topLabel.textColor = CNavBgColor;
    topLabel.font = SYSTEMFONT(15);
    topLabel.textAlignment = 1;
    [self.bigView addSubview:topLabel];
    
    UIView *underLine = [[UIView alloc] init];
    underLine.frame = CGRectMake(12, topLabel.bottom, 223-24, 1);
    underLine.backgroundColor = UNDERLINECOLOR;
    [self.bigView addSubview:underLine];
    
    for (int i = 0; i < self.buttonNameArr.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = KWhiteColor;
        button.tag = i;
        button.frame = CGRectMake(0, underLine.bottom+i*(46.5f), 223, 46);
        button.titleLabel.font = SYSTEMFONT(15);
        [button addTarget:self action:@selector(selectButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:KBlackColor forState:UIControlStateNormal];
        [button setTitleColor:CNavBgColor forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"login_selectProtocol"] forState:UIControlStateSelected];
        [button setTitle:self.buttonNameArr[i] forState:UIControlStateNormal];
        [self.bigView addSubview:button];
        [self.selectedButtonArray addObject:button];
        self.lastButton = button;
    }
    
    for (int i = 0; i < self.buttonNameArr.count; i ++) {
        
        if (i < self.buttonNameArr.count - 1 ) {
            UIView *underLineView = [[UIView alloc] init];
            underLineView.frame = CGRectMake(12, underLine.bottom+i*(46), 223-24, 0.5);
            underLineView.backgroundColor = UNDERLINECOLOR;
            [self.bigView addSubview:underLineView];
        }
    }
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.backgroundColor = KWhiteColor;
    sureButton.frame = CGRectMake(0, self.lastButton.bottom+0.5, 223, 46);
    sureButton.titleLabel.font = SYSTEMFONT(15);
    [sureButton addTarget:self action:@selector(sureButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitleColor:CNavBgColor forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.bigView addSubview:sureButton];

    if (self.isLogin) {
        _bigView.frame = CGRectMake((kScreenWidth-223)/2.0, (kScreenHeight-sureButton.bottom)/2.0, 223, sureButton.bottom);
    } else {
        _bigView.frame = CGRectMake((kScreenWidth-223)/2.0, (kScreenHeight-self.lastButton.bottom)/2.0, 223, self.lastButton.bottom);
    }
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bigView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.bigView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissView {
    [UIView animateWithDuration:0.2 animations:^{
            self.bigView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
    }];
}
- (void)selectButtonEvent:(UIButton *)sender {
    if (self.isLogin) {
        if (sender.tag == 3) {
            sender.selected = !sender.selected;
            [self.selectedSerTypesArray addObject:sender.titleLabel.text];
            [self.selectedButtonTagArray addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        } else {
            for (NSInteger j = 0; j < 3; j++) {
                UIButton *btn = self.selectedButtonArray[j];
                if (sender.tag == j) {
                    btn.selected = YES;
                    [self.selectedSerTypesArray addObject:sender.titleLabel.text];
                    [self.selectedButtonTagArray addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
                } else {
                    btn.selected = NO;
                }
            }
        }
    } else {
        self.senderTitle = sender.titleLabel.text;
        if (self.selectedButtonBlock) {
            self.selectedButtonBlock(self.senderTitle);
        }
        [self dismissView];
    }
}

- (void)sureButtonEvent {
    
    if (self.isLogin && self.selectedArrButtonBlock) {
        
        if ([self.selectedSerTypesArray count] == 0) {
            [YGJToast showToast:@"请选择身份"];
            return;
        }
        self.selectedArrButtonBlock(self.selectedSerTypesArray,self.selectedButtonTagArray);
    } else {
        if (self.selectedButtonBlock) {
            self.selectedButtonBlock(self.senderTitle);
        }
    }
    [self dismissView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissView];
}

- (UIView *)bigView{

    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = KWhiteColor;
        _bigView.layer.masksToBounds = YES;
        _bigView.layer.cornerRadius = 5;
        _bigView.layer.shadowColor = [UIColor colorWithRed:94/255.0 green:101/255.0 blue:112/255.0 alpha:0.35].CGColor;
        _bigView.layer.shadowOffset = CGSizeMake(0,2);
        _bigView.layer.shadowOpacity = 1;
        _bigView.layer.shadowRadius = 8;
    }
    return _bigView;
}

- (NSArray *)buttonNameArr {
    
    if (!_buttonNameArr) {
        _buttonNameArr = [NSArray array];
    }
    return _buttonNameArr;
}

- (NSMutableArray *)selectedSerTypesArray {
    
    if (!_selectedSerTypesArray) {
        _selectedSerTypesArray = [NSMutableArray array];
    }
    return _selectedSerTypesArray;
}

- (NSMutableArray *)selectedButtonArray {
    
    if (!_selectedButtonArray) {
        _selectedButtonArray = [NSMutableArray array];
    }
    return _selectedButtonArray;
}

- (NSMutableArray *)selectedButtonTagArray {
    
    if (!_selectedButtonTagArray) {
        _selectedButtonTagArray = [NSMutableArray array];
    }
    return _selectedButtonTagArray;
}
@end
