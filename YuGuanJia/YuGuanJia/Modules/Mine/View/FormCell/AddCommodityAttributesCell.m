//
//  AddCommodityAttributesCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/17.
//

#import "AddCommodityAttributesCell.h"

NSString *const AddCommodityAttributes = @"AddCommodityAttributes";

@interface AddCommodityAttributesCell ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secButton;

@end

@implementation AddCommodityAttributesCell

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    
    return kScale_W(55);
}
+(void)load {
    
}

- (void)configure {
    
    [super configure];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_offset(1.0);
    }];
    
    [self.contentView addSubview:self.firstButton];
    [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(kScale_W(136));
        make.top.equalTo(self.contentView.mas_top).offset(kScale_W(12.5));
        make.height.mas_equalTo(kScale_W(30.5));
        make.width.mas_equalTo(kScale_W(90.5));
        
    }];
    
    [self.contentView addSubview:self.secButton];
    [self.secButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.firstButton.mas_right).offset(kScale_W(26.5));
        make.top.equalTo(self.contentView.mas_top).offset(kScale_W(12.5));
        make.height.mas_equalTo(kScale_W(30.5));
        make.width.mas_equalTo(kScale_W(90.5));
    }];



}
-(void)update {
    
    [super update];
    self.textLabel.font = FONTSIZEBOLD(16);
    NSString *titleString = self.rowDescriptor.title;
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@",titleString]];
    NSRange range0 = [[hintString string]rangeOfString:@"*"];
    NSRange range1 = [[hintString string]rangeOfString:titleString];
    
    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#F42481") range:range0];
    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#333333") range:range1];
    self.textLabel.attributedText = hintString;
    
    if ([self.rowDescriptor.value integerValue] == 0) {
        [self firstButtonEvent:_firstButton];
    }else {
        [self firstButtonEvent:_secButton];
    }
}
#pragma mark - Setter Getter Methods
- (UIButton *)firstButton {
    if (!_firstButton) {
        _firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_firstButton setTitle:@"虚拟服务" forState:UIControlStateNormal];
        _firstButton.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
        [_firstButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
        _firstButton.titleLabel.font = FONTSIZEBOLD(14);
        _firstButton.layer.cornerRadius = kScale_W(5);
        _firstButton.layer.borderColor = UIColorMakeWithHex(@"CCCCCC").CGColor;
        _firstButton.layer.borderWidth = 0.5;
        [_firstButton addTarget:self action:@selector(firstButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstButton;
}

- (UIButton *)secButton {
    if (!_secButton) {
        _secButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_secButton setTitle:@"实物商品" forState:UIControlStateNormal];
        _secButton.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
        [_secButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];
        _secButton.titleLabel.font = FONTSIZEBOLD(14);
        _secButton.layer.cornerRadius = kScale_W(5);
        _secButton.layer.borderColor = UIColorMakeWithHex(@"#CCCCCC").CGColor;
        _secButton.layer.borderWidth = 0.5;
        [_secButton addTarget:self action:@selector(secButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secButton;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorMakeWithHex(@"#F2F2F2");
    }
    return _lineView;
}


- (void)firstButtonEvent:(UIButton *)sender {
    
    _firstButton.backgroundColor = UIColorMakeWithHex(@"#4581EB");
    _firstButton.layer.borderColor = UIColorMakeWithHex(@"4581EB").CGColor;
    [_firstButton setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];

    _secButton.layer.borderColor = UIColorMakeWithHex(@"#CCCCCC").CGColor;
    _secButton.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
    [_secButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];

    self.rowDescriptor.value = sender.titleLabel.text;
}

- (void)secButtonEvent:(UIButton *)sender {
    
    _firstButton.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
    _firstButton.layer.borderColor = UIColorMakeWithHex(@"CCCCCC").CGColor;
    [_firstButton setTitleColor:UIColorMakeWithHex(@"#666666") forState:UIControlStateNormal];

    _secButton.layer.borderColor = UIColorMakeWithHex(@"#4581EB").CGColor;
    _secButton.backgroundColor = UIColorMakeWithHex(@"#4581EB");
    [_secButton setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];

    self.rowDescriptor.value = sender.titleLabel.text;
    
}
@end
