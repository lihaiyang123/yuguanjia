//
//  QiYeCollectionViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/2.
//

#import "QiYeCollectionViewCell.h"

@implementation QiYeCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self showUI];
    }
    return self;
}

- (void)showUI {
    self.contentView.backgroundColor = KWhiteColor;
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.nameLabel];
    
    self.logoImageView.frame = CGRectMake(0, 0, kScale_W(168), kScale_W(168));
    self.nameLabel.frame = CGRectMake(0, _logoImageView.bottom+kScale_W(16.5f), kScale_W(168), kScale_W(12.5f));
}

- (UIImageView *)logoImageView {
    
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.layer.cornerRadius = 5;
    }
    return _logoImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"物流配送";
        _nameLabel.font = SYSTEMFONT(13);
        _nameLabel.textAlignment = 1;
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _nameLabel;
}
@end
