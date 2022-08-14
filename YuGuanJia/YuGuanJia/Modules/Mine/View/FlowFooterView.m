//
//  FlowFooterView.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/14.
//

#import "FlowFooterView.h"

@interface FlowFooterView ()

@property (nonatomic, strong) UIButton *addLCBtn;
@property (nonatomic, copy) CDBlock block;
@end

@implementation FlowFooterView

- (instancetype)initWithBlock:(CDBlock)block {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kScale_W(145))]) {
        
        _block = block;
        [self setupView];
    }
    return self;
}

#pragma mark - Intial Methods
- (void)setupView {
    
    self.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
    [self addSubview:self.addLCBtn];
    [self.addLCBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_offset(kScale_W(135));
        make.height.mas_offset(kScale_W(45));
        make.center.equalTo(self);
    }];
}
#pragma mark - Target Methods
- (void)seeBtnClick {
    if (self.block) {
        self.block();
    }
}
#pragma mark - Public Methods

#pragma mark - Private Method

#pragma mark - Setter Getter Methods
- (UIButton *)addLCBtn {
    if (!_addLCBtn) {
        _addLCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addLCBtn setTitle:@"新建流程" forState:UIControlStateNormal];
        _addLCBtn.backgroundColor = CNavBgColor;
        [_addLCBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        _addLCBtn.titleLabel.font = FONTSIZEBOLD(18);
        _addLCBtn.layer.cornerRadius = kScale_W(22.5);
        [_addLCBtn addTarget:self action:@selector(seeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addLCBtn;
}

@end
