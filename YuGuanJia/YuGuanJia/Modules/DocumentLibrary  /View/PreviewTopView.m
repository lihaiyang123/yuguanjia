//
//  PreviewTopView.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/31.
//

#import "PreviewTopView.h"

@interface PreviewTopView ()

@property (nonatomic, weak) id <PreviewTopViewDelegate>delegate;
@property (nonatomic, strong) UIStackView *stackMenuView;
@property (nonatomic, strong) UILabel *msgLabel;
@end

@implementation PreviewTopView

- (instancetype)initWithDelegate:(id<PreviewTopViewDelegate>)delegate {
    
    if (self = [super init]) {
        
        self.delegate = delegate;
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
#pragma mark - Intial Methods
- (void)setupView {
    
    [self addSubview:self.msgLabel];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
        make.top.left.right.equalTo(self);
        make.height.mas_offset(kScale_W(70));
    }];
    [self addSubview:self.stackMenuView];
    [self.stackMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_offset(kScale_W(50));
        make.bottom.equalTo(self);
    }];
}
#pragma mark - Events
- (void)buttonClickEvent:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(leftButtonEventWithTitle:)]) {
        [self.delegate leftButtonEventWithTitle:btn.titleLabel.text];
    }
}
#pragma mark - Public Methods
- (void)setupLeftButtons:(NSArray *)buttons withMsg:(NSString *)msg {
    self.msgLabel.text = msg;
    if ([buttons count] == 0) return;
    
    for (NSString *tit in buttons) {
        
        QMUIButton *button = [[QMUIButton alloc] qmui_initWithImage:nil title:[NSString stringWithFormat:@"%@", tit]];
        [button setTitleColor:UIColorMakeWithHex(@"#4581EB") forState:UIControlStateNormal];
        button.titleLabel.font = UIFontMake(15.0);
//        [button setBackgroundColor:UIColorMakeWithHex(@"#4581EB")];
        [button addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
//        button.frame = CGRectMake(0, 0, 120, kScale_W(50));
//        button.layer.cornerRadius = kScale_W(25);
        [self.stackMenuView addArrangedSubview:button];
    }
}
#pragma mark - Private Method
- (void)setupDeviceOrientation {
    NSLog(@"SCREEN_WIDTH: %.2f", SCREEN_WIDTH);
//    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    if (SCREEN_WIDTH > SCREEN_HEIGHT) {
        
        [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(self);
            if (@available(iOS 11.0, *)) {
                make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
            } else {
                make.left.equalTo(self);
            }
            make.width.mas_offset(kScale_W(180));
        }];
        [self.stackMenuView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.msgLabel.mas_right);
            if (@available(iOS 11.0, *)) {
                make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
            } else {
                make.right.equalTo(self);
            }
        }];
        return;
    }
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        make.top.left.right.equalTo(self);
        make.height.mas_offset(kScale_W(70));
    }];
    [self.stackMenuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_offset(kScale_W(50));
        make.bottom.equalTo(self);
    }];
}

#pragma mark - External Delegate

#pragma mark – Getters and Setters
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _msgLabel.font = UIFontMake(16);
        _msgLabel.textColor = UIColorMakeWithHex(@"#666666");
        _msgLabel.textAlignment = NSTextAlignmentCenter;
//        _msgLabel.qmui_lineHeight = kScale_W(70);
    }
    return _msgLabel;
}
- (UIStackView *)stackMenuView {
    if (!_stackMenuView) {
        _stackMenuView = [[UIStackView alloc] init];
        _stackMenuView.translatesAutoresizingMaskIntoConstraints = false;
        _stackMenuView.axis = UILayoutConstraintAxisHorizontal;
        _stackMenuView.alignment = UIStackViewAlignmentFill;
        _stackMenuView.distribution = UIStackViewDistributionFill;
        _stackMenuView.spacing = kScale_W(50);
        _stackMenuView.alignment = UIStackViewAlignmentCenter;
    }
    return _stackMenuView;
}
@end
