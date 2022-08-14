//
//  CommoditiesCollectionViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/5.
//

#import "CommoditiesCollectionViewCell.h"

@implementation CommoditiesCollectionViewCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self showUI];
    }
    return self;
}

- (void)showUI {
    [self.contentView addSubview:self.bigView];
    [self.bigView addSubview:self.logoImageView];
    [self.bigView addSubview:self.proNameLabel];
    [self.bigView addSubview:self.deleteButton];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(kScale_W(197));
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigView.mas_top).offset(0);
        make.left.equalTo(self.bigView.mas_left).offset(0);
        make.height.mas_equalTo(kScale_W(168));
        make.width.mas_equalTo(kScale_W(168));
    }];
        
    [self.proNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(16.5f);
        make.left.equalTo(self.bigView.mas_left).offset(0);
        make.width.mas_equalTo(kScale_W(168));
        make.height.mas_equalTo(kScale_W(12.5f));
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigView.mas_top).offset(0);
        make.right.equalTo(self.bigView.mas_right).offset(0);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];

}
- (UIView *)bigView {
    
    if (!_bigView) {
        
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = KWhiteColor;
    }
    return _bigView;
}

- (UIImageView *)logoImageView {
    
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.layer.cornerRadius = 6;

    }
    return _logoImageView;
}


- (UILabel *)proNameLabel {
    
    if (!_proNameLabel) {
        _proNameLabel = [[UILabel alloc] init];
        _proNameLabel.font = SYSTEMFONT(13);
        _proNameLabel.textAlignment = 1;
        _proNameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _proNameLabel;
}

- (UIButton *)deleteButton {
    
    if (!_deleteButton) {
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.hidden = YES;
        [_deleteButton setImage:[UIImage imageNamed:@"delete_liucheng"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(delteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _deleteButton;
}

- (void)delteButtonClick:(UIButton *)sender {
    
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end
