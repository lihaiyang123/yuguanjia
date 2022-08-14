//
//  AddCommoditiesCollectionViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/20.
//

#import "AddCommoditiesCollectionViewCell.h"

@implementation AddCommoditiesCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self showUI];
    }
    return self;
}

- (void)showUI {
    
    [self.contentView addSubview:self.bigView];
    [self.bigView addSubview:self.addImageView];
    [self.bigView addSubview:self.tipsLabel];
    
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(kScale_W(168));
    }];
    
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigView.mas_top).offset(kScale_W(29.5));
        make.left.equalTo(self.bigView.mas_left).offset(kScale_W(55.5));
        make.height.mas_equalTo(kScale_W(60));
        make.width.mas_equalTo(kScale_W(60));
    }];
        
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addImageView.mas_bottom).offset(kScale_W(29));
        make.left.equalTo(self.bigView.mas_left).offset(0);
        make.width.mas_equalTo(kScale_W(168));
        make.height.mas_equalTo(kScale_W(12.5f));
    }];
    

}
- (UIView *)bigView {
    
    if (!_bigView) {
        
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = UIColorMakeWithHex(@"#F7F7F7");
    }
    return _bigView;
}

- (UIImageView *)addImageView {
    
    if (!_addImageView) {
        _addImageView = [[UIImageView alloc] init];
        _addImageView.image = [UIImage imageNamed:@"bigAdd"];
        _addImageView.contentMode = UIViewContentModeScaleAspectFit;

    }
    return _addImageView;
}


- (UILabel *)tipsLabel {
    
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"添加商品";
        _tipsLabel.font = SYSTEMFONT(13);
        _tipsLabel.textAlignment = 1;
        _tipsLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _tipsLabel;
}

@end
