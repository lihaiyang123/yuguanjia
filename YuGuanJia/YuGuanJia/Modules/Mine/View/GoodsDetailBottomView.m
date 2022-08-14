//
//  GoodsDetailBottomView.m
//  YuGuanJia
//
//  Created by Yang on 2021/8/2.
//

#import "GoodsDetailBottomView.h"

@interface GoodsDetailBottomView ()

@property (nonatomic, weak) id <GoodsDetailBottomViewDelegate>delegate;
@property (nonatomic, strong) QMUILabel *refuseReasonLabel;//拒绝理由
@property (nonatomic, strong) QMUIButton *onSaleButton;//上架
@property (nonatomic, strong) QMUIButton *offSaleButton;//下架
@property (nonatomic, strong) QMUIButton *reditButton;//重新编辑


@end

@implementation GoodsDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<GoodsDetailBottomViewDelegate>)delegate {
    
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = delegate;
        [self setupView];
    }
    return self;
}

#pragma mark - Intial Methods
- (void)setupView {
    
    self.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
    [self addSubview:self.refuseReasonLabel];
    [self addSubview:self.onSaleButton];
    [self addSubview:self.offSaleButton];
    [self addSubview:self.reditButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat btnW = CGRectGetWidth(self.frame)/2.0;
    CGFloat btnH = CGRectGetHeight(self.frame);
    if (self.goodsStatus == YGJGoodsStatusApproved) {
        //审核通过
        self.offSaleButton.frame = CGRectMake(0, 0, btnW, btnH);
        self.reditButton.frame = CGRectMake(btnW, 0, btnW, btnH);
    } else if (self.goodsStatus == YGJGoodsStatusRemoved) {
        //已下架
        [self.onSaleButton setTitle:@"重新上架" forState:UIControlStateNormal];
        self.onSaleButton.frame = CGRectMake(0, 0, btnW, btnH);
        self.reditButton.frame = CGRectMake(btnW, 0, btnW, btnH);
    } else if (self.goodsStatus == YGJGoodsStatusRejected) {
        //被拒绝
        self.refuseReasonLabel.hidden = NO;
        self.refuseReasonLabel.text = self.rejectReason;
        self.refuseReasonLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kScale_W(25));
        self.reditButton.frame = CGRectMake(0, kScale_W(25), CGRectGetWidth(self.frame), btnH-kScale_W(25));
    } else {
        //上架中
        self.offSaleButton.frame = CGRectMake(0, 0, btnW, btnH);
        self.reditButton.frame = CGRectMake(btnW, 0, btnW, btnH);
    }
}

#pragma mark - Events
- (void)onSaleButtonEvent:(UIButton *)sender {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/goods/onsale" parameter:@{@"id":@(self.goodsID)} requestType:UDARequestTypePut isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            if ([self.delegate respondsToSelector:@selector(popGoodsListViewController)]) {
                [self.delegate popGoodsListViewController];
            }
        }
        
    } errorBlock:^(NSError * _Nullable error) {
        
    }];
    
}
- (void)offSaleButtonEvent:(UIButton *)sender {
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/goods/offsale" parameter:@{@"id":@(self.goodsID)} requestType:UDARequestTypePut isShowHUD:YES progressBlock:^(CGFloat value) {
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            if ([self.delegate respondsToSelector:@selector(popGoodsListViewController)]) {
                [self.delegate popGoodsListViewController];
            }
        }
    } errorBlock:^(NSError * _Nullable error) {
        
    }];
}
- (void)reditButtonEvent:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(pushEditGoodsViewController)]) {
        [self.delegate pushEditGoodsViewController];
    }
}

#pragma mark - Public Methods

#pragma mark - Private Method

#pragma mark - External Delegate

#pragma mark – Getters and Setters
- (QMUILabel *)refuseReasonLabel {

    if (!_refuseReasonLabel) {
        _refuseReasonLabel = [[QMUILabel alloc] init];
        _refuseReasonLabel.textColor = UIColorMakeWithHex(@"#FFFFFF");
        _refuseReasonLabel.font = UIFontBoldMake(13);
        _refuseReasonLabel.textAlignment = NSTextAlignmentCenter;
        _refuseReasonLabel.backgroundColor = UIColorMakeWithHex(@"#FF0000");
    }
    return _refuseReasonLabel;
}

- (QMUIButton *)onSaleButton {

    if (!_onSaleButton) {
        _onSaleButton = [[QMUIButton alloc] initWithFrame:CGRectZero];
        [_onSaleButton setTitle:@"上架" forState:UIControlStateNormal];
        _onSaleButton.backgroundColor = KWhiteColor;
        [_onSaleButton setTitleColor:UIColorMakeWithHex(@"999999") forState:UIControlStateNormal];
        _onSaleButton.titleLabel.font = UIFontMake(15);
        [_onSaleButton addTarget:self action:@selector(onSaleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _onSaleButton;
}

- (UIButton *)offSaleButton {

    if (!_offSaleButton) {
        _offSaleButton = [[QMUIButton alloc] initWithFrame:CGRectZero];
        [_offSaleButton setTitle:@"下架" forState:UIControlStateNormal];
        _offSaleButton.backgroundColor = KWhiteColor;
        [_offSaleButton setTitleColor:UIColorMakeWithHex(@"999999") forState:UIControlStateNormal];
        _offSaleButton.titleLabel.font = UIFontMake(15);
        [_offSaleButton addTarget:self action:@selector(offSaleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _offSaleButton;
}

- (QMUIButton *)reditButton {
    if (!_reditButton) {
        _reditButton = [[QMUIButton alloc] initWithFrame:CGRectZero];
        [_reditButton setTitle:@"重新编辑" forState:UIControlStateNormal];
        _reditButton.backgroundColor = UIColorMakeWithHex(@"#4581EB");
        _reditButton.titleLabel.font = UIFontBoldMake(18);
        [_reditButton setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];
        [_reditButton addTarget:self action:@selector(reditButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reditButton;
}
@end
