//
//  XieZuoDTTableViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/25.
//

#import "XieZuoDTTableViewCell.h"
#import "CooperationModel.h"

@implementation XieZuoDTTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self showUIHUD];
    }
    return self;
}
- (void)showUIHUD {
    [self.contentView addSubview:self.bigView];
    [self.bigView addSubview:self.leftGreenView];
    [self.bigView addSubview:self.docTitleLabel];
    [self.bigView addSubview:self.timeLabel];
    [self.bigView addSubview:self.seeDetailLabel];
    [self.bigView addSubview:self.underLineView];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(58);
    }];
    
    [self.leftGreenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigView.mas_top).offset(17);
        make.left.equalTo(self.bigView.mas_left).offset(12);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(5);
    }];
        
    [self.docTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigView.mas_top).offset(12);
        make.right.equalTo(self.bigView.mas_right).offset(-86);
        make.left.equalTo(self.leftGreenView.mas_left).offset(6);
        make.height.mas_equalTo(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.docTitleLabel.mas_bottom).offset(9);
        make.left.equalTo(self.leftGreenView.mas_left).offset(6);
        make.height.mas_equalTo(10.5f);
        make.width.mas_equalTo(130);
    }];

    [self.seeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigView.mas_top).offset(16);
        make.right.equalTo(self.bigView.mas_right).offset(-12.5f);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(61);
    }];
    
    [self.underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bigView.mas_bottom).offset(-1);
        make.left.equalTo(self.bigView.mas_left).offset(0);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(kScreenWidth);
    }];
}
- (void)setUpCooperationModel:(CooperationModel *)model {
    
    self.docTitleLabel.text = model.message;
    self.timeLabel.text = model.updateTime;
}

#pragma mark - 懒加载
- (UIView *)bigView {
    
    if (!_bigView) {
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = KWhiteColor;
    }
    return _bigView;
}

- (UIView *)leftGreenView {
    
    if (!_leftGreenView) {
        _leftGreenView = [[UIView alloc] init];
        _leftGreenView.backgroundColor = [UIColor colorWithHexString:@"#00C091"];
        _leftGreenView.layer.masksToBounds = YES;
        _leftGreenView.layer.cornerRadius = 2.5f;
    }
    return _leftGreenView;
}

- (UILabel *)docTitleLabel {
    
    if (!_docTitleLabel) {
        
        _docTitleLabel = [[UILabel alloc] init];
        _docTitleLabel.textColor = CBlackgColor;
        _docTitleLabel.font = FONTSIZEBOLD(15);
        _docTitleLabel.textAlignment = NSTextAlignmentLeft;
        _docTitleLabel.text = @"上海鞍宝..确认了9999921041302单据";
    }
    return _docTitleLabel;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _timeLabel.font = SYSTEMFONT(11);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.text = @"2021年3月4日19:54";
    }
    
    return _timeLabel;
}

- (UILabel *)seeDetailLabel {
    
    if (!_seeDetailLabel) {
        _seeDetailLabel = [[UILabel alloc] init];
        _seeDetailLabel.textColor = KWhiteColor;
        _seeDetailLabel.backgroundColor = CNavBgColor;
        _seeDetailLabel.font = SYSTEMFONT(12);
        _seeDetailLabel.textAlignment = 1;
        _seeDetailLabel.text = @"查看";
        _seeDetailLabel.layer.masksToBounds = YES;
        _seeDetailLabel.layer.cornerRadius = 13;
    }
    return _seeDetailLabel;
}

- (UIView *)underLineView {
    
    if (!_underLineView) {
        _underLineView = [[UIView alloc] init];
        _underLineView.backgroundColor = UNDERLINECOLOR;
    }
    return _underLineView;
}

@end
