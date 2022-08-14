//
//  EditDetailInlineSelectorCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/7.
//

#import "EditDetailInlineSelectorCell.h"

@interface EditDetailInlineSelectorCell ()

@property (nonatomic, strong) UIView *customRightView;
@property (nonatomic, strong) UILabel *customRightLabel;
@property (nonatomic, strong) UIView  *verticalLineView;
@property (nonatomic, strong) UIImageView *selectArrowImageView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation EditDetailInlineSelectorCell


+(void)load {

}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    
    return kScale_W(55);
}

- (void)configure {
    [super configure];
    
    [self.contentView     addSubview:self.customRightView];
    [self.customRightView addSubview:self.customRightLabel];
    [self.customRightView addSubview:self.verticalLineView];
    [self.customRightView addSubview:self.selectArrowImageView];
    
    [self.customRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kScale_W(10.5));
        make.right.equalTo(self.contentView.mas_right).offset(-kScale_W(12));
        make.width.mas_equalTo(kScale_W(139.5));
        make.height.mas_equalTo(kScale_W(34));
    }];
    
    [self.customRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customRightView.mas_top).offset(0);
        make.left.equalTo(self.customRightView.mas_left).offset(0);
        make.height.mas_equalTo(kScale_W(34));
        make.width.mas_equalTo(kScale_W(104.5));
    }];
    
    [self.verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customRightView.mas_top).offset(0);
        make.left.equalTo(self.customRightLabel.mas_right).offset(1);
        make.height.mas_equalTo(kScale_W(34));
        make.width.mas_equalTo(1);
    }];

    
    CGFloat top = ((kScale_W(34)) - 5.5)/2.0;
    CGFloat left = ((kScale_W(34)) - 10)/2.0;
    [self.selectArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customRightView.mas_top).offset(top);
        make.left.equalTo(self.verticalLineView.mas_right).offset(left);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(5.5);
    }];
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_offset(1.0);
    }];


    
}

-(void)update {
    [super update];
    self.textLabel.font = FONTSIZEBOLD(16);
    NSString *titleString = self.rowDescriptor.title;
    self.detailTextLabel.hidden = YES;
    self.customRightLabel.text = self.rowDescriptor.value;
    if (self.rowDescriptor.required) {
        
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@",titleString]];
        NSRange range0 = [[hintString string]rangeOfString:@"*"];
        NSRange range1 = [[hintString string]rangeOfString:titleString];
        
        [hintString addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#F42481") range:range0];
        [hintString addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#333333") range:range1];
        self.textLabel.attributedText = hintString;
        
    }else {
        
        self.textLabel.text = titleString;

    }

    
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - Setter Getter Methods

- (UIView *)customRightView {
    
    if (!_customRightView) {
        
        _customRightView = [[UIView alloc] init];
        _customRightView.backgroundColor = KWhiteColor;
        _customRightView.layer.masksToBounds = YES;
        _customRightView.layer.cornerRadius = 5;
        _customRightView.layer.borderColor = UIColorMakeWithHex(@"#F1F3F4").CGColor;
        _customRightView.layer.borderWidth = 1;
    }
    return _customRightView;
}

- (UILabel *)customRightLabel {
    
    if (!_customRightLabel) {
        
        _customRightLabel = [[UILabel alloc] init];
        _customRightLabel.textColor = UIColorMakeWithHex(@"#333333");
        _customRightLabel.font = UIFontMake(16);
        _customRightLabel.textAlignment = 1;
    }
    
    return _customRightLabel;
}

- (UIImageView *)selectArrowImageView {
    
    if (!_selectArrowImageView) {
        
        _selectArrowImageView = [[UIImageView alloc] init];
        _selectArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _selectArrowImageView.image = UIImageMake(@"xia_more");
    }
    return  _selectArrowImageView;
}

- (UIView *)verticalLineView {
    
    if (!_verticalLineView) {
        
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.backgroundColor = UIColorMakeWithHex(@"#F1F3F4");
    }
    return _verticalLineView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = UIColorMakeWithHex(@"#F2F2F2");
    }
    return _lineView;
}


@end
