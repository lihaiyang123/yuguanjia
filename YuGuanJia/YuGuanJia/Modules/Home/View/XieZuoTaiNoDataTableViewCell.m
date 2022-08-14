//
//  XieZuoTaiNoDataTableViewCell.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/19.
//

#import "XieZuoTaiNoDataTableViewCell.h"

@implementation XieZuoTaiNoDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self showUIHUD];
    }
    return self;
}
- (void)showUIHUD {
    [self.contentView addSubview:self.bigLabel];
    [self.bigLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(290);
    }];
}

#pragma mark - 懒加载
- (UILabel *)bigLabel {
     
    if (!_bigLabel) {
        _bigLabel = [[UILabel alloc] init];
        _bigLabel.textColor = UIColorMakeWithHex(@"#999999");
        _bigLabel.font = UIFontMake(13);
        _bigLabel.textAlignment = 1;
        _bigLabel.text = @"暂无数据";
    }
    return _bigLabel;
}
@end
