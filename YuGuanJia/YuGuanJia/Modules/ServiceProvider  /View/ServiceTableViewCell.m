//
//  ServiceTableViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/2.
//

#import "ServiceTableViewCell.h"

@implementation ServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self showUIHUD];
    }
    return self;
}
- (void)showUIHUD {
    [self.contentView addSubview:self.leftHeadImageView];
    [self.contentView addSubview:self.companyTitleLabel];
    [self.contentView addSubview:self.firStatusLabel];
    [self.contentView addSubview:self.secStatusLabel];
    [self.contentView addSubview:self.isHeZuoLabel];
    [self.contentView addSubview:self.underLineView];
        
    [self.leftHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10.5f);
        make.left.equalTo(self.contentView.mas_left).offset(12.5f);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(45);
    }];
        
    [self.companyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.left.equalTo(self.leftHeadImageView.mas_right).offset(7);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(300);
    }];
    
    [self.firStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyTitleLabel.mas_bottom).offset(9);
        make.left.equalTo(self.leftHeadImageView.mas_right).offset(7);
        make.height.mas_equalTo(12.5f);
        make.width.mas_equalTo(30);
    }];
    
    [self.secStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyTitleLabel.mas_bottom).offset(9);
        make.left.equalTo(self.firStatusLabel.mas_right).offset(20);
        make.height.mas_equalTo(12.5f);
        make.width.mas_equalTo(30);
    }];
    
    [self.isHeZuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20.5f);
        make.right.equalTo(self.contentView.mas_right).offset(-12.5);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(50);
    }];
    
    [self.underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.equalTo(self.contentView.mas_left).offset(12.5f);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(kScreenWidth-25);
    }];
}

#pragma mark - 懒加载
- (UIImageView *)leftHeadImageView {
    
    if (!_leftHeadImageView) {
        _leftHeadImageView = [[UIImageView alloc] init];
        _leftHeadImageView.contentMode = UIViewContentModeScaleAspectFit;
        _leftHeadImageView.layer.masksToBounds = YES;
        _leftHeadImageView.layer.cornerRadius = 45/2.0;
    }
    return _leftHeadImageView;
}

- (UILabel *)companyTitleLabel {
    
    if (!_companyTitleLabel) {
        _companyTitleLabel = [[UILabel alloc] init];
        _companyTitleLabel.textColor = CBlackgColor;
        _companyTitleLabel.font = FONTSIZEBOLD(15);
        _companyTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _companyTitleLabel;
}

- (UILabel *)firStatusLabel {
    
    if (!_firStatusLabel) {
        _firStatusLabel = [[UILabel alloc] init];
        _firStatusLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _firStatusLabel.font = SYSTEMFONT(13);
        _firStatusLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _firStatusLabel;
}

- (UILabel *)secStatusLabel{
    
    if (!_secStatusLabel) {
        _secStatusLabel = [[UILabel alloc] init];
        _secStatusLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _secStatusLabel.font = SYSTEMFONT(13);
        _secStatusLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _secStatusLabel;
}

- (UILabel *)isHeZuoLabel{
    
    if (!_isHeZuoLabel) {
        _isHeZuoLabel = [[UILabel alloc] init];
        _isHeZuoLabel.text = @"已合作";
        _isHeZuoLabel.textColor = CNavBgColor;
        _isHeZuoLabel.font = SYSTEMFONT(13);
        _isHeZuoLabel.textAlignment = 1;
        _isHeZuoLabel.backgroundColor = [UIColor colorWithHexString:@"#E5EEFF"];
        _isHeZuoLabel.layer.cornerRadius = 5;
    }
    return _isHeZuoLabel;
}


- (UIView *)underLineView{
    
    if (!_underLineView) {
        _underLineView = [[UIView alloc] init];
        _underLineView.backgroundColor = UNDERLINECOLOR;
    }
    return _underLineView;
}

@end
