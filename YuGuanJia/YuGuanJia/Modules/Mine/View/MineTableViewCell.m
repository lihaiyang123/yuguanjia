//
//  MineTableViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/6/30.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self showUIHUD];
    }
    return self;
}
- (void)showUIHUD {

    [self.contentView addSubview:self.leftLittleImageView];
    [self.contentView addSubview:self.midTitleLabel];
    [self.contentView addSubview:self.nextImageView];
    [self.contentView addSubview:self.underLineView];
        
    [self.leftLittleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(17.5f);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
        
    [self.midTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(1);
        make.left.equalTo(self.leftLittleImageView.mas_right).offset(13);
        make.height.mas_equalTo(54);
        make.width.mas_equalTo(80);
    }];
    
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20.5f);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(6.5f);
    }];
    
    [self.underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(kScreenWidth-34);
    }];
}

#pragma mark - 懒加载
- (UIImageView *)leftLittleImageView {
    
    if (!_leftLittleImageView) {
        _leftLittleImageView = [[UIImageView alloc] init];
        _leftLittleImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftLittleImageView;
}


- (UILabel *)midTitleLabel {
    
    if (!_midTitleLabel) {
        
        _midTitleLabel = [[UILabel alloc] init];
        _midTitleLabel.textColor = CBlackgColor;
        _midTitleLabel.font = SYSTEMFONT(15);
        _midTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _midTitleLabel;
}

- (UIImageView *)nextImageView {
    
    if (!_nextImageView) {
        
        _nextImageView = [[UIImageView alloc] init];
        _nextImageView.contentMode = UIViewContentModeScaleAspectFit;
        _nextImageView.image = [UIImage imageNamed:@"xiayiji"];
    }
    return _nextImageView;
}

- (UIView *)underLineView {
    
    if (!_underLineView) {
        
        _underLineView = [[UIView alloc] init];
        _underLineView.backgroundColor = UNDERLINECOLOR;
    }
    return _underLineView;
}

@end
