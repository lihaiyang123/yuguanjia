//
//  AddCommodityPriceCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/17.
//

#import "AddCommodityPriceCell.h"
NSString *const AddCommodityPrice = @"AddCommodityPrice";

@interface AddCommodityPriceCell ()

@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) UILabel *leftTipsLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation AddCommodityPriceCell

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
    
    [self.contentView addSubview:self.leftTitleLabel];
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(kScale_W(16));
        make.top.equalTo(self.contentView.mas_top).offset(kScale_W(14.5));
        make.height.mas_equalTo(kScale_W(15.5));
        make.width.mas_equalTo(kScale_W(120));
        
    }];
    
    [self.contentView addSubview:self.leftTipsLabel];
    [self.leftTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(kScale_W(16));
        make.top.equalTo(self.leftTitleLabel.mas_bottom).offset(kScale_W(4.5));
        make.height.mas_equalTo(kScale_W(10));
        make.width.mas_equalTo(kScale_W(200));
    }];



}
-(void)update {
    
    [super update];
    self.textLabel.hidden = YES;
    self.textField.textColor = UIColorMakeWithHex(@"#333333");
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.font = UIFontMake(16);

    
    NSString *titleString = self.rowDescriptor.title;
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@",titleString]];
    NSRange range0 = [[hintString string]rangeOfString:@"*"];
    NSRange range1 = [[hintString string]rangeOfString:titleString];
    
    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#F42481") range:range0];
    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorMakeWithHex(@"#333333") range:range1];
    self.leftTitleLabel.attributedText = hintString;
    

}
#pragma mark - Setter Getter Methods

- (UILabel *)leftTitleLabel {
    
    if (!_leftTitleLabel) {
        
        _leftTitleLabel = [[UILabel alloc] init];
        _leftTitleLabel.textColor = UIColorMakeWithHex(@"#333333");
        _leftTitleLabel.font = FONTSIZEBOLD(16);
        
    }
    return _leftTitleLabel;
}

- (UILabel *)leftTipsLabel {
    
    if (!_leftTipsLabel) {
        
        _leftTipsLabel = [[UILabel alloc] init];
        _leftTipsLabel.textColor = UIColorMakeWithHex(@"#CCCCCC");
        _leftTipsLabel.font = UIFontMake(10);
        _leftTipsLabel.text = @"如3000元/吨或3000元/件或3000元/米；";
        
    }
    return _leftTipsLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorMakeWithHex(@"#F2F2F2");
    }
    return _lineView;
}



@end
