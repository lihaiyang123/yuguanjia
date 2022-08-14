//
//  ServiceTopTableViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/2.
//

#import "ServiceTopTableViewCell.h"

@implementation ServiceTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self showUIHUD];
    }
    return self;
}
- (void)showUIHUD {
    [self.contentView addSubview:self.leftHeadImageView];
    [self.contentView addSubview:self.companyTitleLabel];
        
    [self.leftHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10.5f);
        make.left.equalTo(self.contentView.mas_left).offset(12.5f);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(45);
    }];
        
    [self.companyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.leftHeadImageView.mas_right).offset(7);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(300);
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
@end
