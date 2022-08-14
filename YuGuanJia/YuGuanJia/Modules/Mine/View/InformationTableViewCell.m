//
//  InformationTableViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/1.
//

#import "InformationTableViewCell.h"
@interface InformationTableViewCell () <YJYCustomTextViewDelegate>

@end

@implementation InformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self showUIHUD];
    }
    return self;
}
- (void)showUIHUD
{
    self.contentView.backgroundColor = KWhiteColor;
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.leftTipsLabel];
    [self.contentView addSubview:self.rightInputTF];
    [self.contentView addSubview:self.rightRenZhengLabel];
    [self.contentView addSubview:self.nextImageView];
    [self.contentView addSubview:self.underLineView];
        
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(12.5f);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
        
    [self.leftTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(12.5f);
        make.height.mas_equalTo(54);
        make.width.mas_equalTo(120);
    }];
    
    [self.rightInputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(0);
        make.left.equalTo(self.leftTipsLabel.mas_right).offset(15);
    }];
    
    [self.rightRenZhengLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.height.mas_equalTo(29);
        make.width.mas_equalTo(75);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20.5f);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(6.5f);
    }];
    
    [self.underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.equalTo(self.contentView.mas_left).offset(12.5f);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(kScreenWidth-25);
    }];
    
}

- (void)customTextViewDidChange:(YJYCustomTextView *)textView{
    if (self.textChangeBlock) {
        self.textChangeBlock(textView.text, self.cellIndexPath);
    }
}

- (UIImageView *)headImageView{
    
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = KBlueColor;
        _headImageView.contentMode = UIViewContentModeScaleAspectFit;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 20;
    }
    return _headImageView;
}


- (UILabel *)leftTipsLabel{
    
    if (!_leftTipsLabel) {
        
        _leftTipsLabel = [[UILabel alloc] init];
        _leftTipsLabel.textColor = CBlackgColor;
        _leftTipsLabel.font = SYSTEMFONT(16);
        _leftTipsLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _leftTipsLabel;
}

- (YJYCustomTextView *)rightInputTF {
    
    
    if (!_rightInputTF) {
        
        _rightInputTF = [[YJYCustomTextView alloc] init];
        _rightInputTF.font = SYSTEMFONT(16);
        _rightInputTF.textAlignment = NSTextAlignmentRight;
        _rightInputTF.backgroundColor = [UIColor clearColor];
        _rightInputTF.initiLine = 1;
        _rightInputTF.maxLine = 0;
        _rightInputTF.maxLength = 200;
        _rightInputTF.placeholderColor = UIColorFromRGB(0xbbbbbb);
        _rightInputTF.delegate = self;
        @weakify(self);
        _rightInputTF.textHeightChangeBlock = ^(CGFloat height) {
            @strongify(self);
            height += 8;
            height = height < 55 ? 55 : height;
            if (self.heightBlock) {
                self.heightBlock(height, self.cellIndexPath);
            }
        };
    }
    return _rightInputTF;
}

- (UILabel *)rightRenZhengLabel{
    
    if (!_rightRenZhengLabel) {
        
        _rightRenZhengLabel = [[UILabel alloc] init];
        _rightRenZhengLabel.textColor = KWhiteColor;
        _rightRenZhengLabel.backgroundColor = [UIColor colorWithHexString:@"#FFC600"];
        _rightRenZhengLabel.text = @"去认证";
        _rightRenZhengLabel.font = SYSTEMFONT(14);
        _rightRenZhengLabel.textAlignment = 1;
        _rightRenZhengLabel.layer.masksToBounds = YES;
        _rightRenZhengLabel.layer.cornerRadius = 14;
    }
    
    return _rightRenZhengLabel;
}


- (UIImageView *)nextImageView{
    
    if (!_nextImageView) {
        
        _nextImageView = [[UIImageView alloc] init];
        _nextImageView.contentMode = UIViewContentModeScaleAspectFit;
        _nextImageView.image = [UIImage imageNamed:@"xiayiji"];
    }
    
    return _nextImageView;
}

- (UIView *)underLineView{
    
    if (!_underLineView) {
        
        _underLineView = [[UIView alloc] init];
        _underLineView.backgroundColor = UNDERLINECOLOR;
    }
    
    return _underLineView;
}



@end
